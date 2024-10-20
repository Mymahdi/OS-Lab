
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
80100028:	bc e0 b5 10 80       	mov    $0x8010b5e0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 90 33 10 80       	mov    $0x80103390,%eax
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
80100048:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 40 74 10 80       	push   $0x80107440
80100055:	68 e0 b5 10 80       	push   $0x8010b5e0
8010005a:	e8 d1 46 00 00       	call   80104730 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 dc fc 10 80       	mov    $0x8010fcdc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
8010006e:	fc 10 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
80100078:	fc 10 80 
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
8010008b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 74 10 80       	push   $0x80107447
80100097:	50                   	push   %eax
80100098:	e8 53 45 00 00       	call   801045f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 80 fa 10 80    	cmp    $0x8010fa80,%ebx
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
801000e3:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e8:	e8 c3 47 00 00       	call   801048b0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
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
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
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
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 09 48 00 00       	call   80104970 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 44 00 00       	call   80104630 <acquiresleep>
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
8010018c:	e8 3f 24 00 00       	call   801025d0 <iderw>
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
801001a3:	68 4e 74 10 80       	push   $0x8010744e
801001a8:	e8 63 04 00 00       	call   80100610 <panic>
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
801001c2:	e8 09 45 00 00       	call   801046d0 <holdingsleep>
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
801001d8:	e9 f3 23 00 00       	jmp    801025d0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 5f 74 10 80       	push   $0x8010745f
801001e5:	e8 26 04 00 00       	call   80100610 <panic>
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
80100203:	e8 c8 44 00 00       	call   801046d0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 78 44 00 00       	call   80104690 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010021f:	e8 8c 46 00 00       	call   801048b0 <acquire>
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
80100246:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 fb 46 00 00       	jmp    80104970 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 66 74 10 80       	push   $0x80107466
8010027d:	e8 8e 03 00 00       	call   80100610 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  release(&cons.lock);
}

int
consoleread(struct inode *ip, char *dst, int n)
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
801002a5:	e8 e6 18 00 00       	call   80101b90 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801002b1:	e8 fa 45 00 00       	call   801048b0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 f4 ff 10 80       	mov    0x8010fff4,%eax
801002cb:	3b 05 f8 ff 10 80    	cmp    0x8010fff8,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 40 a5 10 80       	push   $0x8010a540
801002e0:	68 f4 ff 10 80       	push   $0x8010fff4
801002e5:	e8 86 3f 00 00       	call   80104270 <sleep>
    while(input.r == input.w){
801002ea:	a1 f4 ff 10 80       	mov    0x8010fff4,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 f8 ff 10 80    	cmp    0x8010fff8,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 b1 39 00 00       	call   80103cb0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 40 a5 10 80       	push   $0x8010a540
8010030e:	e8 5d 46 00 00       	call   80104970 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 94 17 00 00       	call   80101ab0 <ilock>
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
80100333:	89 15 f4 ff 10 80    	mov    %edx,0x8010fff4
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 74 ff 10 80 	movsbl -0x7fef008c(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 40 a5 10 80       	push   $0x8010a540
80100365:	e8 06 46 00 00       	call   80104970 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 3d 17 00 00       	call   80101ab0 <ilock>
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
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 f4 ff 10 80       	mov    %eax,0x8010fff4
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <consputc.part.0>:
consputc(int c)
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	57                   	push   %edi
80100394:	56                   	push   %esi
80100395:	53                   	push   %ebx
80100396:	89 c3                	mov    %eax,%ebx
80100398:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010039b:	3d 00 01 00 00       	cmp    $0x100,%eax
801003a0:	0f 84 2a 01 00 00    	je     801004d0 <consputc.part.0+0x140>
    uartputc(c);
801003a6:	83 ec 0c             	sub    $0xc,%esp
801003a9:	50                   	push   %eax
801003aa:	e8 81 5c 00 00       	call   80106030 <uartputc>
801003af:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003b2:	bf d4 03 00 00       	mov    $0x3d4,%edi
801003b7:	b8 0e 00 00 00       	mov    $0xe,%eax
801003bc:	89 fa                	mov    %edi,%edx
801003be:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003bf:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801003c4:	89 ca                	mov    %ecx,%edx
801003c6:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003c7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003ca:	89 fa                	mov    %edi,%edx
801003cc:	c1 e0 08             	shl    $0x8,%eax
801003cf:	89 c6                	mov    %eax,%esi
801003d1:	b8 0f 00 00 00       	mov    $0xf,%eax
801003d6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003d7:	89 ca                	mov    %ecx,%edx
801003d9:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
801003da:	0f b6 c0             	movzbl %al,%eax
801003dd:	09 f0                	or     %esi,%eax
  if(c == '\n')
801003df:	83 fb 0a             	cmp    $0xa,%ebx
801003e2:	0f 84 80 00 00 00    	je     80100468 <consputc.part.0+0xd8>
  else if(c == BACKSPACE){
801003e8:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
801003ee:	74 60                	je     80100450 <consputc.part.0+0xc0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801003f0:	0f b6 db             	movzbl %bl,%ebx
801003f3:	8d 70 01             	lea    0x1(%eax),%esi
801003f6:	80 cf 07             	or     $0x7,%bh
801003f9:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100400:	80 
  if((pos/80) >= 24){  // Scroll up.
80100401:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100407:	7f 7a                	jg     80100483 <consputc.part.0+0xf3>
80100409:	89 f0                	mov    %esi,%eax
8010040b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
80100412:	88 45 e7             	mov    %al,-0x19(%ebp)
80100415:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100418:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010041d:	b8 0e 00 00 00       	mov    $0xe,%eax
80100422:	89 da                	mov    %ebx,%edx
80100424:	ee                   	out    %al,(%dx)
80100425:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010042a:	89 f8                	mov    %edi,%eax
8010042c:	89 ca                	mov    %ecx,%edx
8010042e:	ee                   	out    %al,(%dx)
8010042f:	b8 0f 00 00 00       	mov    $0xf,%eax
80100434:	89 da                	mov    %ebx,%edx
80100436:	ee                   	out    %al,(%dx)
80100437:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010043b:	89 ca                	mov    %ecx,%edx
8010043d:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010043e:	b8 20 07 00 00       	mov    $0x720,%eax
80100443:	66 89 06             	mov    %ax,(%esi)
}
80100446:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100449:	5b                   	pop    %ebx
8010044a:	5e                   	pop    %esi
8010044b:	5f                   	pop    %edi
8010044c:	5d                   	pop    %ebp
8010044d:	c3                   	ret    
8010044e:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
80100450:	8d 70 ff             	lea    -0x1(%eax),%esi
80100453:	85 c0                	test   %eax,%eax
80100455:	75 aa                	jne    80100401 <consputc.part.0+0x71>
80100457:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
8010045b:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100460:	31 ff                	xor    %edi,%edi
80100462:	eb b4                	jmp    80100418 <consputc.part.0+0x88>
80100464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
80100468:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010046d:	f7 e2                	mul    %edx
8010046f:	c1 ea 06             	shr    $0x6,%edx
80100472:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100475:	c1 e0 04             	shl    $0x4,%eax
80100478:	8d 70 50             	lea    0x50(%eax),%esi
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	7e 86                	jle    80100409 <consputc.part.0+0x79>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100483:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100486:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100489:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100490:	68 60 0e 00 00       	push   $0xe60
80100495:	0f b6 ff             	movzbl %bh,%edi
80100498:	68 a0 80 0b 80       	push   $0x800b80a0
8010049d:	68 00 80 0b 80       	push   $0x800b8000
801004a2:	e8 b9 45 00 00       	call   80104a60 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004a7:	b8 80 07 00 00       	mov    $0x780,%eax
801004ac:	83 c4 0c             	add    $0xc,%esp
801004af:	29 d8                	sub    %ebx,%eax
801004b1:	01 c0                	add    %eax,%eax
801004b3:	50                   	push   %eax
801004b4:	6a 00                	push   $0x0
801004b6:	56                   	push   %esi
801004b7:	e8 04 45 00 00       	call   801049c0 <memset>
801004bc:	88 5d e7             	mov    %bl,-0x19(%ebp)
801004bf:	83 c4 10             	add    $0x10,%esp
801004c2:	e9 51 ff ff ff       	jmp    80100418 <consputc.part.0+0x88>
801004c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801004ce:	66 90                	xchg   %ax,%ax
    uartputc('\b'); 
801004d0:	83 ec 0c             	sub    $0xc,%esp
801004d3:	6a 08                	push   $0x8
801004d5:	e8 56 5b 00 00       	call   80106030 <uartputc>
    uartputc(' '); 
801004da:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004e1:	e8 4a 5b 00 00       	call   80106030 <uartputc>
    uartputc('\b');
801004e6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004ed:	e8 3e 5b 00 00       	call   80106030 <uartputc>
801004f2:	83 c4 10             	add    $0x10,%esp
801004f5:	e9 b8 fe ff ff       	jmp    801003b2 <consputc.part.0+0x22>
801004fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100500 <printint>:
{
80100500:	55                   	push   %ebp
80100501:	89 e5                	mov    %esp,%ebp
80100503:	57                   	push   %edi
80100504:	56                   	push   %esi
80100505:	53                   	push   %ebx
80100506:	83 ec 2c             	sub    $0x2c,%esp
80100509:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010050c:	85 c9                	test   %ecx,%ecx
8010050e:	74 04                	je     80100514 <printint+0x14>
80100510:	85 c0                	test   %eax,%eax
80100512:	78 6d                	js     80100581 <printint+0x81>
    x = xx;
80100514:	89 c1                	mov    %eax,%ecx
80100516:	31 f6                	xor    %esi,%esi
  i = 0;
80100518:	89 75 cc             	mov    %esi,-0x34(%ebp)
8010051b:	31 db                	xor    %ebx,%ebx
8010051d:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
80100520:	89 c8                	mov    %ecx,%eax
80100522:	31 d2                	xor    %edx,%edx
80100524:	89 ce                	mov    %ecx,%esi
80100526:	f7 75 d4             	divl   -0x2c(%ebp)
80100529:	0f b6 92 a0 74 10 80 	movzbl -0x7fef8b60(%edx),%edx
80100530:	89 45 d0             	mov    %eax,-0x30(%ebp)
80100533:	89 d8                	mov    %ebx,%eax
80100535:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
80100538:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010053b:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
8010053e:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
80100541:	8b 75 d4             	mov    -0x2c(%ebp),%esi
80100544:	39 75 d0             	cmp    %esi,-0x30(%ebp)
80100547:	73 d7                	jae    80100520 <printint+0x20>
80100549:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
8010054c:	85 f6                	test   %esi,%esi
8010054e:	74 0c                	je     8010055c <printint+0x5c>
    buf[i++] = '-';
80100550:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100555:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
80100557:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010055c:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100560:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100563:	8b 15 78 a5 10 80    	mov    0x8010a578,%edx
80100569:	85 d2                	test   %edx,%edx
8010056b:	74 03                	je     80100570 <printint+0x70>
}

static inline void
cli(void)
{
  asm volatile("cli");
8010056d:	fa                   	cli    
    for(;;)
8010056e:	eb fe                	jmp    8010056e <printint+0x6e>
80100570:	e8 1b fe ff ff       	call   80100390 <consputc.part.0>
  while(--i >= 0)
80100575:	39 fb                	cmp    %edi,%ebx
80100577:	74 10                	je     80100589 <printint+0x89>
80100579:	0f be 03             	movsbl (%ebx),%eax
8010057c:	83 eb 01             	sub    $0x1,%ebx
8010057f:	eb e2                	jmp    80100563 <printint+0x63>
    x = -xx;
80100581:	f7 d8                	neg    %eax
80100583:	89 ce                	mov    %ecx,%esi
80100585:	89 c1                	mov    %eax,%ecx
80100587:	eb 8f                	jmp    80100518 <printint+0x18>
}
80100589:	83 c4 2c             	add    $0x2c,%esp
8010058c:	5b                   	pop    %ebx
8010058d:	5e                   	pop    %esi
8010058e:	5f                   	pop    %edi
8010058f:	5d                   	pop    %ebp
80100590:	c3                   	ret    
80100591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059f:	90                   	nop

801005a0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005a0:	f3 0f 1e fb          	endbr32 
801005a4:	55                   	push   %ebp
801005a5:	89 e5                	mov    %esp,%ebp
801005a7:	57                   	push   %edi
801005a8:	56                   	push   %esi
801005a9:	53                   	push   %ebx
801005aa:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
801005ad:	ff 75 08             	pushl  0x8(%ebp)
{
801005b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
801005b3:	e8 d8 15 00 00       	call   80101b90 <iunlock>
  acquire(&cons.lock);
801005b8:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801005bf:	e8 ec 42 00 00       	call   801048b0 <acquire>
  for(i = 0; i < n; i++)
801005c4:	83 c4 10             	add    $0x10,%esp
801005c7:	85 db                	test   %ebx,%ebx
801005c9:	7e 24                	jle    801005ef <consolewrite+0x4f>
801005cb:	8b 7d 0c             	mov    0xc(%ebp),%edi
801005ce:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
801005d1:	8b 15 78 a5 10 80    	mov    0x8010a578,%edx
801005d7:	85 d2                	test   %edx,%edx
801005d9:	74 05                	je     801005e0 <consolewrite+0x40>
801005db:	fa                   	cli    
    for(;;)
801005dc:	eb fe                	jmp    801005dc <consolewrite+0x3c>
801005de:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
801005e0:	0f b6 07             	movzbl (%edi),%eax
801005e3:	83 c7 01             	add    $0x1,%edi
801005e6:	e8 a5 fd ff ff       	call   80100390 <consputc.part.0>
  for(i = 0; i < n; i++)
801005eb:	39 fe                	cmp    %edi,%esi
801005ed:	75 e2                	jne    801005d1 <consolewrite+0x31>
  release(&cons.lock);
801005ef:	83 ec 0c             	sub    $0xc,%esp
801005f2:	68 40 a5 10 80       	push   $0x8010a540
801005f7:	e8 74 43 00 00       	call   80104970 <release>
  ilock(ip);
801005fc:	58                   	pop    %eax
801005fd:	ff 75 08             	pushl  0x8(%ebp)
80100600:	e8 ab 14 00 00       	call   80101ab0 <ilock>

  return n;
}
80100605:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100608:	89 d8                	mov    %ebx,%eax
8010060a:	5b                   	pop    %ebx
8010060b:	5e                   	pop    %esi
8010060c:	5f                   	pop    %edi
8010060d:	5d                   	pop    %ebp
8010060e:	c3                   	ret    
8010060f:	90                   	nop

80100610 <panic>:
{
80100610:	f3 0f 1e fb          	endbr32 
80100614:	55                   	push   %ebp
80100615:	89 e5                	mov    %esp,%ebp
80100617:	56                   	push   %esi
80100618:	53                   	push   %ebx
80100619:	83 ec 30             	sub    $0x30,%esp
8010061c:	fa                   	cli    
  cons.locking = 0;
8010061d:	c7 05 74 a5 10 80 00 	movl   $0x0,0x8010a574
80100624:	00 00 00 
  getcallerpcs(&s, pcs);
80100627:	8d 5d d0             	lea    -0x30(%ebp),%ebx
8010062a:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
8010062d:	e8 be 25 00 00       	call   80102bf0 <lapicid>
80100632:	83 ec 08             	sub    $0x8,%esp
80100635:	50                   	push   %eax
80100636:	68 6d 74 10 80       	push   $0x8010746d
8010063b:	e8 50 00 00 00       	call   80100690 <cprintf>
  cprintf(s);
80100640:	58                   	pop    %eax
80100641:	ff 75 08             	pushl  0x8(%ebp)
80100644:	e8 47 00 00 00       	call   80100690 <cprintf>
  cprintf("\n");
80100649:	c7 04 24 97 7d 10 80 	movl   $0x80107d97,(%esp)
80100650:	e8 3b 00 00 00       	call   80100690 <cprintf>
  getcallerpcs(&s, pcs);
80100655:	8d 45 08             	lea    0x8(%ebp),%eax
80100658:	5a                   	pop    %edx
80100659:	59                   	pop    %ecx
8010065a:	53                   	push   %ebx
8010065b:	50                   	push   %eax
8010065c:	e8 ef 40 00 00       	call   80104750 <getcallerpcs>
  for(i=0; i<10; i++)
80100661:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100664:	83 ec 08             	sub    $0x8,%esp
80100667:	ff 33                	pushl  (%ebx)
80100669:	83 c3 04             	add    $0x4,%ebx
8010066c:	68 81 74 10 80       	push   $0x80107481
80100671:	e8 1a 00 00 00       	call   80100690 <cprintf>
  for(i=0; i<10; i++)
80100676:	83 c4 10             	add    $0x10,%esp
80100679:	39 f3                	cmp    %esi,%ebx
8010067b:	75 e7                	jne    80100664 <panic+0x54>
  panicked = 1; // freeze other CPU
8010067d:	c7 05 78 a5 10 80 01 	movl   $0x1,0x8010a578
80100684:	00 00 00 
  for(;;)
80100687:	eb fe                	jmp    80100687 <panic+0x77>
80100689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100690 <cprintf>:
{
80100690:	f3 0f 1e fb          	endbr32 
80100694:	55                   	push   %ebp
80100695:	89 e5                	mov    %esp,%ebp
80100697:	57                   	push   %edi
80100698:	56                   	push   %esi
80100699:	53                   	push   %ebx
8010069a:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
8010069d:	a1 74 a5 10 80       	mov    0x8010a574,%eax
801006a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006a5:	85 c0                	test   %eax,%eax
801006a7:	0f 85 e8 00 00 00    	jne    80100795 <cprintf+0x105>
  if (fmt == 0)
801006ad:	8b 45 08             	mov    0x8(%ebp),%eax
801006b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b3:	85 c0                	test   %eax,%eax
801006b5:	0f 84 5a 01 00 00    	je     80100815 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006bb:	0f b6 00             	movzbl (%eax),%eax
801006be:	85 c0                	test   %eax,%eax
801006c0:	74 36                	je     801006f8 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006c2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006c7:	83 f8 25             	cmp    $0x25,%eax
801006ca:	74 44                	je     80100710 <cprintf+0x80>
  if(panicked){
801006cc:	8b 0d 78 a5 10 80    	mov    0x8010a578,%ecx
801006d2:	85 c9                	test   %ecx,%ecx
801006d4:	74 0f                	je     801006e5 <cprintf+0x55>
801006d6:	fa                   	cli    
    for(;;)
801006d7:	eb fe                	jmp    801006d7 <cprintf+0x47>
801006d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006e0:	b8 25 00 00 00       	mov    $0x25,%eax
801006e5:	e8 a6 fc ff ff       	call   80100390 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006ed:	83 c6 01             	add    $0x1,%esi
801006f0:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
801006f4:	85 c0                	test   %eax,%eax
801006f6:	75 cf                	jne    801006c7 <cprintf+0x37>
  if(locking)
801006f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006fb:	85 c0                	test   %eax,%eax
801006fd:	0f 85 fd 00 00 00    	jne    80100800 <cprintf+0x170>
}
80100703:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100706:	5b                   	pop    %ebx
80100707:	5e                   	pop    %esi
80100708:	5f                   	pop    %edi
80100709:	5d                   	pop    %ebp
8010070a:	c3                   	ret    
8010070b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010070f:	90                   	nop
    c = fmt[++i] & 0xff;
80100710:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100713:	83 c6 01             	add    $0x1,%esi
80100716:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010071a:	85 ff                	test   %edi,%edi
8010071c:	74 da                	je     801006f8 <cprintf+0x68>
    switch(c){
8010071e:	83 ff 70             	cmp    $0x70,%edi
80100721:	74 5a                	je     8010077d <cprintf+0xed>
80100723:	7f 2a                	jg     8010074f <cprintf+0xbf>
80100725:	83 ff 25             	cmp    $0x25,%edi
80100728:	0f 84 92 00 00 00    	je     801007c0 <cprintf+0x130>
8010072e:	83 ff 64             	cmp    $0x64,%edi
80100731:	0f 85 a1 00 00 00    	jne    801007d8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100737:	8b 03                	mov    (%ebx),%eax
80100739:	8d 7b 04             	lea    0x4(%ebx),%edi
8010073c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100741:	ba 0a 00 00 00       	mov    $0xa,%edx
80100746:	89 fb                	mov    %edi,%ebx
80100748:	e8 b3 fd ff ff       	call   80100500 <printint>
      break;
8010074d:	eb 9b                	jmp    801006ea <cprintf+0x5a>
    switch(c){
8010074f:	83 ff 73             	cmp    $0x73,%edi
80100752:	75 24                	jne    80100778 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100754:	8d 7b 04             	lea    0x4(%ebx),%edi
80100757:	8b 1b                	mov    (%ebx),%ebx
80100759:	85 db                	test   %ebx,%ebx
8010075b:	75 55                	jne    801007b2 <cprintf+0x122>
        s = "(null)";
8010075d:	bb 85 74 10 80       	mov    $0x80107485,%ebx
      for(; *s; s++)
80100762:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100767:	8b 15 78 a5 10 80    	mov    0x8010a578,%edx
8010076d:	85 d2                	test   %edx,%edx
8010076f:	74 39                	je     801007aa <cprintf+0x11a>
80100771:	fa                   	cli    
    for(;;)
80100772:	eb fe                	jmp    80100772 <cprintf+0xe2>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 ff 78             	cmp    $0x78,%edi
8010077b:	75 5b                	jne    801007d8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010077d:	8b 03                	mov    (%ebx),%eax
8010077f:	8d 7b 04             	lea    0x4(%ebx),%edi
80100782:	31 c9                	xor    %ecx,%ecx
80100784:	ba 10 00 00 00       	mov    $0x10,%edx
80100789:	89 fb                	mov    %edi,%ebx
8010078b:	e8 70 fd ff ff       	call   80100500 <printint>
      break;
80100790:	e9 55 ff ff ff       	jmp    801006ea <cprintf+0x5a>
    acquire(&cons.lock);
80100795:	83 ec 0c             	sub    $0xc,%esp
80100798:	68 40 a5 10 80       	push   $0x8010a540
8010079d:	e8 0e 41 00 00       	call   801048b0 <acquire>
801007a2:	83 c4 10             	add    $0x10,%esp
801007a5:	e9 03 ff ff ff       	jmp    801006ad <cprintf+0x1d>
801007aa:	e8 e1 fb ff ff       	call   80100390 <consputc.part.0>
      for(; *s; s++)
801007af:	83 c3 01             	add    $0x1,%ebx
801007b2:	0f be 03             	movsbl (%ebx),%eax
801007b5:	84 c0                	test   %al,%al
801007b7:	75 ae                	jne    80100767 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007b9:	89 fb                	mov    %edi,%ebx
801007bb:	e9 2a ff ff ff       	jmp    801006ea <cprintf+0x5a>
  if(panicked){
801007c0:	8b 3d 78 a5 10 80    	mov    0x8010a578,%edi
801007c6:	85 ff                	test   %edi,%edi
801007c8:	0f 84 12 ff ff ff    	je     801006e0 <cprintf+0x50>
801007ce:	fa                   	cli    
    for(;;)
801007cf:	eb fe                	jmp    801007cf <cprintf+0x13f>
801007d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007d8:	8b 0d 78 a5 10 80    	mov    0x8010a578,%ecx
801007de:	85 c9                	test   %ecx,%ecx
801007e0:	74 06                	je     801007e8 <cprintf+0x158>
801007e2:	fa                   	cli    
    for(;;)
801007e3:	eb fe                	jmp    801007e3 <cprintf+0x153>
801007e5:	8d 76 00             	lea    0x0(%esi),%esi
801007e8:	b8 25 00 00 00       	mov    $0x25,%eax
801007ed:	e8 9e fb ff ff       	call   80100390 <consputc.part.0>
  if(panicked){
801007f2:	8b 15 78 a5 10 80    	mov    0x8010a578,%edx
801007f8:	85 d2                	test   %edx,%edx
801007fa:	74 2c                	je     80100828 <cprintf+0x198>
801007fc:	fa                   	cli    
    for(;;)
801007fd:	eb fe                	jmp    801007fd <cprintf+0x16d>
801007ff:	90                   	nop
    release(&cons.lock);
80100800:	83 ec 0c             	sub    $0xc,%esp
80100803:	68 40 a5 10 80       	push   $0x8010a540
80100808:	e8 63 41 00 00       	call   80104970 <release>
8010080d:	83 c4 10             	add    $0x10,%esp
}
80100810:	e9 ee fe ff ff       	jmp    80100703 <cprintf+0x73>
    panic("null fmt");
80100815:	83 ec 0c             	sub    $0xc,%esp
80100818:	68 8c 74 10 80       	push   $0x8010748c
8010081d:	e8 ee fd ff ff       	call   80100610 <panic>
80100822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100828:	89 f8                	mov    %edi,%eax
8010082a:	e8 61 fb ff ff       	call   80100390 <consputc.part.0>
8010082f:	e9 b6 fe ff ff       	jmp    801006ea <cprintf+0x5a>
80100834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010083b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010083f:	90                   	nop

80100840 <vga_move_back_cursor>:
void vga_move_back_cursor(){
80100840:	f3 0f 1e fb          	endbr32 
80100844:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100845:	b8 0e 00 00 00       	mov    $0xe,%eax
8010084a:	89 e5                	mov    %esp,%ebp
8010084c:	57                   	push   %edi
8010084d:	56                   	push   %esi
8010084e:	be d4 03 00 00       	mov    $0x3d4,%esi
80100853:	53                   	push   %ebx
80100854:	89 f2                	mov    %esi,%edx
80100856:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100857:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010085c:	89 da                	mov    %ebx,%edx
8010085e:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010085f:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT+1) << 8;
80100864:	0f b6 c8             	movzbl %al,%ecx
80100867:	89 f2                	mov    %esi,%edx
80100869:	c1 e1 08             	shl    $0x8,%ecx
8010086c:	89 f8                	mov    %edi,%eax
8010086e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010086f:	89 da                	mov    %ebx,%edx
80100871:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100872:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100875:	89 f2                	mov    %esi,%edx
80100877:	09 c1                	or     %eax,%ecx
80100879:	89 f8                	mov    %edi,%eax
  pos--;
8010087b:	83 e9 01             	sub    $0x1,%ecx
8010087e:	ee                   	out    %al,(%dx)
8010087f:	89 c8                	mov    %ecx,%eax
80100881:	89 da                	mov    %ebx,%edx
80100883:	ee                   	out    %al,(%dx)
80100884:	b8 0e 00 00 00       	mov    $0xe,%eax
80100889:	89 f2                	mov    %esi,%edx
8010088b:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
8010088c:	89 c8                	mov    %ecx,%eax
8010088e:	89 da                	mov    %ebx,%edx
80100890:	c1 f8 08             	sar    $0x8,%eax
80100893:	ee                   	out    %al,(%dx)
}
80100894:	5b                   	pop    %ebx
80100895:	5e                   	pop    %esi
80100896:	5f                   	pop    %edi
80100897:	5d                   	pop    %ebp
80100898:	c3                   	ret    
80100899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801008a0 <vga_move_forward_cursor>:
void vga_move_forward_cursor(){
801008a0:	f3 0f 1e fb          	endbr32 
801008a4:	55                   	push   %ebp
801008a5:	b8 0e 00 00 00       	mov    $0xe,%eax
801008aa:	89 e5                	mov    %esp,%ebp
801008ac:	57                   	push   %edi
801008ad:	56                   	push   %esi
801008ae:	be d4 03 00 00       	mov    $0x3d4,%esi
801008b3:	53                   	push   %ebx
801008b4:	89 f2                	mov    %esi,%edx
801008b6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801008b7:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801008bc:	89 da                	mov    %ebx,%edx
801008be:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801008bf:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT+1) << 8;
801008c4:	0f b6 c8             	movzbl %al,%ecx
801008c7:	89 f2                	mov    %esi,%edx
801008c9:	c1 e1 08             	shl    $0x8,%ecx
801008cc:	89 f8                	mov    %edi,%eax
801008ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801008cf:	89 da                	mov    %ebx,%edx
801008d1:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
801008d2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801008d5:	89 f2                	mov    %esi,%edx
801008d7:	09 c1                	or     %eax,%ecx
801008d9:	89 f8                	mov    %edi,%eax
  pos++;
801008db:	83 c1 01             	add    $0x1,%ecx
801008de:	ee                   	out    %al,(%dx)
801008df:	89 c8                	mov    %ecx,%eax
801008e1:	89 da                	mov    %ebx,%edx
801008e3:	ee                   	out    %al,(%dx)
801008e4:	b8 0e 00 00 00       	mov    $0xe,%eax
801008e9:	89 f2                	mov    %esi,%edx
801008eb:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
801008ec:	89 c8                	mov    %ecx,%eax
801008ee:	89 da                	mov    %ebx,%edx
801008f0:	c1 f8 08             	sar    $0x8,%eax
801008f3:	ee                   	out    %al,(%dx)
}
801008f4:	5b                   	pop    %ebx
801008f5:	5e                   	pop    %esi
801008f6:	5f                   	pop    %edi
801008f7:	5d                   	pop    %ebp
801008f8:	c3                   	ret    
801008f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100900 <vga_insert_char>:
void vga_insert_char(int c, int back_counter){
80100900:	f3 0f 1e fb          	endbr32 
80100904:	55                   	push   %ebp
80100905:	b8 0e 00 00 00       	mov    $0xe,%eax
8010090a:	89 e5                	mov    %esp,%ebp
8010090c:	57                   	push   %edi
8010090d:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100912:	56                   	push   %esi
80100913:	89 fa                	mov    %edi,%edx
80100915:	53                   	push   %ebx
80100916:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100919:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010091a:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010091f:	89 ca                	mov    %ecx,%edx
80100921:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100922:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100925:	89 fa                	mov    %edi,%edx
80100927:	c1 e0 08             	shl    $0x8,%eax
8010092a:	89 c6                	mov    %eax,%esi
8010092c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100931:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100932:	89 ca                	mov    %ecx,%edx
80100934:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100935:	0f b6 c0             	movzbl %al,%eax
80100938:	09 f0                	or     %esi,%eax
  for(int i = pos + back_counter; i >= pos; i--){
8010093a:	8d 14 18             	lea    (%eax,%ebx,1),%edx
8010093d:	39 d0                	cmp    %edx,%eax
8010093f:	7f 1d                	jg     8010095e <vga_insert_char+0x5e>
80100941:	8d 94 12 00 80 0b 80 	lea    -0x7ff48000(%edx,%edx,1),%edx
80100948:	8d b4 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%esi
8010094f:	90                   	nop
    crt[i+1] = crt[i];
80100950:	0f b7 0a             	movzwl (%edx),%ecx
80100953:	83 ea 02             	sub    $0x2,%edx
80100956:	66 89 4a 04          	mov    %cx,0x4(%edx)
  for(int i = pos + back_counter; i >= pos; i--){
8010095a:	39 d6                	cmp    %edx,%esi
8010095c:	75 f2                	jne    80100950 <vga_insert_char+0x50>
  crt[pos] = (c&0xff) | 0x0700;  
8010095e:	0f b6 55 08          	movzbl 0x8(%ebp),%edx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100962:	bf d4 03 00 00       	mov    $0x3d4,%edi
  pos += 1;
80100967:	8d 48 01             	lea    0x1(%eax),%ecx
  crt[pos] = (c&0xff) | 0x0700;  
8010096a:	80 ce 07             	or     $0x7,%dh
8010096d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100974:	80 
80100975:	b8 0e 00 00 00       	mov    $0xe,%eax
8010097a:	89 fa                	mov    %edi,%edx
8010097c:	ee                   	out    %al,(%dx)
8010097d:	be d5 03 00 00       	mov    $0x3d5,%esi
  outb(CRTPORT+1, pos>>8);
80100982:	89 c8                	mov    %ecx,%eax
80100984:	c1 f8 08             	sar    $0x8,%eax
80100987:	89 f2                	mov    %esi,%edx
80100989:	ee                   	out    %al,(%dx)
8010098a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010098f:	89 fa                	mov    %edi,%edx
80100991:	ee                   	out    %al,(%dx)
80100992:	89 c8                	mov    %ecx,%eax
80100994:	89 f2                	mov    %esi,%edx
80100996:	ee                   	out    %al,(%dx)
  crt[pos+back_counter] = ' ' | 0x0700;
80100997:	b8 20 07 00 00       	mov    $0x720,%eax
8010099c:	01 cb                	add    %ecx,%ebx
8010099e:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801009a5:	80 
}
801009a6:	5b                   	pop    %ebx
801009a7:	5e                   	pop    %esi
801009a8:	5f                   	pop    %edi
801009a9:	5d                   	pop    %ebp
801009aa:	c3                   	ret    
801009ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009af:	90                   	nop

801009b0 <vga_remove_char>:
void vga_remove_char(){
801009b0:	f3 0f 1e fb          	endbr32 
801009b4:	55                   	push   %ebp
801009b5:	b8 0e 00 00 00       	mov    $0xe,%eax
801009ba:	89 e5                	mov    %esp,%ebp
801009bc:	57                   	push   %edi
801009bd:	56                   	push   %esi
801009be:	be d4 03 00 00       	mov    $0x3d4,%esi
801009c3:	53                   	push   %ebx
801009c4:	89 f2                	mov    %esi,%edx
801009c6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801009c7:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801009cc:	89 da                	mov    %ebx,%edx
801009ce:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801009cf:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT+1) << 8;
801009d4:	0f b6 c8             	movzbl %al,%ecx
801009d7:	89 f2                	mov    %esi,%edx
801009d9:	c1 e1 08             	shl    $0x8,%ecx
801009dc:	89 f8                	mov    %edi,%eax
801009de:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801009df:	89 da                	mov    %ebx,%edx
801009e1:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
801009e2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801009e5:	89 f2                	mov    %esi,%edx
801009e7:	09 c1                	or     %eax,%ecx
801009e9:	89 f8                	mov    %edi,%eax
  pos--;
801009eb:	83 e9 01             	sub    $0x1,%ecx
801009ee:	ee                   	out    %al,(%dx)
801009ef:	89 c8                	mov    %ecx,%eax
801009f1:	89 da                	mov    %ebx,%edx
801009f3:	ee                   	out    %al,(%dx)
801009f4:	b8 0e 00 00 00       	mov    $0xe,%eax
801009f9:	89 f2                	mov    %esi,%edx
801009fb:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
801009fc:	89 c8                	mov    %ecx,%eax
801009fe:	89 da                	mov    %ebx,%edx
80100a00:	c1 f8 08             	sar    $0x8,%eax
80100a03:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
80100a04:	b8 20 07 00 00       	mov    $0x720,%eax
80100a09:	66 89 84 09 00 80 0b 	mov    %ax,-0x7ff48000(%ecx,%ecx,1)
80100a10:	80 
}
80100a11:	5b                   	pop    %ebx
80100a12:	5e                   	pop    %esi
80100a13:	5f                   	pop    %edi
80100a14:	5d                   	pop    %ebp
80100a15:	c3                   	ret    
80100a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi

80100a20 <consoleintr>:
{
80100a20:	f3 0f 1e fb          	endbr32 
80100a24:	55                   	push   %ebp
80100a25:	89 e5                	mov    %esp,%ebp
80100a27:	57                   	push   %edi
80100a28:	56                   	push   %esi
80100a29:	53                   	push   %ebx
80100a2a:	83 ec 38             	sub    $0x38,%esp
80100a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
80100a30:	68 40 a5 10 80       	push   $0x8010a540
{
80100a35:	89 45 d8             	mov    %eax,-0x28(%ebp)
  acquire(&cons.lock);
80100a38:	e8 73 3e 00 00       	call   801048b0 <acquire>
  while((c = getc()) >= 0){
80100a3d:	83 c4 10             	add    $0x10,%esp
80100a40:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100a43:	ff d0                	call   *%eax
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	85 c0                	test   %eax,%eax
80100a49:	0f 88 30 02 00 00    	js     80100c7f <consoleintr+0x25f>
    switch(c){
80100a4f:	83 fb 7f             	cmp    $0x7f,%ebx
80100a52:	0f 84 62 01 00 00    	je     80100bba <consoleintr+0x19a>
80100a58:	0f 8f f2 00 00 00    	jg     80100b50 <consoleintr+0x130>
80100a5e:	83 fb 10             	cmp    $0x10,%ebx
80100a61:	0f 84 ff 01 00 00    	je     80100c66 <consoleintr+0x246>
80100a67:	83 fb 15             	cmp    $0x15,%ebx
80100a6a:	75 34                	jne    80100aa0 <consoleintr+0x80>
      while(input.e != input.w &&
80100a6c:	a1 fc ff 10 80       	mov    0x8010fffc,%eax
80100a71:	3b 05 f8 ff 10 80    	cmp    0x8010fff8,%eax
80100a77:	74 c7                	je     80100a40 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a79:	83 e8 01             	sub    $0x1,%eax
80100a7c:	89 c2                	mov    %eax,%edx
80100a7e:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a81:	80 ba 74 ff 10 80 0a 	cmpb   $0xa,-0x7fef008c(%edx)
80100a88:	74 b6                	je     80100a40 <consoleintr+0x20>
  if(panicked){
80100a8a:	8b 1d 78 a5 10 80    	mov    0x8010a578,%ebx
        input.e--;
80100a90:	a3 fc ff 10 80       	mov    %eax,0x8010fffc
  if(panicked){
80100a95:	85 db                	test   %ebx,%ebx
80100a97:	0f 84 ba 01 00 00    	je     80100c57 <consoleintr+0x237>
  asm volatile("cli");
80100a9d:	fa                   	cli    
    for(;;)
80100a9e:	eb fe                	jmp    80100a9e <consoleintr+0x7e>
    switch(c){
80100aa0:	83 fb 08             	cmp    $0x8,%ebx
80100aa3:	0f 84 11 01 00 00    	je     80100bba <consoleintr+0x19a>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100aa9:	85 db                	test   %ebx,%ebx
80100aab:	74 93                	je     80100a40 <consoleintr+0x20>
80100aad:	a1 fc ff 10 80       	mov    0x8010fffc,%eax
80100ab2:	2b 05 f4 ff 10 80    	sub    0x8010fff4,%eax
80100ab8:	83 f8 7f             	cmp    $0x7f,%eax
80100abb:	77 83                	ja     80100a40 <consoleintr+0x20>
        uartputc('-');
80100abd:	83 ec 0c             	sub    $0xc,%esp
80100ac0:	6a 2d                	push   $0x2d
80100ac2:	e8 69 55 00 00       	call   80106030 <uartputc>
        uartputc(c); 
80100ac7:	89 1c 24             	mov    %ebx,(%esp)
80100aca:	e8 61 55 00 00       	call   80106030 <uartputc>
        c = (c == '\r') ? '\n' : c;
80100acf:	a1 fc ff 10 80       	mov    0x8010fffc,%eax
80100ad4:	83 c4 10             	add    $0x10,%esp
80100ad7:	83 fb 0d             	cmp    $0xd,%ebx
80100ada:	0f 84 b2 01 00 00    	je     80100c92 <consoleintr+0x272>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){ 
80100ae0:	88 5d e7             	mov    %bl,-0x19(%ebp)
80100ae3:	8d 48 01             	lea    0x1(%eax),%ecx
80100ae6:	83 fb 0a             	cmp    $0xa,%ebx
80100ae9:	0f 84 af 01 00 00    	je     80100c9e <consoleintr+0x27e>
80100aef:	83 fb 04             	cmp    $0x4,%ebx
80100af2:	0f 84 a6 01 00 00    	je     80100c9e <consoleintr+0x27e>
80100af8:	8b 3d f4 ff 10 80    	mov    0x8010fff4,%edi
80100afe:	8d 97 80 00 00 00    	lea    0x80(%edi),%edx
80100b04:	39 c2                	cmp    %eax,%edx
80100b06:	0f 84 92 01 00 00    	je     80100c9e <consoleintr+0x27e>
          if(back_counter == 0){
80100b0c:	8b 3d 00 00 11 80    	mov    0x80110000,%edi
80100b12:	8b 35 20 a5 10 80    	mov    0x8010a520,%esi
80100b18:	8d 57 01             	lea    0x1(%edi),%edx
80100b1b:	89 75 e0             	mov    %esi,-0x20(%ebp)
80100b1e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80100b21:	85 f6                	test   %esi,%esi
80100b23:	0f 85 d8 01 00 00    	jne    80100d01 <consoleintr+0x2e1>
            input.buf[input.e++ % INPUT_BUF] = c;
80100b29:	83 e0 7f             	and    $0x7f,%eax
80100b2c:	89 0d fc ff 10 80    	mov    %ecx,0x8010fffc
80100b32:	88 98 74 ff 10 80    	mov    %bl,-0x7fef008c(%eax)
  if(panicked){
80100b38:	a1 78 a5 10 80       	mov    0x8010a578,%eax
            input.pos ++;
80100b3d:	89 15 00 00 11 80    	mov    %edx,0x80110000
  if(panicked){
80100b43:	85 c0                	test   %eax,%eax
80100b45:	0f 84 aa 01 00 00    	je     80100cf5 <consoleintr+0x2d5>
80100b4b:	fa                   	cli    
    for(;;)
80100b4c:	eb fe                	jmp    80100b4c <consoleintr+0x12c>
80100b4e:	66 90                	xchg   %ax,%ax
    switch(c){
80100b50:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80100b56:	0f 84 8c 00 00 00    	je     80100be8 <consoleintr+0x1c8>
80100b5c:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
80100b62:	0f 85 45 ff ff ff    	jne    80100aad <consoleintr+0x8d>
      if(input.pos < input.e){  
80100b68:	a1 00 00 11 80       	mov    0x80110000,%eax
80100b6d:	3b 05 fc ff 10 80    	cmp    0x8010fffc,%eax
80100b73:	0f 83 c7 fe ff ff    	jae    80100a40 <consoleintr+0x20>
        input.pos ++; 
80100b79:	83 c0 01             	add    $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b7c:	be d4 03 00 00       	mov    $0x3d4,%esi
        back_counter -= 1;
80100b81:	83 2d 20 a5 10 80 01 	subl   $0x1,0x8010a520
        input.pos ++; 
80100b88:	a3 00 00 11 80       	mov    %eax,0x80110000
80100b8d:	89 f2                	mov    %esi,%edx
80100b8f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100b94:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b95:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100b9a:	89 da                	mov    %ebx,%edx
80100b9c:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b9d:	bf 0f 00 00 00       	mov    $0xf,%edi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100ba2:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100ba5:	89 f2                	mov    %esi,%edx
  pos = inb(CRTPORT+1) << 8;
80100ba7:	c1 e1 08             	shl    $0x8,%ecx
80100baa:	89 f8                	mov    %edi,%eax
80100bac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100bad:	89 da                	mov    %ebx,%edx
80100baf:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100bb0:	0f b6 c0             	movzbl %al,%eax
80100bb3:	09 c1                	or     %eax,%ecx
  pos++;
80100bb5:	83 c1 01             	add    $0x1,%ecx
80100bb8:	eb 7e                	jmp    80100c38 <consoleintr+0x218>
      if(input.e != input.w){
80100bba:	a1 fc ff 10 80       	mov    0x8010fffc,%eax
80100bbf:	3b 05 f8 ff 10 80    	cmp    0x8010fff8,%eax
80100bc5:	0f 84 75 fe ff ff    	je     80100a40 <consoleintr+0x20>
  if(panicked){
80100bcb:	8b 0d 78 a5 10 80    	mov    0x8010a578,%ecx
        input.e--;
80100bd1:	83 e8 01             	sub    $0x1,%eax
80100bd4:	a3 fc ff 10 80       	mov    %eax,0x8010fffc
  if(panicked){
80100bd9:	85 c9                	test   %ecx,%ecx
80100bdb:	0f 84 8f 00 00 00    	je     80100c70 <consoleintr+0x250>
  asm volatile("cli");
80100be1:	fa                   	cli    
    for(;;)
80100be2:	eb fe                	jmp    80100be2 <consoleintr+0x1c2>
80100be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.pos > input.r){ 
80100be8:	a1 00 00 11 80       	mov    0x80110000,%eax
80100bed:	3b 05 f4 ff 10 80    	cmp    0x8010fff4,%eax
80100bf3:	0f 86 47 fe ff ff    	jbe    80100a40 <consoleintr+0x20>
        input.pos --;
80100bf9:	83 e8 01             	sub    $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100bfc:	be d4 03 00 00       	mov    $0x3d4,%esi
        back_counter += 1;
80100c01:	83 05 20 a5 10 80 01 	addl   $0x1,0x8010a520
        input.pos --;
80100c08:	a3 00 00 11 80       	mov    %eax,0x80110000
80100c0d:	89 f2                	mov    %esi,%edx
80100c0f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c14:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c15:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100c1a:	89 da                	mov    %ebx,%edx
80100c1c:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c1d:	bf 0f 00 00 00       	mov    $0xf,%edi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c22:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c25:	89 f2                	mov    %esi,%edx
  pos = inb(CRTPORT+1) << 8;
80100c27:	c1 e1 08             	shl    $0x8,%ecx
80100c2a:	89 f8                	mov    %edi,%eax
80100c2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c2d:	89 da                	mov    %ebx,%edx
80100c2f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100c30:	0f b6 c0             	movzbl %al,%eax
80100c33:	09 c1                	or     %eax,%ecx
  pos--;
80100c35:	83 e9 01             	sub    $0x1,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c38:	89 f8                	mov    %edi,%eax
80100c3a:	89 f2                	mov    %esi,%edx
80100c3c:	ee                   	out    %al,(%dx)
80100c3d:	89 c8                	mov    %ecx,%eax
80100c3f:	89 da                	mov    %ebx,%edx
80100c41:	ee                   	out    %al,(%dx)
80100c42:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c47:	89 f2                	mov    %esi,%edx
80100c49:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
80100c4a:	89 c8                	mov    %ecx,%eax
80100c4c:	89 da                	mov    %ebx,%edx
80100c4e:	c1 f8 08             	sar    $0x8,%eax
80100c51:	ee                   	out    %al,(%dx)
}
80100c52:	e9 e9 fd ff ff       	jmp    80100a40 <consoleintr+0x20>
80100c57:	b8 00 01 00 00       	mov    $0x100,%eax
80100c5c:	e8 2f f7 ff ff       	call   80100390 <consputc.part.0>
80100c61:	e9 06 fe ff ff       	jmp    80100a6c <consoleintr+0x4c>
      procdump();
80100c66:	e8 b5 38 00 00       	call   80104520 <procdump>
      break;
80100c6b:	e9 d0 fd ff ff       	jmp    80100a40 <consoleintr+0x20>
80100c70:	b8 00 01 00 00       	mov    $0x100,%eax
80100c75:	e8 16 f7 ff ff       	call   80100390 <consputc.part.0>
80100c7a:	e9 c1 fd ff ff       	jmp    80100a40 <consoleintr+0x20>
  release(&cons.lock);
80100c7f:	c7 45 08 40 a5 10 80 	movl   $0x8010a540,0x8(%ebp)
}
80100c86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c89:	5b                   	pop    %ebx
80100c8a:	5e                   	pop    %esi
80100c8b:	5f                   	pop    %edi
80100c8c:	5d                   	pop    %ebp
  release(&cons.lock);
80100c8d:	e9 de 3c 00 00       	jmp    80104970 <release>
        c = (c == '\r') ? '\n' : c;
80100c92:	c6 45 e7 0a          	movb   $0xa,-0x19(%ebp)
80100c96:	8d 48 01             	lea    0x1(%eax),%ecx
80100c99:	bb 0a 00 00 00       	mov    $0xa,%ebx
          input.buf[input.e++ % INPUT_BUF] = c;
80100c9e:	89 0d fc ff 10 80    	mov    %ecx,0x8010fffc
  if(panicked){
80100ca4:	8b 15 78 a5 10 80    	mov    0x8010a578,%edx
          input.buf[input.e++ % INPUT_BUF] = c;
80100caa:	83 e0 7f             	and    $0x7f,%eax
80100cad:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
80100cb1:	88 88 74 ff 10 80    	mov    %cl,-0x7fef008c(%eax)
  if(panicked){
80100cb7:	85 d2                	test   %edx,%edx
80100cb9:	74 05                	je     80100cc0 <consoleintr+0x2a0>
  asm volatile("cli");
80100cbb:	fa                   	cli    
    for(;;)
80100cbc:	eb fe                	jmp    80100cbc <consoleintr+0x29c>
80100cbe:	66 90                	xchg   %ax,%ax
80100cc0:	89 d8                	mov    %ebx,%eax
80100cc2:	e8 c9 f6 ff ff       	call   80100390 <consputc.part.0>
          wakeup(&input.r);
80100cc7:	83 ec 0c             	sub    $0xc,%esp
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
80100cca:	a1 fc ff 10 80       	mov    0x8010fffc,%eax
          back_counter = 0;
80100ccf:	c7 05 20 a5 10 80 00 	movl   $0x0,0x8010a520
80100cd6:	00 00 00 
          wakeup(&input.r);
80100cd9:	68 f4 ff 10 80       	push   $0x8010fff4
          input.w = input.e;
80100cde:	a3 f8 ff 10 80       	mov    %eax,0x8010fff8
          input.pos = input.e;
80100ce3:	a3 00 00 11 80       	mov    %eax,0x80110000
          wakeup(&input.r);
80100ce8:	e8 43 37 00 00       	call   80104430 <wakeup>
80100ced:	83 c4 10             	add    $0x10,%esp
80100cf0:	e9 4b fd ff ff       	jmp    80100a40 <consoleintr+0x20>
80100cf5:	89 d8                	mov    %ebx,%eax
80100cf7:	e8 94 f6 ff ff       	call   80100390 <consputc.part.0>
80100cfc:	e9 3f fd ff ff       	jmp    80100a40 <consoleintr+0x20>
            for(int k=input.e; k >= input.pos; k--){
80100d01:	39 f8                	cmp    %edi,%eax
80100d03:	72 3e                	jb     80100d43 <consoleintr+0x323>
80100d05:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
              input.buf[(k + 1) % INPUT_BUF] = input.buf[k % INPUT_BUF];
80100d08:	89 c6                	mov    %eax,%esi
80100d0a:	c1 fe 1f             	sar    $0x1f,%esi
80100d0d:	c1 ee 19             	shr    $0x19,%esi
80100d10:	8d 14 30             	lea    (%eax,%esi,1),%edx
80100d13:	83 e2 7f             	and    $0x7f,%edx
80100d16:	29 f2                	sub    %esi,%edx
80100d18:	0f b6 92 74 ff 10 80 	movzbl -0x7fef008c(%edx),%edx
80100d1f:	89 d1                	mov    %edx,%ecx
80100d21:	8d 50 01             	lea    0x1(%eax),%edx
            for(int k=input.e; k >= input.pos; k--){
80100d24:	83 e8 01             	sub    $0x1,%eax
              input.buf[(k + 1) % INPUT_BUF] = input.buf[k % INPUT_BUF];
80100d27:	89 d6                	mov    %edx,%esi
80100d29:	c1 fe 1f             	sar    $0x1f,%esi
80100d2c:	c1 ee 19             	shr    $0x19,%esi
80100d2f:	01 f2                	add    %esi,%edx
80100d31:	83 e2 7f             	and    $0x7f,%edx
80100d34:	29 f2                	sub    %esi,%edx
80100d36:	88 8a 74 ff 10 80    	mov    %cl,-0x7fef008c(%edx)
            for(int k=input.e; k >= input.pos; k--){
80100d3c:	39 f8                	cmp    %edi,%eax
80100d3e:	73 c8                	jae    80100d08 <consoleintr+0x2e8>
80100d40:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
            vga_insert_char(c, back_counter);
80100d43:	83 ec 08             	sub    $0x8,%esp
            input.buf[input.pos % INPUT_BUF] = c;
80100d46:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
80100d4a:	89 f8                	mov    %edi,%eax
            vga_insert_char(c, back_counter);
80100d4c:	ff 75 e0             	pushl  -0x20(%ebp)
            input.buf[input.pos % INPUT_BUF] = c;
80100d4f:	83 e0 7f             	and    $0x7f,%eax
            vga_insert_char(c, back_counter);
80100d52:	53                   	push   %ebx
            input.buf[input.pos % INPUT_BUF] = c;
80100d53:	88 90 74 ff 10 80    	mov    %dl,-0x7fef008c(%eax)
            input.pos++;
80100d59:	8b 45 dc             	mov    -0x24(%ebp),%eax
            input.e++;
80100d5c:	89 0d fc ff 10 80    	mov    %ecx,0x8010fffc
            input.pos++;
80100d62:	a3 00 00 11 80       	mov    %eax,0x80110000
            vga_insert_char(c, back_counter);
80100d67:	e8 94 fb ff ff       	call   80100900 <vga_insert_char>
80100d6c:	83 c4 10             	add    $0x10,%esp
80100d6f:	e9 cc fc ff ff       	jmp    80100a40 <consoleintr+0x20>
80100d74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d7f:	90                   	nop

80100d80 <consoleinit>:

void
consoleinit(void)
{
80100d80:	f3 0f 1e fb          	endbr32 
80100d84:	55                   	push   %ebp
80100d85:	89 e5                	mov    %esp,%ebp
80100d87:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100d8a:	68 95 74 10 80       	push   $0x80107495
80100d8f:	68 40 a5 10 80       	push   $0x8010a540
80100d94:	e8 97 39 00 00       	call   80104730 <initlock>
  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  //picenable(IRQ_KBD);
  ioapicenable(IRQ_KBD, 0);
80100d99:	58                   	pop    %eax
80100d9a:	5a                   	pop    %edx
80100d9b:	6a 00                	push   $0x0
80100d9d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100d9f:	c7 05 cc 09 11 80 a0 	movl   $0x801005a0,0x801109cc
80100da6:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100da9:	c7 05 c8 09 11 80 90 	movl   $0x80100290,0x801109c8
80100db0:	02 10 80 
  cons.locking = 1;
80100db3:	c7 05 74 a5 10 80 01 	movl   $0x1,0x8010a574
80100dba:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100dbd:	e8 be 19 00 00       	call   80102780 <ioapicenable>
}
80100dc2:	83 c4 10             	add    $0x10,%esp
80100dc5:	c9                   	leave  
80100dc6:	c3                   	ret    
80100dc7:	66 90                	xchg   %ax,%ax
80100dc9:	66 90                	xchg   %ax,%ax
80100dcb:	66 90                	xchg   %ax,%ax
80100dcd:	66 90                	xchg   %ax,%ax
80100dcf:	90                   	nop

80100dd0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100dd0:	f3 0f 1e fb          	endbr32 
80100dd4:	55                   	push   %ebp
80100dd5:	89 e5                	mov    %esp,%ebp
80100dd7:	57                   	push   %edi
80100dd8:	56                   	push   %esi
80100dd9:	53                   	push   %ebx
80100dda:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100de0:	e8 cb 2e 00 00       	call   80103cb0 <myproc>
80100de5:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100deb:	e8 90 22 00 00       	call   80103080 <begin_op>

  if((ip = namei(path)) == 0){
80100df0:	83 ec 0c             	sub    $0xc,%esp
80100df3:	ff 75 08             	pushl  0x8(%ebp)
80100df6:	e8 85 15 00 00       	call   80102380 <namei>
80100dfb:	83 c4 10             	add    $0x10,%esp
80100dfe:	85 c0                	test   %eax,%eax
80100e00:	0f 84 fe 02 00 00    	je     80101104 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100e06:	83 ec 0c             	sub    $0xc,%esp
80100e09:	89 c3                	mov    %eax,%ebx
80100e0b:	50                   	push   %eax
80100e0c:	e8 9f 0c 00 00       	call   80101ab0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100e11:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100e17:	6a 34                	push   $0x34
80100e19:	6a 00                	push   $0x0
80100e1b:	50                   	push   %eax
80100e1c:	53                   	push   %ebx
80100e1d:	e8 8e 0f 00 00       	call   80101db0 <readi>
80100e22:	83 c4 20             	add    $0x20,%esp
80100e25:	83 f8 34             	cmp    $0x34,%eax
80100e28:	74 26                	je     80100e50 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100e2a:	83 ec 0c             	sub    $0xc,%esp
80100e2d:	53                   	push   %ebx
80100e2e:	e8 1d 0f 00 00       	call   80101d50 <iunlockput>
    end_op();
80100e33:	e8 b8 22 00 00       	call   801030f0 <end_op>
80100e38:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100e3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e43:	5b                   	pop    %ebx
80100e44:	5e                   	pop    %esi
80100e45:	5f                   	pop    %edi
80100e46:	5d                   	pop    %ebp
80100e47:	c3                   	ret    
80100e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100e50:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100e57:	45 4c 46 
80100e5a:	75 ce                	jne    80100e2a <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100e5c:	e8 3f 63 00 00       	call   801071a0 <setupkvm>
80100e61:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100e67:	85 c0                	test   %eax,%eax
80100e69:	74 bf                	je     80100e2a <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e6b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100e72:	00 
80100e73:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100e79:	0f 84 a4 02 00 00    	je     80101123 <exec+0x353>
  sz = 0;
80100e7f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e86:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e89:	31 ff                	xor    %edi,%edi
80100e8b:	e9 86 00 00 00       	jmp    80100f16 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100e90:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100e97:	75 6c                	jne    80100f05 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100e99:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100e9f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ea5:	0f 82 87 00 00 00    	jb     80100f32 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100eab:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100eb1:	72 7f                	jb     80100f32 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100eb3:	83 ec 04             	sub    $0x4,%esp
80100eb6:	50                   	push   %eax
80100eb7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100ebd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ec3:	e8 f8 60 00 00       	call   80106fc0 <allocuvm>
80100ec8:	83 c4 10             	add    $0x10,%esp
80100ecb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ed1:	85 c0                	test   %eax,%eax
80100ed3:	74 5d                	je     80100f32 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100ed5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100edb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ee0:	75 50                	jne    80100f32 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ee2:	83 ec 0c             	sub    $0xc,%esp
80100ee5:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100eeb:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ef1:	53                   	push   %ebx
80100ef2:	50                   	push   %eax
80100ef3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ef9:	e8 f2 5f 00 00       	call   80106ef0 <loaduvm>
80100efe:	83 c4 20             	add    $0x20,%esp
80100f01:	85 c0                	test   %eax,%eax
80100f03:	78 2d                	js     80100f32 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f05:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100f0c:	83 c7 01             	add    $0x1,%edi
80100f0f:	83 c6 20             	add    $0x20,%esi
80100f12:	39 f8                	cmp    %edi,%eax
80100f14:	7e 3a                	jle    80100f50 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100f16:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100f1c:	6a 20                	push   $0x20
80100f1e:	56                   	push   %esi
80100f1f:	50                   	push   %eax
80100f20:	53                   	push   %ebx
80100f21:	e8 8a 0e 00 00       	call   80101db0 <readi>
80100f26:	83 c4 10             	add    $0x10,%esp
80100f29:	83 f8 20             	cmp    $0x20,%eax
80100f2c:	0f 84 5e ff ff ff    	je     80100e90 <exec+0xc0>
    freevm(pgdir);
80100f32:	83 ec 0c             	sub    $0xc,%esp
80100f35:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f3b:	e8 e0 61 00 00       	call   80107120 <freevm>
  if(ip){
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	e9 e2 fe ff ff       	jmp    80100e2a <exec+0x5a>
80100f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f4f:	90                   	nop
80100f50:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100f56:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100f5c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100f62:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100f68:	83 ec 0c             	sub    $0xc,%esp
80100f6b:	53                   	push   %ebx
80100f6c:	e8 df 0d 00 00       	call   80101d50 <iunlockput>
  end_op();
80100f71:	e8 7a 21 00 00       	call   801030f0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100f76:	83 c4 0c             	add    $0xc,%esp
80100f79:	56                   	push   %esi
80100f7a:	57                   	push   %edi
80100f7b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100f81:	57                   	push   %edi
80100f82:	e8 39 60 00 00       	call   80106fc0 <allocuvm>
80100f87:	83 c4 10             	add    $0x10,%esp
80100f8a:	89 c6                	mov    %eax,%esi
80100f8c:	85 c0                	test   %eax,%eax
80100f8e:	0f 84 94 00 00 00    	je     80101028 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f94:	83 ec 08             	sub    $0x8,%esp
80100f97:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100f9d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f9f:	50                   	push   %eax
80100fa0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100fa1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100fa3:	e8 98 62 00 00       	call   80107240 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fab:	83 c4 10             	add    $0x10,%esp
80100fae:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100fb4:	8b 00                	mov    (%eax),%eax
80100fb6:	85 c0                	test   %eax,%eax
80100fb8:	0f 84 8b 00 00 00    	je     80101049 <exec+0x279>
80100fbe:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100fc4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100fca:	eb 23                	jmp    80100fef <exec+0x21f>
80100fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100fd3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100fda:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100fdd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100fe3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100fe6:	85 c0                	test   %eax,%eax
80100fe8:	74 59                	je     80101043 <exec+0x273>
    if(argc >= MAXARG)
80100fea:	83 ff 20             	cmp    $0x20,%edi
80100fed:	74 39                	je     80101028 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	50                   	push   %eax
80100ff3:	e8 c8 3b 00 00       	call   80104bc0 <strlen>
80100ff8:	f7 d0                	not    %eax
80100ffa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ffc:	58                   	pop    %eax
80100ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101000:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101003:	ff 34 b8             	pushl  (%eax,%edi,4)
80101006:	e8 b5 3b 00 00       	call   80104bc0 <strlen>
8010100b:	83 c0 01             	add    $0x1,%eax
8010100e:	50                   	push   %eax
8010100f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101012:	ff 34 b8             	pushl  (%eax,%edi,4)
80101015:	53                   	push   %ebx
80101016:	56                   	push   %esi
80101017:	e8 84 63 00 00       	call   801073a0 <copyout>
8010101c:	83 c4 20             	add    $0x20,%esp
8010101f:	85 c0                	test   %eax,%eax
80101021:	79 ad                	jns    80100fd0 <exec+0x200>
80101023:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101027:	90                   	nop
    freevm(pgdir);
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101031:	e8 ea 60 00 00       	call   80107120 <freevm>
80101036:	83 c4 10             	add    $0x10,%esp
  return -1;
80101039:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010103e:	e9 fd fd ff ff       	jmp    80100e40 <exec+0x70>
80101043:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101049:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101050:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101052:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101059:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010105d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010105f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101062:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101068:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010106a:	50                   	push   %eax
8010106b:	52                   	push   %edx
8010106c:	53                   	push   %ebx
8010106d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101073:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010107a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010107d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101083:	e8 18 63 00 00       	call   801073a0 <copyout>
80101088:	83 c4 10             	add    $0x10,%esp
8010108b:	85 c0                	test   %eax,%eax
8010108d:	78 99                	js     80101028 <exec+0x258>
  for(last=s=path; *s; s++)
8010108f:	8b 45 08             	mov    0x8(%ebp),%eax
80101092:	8b 55 08             	mov    0x8(%ebp),%edx
80101095:	0f b6 00             	movzbl (%eax),%eax
80101098:	84 c0                	test   %al,%al
8010109a:	74 13                	je     801010af <exec+0x2df>
8010109c:	89 d1                	mov    %edx,%ecx
8010109e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
801010a0:	83 c1 01             	add    $0x1,%ecx
801010a3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801010a5:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
801010a8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
801010ab:	84 c0                	test   %al,%al
801010ad:	75 f1                	jne    801010a0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801010af:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801010b5:	83 ec 04             	sub    $0x4,%esp
801010b8:	6a 10                	push   $0x10
801010ba:	89 f8                	mov    %edi,%eax
801010bc:	52                   	push   %edx
801010bd:	83 c0 6c             	add    $0x6c,%eax
801010c0:	50                   	push   %eax
801010c1:	e8 ba 3a 00 00       	call   80104b80 <safestrcpy>
  curproc->pgdir = pgdir;
801010c6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801010cc:	89 f8                	mov    %edi,%eax
801010ce:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
801010d1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
801010d3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
801010d6:	89 c1                	mov    %eax,%ecx
801010d8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801010de:	8b 40 18             	mov    0x18(%eax),%eax
801010e1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801010e4:	8b 41 18             	mov    0x18(%ecx),%eax
801010e7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
801010ea:	89 0c 24             	mov    %ecx,(%esp)
801010ed:	e8 6e 5c 00 00       	call   80106d60 <switchuvm>
  freevm(oldpgdir);
801010f2:	89 3c 24             	mov    %edi,(%esp)
801010f5:	e8 26 60 00 00       	call   80107120 <freevm>
  return 0;
801010fa:	83 c4 10             	add    $0x10,%esp
801010fd:	31 c0                	xor    %eax,%eax
801010ff:	e9 3c fd ff ff       	jmp    80100e40 <exec+0x70>
    end_op();
80101104:	e8 e7 1f 00 00       	call   801030f0 <end_op>
    cprintf("exec: fail\n");
80101109:	83 ec 0c             	sub    $0xc,%esp
8010110c:	68 b1 74 10 80       	push   $0x801074b1
80101111:	e8 7a f5 ff ff       	call   80100690 <cprintf>
    return -1;
80101116:	83 c4 10             	add    $0x10,%esp
80101119:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010111e:	e9 1d fd ff ff       	jmp    80100e40 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101123:	31 ff                	xor    %edi,%edi
80101125:	be 00 20 00 00       	mov    $0x2000,%esi
8010112a:	e9 39 fe ff ff       	jmp    80100f68 <exec+0x198>
8010112f:	90                   	nop

80101130 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101130:	f3 0f 1e fb          	endbr32 
80101134:	55                   	push   %ebp
80101135:	89 e5                	mov    %esp,%ebp
80101137:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
8010113a:	68 bd 74 10 80       	push   $0x801074bd
8010113f:	68 20 00 11 80       	push   $0x80110020
80101144:	e8 e7 35 00 00       	call   80104730 <initlock>
}
80101149:	83 c4 10             	add    $0x10,%esp
8010114c:	c9                   	leave  
8010114d:	c3                   	ret    
8010114e:	66 90                	xchg   %ax,%ax

80101150 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101150:	f3 0f 1e fb          	endbr32 
80101154:	55                   	push   %ebp
80101155:	89 e5                	mov    %esp,%ebp
80101157:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101158:	bb 54 00 11 80       	mov    $0x80110054,%ebx
{
8010115d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80101160:	68 20 00 11 80       	push   $0x80110020
80101165:	e8 46 37 00 00       	call   801048b0 <acquire>
8010116a:	83 c4 10             	add    $0x10,%esp
8010116d:	eb 0c                	jmp    8010117b <filealloc+0x2b>
8010116f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101170:	83 c3 18             	add    $0x18,%ebx
80101173:	81 fb b4 09 11 80    	cmp    $0x801109b4,%ebx
80101179:	74 25                	je     801011a0 <filealloc+0x50>
    if(f->ref == 0){
8010117b:	8b 43 04             	mov    0x4(%ebx),%eax
8010117e:	85 c0                	test   %eax,%eax
80101180:	75 ee                	jne    80101170 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101182:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101185:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010118c:	68 20 00 11 80       	push   $0x80110020
80101191:	e8 da 37 00 00       	call   80104970 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101196:	89 d8                	mov    %ebx,%eax
      return f;
80101198:	83 c4 10             	add    $0x10,%esp
}
8010119b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010119e:	c9                   	leave  
8010119f:	c3                   	ret    
  release(&ftable.lock);
801011a0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801011a3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801011a5:	68 20 00 11 80       	push   $0x80110020
801011aa:	e8 c1 37 00 00       	call   80104970 <release>
}
801011af:	89 d8                	mov    %ebx,%eax
  return 0;
801011b1:	83 c4 10             	add    $0x10,%esp
}
801011b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011b7:	c9                   	leave  
801011b8:	c3                   	ret    
801011b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801011c0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801011c0:	f3 0f 1e fb          	endbr32 
801011c4:	55                   	push   %ebp
801011c5:	89 e5                	mov    %esp,%ebp
801011c7:	53                   	push   %ebx
801011c8:	83 ec 10             	sub    $0x10,%esp
801011cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801011ce:	68 20 00 11 80       	push   $0x80110020
801011d3:	e8 d8 36 00 00       	call   801048b0 <acquire>
  if(f->ref < 1)
801011d8:	8b 43 04             	mov    0x4(%ebx),%eax
801011db:	83 c4 10             	add    $0x10,%esp
801011de:	85 c0                	test   %eax,%eax
801011e0:	7e 1a                	jle    801011fc <filedup+0x3c>
    panic("filedup");
  f->ref++;
801011e2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801011e5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801011e8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801011eb:	68 20 00 11 80       	push   $0x80110020
801011f0:	e8 7b 37 00 00       	call   80104970 <release>
  return f;
}
801011f5:	89 d8                	mov    %ebx,%eax
801011f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011fa:	c9                   	leave  
801011fb:	c3                   	ret    
    panic("filedup");
801011fc:	83 ec 0c             	sub    $0xc,%esp
801011ff:	68 c4 74 10 80       	push   $0x801074c4
80101204:	e8 07 f4 ff ff       	call   80100610 <panic>
80101209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101210 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101210:	f3 0f 1e fb          	endbr32 
80101214:	55                   	push   %ebp
80101215:	89 e5                	mov    %esp,%ebp
80101217:	57                   	push   %edi
80101218:	56                   	push   %esi
80101219:	53                   	push   %ebx
8010121a:	83 ec 28             	sub    $0x28,%esp
8010121d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80101220:	68 20 00 11 80       	push   $0x80110020
80101225:	e8 86 36 00 00       	call   801048b0 <acquire>
  if(f->ref < 1)
8010122a:	8b 53 04             	mov    0x4(%ebx),%edx
8010122d:	83 c4 10             	add    $0x10,%esp
80101230:	85 d2                	test   %edx,%edx
80101232:	0f 8e a1 00 00 00    	jle    801012d9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101238:	83 ea 01             	sub    $0x1,%edx
8010123b:	89 53 04             	mov    %edx,0x4(%ebx)
8010123e:	75 40                	jne    80101280 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101240:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101244:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101247:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101249:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010124f:	8b 73 0c             	mov    0xc(%ebx),%esi
80101252:	88 45 e7             	mov    %al,-0x19(%ebp)
80101255:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101258:	68 20 00 11 80       	push   $0x80110020
  ff = *f;
8010125d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101260:	e8 0b 37 00 00       	call   80104970 <release>

  if(ff.type == FD_PIPE)
80101265:	83 c4 10             	add    $0x10,%esp
80101268:	83 ff 01             	cmp    $0x1,%edi
8010126b:	74 53                	je     801012c0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
8010126d:	83 ff 02             	cmp    $0x2,%edi
80101270:	74 26                	je     80101298 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101272:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101275:	5b                   	pop    %ebx
80101276:	5e                   	pop    %esi
80101277:	5f                   	pop    %edi
80101278:	5d                   	pop    %ebp
80101279:	c3                   	ret    
8010127a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101280:	c7 45 08 20 00 11 80 	movl   $0x80110020,0x8(%ebp)
}
80101287:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010128a:	5b                   	pop    %ebx
8010128b:	5e                   	pop    %esi
8010128c:	5f                   	pop    %edi
8010128d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010128e:	e9 dd 36 00 00       	jmp    80104970 <release>
80101293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101297:	90                   	nop
    begin_op();
80101298:	e8 e3 1d 00 00       	call   80103080 <begin_op>
    iput(ff.ip);
8010129d:	83 ec 0c             	sub    $0xc,%esp
801012a0:	ff 75 e0             	pushl  -0x20(%ebp)
801012a3:	e8 38 09 00 00       	call   80101be0 <iput>
    end_op();
801012a8:	83 c4 10             	add    $0x10,%esp
}
801012ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ae:	5b                   	pop    %ebx
801012af:	5e                   	pop    %esi
801012b0:	5f                   	pop    %edi
801012b1:	5d                   	pop    %ebp
    end_op();
801012b2:	e9 39 1e 00 00       	jmp    801030f0 <end_op>
801012b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012be:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801012c0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801012c4:	83 ec 08             	sub    $0x8,%esp
801012c7:	53                   	push   %ebx
801012c8:	56                   	push   %esi
801012c9:	e8 82 25 00 00       	call   80103850 <pipeclose>
801012ce:	83 c4 10             	add    $0x10,%esp
}
801012d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d4:	5b                   	pop    %ebx
801012d5:	5e                   	pop    %esi
801012d6:	5f                   	pop    %edi
801012d7:	5d                   	pop    %ebp
801012d8:	c3                   	ret    
    panic("fileclose");
801012d9:	83 ec 0c             	sub    $0xc,%esp
801012dc:	68 cc 74 10 80       	push   $0x801074cc
801012e1:	e8 2a f3 ff ff       	call   80100610 <panic>
801012e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012ed:	8d 76 00             	lea    0x0(%esi),%esi

801012f0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801012f0:	f3 0f 1e fb          	endbr32 
801012f4:	55                   	push   %ebp
801012f5:	89 e5                	mov    %esp,%ebp
801012f7:	53                   	push   %ebx
801012f8:	83 ec 04             	sub    $0x4,%esp
801012fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801012fe:	83 3b 02             	cmpl   $0x2,(%ebx)
80101301:	75 2d                	jne    80101330 <filestat+0x40>
    ilock(f->ip);
80101303:	83 ec 0c             	sub    $0xc,%esp
80101306:	ff 73 10             	pushl  0x10(%ebx)
80101309:	e8 a2 07 00 00       	call   80101ab0 <ilock>
    stati(f->ip, st);
8010130e:	58                   	pop    %eax
8010130f:	5a                   	pop    %edx
80101310:	ff 75 0c             	pushl  0xc(%ebp)
80101313:	ff 73 10             	pushl  0x10(%ebx)
80101316:	e8 65 0a 00 00       	call   80101d80 <stati>
    iunlock(f->ip);
8010131b:	59                   	pop    %ecx
8010131c:	ff 73 10             	pushl  0x10(%ebx)
8010131f:	e8 6c 08 00 00       	call   80101b90 <iunlock>
    return 0;
  }
  return -1;
}
80101324:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101327:	83 c4 10             	add    $0x10,%esp
8010132a:	31 c0                	xor    %eax,%eax
}
8010132c:	c9                   	leave  
8010132d:	c3                   	ret    
8010132e:	66 90                	xchg   %ax,%ax
80101330:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101333:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101338:	c9                   	leave  
80101339:	c3                   	ret    
8010133a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101340 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101340:	f3 0f 1e fb          	endbr32 
80101344:	55                   	push   %ebp
80101345:	89 e5                	mov    %esp,%ebp
80101347:	57                   	push   %edi
80101348:	56                   	push   %esi
80101349:	53                   	push   %ebx
8010134a:	83 ec 0c             	sub    $0xc,%esp
8010134d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101350:	8b 75 0c             	mov    0xc(%ebp),%esi
80101353:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101356:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010135a:	74 64                	je     801013c0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010135c:	8b 03                	mov    (%ebx),%eax
8010135e:	83 f8 01             	cmp    $0x1,%eax
80101361:	74 45                	je     801013a8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101363:	83 f8 02             	cmp    $0x2,%eax
80101366:	75 5f                	jne    801013c7 <fileread+0x87>
    ilock(f->ip);
80101368:	83 ec 0c             	sub    $0xc,%esp
8010136b:	ff 73 10             	pushl  0x10(%ebx)
8010136e:	e8 3d 07 00 00       	call   80101ab0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101373:	57                   	push   %edi
80101374:	ff 73 14             	pushl  0x14(%ebx)
80101377:	56                   	push   %esi
80101378:	ff 73 10             	pushl  0x10(%ebx)
8010137b:	e8 30 0a 00 00       	call   80101db0 <readi>
80101380:	83 c4 20             	add    $0x20,%esp
80101383:	89 c6                	mov    %eax,%esi
80101385:	85 c0                	test   %eax,%eax
80101387:	7e 03                	jle    8010138c <fileread+0x4c>
      f->off += r;
80101389:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010138c:	83 ec 0c             	sub    $0xc,%esp
8010138f:	ff 73 10             	pushl  0x10(%ebx)
80101392:	e8 f9 07 00 00       	call   80101b90 <iunlock>
    return r;
80101397:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010139a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010139d:	89 f0                	mov    %esi,%eax
8010139f:	5b                   	pop    %ebx
801013a0:	5e                   	pop    %esi
801013a1:	5f                   	pop    %edi
801013a2:	5d                   	pop    %ebp
801013a3:	c3                   	ret    
801013a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801013a8:	8b 43 0c             	mov    0xc(%ebx),%eax
801013ab:	89 45 08             	mov    %eax,0x8(%ebp)
}
801013ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b1:	5b                   	pop    %ebx
801013b2:	5e                   	pop    %esi
801013b3:	5f                   	pop    %edi
801013b4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801013b5:	e9 36 26 00 00       	jmp    801039f0 <piperead>
801013ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801013c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801013c5:	eb d3                	jmp    8010139a <fileread+0x5a>
  panic("fileread");
801013c7:	83 ec 0c             	sub    $0xc,%esp
801013ca:	68 d6 74 10 80       	push   $0x801074d6
801013cf:	e8 3c f2 ff ff       	call   80100610 <panic>
801013d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013df:	90                   	nop

801013e0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801013e0:	f3 0f 1e fb          	endbr32 
801013e4:	55                   	push   %ebp
801013e5:	89 e5                	mov    %esp,%ebp
801013e7:	57                   	push   %edi
801013e8:	56                   	push   %esi
801013e9:	53                   	push   %ebx
801013ea:	83 ec 1c             	sub    $0x1c,%esp
801013ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801013f0:	8b 75 08             	mov    0x8(%ebp),%esi
801013f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801013f6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801013f9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801013fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101400:	0f 84 c1 00 00 00    	je     801014c7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101406:	8b 06                	mov    (%esi),%eax
80101408:	83 f8 01             	cmp    $0x1,%eax
8010140b:	0f 84 c3 00 00 00    	je     801014d4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101411:	83 f8 02             	cmp    $0x2,%eax
80101414:	0f 85 cc 00 00 00    	jne    801014e6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010141a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010141d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010141f:	85 c0                	test   %eax,%eax
80101421:	7f 34                	jg     80101457 <filewrite+0x77>
80101423:	e9 98 00 00 00       	jmp    801014c0 <filewrite+0xe0>
80101428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010142f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101430:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101433:	83 ec 0c             	sub    $0xc,%esp
80101436:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101439:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010143c:	e8 4f 07 00 00       	call   80101b90 <iunlock>
      end_op();
80101441:	e8 aa 1c 00 00       	call   801030f0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101446:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101449:	83 c4 10             	add    $0x10,%esp
8010144c:	39 c3                	cmp    %eax,%ebx
8010144e:	75 60                	jne    801014b0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101450:	01 df                	add    %ebx,%edi
    while(i < n){
80101452:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101455:	7e 69                	jle    801014c0 <filewrite+0xe0>
      int n1 = n - i;
80101457:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010145a:	b8 00 06 00 00       	mov    $0x600,%eax
8010145f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101461:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101467:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010146a:	e8 11 1c 00 00       	call   80103080 <begin_op>
      ilock(f->ip);
8010146f:	83 ec 0c             	sub    $0xc,%esp
80101472:	ff 76 10             	pushl  0x10(%esi)
80101475:	e8 36 06 00 00       	call   80101ab0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010147a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010147d:	53                   	push   %ebx
8010147e:	ff 76 14             	pushl  0x14(%esi)
80101481:	01 f8                	add    %edi,%eax
80101483:	50                   	push   %eax
80101484:	ff 76 10             	pushl  0x10(%esi)
80101487:	e8 24 0a 00 00       	call   80101eb0 <writei>
8010148c:	83 c4 20             	add    $0x20,%esp
8010148f:	85 c0                	test   %eax,%eax
80101491:	7f 9d                	jg     80101430 <filewrite+0x50>
      iunlock(f->ip);
80101493:	83 ec 0c             	sub    $0xc,%esp
80101496:	ff 76 10             	pushl  0x10(%esi)
80101499:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010149c:	e8 ef 06 00 00       	call   80101b90 <iunlock>
      end_op();
801014a1:	e8 4a 1c 00 00       	call   801030f0 <end_op>
      if(r < 0)
801014a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801014a9:	83 c4 10             	add    $0x10,%esp
801014ac:	85 c0                	test   %eax,%eax
801014ae:	75 17                	jne    801014c7 <filewrite+0xe7>
        panic("short filewrite");
801014b0:	83 ec 0c             	sub    $0xc,%esp
801014b3:	68 df 74 10 80       	push   $0x801074df
801014b8:	e8 53 f1 ff ff       	call   80100610 <panic>
801014bd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801014c0:	89 f8                	mov    %edi,%eax
801014c2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801014c5:	74 05                	je     801014cc <filewrite+0xec>
801014c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801014cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014cf:	5b                   	pop    %ebx
801014d0:	5e                   	pop    %esi
801014d1:	5f                   	pop    %edi
801014d2:	5d                   	pop    %ebp
801014d3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801014d4:	8b 46 0c             	mov    0xc(%esi),%eax
801014d7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801014da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014dd:	5b                   	pop    %ebx
801014de:	5e                   	pop    %esi
801014df:	5f                   	pop    %edi
801014e0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801014e1:	e9 0a 24 00 00       	jmp    801038f0 <pipewrite>
  panic("filewrite");
801014e6:	83 ec 0c             	sub    $0xc,%esp
801014e9:	68 e5 74 10 80       	push   $0x801074e5
801014ee:	e8 1d f1 ff ff       	call   80100610 <panic>
801014f3:	66 90                	xchg   %ax,%ax
801014f5:	66 90                	xchg   %ax,%ax
801014f7:	66 90                	xchg   %ax,%ax
801014f9:	66 90                	xchg   %ax,%ax
801014fb:	66 90                	xchg   %ax,%ax
801014fd:	66 90                	xchg   %ax,%ax
801014ff:	90                   	nop

80101500 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101500:	55                   	push   %ebp
80101501:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101503:	89 d0                	mov    %edx,%eax
80101505:	c1 e8 0c             	shr    $0xc,%eax
80101508:	03 05 38 0a 11 80    	add    0x80110a38,%eax
{
8010150e:	89 e5                	mov    %esp,%ebp
80101510:	56                   	push   %esi
80101511:	53                   	push   %ebx
80101512:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101514:	83 ec 08             	sub    $0x8,%esp
80101517:	50                   	push   %eax
80101518:	51                   	push   %ecx
80101519:	e8 b2 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010151e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101520:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101523:	ba 01 00 00 00       	mov    $0x1,%edx
80101528:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010152b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101531:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101534:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101536:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010153b:	85 d1                	test   %edx,%ecx
8010153d:	74 25                	je     80101564 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010153f:	f7 d2                	not    %edx
  log_write(bp);
80101541:	83 ec 0c             	sub    $0xc,%esp
80101544:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101546:	21 ca                	and    %ecx,%edx
80101548:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010154c:	50                   	push   %eax
8010154d:	e8 0e 1d 00 00       	call   80103260 <log_write>
  brelse(bp);
80101552:	89 34 24             	mov    %esi,(%esp)
80101555:	e8 96 ec ff ff       	call   801001f0 <brelse>
}
8010155a:	83 c4 10             	add    $0x10,%esp
8010155d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101560:	5b                   	pop    %ebx
80101561:	5e                   	pop    %esi
80101562:	5d                   	pop    %ebp
80101563:	c3                   	ret    
    panic("freeing free block");
80101564:	83 ec 0c             	sub    $0xc,%esp
80101567:	68 ef 74 10 80       	push   $0x801074ef
8010156c:	e8 9f f0 ff ff       	call   80100610 <panic>
80101571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101578:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010157f:	90                   	nop

80101580 <balloc>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	57                   	push   %edi
80101584:	56                   	push   %esi
80101585:	53                   	push   %ebx
80101586:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101589:	8b 0d 20 0a 11 80    	mov    0x80110a20,%ecx
{
8010158f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101592:	85 c9                	test   %ecx,%ecx
80101594:	0f 84 87 00 00 00    	je     80101621 <balloc+0xa1>
8010159a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801015a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801015a4:	83 ec 08             	sub    $0x8,%esp
801015a7:	89 f0                	mov    %esi,%eax
801015a9:	c1 f8 0c             	sar    $0xc,%eax
801015ac:	03 05 38 0a 11 80    	add    0x80110a38,%eax
801015b2:	50                   	push   %eax
801015b3:	ff 75 d8             	pushl  -0x28(%ebp)
801015b6:	e8 15 eb ff ff       	call   801000d0 <bread>
801015bb:	83 c4 10             	add    $0x10,%esp
801015be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015c1:	a1 20 0a 11 80       	mov    0x80110a20,%eax
801015c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801015c9:	31 c0                	xor    %eax,%eax
801015cb:	eb 2f                	jmp    801015fc <balloc+0x7c>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801015d0:	89 c1                	mov    %eax,%ecx
801015d2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801015da:	83 e1 07             	and    $0x7,%ecx
801015dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015df:	89 c1                	mov    %eax,%ecx
801015e1:	c1 f9 03             	sar    $0x3,%ecx
801015e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801015e9:	89 fa                	mov    %edi,%edx
801015eb:	85 df                	test   %ebx,%edi
801015ed:	74 41                	je     80101630 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015ef:	83 c0 01             	add    $0x1,%eax
801015f2:	83 c6 01             	add    $0x1,%esi
801015f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801015fa:	74 05                	je     80101601 <balloc+0x81>
801015fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801015ff:	77 cf                	ja     801015d0 <balloc+0x50>
    brelse(bp);
80101601:	83 ec 0c             	sub    $0xc,%esp
80101604:	ff 75 e4             	pushl  -0x1c(%ebp)
80101607:	e8 e4 eb ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010160c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101613:	83 c4 10             	add    $0x10,%esp
80101616:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101619:	39 05 20 0a 11 80    	cmp    %eax,0x80110a20
8010161f:	77 80                	ja     801015a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101621:	83 ec 0c             	sub    $0xc,%esp
80101624:	68 02 75 10 80       	push   $0x80107502
80101629:	e8 e2 ef ff ff       	call   80100610 <panic>
8010162e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101630:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101633:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101636:	09 da                	or     %ebx,%edx
80101638:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010163c:	57                   	push   %edi
8010163d:	e8 1e 1c 00 00       	call   80103260 <log_write>
        brelse(bp);
80101642:	89 3c 24             	mov    %edi,(%esp)
80101645:	e8 a6 eb ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010164a:	58                   	pop    %eax
8010164b:	5a                   	pop    %edx
8010164c:	56                   	push   %esi
8010164d:	ff 75 d8             	pushl  -0x28(%ebp)
80101650:	e8 7b ea ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101655:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101658:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010165a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010165d:	68 00 02 00 00       	push   $0x200
80101662:	6a 00                	push   $0x0
80101664:	50                   	push   %eax
80101665:	e8 56 33 00 00       	call   801049c0 <memset>
  log_write(bp);
8010166a:	89 1c 24             	mov    %ebx,(%esp)
8010166d:	e8 ee 1b 00 00       	call   80103260 <log_write>
  brelse(bp);
80101672:	89 1c 24             	mov    %ebx,(%esp)
80101675:	e8 76 eb ff ff       	call   801001f0 <brelse>
}
8010167a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010167d:	89 f0                	mov    %esi,%eax
8010167f:	5b                   	pop    %ebx
80101680:	5e                   	pop    %esi
80101681:	5f                   	pop    %edi
80101682:	5d                   	pop    %ebp
80101683:	c3                   	ret    
80101684:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010168b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010168f:	90                   	nop

80101690 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	57                   	push   %edi
80101694:	89 c7                	mov    %eax,%edi
80101696:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101697:	31 f6                	xor    %esi,%esi
{
80101699:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010169a:	bb 74 0a 11 80       	mov    $0x80110a74,%ebx
{
8010169f:	83 ec 28             	sub    $0x28,%esp
801016a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801016a5:	68 40 0a 11 80       	push   $0x80110a40
801016aa:	e8 01 32 00 00       	call   801048b0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801016b2:	83 c4 10             	add    $0x10,%esp
801016b5:	eb 1b                	jmp    801016d2 <iget+0x42>
801016b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016be:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801016c0:	39 3b                	cmp    %edi,(%ebx)
801016c2:	74 6c                	je     80101730 <iget+0xa0>
801016c4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016ca:	81 fb 94 26 11 80    	cmp    $0x80112694,%ebx
801016d0:	73 26                	jae    801016f8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801016d2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801016d5:	85 c9                	test   %ecx,%ecx
801016d7:	7f e7                	jg     801016c0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801016d9:	85 f6                	test   %esi,%esi
801016db:	75 e7                	jne    801016c4 <iget+0x34>
801016dd:	89 d8                	mov    %ebx,%eax
801016df:	81 c3 90 00 00 00    	add    $0x90,%ebx
801016e5:	85 c9                	test   %ecx,%ecx
801016e7:	75 6e                	jne    80101757 <iget+0xc7>
801016e9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016eb:	81 fb 94 26 11 80    	cmp    $0x80112694,%ebx
801016f1:	72 df                	jb     801016d2 <iget+0x42>
801016f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801016f7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801016f8:	85 f6                	test   %esi,%esi
801016fa:	74 73                	je     8010176f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801016fc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801016ff:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101701:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101704:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010170b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101712:	68 40 0a 11 80       	push   $0x80110a40
80101717:	e8 54 32 00 00       	call   80104970 <release>

  return ip;
8010171c:	83 c4 10             	add    $0x10,%esp
}
8010171f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101722:	89 f0                	mov    %esi,%eax
80101724:	5b                   	pop    %ebx
80101725:	5e                   	pop    %esi
80101726:	5f                   	pop    %edi
80101727:	5d                   	pop    %ebp
80101728:	c3                   	ret    
80101729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101730:	39 53 04             	cmp    %edx,0x4(%ebx)
80101733:	75 8f                	jne    801016c4 <iget+0x34>
      release(&icache.lock);
80101735:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101738:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010173b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010173d:	68 40 0a 11 80       	push   $0x80110a40
      ip->ref++;
80101742:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101745:	e8 26 32 00 00       	call   80104970 <release>
      return ip;
8010174a:	83 c4 10             	add    $0x10,%esp
}
8010174d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101750:	89 f0                	mov    %esi,%eax
80101752:	5b                   	pop    %ebx
80101753:	5e                   	pop    %esi
80101754:	5f                   	pop    %edi
80101755:	5d                   	pop    %ebp
80101756:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101757:	81 fb 94 26 11 80    	cmp    $0x80112694,%ebx
8010175d:	73 10                	jae    8010176f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010175f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101762:	85 c9                	test   %ecx,%ecx
80101764:	0f 8f 56 ff ff ff    	jg     801016c0 <iget+0x30>
8010176a:	e9 6e ff ff ff       	jmp    801016dd <iget+0x4d>
    panic("iget: no inodes");
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	68 18 75 10 80       	push   $0x80107518
80101777:	e8 94 ee ff ff       	call   80100610 <panic>
8010177c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101780 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	57                   	push   %edi
80101784:	56                   	push   %esi
80101785:	89 c6                	mov    %eax,%esi
80101787:	53                   	push   %ebx
80101788:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010178b:	83 fa 0b             	cmp    $0xb,%edx
8010178e:	0f 86 84 00 00 00    	jbe    80101818 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101794:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101797:	83 fb 7f             	cmp    $0x7f,%ebx
8010179a:	0f 87 98 00 00 00    	ja     80101838 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801017a0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801017a6:	8b 16                	mov    (%esi),%edx
801017a8:	85 c0                	test   %eax,%eax
801017aa:	74 54                	je     80101800 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801017ac:	83 ec 08             	sub    $0x8,%esp
801017af:	50                   	push   %eax
801017b0:	52                   	push   %edx
801017b1:	e8 1a e9 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801017b6:	83 c4 10             	add    $0x10,%esp
801017b9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801017bd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801017bf:	8b 1a                	mov    (%edx),%ebx
801017c1:	85 db                	test   %ebx,%ebx
801017c3:	74 1b                	je     801017e0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801017c5:	83 ec 0c             	sub    $0xc,%esp
801017c8:	57                   	push   %edi
801017c9:	e8 22 ea ff ff       	call   801001f0 <brelse>
    return addr;
801017ce:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801017d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017d4:	89 d8                	mov    %ebx,%eax
801017d6:	5b                   	pop    %ebx
801017d7:	5e                   	pop    %esi
801017d8:	5f                   	pop    %edi
801017d9:	5d                   	pop    %ebp
801017da:	c3                   	ret    
801017db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017df:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801017e0:	8b 06                	mov    (%esi),%eax
801017e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801017e5:	e8 96 fd ff ff       	call   80101580 <balloc>
801017ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801017ed:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801017f0:	89 c3                	mov    %eax,%ebx
801017f2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801017f4:	57                   	push   %edi
801017f5:	e8 66 1a 00 00       	call   80103260 <log_write>
801017fa:	83 c4 10             	add    $0x10,%esp
801017fd:	eb c6                	jmp    801017c5 <bmap+0x45>
801017ff:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101800:	89 d0                	mov    %edx,%eax
80101802:	e8 79 fd ff ff       	call   80101580 <balloc>
80101807:	8b 16                	mov    (%esi),%edx
80101809:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010180f:	eb 9b                	jmp    801017ac <bmap+0x2c>
80101811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101818:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010181b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010181e:	85 db                	test   %ebx,%ebx
80101820:	75 af                	jne    801017d1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101822:	8b 00                	mov    (%eax),%eax
80101824:	e8 57 fd ff ff       	call   80101580 <balloc>
80101829:	89 47 5c             	mov    %eax,0x5c(%edi)
8010182c:	89 c3                	mov    %eax,%ebx
}
8010182e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101831:	89 d8                	mov    %ebx,%eax
80101833:	5b                   	pop    %ebx
80101834:	5e                   	pop    %esi
80101835:	5f                   	pop    %edi
80101836:	5d                   	pop    %ebp
80101837:	c3                   	ret    
  panic("bmap: out of range");
80101838:	83 ec 0c             	sub    $0xc,%esp
8010183b:	68 28 75 10 80       	push   $0x80107528
80101840:	e8 cb ed ff ff       	call   80100610 <panic>
80101845:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101850 <readsb>:
{
80101850:	f3 0f 1e fb          	endbr32 
80101854:	55                   	push   %ebp
80101855:	89 e5                	mov    %esp,%ebp
80101857:	56                   	push   %esi
80101858:	53                   	push   %ebx
80101859:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010185c:	83 ec 08             	sub    $0x8,%esp
8010185f:	6a 01                	push   $0x1
80101861:	ff 75 08             	pushl  0x8(%ebp)
80101864:	e8 67 e8 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101869:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010186c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010186e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101871:	6a 1c                	push   $0x1c
80101873:	50                   	push   %eax
80101874:	56                   	push   %esi
80101875:	e8 e6 31 00 00       	call   80104a60 <memmove>
  brelse(bp);
8010187a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010187d:	83 c4 10             	add    $0x10,%esp
}
80101880:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101883:	5b                   	pop    %ebx
80101884:	5e                   	pop    %esi
80101885:	5d                   	pop    %ebp
  brelse(bp);
80101886:	e9 65 e9 ff ff       	jmp    801001f0 <brelse>
8010188b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010188f:	90                   	nop

80101890 <iinit>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	53                   	push   %ebx
80101898:	bb 80 0a 11 80       	mov    $0x80110a80,%ebx
8010189d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801018a0:	68 3b 75 10 80       	push   $0x8010753b
801018a5:	68 40 0a 11 80       	push   $0x80110a40
801018aa:	e8 81 2e 00 00       	call   80104730 <initlock>
  for(i = 0; i < NINODE; i++) {
801018af:	83 c4 10             	add    $0x10,%esp
801018b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
801018b8:	83 ec 08             	sub    $0x8,%esp
801018bb:	68 42 75 10 80       	push   $0x80107542
801018c0:	53                   	push   %ebx
801018c1:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018c7:	e8 24 2d 00 00       	call   801045f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801018cc:	83 c4 10             	add    $0x10,%esp
801018cf:	81 fb a0 26 11 80    	cmp    $0x801126a0,%ebx
801018d5:	75 e1                	jne    801018b8 <iinit+0x28>
  readsb(dev, &sb);
801018d7:	83 ec 08             	sub    $0x8,%esp
801018da:	68 20 0a 11 80       	push   $0x80110a20
801018df:	ff 75 08             	pushl  0x8(%ebp)
801018e2:	e8 69 ff ff ff       	call   80101850 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801018e7:	ff 35 38 0a 11 80    	pushl  0x80110a38
801018ed:	ff 35 34 0a 11 80    	pushl  0x80110a34
801018f3:	ff 35 30 0a 11 80    	pushl  0x80110a30
801018f9:	ff 35 2c 0a 11 80    	pushl  0x80110a2c
801018ff:	ff 35 28 0a 11 80    	pushl  0x80110a28
80101905:	ff 35 24 0a 11 80    	pushl  0x80110a24
8010190b:	ff 35 20 0a 11 80    	pushl  0x80110a20
80101911:	68 a8 75 10 80       	push   $0x801075a8
80101916:	e8 75 ed ff ff       	call   80100690 <cprintf>
}
8010191b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010191e:	83 c4 30             	add    $0x30,%esp
80101921:	c9                   	leave  
80101922:	c3                   	ret    
80101923:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010192a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101930 <ialloc>:
{
80101930:	f3 0f 1e fb          	endbr32 
80101934:	55                   	push   %ebp
80101935:	89 e5                	mov    %esp,%ebp
80101937:	57                   	push   %edi
80101938:	56                   	push   %esi
80101939:	53                   	push   %ebx
8010193a:	83 ec 1c             	sub    $0x1c,%esp
8010193d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101940:	83 3d 28 0a 11 80 01 	cmpl   $0x1,0x80110a28
{
80101947:	8b 75 08             	mov    0x8(%ebp),%esi
8010194a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010194d:	0f 86 8d 00 00 00    	jbe    801019e0 <ialloc+0xb0>
80101953:	bf 01 00 00 00       	mov    $0x1,%edi
80101958:	eb 1d                	jmp    80101977 <ialloc+0x47>
8010195a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101960:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101963:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101966:	53                   	push   %ebx
80101967:	e8 84 e8 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010196c:	83 c4 10             	add    $0x10,%esp
8010196f:	3b 3d 28 0a 11 80    	cmp    0x80110a28,%edi
80101975:	73 69                	jae    801019e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101977:	89 f8                	mov    %edi,%eax
80101979:	83 ec 08             	sub    $0x8,%esp
8010197c:	c1 e8 03             	shr    $0x3,%eax
8010197f:	03 05 34 0a 11 80    	add    0x80110a34,%eax
80101985:	50                   	push   %eax
80101986:	56                   	push   %esi
80101987:	e8 44 e7 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010198c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010198f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101991:	89 f8                	mov    %edi,%eax
80101993:	83 e0 07             	and    $0x7,%eax
80101996:	c1 e0 06             	shl    $0x6,%eax
80101999:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010199d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801019a1:	75 bd                	jne    80101960 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801019a3:	83 ec 04             	sub    $0x4,%esp
801019a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801019a9:	6a 40                	push   $0x40
801019ab:	6a 00                	push   $0x0
801019ad:	51                   	push   %ecx
801019ae:	e8 0d 30 00 00       	call   801049c0 <memset>
      dip->type = type;
801019b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801019b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801019ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801019bd:	89 1c 24             	mov    %ebx,(%esp)
801019c0:	e8 9b 18 00 00       	call   80103260 <log_write>
      brelse(bp);
801019c5:	89 1c 24             	mov    %ebx,(%esp)
801019c8:	e8 23 e8 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801019cd:	83 c4 10             	add    $0x10,%esp
}
801019d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801019d3:	89 fa                	mov    %edi,%edx
}
801019d5:	5b                   	pop    %ebx
      return iget(dev, inum);
801019d6:	89 f0                	mov    %esi,%eax
}
801019d8:	5e                   	pop    %esi
801019d9:	5f                   	pop    %edi
801019da:	5d                   	pop    %ebp
      return iget(dev, inum);
801019db:	e9 b0 fc ff ff       	jmp    80101690 <iget>
  panic("ialloc: no inodes");
801019e0:	83 ec 0c             	sub    $0xc,%esp
801019e3:	68 48 75 10 80       	push   $0x80107548
801019e8:	e8 23 ec ff ff       	call   80100610 <panic>
801019ed:	8d 76 00             	lea    0x0(%esi),%esi

801019f0 <iupdate>:
{
801019f0:	f3 0f 1e fb          	endbr32 
801019f4:	55                   	push   %ebp
801019f5:	89 e5                	mov    %esp,%ebp
801019f7:	56                   	push   %esi
801019f8:	53                   	push   %ebx
801019f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019fc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019ff:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a02:	83 ec 08             	sub    $0x8,%esp
80101a05:	c1 e8 03             	shr    $0x3,%eax
80101a08:	03 05 34 0a 11 80    	add    0x80110a34,%eax
80101a0e:	50                   	push   %eax
80101a0f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101a12:	e8 b9 e6 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101a17:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a1b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a1e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a20:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101a23:	83 e0 07             	and    $0x7,%eax
80101a26:	c1 e0 06             	shl    $0x6,%eax
80101a29:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101a2d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101a30:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a34:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101a37:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101a3b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101a3f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101a43:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101a47:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101a4b:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101a4e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a51:	6a 34                	push   $0x34
80101a53:	53                   	push   %ebx
80101a54:	50                   	push   %eax
80101a55:	e8 06 30 00 00       	call   80104a60 <memmove>
  log_write(bp);
80101a5a:	89 34 24             	mov    %esi,(%esp)
80101a5d:	e8 fe 17 00 00       	call   80103260 <log_write>
  brelse(bp);
80101a62:	89 75 08             	mov    %esi,0x8(%ebp)
80101a65:	83 c4 10             	add    $0x10,%esp
}
80101a68:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a6b:	5b                   	pop    %ebx
80101a6c:	5e                   	pop    %esi
80101a6d:	5d                   	pop    %ebp
  brelse(bp);
80101a6e:	e9 7d e7 ff ff       	jmp    801001f0 <brelse>
80101a73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a80 <idup>:
{
80101a80:	f3 0f 1e fb          	endbr32 
80101a84:	55                   	push   %ebp
80101a85:	89 e5                	mov    %esp,%ebp
80101a87:	53                   	push   %ebx
80101a88:	83 ec 10             	sub    $0x10,%esp
80101a8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101a8e:	68 40 0a 11 80       	push   $0x80110a40
80101a93:	e8 18 2e 00 00       	call   801048b0 <acquire>
  ip->ref++;
80101a98:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a9c:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
80101aa3:	e8 c8 2e 00 00       	call   80104970 <release>
}
80101aa8:	89 d8                	mov    %ebx,%eax
80101aaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101aad:	c9                   	leave  
80101aae:	c3                   	ret    
80101aaf:	90                   	nop

80101ab0 <ilock>:
{
80101ab0:	f3 0f 1e fb          	endbr32 
80101ab4:	55                   	push   %ebp
80101ab5:	89 e5                	mov    %esp,%ebp
80101ab7:	56                   	push   %esi
80101ab8:	53                   	push   %ebx
80101ab9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101abc:	85 db                	test   %ebx,%ebx
80101abe:	0f 84 b3 00 00 00    	je     80101b77 <ilock+0xc7>
80101ac4:	8b 53 08             	mov    0x8(%ebx),%edx
80101ac7:	85 d2                	test   %edx,%edx
80101ac9:	0f 8e a8 00 00 00    	jle    80101b77 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101acf:	83 ec 0c             	sub    $0xc,%esp
80101ad2:	8d 43 0c             	lea    0xc(%ebx),%eax
80101ad5:	50                   	push   %eax
80101ad6:	e8 55 2b 00 00       	call   80104630 <acquiresleep>
  if(ip->valid == 0){
80101adb:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101ade:	83 c4 10             	add    $0x10,%esp
80101ae1:	85 c0                	test   %eax,%eax
80101ae3:	74 0b                	je     80101af0 <ilock+0x40>
}
80101ae5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ae8:	5b                   	pop    %ebx
80101ae9:	5e                   	pop    %esi
80101aea:	5d                   	pop    %ebp
80101aeb:	c3                   	ret    
80101aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101af0:	8b 43 04             	mov    0x4(%ebx),%eax
80101af3:	83 ec 08             	sub    $0x8,%esp
80101af6:	c1 e8 03             	shr    $0x3,%eax
80101af9:	03 05 34 0a 11 80    	add    0x80110a34,%eax
80101aff:	50                   	push   %eax
80101b00:	ff 33                	pushl  (%ebx)
80101b02:	e8 c9 e5 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b07:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b0a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b0c:	8b 43 04             	mov    0x4(%ebx),%eax
80101b0f:	83 e0 07             	and    $0x7,%eax
80101b12:	c1 e0 06             	shl    $0x6,%eax
80101b15:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101b19:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b1c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101b1f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101b23:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101b27:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101b2b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101b2f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101b33:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101b37:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101b3b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101b3e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b41:	6a 34                	push   $0x34
80101b43:	50                   	push   %eax
80101b44:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101b47:	50                   	push   %eax
80101b48:	e8 13 2f 00 00       	call   80104a60 <memmove>
    brelse(bp);
80101b4d:	89 34 24             	mov    %esi,(%esp)
80101b50:	e8 9b e6 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101b55:	83 c4 10             	add    $0x10,%esp
80101b58:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101b5d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101b64:	0f 85 7b ff ff ff    	jne    80101ae5 <ilock+0x35>
      panic("ilock: no type");
80101b6a:	83 ec 0c             	sub    $0xc,%esp
80101b6d:	68 60 75 10 80       	push   $0x80107560
80101b72:	e8 99 ea ff ff       	call   80100610 <panic>
    panic("ilock");
80101b77:	83 ec 0c             	sub    $0xc,%esp
80101b7a:	68 5a 75 10 80       	push   $0x8010755a
80101b7f:	e8 8c ea ff ff       	call   80100610 <panic>
80101b84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <iunlock>:
{
80101b90:	f3 0f 1e fb          	endbr32 
80101b94:	55                   	push   %ebp
80101b95:	89 e5                	mov    %esp,%ebp
80101b97:	56                   	push   %esi
80101b98:	53                   	push   %ebx
80101b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b9c:	85 db                	test   %ebx,%ebx
80101b9e:	74 28                	je     80101bc8 <iunlock+0x38>
80101ba0:	83 ec 0c             	sub    $0xc,%esp
80101ba3:	8d 73 0c             	lea    0xc(%ebx),%esi
80101ba6:	56                   	push   %esi
80101ba7:	e8 24 2b 00 00       	call   801046d0 <holdingsleep>
80101bac:	83 c4 10             	add    $0x10,%esp
80101baf:	85 c0                	test   %eax,%eax
80101bb1:	74 15                	je     80101bc8 <iunlock+0x38>
80101bb3:	8b 43 08             	mov    0x8(%ebx),%eax
80101bb6:	85 c0                	test   %eax,%eax
80101bb8:	7e 0e                	jle    80101bc8 <iunlock+0x38>
  releasesleep(&ip->lock);
80101bba:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101bbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101bc0:	5b                   	pop    %ebx
80101bc1:	5e                   	pop    %esi
80101bc2:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101bc3:	e9 c8 2a 00 00       	jmp    80104690 <releasesleep>
    panic("iunlock");
80101bc8:	83 ec 0c             	sub    $0xc,%esp
80101bcb:	68 6f 75 10 80       	push   $0x8010756f
80101bd0:	e8 3b ea ff ff       	call   80100610 <panic>
80101bd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101be0 <iput>:
{
80101be0:	f3 0f 1e fb          	endbr32 
80101be4:	55                   	push   %ebp
80101be5:	89 e5                	mov    %esp,%ebp
80101be7:	57                   	push   %edi
80101be8:	56                   	push   %esi
80101be9:	53                   	push   %ebx
80101bea:	83 ec 28             	sub    $0x28,%esp
80101bed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101bf0:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101bf3:	57                   	push   %edi
80101bf4:	e8 37 2a 00 00       	call   80104630 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101bf9:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101bfc:	83 c4 10             	add    $0x10,%esp
80101bff:	85 d2                	test   %edx,%edx
80101c01:	74 07                	je     80101c0a <iput+0x2a>
80101c03:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101c08:	74 36                	je     80101c40 <iput+0x60>
  releasesleep(&ip->lock);
80101c0a:	83 ec 0c             	sub    $0xc,%esp
80101c0d:	57                   	push   %edi
80101c0e:	e8 7d 2a 00 00       	call   80104690 <releasesleep>
  acquire(&icache.lock);
80101c13:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
80101c1a:	e8 91 2c 00 00       	call   801048b0 <acquire>
  ip->ref--;
80101c1f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c23:	83 c4 10             	add    $0x10,%esp
80101c26:	c7 45 08 40 0a 11 80 	movl   $0x80110a40,0x8(%ebp)
}
80101c2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c30:	5b                   	pop    %ebx
80101c31:	5e                   	pop    %esi
80101c32:	5f                   	pop    %edi
80101c33:	5d                   	pop    %ebp
  release(&icache.lock);
80101c34:	e9 37 2d 00 00       	jmp    80104970 <release>
80101c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101c40:	83 ec 0c             	sub    $0xc,%esp
80101c43:	68 40 0a 11 80       	push   $0x80110a40
80101c48:	e8 63 2c 00 00       	call   801048b0 <acquire>
    int r = ip->ref;
80101c4d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101c50:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
80101c57:	e8 14 2d 00 00       	call   80104970 <release>
    if(r == 1){
80101c5c:	83 c4 10             	add    $0x10,%esp
80101c5f:	83 fe 01             	cmp    $0x1,%esi
80101c62:	75 a6                	jne    80101c0a <iput+0x2a>
80101c64:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101c6a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101c6d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101c70:	89 cf                	mov    %ecx,%edi
80101c72:	eb 0b                	jmp    80101c7f <iput+0x9f>
80101c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c78:	83 c6 04             	add    $0x4,%esi
80101c7b:	39 fe                	cmp    %edi,%esi
80101c7d:	74 19                	je     80101c98 <iput+0xb8>
    if(ip->addrs[i]){
80101c7f:	8b 16                	mov    (%esi),%edx
80101c81:	85 d2                	test   %edx,%edx
80101c83:	74 f3                	je     80101c78 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101c85:	8b 03                	mov    (%ebx),%eax
80101c87:	e8 74 f8 ff ff       	call   80101500 <bfree>
      ip->addrs[i] = 0;
80101c8c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101c92:	eb e4                	jmp    80101c78 <iput+0x98>
80101c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101c98:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101c9e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	75 33                	jne    80101cd8 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101ca5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101ca8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101caf:	53                   	push   %ebx
80101cb0:	e8 3b fd ff ff       	call   801019f0 <iupdate>
      ip->type = 0;
80101cb5:	31 c0                	xor    %eax,%eax
80101cb7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101cbb:	89 1c 24             	mov    %ebx,(%esp)
80101cbe:	e8 2d fd ff ff       	call   801019f0 <iupdate>
      ip->valid = 0;
80101cc3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101cca:	83 c4 10             	add    $0x10,%esp
80101ccd:	e9 38 ff ff ff       	jmp    80101c0a <iput+0x2a>
80101cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cd8:	83 ec 08             	sub    $0x8,%esp
80101cdb:	50                   	push   %eax
80101cdc:	ff 33                	pushl  (%ebx)
80101cde:	e8 ed e3 ff ff       	call   801000d0 <bread>
80101ce3:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ce6:	83 c4 10             	add    $0x10,%esp
80101ce9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101cef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101cf2:	8d 70 5c             	lea    0x5c(%eax),%esi
80101cf5:	89 cf                	mov    %ecx,%edi
80101cf7:	eb 0e                	jmp    80101d07 <iput+0x127>
80101cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d00:	83 c6 04             	add    $0x4,%esi
80101d03:	39 f7                	cmp    %esi,%edi
80101d05:	74 19                	je     80101d20 <iput+0x140>
      if(a[j])
80101d07:	8b 16                	mov    (%esi),%edx
80101d09:	85 d2                	test   %edx,%edx
80101d0b:	74 f3                	je     80101d00 <iput+0x120>
        bfree(ip->dev, a[j]);
80101d0d:	8b 03                	mov    (%ebx),%eax
80101d0f:	e8 ec f7 ff ff       	call   80101500 <bfree>
80101d14:	eb ea                	jmp    80101d00 <iput+0x120>
80101d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d1d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101d20:	83 ec 0c             	sub    $0xc,%esp
80101d23:	ff 75 e4             	pushl  -0x1c(%ebp)
80101d26:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d29:	e8 c2 e4 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d2e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101d34:	8b 03                	mov    (%ebx),%eax
80101d36:	e8 c5 f7 ff ff       	call   80101500 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d3b:	83 c4 10             	add    $0x10,%esp
80101d3e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101d45:	00 00 00 
80101d48:	e9 58 ff ff ff       	jmp    80101ca5 <iput+0xc5>
80101d4d:	8d 76 00             	lea    0x0(%esi),%esi

80101d50 <iunlockput>:
{
80101d50:	f3 0f 1e fb          	endbr32 
80101d54:	55                   	push   %ebp
80101d55:	89 e5                	mov    %esp,%ebp
80101d57:	53                   	push   %ebx
80101d58:	83 ec 10             	sub    $0x10,%esp
80101d5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101d5e:	53                   	push   %ebx
80101d5f:	e8 2c fe ff ff       	call   80101b90 <iunlock>
  iput(ip);
80101d64:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101d67:	83 c4 10             	add    $0x10,%esp
}
80101d6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d6d:	c9                   	leave  
  iput(ip);
80101d6e:	e9 6d fe ff ff       	jmp    80101be0 <iput>
80101d73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101d80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101d80:	f3 0f 1e fb          	endbr32 
80101d84:	55                   	push   %ebp
80101d85:	89 e5                	mov    %esp,%ebp
80101d87:	8b 55 08             	mov    0x8(%ebp),%edx
80101d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101d8d:	8b 0a                	mov    (%edx),%ecx
80101d8f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101d92:	8b 4a 04             	mov    0x4(%edx),%ecx
80101d95:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101d98:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101d9c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101d9f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101da3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101da7:	8b 52 58             	mov    0x58(%edx),%edx
80101daa:	89 50 10             	mov    %edx,0x10(%eax)
}
80101dad:	5d                   	pop    %ebp
80101dae:	c3                   	ret    
80101daf:	90                   	nop

80101db0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101db0:	f3 0f 1e fb          	endbr32 
80101db4:	55                   	push   %ebp
80101db5:	89 e5                	mov    %esp,%ebp
80101db7:	57                   	push   %edi
80101db8:	56                   	push   %esi
80101db9:	53                   	push   %ebx
80101dba:	83 ec 1c             	sub    $0x1c,%esp
80101dbd:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101dc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc3:	8b 75 10             	mov    0x10(%ebp),%esi
80101dc6:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101dc9:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101dcc:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101dd1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101dd4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101dd7:	0f 84 a3 00 00 00    	je     80101e80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ddd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101de0:	8b 40 58             	mov    0x58(%eax),%eax
80101de3:	39 c6                	cmp    %eax,%esi
80101de5:	0f 87 b6 00 00 00    	ja     80101ea1 <readi+0xf1>
80101deb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101dee:	31 c9                	xor    %ecx,%ecx
80101df0:	89 da                	mov    %ebx,%edx
80101df2:	01 f2                	add    %esi,%edx
80101df4:	0f 92 c1             	setb   %cl
80101df7:	89 cf                	mov    %ecx,%edi
80101df9:	0f 82 a2 00 00 00    	jb     80101ea1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101dff:	89 c1                	mov    %eax,%ecx
80101e01:	29 f1                	sub    %esi,%ecx
80101e03:	39 d0                	cmp    %edx,%eax
80101e05:	0f 43 cb             	cmovae %ebx,%ecx
80101e08:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e0b:	85 c9                	test   %ecx,%ecx
80101e0d:	74 63                	je     80101e72 <readi+0xc2>
80101e0f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101e13:	89 f2                	mov    %esi,%edx
80101e15:	c1 ea 09             	shr    $0x9,%edx
80101e18:	89 d8                	mov    %ebx,%eax
80101e1a:	e8 61 f9 ff ff       	call   80101780 <bmap>
80101e1f:	83 ec 08             	sub    $0x8,%esp
80101e22:	50                   	push   %eax
80101e23:	ff 33                	pushl  (%ebx)
80101e25:	e8 a6 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101e2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101e2d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101e32:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e35:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101e37:	89 f0                	mov    %esi,%eax
80101e39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e3e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101e40:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e43:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101e45:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101e49:	39 d9                	cmp    %ebx,%ecx
80101e4b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101e4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e4f:	01 df                	add    %ebx,%edi
80101e51:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101e53:	50                   	push   %eax
80101e54:	ff 75 e0             	pushl  -0x20(%ebp)
80101e57:	e8 04 2c 00 00       	call   80104a60 <memmove>
    brelse(bp);
80101e5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e5f:	89 14 24             	mov    %edx,(%esp)
80101e62:	e8 89 e3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101e6a:	83 c4 10             	add    $0x10,%esp
80101e6d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101e70:	77 9e                	ja     80101e10 <readi+0x60>
  }
  return n;
80101e72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e78:	5b                   	pop    %ebx
80101e79:	5e                   	pop    %esi
80101e7a:	5f                   	pop    %edi
80101e7b:	5d                   	pop    %ebp
80101e7c:	c3                   	ret    
80101e7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e84:	66 83 f8 09          	cmp    $0x9,%ax
80101e88:	77 17                	ja     80101ea1 <readi+0xf1>
80101e8a:	8b 04 c5 c0 09 11 80 	mov    -0x7feef640(,%eax,8),%eax
80101e91:	85 c0                	test   %eax,%eax
80101e93:	74 0c                	je     80101ea1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101e95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e9b:	5b                   	pop    %ebx
80101e9c:	5e                   	pop    %esi
80101e9d:	5f                   	pop    %edi
80101e9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101e9f:	ff e0                	jmp    *%eax
      return -1;
80101ea1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ea6:	eb cd                	jmp    80101e75 <readi+0xc5>
80101ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eaf:	90                   	nop

80101eb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101eb0:	f3 0f 1e fb          	endbr32 
80101eb4:	55                   	push   %ebp
80101eb5:	89 e5                	mov    %esp,%ebp
80101eb7:	57                   	push   %edi
80101eb8:	56                   	push   %esi
80101eb9:	53                   	push   %ebx
80101eba:	83 ec 1c             	sub    $0x1c,%esp
80101ebd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec0:	8b 75 0c             	mov    0xc(%ebp),%esi
80101ec3:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ec6:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ecb:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101ece:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ed1:	8b 75 10             	mov    0x10(%ebp),%esi
80101ed4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ed7:	0f 84 b3 00 00 00    	je     80101f90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101edd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ee0:	39 70 58             	cmp    %esi,0x58(%eax)
80101ee3:	0f 82 e3 00 00 00    	jb     80101fcc <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ee9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101eec:	89 f8                	mov    %edi,%eax
80101eee:	01 f0                	add    %esi,%eax
80101ef0:	0f 82 d6 00 00 00    	jb     80101fcc <writei+0x11c>
80101ef6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101efb:	0f 87 cb 00 00 00    	ja     80101fcc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101f08:	85 ff                	test   %edi,%edi
80101f0a:	74 75                	je     80101f81 <writei+0xd1>
80101f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f10:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101f13:	89 f2                	mov    %esi,%edx
80101f15:	c1 ea 09             	shr    $0x9,%edx
80101f18:	89 f8                	mov    %edi,%eax
80101f1a:	e8 61 f8 ff ff       	call   80101780 <bmap>
80101f1f:	83 ec 08             	sub    $0x8,%esp
80101f22:	50                   	push   %eax
80101f23:	ff 37                	pushl  (%edi)
80101f25:	e8 a6 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101f2a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101f2f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101f32:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f35:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101f37:	89 f0                	mov    %esi,%eax
80101f39:	83 c4 0c             	add    $0xc,%esp
80101f3c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f41:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101f43:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101f47:	39 d9                	cmp    %ebx,%ecx
80101f49:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101f4c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f4d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101f4f:	ff 75 dc             	pushl  -0x24(%ebp)
80101f52:	50                   	push   %eax
80101f53:	e8 08 2b 00 00       	call   80104a60 <memmove>
    log_write(bp);
80101f58:	89 3c 24             	mov    %edi,(%esp)
80101f5b:	e8 00 13 00 00       	call   80103260 <log_write>
    brelse(bp);
80101f60:	89 3c 24             	mov    %edi,(%esp)
80101f63:	e8 88 e2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f68:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101f6b:	83 c4 10             	add    $0x10,%esp
80101f6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f71:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101f74:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101f77:	77 97                	ja     80101f10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101f79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f7c:	3b 70 58             	cmp    0x58(%eax),%esi
80101f7f:	77 37                	ja     80101fb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101f81:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f87:	5b                   	pop    %ebx
80101f88:	5e                   	pop    %esi
80101f89:	5f                   	pop    %edi
80101f8a:	5d                   	pop    %ebp
80101f8b:	c3                   	ret    
80101f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101f94:	66 83 f8 09          	cmp    $0x9,%ax
80101f98:	77 32                	ja     80101fcc <writei+0x11c>
80101f9a:	8b 04 c5 c4 09 11 80 	mov    -0x7feef63c(,%eax,8),%eax
80101fa1:	85 c0                	test   %eax,%eax
80101fa3:	74 27                	je     80101fcc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101fa5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fab:	5b                   	pop    %ebx
80101fac:	5e                   	pop    %esi
80101fad:	5f                   	pop    %edi
80101fae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101faf:	ff e0                	jmp    *%eax
80101fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101fb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101fbb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101fbe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101fc1:	50                   	push   %eax
80101fc2:	e8 29 fa ff ff       	call   801019f0 <iupdate>
80101fc7:	83 c4 10             	add    $0x10,%esp
80101fca:	eb b5                	jmp    80101f81 <writei+0xd1>
      return -1;
80101fcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fd1:	eb b1                	jmp    80101f84 <writei+0xd4>
80101fd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101fe0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101fe0:	f3 0f 1e fb          	endbr32 
80101fe4:	55                   	push   %ebp
80101fe5:	89 e5                	mov    %esp,%ebp
80101fe7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101fea:	6a 0e                	push   $0xe
80101fec:	ff 75 0c             	pushl  0xc(%ebp)
80101fef:	ff 75 08             	pushl  0x8(%ebp)
80101ff2:	e8 d9 2a 00 00       	call   80104ad0 <strncmp>
}
80101ff7:	c9                   	leave  
80101ff8:	c3                   	ret    
80101ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102000 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102000:	f3 0f 1e fb          	endbr32 
80102004:	55                   	push   %ebp
80102005:	89 e5                	mov    %esp,%ebp
80102007:	57                   	push   %edi
80102008:	56                   	push   %esi
80102009:	53                   	push   %ebx
8010200a:	83 ec 1c             	sub    $0x1c,%esp
8010200d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102010:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102015:	0f 85 89 00 00 00    	jne    801020a4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010201b:	8b 53 58             	mov    0x58(%ebx),%edx
8010201e:	31 ff                	xor    %edi,%edi
80102020:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102023:	85 d2                	test   %edx,%edx
80102025:	74 42                	je     80102069 <dirlookup+0x69>
80102027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010202e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102030:	6a 10                	push   $0x10
80102032:	57                   	push   %edi
80102033:	56                   	push   %esi
80102034:	53                   	push   %ebx
80102035:	e8 76 fd ff ff       	call   80101db0 <readi>
8010203a:	83 c4 10             	add    $0x10,%esp
8010203d:	83 f8 10             	cmp    $0x10,%eax
80102040:	75 55                	jne    80102097 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80102042:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102047:	74 18                	je     80102061 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80102049:	83 ec 04             	sub    $0x4,%esp
8010204c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010204f:	6a 0e                	push   $0xe
80102051:	50                   	push   %eax
80102052:	ff 75 0c             	pushl  0xc(%ebp)
80102055:	e8 76 2a 00 00       	call   80104ad0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
8010205a:	83 c4 10             	add    $0x10,%esp
8010205d:	85 c0                	test   %eax,%eax
8010205f:	74 17                	je     80102078 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102061:	83 c7 10             	add    $0x10,%edi
80102064:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102067:	72 c7                	jb     80102030 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102069:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010206c:	31 c0                	xor    %eax,%eax
}
8010206e:	5b                   	pop    %ebx
8010206f:	5e                   	pop    %esi
80102070:	5f                   	pop    %edi
80102071:	5d                   	pop    %ebp
80102072:	c3                   	ret    
80102073:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102077:	90                   	nop
      if(poff)
80102078:	8b 45 10             	mov    0x10(%ebp),%eax
8010207b:	85 c0                	test   %eax,%eax
8010207d:	74 05                	je     80102084 <dirlookup+0x84>
        *poff = off;
8010207f:	8b 45 10             	mov    0x10(%ebp),%eax
80102082:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80102084:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102088:	8b 03                	mov    (%ebx),%eax
8010208a:	e8 01 f6 ff ff       	call   80101690 <iget>
}
8010208f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102092:	5b                   	pop    %ebx
80102093:	5e                   	pop    %esi
80102094:	5f                   	pop    %edi
80102095:	5d                   	pop    %ebp
80102096:	c3                   	ret    
      panic("dirlookup read");
80102097:	83 ec 0c             	sub    $0xc,%esp
8010209a:	68 89 75 10 80       	push   $0x80107589
8010209f:	e8 6c e5 ff ff       	call   80100610 <panic>
    panic("dirlookup not DIR");
801020a4:	83 ec 0c             	sub    $0xc,%esp
801020a7:	68 77 75 10 80       	push   $0x80107577
801020ac:	e8 5f e5 ff ff       	call   80100610 <panic>
801020b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bf:	90                   	nop

801020c0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	89 c3                	mov    %eax,%ebx
801020c8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801020cb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801020ce:	89 55 e0             	mov    %edx,-0x20(%ebp)
801020d1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801020d4:	0f 84 86 01 00 00    	je     80102260 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801020da:	e8 d1 1b 00 00       	call   80103cb0 <myproc>
  acquire(&icache.lock);
801020df:	83 ec 0c             	sub    $0xc,%esp
801020e2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
801020e4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801020e7:	68 40 0a 11 80       	push   $0x80110a40
801020ec:	e8 bf 27 00 00       	call   801048b0 <acquire>
  ip->ref++;
801020f1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801020f5:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
801020fc:	e8 6f 28 00 00       	call   80104970 <release>
80102101:	83 c4 10             	add    $0x10,%esp
80102104:	eb 0d                	jmp    80102113 <namex+0x53>
80102106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80102110:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102113:	0f b6 07             	movzbl (%edi),%eax
80102116:	3c 2f                	cmp    $0x2f,%al
80102118:	74 f6                	je     80102110 <namex+0x50>
  if(*path == 0)
8010211a:	84 c0                	test   %al,%al
8010211c:	0f 84 ee 00 00 00    	je     80102210 <namex+0x150>
  while(*path != '/' && *path != 0)
80102122:	0f b6 07             	movzbl (%edi),%eax
80102125:	84 c0                	test   %al,%al
80102127:	0f 84 fb 00 00 00    	je     80102228 <namex+0x168>
8010212d:	89 fb                	mov    %edi,%ebx
8010212f:	3c 2f                	cmp    $0x2f,%al
80102131:	0f 84 f1 00 00 00    	je     80102228 <namex+0x168>
80102137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010213e:	66 90                	xchg   %ax,%ax
80102140:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80102144:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80102147:	3c 2f                	cmp    $0x2f,%al
80102149:	74 04                	je     8010214f <namex+0x8f>
8010214b:	84 c0                	test   %al,%al
8010214d:	75 f1                	jne    80102140 <namex+0x80>
  len = path - s;
8010214f:	89 d8                	mov    %ebx,%eax
80102151:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80102153:	83 f8 0d             	cmp    $0xd,%eax
80102156:	0f 8e 84 00 00 00    	jle    801021e0 <namex+0x120>
    memmove(name, s, DIRSIZ);
8010215c:	83 ec 04             	sub    $0x4,%esp
8010215f:	6a 0e                	push   $0xe
80102161:	57                   	push   %edi
    path++;
80102162:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80102164:	ff 75 e4             	pushl  -0x1c(%ebp)
80102167:	e8 f4 28 00 00       	call   80104a60 <memmove>
8010216c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010216f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102172:	75 0c                	jne    80102180 <namex+0xc0>
80102174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102178:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
8010217b:	80 3f 2f             	cmpb   $0x2f,(%edi)
8010217e:	74 f8                	je     80102178 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102180:	83 ec 0c             	sub    $0xc,%esp
80102183:	56                   	push   %esi
80102184:	e8 27 f9 ff ff       	call   80101ab0 <ilock>
    if(ip->type != T_DIR){
80102189:	83 c4 10             	add    $0x10,%esp
8010218c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102191:	0f 85 a1 00 00 00    	jne    80102238 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102197:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010219a:	85 d2                	test   %edx,%edx
8010219c:	74 09                	je     801021a7 <namex+0xe7>
8010219e:	80 3f 00             	cmpb   $0x0,(%edi)
801021a1:	0f 84 d9 00 00 00    	je     80102280 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801021a7:	83 ec 04             	sub    $0x4,%esp
801021aa:	6a 00                	push   $0x0
801021ac:	ff 75 e4             	pushl  -0x1c(%ebp)
801021af:	56                   	push   %esi
801021b0:	e8 4b fe ff ff       	call   80102000 <dirlookup>
801021b5:	83 c4 10             	add    $0x10,%esp
801021b8:	89 c3                	mov    %eax,%ebx
801021ba:	85 c0                	test   %eax,%eax
801021bc:	74 7a                	je     80102238 <namex+0x178>
  iunlock(ip);
801021be:	83 ec 0c             	sub    $0xc,%esp
801021c1:	56                   	push   %esi
801021c2:	e8 c9 f9 ff ff       	call   80101b90 <iunlock>
  iput(ip);
801021c7:	89 34 24             	mov    %esi,(%esp)
801021ca:	89 de                	mov    %ebx,%esi
801021cc:	e8 0f fa ff ff       	call   80101be0 <iput>
801021d1:	83 c4 10             	add    $0x10,%esp
801021d4:	e9 3a ff ff ff       	jmp    80102113 <namex+0x53>
801021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801021e3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801021e6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
801021e9:	83 ec 04             	sub    $0x4,%esp
801021ec:	50                   	push   %eax
801021ed:	57                   	push   %edi
    name[len] = 0;
801021ee:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
801021f0:	ff 75 e4             	pushl  -0x1c(%ebp)
801021f3:	e8 68 28 00 00       	call   80104a60 <memmove>
    name[len] = 0;
801021f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801021fb:	83 c4 10             	add    $0x10,%esp
801021fe:	c6 00 00             	movb   $0x0,(%eax)
80102201:	e9 69 ff ff ff       	jmp    8010216f <namex+0xaf>
80102206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010220d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102210:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102213:	85 c0                	test   %eax,%eax
80102215:	0f 85 85 00 00 00    	jne    801022a0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010221b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010221e:	89 f0                	mov    %esi,%eax
80102220:	5b                   	pop    %ebx
80102221:	5e                   	pop    %esi
80102222:	5f                   	pop    %edi
80102223:	5d                   	pop    %ebp
80102224:	c3                   	ret    
80102225:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102228:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010222b:	89 fb                	mov    %edi,%ebx
8010222d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102230:	31 c0                	xor    %eax,%eax
80102232:	eb b5                	jmp    801021e9 <namex+0x129>
80102234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102238:	83 ec 0c             	sub    $0xc,%esp
8010223b:	56                   	push   %esi
8010223c:	e8 4f f9 ff ff       	call   80101b90 <iunlock>
  iput(ip);
80102241:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102244:	31 f6                	xor    %esi,%esi
  iput(ip);
80102246:	e8 95 f9 ff ff       	call   80101be0 <iput>
      return 0;
8010224b:	83 c4 10             	add    $0x10,%esp
}
8010224e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102251:	89 f0                	mov    %esi,%eax
80102253:	5b                   	pop    %ebx
80102254:	5e                   	pop    %esi
80102255:	5f                   	pop    %edi
80102256:	5d                   	pop    %ebp
80102257:	c3                   	ret    
80102258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010225f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80102260:	ba 01 00 00 00       	mov    $0x1,%edx
80102265:	b8 01 00 00 00       	mov    $0x1,%eax
8010226a:	89 df                	mov    %ebx,%edi
8010226c:	e8 1f f4 ff ff       	call   80101690 <iget>
80102271:	89 c6                	mov    %eax,%esi
80102273:	e9 9b fe ff ff       	jmp    80102113 <namex+0x53>
80102278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop
      iunlock(ip);
80102280:	83 ec 0c             	sub    $0xc,%esp
80102283:	56                   	push   %esi
80102284:	e8 07 f9 ff ff       	call   80101b90 <iunlock>
      return ip;
80102289:	83 c4 10             	add    $0x10,%esp
}
8010228c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010228f:	89 f0                	mov    %esi,%eax
80102291:	5b                   	pop    %ebx
80102292:	5e                   	pop    %esi
80102293:	5f                   	pop    %edi
80102294:	5d                   	pop    %ebp
80102295:	c3                   	ret    
80102296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010229d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
801022a0:	83 ec 0c             	sub    $0xc,%esp
801022a3:	56                   	push   %esi
    return 0;
801022a4:	31 f6                	xor    %esi,%esi
    iput(ip);
801022a6:	e8 35 f9 ff ff       	call   80101be0 <iput>
    return 0;
801022ab:	83 c4 10             	add    $0x10,%esp
801022ae:	e9 68 ff ff ff       	jmp    8010221b <namex+0x15b>
801022b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022c0 <dirlink>:
{
801022c0:	f3 0f 1e fb          	endbr32 
801022c4:	55                   	push   %ebp
801022c5:	89 e5                	mov    %esp,%ebp
801022c7:	57                   	push   %edi
801022c8:	56                   	push   %esi
801022c9:	53                   	push   %ebx
801022ca:	83 ec 20             	sub    $0x20,%esp
801022cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801022d0:	6a 00                	push   $0x0
801022d2:	ff 75 0c             	pushl  0xc(%ebp)
801022d5:	53                   	push   %ebx
801022d6:	e8 25 fd ff ff       	call   80102000 <dirlookup>
801022db:	83 c4 10             	add    $0x10,%esp
801022de:	85 c0                	test   %eax,%eax
801022e0:	75 6b                	jne    8010234d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
801022e2:	8b 7b 58             	mov    0x58(%ebx),%edi
801022e5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801022e8:	85 ff                	test   %edi,%edi
801022ea:	74 2d                	je     80102319 <dirlink+0x59>
801022ec:	31 ff                	xor    %edi,%edi
801022ee:	8d 75 d8             	lea    -0x28(%ebp),%esi
801022f1:	eb 0d                	jmp    80102300 <dirlink+0x40>
801022f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022f7:	90                   	nop
801022f8:	83 c7 10             	add    $0x10,%edi
801022fb:	3b 7b 58             	cmp    0x58(%ebx),%edi
801022fe:	73 19                	jae    80102319 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102300:	6a 10                	push   $0x10
80102302:	57                   	push   %edi
80102303:	56                   	push   %esi
80102304:	53                   	push   %ebx
80102305:	e8 a6 fa ff ff       	call   80101db0 <readi>
8010230a:	83 c4 10             	add    $0x10,%esp
8010230d:	83 f8 10             	cmp    $0x10,%eax
80102310:	75 4e                	jne    80102360 <dirlink+0xa0>
    if(de.inum == 0)
80102312:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102317:	75 df                	jne    801022f8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102319:	83 ec 04             	sub    $0x4,%esp
8010231c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010231f:	6a 0e                	push   $0xe
80102321:	ff 75 0c             	pushl  0xc(%ebp)
80102324:	50                   	push   %eax
80102325:	e8 f6 27 00 00       	call   80104b20 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010232a:	6a 10                	push   $0x10
  de.inum = inum;
8010232c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010232f:	57                   	push   %edi
80102330:	56                   	push   %esi
80102331:	53                   	push   %ebx
  de.inum = inum;
80102332:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102336:	e8 75 fb ff ff       	call   80101eb0 <writei>
8010233b:	83 c4 20             	add    $0x20,%esp
8010233e:	83 f8 10             	cmp    $0x10,%eax
80102341:	75 2a                	jne    8010236d <dirlink+0xad>
  return 0;
80102343:	31 c0                	xor    %eax,%eax
}
80102345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102348:	5b                   	pop    %ebx
80102349:	5e                   	pop    %esi
8010234a:	5f                   	pop    %edi
8010234b:	5d                   	pop    %ebp
8010234c:	c3                   	ret    
    iput(ip);
8010234d:	83 ec 0c             	sub    $0xc,%esp
80102350:	50                   	push   %eax
80102351:	e8 8a f8 ff ff       	call   80101be0 <iput>
    return -1;
80102356:	83 c4 10             	add    $0x10,%esp
80102359:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010235e:	eb e5                	jmp    80102345 <dirlink+0x85>
      panic("dirlink read");
80102360:	83 ec 0c             	sub    $0xc,%esp
80102363:	68 98 75 10 80       	push   $0x80107598
80102368:	e8 a3 e2 ff ff       	call   80100610 <panic>
    panic("dirlink");
8010236d:	83 ec 0c             	sub    $0xc,%esp
80102370:	68 7e 7b 10 80       	push   $0x80107b7e
80102375:	e8 96 e2 ff ff       	call   80100610 <panic>
8010237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102380 <namei>:

struct inode*
namei(char *path)
{
80102380:	f3 0f 1e fb          	endbr32 
80102384:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102385:	31 d2                	xor    %edx,%edx
{
80102387:	89 e5                	mov    %esp,%ebp
80102389:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010238c:	8b 45 08             	mov    0x8(%ebp),%eax
8010238f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102392:	e8 29 fd ff ff       	call   801020c0 <namex>
}
80102397:	c9                   	leave  
80102398:	c3                   	ret    
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801023a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801023a0:	f3 0f 1e fb          	endbr32 
801023a4:	55                   	push   %ebp
  return namex(path, 1, name);
801023a5:	ba 01 00 00 00       	mov    $0x1,%edx
{
801023aa:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801023ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801023af:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023b2:	5d                   	pop    %ebp
  return namex(path, 1, name);
801023b3:	e9 08 fd ff ff       	jmp    801020c0 <namex>
801023b8:	66 90                	xchg   %ax,%ax
801023ba:	66 90                	xchg   %ax,%ax
801023bc:	66 90                	xchg   %ax,%ax
801023be:	66 90                	xchg   %ax,%ax

801023c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	57                   	push   %edi
801023c4:	56                   	push   %esi
801023c5:	53                   	push   %ebx
801023c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801023c9:	85 c0                	test   %eax,%eax
801023cb:	0f 84 b4 00 00 00    	je     80102485 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801023d1:	8b 70 08             	mov    0x8(%eax),%esi
801023d4:	89 c3                	mov    %eax,%ebx
801023d6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801023dc:	0f 87 96 00 00 00    	ja     80102478 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801023e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ee:	66 90                	xchg   %ax,%ax
801023f0:	89 ca                	mov    %ecx,%edx
801023f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023f3:	83 e0 c0             	and    $0xffffffc0,%eax
801023f6:	3c 40                	cmp    $0x40,%al
801023f8:	75 f6                	jne    801023f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023fa:	31 ff                	xor    %edi,%edi
801023fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102401:	89 f8                	mov    %edi,%eax
80102403:	ee                   	out    %al,(%dx)
80102404:	b8 01 00 00 00       	mov    $0x1,%eax
80102409:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010240e:	ee                   	out    %al,(%dx)
8010240f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102414:	89 f0                	mov    %esi,%eax
80102416:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102417:	89 f0                	mov    %esi,%eax
80102419:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010241e:	c1 f8 08             	sar    $0x8,%eax
80102421:	ee                   	out    %al,(%dx)
80102422:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102427:	89 f8                	mov    %edi,%eax
80102429:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010242a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010242e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102433:	c1 e0 04             	shl    $0x4,%eax
80102436:	83 e0 10             	and    $0x10,%eax
80102439:	83 c8 e0             	or     $0xffffffe0,%eax
8010243c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010243d:	f6 03 04             	testb  $0x4,(%ebx)
80102440:	75 16                	jne    80102458 <idestart+0x98>
80102442:	b8 20 00 00 00       	mov    $0x20,%eax
80102447:	89 ca                	mov    %ecx,%edx
80102449:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010244a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010244d:	5b                   	pop    %ebx
8010244e:	5e                   	pop    %esi
8010244f:	5f                   	pop    %edi
80102450:	5d                   	pop    %ebp
80102451:	c3                   	ret    
80102452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102458:	b8 30 00 00 00       	mov    $0x30,%eax
8010245d:	89 ca                	mov    %ecx,%edx
8010245f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102460:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102465:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102468:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010246d:	fc                   	cld    
8010246e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102470:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102473:	5b                   	pop    %ebx
80102474:	5e                   	pop    %esi
80102475:	5f                   	pop    %edi
80102476:	5d                   	pop    %ebp
80102477:	c3                   	ret    
    panic("incorrect blockno");
80102478:	83 ec 0c             	sub    $0xc,%esp
8010247b:	68 04 76 10 80       	push   $0x80107604
80102480:	e8 8b e1 ff ff       	call   80100610 <panic>
    panic("idestart");
80102485:	83 ec 0c             	sub    $0xc,%esp
80102488:	68 fb 75 10 80       	push   $0x801075fb
8010248d:	e8 7e e1 ff ff       	call   80100610 <panic>
80102492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801024a0 <ideinit>:
{
801024a0:	f3 0f 1e fb          	endbr32 
801024a4:	55                   	push   %ebp
801024a5:	89 e5                	mov    %esp,%ebp
801024a7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801024aa:	68 16 76 10 80       	push   $0x80107616
801024af:	68 a0 a5 10 80       	push   $0x8010a5a0
801024b4:	e8 77 22 00 00       	call   80104730 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801024b9:	58                   	pop    %eax
801024ba:	a1 60 2d 11 80       	mov    0x80112d60,%eax
801024bf:	5a                   	pop    %edx
801024c0:	83 e8 01             	sub    $0x1,%eax
801024c3:	50                   	push   %eax
801024c4:	6a 0e                	push   $0xe
801024c6:	e8 b5 02 00 00       	call   80102780 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024cb:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024ce:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d7:	90                   	nop
801024d8:	ec                   	in     (%dx),%al
801024d9:	83 e0 c0             	and    $0xffffffc0,%eax
801024dc:	3c 40                	cmp    $0x40,%al
801024de:	75 f8                	jne    801024d8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024e0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801024e5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801024ea:	ee                   	out    %al,(%dx)
801024eb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024f0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024f5:	eb 0e                	jmp    80102505 <ideinit+0x65>
801024f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024fe:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102500:	83 e9 01             	sub    $0x1,%ecx
80102503:	74 0f                	je     80102514 <ideinit+0x74>
80102505:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102506:	84 c0                	test   %al,%al
80102508:	74 f6                	je     80102500 <ideinit+0x60>
      havedisk1 = 1;
8010250a:	c7 05 80 a5 10 80 01 	movl   $0x1,0x8010a580
80102511:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102514:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102519:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010251e:	ee                   	out    %al,(%dx)
}
8010251f:	c9                   	leave  
80102520:	c3                   	ret    
80102521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010252f:	90                   	nop

80102530 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102530:	f3 0f 1e fb          	endbr32 
80102534:	55                   	push   %ebp
80102535:	89 e5                	mov    %esp,%ebp
80102537:	57                   	push   %edi
80102538:	56                   	push   %esi
80102539:	53                   	push   %ebx
8010253a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010253d:	68 a0 a5 10 80       	push   $0x8010a5a0
80102542:	e8 69 23 00 00       	call   801048b0 <acquire>

  if((b = idequeue) == 0){
80102547:	8b 1d 84 a5 10 80    	mov    0x8010a584,%ebx
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	85 db                	test   %ebx,%ebx
80102552:	74 5f                	je     801025b3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102554:	8b 43 58             	mov    0x58(%ebx),%eax
80102557:	a3 84 a5 10 80       	mov    %eax,0x8010a584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010255c:	8b 33                	mov    (%ebx),%esi
8010255e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102564:	75 2b                	jne    80102591 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102566:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010256b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010256f:	90                   	nop
80102570:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102571:	89 c1                	mov    %eax,%ecx
80102573:	83 e1 c0             	and    $0xffffffc0,%ecx
80102576:	80 f9 40             	cmp    $0x40,%cl
80102579:	75 f5                	jne    80102570 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010257b:	a8 21                	test   $0x21,%al
8010257d:	75 12                	jne    80102591 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010257f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102582:	b9 80 00 00 00       	mov    $0x80,%ecx
80102587:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010258c:	fc                   	cld    
8010258d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010258f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102591:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102594:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102597:	83 ce 02             	or     $0x2,%esi
8010259a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010259c:	53                   	push   %ebx
8010259d:	e8 8e 1e 00 00       	call   80104430 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801025a2:	a1 84 a5 10 80       	mov    0x8010a584,%eax
801025a7:	83 c4 10             	add    $0x10,%esp
801025aa:	85 c0                	test   %eax,%eax
801025ac:	74 05                	je     801025b3 <ideintr+0x83>
    idestart(idequeue);
801025ae:	e8 0d fe ff ff       	call   801023c0 <idestart>
    release(&idelock);
801025b3:	83 ec 0c             	sub    $0xc,%esp
801025b6:	68 a0 a5 10 80       	push   $0x8010a5a0
801025bb:	e8 b0 23 00 00       	call   80104970 <release>

  release(&idelock);
}
801025c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025c3:	5b                   	pop    %ebx
801025c4:	5e                   	pop    %esi
801025c5:	5f                   	pop    %edi
801025c6:	5d                   	pop    %ebp
801025c7:	c3                   	ret    
801025c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801025d0:	f3 0f 1e fb          	endbr32 
801025d4:	55                   	push   %ebp
801025d5:	89 e5                	mov    %esp,%ebp
801025d7:	53                   	push   %ebx
801025d8:	83 ec 10             	sub    $0x10,%esp
801025db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801025de:	8d 43 0c             	lea    0xc(%ebx),%eax
801025e1:	50                   	push   %eax
801025e2:	e8 e9 20 00 00       	call   801046d0 <holdingsleep>
801025e7:	83 c4 10             	add    $0x10,%esp
801025ea:	85 c0                	test   %eax,%eax
801025ec:	0f 84 cf 00 00 00    	je     801026c1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801025f2:	8b 03                	mov    (%ebx),%eax
801025f4:	83 e0 06             	and    $0x6,%eax
801025f7:	83 f8 02             	cmp    $0x2,%eax
801025fa:	0f 84 b4 00 00 00    	je     801026b4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102600:	8b 53 04             	mov    0x4(%ebx),%edx
80102603:	85 d2                	test   %edx,%edx
80102605:	74 0d                	je     80102614 <iderw+0x44>
80102607:	a1 80 a5 10 80       	mov    0x8010a580,%eax
8010260c:	85 c0                	test   %eax,%eax
8010260e:	0f 84 93 00 00 00    	je     801026a7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102614:	83 ec 0c             	sub    $0xc,%esp
80102617:	68 a0 a5 10 80       	push   $0x8010a5a0
8010261c:	e8 8f 22 00 00       	call   801048b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102621:	a1 84 a5 10 80       	mov    0x8010a584,%eax
  b->qnext = 0;
80102626:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010262d:	83 c4 10             	add    $0x10,%esp
80102630:	85 c0                	test   %eax,%eax
80102632:	74 6c                	je     801026a0 <iderw+0xd0>
80102634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102638:	89 c2                	mov    %eax,%edx
8010263a:	8b 40 58             	mov    0x58(%eax),%eax
8010263d:	85 c0                	test   %eax,%eax
8010263f:	75 f7                	jne    80102638 <iderw+0x68>
80102641:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102644:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102646:	39 1d 84 a5 10 80    	cmp    %ebx,0x8010a584
8010264c:	74 42                	je     80102690 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010264e:	8b 03                	mov    (%ebx),%eax
80102650:	83 e0 06             	and    $0x6,%eax
80102653:	83 f8 02             	cmp    $0x2,%eax
80102656:	74 23                	je     8010267b <iderw+0xab>
80102658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010265f:	90                   	nop
    sleep(b, &idelock);
80102660:	83 ec 08             	sub    $0x8,%esp
80102663:	68 a0 a5 10 80       	push   $0x8010a5a0
80102668:	53                   	push   %ebx
80102669:	e8 02 1c 00 00       	call   80104270 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010266e:	8b 03                	mov    (%ebx),%eax
80102670:	83 c4 10             	add    $0x10,%esp
80102673:	83 e0 06             	and    $0x6,%eax
80102676:	83 f8 02             	cmp    $0x2,%eax
80102679:	75 e5                	jne    80102660 <iderw+0x90>
  }


  release(&idelock);
8010267b:	c7 45 08 a0 a5 10 80 	movl   $0x8010a5a0,0x8(%ebp)
}
80102682:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102685:	c9                   	leave  
  release(&idelock);
80102686:	e9 e5 22 00 00       	jmp    80104970 <release>
8010268b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010268f:	90                   	nop
    idestart(b);
80102690:	89 d8                	mov    %ebx,%eax
80102692:	e8 29 fd ff ff       	call   801023c0 <idestart>
80102697:	eb b5                	jmp    8010264e <iderw+0x7e>
80102699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026a0:	ba 84 a5 10 80       	mov    $0x8010a584,%edx
801026a5:	eb 9d                	jmp    80102644 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801026a7:	83 ec 0c             	sub    $0xc,%esp
801026aa:	68 45 76 10 80       	push   $0x80107645
801026af:	e8 5c df ff ff       	call   80100610 <panic>
    panic("iderw: nothing to do");
801026b4:	83 ec 0c             	sub    $0xc,%esp
801026b7:	68 30 76 10 80       	push   $0x80107630
801026bc:	e8 4f df ff ff       	call   80100610 <panic>
    panic("iderw: buf not locked");
801026c1:	83 ec 0c             	sub    $0xc,%esp
801026c4:	68 1a 76 10 80       	push   $0x8010761a
801026c9:	e8 42 df ff ff       	call   80100610 <panic>
801026ce:	66 90                	xchg   %ax,%ax

801026d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801026d0:	f3 0f 1e fb          	endbr32 
801026d4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801026d5:	c7 05 94 26 11 80 00 	movl   $0xfec00000,0x80112694
801026dc:	00 c0 fe 
{
801026df:	89 e5                	mov    %esp,%ebp
801026e1:	56                   	push   %esi
801026e2:	53                   	push   %ebx
  ioapic->reg = reg;
801026e3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801026ea:	00 00 00 
  return ioapic->data;
801026ed:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801026f3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801026f6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801026fc:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102702:	0f b6 15 c0 27 11 80 	movzbl 0x801127c0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102709:	c1 ee 10             	shr    $0x10,%esi
8010270c:	89 f0                	mov    %esi,%eax
8010270e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102711:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102714:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102717:	39 c2                	cmp    %eax,%edx
80102719:	74 16                	je     80102731 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010271b:	83 ec 0c             	sub    $0xc,%esp
8010271e:	68 64 76 10 80       	push   $0x80107664
80102723:	e8 68 df ff ff       	call   80100690 <cprintf>
80102728:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
8010272e:	83 c4 10             	add    $0x10,%esp
80102731:	83 c6 21             	add    $0x21,%esi
{
80102734:	ba 10 00 00 00       	mov    $0x10,%edx
80102739:	b8 20 00 00 00       	mov    $0x20,%eax
8010273e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102740:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102742:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102744:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
8010274a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010274d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102753:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102756:	8d 5a 01             	lea    0x1(%edx),%ebx
80102759:	83 c2 02             	add    $0x2,%edx
8010275c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010275e:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
80102764:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010276b:	39 f0                	cmp    %esi,%eax
8010276d:	75 d1                	jne    80102740 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010276f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102772:	5b                   	pop    %ebx
80102773:	5e                   	pop    %esi
80102774:	5d                   	pop    %ebp
80102775:	c3                   	ret    
80102776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277d:	8d 76 00             	lea    0x0(%esi),%esi

80102780 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102780:	f3 0f 1e fb          	endbr32 
80102784:	55                   	push   %ebp
  ioapic->reg = reg;
80102785:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
{
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102790:	8d 50 20             	lea    0x20(%eax),%edx
80102793:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102797:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102799:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010279f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801027a2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801027a8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801027aa:	a1 94 26 11 80       	mov    0x80112694,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027af:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801027b2:	89 50 10             	mov    %edx,0x10(%eax)
}
801027b5:	5d                   	pop    %ebp
801027b6:	c3                   	ret    
801027b7:	66 90                	xchg   %ax,%ax
801027b9:	66 90                	xchg   %ax,%ax
801027bb:	66 90                	xchg   %ax,%ax
801027bd:	66 90                	xchg   %ax,%ax
801027bf:	90                   	nop

801027c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801027c0:	f3 0f 1e fb          	endbr32 
801027c4:	55                   	push   %ebp
801027c5:	89 e5                	mov    %esp,%ebp
801027c7:	53                   	push   %ebx
801027c8:	83 ec 04             	sub    $0x4,%esp
801027cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801027ce:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801027d4:	75 7a                	jne    80102850 <kfree+0x90>
801027d6:	81 fb 08 55 11 80    	cmp    $0x80115508,%ebx
801027dc:	72 72                	jb     80102850 <kfree+0x90>
801027de:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801027e4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801027e9:	77 65                	ja     80102850 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801027eb:	83 ec 04             	sub    $0x4,%esp
801027ee:	68 00 10 00 00       	push   $0x1000
801027f3:	6a 01                	push   $0x1
801027f5:	53                   	push   %ebx
801027f6:	e8 c5 21 00 00       	call   801049c0 <memset>

  if(kmem.use_lock)
801027fb:	8b 15 d4 26 11 80    	mov    0x801126d4,%edx
80102801:	83 c4 10             	add    $0x10,%esp
80102804:	85 d2                	test   %edx,%edx
80102806:	75 20                	jne    80102828 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102808:	a1 d8 26 11 80       	mov    0x801126d8,%eax
8010280d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010280f:	a1 d4 26 11 80       	mov    0x801126d4,%eax
  kmem.freelist = r;
80102814:	89 1d d8 26 11 80    	mov    %ebx,0x801126d8
  if(kmem.use_lock)
8010281a:	85 c0                	test   %eax,%eax
8010281c:	75 22                	jne    80102840 <kfree+0x80>
    release(&kmem.lock);
}
8010281e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102821:	c9                   	leave  
80102822:	c3                   	ret    
80102823:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102827:	90                   	nop
    acquire(&kmem.lock);
80102828:	83 ec 0c             	sub    $0xc,%esp
8010282b:	68 a0 26 11 80       	push   $0x801126a0
80102830:	e8 7b 20 00 00       	call   801048b0 <acquire>
80102835:	83 c4 10             	add    $0x10,%esp
80102838:	eb ce                	jmp    80102808 <kfree+0x48>
8010283a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102840:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102847:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010284a:	c9                   	leave  
    release(&kmem.lock);
8010284b:	e9 20 21 00 00       	jmp    80104970 <release>
    panic("kfree");
80102850:	83 ec 0c             	sub    $0xc,%esp
80102853:	68 96 76 10 80       	push   $0x80107696
80102858:	e8 b3 dd ff ff       	call   80100610 <panic>
8010285d:	8d 76 00             	lea    0x0(%esi),%esi

80102860 <freerange>:
{
80102860:	f3 0f 1e fb          	endbr32 
80102864:	55                   	push   %ebp
80102865:	89 e5                	mov    %esp,%ebp
80102867:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102868:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010286b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010286e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010286f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102875:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010287b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102881:	39 de                	cmp    %ebx,%esi
80102883:	72 1f                	jb     801028a4 <freerange+0x44>
80102885:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102888:	83 ec 0c             	sub    $0xc,%esp
8010288b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102891:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102897:	50                   	push   %eax
80102898:	e8 23 ff ff ff       	call   801027c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010289d:	83 c4 10             	add    $0x10,%esp
801028a0:	39 f3                	cmp    %esi,%ebx
801028a2:	76 e4                	jbe    80102888 <freerange+0x28>
}
801028a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028a7:	5b                   	pop    %ebx
801028a8:	5e                   	pop    %esi
801028a9:	5d                   	pop    %ebp
801028aa:	c3                   	ret    
801028ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028af:	90                   	nop

801028b0 <kinit1>:
{
801028b0:	f3 0f 1e fb          	endbr32 
801028b4:	55                   	push   %ebp
801028b5:	89 e5                	mov    %esp,%ebp
801028b7:	56                   	push   %esi
801028b8:	53                   	push   %ebx
801028b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801028bc:	83 ec 08             	sub    $0x8,%esp
801028bf:	68 9c 76 10 80       	push   $0x8010769c
801028c4:	68 a0 26 11 80       	push   $0x801126a0
801028c9:	e8 62 1e 00 00       	call   80104730 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028d1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801028d4:	c7 05 d4 26 11 80 00 	movl   $0x0,0x801126d4
801028db:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801028de:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028e4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028ea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028f0:	39 de                	cmp    %ebx,%esi
801028f2:	72 20                	jb     80102914 <kinit1+0x64>
801028f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801028f8:	83 ec 0c             	sub    $0xc,%esp
801028fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102901:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102907:	50                   	push   %eax
80102908:	e8 b3 fe ff ff       	call   801027c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010290d:	83 c4 10             	add    $0x10,%esp
80102910:	39 de                	cmp    %ebx,%esi
80102912:	73 e4                	jae    801028f8 <kinit1+0x48>
}
80102914:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102917:	5b                   	pop    %ebx
80102918:	5e                   	pop    %esi
80102919:	5d                   	pop    %ebp
8010291a:	c3                   	ret    
8010291b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010291f:	90                   	nop

80102920 <kinit2>:
{
80102920:	f3 0f 1e fb          	endbr32 
80102924:	55                   	push   %ebp
80102925:	89 e5                	mov    %esp,%ebp
80102927:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102928:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010292b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010292e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010292f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102935:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010293b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102941:	39 de                	cmp    %ebx,%esi
80102943:	72 1f                	jb     80102964 <kinit2+0x44>
80102945:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102948:	83 ec 0c             	sub    $0xc,%esp
8010294b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102951:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102957:	50                   	push   %eax
80102958:	e8 63 fe ff ff       	call   801027c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010295d:	83 c4 10             	add    $0x10,%esp
80102960:	39 de                	cmp    %ebx,%esi
80102962:	73 e4                	jae    80102948 <kinit2+0x28>
  kmem.use_lock = 1;
80102964:	c7 05 d4 26 11 80 01 	movl   $0x1,0x801126d4
8010296b:	00 00 00 
}
8010296e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102971:	5b                   	pop    %ebx
80102972:	5e                   	pop    %esi
80102973:	5d                   	pop    %ebp
80102974:	c3                   	ret    
80102975:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102980 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102980:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102984:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102989:	85 c0                	test   %eax,%eax
8010298b:	75 1b                	jne    801029a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010298d:	a1 d8 26 11 80       	mov    0x801126d8,%eax
  if(r)
80102992:	85 c0                	test   %eax,%eax
80102994:	74 0a                	je     801029a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102996:	8b 10                	mov    (%eax),%edx
80102998:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  if(kmem.use_lock)
8010299e:	c3                   	ret    
8010299f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801029a0:	c3                   	ret    
801029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801029a8:	55                   	push   %ebp
801029a9:	89 e5                	mov    %esp,%ebp
801029ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801029ae:	68 a0 26 11 80       	push   $0x801126a0
801029b3:	e8 f8 1e 00 00       	call   801048b0 <acquire>
  r = kmem.freelist;
801029b8:	a1 d8 26 11 80       	mov    0x801126d8,%eax
  if(r)
801029bd:	8b 15 d4 26 11 80    	mov    0x801126d4,%edx
801029c3:	83 c4 10             	add    $0x10,%esp
801029c6:	85 c0                	test   %eax,%eax
801029c8:	74 08                	je     801029d2 <kalloc+0x52>
    kmem.freelist = r->next;
801029ca:	8b 08                	mov    (%eax),%ecx
801029cc:	89 0d d8 26 11 80    	mov    %ecx,0x801126d8
  if(kmem.use_lock)
801029d2:	85 d2                	test   %edx,%edx
801029d4:	74 16                	je     801029ec <kalloc+0x6c>
    release(&kmem.lock);
801029d6:	83 ec 0c             	sub    $0xc,%esp
801029d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029dc:	68 a0 26 11 80       	push   $0x801126a0
801029e1:	e8 8a 1f 00 00       	call   80104970 <release>
  return (char*)r;
801029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801029e9:	83 c4 10             	add    $0x10,%esp
}
801029ec:	c9                   	leave  
801029ed:	c3                   	ret    
801029ee:	66 90                	xchg   %ax,%ax

801029f0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801029f0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	ba 64 00 00 00       	mov    $0x64,%edx
801029f9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801029fa:	a8 01                	test   $0x1,%al
801029fc:	0f 84 be 00 00 00    	je     80102ac0 <kbdgetc+0xd0>
{
80102a02:	55                   	push   %ebp
80102a03:	ba 60 00 00 00       	mov    $0x60,%edx
80102a08:	89 e5                	mov    %esp,%ebp
80102a0a:	53                   	push   %ebx
80102a0b:	ec                   	in     (%dx),%al
  return data;
80102a0c:	8b 1d d4 a5 10 80    	mov    0x8010a5d4,%ebx
    return -1;
  data = inb(KBDATAP);
80102a12:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102a15:	3c e0                	cmp    $0xe0,%al
80102a17:	74 57                	je     80102a70 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102a19:	89 d9                	mov    %ebx,%ecx
80102a1b:	83 e1 40             	and    $0x40,%ecx
80102a1e:	84 c0                	test   %al,%al
80102a20:	78 5e                	js     80102a80 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102a22:	85 c9                	test   %ecx,%ecx
80102a24:	74 09                	je     80102a2f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102a26:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102a29:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102a2c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102a2f:	0f b6 8a e0 77 10 80 	movzbl -0x7fef8820(%edx),%ecx
  shift ^= togglecode[data];
80102a36:	0f b6 82 e0 76 10 80 	movzbl -0x7fef8920(%edx),%eax
  shift |= shiftcode[data];
80102a3d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102a3f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a41:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102a43:	89 0d d4 a5 10 80    	mov    %ecx,0x8010a5d4
  c = charcode[shift & (CTL | SHIFT)][data];
80102a49:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102a4c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a4f:	8b 04 85 c0 76 10 80 	mov    -0x7fef8940(,%eax,4),%eax
80102a56:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102a5a:	74 0b                	je     80102a67 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102a5c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102a5f:	83 fa 19             	cmp    $0x19,%edx
80102a62:	77 44                	ja     80102aa8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102a64:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a67:	5b                   	pop    %ebx
80102a68:	5d                   	pop    %ebp
80102a69:	c3                   	ret    
80102a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102a70:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102a73:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102a75:	89 1d d4 a5 10 80    	mov    %ebx,0x8010a5d4
}
80102a7b:	5b                   	pop    %ebx
80102a7c:	5d                   	pop    %ebp
80102a7d:	c3                   	ret    
80102a7e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102a80:	83 e0 7f             	and    $0x7f,%eax
80102a83:	85 c9                	test   %ecx,%ecx
80102a85:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102a88:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102a8a:	0f b6 8a e0 77 10 80 	movzbl -0x7fef8820(%edx),%ecx
80102a91:	83 c9 40             	or     $0x40,%ecx
80102a94:	0f b6 c9             	movzbl %cl,%ecx
80102a97:	f7 d1                	not    %ecx
80102a99:	21 d9                	and    %ebx,%ecx
}
80102a9b:	5b                   	pop    %ebx
80102a9c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102a9d:	89 0d d4 a5 10 80    	mov    %ecx,0x8010a5d4
}
80102aa3:	c3                   	ret    
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102aa8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102aab:	8d 50 20             	lea    0x20(%eax),%edx
}
80102aae:	5b                   	pop    %ebx
80102aaf:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102ab0:	83 f9 1a             	cmp    $0x1a,%ecx
80102ab3:	0f 42 c2             	cmovb  %edx,%eax
}
80102ab6:	c3                   	ret    
80102ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102abe:	66 90                	xchg   %ax,%ax
    return -1;
80102ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ac5:	c3                   	ret    
80102ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102acd:	8d 76 00             	lea    0x0(%esi),%esi

80102ad0 <kbdintr>:

void
kbdintr(void)
{
80102ad0:	f3 0f 1e fb          	endbr32 
80102ad4:	55                   	push   %ebp
80102ad5:	89 e5                	mov    %esp,%ebp
80102ad7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102ada:	68 f0 29 10 80       	push   $0x801029f0
80102adf:	e8 3c df ff ff       	call   80100a20 <consoleintr>
}
80102ae4:	83 c4 10             	add    $0x10,%esp
80102ae7:	c9                   	leave  
80102ae8:	c3                   	ret    
80102ae9:	66 90                	xchg   %ax,%ax
80102aeb:	66 90                	xchg   %ax,%ax
80102aed:	66 90                	xchg   %ax,%ax
80102aef:	90                   	nop

80102af0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102af0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102af4:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102af9:	85 c0                	test   %eax,%eax
80102afb:	0f 84 c7 00 00 00    	je     80102bc8 <lapicinit+0xd8>
  lapic[index] = value;
80102b01:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102b08:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b0b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b0e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102b15:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b18:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b1b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102b22:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102b25:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b28:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102b2f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102b32:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b35:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102b3c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b3f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b42:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102b49:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b4c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b4f:	8b 50 30             	mov    0x30(%eax),%edx
80102b52:	c1 ea 10             	shr    $0x10,%edx
80102b55:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102b5b:	75 73                	jne    80102bd0 <lapicinit+0xe0>
  lapic[index] = value;
80102b5d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102b64:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b67:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b6a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b71:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b74:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b77:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b7e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b81:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b84:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b8b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b8e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b91:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102b98:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b9b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b9e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ba5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba8:	8b 50 20             	mov    0x20(%eax),%edx
80102bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102baf:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102bb0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102bb6:	80 e6 10             	and    $0x10,%dh
80102bb9:	75 f5                	jne    80102bb0 <lapicinit+0xc0>
  lapic[index] = value;
80102bbb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102bc2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102bc8:	c3                   	ret    
80102bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102bd0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102bd7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bda:	8b 50 20             	mov    0x20(%eax),%edx
}
80102bdd:	e9 7b ff ff ff       	jmp    80102b5d <lapicinit+0x6d>
80102be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102bf0 <lapicid>:

int
lapicid(void)
{
80102bf0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102bf4:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102bf9:	85 c0                	test   %eax,%eax
80102bfb:	74 0b                	je     80102c08 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102bfd:	8b 40 20             	mov    0x20(%eax),%eax
80102c00:	c1 e8 18             	shr    $0x18,%eax
80102c03:	c3                   	ret    
80102c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102c08:	31 c0                	xor    %eax,%eax
}
80102c0a:	c3                   	ret    
80102c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c0f:	90                   	nop

80102c10 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102c10:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102c14:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102c19:	85 c0                	test   %eax,%eax
80102c1b:	74 0d                	je     80102c2a <lapiceoi+0x1a>
  lapic[index] = value;
80102c1d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c24:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c27:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102c2a:	c3                   	ret    
80102c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c2f:	90                   	nop

80102c30 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102c30:	f3 0f 1e fb          	endbr32 
}
80102c34:	c3                   	ret    
80102c35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c40 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c40:	f3 0f 1e fb          	endbr32 
80102c44:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c45:	b8 0f 00 00 00       	mov    $0xf,%eax
80102c4a:	ba 70 00 00 00       	mov    $0x70,%edx
80102c4f:	89 e5                	mov    %esp,%ebp
80102c51:	53                   	push   %ebx
80102c52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102c55:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c58:	ee                   	out    %al,(%dx)
80102c59:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c5e:	ba 71 00 00 00       	mov    $0x71,%edx
80102c63:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102c64:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102c66:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102c69:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102c6f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c71:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102c74:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102c76:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c79:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102c7c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102c82:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102c87:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c8d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c90:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102c97:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c9a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c9d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ca4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ca7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102caa:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cb0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cb3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cb9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cbc:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cc2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cc5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102ccb:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102ccc:	8b 40 20             	mov    0x20(%eax),%eax
}
80102ccf:	5d                   	pop    %ebp
80102cd0:	c3                   	ret    
80102cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cdf:	90                   	nop

80102ce0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102ce0:	f3 0f 1e fb          	endbr32 
80102ce4:	55                   	push   %ebp
80102ce5:	b8 0b 00 00 00       	mov    $0xb,%eax
80102cea:	ba 70 00 00 00       	mov    $0x70,%edx
80102cef:	89 e5                	mov    %esp,%ebp
80102cf1:	57                   	push   %edi
80102cf2:	56                   	push   %esi
80102cf3:	53                   	push   %ebx
80102cf4:	83 ec 4c             	sub    $0x4c,%esp
80102cf7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cf8:	ba 71 00 00 00       	mov    $0x71,%edx
80102cfd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102cfe:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d01:	bb 70 00 00 00       	mov    $0x70,%ebx
80102d06:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d10:	31 c0                	xor    %eax,%eax
80102d12:	89 da                	mov    %ebx,%edx
80102d14:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d15:	b9 71 00 00 00       	mov    $0x71,%ecx
80102d1a:	89 ca                	mov    %ecx,%edx
80102d1c:	ec                   	in     (%dx),%al
80102d1d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d20:	89 da                	mov    %ebx,%edx
80102d22:	b8 02 00 00 00       	mov    $0x2,%eax
80102d27:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d28:	89 ca                	mov    %ecx,%edx
80102d2a:	ec                   	in     (%dx),%al
80102d2b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d2e:	89 da                	mov    %ebx,%edx
80102d30:	b8 04 00 00 00       	mov    $0x4,%eax
80102d35:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d36:	89 ca                	mov    %ecx,%edx
80102d38:	ec                   	in     (%dx),%al
80102d39:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d3c:	89 da                	mov    %ebx,%edx
80102d3e:	b8 07 00 00 00       	mov    $0x7,%eax
80102d43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d44:	89 ca                	mov    %ecx,%edx
80102d46:	ec                   	in     (%dx),%al
80102d47:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d4a:	89 da                	mov    %ebx,%edx
80102d4c:	b8 08 00 00 00       	mov    $0x8,%eax
80102d51:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d52:	89 ca                	mov    %ecx,%edx
80102d54:	ec                   	in     (%dx),%al
80102d55:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d57:	89 da                	mov    %ebx,%edx
80102d59:	b8 09 00 00 00       	mov    $0x9,%eax
80102d5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d5f:	89 ca                	mov    %ecx,%edx
80102d61:	ec                   	in     (%dx),%al
80102d62:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d64:	89 da                	mov    %ebx,%edx
80102d66:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d6c:	89 ca                	mov    %ecx,%edx
80102d6e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102d6f:	84 c0                	test   %al,%al
80102d71:	78 9d                	js     80102d10 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102d73:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102d77:	89 fa                	mov    %edi,%edx
80102d79:	0f b6 fa             	movzbl %dl,%edi
80102d7c:	89 f2                	mov    %esi,%edx
80102d7e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102d81:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102d85:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d88:	89 da                	mov    %ebx,%edx
80102d8a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102d8d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102d90:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102d94:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102d97:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102d9a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102d9e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102da1:	31 c0                	xor    %eax,%eax
80102da3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102da4:	89 ca                	mov    %ecx,%edx
80102da6:	ec                   	in     (%dx),%al
80102da7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102daa:	89 da                	mov    %ebx,%edx
80102dac:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102daf:	b8 02 00 00 00       	mov    $0x2,%eax
80102db4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102db5:	89 ca                	mov    %ecx,%edx
80102db7:	ec                   	in     (%dx),%al
80102db8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dbb:	89 da                	mov    %ebx,%edx
80102dbd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102dc0:	b8 04 00 00 00       	mov    $0x4,%eax
80102dc5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dc6:	89 ca                	mov    %ecx,%edx
80102dc8:	ec                   	in     (%dx),%al
80102dc9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dcc:	89 da                	mov    %ebx,%edx
80102dce:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102dd1:	b8 07 00 00 00       	mov    $0x7,%eax
80102dd6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dd7:	89 ca                	mov    %ecx,%edx
80102dd9:	ec                   	in     (%dx),%al
80102dda:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ddd:	89 da                	mov    %ebx,%edx
80102ddf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102de2:	b8 08 00 00 00       	mov    $0x8,%eax
80102de7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102de8:	89 ca                	mov    %ecx,%edx
80102dea:	ec                   	in     (%dx),%al
80102deb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dee:	89 da                	mov    %ebx,%edx
80102df0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102df3:	b8 09 00 00 00       	mov    $0x9,%eax
80102df8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102df9:	89 ca                	mov    %ecx,%edx
80102dfb:	ec                   	in     (%dx),%al
80102dfc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102dff:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102e02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e05:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102e08:	6a 18                	push   $0x18
80102e0a:	50                   	push   %eax
80102e0b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102e0e:	50                   	push   %eax
80102e0f:	e8 fc 1b 00 00       	call   80104a10 <memcmp>
80102e14:	83 c4 10             	add    $0x10,%esp
80102e17:	85 c0                	test   %eax,%eax
80102e19:	0f 85 f1 fe ff ff    	jne    80102d10 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102e1f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102e23:	75 78                	jne    80102e9d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102e25:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e28:	89 c2                	mov    %eax,%edx
80102e2a:	83 e0 0f             	and    $0xf,%eax
80102e2d:	c1 ea 04             	shr    $0x4,%edx
80102e30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e36:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102e39:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e3c:	89 c2                	mov    %eax,%edx
80102e3e:	83 e0 0f             	and    $0xf,%eax
80102e41:	c1 ea 04             	shr    $0x4,%edx
80102e44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e4a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102e4d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e50:	89 c2                	mov    %eax,%edx
80102e52:	83 e0 0f             	and    $0xf,%eax
80102e55:	c1 ea 04             	shr    $0x4,%edx
80102e58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e5e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102e61:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e64:	89 c2                	mov    %eax,%edx
80102e66:	83 e0 0f             	and    $0xf,%eax
80102e69:	c1 ea 04             	shr    $0x4,%edx
80102e6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e72:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102e75:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e78:	89 c2                	mov    %eax,%edx
80102e7a:	83 e0 0f             	and    $0xf,%eax
80102e7d:	c1 ea 04             	shr    $0x4,%edx
80102e80:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e83:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e86:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102e89:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e8c:	89 c2                	mov    %eax,%edx
80102e8e:	83 e0 0f             	and    $0xf,%eax
80102e91:	c1 ea 04             	shr    $0x4,%edx
80102e94:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e97:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e9a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102e9d:	8b 75 08             	mov    0x8(%ebp),%esi
80102ea0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ea3:	89 06                	mov    %eax,(%esi)
80102ea5:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ea8:	89 46 04             	mov    %eax,0x4(%esi)
80102eab:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102eae:	89 46 08             	mov    %eax,0x8(%esi)
80102eb1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102eb4:	89 46 0c             	mov    %eax,0xc(%esi)
80102eb7:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102eba:	89 46 10             	mov    %eax,0x10(%esi)
80102ebd:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ec0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102ec3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102eca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ecd:	5b                   	pop    %ebx
80102ece:	5e                   	pop    %esi
80102ecf:	5f                   	pop    %edi
80102ed0:	5d                   	pop    %ebp
80102ed1:	c3                   	ret    
80102ed2:	66 90                	xchg   %ax,%ax
80102ed4:	66 90                	xchg   %ax,%ax
80102ed6:	66 90                	xchg   %ax,%ax
80102ed8:	66 90                	xchg   %ax,%ax
80102eda:	66 90                	xchg   %ax,%ax
80102edc:	66 90                	xchg   %ax,%ax
80102ede:	66 90                	xchg   %ax,%ax

80102ee0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ee0:	8b 0d 28 27 11 80    	mov    0x80112728,%ecx
80102ee6:	85 c9                	test   %ecx,%ecx
80102ee8:	0f 8e 8a 00 00 00    	jle    80102f78 <install_trans+0x98>
{
80102eee:	55                   	push   %ebp
80102eef:	89 e5                	mov    %esp,%ebp
80102ef1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ef2:	31 ff                	xor    %edi,%edi
{
80102ef4:	56                   	push   %esi
80102ef5:	53                   	push   %ebx
80102ef6:	83 ec 0c             	sub    $0xc,%esp
80102ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102f00:	a1 14 27 11 80       	mov    0x80112714,%eax
80102f05:	83 ec 08             	sub    $0x8,%esp
80102f08:	01 f8                	add    %edi,%eax
80102f0a:	83 c0 01             	add    $0x1,%eax
80102f0d:	50                   	push   %eax
80102f0e:	ff 35 24 27 11 80    	pushl  0x80112724
80102f14:	e8 b7 d1 ff ff       	call   801000d0 <bread>
80102f19:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f1b:	58                   	pop    %eax
80102f1c:	5a                   	pop    %edx
80102f1d:	ff 34 bd 2c 27 11 80 	pushl  -0x7feed8d4(,%edi,4)
80102f24:	ff 35 24 27 11 80    	pushl  0x80112724
  for (tail = 0; tail < log.lh.n; tail++) {
80102f2a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f2d:	e8 9e d1 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f32:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f35:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f37:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f3a:	68 00 02 00 00       	push   $0x200
80102f3f:	50                   	push   %eax
80102f40:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102f43:	50                   	push   %eax
80102f44:	e8 17 1b 00 00       	call   80104a60 <memmove>
    bwrite(dbuf);  // write dst to disk
80102f49:	89 1c 24             	mov    %ebx,(%esp)
80102f4c:	e8 5f d2 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102f51:	89 34 24             	mov    %esi,(%esp)
80102f54:	e8 97 d2 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102f59:	89 1c 24             	mov    %ebx,(%esp)
80102f5c:	e8 8f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f61:	83 c4 10             	add    $0x10,%esp
80102f64:	39 3d 28 27 11 80    	cmp    %edi,0x80112728
80102f6a:	7f 94                	jg     80102f00 <install_trans+0x20>
  }
}
80102f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f6f:	5b                   	pop    %ebx
80102f70:	5e                   	pop    %esi
80102f71:	5f                   	pop    %edi
80102f72:	5d                   	pop    %ebp
80102f73:	c3                   	ret    
80102f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f78:	c3                   	ret    
80102f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	53                   	push   %ebx
80102f84:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f87:	ff 35 14 27 11 80    	pushl  0x80112714
80102f8d:	ff 35 24 27 11 80    	pushl  0x80112724
80102f93:	e8 38 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102f98:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f9b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102f9d:	a1 28 27 11 80       	mov    0x80112728,%eax
80102fa2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102fa5:	85 c0                	test   %eax,%eax
80102fa7:	7e 19                	jle    80102fc2 <write_head+0x42>
80102fa9:	31 d2                	xor    %edx,%edx
80102fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102faf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102fb0:	8b 0c 95 2c 27 11 80 	mov    -0x7feed8d4(,%edx,4),%ecx
80102fb7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102fbb:	83 c2 01             	add    $0x1,%edx
80102fbe:	39 d0                	cmp    %edx,%eax
80102fc0:	75 ee                	jne    80102fb0 <write_head+0x30>
  }
  bwrite(buf);
80102fc2:	83 ec 0c             	sub    $0xc,%esp
80102fc5:	53                   	push   %ebx
80102fc6:	e8 e5 d1 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102fcb:	89 1c 24             	mov    %ebx,(%esp)
80102fce:	e8 1d d2 ff ff       	call   801001f0 <brelse>
}
80102fd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fd6:	83 c4 10             	add    $0x10,%esp
80102fd9:	c9                   	leave  
80102fda:	c3                   	ret    
80102fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fdf:	90                   	nop

80102fe0 <initlog>:
{
80102fe0:	f3 0f 1e fb          	endbr32 
80102fe4:	55                   	push   %ebp
80102fe5:	89 e5                	mov    %esp,%ebp
80102fe7:	53                   	push   %ebx
80102fe8:	83 ec 2c             	sub    $0x2c,%esp
80102feb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102fee:	68 e0 78 10 80       	push   $0x801078e0
80102ff3:	68 e0 26 11 80       	push   $0x801126e0
80102ff8:	e8 33 17 00 00       	call   80104730 <initlock>
  readsb(dev, &sb);
80102ffd:	58                   	pop    %eax
80102ffe:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103001:	5a                   	pop    %edx
80103002:	50                   	push   %eax
80103003:	53                   	push   %ebx
80103004:	e8 47 e8 ff ff       	call   80101850 <readsb>
  log.start = sb.logstart;
80103009:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010300c:	59                   	pop    %ecx
  log.dev = dev;
8010300d:	89 1d 24 27 11 80    	mov    %ebx,0x80112724
  log.size = sb.nlog;
80103013:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103016:	a3 14 27 11 80       	mov    %eax,0x80112714
  log.size = sb.nlog;
8010301b:	89 15 18 27 11 80    	mov    %edx,0x80112718
  struct buf *buf = bread(log.dev, log.start);
80103021:	5a                   	pop    %edx
80103022:	50                   	push   %eax
80103023:	53                   	push   %ebx
80103024:	e8 a7 d0 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103029:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010302c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010302f:	89 0d 28 27 11 80    	mov    %ecx,0x80112728
  for (i = 0; i < log.lh.n; i++) {
80103035:	85 c9                	test   %ecx,%ecx
80103037:	7e 19                	jle    80103052 <initlog+0x72>
80103039:	31 d2                	xor    %edx,%edx
8010303b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010303f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103040:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103044:	89 1c 95 2c 27 11 80 	mov    %ebx,-0x7feed8d4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010304b:	83 c2 01             	add    $0x1,%edx
8010304e:	39 d1                	cmp    %edx,%ecx
80103050:	75 ee                	jne    80103040 <initlog+0x60>
  brelse(buf);
80103052:	83 ec 0c             	sub    $0xc,%esp
80103055:	50                   	push   %eax
80103056:	e8 95 d1 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010305b:	e8 80 fe ff ff       	call   80102ee0 <install_trans>
  log.lh.n = 0;
80103060:	c7 05 28 27 11 80 00 	movl   $0x0,0x80112728
80103067:	00 00 00 
  write_head(); // clear the log
8010306a:	e8 11 ff ff ff       	call   80102f80 <write_head>
}
8010306f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103072:	83 c4 10             	add    $0x10,%esp
80103075:	c9                   	leave  
80103076:	c3                   	ret    
80103077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010307e:	66 90                	xchg   %ax,%ax

80103080 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103080:	f3 0f 1e fb          	endbr32 
80103084:	55                   	push   %ebp
80103085:	89 e5                	mov    %esp,%ebp
80103087:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010308a:	68 e0 26 11 80       	push   $0x801126e0
8010308f:	e8 1c 18 00 00       	call   801048b0 <acquire>
80103094:	83 c4 10             	add    $0x10,%esp
80103097:	eb 1c                	jmp    801030b5 <begin_op+0x35>
80103099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801030a0:	83 ec 08             	sub    $0x8,%esp
801030a3:	68 e0 26 11 80       	push   $0x801126e0
801030a8:	68 e0 26 11 80       	push   $0x801126e0
801030ad:	e8 be 11 00 00       	call   80104270 <sleep>
801030b2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801030b5:	a1 20 27 11 80       	mov    0x80112720,%eax
801030ba:	85 c0                	test   %eax,%eax
801030bc:	75 e2                	jne    801030a0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801030be:	a1 1c 27 11 80       	mov    0x8011271c,%eax
801030c3:	8b 15 28 27 11 80    	mov    0x80112728,%edx
801030c9:	83 c0 01             	add    $0x1,%eax
801030cc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801030cf:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801030d2:	83 fa 1e             	cmp    $0x1e,%edx
801030d5:	7f c9                	jg     801030a0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801030d7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801030da:	a3 1c 27 11 80       	mov    %eax,0x8011271c
      release(&log.lock);
801030df:	68 e0 26 11 80       	push   $0x801126e0
801030e4:	e8 87 18 00 00       	call   80104970 <release>
      break;
    }
  }
}
801030e9:	83 c4 10             	add    $0x10,%esp
801030ec:	c9                   	leave  
801030ed:	c3                   	ret    
801030ee:	66 90                	xchg   %ax,%ax

801030f0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801030f0:	f3 0f 1e fb          	endbr32 
801030f4:	55                   	push   %ebp
801030f5:	89 e5                	mov    %esp,%ebp
801030f7:	57                   	push   %edi
801030f8:	56                   	push   %esi
801030f9:	53                   	push   %ebx
801030fa:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801030fd:	68 e0 26 11 80       	push   $0x801126e0
80103102:	e8 a9 17 00 00       	call   801048b0 <acquire>
  log.outstanding -= 1;
80103107:	a1 1c 27 11 80       	mov    0x8011271c,%eax
  if(log.committing)
8010310c:	8b 35 20 27 11 80    	mov    0x80112720,%esi
80103112:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103115:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103118:	89 1d 1c 27 11 80    	mov    %ebx,0x8011271c
  if(log.committing)
8010311e:	85 f6                	test   %esi,%esi
80103120:	0f 85 1e 01 00 00    	jne    80103244 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103126:	85 db                	test   %ebx,%ebx
80103128:	0f 85 f2 00 00 00    	jne    80103220 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010312e:	c7 05 20 27 11 80 01 	movl   $0x1,0x80112720
80103135:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103138:	83 ec 0c             	sub    $0xc,%esp
8010313b:	68 e0 26 11 80       	push   $0x801126e0
80103140:	e8 2b 18 00 00       	call   80104970 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103145:	8b 0d 28 27 11 80    	mov    0x80112728,%ecx
8010314b:	83 c4 10             	add    $0x10,%esp
8010314e:	85 c9                	test   %ecx,%ecx
80103150:	7f 3e                	jg     80103190 <end_op+0xa0>
    acquire(&log.lock);
80103152:	83 ec 0c             	sub    $0xc,%esp
80103155:	68 e0 26 11 80       	push   $0x801126e0
8010315a:	e8 51 17 00 00       	call   801048b0 <acquire>
    wakeup(&log);
8010315f:	c7 04 24 e0 26 11 80 	movl   $0x801126e0,(%esp)
    log.committing = 0;
80103166:	c7 05 20 27 11 80 00 	movl   $0x0,0x80112720
8010316d:	00 00 00 
    wakeup(&log);
80103170:	e8 bb 12 00 00       	call   80104430 <wakeup>
    release(&log.lock);
80103175:	c7 04 24 e0 26 11 80 	movl   $0x801126e0,(%esp)
8010317c:	e8 ef 17 00 00       	call   80104970 <release>
80103181:	83 c4 10             	add    $0x10,%esp
}
80103184:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103187:	5b                   	pop    %ebx
80103188:	5e                   	pop    %esi
80103189:	5f                   	pop    %edi
8010318a:	5d                   	pop    %ebp
8010318b:	c3                   	ret    
8010318c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103190:	a1 14 27 11 80       	mov    0x80112714,%eax
80103195:	83 ec 08             	sub    $0x8,%esp
80103198:	01 d8                	add    %ebx,%eax
8010319a:	83 c0 01             	add    $0x1,%eax
8010319d:	50                   	push   %eax
8010319e:	ff 35 24 27 11 80    	pushl  0x80112724
801031a4:	e8 27 cf ff ff       	call   801000d0 <bread>
801031a9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031ab:	58                   	pop    %eax
801031ac:	5a                   	pop    %edx
801031ad:	ff 34 9d 2c 27 11 80 	pushl  -0x7feed8d4(,%ebx,4)
801031b4:	ff 35 24 27 11 80    	pushl  0x80112724
  for (tail = 0; tail < log.lh.n; tail++) {
801031ba:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031bd:	e8 0e cf ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801031c2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031c5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801031c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801031ca:	68 00 02 00 00       	push   $0x200
801031cf:	50                   	push   %eax
801031d0:	8d 46 5c             	lea    0x5c(%esi),%eax
801031d3:	50                   	push   %eax
801031d4:	e8 87 18 00 00       	call   80104a60 <memmove>
    bwrite(to);  // write the log
801031d9:	89 34 24             	mov    %esi,(%esp)
801031dc:	e8 cf cf ff ff       	call   801001b0 <bwrite>
    brelse(from);
801031e1:	89 3c 24             	mov    %edi,(%esp)
801031e4:	e8 07 d0 ff ff       	call   801001f0 <brelse>
    brelse(to);
801031e9:	89 34 24             	mov    %esi,(%esp)
801031ec:	e8 ff cf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801031f1:	83 c4 10             	add    $0x10,%esp
801031f4:	3b 1d 28 27 11 80    	cmp    0x80112728,%ebx
801031fa:	7c 94                	jl     80103190 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801031fc:	e8 7f fd ff ff       	call   80102f80 <write_head>
    install_trans(); // Now install writes to home locations
80103201:	e8 da fc ff ff       	call   80102ee0 <install_trans>
    log.lh.n = 0;
80103206:	c7 05 28 27 11 80 00 	movl   $0x0,0x80112728
8010320d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103210:	e8 6b fd ff ff       	call   80102f80 <write_head>
80103215:	e9 38 ff ff ff       	jmp    80103152 <end_op+0x62>
8010321a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103220:	83 ec 0c             	sub    $0xc,%esp
80103223:	68 e0 26 11 80       	push   $0x801126e0
80103228:	e8 03 12 00 00       	call   80104430 <wakeup>
  release(&log.lock);
8010322d:	c7 04 24 e0 26 11 80 	movl   $0x801126e0,(%esp)
80103234:	e8 37 17 00 00       	call   80104970 <release>
80103239:	83 c4 10             	add    $0x10,%esp
}
8010323c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010323f:	5b                   	pop    %ebx
80103240:	5e                   	pop    %esi
80103241:	5f                   	pop    %edi
80103242:	5d                   	pop    %ebp
80103243:	c3                   	ret    
    panic("log.committing");
80103244:	83 ec 0c             	sub    $0xc,%esp
80103247:	68 e4 78 10 80       	push   $0x801078e4
8010324c:	e8 bf d3 ff ff       	call   80100610 <panic>
80103251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010325f:	90                   	nop

80103260 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103260:	f3 0f 1e fb          	endbr32 
80103264:	55                   	push   %ebp
80103265:	89 e5                	mov    %esp,%ebp
80103267:	53                   	push   %ebx
80103268:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010326b:	8b 15 28 27 11 80    	mov    0x80112728,%edx
{
80103271:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103274:	83 fa 1d             	cmp    $0x1d,%edx
80103277:	0f 8f 91 00 00 00    	jg     8010330e <log_write+0xae>
8010327d:	a1 18 27 11 80       	mov    0x80112718,%eax
80103282:	83 e8 01             	sub    $0x1,%eax
80103285:	39 c2                	cmp    %eax,%edx
80103287:	0f 8d 81 00 00 00    	jge    8010330e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010328d:	a1 1c 27 11 80       	mov    0x8011271c,%eax
80103292:	85 c0                	test   %eax,%eax
80103294:	0f 8e 81 00 00 00    	jle    8010331b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010329a:	83 ec 0c             	sub    $0xc,%esp
8010329d:	68 e0 26 11 80       	push   $0x801126e0
801032a2:	e8 09 16 00 00       	call   801048b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801032a7:	8b 15 28 27 11 80    	mov    0x80112728,%edx
801032ad:	83 c4 10             	add    $0x10,%esp
801032b0:	85 d2                	test   %edx,%edx
801032b2:	7e 4e                	jle    80103302 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032b4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801032b7:	31 c0                	xor    %eax,%eax
801032b9:	eb 0c                	jmp    801032c7 <log_write+0x67>
801032bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032bf:	90                   	nop
801032c0:	83 c0 01             	add    $0x1,%eax
801032c3:	39 c2                	cmp    %eax,%edx
801032c5:	74 29                	je     801032f0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032c7:	39 0c 85 2c 27 11 80 	cmp    %ecx,-0x7feed8d4(,%eax,4)
801032ce:	75 f0                	jne    801032c0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801032d0:	89 0c 85 2c 27 11 80 	mov    %ecx,-0x7feed8d4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801032d7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801032da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801032dd:	c7 45 08 e0 26 11 80 	movl   $0x801126e0,0x8(%ebp)
}
801032e4:	c9                   	leave  
  release(&log.lock);
801032e5:	e9 86 16 00 00       	jmp    80104970 <release>
801032ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801032f0:	89 0c 95 2c 27 11 80 	mov    %ecx,-0x7feed8d4(,%edx,4)
    log.lh.n++;
801032f7:	83 c2 01             	add    $0x1,%edx
801032fa:	89 15 28 27 11 80    	mov    %edx,0x80112728
80103300:	eb d5                	jmp    801032d7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103302:	8b 43 08             	mov    0x8(%ebx),%eax
80103305:	a3 2c 27 11 80       	mov    %eax,0x8011272c
  if (i == log.lh.n)
8010330a:	75 cb                	jne    801032d7 <log_write+0x77>
8010330c:	eb e9                	jmp    801032f7 <log_write+0x97>
    panic("too big a transaction");
8010330e:	83 ec 0c             	sub    $0xc,%esp
80103311:	68 f3 78 10 80       	push   $0x801078f3
80103316:	e8 f5 d2 ff ff       	call   80100610 <panic>
    panic("log_write outside of trans");
8010331b:	83 ec 0c             	sub    $0xc,%esp
8010331e:	68 09 79 10 80       	push   $0x80107909
80103323:	e8 e8 d2 ff ff       	call   80100610 <panic>
80103328:	66 90                	xchg   %ax,%ax
8010332a:	66 90                	xchg   %ax,%ax
8010332c:	66 90                	xchg   %ax,%ax
8010332e:	66 90                	xchg   %ax,%ax

80103330 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103330:	55                   	push   %ebp
80103331:	89 e5                	mov    %esp,%ebp
80103333:	53                   	push   %ebx
80103334:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103337:	e8 54 09 00 00       	call   80103c90 <cpuid>
8010333c:	89 c3                	mov    %eax,%ebx
8010333e:	e8 4d 09 00 00       	call   80103c90 <cpuid>
80103343:	83 ec 04             	sub    $0x4,%esp
80103346:	53                   	push   %ebx
80103347:	50                   	push   %eax
80103348:	68 24 79 10 80       	push   $0x80107924
8010334d:	e8 3e d3 ff ff       	call   80100690 <cprintf>
  idtinit();       // load idt register
80103352:	e8 19 29 00 00       	call   80105c70 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103357:	e8 c4 08 00 00       	call   80103c20 <mycpu>
8010335c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010335e:	b8 01 00 00 00       	mov    $0x1,%eax
80103363:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010336a:	e8 11 0c 00 00       	call   80103f80 <scheduler>
8010336f:	90                   	nop

80103370 <mpenter>:
{
80103370:	f3 0f 1e fb          	endbr32 
80103374:	55                   	push   %ebp
80103375:	89 e5                	mov    %esp,%ebp
80103377:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010337a:	e8 c1 39 00 00       	call   80106d40 <switchkvm>
  seginit();
8010337f:	e8 2c 39 00 00       	call   80106cb0 <seginit>
  lapicinit();
80103384:	e8 67 f7 ff ff       	call   80102af0 <lapicinit>
  mpmain();
80103389:	e8 a2 ff ff ff       	call   80103330 <mpmain>
8010338e:	66 90                	xchg   %ax,%ax

80103390 <main>:
{
80103390:	f3 0f 1e fb          	endbr32 
80103394:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103398:	83 e4 f0             	and    $0xfffffff0,%esp
8010339b:	ff 71 fc             	pushl  -0x4(%ecx)
8010339e:	55                   	push   %ebp
8010339f:	89 e5                	mov    %esp,%ebp
801033a1:	53                   	push   %ebx
801033a2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033a3:	83 ec 08             	sub    $0x8,%esp
801033a6:	68 00 00 40 80       	push   $0x80400000
801033ab:	68 08 55 11 80       	push   $0x80115508
801033b0:	e8 fb f4 ff ff       	call   801028b0 <kinit1>
  kvmalloc();      // kernel page table
801033b5:	e8 66 3e 00 00       	call   80107220 <kvmalloc>
  mpinit();        // detect other processors
801033ba:	e8 81 01 00 00       	call   80103540 <mpinit>
  lapicinit();     // interrupt controller
801033bf:	e8 2c f7 ff ff       	call   80102af0 <lapicinit>
  seginit();       // segment descriptors
801033c4:	e8 e7 38 00 00       	call   80106cb0 <seginit>
  picinit();       // disable pic
801033c9:	e8 52 03 00 00       	call   80103720 <picinit>
  ioapicinit();    // another interrupt controller
801033ce:	e8 fd f2 ff ff       	call   801026d0 <ioapicinit>
  consoleinit();   // console hardware
801033d3:	e8 a8 d9 ff ff       	call   80100d80 <consoleinit>
  uartinit();      // serial port
801033d8:	e8 93 2b 00 00       	call   80105f70 <uartinit>
  pinit();         // process table
801033dd:	e8 1e 08 00 00       	call   80103c00 <pinit>
  tvinit();        // trap vectors
801033e2:	e8 09 28 00 00       	call   80105bf0 <tvinit>
  binit();         // buffer cache
801033e7:	e8 54 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
801033ec:	e8 3f dd ff ff       	call   80101130 <fileinit>
  ideinit();       // disk 
801033f1:	e8 aa f0 ff ff       	call   801024a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801033f6:	83 c4 0c             	add    $0xc,%esp
801033f9:	68 8a 00 00 00       	push   $0x8a
801033fe:	68 8c a4 10 80       	push   $0x8010a48c
80103403:	68 00 70 00 80       	push   $0x80007000
80103408:	e8 53 16 00 00       	call   80104a60 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010340d:	83 c4 10             	add    $0x10,%esp
80103410:	69 05 60 2d 11 80 b0 	imul   $0xb0,0x80112d60,%eax
80103417:	00 00 00 
8010341a:	05 e0 27 11 80       	add    $0x801127e0,%eax
8010341f:	3d e0 27 11 80       	cmp    $0x801127e0,%eax
80103424:	76 7a                	jbe    801034a0 <main+0x110>
80103426:	bb e0 27 11 80       	mov    $0x801127e0,%ebx
8010342b:	eb 1c                	jmp    80103449 <main+0xb9>
8010342d:	8d 76 00             	lea    0x0(%esi),%esi
80103430:	69 05 60 2d 11 80 b0 	imul   $0xb0,0x80112d60,%eax
80103437:	00 00 00 
8010343a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103440:	05 e0 27 11 80       	add    $0x801127e0,%eax
80103445:	39 c3                	cmp    %eax,%ebx
80103447:	73 57                	jae    801034a0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103449:	e8 d2 07 00 00       	call   80103c20 <mycpu>
8010344e:	39 c3                	cmp    %eax,%ebx
80103450:	74 de                	je     80103430 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103452:	e8 29 f5 ff ff       	call   80102980 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103457:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010345a:	c7 05 f8 6f 00 80 70 	movl   $0x80103370,0x80006ff8
80103461:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103464:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010346b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010346e:	05 00 10 00 00       	add    $0x1000,%eax
80103473:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103478:	0f b6 03             	movzbl (%ebx),%eax
8010347b:	68 00 70 00 00       	push   $0x7000
80103480:	50                   	push   %eax
80103481:	e8 ba f7 ff ff       	call   80102c40 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103486:	83 c4 10             	add    $0x10,%esp
80103489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103490:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103496:	85 c0                	test   %eax,%eax
80103498:	74 f6                	je     80103490 <main+0x100>
8010349a:	eb 94                	jmp    80103430 <main+0xa0>
8010349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801034a0:	83 ec 08             	sub    $0x8,%esp
801034a3:	68 00 00 00 8e       	push   $0x8e000000
801034a8:	68 00 00 40 80       	push   $0x80400000
801034ad:	e8 6e f4 ff ff       	call   80102920 <kinit2>
  userinit();      // first user process
801034b2:	e8 29 08 00 00       	call   80103ce0 <userinit>
  mpmain();        // finish this processor's setup
801034b7:	e8 74 fe ff ff       	call   80103330 <mpmain>
801034bc:	66 90                	xchg   %ax,%ax
801034be:	66 90                	xchg   %ax,%ax

801034c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	57                   	push   %edi
801034c4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801034c5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801034cb:	53                   	push   %ebx
  e = addr+len;
801034cc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801034cf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801034d2:	39 de                	cmp    %ebx,%esi
801034d4:	72 10                	jb     801034e6 <mpsearch1+0x26>
801034d6:	eb 50                	jmp    80103528 <mpsearch1+0x68>
801034d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034df:	90                   	nop
801034e0:	89 fe                	mov    %edi,%esi
801034e2:	39 fb                	cmp    %edi,%ebx
801034e4:	76 42                	jbe    80103528 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034e6:	83 ec 04             	sub    $0x4,%esp
801034e9:	8d 7e 10             	lea    0x10(%esi),%edi
801034ec:	6a 04                	push   $0x4
801034ee:	68 38 79 10 80       	push   $0x80107938
801034f3:	56                   	push   %esi
801034f4:	e8 17 15 00 00       	call   80104a10 <memcmp>
801034f9:	83 c4 10             	add    $0x10,%esp
801034fc:	85 c0                	test   %eax,%eax
801034fe:	75 e0                	jne    801034e0 <mpsearch1+0x20>
80103500:	89 f2                	mov    %esi,%edx
80103502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103508:	0f b6 0a             	movzbl (%edx),%ecx
8010350b:	83 c2 01             	add    $0x1,%edx
8010350e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103510:	39 fa                	cmp    %edi,%edx
80103512:	75 f4                	jne    80103508 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103514:	84 c0                	test   %al,%al
80103516:	75 c8                	jne    801034e0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103518:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010351b:	89 f0                	mov    %esi,%eax
8010351d:	5b                   	pop    %ebx
8010351e:	5e                   	pop    %esi
8010351f:	5f                   	pop    %edi
80103520:	5d                   	pop    %ebp
80103521:	c3                   	ret    
80103522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103528:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010352b:	31 f6                	xor    %esi,%esi
}
8010352d:	5b                   	pop    %ebx
8010352e:	89 f0                	mov    %esi,%eax
80103530:	5e                   	pop    %esi
80103531:	5f                   	pop    %edi
80103532:	5d                   	pop    %ebp
80103533:	c3                   	ret    
80103534:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010353b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010353f:	90                   	nop

80103540 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103540:	f3 0f 1e fb          	endbr32 
80103544:	55                   	push   %ebp
80103545:	89 e5                	mov    %esp,%ebp
80103547:	57                   	push   %edi
80103548:	56                   	push   %esi
80103549:	53                   	push   %ebx
8010354a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010354d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103554:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010355b:	c1 e0 08             	shl    $0x8,%eax
8010355e:	09 d0                	or     %edx,%eax
80103560:	c1 e0 04             	shl    $0x4,%eax
80103563:	75 1b                	jne    80103580 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103565:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010356c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103573:	c1 e0 08             	shl    $0x8,%eax
80103576:	09 d0                	or     %edx,%eax
80103578:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010357b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103580:	ba 00 04 00 00       	mov    $0x400,%edx
80103585:	e8 36 ff ff ff       	call   801034c0 <mpsearch1>
8010358a:	89 c6                	mov    %eax,%esi
8010358c:	85 c0                	test   %eax,%eax
8010358e:	0f 84 4c 01 00 00    	je     801036e0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103594:	8b 5e 04             	mov    0x4(%esi),%ebx
80103597:	85 db                	test   %ebx,%ebx
80103599:	0f 84 61 01 00 00    	je     80103700 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010359f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801035a2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801035a8:	6a 04                	push   $0x4
801035aa:	68 3d 79 10 80       	push   $0x8010793d
801035af:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801035b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801035b3:	e8 58 14 00 00       	call   80104a10 <memcmp>
801035b8:	83 c4 10             	add    $0x10,%esp
801035bb:	85 c0                	test   %eax,%eax
801035bd:	0f 85 3d 01 00 00    	jne    80103700 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801035c3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801035ca:	3c 01                	cmp    $0x1,%al
801035cc:	74 08                	je     801035d6 <mpinit+0x96>
801035ce:	3c 04                	cmp    $0x4,%al
801035d0:	0f 85 2a 01 00 00    	jne    80103700 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801035d6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801035dd:	66 85 d2             	test   %dx,%dx
801035e0:	74 26                	je     80103608 <mpinit+0xc8>
801035e2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801035e5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801035e7:	31 d2                	xor    %edx,%edx
801035e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801035f0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801035f7:	83 c0 01             	add    $0x1,%eax
801035fa:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801035fc:	39 f8                	cmp    %edi,%eax
801035fe:	75 f0                	jne    801035f0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103600:	84 d2                	test   %dl,%dl
80103602:	0f 85 f8 00 00 00    	jne    80103700 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103608:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010360e:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103613:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103619:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103620:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103625:	03 55 e4             	add    -0x1c(%ebp),%edx
80103628:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010362b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010362f:	90                   	nop
80103630:	39 c2                	cmp    %eax,%edx
80103632:	76 15                	jbe    80103649 <mpinit+0x109>
    switch(*p){
80103634:	0f b6 08             	movzbl (%eax),%ecx
80103637:	80 f9 02             	cmp    $0x2,%cl
8010363a:	74 5c                	je     80103698 <mpinit+0x158>
8010363c:	77 42                	ja     80103680 <mpinit+0x140>
8010363e:	84 c9                	test   %cl,%cl
80103640:	74 6e                	je     801036b0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103642:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103645:	39 c2                	cmp    %eax,%edx
80103647:	77 eb                	ja     80103634 <mpinit+0xf4>
80103649:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010364c:	85 db                	test   %ebx,%ebx
8010364e:	0f 84 b9 00 00 00    	je     8010370d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103654:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103658:	74 15                	je     8010366f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010365a:	b8 70 00 00 00       	mov    $0x70,%eax
8010365f:	ba 22 00 00 00       	mov    $0x22,%edx
80103664:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103665:	ba 23 00 00 00       	mov    $0x23,%edx
8010366a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010366b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010366e:	ee                   	out    %al,(%dx)
  }
}
8010366f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103672:	5b                   	pop    %ebx
80103673:	5e                   	pop    %esi
80103674:	5f                   	pop    %edi
80103675:	5d                   	pop    %ebp
80103676:	c3                   	ret    
80103677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010367e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103680:	83 e9 03             	sub    $0x3,%ecx
80103683:	80 f9 01             	cmp    $0x1,%cl
80103686:	76 ba                	jbe    80103642 <mpinit+0x102>
80103688:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010368f:	eb 9f                	jmp    80103630 <mpinit+0xf0>
80103691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103698:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010369c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010369f:	88 0d c0 27 11 80    	mov    %cl,0x801127c0
      continue;
801036a5:	eb 89                	jmp    80103630 <mpinit+0xf0>
801036a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036ae:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801036b0:	8b 0d 60 2d 11 80    	mov    0x80112d60,%ecx
801036b6:	83 f9 07             	cmp    $0x7,%ecx
801036b9:	7f 19                	jg     801036d4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036bb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801036c1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801036c5:	83 c1 01             	add    $0x1,%ecx
801036c8:	89 0d 60 2d 11 80    	mov    %ecx,0x80112d60
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036ce:	88 9f e0 27 11 80    	mov    %bl,-0x7feed820(%edi)
      p += sizeof(struct mpproc);
801036d4:	83 c0 14             	add    $0x14,%eax
      continue;
801036d7:	e9 54 ff ff ff       	jmp    80103630 <mpinit+0xf0>
801036dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801036e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801036e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801036ea:	e8 d1 fd ff ff       	call   801034c0 <mpsearch1>
801036ef:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801036f1:	85 c0                	test   %eax,%eax
801036f3:	0f 85 9b fe ff ff    	jne    80103594 <mpinit+0x54>
801036f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	68 42 79 10 80       	push   $0x80107942
80103708:	e8 03 cf ff ff       	call   80100610 <panic>
    panic("Didn't find a suitable machine");
8010370d:	83 ec 0c             	sub    $0xc,%esp
80103710:	68 5c 79 10 80       	push   $0x8010795c
80103715:	e8 f6 ce ff ff       	call   80100610 <panic>
8010371a:	66 90                	xchg   %ax,%ax
8010371c:	66 90                	xchg   %ax,%ax
8010371e:	66 90                	xchg   %ax,%ax

80103720 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103720:	f3 0f 1e fb          	endbr32 
80103724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103729:	ba 21 00 00 00       	mov    $0x21,%edx
8010372e:	ee                   	out    %al,(%dx)
8010372f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103734:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103735:	c3                   	ret    
80103736:	66 90                	xchg   %ax,%ax
80103738:	66 90                	xchg   %ax,%ax
8010373a:	66 90                	xchg   %ax,%ax
8010373c:	66 90                	xchg   %ax,%ax
8010373e:	66 90                	xchg   %ax,%ax

80103740 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103740:	f3 0f 1e fb          	endbr32 
80103744:	55                   	push   %ebp
80103745:	89 e5                	mov    %esp,%ebp
80103747:	57                   	push   %edi
80103748:	56                   	push   %esi
80103749:	53                   	push   %ebx
8010374a:	83 ec 0c             	sub    $0xc,%esp
8010374d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103750:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103753:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103759:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010375f:	e8 ec d9 ff ff       	call   80101150 <filealloc>
80103764:	89 03                	mov    %eax,(%ebx)
80103766:	85 c0                	test   %eax,%eax
80103768:	0f 84 ac 00 00 00    	je     8010381a <pipealloc+0xda>
8010376e:	e8 dd d9 ff ff       	call   80101150 <filealloc>
80103773:	89 06                	mov    %eax,(%esi)
80103775:	85 c0                	test   %eax,%eax
80103777:	0f 84 8b 00 00 00    	je     80103808 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010377d:	e8 fe f1 ff ff       	call   80102980 <kalloc>
80103782:	89 c7                	mov    %eax,%edi
80103784:	85 c0                	test   %eax,%eax
80103786:	0f 84 b4 00 00 00    	je     80103840 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010378c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103793:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103796:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103799:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801037a0:	00 00 00 
  p->nwrite = 0;
801037a3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801037aa:	00 00 00 
  p->nread = 0;
801037ad:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801037b4:	00 00 00 
  initlock(&p->lock, "pipe");
801037b7:	68 7b 79 10 80       	push   $0x8010797b
801037bc:	50                   	push   %eax
801037bd:	e8 6e 0f 00 00       	call   80104730 <initlock>
  (*f0)->type = FD_PIPE;
801037c2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801037c4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801037c7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801037cd:	8b 03                	mov    (%ebx),%eax
801037cf:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801037d3:	8b 03                	mov    (%ebx),%eax
801037d5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801037d9:	8b 03                	mov    (%ebx),%eax
801037db:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801037de:	8b 06                	mov    (%esi),%eax
801037e0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801037e6:	8b 06                	mov    (%esi),%eax
801037e8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801037ec:	8b 06                	mov    (%esi),%eax
801037ee:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801037f2:	8b 06                	mov    (%esi),%eax
801037f4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801037f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801037fa:	31 c0                	xor    %eax,%eax
}
801037fc:	5b                   	pop    %ebx
801037fd:	5e                   	pop    %esi
801037fe:	5f                   	pop    %edi
801037ff:	5d                   	pop    %ebp
80103800:	c3                   	ret    
80103801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103808:	8b 03                	mov    (%ebx),%eax
8010380a:	85 c0                	test   %eax,%eax
8010380c:	74 1e                	je     8010382c <pipealloc+0xec>
    fileclose(*f0);
8010380e:	83 ec 0c             	sub    $0xc,%esp
80103811:	50                   	push   %eax
80103812:	e8 f9 d9 ff ff       	call   80101210 <fileclose>
80103817:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010381a:	8b 06                	mov    (%esi),%eax
8010381c:	85 c0                	test   %eax,%eax
8010381e:	74 0c                	je     8010382c <pipealloc+0xec>
    fileclose(*f1);
80103820:	83 ec 0c             	sub    $0xc,%esp
80103823:	50                   	push   %eax
80103824:	e8 e7 d9 ff ff       	call   80101210 <fileclose>
80103829:	83 c4 10             	add    $0x10,%esp
}
8010382c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010382f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103834:	5b                   	pop    %ebx
80103835:	5e                   	pop    %esi
80103836:	5f                   	pop    %edi
80103837:	5d                   	pop    %ebp
80103838:	c3                   	ret    
80103839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103840:	8b 03                	mov    (%ebx),%eax
80103842:	85 c0                	test   %eax,%eax
80103844:	75 c8                	jne    8010380e <pipealloc+0xce>
80103846:	eb d2                	jmp    8010381a <pipealloc+0xda>
80103848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010384f:	90                   	nop

80103850 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103850:	f3 0f 1e fb          	endbr32 
80103854:	55                   	push   %ebp
80103855:	89 e5                	mov    %esp,%ebp
80103857:	56                   	push   %esi
80103858:	53                   	push   %ebx
80103859:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010385c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010385f:	83 ec 0c             	sub    $0xc,%esp
80103862:	53                   	push   %ebx
80103863:	e8 48 10 00 00       	call   801048b0 <acquire>
  if(writable){
80103868:	83 c4 10             	add    $0x10,%esp
8010386b:	85 f6                	test   %esi,%esi
8010386d:	74 41                	je     801038b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010386f:	83 ec 0c             	sub    $0xc,%esp
80103872:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103878:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010387f:	00 00 00 
    wakeup(&p->nread);
80103882:	50                   	push   %eax
80103883:	e8 a8 0b 00 00       	call   80104430 <wakeup>
80103888:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010388b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103891:	85 d2                	test   %edx,%edx
80103893:	75 0a                	jne    8010389f <pipeclose+0x4f>
80103895:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010389b:	85 c0                	test   %eax,%eax
8010389d:	74 31                	je     801038d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010389f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801038a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038a5:	5b                   	pop    %ebx
801038a6:	5e                   	pop    %esi
801038a7:	5d                   	pop    %ebp
    release(&p->lock);
801038a8:	e9 c3 10 00 00       	jmp    80104970 <release>
801038ad:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801038b0:	83 ec 0c             	sub    $0xc,%esp
801038b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801038b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801038c0:	00 00 00 
    wakeup(&p->nwrite);
801038c3:	50                   	push   %eax
801038c4:	e8 67 0b 00 00       	call   80104430 <wakeup>
801038c9:	83 c4 10             	add    $0x10,%esp
801038cc:	eb bd                	jmp    8010388b <pipeclose+0x3b>
801038ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801038d0:	83 ec 0c             	sub    $0xc,%esp
801038d3:	53                   	push   %ebx
801038d4:	e8 97 10 00 00       	call   80104970 <release>
    kfree((char*)p);
801038d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801038dc:	83 c4 10             	add    $0x10,%esp
}
801038df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038e2:	5b                   	pop    %ebx
801038e3:	5e                   	pop    %esi
801038e4:	5d                   	pop    %ebp
    kfree((char*)p);
801038e5:	e9 d6 ee ff ff       	jmp    801027c0 <kfree>
801038ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801038f0:	f3 0f 1e fb          	endbr32 
801038f4:	55                   	push   %ebp
801038f5:	89 e5                	mov    %esp,%ebp
801038f7:	57                   	push   %edi
801038f8:	56                   	push   %esi
801038f9:	53                   	push   %ebx
801038fa:	83 ec 28             	sub    $0x28,%esp
801038fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103900:	53                   	push   %ebx
80103901:	e8 aa 0f 00 00       	call   801048b0 <acquire>
  for(i = 0; i < n; i++){
80103906:	8b 45 10             	mov    0x10(%ebp),%eax
80103909:	83 c4 10             	add    $0x10,%esp
8010390c:	85 c0                	test   %eax,%eax
8010390e:	0f 8e bc 00 00 00    	jle    801039d0 <pipewrite+0xe0>
80103914:	8b 45 0c             	mov    0xc(%ebp),%eax
80103917:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010391d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103923:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103926:	03 45 10             	add    0x10(%ebp),%eax
80103929:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010392c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103932:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103938:	89 ca                	mov    %ecx,%edx
8010393a:	05 00 02 00 00       	add    $0x200,%eax
8010393f:	39 c1                	cmp    %eax,%ecx
80103941:	74 3b                	je     8010397e <pipewrite+0x8e>
80103943:	eb 63                	jmp    801039a8 <pipewrite+0xb8>
80103945:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103948:	e8 63 03 00 00       	call   80103cb0 <myproc>
8010394d:	8b 48 24             	mov    0x24(%eax),%ecx
80103950:	85 c9                	test   %ecx,%ecx
80103952:	75 34                	jne    80103988 <pipewrite+0x98>
      wakeup(&p->nread);
80103954:	83 ec 0c             	sub    $0xc,%esp
80103957:	57                   	push   %edi
80103958:	e8 d3 0a 00 00       	call   80104430 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010395d:	58                   	pop    %eax
8010395e:	5a                   	pop    %edx
8010395f:	53                   	push   %ebx
80103960:	56                   	push   %esi
80103961:	e8 0a 09 00 00       	call   80104270 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103966:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010396c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103972:	83 c4 10             	add    $0x10,%esp
80103975:	05 00 02 00 00       	add    $0x200,%eax
8010397a:	39 c2                	cmp    %eax,%edx
8010397c:	75 2a                	jne    801039a8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010397e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103984:	85 c0                	test   %eax,%eax
80103986:	75 c0                	jne    80103948 <pipewrite+0x58>
        release(&p->lock);
80103988:	83 ec 0c             	sub    $0xc,%esp
8010398b:	53                   	push   %ebx
8010398c:	e8 df 0f 00 00       	call   80104970 <release>
        return -1;
80103991:	83 c4 10             	add    $0x10,%esp
80103994:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103999:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010399c:	5b                   	pop    %ebx
8010399d:	5e                   	pop    %esi
8010399e:	5f                   	pop    %edi
8010399f:	5d                   	pop    %ebp
801039a0:	c3                   	ret    
801039a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801039a8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801039ab:	8d 4a 01             	lea    0x1(%edx),%ecx
801039ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801039b4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801039ba:	0f b6 06             	movzbl (%esi),%eax
801039bd:	83 c6 01             	add    $0x1,%esi
801039c0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801039c3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801039c7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801039ca:	0f 85 5c ff ff ff    	jne    8010392c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801039d0:	83 ec 0c             	sub    $0xc,%esp
801039d3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801039d9:	50                   	push   %eax
801039da:	e8 51 0a 00 00       	call   80104430 <wakeup>
  release(&p->lock);
801039df:	89 1c 24             	mov    %ebx,(%esp)
801039e2:	e8 89 0f 00 00       	call   80104970 <release>
  return n;
801039e7:	8b 45 10             	mov    0x10(%ebp),%eax
801039ea:	83 c4 10             	add    $0x10,%esp
801039ed:	eb aa                	jmp    80103999 <pipewrite+0xa9>
801039ef:	90                   	nop

801039f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801039f0:	f3 0f 1e fb          	endbr32 
801039f4:	55                   	push   %ebp
801039f5:	89 e5                	mov    %esp,%ebp
801039f7:	57                   	push   %edi
801039f8:	56                   	push   %esi
801039f9:	53                   	push   %ebx
801039fa:	83 ec 18             	sub    $0x18,%esp
801039fd:	8b 75 08             	mov    0x8(%ebp),%esi
80103a00:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103a03:	56                   	push   %esi
80103a04:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103a0a:	e8 a1 0e 00 00       	call   801048b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a0f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103a15:	83 c4 10             	add    $0x10,%esp
80103a18:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103a1e:	74 33                	je     80103a53 <piperead+0x63>
80103a20:	eb 3b                	jmp    80103a5d <piperead+0x6d>
80103a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103a28:	e8 83 02 00 00       	call   80103cb0 <myproc>
80103a2d:	8b 48 24             	mov    0x24(%eax),%ecx
80103a30:	85 c9                	test   %ecx,%ecx
80103a32:	0f 85 88 00 00 00    	jne    80103ac0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103a38:	83 ec 08             	sub    $0x8,%esp
80103a3b:	56                   	push   %esi
80103a3c:	53                   	push   %ebx
80103a3d:	e8 2e 08 00 00       	call   80104270 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a42:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103a48:	83 c4 10             	add    $0x10,%esp
80103a4b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103a51:	75 0a                	jne    80103a5d <piperead+0x6d>
80103a53:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103a59:	85 c0                	test   %eax,%eax
80103a5b:	75 cb                	jne    80103a28 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a5d:	8b 55 10             	mov    0x10(%ebp),%edx
80103a60:	31 db                	xor    %ebx,%ebx
80103a62:	85 d2                	test   %edx,%edx
80103a64:	7f 28                	jg     80103a8e <piperead+0x9e>
80103a66:	eb 34                	jmp    80103a9c <piperead+0xac>
80103a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a6f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103a70:	8d 48 01             	lea    0x1(%eax),%ecx
80103a73:	25 ff 01 00 00       	and    $0x1ff,%eax
80103a78:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103a7e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103a83:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a86:	83 c3 01             	add    $0x1,%ebx
80103a89:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103a8c:	74 0e                	je     80103a9c <piperead+0xac>
    if(p->nread == p->nwrite)
80103a8e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103a94:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103a9a:	75 d4                	jne    80103a70 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103a9c:	83 ec 0c             	sub    $0xc,%esp
80103a9f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103aa5:	50                   	push   %eax
80103aa6:	e8 85 09 00 00       	call   80104430 <wakeup>
  release(&p->lock);
80103aab:	89 34 24             	mov    %esi,(%esp)
80103aae:	e8 bd 0e 00 00       	call   80104970 <release>
  return i;
80103ab3:	83 c4 10             	add    $0x10,%esp
}
80103ab6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ab9:	89 d8                	mov    %ebx,%eax
80103abb:	5b                   	pop    %ebx
80103abc:	5e                   	pop    %esi
80103abd:	5f                   	pop    %edi
80103abe:	5d                   	pop    %ebp
80103abf:	c3                   	ret    
      release(&p->lock);
80103ac0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ac3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103ac8:	56                   	push   %esi
80103ac9:	e8 a2 0e 00 00       	call   80104970 <release>
      return -1;
80103ace:	83 c4 10             	add    $0x10,%esp
}
80103ad1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ad4:	89 d8                	mov    %ebx,%eax
80103ad6:	5b                   	pop    %ebx
80103ad7:	5e                   	pop    %esi
80103ad8:	5f                   	pop    %edi
80103ad9:	5d                   	pop    %ebp
80103ada:	c3                   	ret    
80103adb:	66 90                	xchg   %ax,%ax
80103add:	66 90                	xchg   %ax,%ax
80103adf:	90                   	nop

80103ae0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ae4:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
{
80103ae9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103aec:	68 80 2d 11 80       	push   $0x80112d80
80103af1:	e8 ba 0d 00 00       	call   801048b0 <acquire>
80103af6:	83 c4 10             	add    $0x10,%esp
80103af9:	eb 10                	jmp    80103b0b <allocproc+0x2b>
80103afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103aff:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b00:	83 c3 7c             	add    $0x7c,%ebx
80103b03:	81 fb b4 4c 11 80    	cmp    $0x80114cb4,%ebx
80103b09:	74 75                	je     80103b80 <allocproc+0xa0>
    if(p->state == UNUSED)
80103b0b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103b0e:	85 c0                	test   %eax,%eax
80103b10:	75 ee                	jne    80103b00 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103b12:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103b17:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103b1a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103b21:	89 43 10             	mov    %eax,0x10(%ebx)
80103b24:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103b27:	68 80 2d 11 80       	push   $0x80112d80
  p->pid = nextpid++;
80103b2c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103b32:	e8 39 0e 00 00       	call   80104970 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103b37:	e8 44 ee ff ff       	call   80102980 <kalloc>
80103b3c:	83 c4 10             	add    $0x10,%esp
80103b3f:	89 43 08             	mov    %eax,0x8(%ebx)
80103b42:	85 c0                	test   %eax,%eax
80103b44:	74 53                	je     80103b99 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b46:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103b4c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103b4f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103b54:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103b57:	c7 40 14 d6 5b 10 80 	movl   $0x80105bd6,0x14(%eax)
  p->context = (struct context*)sp;
80103b5e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103b61:	6a 14                	push   $0x14
80103b63:	6a 00                	push   $0x0
80103b65:	50                   	push   %eax
80103b66:	e8 55 0e 00 00       	call   801049c0 <memset>
  p->context->eip = (uint)forkret;
80103b6b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103b6e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b71:	c7 40 10 b0 3b 10 80 	movl   $0x80103bb0,0x10(%eax)
}
80103b78:	89 d8                	mov    %ebx,%eax
80103b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b7d:	c9                   	leave  
80103b7e:	c3                   	ret    
80103b7f:	90                   	nop
  release(&ptable.lock);
80103b80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103b83:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103b85:	68 80 2d 11 80       	push   $0x80112d80
80103b8a:	e8 e1 0d 00 00       	call   80104970 <release>
}
80103b8f:	89 d8                	mov    %ebx,%eax
  return 0;
80103b91:	83 c4 10             	add    $0x10,%esp
}
80103b94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b97:	c9                   	leave  
80103b98:	c3                   	ret    
    p->state = UNUSED;
80103b99:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103ba0:	31 db                	xor    %ebx,%ebx
}
80103ba2:	89 d8                	mov    %ebx,%eax
80103ba4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ba7:	c9                   	leave  
80103ba8:	c3                   	ret    
80103ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103bb0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103bb0:	f3 0f 1e fb          	endbr32 
80103bb4:	55                   	push   %ebp
80103bb5:	89 e5                	mov    %esp,%ebp
80103bb7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103bba:	68 80 2d 11 80       	push   $0x80112d80
80103bbf:	e8 ac 0d 00 00       	call   80104970 <release>

  if (first) {
80103bc4:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103bc9:	83 c4 10             	add    $0x10,%esp
80103bcc:	85 c0                	test   %eax,%eax
80103bce:	75 08                	jne    80103bd8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103bd0:	c9                   	leave  
80103bd1:	c3                   	ret    
80103bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103bd8:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103bdf:	00 00 00 
    iinit(ROOTDEV);
80103be2:	83 ec 0c             	sub    $0xc,%esp
80103be5:	6a 01                	push   $0x1
80103be7:	e8 a4 dc ff ff       	call   80101890 <iinit>
    initlog(ROOTDEV);
80103bec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103bf3:	e8 e8 f3 ff ff       	call   80102fe0 <initlog>
}
80103bf8:	83 c4 10             	add    $0x10,%esp
80103bfb:	c9                   	leave  
80103bfc:	c3                   	ret    
80103bfd:	8d 76 00             	lea    0x0(%esi),%esi

80103c00 <pinit>:
{
80103c00:	f3 0f 1e fb          	endbr32 
80103c04:	55                   	push   %ebp
80103c05:	89 e5                	mov    %esp,%ebp
80103c07:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103c0a:	68 80 79 10 80       	push   $0x80107980
80103c0f:	68 80 2d 11 80       	push   $0x80112d80
80103c14:	e8 17 0b 00 00       	call   80104730 <initlock>
}
80103c19:	83 c4 10             	add    $0x10,%esp
80103c1c:	c9                   	leave  
80103c1d:	c3                   	ret    
80103c1e:	66 90                	xchg   %ax,%ax

80103c20 <mycpu>:
{
80103c20:	f3 0f 1e fb          	endbr32 
80103c24:	55                   	push   %ebp
80103c25:	89 e5                	mov    %esp,%ebp
80103c27:	56                   	push   %esi
80103c28:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c29:	9c                   	pushf  
80103c2a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c2b:	f6 c4 02             	test   $0x2,%ah
80103c2e:	75 4a                	jne    80103c7a <mycpu+0x5a>
  apicid = lapicid();
80103c30:	e8 bb ef ff ff       	call   80102bf0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103c35:	8b 35 60 2d 11 80    	mov    0x80112d60,%esi
  apicid = lapicid();
80103c3b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103c3d:	85 f6                	test   %esi,%esi
80103c3f:	7e 2c                	jle    80103c6d <mycpu+0x4d>
80103c41:	31 d2                	xor    %edx,%edx
80103c43:	eb 0a                	jmp    80103c4f <mycpu+0x2f>
80103c45:	8d 76 00             	lea    0x0(%esi),%esi
80103c48:	83 c2 01             	add    $0x1,%edx
80103c4b:	39 f2                	cmp    %esi,%edx
80103c4d:	74 1e                	je     80103c6d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103c4f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103c55:	0f b6 81 e0 27 11 80 	movzbl -0x7feed820(%ecx),%eax
80103c5c:	39 d8                	cmp    %ebx,%eax
80103c5e:	75 e8                	jne    80103c48 <mycpu+0x28>
}
80103c60:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103c63:	8d 81 e0 27 11 80    	lea    -0x7feed820(%ecx),%eax
}
80103c69:	5b                   	pop    %ebx
80103c6a:	5e                   	pop    %esi
80103c6b:	5d                   	pop    %ebp
80103c6c:	c3                   	ret    
  panic("unknown apicid\n");
80103c6d:	83 ec 0c             	sub    $0xc,%esp
80103c70:	68 87 79 10 80       	push   $0x80107987
80103c75:	e8 96 c9 ff ff       	call   80100610 <panic>
    panic("mycpu called with interrupts enabled\n");
80103c7a:	83 ec 0c             	sub    $0xc,%esp
80103c7d:	68 64 7a 10 80       	push   $0x80107a64
80103c82:	e8 89 c9 ff ff       	call   80100610 <panic>
80103c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c8e:	66 90                	xchg   %ax,%ax

80103c90 <cpuid>:
cpuid() {
80103c90:	f3 0f 1e fb          	endbr32 
80103c94:	55                   	push   %ebp
80103c95:	89 e5                	mov    %esp,%ebp
80103c97:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c9a:	e8 81 ff ff ff       	call   80103c20 <mycpu>
}
80103c9f:	c9                   	leave  
  return mycpu()-cpus;
80103ca0:	2d e0 27 11 80       	sub    $0x801127e0,%eax
80103ca5:	c1 f8 04             	sar    $0x4,%eax
80103ca8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103cae:	c3                   	ret    
80103caf:	90                   	nop

80103cb0 <myproc>:
myproc(void) {
80103cb0:	f3 0f 1e fb          	endbr32 
80103cb4:	55                   	push   %ebp
80103cb5:	89 e5                	mov    %esp,%ebp
80103cb7:	53                   	push   %ebx
80103cb8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103cbb:	e8 f0 0a 00 00       	call   801047b0 <pushcli>
  c = mycpu();
80103cc0:	e8 5b ff ff ff       	call   80103c20 <mycpu>
  p = c->proc;
80103cc5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ccb:	e8 30 0b 00 00       	call   80104800 <popcli>
}
80103cd0:	83 c4 04             	add    $0x4,%esp
80103cd3:	89 d8                	mov    %ebx,%eax
80103cd5:	5b                   	pop    %ebx
80103cd6:	5d                   	pop    %ebp
80103cd7:	c3                   	ret    
80103cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cdf:	90                   	nop

80103ce0 <userinit>:
{
80103ce0:	f3 0f 1e fb          	endbr32 
80103ce4:	55                   	push   %ebp
80103ce5:	89 e5                	mov    %esp,%ebp
80103ce7:	53                   	push   %ebx
80103ce8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ceb:	e8 f0 fd ff ff       	call   80103ae0 <allocproc>
80103cf0:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103cf2:	a3 d8 a5 10 80       	mov    %eax,0x8010a5d8
  if((p->pgdir = setupkvm()) == 0)
80103cf7:	e8 a4 34 00 00       	call   801071a0 <setupkvm>
80103cfc:	89 43 04             	mov    %eax,0x4(%ebx)
80103cff:	85 c0                	test   %eax,%eax
80103d01:	0f 84 bd 00 00 00    	je     80103dc4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103d07:	83 ec 04             	sub    $0x4,%esp
80103d0a:	68 2c 00 00 00       	push   $0x2c
80103d0f:	68 60 a4 10 80       	push   $0x8010a460
80103d14:	50                   	push   %eax
80103d15:	e8 56 31 00 00       	call   80106e70 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103d1a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103d1d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103d23:	6a 4c                	push   $0x4c
80103d25:	6a 00                	push   $0x0
80103d27:	ff 73 18             	pushl  0x18(%ebx)
80103d2a:	e8 91 0c 00 00       	call   801049c0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103d32:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d37:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d3a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d3f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d43:	8b 43 18             	mov    0x18(%ebx),%eax
80103d46:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103d4a:	8b 43 18             	mov    0x18(%ebx),%eax
80103d4d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d51:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d55:	8b 43 18             	mov    0x18(%ebx),%eax
80103d58:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d5c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d60:	8b 43 18             	mov    0x18(%ebx),%eax
80103d63:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d6a:	8b 43 18             	mov    0x18(%ebx),%eax
80103d6d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d74:	8b 43 18             	mov    0x18(%ebx),%eax
80103d77:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d7e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d81:	6a 10                	push   $0x10
80103d83:	68 b0 79 10 80       	push   $0x801079b0
80103d88:	50                   	push   %eax
80103d89:	e8 f2 0d 00 00       	call   80104b80 <safestrcpy>
  p->cwd = namei("/");
80103d8e:	c7 04 24 b9 79 10 80 	movl   $0x801079b9,(%esp)
80103d95:	e8 e6 e5 ff ff       	call   80102380 <namei>
80103d9a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103d9d:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103da4:	e8 07 0b 00 00       	call   801048b0 <acquire>
  p->state = RUNNABLE;
80103da9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103db0:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103db7:	e8 b4 0b 00 00       	call   80104970 <release>
}
80103dbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dbf:	83 c4 10             	add    $0x10,%esp
80103dc2:	c9                   	leave  
80103dc3:	c3                   	ret    
    panic("userinit: out of memory?");
80103dc4:	83 ec 0c             	sub    $0xc,%esp
80103dc7:	68 97 79 10 80       	push   $0x80107997
80103dcc:	e8 3f c8 ff ff       	call   80100610 <panic>
80103dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ddf:	90                   	nop

80103de0 <growproc>:
{
80103de0:	f3 0f 1e fb          	endbr32 
80103de4:	55                   	push   %ebp
80103de5:	89 e5                	mov    %esp,%ebp
80103de7:	56                   	push   %esi
80103de8:	53                   	push   %ebx
80103de9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103dec:	e8 bf 09 00 00       	call   801047b0 <pushcli>
  c = mycpu();
80103df1:	e8 2a fe ff ff       	call   80103c20 <mycpu>
  p = c->proc;
80103df6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dfc:	e8 ff 09 00 00       	call   80104800 <popcli>
  sz = curproc->sz;
80103e01:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103e03:	85 f6                	test   %esi,%esi
80103e05:	7f 19                	jg     80103e20 <growproc+0x40>
  } else if(n < 0){
80103e07:	75 37                	jne    80103e40 <growproc+0x60>
  switchuvm(curproc);
80103e09:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103e0c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103e0e:	53                   	push   %ebx
80103e0f:	e8 4c 2f 00 00       	call   80106d60 <switchuvm>
  return 0;
80103e14:	83 c4 10             	add    $0x10,%esp
80103e17:	31 c0                	xor    %eax,%eax
}
80103e19:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e1c:	5b                   	pop    %ebx
80103e1d:	5e                   	pop    %esi
80103e1e:	5d                   	pop    %ebp
80103e1f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e20:	83 ec 04             	sub    $0x4,%esp
80103e23:	01 c6                	add    %eax,%esi
80103e25:	56                   	push   %esi
80103e26:	50                   	push   %eax
80103e27:	ff 73 04             	pushl  0x4(%ebx)
80103e2a:	e8 91 31 00 00       	call   80106fc0 <allocuvm>
80103e2f:	83 c4 10             	add    $0x10,%esp
80103e32:	85 c0                	test   %eax,%eax
80103e34:	75 d3                	jne    80103e09 <growproc+0x29>
      return -1;
80103e36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e3b:	eb dc                	jmp    80103e19 <growproc+0x39>
80103e3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e40:	83 ec 04             	sub    $0x4,%esp
80103e43:	01 c6                	add    %eax,%esi
80103e45:	56                   	push   %esi
80103e46:	50                   	push   %eax
80103e47:	ff 73 04             	pushl  0x4(%ebx)
80103e4a:	e8 a1 32 00 00       	call   801070f0 <deallocuvm>
80103e4f:	83 c4 10             	add    $0x10,%esp
80103e52:	85 c0                	test   %eax,%eax
80103e54:	75 b3                	jne    80103e09 <growproc+0x29>
80103e56:	eb de                	jmp    80103e36 <growproc+0x56>
80103e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e5f:	90                   	nop

80103e60 <fork>:
{
80103e60:	f3 0f 1e fb          	endbr32 
80103e64:	55                   	push   %ebp
80103e65:	89 e5                	mov    %esp,%ebp
80103e67:	57                   	push   %edi
80103e68:	56                   	push   %esi
80103e69:	53                   	push   %ebx
80103e6a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103e6d:	e8 3e 09 00 00       	call   801047b0 <pushcli>
  c = mycpu();
80103e72:	e8 a9 fd ff ff       	call   80103c20 <mycpu>
  p = c->proc;
80103e77:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e7d:	e8 7e 09 00 00       	call   80104800 <popcli>
  if((np = allocproc()) == 0){
80103e82:	e8 59 fc ff ff       	call   80103ae0 <allocproc>
80103e87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e8a:	85 c0                	test   %eax,%eax
80103e8c:	0f 84 bb 00 00 00    	je     80103f4d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103e92:	83 ec 08             	sub    $0x8,%esp
80103e95:	ff 33                	pushl  (%ebx)
80103e97:	89 c7                	mov    %eax,%edi
80103e99:	ff 73 04             	pushl  0x4(%ebx)
80103e9c:	e8 cf 33 00 00       	call   80107270 <copyuvm>
80103ea1:	83 c4 10             	add    $0x10,%esp
80103ea4:	89 47 04             	mov    %eax,0x4(%edi)
80103ea7:	85 c0                	test   %eax,%eax
80103ea9:	0f 84 a5 00 00 00    	je     80103f54 <fork+0xf4>
  np->sz = curproc->sz;
80103eaf:	8b 03                	mov    (%ebx),%eax
80103eb1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103eb4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103eb6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103eb9:	89 c8                	mov    %ecx,%eax
80103ebb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103ebe:	b9 13 00 00 00       	mov    $0x13,%ecx
80103ec3:	8b 73 18             	mov    0x18(%ebx),%esi
80103ec6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ec8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103eca:	8b 40 18             	mov    0x18(%eax),%eax
80103ecd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103ed8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103edc:	85 c0                	test   %eax,%eax
80103ede:	74 13                	je     80103ef3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ee0:	83 ec 0c             	sub    $0xc,%esp
80103ee3:	50                   	push   %eax
80103ee4:	e8 d7 d2 ff ff       	call   801011c0 <filedup>
80103ee9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103eec:	83 c4 10             	add    $0x10,%esp
80103eef:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103ef3:	83 c6 01             	add    $0x1,%esi
80103ef6:	83 fe 10             	cmp    $0x10,%esi
80103ef9:	75 dd                	jne    80103ed8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103efb:	83 ec 0c             	sub    $0xc,%esp
80103efe:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f01:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103f04:	e8 77 db ff ff       	call   80101a80 <idup>
80103f09:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f0c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103f0f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f12:	8d 47 6c             	lea    0x6c(%edi),%eax
80103f15:	6a 10                	push   $0x10
80103f17:	53                   	push   %ebx
80103f18:	50                   	push   %eax
80103f19:	e8 62 0c 00 00       	call   80104b80 <safestrcpy>
  pid = np->pid;
80103f1e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103f21:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103f28:	e8 83 09 00 00       	call   801048b0 <acquire>
  np->state = RUNNABLE;
80103f2d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103f34:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103f3b:	e8 30 0a 00 00       	call   80104970 <release>
  return pid;
80103f40:	83 c4 10             	add    $0x10,%esp
}
80103f43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f46:	89 d8                	mov    %ebx,%eax
80103f48:	5b                   	pop    %ebx
80103f49:	5e                   	pop    %esi
80103f4a:	5f                   	pop    %edi
80103f4b:	5d                   	pop    %ebp
80103f4c:	c3                   	ret    
    return -1;
80103f4d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f52:	eb ef                	jmp    80103f43 <fork+0xe3>
    kfree(np->kstack);
80103f54:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103f57:	83 ec 0c             	sub    $0xc,%esp
80103f5a:	ff 73 08             	pushl  0x8(%ebx)
80103f5d:	e8 5e e8 ff ff       	call   801027c0 <kfree>
    np->kstack = 0;
80103f62:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103f69:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103f6c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103f73:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f78:	eb c9                	jmp    80103f43 <fork+0xe3>
80103f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f80 <scheduler>:
{
80103f80:	f3 0f 1e fb          	endbr32 
80103f84:	55                   	push   %ebp
80103f85:	89 e5                	mov    %esp,%ebp
80103f87:	57                   	push   %edi
80103f88:	56                   	push   %esi
80103f89:	53                   	push   %ebx
80103f8a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103f8d:	e8 8e fc ff ff       	call   80103c20 <mycpu>
  c->proc = 0;
80103f92:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f99:	00 00 00 
  struct cpu *c = mycpu();
80103f9c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103f9e:	8d 78 04             	lea    0x4(%eax),%edi
80103fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103fa8:	fb                   	sti    
    acquire(&ptable.lock);
80103fa9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fac:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
    acquire(&ptable.lock);
80103fb1:	68 80 2d 11 80       	push   $0x80112d80
80103fb6:	e8 f5 08 00 00       	call   801048b0 <acquire>
80103fbb:	83 c4 10             	add    $0x10,%esp
80103fbe:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103fc0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103fc4:	75 33                	jne    80103ff9 <scheduler+0x79>
      switchuvm(p);
80103fc6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103fc9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103fcf:	53                   	push   %ebx
80103fd0:	e8 8b 2d 00 00       	call   80106d60 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103fd5:	58                   	pop    %eax
80103fd6:	5a                   	pop    %edx
80103fd7:	ff 73 1c             	pushl  0x1c(%ebx)
80103fda:	57                   	push   %edi
      p->state = RUNNING;
80103fdb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103fe2:	e8 fc 0b 00 00       	call   80104be3 <swtch>
      switchkvm();
80103fe7:	e8 54 2d 00 00       	call   80106d40 <switchkvm>
      c->proc = 0;
80103fec:	83 c4 10             	add    $0x10,%esp
80103fef:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ff6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ff9:	83 c3 7c             	add    $0x7c,%ebx
80103ffc:	81 fb b4 4c 11 80    	cmp    $0x80114cb4,%ebx
80104002:	75 bc                	jne    80103fc0 <scheduler+0x40>
    release(&ptable.lock);
80104004:	83 ec 0c             	sub    $0xc,%esp
80104007:	68 80 2d 11 80       	push   $0x80112d80
8010400c:	e8 5f 09 00 00       	call   80104970 <release>
    sti();
80104011:	83 c4 10             	add    $0x10,%esp
80104014:	eb 92                	jmp    80103fa8 <scheduler+0x28>
80104016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010401d:	8d 76 00             	lea    0x0(%esi),%esi

80104020 <sched>:
{
80104020:	f3 0f 1e fb          	endbr32 
80104024:	55                   	push   %ebp
80104025:	89 e5                	mov    %esp,%ebp
80104027:	56                   	push   %esi
80104028:	53                   	push   %ebx
  pushcli();
80104029:	e8 82 07 00 00       	call   801047b0 <pushcli>
  c = mycpu();
8010402e:	e8 ed fb ff ff       	call   80103c20 <mycpu>
  p = c->proc;
80104033:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104039:	e8 c2 07 00 00       	call   80104800 <popcli>
  if(!holding(&ptable.lock))
8010403e:	83 ec 0c             	sub    $0xc,%esp
80104041:	68 80 2d 11 80       	push   $0x80112d80
80104046:	e8 15 08 00 00       	call   80104860 <holding>
8010404b:	83 c4 10             	add    $0x10,%esp
8010404e:	85 c0                	test   %eax,%eax
80104050:	74 4f                	je     801040a1 <sched+0x81>
  if(mycpu()->ncli != 1)
80104052:	e8 c9 fb ff ff       	call   80103c20 <mycpu>
80104057:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010405e:	75 68                	jne    801040c8 <sched+0xa8>
  if(p->state == RUNNING)
80104060:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104064:	74 55                	je     801040bb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104066:	9c                   	pushf  
80104067:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104068:	f6 c4 02             	test   $0x2,%ah
8010406b:	75 41                	jne    801040ae <sched+0x8e>
  intena = mycpu()->intena;
8010406d:	e8 ae fb ff ff       	call   80103c20 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104072:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104075:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010407b:	e8 a0 fb ff ff       	call   80103c20 <mycpu>
80104080:	83 ec 08             	sub    $0x8,%esp
80104083:	ff 70 04             	pushl  0x4(%eax)
80104086:	53                   	push   %ebx
80104087:	e8 57 0b 00 00       	call   80104be3 <swtch>
  mycpu()->intena = intena;
8010408c:	e8 8f fb ff ff       	call   80103c20 <mycpu>
}
80104091:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104094:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010409a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010409d:	5b                   	pop    %ebx
8010409e:	5e                   	pop    %esi
8010409f:	5d                   	pop    %ebp
801040a0:	c3                   	ret    
    panic("sched ptable.lock");
801040a1:	83 ec 0c             	sub    $0xc,%esp
801040a4:	68 bb 79 10 80       	push   $0x801079bb
801040a9:	e8 62 c5 ff ff       	call   80100610 <panic>
    panic("sched interruptible");
801040ae:	83 ec 0c             	sub    $0xc,%esp
801040b1:	68 e7 79 10 80       	push   $0x801079e7
801040b6:	e8 55 c5 ff ff       	call   80100610 <panic>
    panic("sched running");
801040bb:	83 ec 0c             	sub    $0xc,%esp
801040be:	68 d9 79 10 80       	push   $0x801079d9
801040c3:	e8 48 c5 ff ff       	call   80100610 <panic>
    panic("sched locks");
801040c8:	83 ec 0c             	sub    $0xc,%esp
801040cb:	68 cd 79 10 80       	push   $0x801079cd
801040d0:	e8 3b c5 ff ff       	call   80100610 <panic>
801040d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801040e0 <exit>:
{
801040e0:	f3 0f 1e fb          	endbr32 
801040e4:	55                   	push   %ebp
801040e5:	89 e5                	mov    %esp,%ebp
801040e7:	57                   	push   %edi
801040e8:	56                   	push   %esi
801040e9:	53                   	push   %ebx
801040ea:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801040ed:	e8 be 06 00 00       	call   801047b0 <pushcli>
  c = mycpu();
801040f2:	e8 29 fb ff ff       	call   80103c20 <mycpu>
  p = c->proc;
801040f7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040fd:	e8 fe 06 00 00       	call   80104800 <popcli>
  if(curproc == initproc)
80104102:	8d 5e 28             	lea    0x28(%esi),%ebx
80104105:	8d 7e 68             	lea    0x68(%esi),%edi
80104108:	39 35 d8 a5 10 80    	cmp    %esi,0x8010a5d8
8010410e:	0f 84 f3 00 00 00    	je     80104207 <exit+0x127>
80104114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104118:	8b 03                	mov    (%ebx),%eax
8010411a:	85 c0                	test   %eax,%eax
8010411c:	74 12                	je     80104130 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010411e:	83 ec 0c             	sub    $0xc,%esp
80104121:	50                   	push   %eax
80104122:	e8 e9 d0 ff ff       	call   80101210 <fileclose>
      curproc->ofile[fd] = 0;
80104127:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010412d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104130:	83 c3 04             	add    $0x4,%ebx
80104133:	39 df                	cmp    %ebx,%edi
80104135:	75 e1                	jne    80104118 <exit+0x38>
  begin_op();
80104137:	e8 44 ef ff ff       	call   80103080 <begin_op>
  iput(curproc->cwd);
8010413c:	83 ec 0c             	sub    $0xc,%esp
8010413f:	ff 76 68             	pushl  0x68(%esi)
80104142:	e8 99 da ff ff       	call   80101be0 <iput>
  end_op();
80104147:	e8 a4 ef ff ff       	call   801030f0 <end_op>
  curproc->cwd = 0;
8010414c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104153:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
8010415a:	e8 51 07 00 00       	call   801048b0 <acquire>
  wakeup1(curproc->parent);
8010415f:	8b 56 14             	mov    0x14(%esi),%edx
80104162:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104165:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
8010416a:	eb 0e                	jmp    8010417a <exit+0x9a>
8010416c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104170:	83 c0 7c             	add    $0x7c,%eax
80104173:	3d b4 4c 11 80       	cmp    $0x80114cb4,%eax
80104178:	74 1c                	je     80104196 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
8010417a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010417e:	75 f0                	jne    80104170 <exit+0x90>
80104180:	3b 50 20             	cmp    0x20(%eax),%edx
80104183:	75 eb                	jne    80104170 <exit+0x90>
      p->state = RUNNABLE;
80104185:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010418c:	83 c0 7c             	add    $0x7c,%eax
8010418f:	3d b4 4c 11 80       	cmp    $0x80114cb4,%eax
80104194:	75 e4                	jne    8010417a <exit+0x9a>
      p->parent = initproc;
80104196:	8b 0d d8 a5 10 80    	mov    0x8010a5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010419c:	ba b4 2d 11 80       	mov    $0x80112db4,%edx
801041a1:	eb 10                	jmp    801041b3 <exit+0xd3>
801041a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041a7:	90                   	nop
801041a8:	83 c2 7c             	add    $0x7c,%edx
801041ab:	81 fa b4 4c 11 80    	cmp    $0x80114cb4,%edx
801041b1:	74 3b                	je     801041ee <exit+0x10e>
    if(p->parent == curproc){
801041b3:	39 72 14             	cmp    %esi,0x14(%edx)
801041b6:	75 f0                	jne    801041a8 <exit+0xc8>
      if(p->state == ZOMBIE)
801041b8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801041bc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801041bf:	75 e7                	jne    801041a8 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041c1:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
801041c6:	eb 12                	jmp    801041da <exit+0xfa>
801041c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041cf:	90                   	nop
801041d0:	83 c0 7c             	add    $0x7c,%eax
801041d3:	3d b4 4c 11 80       	cmp    $0x80114cb4,%eax
801041d8:	74 ce                	je     801041a8 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
801041da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041de:	75 f0                	jne    801041d0 <exit+0xf0>
801041e0:	3b 48 20             	cmp    0x20(%eax),%ecx
801041e3:	75 eb                	jne    801041d0 <exit+0xf0>
      p->state = RUNNABLE;
801041e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801041ec:	eb e2                	jmp    801041d0 <exit+0xf0>
  curproc->state = ZOMBIE;
801041ee:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801041f5:	e8 26 fe ff ff       	call   80104020 <sched>
  panic("zombie exit");
801041fa:	83 ec 0c             	sub    $0xc,%esp
801041fd:	68 08 7a 10 80       	push   $0x80107a08
80104202:	e8 09 c4 ff ff       	call   80100610 <panic>
    panic("init exiting");
80104207:	83 ec 0c             	sub    $0xc,%esp
8010420a:	68 fb 79 10 80       	push   $0x801079fb
8010420f:	e8 fc c3 ff ff       	call   80100610 <panic>
80104214:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010421b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010421f:	90                   	nop

80104220 <yield>:
{
80104220:	f3 0f 1e fb          	endbr32 
80104224:	55                   	push   %ebp
80104225:	89 e5                	mov    %esp,%ebp
80104227:	53                   	push   %ebx
80104228:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010422b:	68 80 2d 11 80       	push   $0x80112d80
80104230:	e8 7b 06 00 00       	call   801048b0 <acquire>
  pushcli();
80104235:	e8 76 05 00 00       	call   801047b0 <pushcli>
  c = mycpu();
8010423a:	e8 e1 f9 ff ff       	call   80103c20 <mycpu>
  p = c->proc;
8010423f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104245:	e8 b6 05 00 00       	call   80104800 <popcli>
  myproc()->state = RUNNABLE;
8010424a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104251:	e8 ca fd ff ff       	call   80104020 <sched>
  release(&ptable.lock);
80104256:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
8010425d:	e8 0e 07 00 00       	call   80104970 <release>
}
80104262:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104265:	83 c4 10             	add    $0x10,%esp
80104268:	c9                   	leave  
80104269:	c3                   	ret    
8010426a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104270 <sleep>:
{
80104270:	f3 0f 1e fb          	endbr32 
80104274:	55                   	push   %ebp
80104275:	89 e5                	mov    %esp,%ebp
80104277:	57                   	push   %edi
80104278:	56                   	push   %esi
80104279:	53                   	push   %ebx
8010427a:	83 ec 0c             	sub    $0xc,%esp
8010427d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104280:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104283:	e8 28 05 00 00       	call   801047b0 <pushcli>
  c = mycpu();
80104288:	e8 93 f9 ff ff       	call   80103c20 <mycpu>
  p = c->proc;
8010428d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104293:	e8 68 05 00 00       	call   80104800 <popcli>
  if(p == 0)
80104298:	85 db                	test   %ebx,%ebx
8010429a:	0f 84 83 00 00 00    	je     80104323 <sleep+0xb3>
  if(lk == 0)
801042a0:	85 f6                	test   %esi,%esi
801042a2:	74 72                	je     80104316 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042a4:	81 fe 80 2d 11 80    	cmp    $0x80112d80,%esi
801042aa:	74 4c                	je     801042f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042ac:	83 ec 0c             	sub    $0xc,%esp
801042af:	68 80 2d 11 80       	push   $0x80112d80
801042b4:	e8 f7 05 00 00       	call   801048b0 <acquire>
    release(lk);
801042b9:	89 34 24             	mov    %esi,(%esp)
801042bc:	e8 af 06 00 00       	call   80104970 <release>
  p->chan = chan;
801042c1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042c4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042cb:	e8 50 fd ff ff       	call   80104020 <sched>
  p->chan = 0;
801042d0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801042d7:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
801042de:	e8 8d 06 00 00       	call   80104970 <release>
    acquire(lk);
801042e3:	89 75 08             	mov    %esi,0x8(%ebp)
801042e6:	83 c4 10             	add    $0x10,%esp
}
801042e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042ec:	5b                   	pop    %ebx
801042ed:	5e                   	pop    %esi
801042ee:	5f                   	pop    %edi
801042ef:	5d                   	pop    %ebp
    acquire(lk);
801042f0:	e9 bb 05 00 00       	jmp    801048b0 <acquire>
801042f5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801042f8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104302:	e8 19 fd ff ff       	call   80104020 <sched>
  p->chan = 0;
80104307:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010430e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104311:	5b                   	pop    %ebx
80104312:	5e                   	pop    %esi
80104313:	5f                   	pop    %edi
80104314:	5d                   	pop    %ebp
80104315:	c3                   	ret    
    panic("sleep without lk");
80104316:	83 ec 0c             	sub    $0xc,%esp
80104319:	68 1a 7a 10 80       	push   $0x80107a1a
8010431e:	e8 ed c2 ff ff       	call   80100610 <panic>
    panic("sleep");
80104323:	83 ec 0c             	sub    $0xc,%esp
80104326:	68 14 7a 10 80       	push   $0x80107a14
8010432b:	e8 e0 c2 ff ff       	call   80100610 <panic>

80104330 <wait>:
{
80104330:	f3 0f 1e fb          	endbr32 
80104334:	55                   	push   %ebp
80104335:	89 e5                	mov    %esp,%ebp
80104337:	56                   	push   %esi
80104338:	53                   	push   %ebx
  pushcli();
80104339:	e8 72 04 00 00       	call   801047b0 <pushcli>
  c = mycpu();
8010433e:	e8 dd f8 ff ff       	call   80103c20 <mycpu>
  p = c->proc;
80104343:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104349:	e8 b2 04 00 00       	call   80104800 <popcli>
  acquire(&ptable.lock);
8010434e:	83 ec 0c             	sub    $0xc,%esp
80104351:	68 80 2d 11 80       	push   $0x80112d80
80104356:	e8 55 05 00 00       	call   801048b0 <acquire>
8010435b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010435e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104360:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
80104365:	eb 14                	jmp    8010437b <wait+0x4b>
80104367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010436e:	66 90                	xchg   %ax,%ax
80104370:	83 c3 7c             	add    $0x7c,%ebx
80104373:	81 fb b4 4c 11 80    	cmp    $0x80114cb4,%ebx
80104379:	74 1b                	je     80104396 <wait+0x66>
      if(p->parent != curproc)
8010437b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010437e:	75 f0                	jne    80104370 <wait+0x40>
      if(p->state == ZOMBIE){
80104380:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104384:	74 32                	je     801043b8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104386:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104389:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010438e:	81 fb b4 4c 11 80    	cmp    $0x80114cb4,%ebx
80104394:	75 e5                	jne    8010437b <wait+0x4b>
    if(!havekids || curproc->killed){
80104396:	85 c0                	test   %eax,%eax
80104398:	74 74                	je     8010440e <wait+0xde>
8010439a:	8b 46 24             	mov    0x24(%esi),%eax
8010439d:	85 c0                	test   %eax,%eax
8010439f:	75 6d                	jne    8010440e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801043a1:	83 ec 08             	sub    $0x8,%esp
801043a4:	68 80 2d 11 80       	push   $0x80112d80
801043a9:	56                   	push   %esi
801043aa:	e8 c1 fe ff ff       	call   80104270 <sleep>
    havekids = 0;
801043af:	83 c4 10             	add    $0x10,%esp
801043b2:	eb aa                	jmp    8010435e <wait+0x2e>
801043b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801043b8:	83 ec 0c             	sub    $0xc,%esp
801043bb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801043be:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801043c1:	e8 fa e3 ff ff       	call   801027c0 <kfree>
        freevm(p->pgdir);
801043c6:	5a                   	pop    %edx
801043c7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801043ca:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801043d1:	e8 4a 2d 00 00       	call   80107120 <freevm>
        release(&ptable.lock);
801043d6:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
        p->pid = 0;
801043dd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801043e4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801043eb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801043ef:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801043f6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801043fd:	e8 6e 05 00 00       	call   80104970 <release>
        return pid;
80104402:	83 c4 10             	add    $0x10,%esp
}
80104405:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104408:	89 f0                	mov    %esi,%eax
8010440a:	5b                   	pop    %ebx
8010440b:	5e                   	pop    %esi
8010440c:	5d                   	pop    %ebp
8010440d:	c3                   	ret    
      release(&ptable.lock);
8010440e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104411:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104416:	68 80 2d 11 80       	push   $0x80112d80
8010441b:	e8 50 05 00 00       	call   80104970 <release>
      return -1;
80104420:	83 c4 10             	add    $0x10,%esp
80104423:	eb e0                	jmp    80104405 <wait+0xd5>
80104425:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010442c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104430 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104430:	f3 0f 1e fb          	endbr32 
80104434:	55                   	push   %ebp
80104435:	89 e5                	mov    %esp,%ebp
80104437:	53                   	push   %ebx
80104438:	83 ec 10             	sub    $0x10,%esp
8010443b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010443e:	68 80 2d 11 80       	push   $0x80112d80
80104443:	e8 68 04 00 00       	call   801048b0 <acquire>
80104448:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010444b:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
80104450:	eb 10                	jmp    80104462 <wakeup+0x32>
80104452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104458:	83 c0 7c             	add    $0x7c,%eax
8010445b:	3d b4 4c 11 80       	cmp    $0x80114cb4,%eax
80104460:	74 1c                	je     8010447e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104462:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104466:	75 f0                	jne    80104458 <wakeup+0x28>
80104468:	3b 58 20             	cmp    0x20(%eax),%ebx
8010446b:	75 eb                	jne    80104458 <wakeup+0x28>
      p->state = RUNNABLE;
8010446d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104474:	83 c0 7c             	add    $0x7c,%eax
80104477:	3d b4 4c 11 80       	cmp    $0x80114cb4,%eax
8010447c:	75 e4                	jne    80104462 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010447e:	c7 45 08 80 2d 11 80 	movl   $0x80112d80,0x8(%ebp)
}
80104485:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104488:	c9                   	leave  
  release(&ptable.lock);
80104489:	e9 e2 04 00 00       	jmp    80104970 <release>
8010448e:	66 90                	xchg   %ax,%ax

80104490 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104490:	f3 0f 1e fb          	endbr32 
80104494:	55                   	push   %ebp
80104495:	89 e5                	mov    %esp,%ebp
80104497:	53                   	push   %ebx
80104498:	83 ec 10             	sub    $0x10,%esp
8010449b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010449e:	68 80 2d 11 80       	push   $0x80112d80
801044a3:	e8 08 04 00 00       	call   801048b0 <acquire>
801044a8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ab:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
801044b0:	eb 10                	jmp    801044c2 <kill+0x32>
801044b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044b8:	83 c0 7c             	add    $0x7c,%eax
801044bb:	3d b4 4c 11 80       	cmp    $0x80114cb4,%eax
801044c0:	74 36                	je     801044f8 <kill+0x68>
    if(p->pid == pid){
801044c2:	39 58 10             	cmp    %ebx,0x10(%eax)
801044c5:	75 f1                	jne    801044b8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801044c7:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801044cb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801044d2:	75 07                	jne    801044db <kill+0x4b>
        p->state = RUNNABLE;
801044d4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801044db:	83 ec 0c             	sub    $0xc,%esp
801044de:	68 80 2d 11 80       	push   $0x80112d80
801044e3:	e8 88 04 00 00       	call   80104970 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801044e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801044eb:	83 c4 10             	add    $0x10,%esp
801044ee:	31 c0                	xor    %eax,%eax
}
801044f0:	c9                   	leave  
801044f1:	c3                   	ret    
801044f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801044f8:	83 ec 0c             	sub    $0xc,%esp
801044fb:	68 80 2d 11 80       	push   $0x80112d80
80104500:	e8 6b 04 00 00       	call   80104970 <release>
}
80104505:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104508:	83 c4 10             	add    $0x10,%esp
8010450b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104510:	c9                   	leave  
80104511:	c3                   	ret    
80104512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104520 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104520:	f3 0f 1e fb          	endbr32 
80104524:	55                   	push   %ebp
80104525:	89 e5                	mov    %esp,%ebp
80104527:	57                   	push   %edi
80104528:	56                   	push   %esi
80104529:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010452c:	53                   	push   %ebx
8010452d:	bb 20 2e 11 80       	mov    $0x80112e20,%ebx
80104532:	83 ec 3c             	sub    $0x3c,%esp
80104535:	eb 28                	jmp    8010455f <procdump+0x3f>
80104537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010453e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104540:	83 ec 0c             	sub    $0xc,%esp
80104543:	68 97 7d 10 80       	push   $0x80107d97
80104548:	e8 43 c1 ff ff       	call   80100690 <cprintf>
8010454d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104550:	83 c3 7c             	add    $0x7c,%ebx
80104553:	81 fb 20 4d 11 80    	cmp    $0x80114d20,%ebx
80104559:	0f 84 81 00 00 00    	je     801045e0 <procdump+0xc0>
    if(p->state == UNUSED)
8010455f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104562:	85 c0                	test   %eax,%eax
80104564:	74 ea                	je     80104550 <procdump+0x30>
      state = "???";
80104566:	ba 2b 7a 10 80       	mov    $0x80107a2b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010456b:	83 f8 05             	cmp    $0x5,%eax
8010456e:	77 11                	ja     80104581 <procdump+0x61>
80104570:	8b 14 85 8c 7a 10 80 	mov    -0x7fef8574(,%eax,4),%edx
      state = "???";
80104577:	b8 2b 7a 10 80       	mov    $0x80107a2b,%eax
8010457c:	85 d2                	test   %edx,%edx
8010457e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104581:	53                   	push   %ebx
80104582:	52                   	push   %edx
80104583:	ff 73 a4             	pushl  -0x5c(%ebx)
80104586:	68 2f 7a 10 80       	push   $0x80107a2f
8010458b:	e8 00 c1 ff ff       	call   80100690 <cprintf>
    if(p->state == SLEEPING){
80104590:	83 c4 10             	add    $0x10,%esp
80104593:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104597:	75 a7                	jne    80104540 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104599:	83 ec 08             	sub    $0x8,%esp
8010459c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010459f:	8d 7d c0             	lea    -0x40(%ebp),%edi
801045a2:	50                   	push   %eax
801045a3:	8b 43 b0             	mov    -0x50(%ebx),%eax
801045a6:	8b 40 0c             	mov    0xc(%eax),%eax
801045a9:	83 c0 08             	add    $0x8,%eax
801045ac:	50                   	push   %eax
801045ad:	e8 9e 01 00 00       	call   80104750 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801045b2:	83 c4 10             	add    $0x10,%esp
801045b5:	8d 76 00             	lea    0x0(%esi),%esi
801045b8:	8b 17                	mov    (%edi),%edx
801045ba:	85 d2                	test   %edx,%edx
801045bc:	74 82                	je     80104540 <procdump+0x20>
        cprintf(" %p", pc[i]);
801045be:	83 ec 08             	sub    $0x8,%esp
801045c1:	83 c7 04             	add    $0x4,%edi
801045c4:	52                   	push   %edx
801045c5:	68 81 74 10 80       	push   $0x80107481
801045ca:	e8 c1 c0 ff ff       	call   80100690 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801045cf:	83 c4 10             	add    $0x10,%esp
801045d2:	39 fe                	cmp    %edi,%esi
801045d4:	75 e2                	jne    801045b8 <procdump+0x98>
801045d6:	e9 65 ff ff ff       	jmp    80104540 <procdump+0x20>
801045db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045df:	90                   	nop
  }
}
801045e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045e3:	5b                   	pop    %ebx
801045e4:	5e                   	pop    %esi
801045e5:	5f                   	pop    %edi
801045e6:	5d                   	pop    %ebp
801045e7:	c3                   	ret    
801045e8:	66 90                	xchg   %ax,%ax
801045ea:	66 90                	xchg   %ax,%ax
801045ec:	66 90                	xchg   %ax,%ax
801045ee:	66 90                	xchg   %ax,%ax

801045f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801045f0:	f3 0f 1e fb          	endbr32 
801045f4:	55                   	push   %ebp
801045f5:	89 e5                	mov    %esp,%ebp
801045f7:	53                   	push   %ebx
801045f8:	83 ec 0c             	sub    $0xc,%esp
801045fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801045fe:	68 a4 7a 10 80       	push   $0x80107aa4
80104603:	8d 43 04             	lea    0x4(%ebx),%eax
80104606:	50                   	push   %eax
80104607:	e8 24 01 00 00       	call   80104730 <initlock>
  lk->name = name;
8010460c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010460f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104615:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104618:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010461f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104622:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104625:	c9                   	leave  
80104626:	c3                   	ret    
80104627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010462e:	66 90                	xchg   %ax,%ax

80104630 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104630:	f3 0f 1e fb          	endbr32 
80104634:	55                   	push   %ebp
80104635:	89 e5                	mov    %esp,%ebp
80104637:	56                   	push   %esi
80104638:	53                   	push   %ebx
80104639:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010463c:	8d 73 04             	lea    0x4(%ebx),%esi
8010463f:	83 ec 0c             	sub    $0xc,%esp
80104642:	56                   	push   %esi
80104643:	e8 68 02 00 00       	call   801048b0 <acquire>
  while (lk->locked) {
80104648:	8b 13                	mov    (%ebx),%edx
8010464a:	83 c4 10             	add    $0x10,%esp
8010464d:	85 d2                	test   %edx,%edx
8010464f:	74 1a                	je     8010466b <acquiresleep+0x3b>
80104651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104658:	83 ec 08             	sub    $0x8,%esp
8010465b:	56                   	push   %esi
8010465c:	53                   	push   %ebx
8010465d:	e8 0e fc ff ff       	call   80104270 <sleep>
  while (lk->locked) {
80104662:	8b 03                	mov    (%ebx),%eax
80104664:	83 c4 10             	add    $0x10,%esp
80104667:	85 c0                	test   %eax,%eax
80104669:	75 ed                	jne    80104658 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010466b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104671:	e8 3a f6 ff ff       	call   80103cb0 <myproc>
80104676:	8b 40 10             	mov    0x10(%eax),%eax
80104679:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010467c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010467f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104682:	5b                   	pop    %ebx
80104683:	5e                   	pop    %esi
80104684:	5d                   	pop    %ebp
  release(&lk->lk);
80104685:	e9 e6 02 00 00       	jmp    80104970 <release>
8010468a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104690 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104690:	f3 0f 1e fb          	endbr32 
80104694:	55                   	push   %ebp
80104695:	89 e5                	mov    %esp,%ebp
80104697:	56                   	push   %esi
80104698:	53                   	push   %ebx
80104699:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010469c:	8d 73 04             	lea    0x4(%ebx),%esi
8010469f:	83 ec 0c             	sub    $0xc,%esp
801046a2:	56                   	push   %esi
801046a3:	e8 08 02 00 00       	call   801048b0 <acquire>
  lk->locked = 0;
801046a8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801046ae:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801046b5:	89 1c 24             	mov    %ebx,(%esp)
801046b8:	e8 73 fd ff ff       	call   80104430 <wakeup>
  release(&lk->lk);
801046bd:	89 75 08             	mov    %esi,0x8(%ebp)
801046c0:	83 c4 10             	add    $0x10,%esp
}
801046c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046c6:	5b                   	pop    %ebx
801046c7:	5e                   	pop    %esi
801046c8:	5d                   	pop    %ebp
  release(&lk->lk);
801046c9:	e9 a2 02 00 00       	jmp    80104970 <release>
801046ce:	66 90                	xchg   %ax,%ax

801046d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801046d0:	f3 0f 1e fb          	endbr32 
801046d4:	55                   	push   %ebp
801046d5:	89 e5                	mov    %esp,%ebp
801046d7:	57                   	push   %edi
801046d8:	31 ff                	xor    %edi,%edi
801046da:	56                   	push   %esi
801046db:	53                   	push   %ebx
801046dc:	83 ec 18             	sub    $0x18,%esp
801046df:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801046e2:	8d 73 04             	lea    0x4(%ebx),%esi
801046e5:	56                   	push   %esi
801046e6:	e8 c5 01 00 00       	call   801048b0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801046eb:	8b 03                	mov    (%ebx),%eax
801046ed:	83 c4 10             	add    $0x10,%esp
801046f0:	85 c0                	test   %eax,%eax
801046f2:	75 1c                	jne    80104710 <holdingsleep+0x40>
  release(&lk->lk);
801046f4:	83 ec 0c             	sub    $0xc,%esp
801046f7:	56                   	push   %esi
801046f8:	e8 73 02 00 00       	call   80104970 <release>
  return r;
}
801046fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104700:	89 f8                	mov    %edi,%eax
80104702:	5b                   	pop    %ebx
80104703:	5e                   	pop    %esi
80104704:	5f                   	pop    %edi
80104705:	5d                   	pop    %ebp
80104706:	c3                   	ret    
80104707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104710:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104713:	e8 98 f5 ff ff       	call   80103cb0 <myproc>
80104718:	39 58 10             	cmp    %ebx,0x10(%eax)
8010471b:	0f 94 c0             	sete   %al
8010471e:	0f b6 c0             	movzbl %al,%eax
80104721:	89 c7                	mov    %eax,%edi
80104723:	eb cf                	jmp    801046f4 <holdingsleep+0x24>
80104725:	66 90                	xchg   %ax,%ax
80104727:	66 90                	xchg   %ax,%ax
80104729:	66 90                	xchg   %ax,%ax
8010472b:	66 90                	xchg   %ax,%ax
8010472d:	66 90                	xchg   %ax,%ax
8010472f:	90                   	nop

80104730 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104730:	f3 0f 1e fb          	endbr32 
80104734:	55                   	push   %ebp
80104735:	89 e5                	mov    %esp,%ebp
80104737:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010473a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010473d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104743:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104746:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010474d:	5d                   	pop    %ebp
8010474e:	c3                   	ret    
8010474f:	90                   	nop

80104750 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104750:	f3 0f 1e fb          	endbr32 
80104754:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104755:	31 d2                	xor    %edx,%edx
{
80104757:	89 e5                	mov    %esp,%ebp
80104759:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010475a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010475d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104760:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104763:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104767:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104768:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010476e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104774:	77 1a                	ja     80104790 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104776:	8b 58 04             	mov    0x4(%eax),%ebx
80104779:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010477c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010477f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104781:	83 fa 0a             	cmp    $0xa,%edx
80104784:	75 e2                	jne    80104768 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104786:	5b                   	pop    %ebx
80104787:	5d                   	pop    %ebp
80104788:	c3                   	ret    
80104789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104790:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104793:	8d 51 28             	lea    0x28(%ecx),%edx
80104796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801047a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047a6:	83 c0 04             	add    $0x4,%eax
801047a9:	39 d0                	cmp    %edx,%eax
801047ab:	75 f3                	jne    801047a0 <getcallerpcs+0x50>
}
801047ad:	5b                   	pop    %ebx
801047ae:	5d                   	pop    %ebp
801047af:	c3                   	ret    

801047b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801047b0:	f3 0f 1e fb          	endbr32 
801047b4:	55                   	push   %ebp
801047b5:	89 e5                	mov    %esp,%ebp
801047b7:	53                   	push   %ebx
801047b8:	83 ec 04             	sub    $0x4,%esp
801047bb:	9c                   	pushf  
801047bc:	5b                   	pop    %ebx
  asm volatile("cli");
801047bd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801047be:	e8 5d f4 ff ff       	call   80103c20 <mycpu>
801047c3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801047c9:	85 c0                	test   %eax,%eax
801047cb:	74 13                	je     801047e0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801047cd:	e8 4e f4 ff ff       	call   80103c20 <mycpu>
801047d2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801047d9:	83 c4 04             	add    $0x4,%esp
801047dc:	5b                   	pop    %ebx
801047dd:	5d                   	pop    %ebp
801047de:	c3                   	ret    
801047df:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801047e0:	e8 3b f4 ff ff       	call   80103c20 <mycpu>
801047e5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801047eb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801047f1:	eb da                	jmp    801047cd <pushcli+0x1d>
801047f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104800 <popcli>:

void
popcli(void)
{
80104800:	f3 0f 1e fb          	endbr32 
80104804:	55                   	push   %ebp
80104805:	89 e5                	mov    %esp,%ebp
80104807:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010480a:	9c                   	pushf  
8010480b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010480c:	f6 c4 02             	test   $0x2,%ah
8010480f:	75 31                	jne    80104842 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104811:	e8 0a f4 ff ff       	call   80103c20 <mycpu>
80104816:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010481d:	78 30                	js     8010484f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010481f:	e8 fc f3 ff ff       	call   80103c20 <mycpu>
80104824:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010482a:	85 d2                	test   %edx,%edx
8010482c:	74 02                	je     80104830 <popcli+0x30>
    sti();
}
8010482e:	c9                   	leave  
8010482f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104830:	e8 eb f3 ff ff       	call   80103c20 <mycpu>
80104835:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010483b:	85 c0                	test   %eax,%eax
8010483d:	74 ef                	je     8010482e <popcli+0x2e>
  asm volatile("sti");
8010483f:	fb                   	sti    
}
80104840:	c9                   	leave  
80104841:	c3                   	ret    
    panic("popcli - interruptible");
80104842:	83 ec 0c             	sub    $0xc,%esp
80104845:	68 af 7a 10 80       	push   $0x80107aaf
8010484a:	e8 c1 bd ff ff       	call   80100610 <panic>
    panic("popcli");
8010484f:	83 ec 0c             	sub    $0xc,%esp
80104852:	68 c6 7a 10 80       	push   $0x80107ac6
80104857:	e8 b4 bd ff ff       	call   80100610 <panic>
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104860 <holding>:
{
80104860:	f3 0f 1e fb          	endbr32 
80104864:	55                   	push   %ebp
80104865:	89 e5                	mov    %esp,%ebp
80104867:	56                   	push   %esi
80104868:	53                   	push   %ebx
80104869:	8b 75 08             	mov    0x8(%ebp),%esi
8010486c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010486e:	e8 3d ff ff ff       	call   801047b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104873:	8b 06                	mov    (%esi),%eax
80104875:	85 c0                	test   %eax,%eax
80104877:	75 0f                	jne    80104888 <holding+0x28>
  popcli();
80104879:	e8 82 ff ff ff       	call   80104800 <popcli>
}
8010487e:	89 d8                	mov    %ebx,%eax
80104880:	5b                   	pop    %ebx
80104881:	5e                   	pop    %esi
80104882:	5d                   	pop    %ebp
80104883:	c3                   	ret    
80104884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104888:	8b 5e 08             	mov    0x8(%esi),%ebx
8010488b:	e8 90 f3 ff ff       	call   80103c20 <mycpu>
80104890:	39 c3                	cmp    %eax,%ebx
80104892:	0f 94 c3             	sete   %bl
  popcli();
80104895:	e8 66 ff ff ff       	call   80104800 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010489a:	0f b6 db             	movzbl %bl,%ebx
}
8010489d:	89 d8                	mov    %ebx,%eax
8010489f:	5b                   	pop    %ebx
801048a0:	5e                   	pop    %esi
801048a1:	5d                   	pop    %ebp
801048a2:	c3                   	ret    
801048a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048b0 <acquire>:
{
801048b0:	f3 0f 1e fb          	endbr32 
801048b4:	55                   	push   %ebp
801048b5:	89 e5                	mov    %esp,%ebp
801048b7:	56                   	push   %esi
801048b8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801048b9:	e8 f2 fe ff ff       	call   801047b0 <pushcli>
  if(holding(lk))
801048be:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048c1:	83 ec 0c             	sub    $0xc,%esp
801048c4:	53                   	push   %ebx
801048c5:	e8 96 ff ff ff       	call   80104860 <holding>
801048ca:	83 c4 10             	add    $0x10,%esp
801048cd:	85 c0                	test   %eax,%eax
801048cf:	0f 85 7f 00 00 00    	jne    80104954 <acquire+0xa4>
801048d5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801048d7:	ba 01 00 00 00       	mov    $0x1,%edx
801048dc:	eb 05                	jmp    801048e3 <acquire+0x33>
801048de:	66 90                	xchg   %ax,%ax
801048e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048e3:	89 d0                	mov    %edx,%eax
801048e5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801048e8:	85 c0                	test   %eax,%eax
801048ea:	75 f4                	jne    801048e0 <acquire+0x30>
  __sync_synchronize();
801048ec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801048f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048f4:	e8 27 f3 ff ff       	call   80103c20 <mycpu>
801048f9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801048fc:	89 e8                	mov    %ebp,%eax
801048fe:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104900:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104906:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010490c:	77 22                	ja     80104930 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010490e:	8b 50 04             	mov    0x4(%eax),%edx
80104911:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104915:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104918:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010491a:	83 fe 0a             	cmp    $0xa,%esi
8010491d:	75 e1                	jne    80104900 <acquire+0x50>
}
8010491f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104922:	5b                   	pop    %ebx
80104923:	5e                   	pop    %esi
80104924:	5d                   	pop    %ebp
80104925:	c3                   	ret    
80104926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104930:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104934:	83 c3 34             	add    $0x34,%ebx
80104937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104940:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104946:	83 c0 04             	add    $0x4,%eax
80104949:	39 d8                	cmp    %ebx,%eax
8010494b:	75 f3                	jne    80104940 <acquire+0x90>
}
8010494d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104950:	5b                   	pop    %ebx
80104951:	5e                   	pop    %esi
80104952:	5d                   	pop    %ebp
80104953:	c3                   	ret    
    panic("acquire");
80104954:	83 ec 0c             	sub    $0xc,%esp
80104957:	68 cd 7a 10 80       	push   $0x80107acd
8010495c:	e8 af bc ff ff       	call   80100610 <panic>
80104961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496f:	90                   	nop

80104970 <release>:
{
80104970:	f3 0f 1e fb          	endbr32 
80104974:	55                   	push   %ebp
80104975:	89 e5                	mov    %esp,%ebp
80104977:	53                   	push   %ebx
80104978:	83 ec 10             	sub    $0x10,%esp
8010497b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010497e:	53                   	push   %ebx
8010497f:	e8 dc fe ff ff       	call   80104860 <holding>
80104984:	83 c4 10             	add    $0x10,%esp
80104987:	85 c0                	test   %eax,%eax
80104989:	74 22                	je     801049ad <release+0x3d>
  lk->pcs[0] = 0;
8010498b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104992:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104999:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010499e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801049a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049a7:	c9                   	leave  
  popcli();
801049a8:	e9 53 fe ff ff       	jmp    80104800 <popcli>
    panic("release");
801049ad:	83 ec 0c             	sub    $0xc,%esp
801049b0:	68 d5 7a 10 80       	push   $0x80107ad5
801049b5:	e8 56 bc ff ff       	call   80100610 <panic>
801049ba:	66 90                	xchg   %ax,%ax
801049bc:	66 90                	xchg   %ax,%ax
801049be:	66 90                	xchg   %ax,%ax

801049c0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801049c0:	f3 0f 1e fb          	endbr32 
801049c4:	55                   	push   %ebp
801049c5:	89 e5                	mov    %esp,%ebp
801049c7:	57                   	push   %edi
801049c8:	8b 55 08             	mov    0x8(%ebp),%edx
801049cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049ce:	53                   	push   %ebx
801049cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801049d2:	89 d7                	mov    %edx,%edi
801049d4:	09 cf                	or     %ecx,%edi
801049d6:	83 e7 03             	and    $0x3,%edi
801049d9:	75 25                	jne    80104a00 <memset+0x40>
    c &= 0xFF;
801049db:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801049de:	c1 e0 18             	shl    $0x18,%eax
801049e1:	89 fb                	mov    %edi,%ebx
801049e3:	c1 e9 02             	shr    $0x2,%ecx
801049e6:	c1 e3 10             	shl    $0x10,%ebx
801049e9:	09 d8                	or     %ebx,%eax
801049eb:	09 f8                	or     %edi,%eax
801049ed:	c1 e7 08             	shl    $0x8,%edi
801049f0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801049f2:	89 d7                	mov    %edx,%edi
801049f4:	fc                   	cld    
801049f5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801049f7:	5b                   	pop    %ebx
801049f8:	89 d0                	mov    %edx,%eax
801049fa:	5f                   	pop    %edi
801049fb:	5d                   	pop    %ebp
801049fc:	c3                   	ret    
801049fd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104a00:	89 d7                	mov    %edx,%edi
80104a02:	fc                   	cld    
80104a03:	f3 aa                	rep stos %al,%es:(%edi)
80104a05:	5b                   	pop    %ebx
80104a06:	89 d0                	mov    %edx,%eax
80104a08:	5f                   	pop    %edi
80104a09:	5d                   	pop    %ebp
80104a0a:	c3                   	ret    
80104a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a0f:	90                   	nop

80104a10 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a10:	f3 0f 1e fb          	endbr32 
80104a14:	55                   	push   %ebp
80104a15:	89 e5                	mov    %esp,%ebp
80104a17:	56                   	push   %esi
80104a18:	8b 75 10             	mov    0x10(%ebp),%esi
80104a1b:	8b 55 08             	mov    0x8(%ebp),%edx
80104a1e:	53                   	push   %ebx
80104a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a22:	85 f6                	test   %esi,%esi
80104a24:	74 2a                	je     80104a50 <memcmp+0x40>
80104a26:	01 c6                	add    %eax,%esi
80104a28:	eb 10                	jmp    80104a3a <memcmp+0x2a>
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104a30:	83 c0 01             	add    $0x1,%eax
80104a33:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104a36:	39 f0                	cmp    %esi,%eax
80104a38:	74 16                	je     80104a50 <memcmp+0x40>
    if(*s1 != *s2)
80104a3a:	0f b6 0a             	movzbl (%edx),%ecx
80104a3d:	0f b6 18             	movzbl (%eax),%ebx
80104a40:	38 d9                	cmp    %bl,%cl
80104a42:	74 ec                	je     80104a30 <memcmp+0x20>
      return *s1 - *s2;
80104a44:	0f b6 c1             	movzbl %cl,%eax
80104a47:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104a49:	5b                   	pop    %ebx
80104a4a:	5e                   	pop    %esi
80104a4b:	5d                   	pop    %ebp
80104a4c:	c3                   	ret    
80104a4d:	8d 76 00             	lea    0x0(%esi),%esi
80104a50:	5b                   	pop    %ebx
  return 0;
80104a51:	31 c0                	xor    %eax,%eax
}
80104a53:	5e                   	pop    %esi
80104a54:	5d                   	pop    %ebp
80104a55:	c3                   	ret    
80104a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5d:	8d 76 00             	lea    0x0(%esi),%esi

80104a60 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	57                   	push   %edi
80104a68:	8b 55 08             	mov    0x8(%ebp),%edx
80104a6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a6e:	56                   	push   %esi
80104a6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a72:	39 d6                	cmp    %edx,%esi
80104a74:	73 2a                	jae    80104aa0 <memmove+0x40>
80104a76:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104a79:	39 fa                	cmp    %edi,%edx
80104a7b:	73 23                	jae    80104aa0 <memmove+0x40>
80104a7d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104a80:	85 c9                	test   %ecx,%ecx
80104a82:	74 13                	je     80104a97 <memmove+0x37>
80104a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104a88:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a8c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104a8f:	83 e8 01             	sub    $0x1,%eax
80104a92:	83 f8 ff             	cmp    $0xffffffff,%eax
80104a95:	75 f1                	jne    80104a88 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a97:	5e                   	pop    %esi
80104a98:	89 d0                	mov    %edx,%eax
80104a9a:	5f                   	pop    %edi
80104a9b:	5d                   	pop    %ebp
80104a9c:	c3                   	ret    
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104aa0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104aa3:	89 d7                	mov    %edx,%edi
80104aa5:	85 c9                	test   %ecx,%ecx
80104aa7:	74 ee                	je     80104a97 <memmove+0x37>
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104ab0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104ab1:	39 f0                	cmp    %esi,%eax
80104ab3:	75 fb                	jne    80104ab0 <memmove+0x50>
}
80104ab5:	5e                   	pop    %esi
80104ab6:	89 d0                	mov    %edx,%eax
80104ab8:	5f                   	pop    %edi
80104ab9:	5d                   	pop    %ebp
80104aba:	c3                   	ret    
80104abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104abf:	90                   	nop

80104ac0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104ac0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104ac4:	eb 9a                	jmp    80104a60 <memmove>
80104ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104acd:	8d 76 00             	lea    0x0(%esi),%esi

80104ad0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104ad0:	f3 0f 1e fb          	endbr32 
80104ad4:	55                   	push   %ebp
80104ad5:	89 e5                	mov    %esp,%ebp
80104ad7:	56                   	push   %esi
80104ad8:	8b 75 10             	mov    0x10(%ebp),%esi
80104adb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ade:	53                   	push   %ebx
80104adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104ae2:	85 f6                	test   %esi,%esi
80104ae4:	74 32                	je     80104b18 <strncmp+0x48>
80104ae6:	01 c6                	add    %eax,%esi
80104ae8:	eb 14                	jmp    80104afe <strncmp+0x2e>
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104af0:	38 da                	cmp    %bl,%dl
80104af2:	75 14                	jne    80104b08 <strncmp+0x38>
    n--, p++, q++;
80104af4:	83 c0 01             	add    $0x1,%eax
80104af7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104afa:	39 f0                	cmp    %esi,%eax
80104afc:	74 1a                	je     80104b18 <strncmp+0x48>
80104afe:	0f b6 11             	movzbl (%ecx),%edx
80104b01:	0f b6 18             	movzbl (%eax),%ebx
80104b04:	84 d2                	test   %dl,%dl
80104b06:	75 e8                	jne    80104af0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104b08:	0f b6 c2             	movzbl %dl,%eax
80104b0b:	29 d8                	sub    %ebx,%eax
}
80104b0d:	5b                   	pop    %ebx
80104b0e:	5e                   	pop    %esi
80104b0f:	5d                   	pop    %ebp
80104b10:	c3                   	ret    
80104b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b18:	5b                   	pop    %ebx
    return 0;
80104b19:	31 c0                	xor    %eax,%eax
}
80104b1b:	5e                   	pop    %esi
80104b1c:	5d                   	pop    %ebp
80104b1d:	c3                   	ret    
80104b1e:	66 90                	xchg   %ax,%ax

80104b20 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b20:	f3 0f 1e fb          	endbr32 
80104b24:	55                   	push   %ebp
80104b25:	89 e5                	mov    %esp,%ebp
80104b27:	57                   	push   %edi
80104b28:	56                   	push   %esi
80104b29:	8b 75 08             	mov    0x8(%ebp),%esi
80104b2c:	53                   	push   %ebx
80104b2d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b30:	89 f2                	mov    %esi,%edx
80104b32:	eb 1b                	jmp    80104b4f <strncpy+0x2f>
80104b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b38:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104b3c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104b3f:	83 c2 01             	add    $0x1,%edx
80104b42:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104b46:	89 f9                	mov    %edi,%ecx
80104b48:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b4b:	84 c9                	test   %cl,%cl
80104b4d:	74 09                	je     80104b58 <strncpy+0x38>
80104b4f:	89 c3                	mov    %eax,%ebx
80104b51:	83 e8 01             	sub    $0x1,%eax
80104b54:	85 db                	test   %ebx,%ebx
80104b56:	7f e0                	jg     80104b38 <strncpy+0x18>
    ;
  while(n-- > 0)
80104b58:	89 d1                	mov    %edx,%ecx
80104b5a:	85 c0                	test   %eax,%eax
80104b5c:	7e 15                	jle    80104b73 <strncpy+0x53>
80104b5e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104b60:	83 c1 01             	add    $0x1,%ecx
80104b63:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104b67:	89 c8                	mov    %ecx,%eax
80104b69:	f7 d0                	not    %eax
80104b6b:	01 d0                	add    %edx,%eax
80104b6d:	01 d8                	add    %ebx,%eax
80104b6f:	85 c0                	test   %eax,%eax
80104b71:	7f ed                	jg     80104b60 <strncpy+0x40>
  return os;
}
80104b73:	5b                   	pop    %ebx
80104b74:	89 f0                	mov    %esi,%eax
80104b76:	5e                   	pop    %esi
80104b77:	5f                   	pop    %edi
80104b78:	5d                   	pop    %ebp
80104b79:	c3                   	ret    
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b80 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b80:	f3 0f 1e fb          	endbr32 
80104b84:	55                   	push   %ebp
80104b85:	89 e5                	mov    %esp,%ebp
80104b87:	56                   	push   %esi
80104b88:	8b 55 10             	mov    0x10(%ebp),%edx
80104b8b:	8b 75 08             	mov    0x8(%ebp),%esi
80104b8e:	53                   	push   %ebx
80104b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104b92:	85 d2                	test   %edx,%edx
80104b94:	7e 21                	jle    80104bb7 <safestrcpy+0x37>
80104b96:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104b9a:	89 f2                	mov    %esi,%edx
80104b9c:	eb 12                	jmp    80104bb0 <safestrcpy+0x30>
80104b9e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ba0:	0f b6 08             	movzbl (%eax),%ecx
80104ba3:	83 c0 01             	add    $0x1,%eax
80104ba6:	83 c2 01             	add    $0x1,%edx
80104ba9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104bac:	84 c9                	test   %cl,%cl
80104bae:	74 04                	je     80104bb4 <safestrcpy+0x34>
80104bb0:	39 d8                	cmp    %ebx,%eax
80104bb2:	75 ec                	jne    80104ba0 <safestrcpy+0x20>
    ;
  *s = 0;
80104bb4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104bb7:	89 f0                	mov    %esi,%eax
80104bb9:	5b                   	pop    %ebx
80104bba:	5e                   	pop    %esi
80104bbb:	5d                   	pop    %ebp
80104bbc:	c3                   	ret    
80104bbd:	8d 76 00             	lea    0x0(%esi),%esi

80104bc0 <strlen>:

int
strlen(const char *s)
{
80104bc0:	f3 0f 1e fb          	endbr32 
80104bc4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104bc5:	31 c0                	xor    %eax,%eax
{
80104bc7:	89 e5                	mov    %esp,%ebp
80104bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104bcc:	80 3a 00             	cmpb   $0x0,(%edx)
80104bcf:	74 10                	je     80104be1 <strlen+0x21>
80104bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bd8:	83 c0 01             	add    $0x1,%eax
80104bdb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104bdf:	75 f7                	jne    80104bd8 <strlen+0x18>
    ;
  return n;
}
80104be1:	5d                   	pop    %ebp
80104be2:	c3                   	ret    

80104be3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104be3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104be7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104beb:	55                   	push   %ebp
  pushl %ebx
80104bec:	53                   	push   %ebx
  pushl %esi
80104bed:	56                   	push   %esi
  pushl %edi
80104bee:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104bef:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104bf1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104bf3:	5f                   	pop    %edi
  popl %esi
80104bf4:	5e                   	pop    %esi
  popl %ebx
80104bf5:	5b                   	pop    %ebx
  popl %ebp
80104bf6:	5d                   	pop    %ebp
  ret
80104bf7:	c3                   	ret    
80104bf8:	66 90                	xchg   %ax,%ax
80104bfa:	66 90                	xchg   %ax,%ax
80104bfc:	66 90                	xchg   %ax,%ax
80104bfe:	66 90                	xchg   %ax,%ax

80104c00 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c00:	f3 0f 1e fb          	endbr32 
80104c04:	55                   	push   %ebp
80104c05:	89 e5                	mov    %esp,%ebp
80104c07:	53                   	push   %ebx
80104c08:	83 ec 04             	sub    $0x4,%esp
80104c0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c0e:	e8 9d f0 ff ff       	call   80103cb0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c13:	8b 00                	mov    (%eax),%eax
80104c15:	39 d8                	cmp    %ebx,%eax
80104c17:	76 17                	jbe    80104c30 <fetchint+0x30>
80104c19:	8d 53 04             	lea    0x4(%ebx),%edx
80104c1c:	39 d0                	cmp    %edx,%eax
80104c1e:	72 10                	jb     80104c30 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104c20:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c23:	8b 13                	mov    (%ebx),%edx
80104c25:	89 10                	mov    %edx,(%eax)
  return 0;
80104c27:	31 c0                	xor    %eax,%eax
}
80104c29:	83 c4 04             	add    $0x4,%esp
80104c2c:	5b                   	pop    %ebx
80104c2d:	5d                   	pop    %ebp
80104c2e:	c3                   	ret    
80104c2f:	90                   	nop
    return -1;
80104c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c35:	eb f2                	jmp    80104c29 <fetchint+0x29>
80104c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3e:	66 90                	xchg   %ax,%ax

80104c40 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c40:	f3 0f 1e fb          	endbr32 
80104c44:	55                   	push   %ebp
80104c45:	89 e5                	mov    %esp,%ebp
80104c47:	53                   	push   %ebx
80104c48:	83 ec 04             	sub    $0x4,%esp
80104c4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c4e:	e8 5d f0 ff ff       	call   80103cb0 <myproc>

  if(addr >= curproc->sz)
80104c53:	39 18                	cmp    %ebx,(%eax)
80104c55:	76 31                	jbe    80104c88 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104c57:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c5a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c5c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c5e:	39 d3                	cmp    %edx,%ebx
80104c60:	73 26                	jae    80104c88 <fetchstr+0x48>
80104c62:	89 d8                	mov    %ebx,%eax
80104c64:	eb 11                	jmp    80104c77 <fetchstr+0x37>
80104c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi
80104c70:	83 c0 01             	add    $0x1,%eax
80104c73:	39 c2                	cmp    %eax,%edx
80104c75:	76 11                	jbe    80104c88 <fetchstr+0x48>
    if(*s == 0)
80104c77:	80 38 00             	cmpb   $0x0,(%eax)
80104c7a:	75 f4                	jne    80104c70 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104c7c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104c7f:	29 d8                	sub    %ebx,%eax
}
80104c81:	5b                   	pop    %ebx
80104c82:	5d                   	pop    %ebp
80104c83:	c3                   	ret    
80104c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c88:	83 c4 04             	add    $0x4,%esp
    return -1;
80104c8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c90:	5b                   	pop    %ebx
80104c91:	5d                   	pop    %ebp
80104c92:	c3                   	ret    
80104c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ca0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ca0:	f3 0f 1e fb          	endbr32 
80104ca4:	55                   	push   %ebp
80104ca5:	89 e5                	mov    %esp,%ebp
80104ca7:	56                   	push   %esi
80104ca8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ca9:	e8 02 f0 ff ff       	call   80103cb0 <myproc>
80104cae:	8b 55 08             	mov    0x8(%ebp),%edx
80104cb1:	8b 40 18             	mov    0x18(%eax),%eax
80104cb4:	8b 40 44             	mov    0x44(%eax),%eax
80104cb7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104cba:	e8 f1 ef ff ff       	call   80103cb0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cbf:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cc2:	8b 00                	mov    (%eax),%eax
80104cc4:	39 c6                	cmp    %eax,%esi
80104cc6:	73 18                	jae    80104ce0 <argint+0x40>
80104cc8:	8d 53 08             	lea    0x8(%ebx),%edx
80104ccb:	39 d0                	cmp    %edx,%eax
80104ccd:	72 11                	jb     80104ce0 <argint+0x40>
  *ip = *(int*)(addr);
80104ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cd2:	8b 53 04             	mov    0x4(%ebx),%edx
80104cd5:	89 10                	mov    %edx,(%eax)
  return 0;
80104cd7:	31 c0                	xor    %eax,%eax
}
80104cd9:	5b                   	pop    %ebx
80104cda:	5e                   	pop    %esi
80104cdb:	5d                   	pop    %ebp
80104cdc:	c3                   	ret    
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ce5:	eb f2                	jmp    80104cd9 <argint+0x39>
80104ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cee:	66 90                	xchg   %ax,%ax

80104cf0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104cf0:	f3 0f 1e fb          	endbr32 
80104cf4:	55                   	push   %ebp
80104cf5:	89 e5                	mov    %esp,%ebp
80104cf7:	56                   	push   %esi
80104cf8:	53                   	push   %ebx
80104cf9:	83 ec 10             	sub    $0x10,%esp
80104cfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104cff:	e8 ac ef ff ff       	call   80103cb0 <myproc>
 
  if(argint(n, &i) < 0)
80104d04:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104d07:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104d09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d0c:	50                   	push   %eax
80104d0d:	ff 75 08             	pushl  0x8(%ebp)
80104d10:	e8 8b ff ff ff       	call   80104ca0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d15:	83 c4 10             	add    $0x10,%esp
80104d18:	85 c0                	test   %eax,%eax
80104d1a:	78 24                	js     80104d40 <argptr+0x50>
80104d1c:	85 db                	test   %ebx,%ebx
80104d1e:	78 20                	js     80104d40 <argptr+0x50>
80104d20:	8b 16                	mov    (%esi),%edx
80104d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d25:	39 c2                	cmp    %eax,%edx
80104d27:	76 17                	jbe    80104d40 <argptr+0x50>
80104d29:	01 c3                	add    %eax,%ebx
80104d2b:	39 da                	cmp    %ebx,%edx
80104d2d:	72 11                	jb     80104d40 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104d2f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d32:	89 02                	mov    %eax,(%edx)
  return 0;
80104d34:	31 c0                	xor    %eax,%eax
}
80104d36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d39:	5b                   	pop    %ebx
80104d3a:	5e                   	pop    %esi
80104d3b:	5d                   	pop    %ebp
80104d3c:	c3                   	ret    
80104d3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d45:	eb ef                	jmp    80104d36 <argptr+0x46>
80104d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d50:	f3 0f 1e fb          	endbr32 
80104d54:	55                   	push   %ebp
80104d55:	89 e5                	mov    %esp,%ebp
80104d57:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104d5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d5d:	50                   	push   %eax
80104d5e:	ff 75 08             	pushl  0x8(%ebp)
80104d61:	e8 3a ff ff ff       	call   80104ca0 <argint>
80104d66:	83 c4 10             	add    $0x10,%esp
80104d69:	85 c0                	test   %eax,%eax
80104d6b:	78 13                	js     80104d80 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104d6d:	83 ec 08             	sub    $0x8,%esp
80104d70:	ff 75 0c             	pushl  0xc(%ebp)
80104d73:	ff 75 f4             	pushl  -0xc(%ebp)
80104d76:	e8 c5 fe ff ff       	call   80104c40 <fetchstr>
80104d7b:	83 c4 10             	add    $0x10,%esp
}
80104d7e:	c9                   	leave  
80104d7f:	c3                   	ret    
80104d80:	c9                   	leave  
    return -1;
80104d81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d86:	c3                   	ret    
80104d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8e:	66 90                	xchg   %ax,%ax

80104d90 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104d90:	f3 0f 1e fb          	endbr32 
80104d94:	55                   	push   %ebp
80104d95:	89 e5                	mov    %esp,%ebp
80104d97:	53                   	push   %ebx
80104d98:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d9b:	e8 10 ef ff ff       	call   80103cb0 <myproc>
80104da0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104da2:	8b 40 18             	mov    0x18(%eax),%eax
80104da5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104da8:	8d 50 ff             	lea    -0x1(%eax),%edx
80104dab:	83 fa 14             	cmp    $0x14,%edx
80104dae:	77 20                	ja     80104dd0 <syscall+0x40>
80104db0:	8b 14 85 00 7b 10 80 	mov    -0x7fef8500(,%eax,4),%edx
80104db7:	85 d2                	test   %edx,%edx
80104db9:	74 15                	je     80104dd0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104dbb:	ff d2                	call   *%edx
80104dbd:	89 c2                	mov    %eax,%edx
80104dbf:	8b 43 18             	mov    0x18(%ebx),%eax
80104dc2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104dc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc8:	c9                   	leave  
80104dc9:	c3                   	ret    
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104dd0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104dd1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104dd4:	50                   	push   %eax
80104dd5:	ff 73 10             	pushl  0x10(%ebx)
80104dd8:	68 dd 7a 10 80       	push   $0x80107add
80104ddd:	e8 ae b8 ff ff       	call   80100690 <cprintf>
    curproc->tf->eax = -1;
80104de2:	8b 43 18             	mov    0x18(%ebx),%eax
80104de5:	83 c4 10             	add    $0x10,%esp
80104de8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104def:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104df2:	c9                   	leave  
80104df3:	c3                   	ret    
80104df4:	66 90                	xchg   %ax,%ax
80104df6:	66 90                	xchg   %ax,%ax
80104df8:	66 90                	xchg   %ax,%ax
80104dfa:	66 90                	xchg   %ax,%ax
80104dfc:	66 90                	xchg   %ax,%ax
80104dfe:	66 90                	xchg   %ax,%ax

80104e00 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	57                   	push   %edi
80104e04:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e05:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104e08:	53                   	push   %ebx
80104e09:	83 ec 34             	sub    $0x34,%esp
80104e0c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104e0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104e12:	57                   	push   %edi
80104e13:	50                   	push   %eax
{
80104e14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104e17:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104e1a:	e8 81 d5 ff ff       	call   801023a0 <nameiparent>
80104e1f:	83 c4 10             	add    $0x10,%esp
80104e22:	85 c0                	test   %eax,%eax
80104e24:	0f 84 46 01 00 00    	je     80104f70 <create+0x170>
    return 0;
  ilock(dp);
80104e2a:	83 ec 0c             	sub    $0xc,%esp
80104e2d:	89 c3                	mov    %eax,%ebx
80104e2f:	50                   	push   %eax
80104e30:	e8 7b cc ff ff       	call   80101ab0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e35:	83 c4 0c             	add    $0xc,%esp
80104e38:	6a 00                	push   $0x0
80104e3a:	57                   	push   %edi
80104e3b:	53                   	push   %ebx
80104e3c:	e8 bf d1 ff ff       	call   80102000 <dirlookup>
80104e41:	83 c4 10             	add    $0x10,%esp
80104e44:	89 c6                	mov    %eax,%esi
80104e46:	85 c0                	test   %eax,%eax
80104e48:	74 56                	je     80104ea0 <create+0xa0>
    iunlockput(dp);
80104e4a:	83 ec 0c             	sub    $0xc,%esp
80104e4d:	53                   	push   %ebx
80104e4e:	e8 fd ce ff ff       	call   80101d50 <iunlockput>
    ilock(ip);
80104e53:	89 34 24             	mov    %esi,(%esp)
80104e56:	e8 55 cc ff ff       	call   80101ab0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e5b:	83 c4 10             	add    $0x10,%esp
80104e5e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e63:	75 1b                	jne    80104e80 <create+0x80>
80104e65:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104e6a:	75 14                	jne    80104e80 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e6f:	89 f0                	mov    %esi,%eax
80104e71:	5b                   	pop    %ebx
80104e72:	5e                   	pop    %esi
80104e73:	5f                   	pop    %edi
80104e74:	5d                   	pop    %ebp
80104e75:	c3                   	ret    
80104e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e7d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104e80:	83 ec 0c             	sub    $0xc,%esp
80104e83:	56                   	push   %esi
    return 0;
80104e84:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104e86:	e8 c5 ce ff ff       	call   80101d50 <iunlockput>
    return 0;
80104e8b:	83 c4 10             	add    $0x10,%esp
}
80104e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e91:	89 f0                	mov    %esi,%eax
80104e93:	5b                   	pop    %ebx
80104e94:	5e                   	pop    %esi
80104e95:	5f                   	pop    %edi
80104e96:	5d                   	pop    %ebp
80104e97:	c3                   	ret    
80104e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104ea0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104ea4:	83 ec 08             	sub    $0x8,%esp
80104ea7:	50                   	push   %eax
80104ea8:	ff 33                	pushl  (%ebx)
80104eaa:	e8 81 ca ff ff       	call   80101930 <ialloc>
80104eaf:	83 c4 10             	add    $0x10,%esp
80104eb2:	89 c6                	mov    %eax,%esi
80104eb4:	85 c0                	test   %eax,%eax
80104eb6:	0f 84 cd 00 00 00    	je     80104f89 <create+0x189>
  ilock(ip);
80104ebc:	83 ec 0c             	sub    $0xc,%esp
80104ebf:	50                   	push   %eax
80104ec0:	e8 eb cb ff ff       	call   80101ab0 <ilock>
  ip->major = major;
80104ec5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104ec9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104ecd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ed1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104ed5:	b8 01 00 00 00       	mov    $0x1,%eax
80104eda:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104ede:	89 34 24             	mov    %esi,(%esp)
80104ee1:	e8 0a cb ff ff       	call   801019f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ee6:	83 c4 10             	add    $0x10,%esp
80104ee9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104eee:	74 30                	je     80104f20 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104ef0:	83 ec 04             	sub    $0x4,%esp
80104ef3:	ff 76 04             	pushl  0x4(%esi)
80104ef6:	57                   	push   %edi
80104ef7:	53                   	push   %ebx
80104ef8:	e8 c3 d3 ff ff       	call   801022c0 <dirlink>
80104efd:	83 c4 10             	add    $0x10,%esp
80104f00:	85 c0                	test   %eax,%eax
80104f02:	78 78                	js     80104f7c <create+0x17c>
  iunlockput(dp);
80104f04:	83 ec 0c             	sub    $0xc,%esp
80104f07:	53                   	push   %ebx
80104f08:	e8 43 ce ff ff       	call   80101d50 <iunlockput>
  return ip;
80104f0d:	83 c4 10             	add    $0x10,%esp
}
80104f10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f13:	89 f0                	mov    %esi,%eax
80104f15:	5b                   	pop    %ebx
80104f16:	5e                   	pop    %esi
80104f17:	5f                   	pop    %edi
80104f18:	5d                   	pop    %ebp
80104f19:	c3                   	ret    
80104f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104f20:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104f23:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104f28:	53                   	push   %ebx
80104f29:	e8 c2 ca ff ff       	call   801019f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f2e:	83 c4 0c             	add    $0xc,%esp
80104f31:	ff 76 04             	pushl  0x4(%esi)
80104f34:	68 74 7b 10 80       	push   $0x80107b74
80104f39:	56                   	push   %esi
80104f3a:	e8 81 d3 ff ff       	call   801022c0 <dirlink>
80104f3f:	83 c4 10             	add    $0x10,%esp
80104f42:	85 c0                	test   %eax,%eax
80104f44:	78 18                	js     80104f5e <create+0x15e>
80104f46:	83 ec 04             	sub    $0x4,%esp
80104f49:	ff 73 04             	pushl  0x4(%ebx)
80104f4c:	68 73 7b 10 80       	push   $0x80107b73
80104f51:	56                   	push   %esi
80104f52:	e8 69 d3 ff ff       	call   801022c0 <dirlink>
80104f57:	83 c4 10             	add    $0x10,%esp
80104f5a:	85 c0                	test   %eax,%eax
80104f5c:	79 92                	jns    80104ef0 <create+0xf0>
      panic("create dots");
80104f5e:	83 ec 0c             	sub    $0xc,%esp
80104f61:	68 67 7b 10 80       	push   $0x80107b67
80104f66:	e8 a5 b6 ff ff       	call   80100610 <panic>
80104f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f6f:	90                   	nop
}
80104f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104f73:	31 f6                	xor    %esi,%esi
}
80104f75:	5b                   	pop    %ebx
80104f76:	89 f0                	mov    %esi,%eax
80104f78:	5e                   	pop    %esi
80104f79:	5f                   	pop    %edi
80104f7a:	5d                   	pop    %ebp
80104f7b:	c3                   	ret    
    panic("create: dirlink");
80104f7c:	83 ec 0c             	sub    $0xc,%esp
80104f7f:	68 76 7b 10 80       	push   $0x80107b76
80104f84:	e8 87 b6 ff ff       	call   80100610 <panic>
    panic("create: ialloc");
80104f89:	83 ec 0c             	sub    $0xc,%esp
80104f8c:	68 58 7b 10 80       	push   $0x80107b58
80104f91:	e8 7a b6 ff ff       	call   80100610 <panic>
80104f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi

80104fa0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	89 d6                	mov    %edx,%esi
80104fa6:	53                   	push   %ebx
80104fa7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104fa9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104fac:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104faf:	50                   	push   %eax
80104fb0:	6a 00                	push   $0x0
80104fb2:	e8 e9 fc ff ff       	call   80104ca0 <argint>
80104fb7:	83 c4 10             	add    $0x10,%esp
80104fba:	85 c0                	test   %eax,%eax
80104fbc:	78 2a                	js     80104fe8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fbe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fc2:	77 24                	ja     80104fe8 <argfd.constprop.0+0x48>
80104fc4:	e8 e7 ec ff ff       	call   80103cb0 <myproc>
80104fc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fcc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104fd0:	85 c0                	test   %eax,%eax
80104fd2:	74 14                	je     80104fe8 <argfd.constprop.0+0x48>
  if(pfd)
80104fd4:	85 db                	test   %ebx,%ebx
80104fd6:	74 02                	je     80104fda <argfd.constprop.0+0x3a>
    *pfd = fd;
80104fd8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104fda:	89 06                	mov    %eax,(%esi)
  return 0;
80104fdc:	31 c0                	xor    %eax,%eax
}
80104fde:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fe1:	5b                   	pop    %ebx
80104fe2:	5e                   	pop    %esi
80104fe3:	5d                   	pop    %ebp
80104fe4:	c3                   	ret    
80104fe5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fed:	eb ef                	jmp    80104fde <argfd.constprop.0+0x3e>
80104fef:	90                   	nop

80104ff0 <sys_dup>:
{
80104ff0:	f3 0f 1e fb          	endbr32 
80104ff4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104ff5:	31 c0                	xor    %eax,%eax
{
80104ff7:	89 e5                	mov    %esp,%ebp
80104ff9:	56                   	push   %esi
80104ffa:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104ffb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104ffe:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105001:	e8 9a ff ff ff       	call   80104fa0 <argfd.constprop.0>
80105006:	85 c0                	test   %eax,%eax
80105008:	78 1e                	js     80105028 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010500a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010500d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010500f:	e8 9c ec ff ff       	call   80103cb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105018:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010501c:	85 d2                	test   %edx,%edx
8010501e:	74 20                	je     80105040 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105020:	83 c3 01             	add    $0x1,%ebx
80105023:	83 fb 10             	cmp    $0x10,%ebx
80105026:	75 f0                	jne    80105018 <sys_dup+0x28>
}
80105028:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010502b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105030:	89 d8                	mov    %ebx,%eax
80105032:	5b                   	pop    %ebx
80105033:	5e                   	pop    %esi
80105034:	5d                   	pop    %ebp
80105035:	c3                   	ret    
80105036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105040:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105044:	83 ec 0c             	sub    $0xc,%esp
80105047:	ff 75 f4             	pushl  -0xc(%ebp)
8010504a:	e8 71 c1 ff ff       	call   801011c0 <filedup>
  return fd;
8010504f:	83 c4 10             	add    $0x10,%esp
}
80105052:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105055:	89 d8                	mov    %ebx,%eax
80105057:	5b                   	pop    %ebx
80105058:	5e                   	pop    %esi
80105059:	5d                   	pop    %ebp
8010505a:	c3                   	ret    
8010505b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010505f:	90                   	nop

80105060 <sys_read>:
{
80105060:	f3 0f 1e fb          	endbr32 
80105064:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105065:	31 c0                	xor    %eax,%eax
{
80105067:	89 e5                	mov    %esp,%ebp
80105069:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010506c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010506f:	e8 2c ff ff ff       	call   80104fa0 <argfd.constprop.0>
80105074:	85 c0                	test   %eax,%eax
80105076:	78 48                	js     801050c0 <sys_read+0x60>
80105078:	83 ec 08             	sub    $0x8,%esp
8010507b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010507e:	50                   	push   %eax
8010507f:	6a 02                	push   $0x2
80105081:	e8 1a fc ff ff       	call   80104ca0 <argint>
80105086:	83 c4 10             	add    $0x10,%esp
80105089:	85 c0                	test   %eax,%eax
8010508b:	78 33                	js     801050c0 <sys_read+0x60>
8010508d:	83 ec 04             	sub    $0x4,%esp
80105090:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105093:	ff 75 f0             	pushl  -0x10(%ebp)
80105096:	50                   	push   %eax
80105097:	6a 01                	push   $0x1
80105099:	e8 52 fc ff ff       	call   80104cf0 <argptr>
8010509e:	83 c4 10             	add    $0x10,%esp
801050a1:	85 c0                	test   %eax,%eax
801050a3:	78 1b                	js     801050c0 <sys_read+0x60>
  return fileread(f, p, n);
801050a5:	83 ec 04             	sub    $0x4,%esp
801050a8:	ff 75 f0             	pushl  -0x10(%ebp)
801050ab:	ff 75 f4             	pushl  -0xc(%ebp)
801050ae:	ff 75 ec             	pushl  -0x14(%ebp)
801050b1:	e8 8a c2 ff ff       	call   80101340 <fileread>
801050b6:	83 c4 10             	add    $0x10,%esp
}
801050b9:	c9                   	leave  
801050ba:	c3                   	ret    
801050bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050bf:	90                   	nop
801050c0:	c9                   	leave  
    return -1;
801050c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050c6:	c3                   	ret    
801050c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ce:	66 90                	xchg   %ax,%ax

801050d0 <sys_write>:
{
801050d0:	f3 0f 1e fb          	endbr32 
801050d4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050d5:	31 c0                	xor    %eax,%eax
{
801050d7:	89 e5                	mov    %esp,%ebp
801050d9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050dc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801050df:	e8 bc fe ff ff       	call   80104fa0 <argfd.constprop.0>
801050e4:	85 c0                	test   %eax,%eax
801050e6:	78 48                	js     80105130 <sys_write+0x60>
801050e8:	83 ec 08             	sub    $0x8,%esp
801050eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050ee:	50                   	push   %eax
801050ef:	6a 02                	push   $0x2
801050f1:	e8 aa fb ff ff       	call   80104ca0 <argint>
801050f6:	83 c4 10             	add    $0x10,%esp
801050f9:	85 c0                	test   %eax,%eax
801050fb:	78 33                	js     80105130 <sys_write+0x60>
801050fd:	83 ec 04             	sub    $0x4,%esp
80105100:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105103:	ff 75 f0             	pushl  -0x10(%ebp)
80105106:	50                   	push   %eax
80105107:	6a 01                	push   $0x1
80105109:	e8 e2 fb ff ff       	call   80104cf0 <argptr>
8010510e:	83 c4 10             	add    $0x10,%esp
80105111:	85 c0                	test   %eax,%eax
80105113:	78 1b                	js     80105130 <sys_write+0x60>
  return filewrite(f, p, n);
80105115:	83 ec 04             	sub    $0x4,%esp
80105118:	ff 75 f0             	pushl  -0x10(%ebp)
8010511b:	ff 75 f4             	pushl  -0xc(%ebp)
8010511e:	ff 75 ec             	pushl  -0x14(%ebp)
80105121:	e8 ba c2 ff ff       	call   801013e0 <filewrite>
80105126:	83 c4 10             	add    $0x10,%esp
}
80105129:	c9                   	leave  
8010512a:	c3                   	ret    
8010512b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010512f:	90                   	nop
80105130:	c9                   	leave  
    return -1;
80105131:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105136:	c3                   	ret    
80105137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010513e:	66 90                	xchg   %ax,%ax

80105140 <sys_close>:
{
80105140:	f3 0f 1e fb          	endbr32 
80105144:	55                   	push   %ebp
80105145:	89 e5                	mov    %esp,%ebp
80105147:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010514a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010514d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105150:	e8 4b fe ff ff       	call   80104fa0 <argfd.constprop.0>
80105155:	85 c0                	test   %eax,%eax
80105157:	78 27                	js     80105180 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105159:	e8 52 eb ff ff       	call   80103cb0 <myproc>
8010515e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105161:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105164:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010516b:	00 
  fileclose(f);
8010516c:	ff 75 f4             	pushl  -0xc(%ebp)
8010516f:	e8 9c c0 ff ff       	call   80101210 <fileclose>
  return 0;
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	31 c0                	xor    %eax,%eax
}
80105179:	c9                   	leave  
8010517a:	c3                   	ret    
8010517b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010517f:	90                   	nop
80105180:	c9                   	leave  
    return -1;
80105181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105186:	c3                   	ret    
80105187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010518e:	66 90                	xchg   %ax,%ax

80105190 <sys_fstat>:
{
80105190:	f3 0f 1e fb          	endbr32 
80105194:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105195:	31 c0                	xor    %eax,%eax
{
80105197:	89 e5                	mov    %esp,%ebp
80105199:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010519c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010519f:	e8 fc fd ff ff       	call   80104fa0 <argfd.constprop.0>
801051a4:	85 c0                	test   %eax,%eax
801051a6:	78 30                	js     801051d8 <sys_fstat+0x48>
801051a8:	83 ec 04             	sub    $0x4,%esp
801051ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051ae:	6a 14                	push   $0x14
801051b0:	50                   	push   %eax
801051b1:	6a 01                	push   $0x1
801051b3:	e8 38 fb ff ff       	call   80104cf0 <argptr>
801051b8:	83 c4 10             	add    $0x10,%esp
801051bb:	85 c0                	test   %eax,%eax
801051bd:	78 19                	js     801051d8 <sys_fstat+0x48>
  return filestat(f, st);
801051bf:	83 ec 08             	sub    $0x8,%esp
801051c2:	ff 75 f4             	pushl  -0xc(%ebp)
801051c5:	ff 75 f0             	pushl  -0x10(%ebp)
801051c8:	e8 23 c1 ff ff       	call   801012f0 <filestat>
801051cd:	83 c4 10             	add    $0x10,%esp
}
801051d0:	c9                   	leave  
801051d1:	c3                   	ret    
801051d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801051d8:	c9                   	leave  
    return -1;
801051d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051de:	c3                   	ret    
801051df:	90                   	nop

801051e0 <sys_link>:
{
801051e0:	f3 0f 1e fb          	endbr32 
801051e4:	55                   	push   %ebp
801051e5:	89 e5                	mov    %esp,%ebp
801051e7:	57                   	push   %edi
801051e8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051e9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801051ec:	53                   	push   %ebx
801051ed:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051f0:	50                   	push   %eax
801051f1:	6a 00                	push   $0x0
801051f3:	e8 58 fb ff ff       	call   80104d50 <argstr>
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	85 c0                	test   %eax,%eax
801051fd:	0f 88 ff 00 00 00    	js     80105302 <sys_link+0x122>
80105203:	83 ec 08             	sub    $0x8,%esp
80105206:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105209:	50                   	push   %eax
8010520a:	6a 01                	push   $0x1
8010520c:	e8 3f fb ff ff       	call   80104d50 <argstr>
80105211:	83 c4 10             	add    $0x10,%esp
80105214:	85 c0                	test   %eax,%eax
80105216:	0f 88 e6 00 00 00    	js     80105302 <sys_link+0x122>
  begin_op();
8010521c:	e8 5f de ff ff       	call   80103080 <begin_op>
  if((ip = namei(old)) == 0){
80105221:	83 ec 0c             	sub    $0xc,%esp
80105224:	ff 75 d4             	pushl  -0x2c(%ebp)
80105227:	e8 54 d1 ff ff       	call   80102380 <namei>
8010522c:	83 c4 10             	add    $0x10,%esp
8010522f:	89 c3                	mov    %eax,%ebx
80105231:	85 c0                	test   %eax,%eax
80105233:	0f 84 e8 00 00 00    	je     80105321 <sys_link+0x141>
  ilock(ip);
80105239:	83 ec 0c             	sub    $0xc,%esp
8010523c:	50                   	push   %eax
8010523d:	e8 6e c8 ff ff       	call   80101ab0 <ilock>
  if(ip->type == T_DIR){
80105242:	83 c4 10             	add    $0x10,%esp
80105245:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010524a:	0f 84 b9 00 00 00    	je     80105309 <sys_link+0x129>
  iupdate(ip);
80105250:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105253:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105258:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010525b:	53                   	push   %ebx
8010525c:	e8 8f c7 ff ff       	call   801019f0 <iupdate>
  iunlock(ip);
80105261:	89 1c 24             	mov    %ebx,(%esp)
80105264:	e8 27 c9 ff ff       	call   80101b90 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105269:	58                   	pop    %eax
8010526a:	5a                   	pop    %edx
8010526b:	57                   	push   %edi
8010526c:	ff 75 d0             	pushl  -0x30(%ebp)
8010526f:	e8 2c d1 ff ff       	call   801023a0 <nameiparent>
80105274:	83 c4 10             	add    $0x10,%esp
80105277:	89 c6                	mov    %eax,%esi
80105279:	85 c0                	test   %eax,%eax
8010527b:	74 5f                	je     801052dc <sys_link+0xfc>
  ilock(dp);
8010527d:	83 ec 0c             	sub    $0xc,%esp
80105280:	50                   	push   %eax
80105281:	e8 2a c8 ff ff       	call   80101ab0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105286:	8b 03                	mov    (%ebx),%eax
80105288:	83 c4 10             	add    $0x10,%esp
8010528b:	39 06                	cmp    %eax,(%esi)
8010528d:	75 41                	jne    801052d0 <sys_link+0xf0>
8010528f:	83 ec 04             	sub    $0x4,%esp
80105292:	ff 73 04             	pushl  0x4(%ebx)
80105295:	57                   	push   %edi
80105296:	56                   	push   %esi
80105297:	e8 24 d0 ff ff       	call   801022c0 <dirlink>
8010529c:	83 c4 10             	add    $0x10,%esp
8010529f:	85 c0                	test   %eax,%eax
801052a1:	78 2d                	js     801052d0 <sys_link+0xf0>
  iunlockput(dp);
801052a3:	83 ec 0c             	sub    $0xc,%esp
801052a6:	56                   	push   %esi
801052a7:	e8 a4 ca ff ff       	call   80101d50 <iunlockput>
  iput(ip);
801052ac:	89 1c 24             	mov    %ebx,(%esp)
801052af:	e8 2c c9 ff ff       	call   80101be0 <iput>
  end_op();
801052b4:	e8 37 de ff ff       	call   801030f0 <end_op>
  return 0;
801052b9:	83 c4 10             	add    $0x10,%esp
801052bc:	31 c0                	xor    %eax,%eax
}
801052be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052c1:	5b                   	pop    %ebx
801052c2:	5e                   	pop    %esi
801052c3:	5f                   	pop    %edi
801052c4:	5d                   	pop    %ebp
801052c5:	c3                   	ret    
801052c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052cd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801052d0:	83 ec 0c             	sub    $0xc,%esp
801052d3:	56                   	push   %esi
801052d4:	e8 77 ca ff ff       	call   80101d50 <iunlockput>
    goto bad;
801052d9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801052dc:	83 ec 0c             	sub    $0xc,%esp
801052df:	53                   	push   %ebx
801052e0:	e8 cb c7 ff ff       	call   80101ab0 <ilock>
  ip->nlink--;
801052e5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052ea:	89 1c 24             	mov    %ebx,(%esp)
801052ed:	e8 fe c6 ff ff       	call   801019f0 <iupdate>
  iunlockput(ip);
801052f2:	89 1c 24             	mov    %ebx,(%esp)
801052f5:	e8 56 ca ff ff       	call   80101d50 <iunlockput>
  end_op();
801052fa:	e8 f1 dd ff ff       	call   801030f0 <end_op>
  return -1;
801052ff:	83 c4 10             	add    $0x10,%esp
80105302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105307:	eb b5                	jmp    801052be <sys_link+0xde>
    iunlockput(ip);
80105309:	83 ec 0c             	sub    $0xc,%esp
8010530c:	53                   	push   %ebx
8010530d:	e8 3e ca ff ff       	call   80101d50 <iunlockput>
    end_op();
80105312:	e8 d9 dd ff ff       	call   801030f0 <end_op>
    return -1;
80105317:	83 c4 10             	add    $0x10,%esp
8010531a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531f:	eb 9d                	jmp    801052be <sys_link+0xde>
    end_op();
80105321:	e8 ca dd ff ff       	call   801030f0 <end_op>
    return -1;
80105326:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010532b:	eb 91                	jmp    801052be <sys_link+0xde>
8010532d:	8d 76 00             	lea    0x0(%esi),%esi

80105330 <sys_unlink>:
{
80105330:	f3 0f 1e fb          	endbr32 
80105334:	55                   	push   %ebp
80105335:	89 e5                	mov    %esp,%ebp
80105337:	57                   	push   %edi
80105338:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105339:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010533c:	53                   	push   %ebx
8010533d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105340:	50                   	push   %eax
80105341:	6a 00                	push   $0x0
80105343:	e8 08 fa ff ff       	call   80104d50 <argstr>
80105348:	83 c4 10             	add    $0x10,%esp
8010534b:	85 c0                	test   %eax,%eax
8010534d:	0f 88 7d 01 00 00    	js     801054d0 <sys_unlink+0x1a0>
  begin_op();
80105353:	e8 28 dd ff ff       	call   80103080 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105358:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010535b:	83 ec 08             	sub    $0x8,%esp
8010535e:	53                   	push   %ebx
8010535f:	ff 75 c0             	pushl  -0x40(%ebp)
80105362:	e8 39 d0 ff ff       	call   801023a0 <nameiparent>
80105367:	83 c4 10             	add    $0x10,%esp
8010536a:	89 c6                	mov    %eax,%esi
8010536c:	85 c0                	test   %eax,%eax
8010536e:	0f 84 66 01 00 00    	je     801054da <sys_unlink+0x1aa>
  ilock(dp);
80105374:	83 ec 0c             	sub    $0xc,%esp
80105377:	50                   	push   %eax
80105378:	e8 33 c7 ff ff       	call   80101ab0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010537d:	58                   	pop    %eax
8010537e:	5a                   	pop    %edx
8010537f:	68 74 7b 10 80       	push   $0x80107b74
80105384:	53                   	push   %ebx
80105385:	e8 56 cc ff ff       	call   80101fe0 <namecmp>
8010538a:	83 c4 10             	add    $0x10,%esp
8010538d:	85 c0                	test   %eax,%eax
8010538f:	0f 84 03 01 00 00    	je     80105498 <sys_unlink+0x168>
80105395:	83 ec 08             	sub    $0x8,%esp
80105398:	68 73 7b 10 80       	push   $0x80107b73
8010539d:	53                   	push   %ebx
8010539e:	e8 3d cc ff ff       	call   80101fe0 <namecmp>
801053a3:	83 c4 10             	add    $0x10,%esp
801053a6:	85 c0                	test   %eax,%eax
801053a8:	0f 84 ea 00 00 00    	je     80105498 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801053ae:	83 ec 04             	sub    $0x4,%esp
801053b1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801053b4:	50                   	push   %eax
801053b5:	53                   	push   %ebx
801053b6:	56                   	push   %esi
801053b7:	e8 44 cc ff ff       	call   80102000 <dirlookup>
801053bc:	83 c4 10             	add    $0x10,%esp
801053bf:	89 c3                	mov    %eax,%ebx
801053c1:	85 c0                	test   %eax,%eax
801053c3:	0f 84 cf 00 00 00    	je     80105498 <sys_unlink+0x168>
  ilock(ip);
801053c9:	83 ec 0c             	sub    $0xc,%esp
801053cc:	50                   	push   %eax
801053cd:	e8 de c6 ff ff       	call   80101ab0 <ilock>
  if(ip->nlink < 1)
801053d2:	83 c4 10             	add    $0x10,%esp
801053d5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801053da:	0f 8e 23 01 00 00    	jle    80105503 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801053e0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053e5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801053e8:	74 66                	je     80105450 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801053ea:	83 ec 04             	sub    $0x4,%esp
801053ed:	6a 10                	push   $0x10
801053ef:	6a 00                	push   $0x0
801053f1:	57                   	push   %edi
801053f2:	e8 c9 f5 ff ff       	call   801049c0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053f7:	6a 10                	push   $0x10
801053f9:	ff 75 c4             	pushl  -0x3c(%ebp)
801053fc:	57                   	push   %edi
801053fd:	56                   	push   %esi
801053fe:	e8 ad ca ff ff       	call   80101eb0 <writei>
80105403:	83 c4 20             	add    $0x20,%esp
80105406:	83 f8 10             	cmp    $0x10,%eax
80105409:	0f 85 e7 00 00 00    	jne    801054f6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010540f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105414:	0f 84 96 00 00 00    	je     801054b0 <sys_unlink+0x180>
  iunlockput(dp);
8010541a:	83 ec 0c             	sub    $0xc,%esp
8010541d:	56                   	push   %esi
8010541e:	e8 2d c9 ff ff       	call   80101d50 <iunlockput>
  ip->nlink--;
80105423:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105428:	89 1c 24             	mov    %ebx,(%esp)
8010542b:	e8 c0 c5 ff ff       	call   801019f0 <iupdate>
  iunlockput(ip);
80105430:	89 1c 24             	mov    %ebx,(%esp)
80105433:	e8 18 c9 ff ff       	call   80101d50 <iunlockput>
  end_op();
80105438:	e8 b3 dc ff ff       	call   801030f0 <end_op>
  return 0;
8010543d:	83 c4 10             	add    $0x10,%esp
80105440:	31 c0                	xor    %eax,%eax
}
80105442:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105445:	5b                   	pop    %ebx
80105446:	5e                   	pop    %esi
80105447:	5f                   	pop    %edi
80105448:	5d                   	pop    %ebp
80105449:	c3                   	ret    
8010544a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105450:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105454:	76 94                	jbe    801053ea <sys_unlink+0xba>
80105456:	ba 20 00 00 00       	mov    $0x20,%edx
8010545b:	eb 0b                	jmp    80105468 <sys_unlink+0x138>
8010545d:	8d 76 00             	lea    0x0(%esi),%esi
80105460:	83 c2 10             	add    $0x10,%edx
80105463:	39 53 58             	cmp    %edx,0x58(%ebx)
80105466:	76 82                	jbe    801053ea <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105468:	6a 10                	push   $0x10
8010546a:	52                   	push   %edx
8010546b:	57                   	push   %edi
8010546c:	53                   	push   %ebx
8010546d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105470:	e8 3b c9 ff ff       	call   80101db0 <readi>
80105475:	83 c4 10             	add    $0x10,%esp
80105478:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010547b:	83 f8 10             	cmp    $0x10,%eax
8010547e:	75 69                	jne    801054e9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105480:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105485:	74 d9                	je     80105460 <sys_unlink+0x130>
    iunlockput(ip);
80105487:	83 ec 0c             	sub    $0xc,%esp
8010548a:	53                   	push   %ebx
8010548b:	e8 c0 c8 ff ff       	call   80101d50 <iunlockput>
    goto bad;
80105490:	83 c4 10             	add    $0x10,%esp
80105493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105497:	90                   	nop
  iunlockput(dp);
80105498:	83 ec 0c             	sub    $0xc,%esp
8010549b:	56                   	push   %esi
8010549c:	e8 af c8 ff ff       	call   80101d50 <iunlockput>
  end_op();
801054a1:	e8 4a dc ff ff       	call   801030f0 <end_op>
  return -1;
801054a6:	83 c4 10             	add    $0x10,%esp
801054a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ae:	eb 92                	jmp    80105442 <sys_unlink+0x112>
    iupdate(dp);
801054b0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801054b3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801054b8:	56                   	push   %esi
801054b9:	e8 32 c5 ff ff       	call   801019f0 <iupdate>
801054be:	83 c4 10             	add    $0x10,%esp
801054c1:	e9 54 ff ff ff       	jmp    8010541a <sys_unlink+0xea>
801054c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801054d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054d5:	e9 68 ff ff ff       	jmp    80105442 <sys_unlink+0x112>
    end_op();
801054da:	e8 11 dc ff ff       	call   801030f0 <end_op>
    return -1;
801054df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e4:	e9 59 ff ff ff       	jmp    80105442 <sys_unlink+0x112>
      panic("isdirempty: readi");
801054e9:	83 ec 0c             	sub    $0xc,%esp
801054ec:	68 98 7b 10 80       	push   $0x80107b98
801054f1:	e8 1a b1 ff ff       	call   80100610 <panic>
    panic("unlink: writei");
801054f6:	83 ec 0c             	sub    $0xc,%esp
801054f9:	68 aa 7b 10 80       	push   $0x80107baa
801054fe:	e8 0d b1 ff ff       	call   80100610 <panic>
    panic("unlink: nlink < 1");
80105503:	83 ec 0c             	sub    $0xc,%esp
80105506:	68 86 7b 10 80       	push   $0x80107b86
8010550b:	e8 00 b1 ff ff       	call   80100610 <panic>

80105510 <sys_open>:

int
sys_open(void)
{
80105510:	f3 0f 1e fb          	endbr32 
80105514:	55                   	push   %ebp
80105515:	89 e5                	mov    %esp,%ebp
80105517:	57                   	push   %edi
80105518:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105519:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010551c:	53                   	push   %ebx
8010551d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105520:	50                   	push   %eax
80105521:	6a 00                	push   $0x0
80105523:	e8 28 f8 ff ff       	call   80104d50 <argstr>
80105528:	83 c4 10             	add    $0x10,%esp
8010552b:	85 c0                	test   %eax,%eax
8010552d:	0f 88 8a 00 00 00    	js     801055bd <sys_open+0xad>
80105533:	83 ec 08             	sub    $0x8,%esp
80105536:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105539:	50                   	push   %eax
8010553a:	6a 01                	push   $0x1
8010553c:	e8 5f f7 ff ff       	call   80104ca0 <argint>
80105541:	83 c4 10             	add    $0x10,%esp
80105544:	85 c0                	test   %eax,%eax
80105546:	78 75                	js     801055bd <sys_open+0xad>
    return -1;

  begin_op();
80105548:	e8 33 db ff ff       	call   80103080 <begin_op>

  if(omode & O_CREATE){
8010554d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105551:	75 75                	jne    801055c8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105553:	83 ec 0c             	sub    $0xc,%esp
80105556:	ff 75 e0             	pushl  -0x20(%ebp)
80105559:	e8 22 ce ff ff       	call   80102380 <namei>
8010555e:	83 c4 10             	add    $0x10,%esp
80105561:	89 c6                	mov    %eax,%esi
80105563:	85 c0                	test   %eax,%eax
80105565:	74 7e                	je     801055e5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105567:	83 ec 0c             	sub    $0xc,%esp
8010556a:	50                   	push   %eax
8010556b:	e8 40 c5 ff ff       	call   80101ab0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105570:	83 c4 10             	add    $0x10,%esp
80105573:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105578:	0f 84 c2 00 00 00    	je     80105640 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010557e:	e8 cd bb ff ff       	call   80101150 <filealloc>
80105583:	89 c7                	mov    %eax,%edi
80105585:	85 c0                	test   %eax,%eax
80105587:	74 23                	je     801055ac <sys_open+0x9c>
  struct proc *curproc = myproc();
80105589:	e8 22 e7 ff ff       	call   80103cb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010558e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105590:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105594:	85 d2                	test   %edx,%edx
80105596:	74 60                	je     801055f8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105598:	83 c3 01             	add    $0x1,%ebx
8010559b:	83 fb 10             	cmp    $0x10,%ebx
8010559e:	75 f0                	jne    80105590 <sys_open+0x80>
    if(f)
      fileclose(f);
801055a0:	83 ec 0c             	sub    $0xc,%esp
801055a3:	57                   	push   %edi
801055a4:	e8 67 bc ff ff       	call   80101210 <fileclose>
801055a9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801055ac:	83 ec 0c             	sub    $0xc,%esp
801055af:	56                   	push   %esi
801055b0:	e8 9b c7 ff ff       	call   80101d50 <iunlockput>
    end_op();
801055b5:	e8 36 db ff ff       	call   801030f0 <end_op>
    return -1;
801055ba:	83 c4 10             	add    $0x10,%esp
801055bd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055c2:	eb 6d                	jmp    80105631 <sys_open+0x121>
801055c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801055c8:	83 ec 0c             	sub    $0xc,%esp
801055cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055ce:	31 c9                	xor    %ecx,%ecx
801055d0:	ba 02 00 00 00       	mov    $0x2,%edx
801055d5:	6a 00                	push   $0x0
801055d7:	e8 24 f8 ff ff       	call   80104e00 <create>
    if(ip == 0){
801055dc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801055df:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801055e1:	85 c0                	test   %eax,%eax
801055e3:	75 99                	jne    8010557e <sys_open+0x6e>
      end_op();
801055e5:	e8 06 db ff ff       	call   801030f0 <end_op>
      return -1;
801055ea:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055ef:	eb 40                	jmp    80105631 <sys_open+0x121>
801055f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801055f8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801055fb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801055ff:	56                   	push   %esi
80105600:	e8 8b c5 ff ff       	call   80101b90 <iunlock>
  end_op();
80105605:	e8 e6 da ff ff       	call   801030f0 <end_op>

  f->type = FD_INODE;
8010560a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105610:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105613:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105616:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105619:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010561b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105622:	f7 d0                	not    %eax
80105624:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105627:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010562a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010562d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105631:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105634:	89 d8                	mov    %ebx,%eax
80105636:	5b                   	pop    %ebx
80105637:	5e                   	pop    %esi
80105638:	5f                   	pop    %edi
80105639:	5d                   	pop    %ebp
8010563a:	c3                   	ret    
8010563b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010563f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105640:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105643:	85 c9                	test   %ecx,%ecx
80105645:	0f 84 33 ff ff ff    	je     8010557e <sys_open+0x6e>
8010564b:	e9 5c ff ff ff       	jmp    801055ac <sys_open+0x9c>

80105650 <sys_mkdir>:

int
sys_mkdir(void)
{
80105650:	f3 0f 1e fb          	endbr32 
80105654:	55                   	push   %ebp
80105655:	89 e5                	mov    %esp,%ebp
80105657:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010565a:	e8 21 da ff ff       	call   80103080 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010565f:	83 ec 08             	sub    $0x8,%esp
80105662:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105665:	50                   	push   %eax
80105666:	6a 00                	push   $0x0
80105668:	e8 e3 f6 ff ff       	call   80104d50 <argstr>
8010566d:	83 c4 10             	add    $0x10,%esp
80105670:	85 c0                	test   %eax,%eax
80105672:	78 34                	js     801056a8 <sys_mkdir+0x58>
80105674:	83 ec 0c             	sub    $0xc,%esp
80105677:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010567a:	31 c9                	xor    %ecx,%ecx
8010567c:	ba 01 00 00 00       	mov    $0x1,%edx
80105681:	6a 00                	push   $0x0
80105683:	e8 78 f7 ff ff       	call   80104e00 <create>
80105688:	83 c4 10             	add    $0x10,%esp
8010568b:	85 c0                	test   %eax,%eax
8010568d:	74 19                	je     801056a8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010568f:	83 ec 0c             	sub    $0xc,%esp
80105692:	50                   	push   %eax
80105693:	e8 b8 c6 ff ff       	call   80101d50 <iunlockput>
  end_op();
80105698:	e8 53 da ff ff       	call   801030f0 <end_op>
  return 0;
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	31 c0                	xor    %eax,%eax
}
801056a2:	c9                   	leave  
801056a3:	c3                   	ret    
801056a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801056a8:	e8 43 da ff ff       	call   801030f0 <end_op>
    return -1;
801056ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056b2:	c9                   	leave  
801056b3:	c3                   	ret    
801056b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056bf:	90                   	nop

801056c0 <sys_mknod>:

int
sys_mknod(void)
{
801056c0:	f3 0f 1e fb          	endbr32 
801056c4:	55                   	push   %ebp
801056c5:	89 e5                	mov    %esp,%ebp
801056c7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801056ca:	e8 b1 d9 ff ff       	call   80103080 <begin_op>
  if((argstr(0, &path)) < 0 ||
801056cf:	83 ec 08             	sub    $0x8,%esp
801056d2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056d5:	50                   	push   %eax
801056d6:	6a 00                	push   $0x0
801056d8:	e8 73 f6 ff ff       	call   80104d50 <argstr>
801056dd:	83 c4 10             	add    $0x10,%esp
801056e0:	85 c0                	test   %eax,%eax
801056e2:	78 64                	js     80105748 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801056e4:	83 ec 08             	sub    $0x8,%esp
801056e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056ea:	50                   	push   %eax
801056eb:	6a 01                	push   $0x1
801056ed:	e8 ae f5 ff ff       	call   80104ca0 <argint>
  if((argstr(0, &path)) < 0 ||
801056f2:	83 c4 10             	add    $0x10,%esp
801056f5:	85 c0                	test   %eax,%eax
801056f7:	78 4f                	js     80105748 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
801056f9:	83 ec 08             	sub    $0x8,%esp
801056fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ff:	50                   	push   %eax
80105700:	6a 02                	push   $0x2
80105702:	e8 99 f5 ff ff       	call   80104ca0 <argint>
     argint(1, &major) < 0 ||
80105707:	83 c4 10             	add    $0x10,%esp
8010570a:	85 c0                	test   %eax,%eax
8010570c:	78 3a                	js     80105748 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010570e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105712:	83 ec 0c             	sub    $0xc,%esp
80105715:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105719:	ba 03 00 00 00       	mov    $0x3,%edx
8010571e:	50                   	push   %eax
8010571f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105722:	e8 d9 f6 ff ff       	call   80104e00 <create>
     argint(2, &minor) < 0 ||
80105727:	83 c4 10             	add    $0x10,%esp
8010572a:	85 c0                	test   %eax,%eax
8010572c:	74 1a                	je     80105748 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010572e:	83 ec 0c             	sub    $0xc,%esp
80105731:	50                   	push   %eax
80105732:	e8 19 c6 ff ff       	call   80101d50 <iunlockput>
  end_op();
80105737:	e8 b4 d9 ff ff       	call   801030f0 <end_op>
  return 0;
8010573c:	83 c4 10             	add    $0x10,%esp
8010573f:	31 c0                	xor    %eax,%eax
}
80105741:	c9                   	leave  
80105742:	c3                   	ret    
80105743:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105747:	90                   	nop
    end_op();
80105748:	e8 a3 d9 ff ff       	call   801030f0 <end_op>
    return -1;
8010574d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105752:	c9                   	leave  
80105753:	c3                   	ret    
80105754:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010575f:	90                   	nop

80105760 <sys_chdir>:

int
sys_chdir(void)
{
80105760:	f3 0f 1e fb          	endbr32 
80105764:	55                   	push   %ebp
80105765:	89 e5                	mov    %esp,%ebp
80105767:	56                   	push   %esi
80105768:	53                   	push   %ebx
80105769:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010576c:	e8 3f e5 ff ff       	call   80103cb0 <myproc>
80105771:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105773:	e8 08 d9 ff ff       	call   80103080 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105778:	83 ec 08             	sub    $0x8,%esp
8010577b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010577e:	50                   	push   %eax
8010577f:	6a 00                	push   $0x0
80105781:	e8 ca f5 ff ff       	call   80104d50 <argstr>
80105786:	83 c4 10             	add    $0x10,%esp
80105789:	85 c0                	test   %eax,%eax
8010578b:	78 73                	js     80105800 <sys_chdir+0xa0>
8010578d:	83 ec 0c             	sub    $0xc,%esp
80105790:	ff 75 f4             	pushl  -0xc(%ebp)
80105793:	e8 e8 cb ff ff       	call   80102380 <namei>
80105798:	83 c4 10             	add    $0x10,%esp
8010579b:	89 c3                	mov    %eax,%ebx
8010579d:	85 c0                	test   %eax,%eax
8010579f:	74 5f                	je     80105800 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801057a1:	83 ec 0c             	sub    $0xc,%esp
801057a4:	50                   	push   %eax
801057a5:	e8 06 c3 ff ff       	call   80101ab0 <ilock>
  if(ip->type != T_DIR){
801057aa:	83 c4 10             	add    $0x10,%esp
801057ad:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057b2:	75 2c                	jne    801057e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057b4:	83 ec 0c             	sub    $0xc,%esp
801057b7:	53                   	push   %ebx
801057b8:	e8 d3 c3 ff ff       	call   80101b90 <iunlock>
  iput(curproc->cwd);
801057bd:	58                   	pop    %eax
801057be:	ff 76 68             	pushl  0x68(%esi)
801057c1:	e8 1a c4 ff ff       	call   80101be0 <iput>
  end_op();
801057c6:	e8 25 d9 ff ff       	call   801030f0 <end_op>
  curproc->cwd = ip;
801057cb:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801057ce:	83 c4 10             	add    $0x10,%esp
801057d1:	31 c0                	xor    %eax,%eax
}
801057d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057d6:	5b                   	pop    %ebx
801057d7:	5e                   	pop    %esi
801057d8:	5d                   	pop    %ebp
801057d9:	c3                   	ret    
801057da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801057e0:	83 ec 0c             	sub    $0xc,%esp
801057e3:	53                   	push   %ebx
801057e4:	e8 67 c5 ff ff       	call   80101d50 <iunlockput>
    end_op();
801057e9:	e8 02 d9 ff ff       	call   801030f0 <end_op>
    return -1;
801057ee:	83 c4 10             	add    $0x10,%esp
801057f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f6:	eb db                	jmp    801057d3 <sys_chdir+0x73>
801057f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ff:	90                   	nop
    end_op();
80105800:	e8 eb d8 ff ff       	call   801030f0 <end_op>
    return -1;
80105805:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580a:	eb c7                	jmp    801057d3 <sys_chdir+0x73>
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105810 <sys_exec>:

int
sys_exec(void)
{
80105810:	f3 0f 1e fb          	endbr32 
80105814:	55                   	push   %ebp
80105815:	89 e5                	mov    %esp,%ebp
80105817:	57                   	push   %edi
80105818:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105819:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010581f:	53                   	push   %ebx
80105820:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105826:	50                   	push   %eax
80105827:	6a 00                	push   $0x0
80105829:	e8 22 f5 ff ff       	call   80104d50 <argstr>
8010582e:	83 c4 10             	add    $0x10,%esp
80105831:	85 c0                	test   %eax,%eax
80105833:	0f 88 8b 00 00 00    	js     801058c4 <sys_exec+0xb4>
80105839:	83 ec 08             	sub    $0x8,%esp
8010583c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105842:	50                   	push   %eax
80105843:	6a 01                	push   $0x1
80105845:	e8 56 f4 ff ff       	call   80104ca0 <argint>
8010584a:	83 c4 10             	add    $0x10,%esp
8010584d:	85 c0                	test   %eax,%eax
8010584f:	78 73                	js     801058c4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105851:	83 ec 04             	sub    $0x4,%esp
80105854:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010585a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010585c:	68 80 00 00 00       	push   $0x80
80105861:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105867:	6a 00                	push   $0x0
80105869:	50                   	push   %eax
8010586a:	e8 51 f1 ff ff       	call   801049c0 <memset>
8010586f:	83 c4 10             	add    $0x10,%esp
80105872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105878:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010587e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105885:	83 ec 08             	sub    $0x8,%esp
80105888:	57                   	push   %edi
80105889:	01 f0                	add    %esi,%eax
8010588b:	50                   	push   %eax
8010588c:	e8 6f f3 ff ff       	call   80104c00 <fetchint>
80105891:	83 c4 10             	add    $0x10,%esp
80105894:	85 c0                	test   %eax,%eax
80105896:	78 2c                	js     801058c4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105898:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010589e:	85 c0                	test   %eax,%eax
801058a0:	74 36                	je     801058d8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801058a2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801058a8:	83 ec 08             	sub    $0x8,%esp
801058ab:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801058ae:	52                   	push   %edx
801058af:	50                   	push   %eax
801058b0:	e8 8b f3 ff ff       	call   80104c40 <fetchstr>
801058b5:	83 c4 10             	add    $0x10,%esp
801058b8:	85 c0                	test   %eax,%eax
801058ba:	78 08                	js     801058c4 <sys_exec+0xb4>
  for(i=0;; i++){
801058bc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801058bf:	83 fb 20             	cmp    $0x20,%ebx
801058c2:	75 b4                	jne    80105878 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
801058c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801058c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058cc:	5b                   	pop    %ebx
801058cd:	5e                   	pop    %esi
801058ce:	5f                   	pop    %edi
801058cf:	5d                   	pop    %ebp
801058d0:	c3                   	ret    
801058d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801058d8:	83 ec 08             	sub    $0x8,%esp
801058db:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801058e1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801058e8:	00 00 00 00 
  return exec(path, argv);
801058ec:	50                   	push   %eax
801058ed:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801058f3:	e8 d8 b4 ff ff       	call   80100dd0 <exec>
801058f8:	83 c4 10             	add    $0x10,%esp
}
801058fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058fe:	5b                   	pop    %ebx
801058ff:	5e                   	pop    %esi
80105900:	5f                   	pop    %edi
80105901:	5d                   	pop    %ebp
80105902:	c3                   	ret    
80105903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105910 <sys_pipe>:

int
sys_pipe(void)
{
80105910:	f3 0f 1e fb          	endbr32 
80105914:	55                   	push   %ebp
80105915:	89 e5                	mov    %esp,%ebp
80105917:	57                   	push   %edi
80105918:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105919:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010591c:	53                   	push   %ebx
8010591d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105920:	6a 08                	push   $0x8
80105922:	50                   	push   %eax
80105923:	6a 00                	push   $0x0
80105925:	e8 c6 f3 ff ff       	call   80104cf0 <argptr>
8010592a:	83 c4 10             	add    $0x10,%esp
8010592d:	85 c0                	test   %eax,%eax
8010592f:	78 4e                	js     8010597f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105931:	83 ec 08             	sub    $0x8,%esp
80105934:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105937:	50                   	push   %eax
80105938:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010593b:	50                   	push   %eax
8010593c:	e8 ff dd ff ff       	call   80103740 <pipealloc>
80105941:	83 c4 10             	add    $0x10,%esp
80105944:	85 c0                	test   %eax,%eax
80105946:	78 37                	js     8010597f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105948:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010594b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010594d:	e8 5e e3 ff ff       	call   80103cb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105958:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010595c:	85 f6                	test   %esi,%esi
8010595e:	74 30                	je     80105990 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105960:	83 c3 01             	add    $0x1,%ebx
80105963:	83 fb 10             	cmp    $0x10,%ebx
80105966:	75 f0                	jne    80105958 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105968:	83 ec 0c             	sub    $0xc,%esp
8010596b:	ff 75 e0             	pushl  -0x20(%ebp)
8010596e:	e8 9d b8 ff ff       	call   80101210 <fileclose>
    fileclose(wf);
80105973:	58                   	pop    %eax
80105974:	ff 75 e4             	pushl  -0x1c(%ebp)
80105977:	e8 94 b8 ff ff       	call   80101210 <fileclose>
    return -1;
8010597c:	83 c4 10             	add    $0x10,%esp
8010597f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105984:	eb 5b                	jmp    801059e1 <sys_pipe+0xd1>
80105986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105990:	8d 73 08             	lea    0x8(%ebx),%esi
80105993:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010599a:	e8 11 e3 ff ff       	call   80103cb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010599f:	31 d2                	xor    %edx,%edx
801059a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801059a8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801059ac:	85 c9                	test   %ecx,%ecx
801059ae:	74 20                	je     801059d0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
801059b0:	83 c2 01             	add    $0x1,%edx
801059b3:	83 fa 10             	cmp    $0x10,%edx
801059b6:	75 f0                	jne    801059a8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
801059b8:	e8 f3 e2 ff ff       	call   80103cb0 <myproc>
801059bd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801059c4:	00 
801059c5:	eb a1                	jmp    80105968 <sys_pipe+0x58>
801059c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ce:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801059d0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801059d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059d7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801059d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059dc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801059df:	31 c0                	xor    %eax,%eax
}
801059e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059e4:	5b                   	pop    %ebx
801059e5:	5e                   	pop    %esi
801059e6:	5f                   	pop    %edi
801059e7:	5d                   	pop    %ebp
801059e8:	c3                   	ret    
801059e9:	66 90                	xchg   %ax,%ax
801059eb:	66 90                	xchg   %ax,%ax
801059ed:	66 90                	xchg   %ax,%ax
801059ef:	90                   	nop

801059f0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801059f0:	f3 0f 1e fb          	endbr32 
  return fork();
801059f4:	e9 67 e4 ff ff       	jmp    80103e60 <fork>
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a00 <sys_exit>:
}

int
sys_exit(void)
{
80105a00:	f3 0f 1e fb          	endbr32 
80105a04:	55                   	push   %ebp
80105a05:	89 e5                	mov    %esp,%ebp
80105a07:	83 ec 08             	sub    $0x8,%esp
  exit();
80105a0a:	e8 d1 e6 ff ff       	call   801040e0 <exit>
  return 0;  // not reached
}
80105a0f:	31 c0                	xor    %eax,%eax
80105a11:	c9                   	leave  
80105a12:	c3                   	ret    
80105a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a20 <sys_wait>:

int
sys_wait(void)
{
80105a20:	f3 0f 1e fb          	endbr32 
  return wait();
80105a24:	e9 07 e9 ff ff       	jmp    80104330 <wait>
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a30 <sys_kill>:
}

int
sys_kill(void)
{
80105a30:	f3 0f 1e fb          	endbr32 
80105a34:	55                   	push   %ebp
80105a35:	89 e5                	mov    %esp,%ebp
80105a37:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a3d:	50                   	push   %eax
80105a3e:	6a 00                	push   $0x0
80105a40:	e8 5b f2 ff ff       	call   80104ca0 <argint>
80105a45:	83 c4 10             	add    $0x10,%esp
80105a48:	85 c0                	test   %eax,%eax
80105a4a:	78 14                	js     80105a60 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a4c:	83 ec 0c             	sub    $0xc,%esp
80105a4f:	ff 75 f4             	pushl  -0xc(%ebp)
80105a52:	e8 39 ea ff ff       	call   80104490 <kill>
80105a57:	83 c4 10             	add    $0x10,%esp
}
80105a5a:	c9                   	leave  
80105a5b:	c3                   	ret    
80105a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a60:	c9                   	leave  
    return -1;
80105a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a66:	c3                   	ret    
80105a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6e:	66 90                	xchg   %ax,%ax

80105a70 <sys_getpid>:

int
sys_getpid(void)
{
80105a70:	f3 0f 1e fb          	endbr32 
80105a74:	55                   	push   %ebp
80105a75:	89 e5                	mov    %esp,%ebp
80105a77:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a7a:	e8 31 e2 ff ff       	call   80103cb0 <myproc>
80105a7f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a82:	c9                   	leave  
80105a83:	c3                   	ret    
80105a84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a8f:	90                   	nop

80105a90 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a90:	f3 0f 1e fb          	endbr32 
80105a94:	55                   	push   %ebp
80105a95:	89 e5                	mov    %esp,%ebp
80105a97:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a98:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a9b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a9e:	50                   	push   %eax
80105a9f:	6a 00                	push   $0x0
80105aa1:	e8 fa f1 ff ff       	call   80104ca0 <argint>
80105aa6:	83 c4 10             	add    $0x10,%esp
80105aa9:	85 c0                	test   %eax,%eax
80105aab:	78 23                	js     80105ad0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105aad:	e8 fe e1 ff ff       	call   80103cb0 <myproc>
  if(growproc(n) < 0)
80105ab2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ab5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ab7:	ff 75 f4             	pushl  -0xc(%ebp)
80105aba:	e8 21 e3 ff ff       	call   80103de0 <growproc>
80105abf:	83 c4 10             	add    $0x10,%esp
80105ac2:	85 c0                	test   %eax,%eax
80105ac4:	78 0a                	js     80105ad0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ac6:	89 d8                	mov    %ebx,%eax
80105ac8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105acb:	c9                   	leave  
80105acc:	c3                   	ret    
80105acd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ad0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ad5:	eb ef                	jmp    80105ac6 <sys_sbrk+0x36>
80105ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ade:	66 90                	xchg   %ax,%ax

80105ae0 <sys_sleep>:

int
sys_sleep(void)
{
80105ae0:	f3 0f 1e fb          	endbr32 
80105ae4:	55                   	push   %ebp
80105ae5:	89 e5                	mov    %esp,%ebp
80105ae7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ae8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105aeb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105aee:	50                   	push   %eax
80105aef:	6a 00                	push   $0x0
80105af1:	e8 aa f1 ff ff       	call   80104ca0 <argint>
80105af6:	83 c4 10             	add    $0x10,%esp
80105af9:	85 c0                	test   %eax,%eax
80105afb:	0f 88 86 00 00 00    	js     80105b87 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105b01:	83 ec 0c             	sub    $0xc,%esp
80105b04:	68 c0 4c 11 80       	push   $0x80114cc0
80105b09:	e8 a2 ed ff ff       	call   801048b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105b11:	8b 1d 00 55 11 80    	mov    0x80115500,%ebx
  while(ticks - ticks0 < n){
80105b17:	83 c4 10             	add    $0x10,%esp
80105b1a:	85 d2                	test   %edx,%edx
80105b1c:	75 23                	jne    80105b41 <sys_sleep+0x61>
80105b1e:	eb 50                	jmp    80105b70 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105b20:	83 ec 08             	sub    $0x8,%esp
80105b23:	68 c0 4c 11 80       	push   $0x80114cc0
80105b28:	68 00 55 11 80       	push   $0x80115500
80105b2d:	e8 3e e7 ff ff       	call   80104270 <sleep>
  while(ticks - ticks0 < n){
80105b32:	a1 00 55 11 80       	mov    0x80115500,%eax
80105b37:	83 c4 10             	add    $0x10,%esp
80105b3a:	29 d8                	sub    %ebx,%eax
80105b3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b3f:	73 2f                	jae    80105b70 <sys_sleep+0x90>
    if(myproc()->killed){
80105b41:	e8 6a e1 ff ff       	call   80103cb0 <myproc>
80105b46:	8b 40 24             	mov    0x24(%eax),%eax
80105b49:	85 c0                	test   %eax,%eax
80105b4b:	74 d3                	je     80105b20 <sys_sleep+0x40>
      release(&tickslock);
80105b4d:	83 ec 0c             	sub    $0xc,%esp
80105b50:	68 c0 4c 11 80       	push   $0x80114cc0
80105b55:	e8 16 ee ff ff       	call   80104970 <release>
  }
  release(&tickslock);
  return 0;
}
80105b5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105b5d:	83 c4 10             	add    $0x10,%esp
80105b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b65:	c9                   	leave  
80105b66:	c3                   	ret    
80105b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b6e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105b70:	83 ec 0c             	sub    $0xc,%esp
80105b73:	68 c0 4c 11 80       	push   $0x80114cc0
80105b78:	e8 f3 ed ff ff       	call   80104970 <release>
  return 0;
80105b7d:	83 c4 10             	add    $0x10,%esp
80105b80:	31 c0                	xor    %eax,%eax
}
80105b82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b85:	c9                   	leave  
80105b86:	c3                   	ret    
    return -1;
80105b87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b8c:	eb f4                	jmp    80105b82 <sys_sleep+0xa2>
80105b8e:	66 90                	xchg   %ax,%ax

80105b90 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b90:	f3 0f 1e fb          	endbr32 
80105b94:	55                   	push   %ebp
80105b95:	89 e5                	mov    %esp,%ebp
80105b97:	53                   	push   %ebx
80105b98:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b9b:	68 c0 4c 11 80       	push   $0x80114cc0
80105ba0:	e8 0b ed ff ff       	call   801048b0 <acquire>
  xticks = ticks;
80105ba5:	8b 1d 00 55 11 80    	mov    0x80115500,%ebx
  release(&tickslock);
80105bab:	c7 04 24 c0 4c 11 80 	movl   $0x80114cc0,(%esp)
80105bb2:	e8 b9 ed ff ff       	call   80104970 <release>
  return xticks;
}
80105bb7:	89 d8                	mov    %ebx,%eax
80105bb9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bbc:	c9                   	leave  
80105bbd:	c3                   	ret    

80105bbe <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105bbe:	1e                   	push   %ds
  pushl %es
80105bbf:	06                   	push   %es
  pushl %fs
80105bc0:	0f a0                	push   %fs
  pushl %gs
80105bc2:	0f a8                	push   %gs
  pushal
80105bc4:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105bc5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105bc9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105bcb:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105bcd:	54                   	push   %esp
  call trap
80105bce:	e8 cd 00 00 00       	call   80105ca0 <trap>
  addl $4, %esp
80105bd3:	83 c4 04             	add    $0x4,%esp

80105bd6 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105bd6:	61                   	popa   
  popl %gs
80105bd7:	0f a9                	pop    %gs
  popl %fs
80105bd9:	0f a1                	pop    %fs
  popl %es
80105bdb:	07                   	pop    %es
  popl %ds
80105bdc:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105bdd:	83 c4 08             	add    $0x8,%esp
  iret
80105be0:	cf                   	iret   
80105be1:	66 90                	xchg   %ax,%ax
80105be3:	66 90                	xchg   %ax,%ax
80105be5:	66 90                	xchg   %ax,%ax
80105be7:	66 90                	xchg   %ax,%ax
80105be9:	66 90                	xchg   %ax,%ax
80105beb:	66 90                	xchg   %ax,%ax
80105bed:	66 90                	xchg   %ax,%ax
80105bef:	90                   	nop

80105bf0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105bf0:	f3 0f 1e fb          	endbr32 
80105bf4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105bf5:	31 c0                	xor    %eax,%eax
{
80105bf7:	89 e5                	mov    %esp,%ebp
80105bf9:	83 ec 08             	sub    $0x8,%esp
80105bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c00:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105c07:	c7 04 c5 02 4d 11 80 	movl   $0x8e000008,-0x7feeb2fe(,%eax,8)
80105c0e:	08 00 00 8e 
80105c12:	66 89 14 c5 00 4d 11 	mov    %dx,-0x7feeb300(,%eax,8)
80105c19:	80 
80105c1a:	c1 ea 10             	shr    $0x10,%edx
80105c1d:	66 89 14 c5 06 4d 11 	mov    %dx,-0x7feeb2fa(,%eax,8)
80105c24:	80 
  for(i = 0; i < 256; i++)
80105c25:	83 c0 01             	add    $0x1,%eax
80105c28:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c2d:	75 d1                	jne    80105c00 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105c2f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c32:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105c37:	c7 05 02 4f 11 80 08 	movl   $0xef000008,0x80114f02
80105c3e:	00 00 ef 
  initlock(&tickslock, "time");
80105c41:	68 b9 7b 10 80       	push   $0x80107bb9
80105c46:	68 c0 4c 11 80       	push   $0x80114cc0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c4b:	66 a3 00 4f 11 80    	mov    %ax,0x80114f00
80105c51:	c1 e8 10             	shr    $0x10,%eax
80105c54:	66 a3 06 4f 11 80    	mov    %ax,0x80114f06
  initlock(&tickslock, "time");
80105c5a:	e8 d1 ea ff ff       	call   80104730 <initlock>
}
80105c5f:	83 c4 10             	add    $0x10,%esp
80105c62:	c9                   	leave  
80105c63:	c3                   	ret    
80105c64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c6f:	90                   	nop

80105c70 <idtinit>:

void
idtinit(void)
{
80105c70:	f3 0f 1e fb          	endbr32 
80105c74:	55                   	push   %ebp
  pd[0] = size-1;
80105c75:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c7a:	89 e5                	mov    %esp,%ebp
80105c7c:	83 ec 10             	sub    $0x10,%esp
80105c7f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c83:	b8 00 4d 11 80       	mov    $0x80114d00,%eax
80105c88:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c8c:	c1 e8 10             	shr    $0x10,%eax
80105c8f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c93:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c96:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c99:	c9                   	leave  
80105c9a:	c3                   	ret    
80105c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c9f:	90                   	nop

80105ca0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ca0:	f3 0f 1e fb          	endbr32 
80105ca4:	55                   	push   %ebp
80105ca5:	89 e5                	mov    %esp,%ebp
80105ca7:	57                   	push   %edi
80105ca8:	56                   	push   %esi
80105ca9:	53                   	push   %ebx
80105caa:	83 ec 1c             	sub    $0x1c,%esp
80105cad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105cb0:	8b 43 30             	mov    0x30(%ebx),%eax
80105cb3:	83 f8 40             	cmp    $0x40,%eax
80105cb6:	0f 84 bc 01 00 00    	je     80105e78 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105cbc:	83 e8 20             	sub    $0x20,%eax
80105cbf:	83 f8 1f             	cmp    $0x1f,%eax
80105cc2:	77 08                	ja     80105ccc <trap+0x2c>
80105cc4:	3e ff 24 85 60 7c 10 	notrack jmp *-0x7fef83a0(,%eax,4)
80105ccb:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105ccc:	e8 df df ff ff       	call   80103cb0 <myproc>
80105cd1:	8b 7b 38             	mov    0x38(%ebx),%edi
80105cd4:	85 c0                	test   %eax,%eax
80105cd6:	0f 84 eb 01 00 00    	je     80105ec7 <trap+0x227>
80105cdc:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105ce0:	0f 84 e1 01 00 00    	je     80105ec7 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105ce6:	0f 20 d1             	mov    %cr2,%ecx
80105ce9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cec:	e8 9f df ff ff       	call   80103c90 <cpuid>
80105cf1:	8b 73 30             	mov    0x30(%ebx),%esi
80105cf4:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105cf7:	8b 43 34             	mov    0x34(%ebx),%eax
80105cfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105cfd:	e8 ae df ff ff       	call   80103cb0 <myproc>
80105d02:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d05:	e8 a6 df ff ff       	call   80103cb0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d0a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d10:	51                   	push   %ecx
80105d11:	57                   	push   %edi
80105d12:	52                   	push   %edx
80105d13:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d16:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d17:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105d1a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d1d:	56                   	push   %esi
80105d1e:	ff 70 10             	pushl  0x10(%eax)
80105d21:	68 1c 7c 10 80       	push   $0x80107c1c
80105d26:	e8 65 a9 ff ff       	call   80100690 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105d2b:	83 c4 20             	add    $0x20,%esp
80105d2e:	e8 7d df ff ff       	call   80103cb0 <myproc>
80105d33:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d3a:	e8 71 df ff ff       	call   80103cb0 <myproc>
80105d3f:	85 c0                	test   %eax,%eax
80105d41:	74 1d                	je     80105d60 <trap+0xc0>
80105d43:	e8 68 df ff ff       	call   80103cb0 <myproc>
80105d48:	8b 50 24             	mov    0x24(%eax),%edx
80105d4b:	85 d2                	test   %edx,%edx
80105d4d:	74 11                	je     80105d60 <trap+0xc0>
80105d4f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d53:	83 e0 03             	and    $0x3,%eax
80105d56:	66 83 f8 03          	cmp    $0x3,%ax
80105d5a:	0f 84 50 01 00 00    	je     80105eb0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d60:	e8 4b df ff ff       	call   80103cb0 <myproc>
80105d65:	85 c0                	test   %eax,%eax
80105d67:	74 0f                	je     80105d78 <trap+0xd8>
80105d69:	e8 42 df ff ff       	call   80103cb0 <myproc>
80105d6e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d72:	0f 84 e8 00 00 00    	je     80105e60 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d78:	e8 33 df ff ff       	call   80103cb0 <myproc>
80105d7d:	85 c0                	test   %eax,%eax
80105d7f:	74 1d                	je     80105d9e <trap+0xfe>
80105d81:	e8 2a df ff ff       	call   80103cb0 <myproc>
80105d86:	8b 40 24             	mov    0x24(%eax),%eax
80105d89:	85 c0                	test   %eax,%eax
80105d8b:	74 11                	je     80105d9e <trap+0xfe>
80105d8d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d91:	83 e0 03             	and    $0x3,%eax
80105d94:	66 83 f8 03          	cmp    $0x3,%ax
80105d98:	0f 84 03 01 00 00    	je     80105ea1 <trap+0x201>
    exit();
}
80105d9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105da1:	5b                   	pop    %ebx
80105da2:	5e                   	pop    %esi
80105da3:	5f                   	pop    %edi
80105da4:	5d                   	pop    %ebp
80105da5:	c3                   	ret    
    ideintr();
80105da6:	e8 85 c7 ff ff       	call   80102530 <ideintr>
    lapiceoi();
80105dab:	e8 60 ce ff ff       	call   80102c10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105db0:	e8 fb de ff ff       	call   80103cb0 <myproc>
80105db5:	85 c0                	test   %eax,%eax
80105db7:	75 8a                	jne    80105d43 <trap+0xa3>
80105db9:	eb a5                	jmp    80105d60 <trap+0xc0>
    if(cpuid() == 0){
80105dbb:	e8 d0 de ff ff       	call   80103c90 <cpuid>
80105dc0:	85 c0                	test   %eax,%eax
80105dc2:	75 e7                	jne    80105dab <trap+0x10b>
      acquire(&tickslock);
80105dc4:	83 ec 0c             	sub    $0xc,%esp
80105dc7:	68 c0 4c 11 80       	push   $0x80114cc0
80105dcc:	e8 df ea ff ff       	call   801048b0 <acquire>
      wakeup(&ticks);
80105dd1:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
      ticks++;
80105dd8:	83 05 00 55 11 80 01 	addl   $0x1,0x80115500
      wakeup(&ticks);
80105ddf:	e8 4c e6 ff ff       	call   80104430 <wakeup>
      release(&tickslock);
80105de4:	c7 04 24 c0 4c 11 80 	movl   $0x80114cc0,(%esp)
80105deb:	e8 80 eb ff ff       	call   80104970 <release>
80105df0:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105df3:	eb b6                	jmp    80105dab <trap+0x10b>
    kbdintr();
80105df5:	e8 d6 cc ff ff       	call   80102ad0 <kbdintr>
    lapiceoi();
80105dfa:	e8 11 ce ff ff       	call   80102c10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dff:	e8 ac de ff ff       	call   80103cb0 <myproc>
80105e04:	85 c0                	test   %eax,%eax
80105e06:	0f 85 37 ff ff ff    	jne    80105d43 <trap+0xa3>
80105e0c:	e9 4f ff ff ff       	jmp    80105d60 <trap+0xc0>
    uartintr();
80105e11:	e8 4a 02 00 00       	call   80106060 <uartintr>
    lapiceoi();
80105e16:	e8 f5 cd ff ff       	call   80102c10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e1b:	e8 90 de ff ff       	call   80103cb0 <myproc>
80105e20:	85 c0                	test   %eax,%eax
80105e22:	0f 85 1b ff ff ff    	jne    80105d43 <trap+0xa3>
80105e28:	e9 33 ff ff ff       	jmp    80105d60 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e2d:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e30:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105e34:	e8 57 de ff ff       	call   80103c90 <cpuid>
80105e39:	57                   	push   %edi
80105e3a:	56                   	push   %esi
80105e3b:	50                   	push   %eax
80105e3c:	68 c4 7b 10 80       	push   $0x80107bc4
80105e41:	e8 4a a8 ff ff       	call   80100690 <cprintf>
    lapiceoi();
80105e46:	e8 c5 cd ff ff       	call   80102c10 <lapiceoi>
    break;
80105e4b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e4e:	e8 5d de ff ff       	call   80103cb0 <myproc>
80105e53:	85 c0                	test   %eax,%eax
80105e55:	0f 85 e8 fe ff ff    	jne    80105d43 <trap+0xa3>
80105e5b:	e9 00 ff ff ff       	jmp    80105d60 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80105e60:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105e64:	0f 85 0e ff ff ff    	jne    80105d78 <trap+0xd8>
    yield();
80105e6a:	e8 b1 e3 ff ff       	call   80104220 <yield>
80105e6f:	e9 04 ff ff ff       	jmp    80105d78 <trap+0xd8>
80105e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105e78:	e8 33 de ff ff       	call   80103cb0 <myproc>
80105e7d:	8b 70 24             	mov    0x24(%eax),%esi
80105e80:	85 f6                	test   %esi,%esi
80105e82:	75 3c                	jne    80105ec0 <trap+0x220>
    myproc()->tf = tf;
80105e84:	e8 27 de ff ff       	call   80103cb0 <myproc>
80105e89:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105e8c:	e8 ff ee ff ff       	call   80104d90 <syscall>
    if(myproc()->killed)
80105e91:	e8 1a de ff ff       	call   80103cb0 <myproc>
80105e96:	8b 48 24             	mov    0x24(%eax),%ecx
80105e99:	85 c9                	test   %ecx,%ecx
80105e9b:	0f 84 fd fe ff ff    	je     80105d9e <trap+0xfe>
}
80105ea1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea4:	5b                   	pop    %ebx
80105ea5:	5e                   	pop    %esi
80105ea6:	5f                   	pop    %edi
80105ea7:	5d                   	pop    %ebp
      exit();
80105ea8:	e9 33 e2 ff ff       	jmp    801040e0 <exit>
80105ead:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105eb0:	e8 2b e2 ff ff       	call   801040e0 <exit>
80105eb5:	e9 a6 fe ff ff       	jmp    80105d60 <trap+0xc0>
80105eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105ec0:	e8 1b e2 ff ff       	call   801040e0 <exit>
80105ec5:	eb bd                	jmp    80105e84 <trap+0x1e4>
80105ec7:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105eca:	e8 c1 dd ff ff       	call   80103c90 <cpuid>
80105ecf:	83 ec 0c             	sub    $0xc,%esp
80105ed2:	56                   	push   %esi
80105ed3:	57                   	push   %edi
80105ed4:	50                   	push   %eax
80105ed5:	ff 73 30             	pushl  0x30(%ebx)
80105ed8:	68 e8 7b 10 80       	push   $0x80107be8
80105edd:	e8 ae a7 ff ff       	call   80100690 <cprintf>
      panic("trap");
80105ee2:	83 c4 14             	add    $0x14,%esp
80105ee5:	68 be 7b 10 80       	push   $0x80107bbe
80105eea:	e8 21 a7 ff ff       	call   80100610 <panic>
80105eef:	90                   	nop

80105ef0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105ef0:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105ef4:	a1 dc a5 10 80       	mov    0x8010a5dc,%eax
80105ef9:	85 c0                	test   %eax,%eax
80105efb:	74 1b                	je     80105f18 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105efd:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f02:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f03:	a8 01                	test   $0x1,%al
80105f05:	74 11                	je     80105f18 <uartgetc+0x28>
80105f07:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f0c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f0d:	0f b6 c0             	movzbl %al,%eax
80105f10:	c3                   	ret    
80105f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f1d:	c3                   	ret    
80105f1e:	66 90                	xchg   %ax,%ax

80105f20 <uartputc.part.0>:
uartputc(int c)
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	57                   	push   %edi
80105f24:	89 c7                	mov    %eax,%edi
80105f26:	56                   	push   %esi
80105f27:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f2c:	53                   	push   %ebx
80105f2d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f32:	83 ec 0c             	sub    $0xc,%esp
80105f35:	eb 1b                	jmp    80105f52 <uartputc.part.0+0x32>
80105f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105f40:	83 ec 0c             	sub    $0xc,%esp
80105f43:	6a 0a                	push   $0xa
80105f45:	e8 e6 cc ff ff       	call   80102c30 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f4a:	83 c4 10             	add    $0x10,%esp
80105f4d:	83 eb 01             	sub    $0x1,%ebx
80105f50:	74 07                	je     80105f59 <uartputc.part.0+0x39>
80105f52:	89 f2                	mov    %esi,%edx
80105f54:	ec                   	in     (%dx),%al
80105f55:	a8 20                	test   $0x20,%al
80105f57:	74 e7                	je     80105f40 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f59:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f5e:	89 f8                	mov    %edi,%eax
80105f60:	ee                   	out    %al,(%dx)
}
80105f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f64:	5b                   	pop    %ebx
80105f65:	5e                   	pop    %esi
80105f66:	5f                   	pop    %edi
80105f67:	5d                   	pop    %ebp
80105f68:	c3                   	ret    
80105f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f70 <uartinit>:
{
80105f70:	f3 0f 1e fb          	endbr32 
80105f74:	55                   	push   %ebp
80105f75:	31 c9                	xor    %ecx,%ecx
80105f77:	89 c8                	mov    %ecx,%eax
80105f79:	89 e5                	mov    %esp,%ebp
80105f7b:	57                   	push   %edi
80105f7c:	56                   	push   %esi
80105f7d:	53                   	push   %ebx
80105f7e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105f83:	89 da                	mov    %ebx,%edx
80105f85:	83 ec 0c             	sub    $0xc,%esp
80105f88:	ee                   	out    %al,(%dx)
80105f89:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f8e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f93:	89 fa                	mov    %edi,%edx
80105f95:	ee                   	out    %al,(%dx)
80105f96:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f9b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fa0:	ee                   	out    %al,(%dx)
80105fa1:	be f9 03 00 00       	mov    $0x3f9,%esi
80105fa6:	89 c8                	mov    %ecx,%eax
80105fa8:	89 f2                	mov    %esi,%edx
80105faa:	ee                   	out    %al,(%dx)
80105fab:	b8 03 00 00 00       	mov    $0x3,%eax
80105fb0:	89 fa                	mov    %edi,%edx
80105fb2:	ee                   	out    %al,(%dx)
80105fb3:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105fb8:	89 c8                	mov    %ecx,%eax
80105fba:	ee                   	out    %al,(%dx)
80105fbb:	b8 01 00 00 00       	mov    $0x1,%eax
80105fc0:	89 f2                	mov    %esi,%edx
80105fc2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fc3:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fc8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105fc9:	3c ff                	cmp    $0xff,%al
80105fcb:	74 52                	je     8010601f <uartinit+0xaf>
  uart = 1;
80105fcd:	c7 05 dc a5 10 80 01 	movl   $0x1,0x8010a5dc
80105fd4:	00 00 00 
80105fd7:	89 da                	mov    %ebx,%edx
80105fd9:	ec                   	in     (%dx),%al
80105fda:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fdf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105fe0:	83 ec 08             	sub    $0x8,%esp
80105fe3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105fe8:	bb e0 7c 10 80       	mov    $0x80107ce0,%ebx
  ioapicenable(IRQ_COM1, 0);
80105fed:	6a 00                	push   $0x0
80105fef:	6a 04                	push   $0x4
80105ff1:	e8 8a c7 ff ff       	call   80102780 <ioapicenable>
80105ff6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105ff9:	b8 78 00 00 00       	mov    $0x78,%eax
80105ffe:	eb 04                	jmp    80106004 <uartinit+0x94>
80106000:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106004:	8b 15 dc a5 10 80    	mov    0x8010a5dc,%edx
8010600a:	85 d2                	test   %edx,%edx
8010600c:	74 08                	je     80106016 <uartinit+0xa6>
    uartputc(*p);
8010600e:	0f be c0             	movsbl %al,%eax
80106011:	e8 0a ff ff ff       	call   80105f20 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106016:	89 f0                	mov    %esi,%eax
80106018:	83 c3 01             	add    $0x1,%ebx
8010601b:	84 c0                	test   %al,%al
8010601d:	75 e1                	jne    80106000 <uartinit+0x90>
}
8010601f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106022:	5b                   	pop    %ebx
80106023:	5e                   	pop    %esi
80106024:	5f                   	pop    %edi
80106025:	5d                   	pop    %ebp
80106026:	c3                   	ret    
80106027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010602e:	66 90                	xchg   %ax,%ax

80106030 <uartputc>:
{
80106030:	f3 0f 1e fb          	endbr32 
80106034:	55                   	push   %ebp
  if(!uart)
80106035:	8b 15 dc a5 10 80    	mov    0x8010a5dc,%edx
{
8010603b:	89 e5                	mov    %esp,%ebp
8010603d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106040:	85 d2                	test   %edx,%edx
80106042:	74 0c                	je     80106050 <uartputc+0x20>
}
80106044:	5d                   	pop    %ebp
80106045:	e9 d6 fe ff ff       	jmp    80105f20 <uartputc.part.0>
8010604a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106050:	5d                   	pop    %ebp
80106051:	c3                   	ret    
80106052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106060 <uartintr>:

void
uartintr(void)
{
80106060:	f3 0f 1e fb          	endbr32 
80106064:	55                   	push   %ebp
80106065:	89 e5                	mov    %esp,%ebp
80106067:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010606a:	68 f0 5e 10 80       	push   $0x80105ef0
8010606f:	e8 ac a9 ff ff       	call   80100a20 <consoleintr>
}
80106074:	83 c4 10             	add    $0x10,%esp
80106077:	c9                   	leave  
80106078:	c3                   	ret    

80106079 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $0
8010607b:	6a 00                	push   $0x0
  jmp alltraps
8010607d:	e9 3c fb ff ff       	jmp    80105bbe <alltraps>

80106082 <vector1>:
.globl vector1
vector1:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $1
80106084:	6a 01                	push   $0x1
  jmp alltraps
80106086:	e9 33 fb ff ff       	jmp    80105bbe <alltraps>

8010608b <vector2>:
.globl vector2
vector2:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $2
8010608d:	6a 02                	push   $0x2
  jmp alltraps
8010608f:	e9 2a fb ff ff       	jmp    80105bbe <alltraps>

80106094 <vector3>:
.globl vector3
vector3:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $3
80106096:	6a 03                	push   $0x3
  jmp alltraps
80106098:	e9 21 fb ff ff       	jmp    80105bbe <alltraps>

8010609d <vector4>:
.globl vector4
vector4:
  pushl $0
8010609d:	6a 00                	push   $0x0
  pushl $4
8010609f:	6a 04                	push   $0x4
  jmp alltraps
801060a1:	e9 18 fb ff ff       	jmp    80105bbe <alltraps>

801060a6 <vector5>:
.globl vector5
vector5:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $5
801060a8:	6a 05                	push   $0x5
  jmp alltraps
801060aa:	e9 0f fb ff ff       	jmp    80105bbe <alltraps>

801060af <vector6>:
.globl vector6
vector6:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $6
801060b1:	6a 06                	push   $0x6
  jmp alltraps
801060b3:	e9 06 fb ff ff       	jmp    80105bbe <alltraps>

801060b8 <vector7>:
.globl vector7
vector7:
  pushl $0
801060b8:	6a 00                	push   $0x0
  pushl $7
801060ba:	6a 07                	push   $0x7
  jmp alltraps
801060bc:	e9 fd fa ff ff       	jmp    80105bbe <alltraps>

801060c1 <vector8>:
.globl vector8
vector8:
  pushl $8
801060c1:	6a 08                	push   $0x8
  jmp alltraps
801060c3:	e9 f6 fa ff ff       	jmp    80105bbe <alltraps>

801060c8 <vector9>:
.globl vector9
vector9:
  pushl $0
801060c8:	6a 00                	push   $0x0
  pushl $9
801060ca:	6a 09                	push   $0x9
  jmp alltraps
801060cc:	e9 ed fa ff ff       	jmp    80105bbe <alltraps>

801060d1 <vector10>:
.globl vector10
vector10:
  pushl $10
801060d1:	6a 0a                	push   $0xa
  jmp alltraps
801060d3:	e9 e6 fa ff ff       	jmp    80105bbe <alltraps>

801060d8 <vector11>:
.globl vector11
vector11:
  pushl $11
801060d8:	6a 0b                	push   $0xb
  jmp alltraps
801060da:	e9 df fa ff ff       	jmp    80105bbe <alltraps>

801060df <vector12>:
.globl vector12
vector12:
  pushl $12
801060df:	6a 0c                	push   $0xc
  jmp alltraps
801060e1:	e9 d8 fa ff ff       	jmp    80105bbe <alltraps>

801060e6 <vector13>:
.globl vector13
vector13:
  pushl $13
801060e6:	6a 0d                	push   $0xd
  jmp alltraps
801060e8:	e9 d1 fa ff ff       	jmp    80105bbe <alltraps>

801060ed <vector14>:
.globl vector14
vector14:
  pushl $14
801060ed:	6a 0e                	push   $0xe
  jmp alltraps
801060ef:	e9 ca fa ff ff       	jmp    80105bbe <alltraps>

801060f4 <vector15>:
.globl vector15
vector15:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $15
801060f6:	6a 0f                	push   $0xf
  jmp alltraps
801060f8:	e9 c1 fa ff ff       	jmp    80105bbe <alltraps>

801060fd <vector16>:
.globl vector16
vector16:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $16
801060ff:	6a 10                	push   $0x10
  jmp alltraps
80106101:	e9 b8 fa ff ff       	jmp    80105bbe <alltraps>

80106106 <vector17>:
.globl vector17
vector17:
  pushl $17
80106106:	6a 11                	push   $0x11
  jmp alltraps
80106108:	e9 b1 fa ff ff       	jmp    80105bbe <alltraps>

8010610d <vector18>:
.globl vector18
vector18:
  pushl $0
8010610d:	6a 00                	push   $0x0
  pushl $18
8010610f:	6a 12                	push   $0x12
  jmp alltraps
80106111:	e9 a8 fa ff ff       	jmp    80105bbe <alltraps>

80106116 <vector19>:
.globl vector19
vector19:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $19
80106118:	6a 13                	push   $0x13
  jmp alltraps
8010611a:	e9 9f fa ff ff       	jmp    80105bbe <alltraps>

8010611f <vector20>:
.globl vector20
vector20:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $20
80106121:	6a 14                	push   $0x14
  jmp alltraps
80106123:	e9 96 fa ff ff       	jmp    80105bbe <alltraps>

80106128 <vector21>:
.globl vector21
vector21:
  pushl $0
80106128:	6a 00                	push   $0x0
  pushl $21
8010612a:	6a 15                	push   $0x15
  jmp alltraps
8010612c:	e9 8d fa ff ff       	jmp    80105bbe <alltraps>

80106131 <vector22>:
.globl vector22
vector22:
  pushl $0
80106131:	6a 00                	push   $0x0
  pushl $22
80106133:	6a 16                	push   $0x16
  jmp alltraps
80106135:	e9 84 fa ff ff       	jmp    80105bbe <alltraps>

8010613a <vector23>:
.globl vector23
vector23:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $23
8010613c:	6a 17                	push   $0x17
  jmp alltraps
8010613e:	e9 7b fa ff ff       	jmp    80105bbe <alltraps>

80106143 <vector24>:
.globl vector24
vector24:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $24
80106145:	6a 18                	push   $0x18
  jmp alltraps
80106147:	e9 72 fa ff ff       	jmp    80105bbe <alltraps>

8010614c <vector25>:
.globl vector25
vector25:
  pushl $0
8010614c:	6a 00                	push   $0x0
  pushl $25
8010614e:	6a 19                	push   $0x19
  jmp alltraps
80106150:	e9 69 fa ff ff       	jmp    80105bbe <alltraps>

80106155 <vector26>:
.globl vector26
vector26:
  pushl $0
80106155:	6a 00                	push   $0x0
  pushl $26
80106157:	6a 1a                	push   $0x1a
  jmp alltraps
80106159:	e9 60 fa ff ff       	jmp    80105bbe <alltraps>

8010615e <vector27>:
.globl vector27
vector27:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $27
80106160:	6a 1b                	push   $0x1b
  jmp alltraps
80106162:	e9 57 fa ff ff       	jmp    80105bbe <alltraps>

80106167 <vector28>:
.globl vector28
vector28:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $28
80106169:	6a 1c                	push   $0x1c
  jmp alltraps
8010616b:	e9 4e fa ff ff       	jmp    80105bbe <alltraps>

80106170 <vector29>:
.globl vector29
vector29:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $29
80106172:	6a 1d                	push   $0x1d
  jmp alltraps
80106174:	e9 45 fa ff ff       	jmp    80105bbe <alltraps>

80106179 <vector30>:
.globl vector30
vector30:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $30
8010617b:	6a 1e                	push   $0x1e
  jmp alltraps
8010617d:	e9 3c fa ff ff       	jmp    80105bbe <alltraps>

80106182 <vector31>:
.globl vector31
vector31:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $31
80106184:	6a 1f                	push   $0x1f
  jmp alltraps
80106186:	e9 33 fa ff ff       	jmp    80105bbe <alltraps>

8010618b <vector32>:
.globl vector32
vector32:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $32
8010618d:	6a 20                	push   $0x20
  jmp alltraps
8010618f:	e9 2a fa ff ff       	jmp    80105bbe <alltraps>

80106194 <vector33>:
.globl vector33
vector33:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $33
80106196:	6a 21                	push   $0x21
  jmp alltraps
80106198:	e9 21 fa ff ff       	jmp    80105bbe <alltraps>

8010619d <vector34>:
.globl vector34
vector34:
  pushl $0
8010619d:	6a 00                	push   $0x0
  pushl $34
8010619f:	6a 22                	push   $0x22
  jmp alltraps
801061a1:	e9 18 fa ff ff       	jmp    80105bbe <alltraps>

801061a6 <vector35>:
.globl vector35
vector35:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $35
801061a8:	6a 23                	push   $0x23
  jmp alltraps
801061aa:	e9 0f fa ff ff       	jmp    80105bbe <alltraps>

801061af <vector36>:
.globl vector36
vector36:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $36
801061b1:	6a 24                	push   $0x24
  jmp alltraps
801061b3:	e9 06 fa ff ff       	jmp    80105bbe <alltraps>

801061b8 <vector37>:
.globl vector37
vector37:
  pushl $0
801061b8:	6a 00                	push   $0x0
  pushl $37
801061ba:	6a 25                	push   $0x25
  jmp alltraps
801061bc:	e9 fd f9 ff ff       	jmp    80105bbe <alltraps>

801061c1 <vector38>:
.globl vector38
vector38:
  pushl $0
801061c1:	6a 00                	push   $0x0
  pushl $38
801061c3:	6a 26                	push   $0x26
  jmp alltraps
801061c5:	e9 f4 f9 ff ff       	jmp    80105bbe <alltraps>

801061ca <vector39>:
.globl vector39
vector39:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $39
801061cc:	6a 27                	push   $0x27
  jmp alltraps
801061ce:	e9 eb f9 ff ff       	jmp    80105bbe <alltraps>

801061d3 <vector40>:
.globl vector40
vector40:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $40
801061d5:	6a 28                	push   $0x28
  jmp alltraps
801061d7:	e9 e2 f9 ff ff       	jmp    80105bbe <alltraps>

801061dc <vector41>:
.globl vector41
vector41:
  pushl $0
801061dc:	6a 00                	push   $0x0
  pushl $41
801061de:	6a 29                	push   $0x29
  jmp alltraps
801061e0:	e9 d9 f9 ff ff       	jmp    80105bbe <alltraps>

801061e5 <vector42>:
.globl vector42
vector42:
  pushl $0
801061e5:	6a 00                	push   $0x0
  pushl $42
801061e7:	6a 2a                	push   $0x2a
  jmp alltraps
801061e9:	e9 d0 f9 ff ff       	jmp    80105bbe <alltraps>

801061ee <vector43>:
.globl vector43
vector43:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $43
801061f0:	6a 2b                	push   $0x2b
  jmp alltraps
801061f2:	e9 c7 f9 ff ff       	jmp    80105bbe <alltraps>

801061f7 <vector44>:
.globl vector44
vector44:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $44
801061f9:	6a 2c                	push   $0x2c
  jmp alltraps
801061fb:	e9 be f9 ff ff       	jmp    80105bbe <alltraps>

80106200 <vector45>:
.globl vector45
vector45:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $45
80106202:	6a 2d                	push   $0x2d
  jmp alltraps
80106204:	e9 b5 f9 ff ff       	jmp    80105bbe <alltraps>

80106209 <vector46>:
.globl vector46
vector46:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $46
8010620b:	6a 2e                	push   $0x2e
  jmp alltraps
8010620d:	e9 ac f9 ff ff       	jmp    80105bbe <alltraps>

80106212 <vector47>:
.globl vector47
vector47:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $47
80106214:	6a 2f                	push   $0x2f
  jmp alltraps
80106216:	e9 a3 f9 ff ff       	jmp    80105bbe <alltraps>

8010621b <vector48>:
.globl vector48
vector48:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $48
8010621d:	6a 30                	push   $0x30
  jmp alltraps
8010621f:	e9 9a f9 ff ff       	jmp    80105bbe <alltraps>

80106224 <vector49>:
.globl vector49
vector49:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $49
80106226:	6a 31                	push   $0x31
  jmp alltraps
80106228:	e9 91 f9 ff ff       	jmp    80105bbe <alltraps>

8010622d <vector50>:
.globl vector50
vector50:
  pushl $0
8010622d:	6a 00                	push   $0x0
  pushl $50
8010622f:	6a 32                	push   $0x32
  jmp alltraps
80106231:	e9 88 f9 ff ff       	jmp    80105bbe <alltraps>

80106236 <vector51>:
.globl vector51
vector51:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $51
80106238:	6a 33                	push   $0x33
  jmp alltraps
8010623a:	e9 7f f9 ff ff       	jmp    80105bbe <alltraps>

8010623f <vector52>:
.globl vector52
vector52:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $52
80106241:	6a 34                	push   $0x34
  jmp alltraps
80106243:	e9 76 f9 ff ff       	jmp    80105bbe <alltraps>

80106248 <vector53>:
.globl vector53
vector53:
  pushl $0
80106248:	6a 00                	push   $0x0
  pushl $53
8010624a:	6a 35                	push   $0x35
  jmp alltraps
8010624c:	e9 6d f9 ff ff       	jmp    80105bbe <alltraps>

80106251 <vector54>:
.globl vector54
vector54:
  pushl $0
80106251:	6a 00                	push   $0x0
  pushl $54
80106253:	6a 36                	push   $0x36
  jmp alltraps
80106255:	e9 64 f9 ff ff       	jmp    80105bbe <alltraps>

8010625a <vector55>:
.globl vector55
vector55:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $55
8010625c:	6a 37                	push   $0x37
  jmp alltraps
8010625e:	e9 5b f9 ff ff       	jmp    80105bbe <alltraps>

80106263 <vector56>:
.globl vector56
vector56:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $56
80106265:	6a 38                	push   $0x38
  jmp alltraps
80106267:	e9 52 f9 ff ff       	jmp    80105bbe <alltraps>

8010626c <vector57>:
.globl vector57
vector57:
  pushl $0
8010626c:	6a 00                	push   $0x0
  pushl $57
8010626e:	6a 39                	push   $0x39
  jmp alltraps
80106270:	e9 49 f9 ff ff       	jmp    80105bbe <alltraps>

80106275 <vector58>:
.globl vector58
vector58:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $58
80106277:	6a 3a                	push   $0x3a
  jmp alltraps
80106279:	e9 40 f9 ff ff       	jmp    80105bbe <alltraps>

8010627e <vector59>:
.globl vector59
vector59:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $59
80106280:	6a 3b                	push   $0x3b
  jmp alltraps
80106282:	e9 37 f9 ff ff       	jmp    80105bbe <alltraps>

80106287 <vector60>:
.globl vector60
vector60:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $60
80106289:	6a 3c                	push   $0x3c
  jmp alltraps
8010628b:	e9 2e f9 ff ff       	jmp    80105bbe <alltraps>

80106290 <vector61>:
.globl vector61
vector61:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $61
80106292:	6a 3d                	push   $0x3d
  jmp alltraps
80106294:	e9 25 f9 ff ff       	jmp    80105bbe <alltraps>

80106299 <vector62>:
.globl vector62
vector62:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $62
8010629b:	6a 3e                	push   $0x3e
  jmp alltraps
8010629d:	e9 1c f9 ff ff       	jmp    80105bbe <alltraps>

801062a2 <vector63>:
.globl vector63
vector63:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $63
801062a4:	6a 3f                	push   $0x3f
  jmp alltraps
801062a6:	e9 13 f9 ff ff       	jmp    80105bbe <alltraps>

801062ab <vector64>:
.globl vector64
vector64:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $64
801062ad:	6a 40                	push   $0x40
  jmp alltraps
801062af:	e9 0a f9 ff ff       	jmp    80105bbe <alltraps>

801062b4 <vector65>:
.globl vector65
vector65:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $65
801062b6:	6a 41                	push   $0x41
  jmp alltraps
801062b8:	e9 01 f9 ff ff       	jmp    80105bbe <alltraps>

801062bd <vector66>:
.globl vector66
vector66:
  pushl $0
801062bd:	6a 00                	push   $0x0
  pushl $66
801062bf:	6a 42                	push   $0x42
  jmp alltraps
801062c1:	e9 f8 f8 ff ff       	jmp    80105bbe <alltraps>

801062c6 <vector67>:
.globl vector67
vector67:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $67
801062c8:	6a 43                	push   $0x43
  jmp alltraps
801062ca:	e9 ef f8 ff ff       	jmp    80105bbe <alltraps>

801062cf <vector68>:
.globl vector68
vector68:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $68
801062d1:	6a 44                	push   $0x44
  jmp alltraps
801062d3:	e9 e6 f8 ff ff       	jmp    80105bbe <alltraps>

801062d8 <vector69>:
.globl vector69
vector69:
  pushl $0
801062d8:	6a 00                	push   $0x0
  pushl $69
801062da:	6a 45                	push   $0x45
  jmp alltraps
801062dc:	e9 dd f8 ff ff       	jmp    80105bbe <alltraps>

801062e1 <vector70>:
.globl vector70
vector70:
  pushl $0
801062e1:	6a 00                	push   $0x0
  pushl $70
801062e3:	6a 46                	push   $0x46
  jmp alltraps
801062e5:	e9 d4 f8 ff ff       	jmp    80105bbe <alltraps>

801062ea <vector71>:
.globl vector71
vector71:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $71
801062ec:	6a 47                	push   $0x47
  jmp alltraps
801062ee:	e9 cb f8 ff ff       	jmp    80105bbe <alltraps>

801062f3 <vector72>:
.globl vector72
vector72:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $72
801062f5:	6a 48                	push   $0x48
  jmp alltraps
801062f7:	e9 c2 f8 ff ff       	jmp    80105bbe <alltraps>

801062fc <vector73>:
.globl vector73
vector73:
  pushl $0
801062fc:	6a 00                	push   $0x0
  pushl $73
801062fe:	6a 49                	push   $0x49
  jmp alltraps
80106300:	e9 b9 f8 ff ff       	jmp    80105bbe <alltraps>

80106305 <vector74>:
.globl vector74
vector74:
  pushl $0
80106305:	6a 00                	push   $0x0
  pushl $74
80106307:	6a 4a                	push   $0x4a
  jmp alltraps
80106309:	e9 b0 f8 ff ff       	jmp    80105bbe <alltraps>

8010630e <vector75>:
.globl vector75
vector75:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $75
80106310:	6a 4b                	push   $0x4b
  jmp alltraps
80106312:	e9 a7 f8 ff ff       	jmp    80105bbe <alltraps>

80106317 <vector76>:
.globl vector76
vector76:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $76
80106319:	6a 4c                	push   $0x4c
  jmp alltraps
8010631b:	e9 9e f8 ff ff       	jmp    80105bbe <alltraps>

80106320 <vector77>:
.globl vector77
vector77:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $77
80106322:	6a 4d                	push   $0x4d
  jmp alltraps
80106324:	e9 95 f8 ff ff       	jmp    80105bbe <alltraps>

80106329 <vector78>:
.globl vector78
vector78:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $78
8010632b:	6a 4e                	push   $0x4e
  jmp alltraps
8010632d:	e9 8c f8 ff ff       	jmp    80105bbe <alltraps>

80106332 <vector79>:
.globl vector79
vector79:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $79
80106334:	6a 4f                	push   $0x4f
  jmp alltraps
80106336:	e9 83 f8 ff ff       	jmp    80105bbe <alltraps>

8010633b <vector80>:
.globl vector80
vector80:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $80
8010633d:	6a 50                	push   $0x50
  jmp alltraps
8010633f:	e9 7a f8 ff ff       	jmp    80105bbe <alltraps>

80106344 <vector81>:
.globl vector81
vector81:
  pushl $0
80106344:	6a 00                	push   $0x0
  pushl $81
80106346:	6a 51                	push   $0x51
  jmp alltraps
80106348:	e9 71 f8 ff ff       	jmp    80105bbe <alltraps>

8010634d <vector82>:
.globl vector82
vector82:
  pushl $0
8010634d:	6a 00                	push   $0x0
  pushl $82
8010634f:	6a 52                	push   $0x52
  jmp alltraps
80106351:	e9 68 f8 ff ff       	jmp    80105bbe <alltraps>

80106356 <vector83>:
.globl vector83
vector83:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $83
80106358:	6a 53                	push   $0x53
  jmp alltraps
8010635a:	e9 5f f8 ff ff       	jmp    80105bbe <alltraps>

8010635f <vector84>:
.globl vector84
vector84:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $84
80106361:	6a 54                	push   $0x54
  jmp alltraps
80106363:	e9 56 f8 ff ff       	jmp    80105bbe <alltraps>

80106368 <vector85>:
.globl vector85
vector85:
  pushl $0
80106368:	6a 00                	push   $0x0
  pushl $85
8010636a:	6a 55                	push   $0x55
  jmp alltraps
8010636c:	e9 4d f8 ff ff       	jmp    80105bbe <alltraps>

80106371 <vector86>:
.globl vector86
vector86:
  pushl $0
80106371:	6a 00                	push   $0x0
  pushl $86
80106373:	6a 56                	push   $0x56
  jmp alltraps
80106375:	e9 44 f8 ff ff       	jmp    80105bbe <alltraps>

8010637a <vector87>:
.globl vector87
vector87:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $87
8010637c:	6a 57                	push   $0x57
  jmp alltraps
8010637e:	e9 3b f8 ff ff       	jmp    80105bbe <alltraps>

80106383 <vector88>:
.globl vector88
vector88:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $88
80106385:	6a 58                	push   $0x58
  jmp alltraps
80106387:	e9 32 f8 ff ff       	jmp    80105bbe <alltraps>

8010638c <vector89>:
.globl vector89
vector89:
  pushl $0
8010638c:	6a 00                	push   $0x0
  pushl $89
8010638e:	6a 59                	push   $0x59
  jmp alltraps
80106390:	e9 29 f8 ff ff       	jmp    80105bbe <alltraps>

80106395 <vector90>:
.globl vector90
vector90:
  pushl $0
80106395:	6a 00                	push   $0x0
  pushl $90
80106397:	6a 5a                	push   $0x5a
  jmp alltraps
80106399:	e9 20 f8 ff ff       	jmp    80105bbe <alltraps>

8010639e <vector91>:
.globl vector91
vector91:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $91
801063a0:	6a 5b                	push   $0x5b
  jmp alltraps
801063a2:	e9 17 f8 ff ff       	jmp    80105bbe <alltraps>

801063a7 <vector92>:
.globl vector92
vector92:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $92
801063a9:	6a 5c                	push   $0x5c
  jmp alltraps
801063ab:	e9 0e f8 ff ff       	jmp    80105bbe <alltraps>

801063b0 <vector93>:
.globl vector93
vector93:
  pushl $0
801063b0:	6a 00                	push   $0x0
  pushl $93
801063b2:	6a 5d                	push   $0x5d
  jmp alltraps
801063b4:	e9 05 f8 ff ff       	jmp    80105bbe <alltraps>

801063b9 <vector94>:
.globl vector94
vector94:
  pushl $0
801063b9:	6a 00                	push   $0x0
  pushl $94
801063bb:	6a 5e                	push   $0x5e
  jmp alltraps
801063bd:	e9 fc f7 ff ff       	jmp    80105bbe <alltraps>

801063c2 <vector95>:
.globl vector95
vector95:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $95
801063c4:	6a 5f                	push   $0x5f
  jmp alltraps
801063c6:	e9 f3 f7 ff ff       	jmp    80105bbe <alltraps>

801063cb <vector96>:
.globl vector96
vector96:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $96
801063cd:	6a 60                	push   $0x60
  jmp alltraps
801063cf:	e9 ea f7 ff ff       	jmp    80105bbe <alltraps>

801063d4 <vector97>:
.globl vector97
vector97:
  pushl $0
801063d4:	6a 00                	push   $0x0
  pushl $97
801063d6:	6a 61                	push   $0x61
  jmp alltraps
801063d8:	e9 e1 f7 ff ff       	jmp    80105bbe <alltraps>

801063dd <vector98>:
.globl vector98
vector98:
  pushl $0
801063dd:	6a 00                	push   $0x0
  pushl $98
801063df:	6a 62                	push   $0x62
  jmp alltraps
801063e1:	e9 d8 f7 ff ff       	jmp    80105bbe <alltraps>

801063e6 <vector99>:
.globl vector99
vector99:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $99
801063e8:	6a 63                	push   $0x63
  jmp alltraps
801063ea:	e9 cf f7 ff ff       	jmp    80105bbe <alltraps>

801063ef <vector100>:
.globl vector100
vector100:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $100
801063f1:	6a 64                	push   $0x64
  jmp alltraps
801063f3:	e9 c6 f7 ff ff       	jmp    80105bbe <alltraps>

801063f8 <vector101>:
.globl vector101
vector101:
  pushl $0
801063f8:	6a 00                	push   $0x0
  pushl $101
801063fa:	6a 65                	push   $0x65
  jmp alltraps
801063fc:	e9 bd f7 ff ff       	jmp    80105bbe <alltraps>

80106401 <vector102>:
.globl vector102
vector102:
  pushl $0
80106401:	6a 00                	push   $0x0
  pushl $102
80106403:	6a 66                	push   $0x66
  jmp alltraps
80106405:	e9 b4 f7 ff ff       	jmp    80105bbe <alltraps>

8010640a <vector103>:
.globl vector103
vector103:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $103
8010640c:	6a 67                	push   $0x67
  jmp alltraps
8010640e:	e9 ab f7 ff ff       	jmp    80105bbe <alltraps>

80106413 <vector104>:
.globl vector104
vector104:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $104
80106415:	6a 68                	push   $0x68
  jmp alltraps
80106417:	e9 a2 f7 ff ff       	jmp    80105bbe <alltraps>

8010641c <vector105>:
.globl vector105
vector105:
  pushl $0
8010641c:	6a 00                	push   $0x0
  pushl $105
8010641e:	6a 69                	push   $0x69
  jmp alltraps
80106420:	e9 99 f7 ff ff       	jmp    80105bbe <alltraps>

80106425 <vector106>:
.globl vector106
vector106:
  pushl $0
80106425:	6a 00                	push   $0x0
  pushl $106
80106427:	6a 6a                	push   $0x6a
  jmp alltraps
80106429:	e9 90 f7 ff ff       	jmp    80105bbe <alltraps>

8010642e <vector107>:
.globl vector107
vector107:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $107
80106430:	6a 6b                	push   $0x6b
  jmp alltraps
80106432:	e9 87 f7 ff ff       	jmp    80105bbe <alltraps>

80106437 <vector108>:
.globl vector108
vector108:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $108
80106439:	6a 6c                	push   $0x6c
  jmp alltraps
8010643b:	e9 7e f7 ff ff       	jmp    80105bbe <alltraps>

80106440 <vector109>:
.globl vector109
vector109:
  pushl $0
80106440:	6a 00                	push   $0x0
  pushl $109
80106442:	6a 6d                	push   $0x6d
  jmp alltraps
80106444:	e9 75 f7 ff ff       	jmp    80105bbe <alltraps>

80106449 <vector110>:
.globl vector110
vector110:
  pushl $0
80106449:	6a 00                	push   $0x0
  pushl $110
8010644b:	6a 6e                	push   $0x6e
  jmp alltraps
8010644d:	e9 6c f7 ff ff       	jmp    80105bbe <alltraps>

80106452 <vector111>:
.globl vector111
vector111:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $111
80106454:	6a 6f                	push   $0x6f
  jmp alltraps
80106456:	e9 63 f7 ff ff       	jmp    80105bbe <alltraps>

8010645b <vector112>:
.globl vector112
vector112:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $112
8010645d:	6a 70                	push   $0x70
  jmp alltraps
8010645f:	e9 5a f7 ff ff       	jmp    80105bbe <alltraps>

80106464 <vector113>:
.globl vector113
vector113:
  pushl $0
80106464:	6a 00                	push   $0x0
  pushl $113
80106466:	6a 71                	push   $0x71
  jmp alltraps
80106468:	e9 51 f7 ff ff       	jmp    80105bbe <alltraps>

8010646d <vector114>:
.globl vector114
vector114:
  pushl $0
8010646d:	6a 00                	push   $0x0
  pushl $114
8010646f:	6a 72                	push   $0x72
  jmp alltraps
80106471:	e9 48 f7 ff ff       	jmp    80105bbe <alltraps>

80106476 <vector115>:
.globl vector115
vector115:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $115
80106478:	6a 73                	push   $0x73
  jmp alltraps
8010647a:	e9 3f f7 ff ff       	jmp    80105bbe <alltraps>

8010647f <vector116>:
.globl vector116
vector116:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $116
80106481:	6a 74                	push   $0x74
  jmp alltraps
80106483:	e9 36 f7 ff ff       	jmp    80105bbe <alltraps>

80106488 <vector117>:
.globl vector117
vector117:
  pushl $0
80106488:	6a 00                	push   $0x0
  pushl $117
8010648a:	6a 75                	push   $0x75
  jmp alltraps
8010648c:	e9 2d f7 ff ff       	jmp    80105bbe <alltraps>

80106491 <vector118>:
.globl vector118
vector118:
  pushl $0
80106491:	6a 00                	push   $0x0
  pushl $118
80106493:	6a 76                	push   $0x76
  jmp alltraps
80106495:	e9 24 f7 ff ff       	jmp    80105bbe <alltraps>

8010649a <vector119>:
.globl vector119
vector119:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $119
8010649c:	6a 77                	push   $0x77
  jmp alltraps
8010649e:	e9 1b f7 ff ff       	jmp    80105bbe <alltraps>

801064a3 <vector120>:
.globl vector120
vector120:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $120
801064a5:	6a 78                	push   $0x78
  jmp alltraps
801064a7:	e9 12 f7 ff ff       	jmp    80105bbe <alltraps>

801064ac <vector121>:
.globl vector121
vector121:
  pushl $0
801064ac:	6a 00                	push   $0x0
  pushl $121
801064ae:	6a 79                	push   $0x79
  jmp alltraps
801064b0:	e9 09 f7 ff ff       	jmp    80105bbe <alltraps>

801064b5 <vector122>:
.globl vector122
vector122:
  pushl $0
801064b5:	6a 00                	push   $0x0
  pushl $122
801064b7:	6a 7a                	push   $0x7a
  jmp alltraps
801064b9:	e9 00 f7 ff ff       	jmp    80105bbe <alltraps>

801064be <vector123>:
.globl vector123
vector123:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $123
801064c0:	6a 7b                	push   $0x7b
  jmp alltraps
801064c2:	e9 f7 f6 ff ff       	jmp    80105bbe <alltraps>

801064c7 <vector124>:
.globl vector124
vector124:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $124
801064c9:	6a 7c                	push   $0x7c
  jmp alltraps
801064cb:	e9 ee f6 ff ff       	jmp    80105bbe <alltraps>

801064d0 <vector125>:
.globl vector125
vector125:
  pushl $0
801064d0:	6a 00                	push   $0x0
  pushl $125
801064d2:	6a 7d                	push   $0x7d
  jmp alltraps
801064d4:	e9 e5 f6 ff ff       	jmp    80105bbe <alltraps>

801064d9 <vector126>:
.globl vector126
vector126:
  pushl $0
801064d9:	6a 00                	push   $0x0
  pushl $126
801064db:	6a 7e                	push   $0x7e
  jmp alltraps
801064dd:	e9 dc f6 ff ff       	jmp    80105bbe <alltraps>

801064e2 <vector127>:
.globl vector127
vector127:
  pushl $0
801064e2:	6a 00                	push   $0x0
  pushl $127
801064e4:	6a 7f                	push   $0x7f
  jmp alltraps
801064e6:	e9 d3 f6 ff ff       	jmp    80105bbe <alltraps>

801064eb <vector128>:
.globl vector128
vector128:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $128
801064ed:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064f2:	e9 c7 f6 ff ff       	jmp    80105bbe <alltraps>

801064f7 <vector129>:
.globl vector129
vector129:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $129
801064f9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064fe:	e9 bb f6 ff ff       	jmp    80105bbe <alltraps>

80106503 <vector130>:
.globl vector130
vector130:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $130
80106505:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010650a:	e9 af f6 ff ff       	jmp    80105bbe <alltraps>

8010650f <vector131>:
.globl vector131
vector131:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $131
80106511:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106516:	e9 a3 f6 ff ff       	jmp    80105bbe <alltraps>

8010651b <vector132>:
.globl vector132
vector132:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $132
8010651d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106522:	e9 97 f6 ff ff       	jmp    80105bbe <alltraps>

80106527 <vector133>:
.globl vector133
vector133:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $133
80106529:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010652e:	e9 8b f6 ff ff       	jmp    80105bbe <alltraps>

80106533 <vector134>:
.globl vector134
vector134:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $134
80106535:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010653a:	e9 7f f6 ff ff       	jmp    80105bbe <alltraps>

8010653f <vector135>:
.globl vector135
vector135:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $135
80106541:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106546:	e9 73 f6 ff ff       	jmp    80105bbe <alltraps>

8010654b <vector136>:
.globl vector136
vector136:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $136
8010654d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106552:	e9 67 f6 ff ff       	jmp    80105bbe <alltraps>

80106557 <vector137>:
.globl vector137
vector137:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $137
80106559:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010655e:	e9 5b f6 ff ff       	jmp    80105bbe <alltraps>

80106563 <vector138>:
.globl vector138
vector138:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $138
80106565:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010656a:	e9 4f f6 ff ff       	jmp    80105bbe <alltraps>

8010656f <vector139>:
.globl vector139
vector139:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $139
80106571:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106576:	e9 43 f6 ff ff       	jmp    80105bbe <alltraps>

8010657b <vector140>:
.globl vector140
vector140:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $140
8010657d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106582:	e9 37 f6 ff ff       	jmp    80105bbe <alltraps>

80106587 <vector141>:
.globl vector141
vector141:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $141
80106589:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010658e:	e9 2b f6 ff ff       	jmp    80105bbe <alltraps>

80106593 <vector142>:
.globl vector142
vector142:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $142
80106595:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010659a:	e9 1f f6 ff ff       	jmp    80105bbe <alltraps>

8010659f <vector143>:
.globl vector143
vector143:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $143
801065a1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801065a6:	e9 13 f6 ff ff       	jmp    80105bbe <alltraps>

801065ab <vector144>:
.globl vector144
vector144:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $144
801065ad:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801065b2:	e9 07 f6 ff ff       	jmp    80105bbe <alltraps>

801065b7 <vector145>:
.globl vector145
vector145:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $145
801065b9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801065be:	e9 fb f5 ff ff       	jmp    80105bbe <alltraps>

801065c3 <vector146>:
.globl vector146
vector146:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $146
801065c5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801065ca:	e9 ef f5 ff ff       	jmp    80105bbe <alltraps>

801065cf <vector147>:
.globl vector147
vector147:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $147
801065d1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801065d6:	e9 e3 f5 ff ff       	jmp    80105bbe <alltraps>

801065db <vector148>:
.globl vector148
vector148:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $148
801065dd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801065e2:	e9 d7 f5 ff ff       	jmp    80105bbe <alltraps>

801065e7 <vector149>:
.globl vector149
vector149:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $149
801065e9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065ee:	e9 cb f5 ff ff       	jmp    80105bbe <alltraps>

801065f3 <vector150>:
.globl vector150
vector150:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $150
801065f5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065fa:	e9 bf f5 ff ff       	jmp    80105bbe <alltraps>

801065ff <vector151>:
.globl vector151
vector151:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $151
80106601:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106606:	e9 b3 f5 ff ff       	jmp    80105bbe <alltraps>

8010660b <vector152>:
.globl vector152
vector152:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $152
8010660d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106612:	e9 a7 f5 ff ff       	jmp    80105bbe <alltraps>

80106617 <vector153>:
.globl vector153
vector153:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $153
80106619:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010661e:	e9 9b f5 ff ff       	jmp    80105bbe <alltraps>

80106623 <vector154>:
.globl vector154
vector154:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $154
80106625:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010662a:	e9 8f f5 ff ff       	jmp    80105bbe <alltraps>

8010662f <vector155>:
.globl vector155
vector155:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $155
80106631:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106636:	e9 83 f5 ff ff       	jmp    80105bbe <alltraps>

8010663b <vector156>:
.globl vector156
vector156:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $156
8010663d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106642:	e9 77 f5 ff ff       	jmp    80105bbe <alltraps>

80106647 <vector157>:
.globl vector157
vector157:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $157
80106649:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010664e:	e9 6b f5 ff ff       	jmp    80105bbe <alltraps>

80106653 <vector158>:
.globl vector158
vector158:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $158
80106655:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010665a:	e9 5f f5 ff ff       	jmp    80105bbe <alltraps>

8010665f <vector159>:
.globl vector159
vector159:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $159
80106661:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106666:	e9 53 f5 ff ff       	jmp    80105bbe <alltraps>

8010666b <vector160>:
.globl vector160
vector160:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $160
8010666d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106672:	e9 47 f5 ff ff       	jmp    80105bbe <alltraps>

80106677 <vector161>:
.globl vector161
vector161:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $161
80106679:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010667e:	e9 3b f5 ff ff       	jmp    80105bbe <alltraps>

80106683 <vector162>:
.globl vector162
vector162:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $162
80106685:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010668a:	e9 2f f5 ff ff       	jmp    80105bbe <alltraps>

8010668f <vector163>:
.globl vector163
vector163:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $163
80106691:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106696:	e9 23 f5 ff ff       	jmp    80105bbe <alltraps>

8010669b <vector164>:
.globl vector164
vector164:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $164
8010669d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801066a2:	e9 17 f5 ff ff       	jmp    80105bbe <alltraps>

801066a7 <vector165>:
.globl vector165
vector165:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $165
801066a9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801066ae:	e9 0b f5 ff ff       	jmp    80105bbe <alltraps>

801066b3 <vector166>:
.globl vector166
vector166:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $166
801066b5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801066ba:	e9 ff f4 ff ff       	jmp    80105bbe <alltraps>

801066bf <vector167>:
.globl vector167
vector167:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $167
801066c1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801066c6:	e9 f3 f4 ff ff       	jmp    80105bbe <alltraps>

801066cb <vector168>:
.globl vector168
vector168:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $168
801066cd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801066d2:	e9 e7 f4 ff ff       	jmp    80105bbe <alltraps>

801066d7 <vector169>:
.globl vector169
vector169:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $169
801066d9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801066de:	e9 db f4 ff ff       	jmp    80105bbe <alltraps>

801066e3 <vector170>:
.globl vector170
vector170:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $170
801066e5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066ea:	e9 cf f4 ff ff       	jmp    80105bbe <alltraps>

801066ef <vector171>:
.globl vector171
vector171:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $171
801066f1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066f6:	e9 c3 f4 ff ff       	jmp    80105bbe <alltraps>

801066fb <vector172>:
.globl vector172
vector172:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $172
801066fd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106702:	e9 b7 f4 ff ff       	jmp    80105bbe <alltraps>

80106707 <vector173>:
.globl vector173
vector173:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $173
80106709:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010670e:	e9 ab f4 ff ff       	jmp    80105bbe <alltraps>

80106713 <vector174>:
.globl vector174
vector174:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $174
80106715:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010671a:	e9 9f f4 ff ff       	jmp    80105bbe <alltraps>

8010671f <vector175>:
.globl vector175
vector175:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $175
80106721:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106726:	e9 93 f4 ff ff       	jmp    80105bbe <alltraps>

8010672b <vector176>:
.globl vector176
vector176:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $176
8010672d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106732:	e9 87 f4 ff ff       	jmp    80105bbe <alltraps>

80106737 <vector177>:
.globl vector177
vector177:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $177
80106739:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010673e:	e9 7b f4 ff ff       	jmp    80105bbe <alltraps>

80106743 <vector178>:
.globl vector178
vector178:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $178
80106745:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010674a:	e9 6f f4 ff ff       	jmp    80105bbe <alltraps>

8010674f <vector179>:
.globl vector179
vector179:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $179
80106751:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106756:	e9 63 f4 ff ff       	jmp    80105bbe <alltraps>

8010675b <vector180>:
.globl vector180
vector180:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $180
8010675d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106762:	e9 57 f4 ff ff       	jmp    80105bbe <alltraps>

80106767 <vector181>:
.globl vector181
vector181:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $181
80106769:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010676e:	e9 4b f4 ff ff       	jmp    80105bbe <alltraps>

80106773 <vector182>:
.globl vector182
vector182:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $182
80106775:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010677a:	e9 3f f4 ff ff       	jmp    80105bbe <alltraps>

8010677f <vector183>:
.globl vector183
vector183:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $183
80106781:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106786:	e9 33 f4 ff ff       	jmp    80105bbe <alltraps>

8010678b <vector184>:
.globl vector184
vector184:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $184
8010678d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106792:	e9 27 f4 ff ff       	jmp    80105bbe <alltraps>

80106797 <vector185>:
.globl vector185
vector185:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $185
80106799:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010679e:	e9 1b f4 ff ff       	jmp    80105bbe <alltraps>

801067a3 <vector186>:
.globl vector186
vector186:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $186
801067a5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801067aa:	e9 0f f4 ff ff       	jmp    80105bbe <alltraps>

801067af <vector187>:
.globl vector187
vector187:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $187
801067b1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801067b6:	e9 03 f4 ff ff       	jmp    80105bbe <alltraps>

801067bb <vector188>:
.globl vector188
vector188:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $188
801067bd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801067c2:	e9 f7 f3 ff ff       	jmp    80105bbe <alltraps>

801067c7 <vector189>:
.globl vector189
vector189:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $189
801067c9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801067ce:	e9 eb f3 ff ff       	jmp    80105bbe <alltraps>

801067d3 <vector190>:
.globl vector190
vector190:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $190
801067d5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801067da:	e9 df f3 ff ff       	jmp    80105bbe <alltraps>

801067df <vector191>:
.globl vector191
vector191:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $191
801067e1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067e6:	e9 d3 f3 ff ff       	jmp    80105bbe <alltraps>

801067eb <vector192>:
.globl vector192
vector192:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $192
801067ed:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067f2:	e9 c7 f3 ff ff       	jmp    80105bbe <alltraps>

801067f7 <vector193>:
.globl vector193
vector193:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $193
801067f9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067fe:	e9 bb f3 ff ff       	jmp    80105bbe <alltraps>

80106803 <vector194>:
.globl vector194
vector194:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $194
80106805:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010680a:	e9 af f3 ff ff       	jmp    80105bbe <alltraps>

8010680f <vector195>:
.globl vector195
vector195:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $195
80106811:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106816:	e9 a3 f3 ff ff       	jmp    80105bbe <alltraps>

8010681b <vector196>:
.globl vector196
vector196:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $196
8010681d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106822:	e9 97 f3 ff ff       	jmp    80105bbe <alltraps>

80106827 <vector197>:
.globl vector197
vector197:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $197
80106829:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010682e:	e9 8b f3 ff ff       	jmp    80105bbe <alltraps>

80106833 <vector198>:
.globl vector198
vector198:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $198
80106835:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010683a:	e9 7f f3 ff ff       	jmp    80105bbe <alltraps>

8010683f <vector199>:
.globl vector199
vector199:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $199
80106841:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106846:	e9 73 f3 ff ff       	jmp    80105bbe <alltraps>

8010684b <vector200>:
.globl vector200
vector200:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $200
8010684d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106852:	e9 67 f3 ff ff       	jmp    80105bbe <alltraps>

80106857 <vector201>:
.globl vector201
vector201:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $201
80106859:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010685e:	e9 5b f3 ff ff       	jmp    80105bbe <alltraps>

80106863 <vector202>:
.globl vector202
vector202:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $202
80106865:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010686a:	e9 4f f3 ff ff       	jmp    80105bbe <alltraps>

8010686f <vector203>:
.globl vector203
vector203:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $203
80106871:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106876:	e9 43 f3 ff ff       	jmp    80105bbe <alltraps>

8010687b <vector204>:
.globl vector204
vector204:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $204
8010687d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106882:	e9 37 f3 ff ff       	jmp    80105bbe <alltraps>

80106887 <vector205>:
.globl vector205
vector205:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $205
80106889:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010688e:	e9 2b f3 ff ff       	jmp    80105bbe <alltraps>

80106893 <vector206>:
.globl vector206
vector206:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $206
80106895:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010689a:	e9 1f f3 ff ff       	jmp    80105bbe <alltraps>

8010689f <vector207>:
.globl vector207
vector207:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $207
801068a1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801068a6:	e9 13 f3 ff ff       	jmp    80105bbe <alltraps>

801068ab <vector208>:
.globl vector208
vector208:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $208
801068ad:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801068b2:	e9 07 f3 ff ff       	jmp    80105bbe <alltraps>

801068b7 <vector209>:
.globl vector209
vector209:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $209
801068b9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801068be:	e9 fb f2 ff ff       	jmp    80105bbe <alltraps>

801068c3 <vector210>:
.globl vector210
vector210:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $210
801068c5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801068ca:	e9 ef f2 ff ff       	jmp    80105bbe <alltraps>

801068cf <vector211>:
.globl vector211
vector211:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $211
801068d1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801068d6:	e9 e3 f2 ff ff       	jmp    80105bbe <alltraps>

801068db <vector212>:
.globl vector212
vector212:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $212
801068dd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801068e2:	e9 d7 f2 ff ff       	jmp    80105bbe <alltraps>

801068e7 <vector213>:
.globl vector213
vector213:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $213
801068e9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068ee:	e9 cb f2 ff ff       	jmp    80105bbe <alltraps>

801068f3 <vector214>:
.globl vector214
vector214:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $214
801068f5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068fa:	e9 bf f2 ff ff       	jmp    80105bbe <alltraps>

801068ff <vector215>:
.globl vector215
vector215:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $215
80106901:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106906:	e9 b3 f2 ff ff       	jmp    80105bbe <alltraps>

8010690b <vector216>:
.globl vector216
vector216:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $216
8010690d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106912:	e9 a7 f2 ff ff       	jmp    80105bbe <alltraps>

80106917 <vector217>:
.globl vector217
vector217:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $217
80106919:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010691e:	e9 9b f2 ff ff       	jmp    80105bbe <alltraps>

80106923 <vector218>:
.globl vector218
vector218:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $218
80106925:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010692a:	e9 8f f2 ff ff       	jmp    80105bbe <alltraps>

8010692f <vector219>:
.globl vector219
vector219:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $219
80106931:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106936:	e9 83 f2 ff ff       	jmp    80105bbe <alltraps>

8010693b <vector220>:
.globl vector220
vector220:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $220
8010693d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106942:	e9 77 f2 ff ff       	jmp    80105bbe <alltraps>

80106947 <vector221>:
.globl vector221
vector221:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $221
80106949:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010694e:	e9 6b f2 ff ff       	jmp    80105bbe <alltraps>

80106953 <vector222>:
.globl vector222
vector222:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $222
80106955:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010695a:	e9 5f f2 ff ff       	jmp    80105bbe <alltraps>

8010695f <vector223>:
.globl vector223
vector223:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $223
80106961:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106966:	e9 53 f2 ff ff       	jmp    80105bbe <alltraps>

8010696b <vector224>:
.globl vector224
vector224:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $224
8010696d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106972:	e9 47 f2 ff ff       	jmp    80105bbe <alltraps>

80106977 <vector225>:
.globl vector225
vector225:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $225
80106979:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010697e:	e9 3b f2 ff ff       	jmp    80105bbe <alltraps>

80106983 <vector226>:
.globl vector226
vector226:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $226
80106985:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010698a:	e9 2f f2 ff ff       	jmp    80105bbe <alltraps>

8010698f <vector227>:
.globl vector227
vector227:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $227
80106991:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106996:	e9 23 f2 ff ff       	jmp    80105bbe <alltraps>

8010699b <vector228>:
.globl vector228
vector228:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $228
8010699d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801069a2:	e9 17 f2 ff ff       	jmp    80105bbe <alltraps>

801069a7 <vector229>:
.globl vector229
vector229:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $229
801069a9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801069ae:	e9 0b f2 ff ff       	jmp    80105bbe <alltraps>

801069b3 <vector230>:
.globl vector230
vector230:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $230
801069b5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801069ba:	e9 ff f1 ff ff       	jmp    80105bbe <alltraps>

801069bf <vector231>:
.globl vector231
vector231:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $231
801069c1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801069c6:	e9 f3 f1 ff ff       	jmp    80105bbe <alltraps>

801069cb <vector232>:
.globl vector232
vector232:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $232
801069cd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801069d2:	e9 e7 f1 ff ff       	jmp    80105bbe <alltraps>

801069d7 <vector233>:
.globl vector233
vector233:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $233
801069d9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801069de:	e9 db f1 ff ff       	jmp    80105bbe <alltraps>

801069e3 <vector234>:
.globl vector234
vector234:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $234
801069e5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069ea:	e9 cf f1 ff ff       	jmp    80105bbe <alltraps>

801069ef <vector235>:
.globl vector235
vector235:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $235
801069f1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069f6:	e9 c3 f1 ff ff       	jmp    80105bbe <alltraps>

801069fb <vector236>:
.globl vector236
vector236:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $236
801069fd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106a02:	e9 b7 f1 ff ff       	jmp    80105bbe <alltraps>

80106a07 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $237
80106a09:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a0e:	e9 ab f1 ff ff       	jmp    80105bbe <alltraps>

80106a13 <vector238>:
.globl vector238
vector238:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $238
80106a15:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a1a:	e9 9f f1 ff ff       	jmp    80105bbe <alltraps>

80106a1f <vector239>:
.globl vector239
vector239:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $239
80106a21:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a26:	e9 93 f1 ff ff       	jmp    80105bbe <alltraps>

80106a2b <vector240>:
.globl vector240
vector240:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $240
80106a2d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a32:	e9 87 f1 ff ff       	jmp    80105bbe <alltraps>

80106a37 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $241
80106a39:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a3e:	e9 7b f1 ff ff       	jmp    80105bbe <alltraps>

80106a43 <vector242>:
.globl vector242
vector242:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $242
80106a45:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a4a:	e9 6f f1 ff ff       	jmp    80105bbe <alltraps>

80106a4f <vector243>:
.globl vector243
vector243:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $243
80106a51:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a56:	e9 63 f1 ff ff       	jmp    80105bbe <alltraps>

80106a5b <vector244>:
.globl vector244
vector244:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $244
80106a5d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a62:	e9 57 f1 ff ff       	jmp    80105bbe <alltraps>

80106a67 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $245
80106a69:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a6e:	e9 4b f1 ff ff       	jmp    80105bbe <alltraps>

80106a73 <vector246>:
.globl vector246
vector246:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $246
80106a75:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a7a:	e9 3f f1 ff ff       	jmp    80105bbe <alltraps>

80106a7f <vector247>:
.globl vector247
vector247:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $247
80106a81:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a86:	e9 33 f1 ff ff       	jmp    80105bbe <alltraps>

80106a8b <vector248>:
.globl vector248
vector248:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $248
80106a8d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a92:	e9 27 f1 ff ff       	jmp    80105bbe <alltraps>

80106a97 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $249
80106a99:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a9e:	e9 1b f1 ff ff       	jmp    80105bbe <alltraps>

80106aa3 <vector250>:
.globl vector250
vector250:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $250
80106aa5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106aaa:	e9 0f f1 ff ff       	jmp    80105bbe <alltraps>

80106aaf <vector251>:
.globl vector251
vector251:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $251
80106ab1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ab6:	e9 03 f1 ff ff       	jmp    80105bbe <alltraps>

80106abb <vector252>:
.globl vector252
vector252:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $252
80106abd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106ac2:	e9 f7 f0 ff ff       	jmp    80105bbe <alltraps>

80106ac7 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $253
80106ac9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106ace:	e9 eb f0 ff ff       	jmp    80105bbe <alltraps>

80106ad3 <vector254>:
.globl vector254
vector254:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $254
80106ad5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ada:	e9 df f0 ff ff       	jmp    80105bbe <alltraps>

80106adf <vector255>:
.globl vector255
vector255:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $255
80106ae1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ae6:	e9 d3 f0 ff ff       	jmp    80105bbe <alltraps>
80106aeb:	66 90                	xchg   %ax,%ax
80106aed:	66 90                	xchg   %ax,%ax
80106aef:	90                   	nop

80106af0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106af7:	c1 ea 16             	shr    $0x16,%edx
{
80106afa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106afb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106afe:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106b01:	8b 1f                	mov    (%edi),%ebx
80106b03:	f6 c3 01             	test   $0x1,%bl
80106b06:	74 28                	je     80106b30 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b08:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106b0e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106b14:	89 f0                	mov    %esi,%eax
}
80106b16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106b19:	c1 e8 0a             	shr    $0xa,%eax
80106b1c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106b21:	01 d8                	add    %ebx,%eax
}
80106b23:	5b                   	pop    %ebx
80106b24:	5e                   	pop    %esi
80106b25:	5f                   	pop    %edi
80106b26:	5d                   	pop    %ebp
80106b27:	c3                   	ret    
80106b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b2f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b30:	85 c9                	test   %ecx,%ecx
80106b32:	74 2c                	je     80106b60 <walkpgdir+0x70>
80106b34:	e8 47 be ff ff       	call   80102980 <kalloc>
80106b39:	89 c3                	mov    %eax,%ebx
80106b3b:	85 c0                	test   %eax,%eax
80106b3d:	74 21                	je     80106b60 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106b3f:	83 ec 04             	sub    $0x4,%esp
80106b42:	68 00 10 00 00       	push   $0x1000
80106b47:	6a 00                	push   $0x0
80106b49:	50                   	push   %eax
80106b4a:	e8 71 de ff ff       	call   801049c0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b4f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b55:	83 c4 10             	add    $0x10,%esp
80106b58:	83 c8 07             	or     $0x7,%eax
80106b5b:	89 07                	mov    %eax,(%edi)
80106b5d:	eb b5                	jmp    80106b14 <walkpgdir+0x24>
80106b5f:	90                   	nop
}
80106b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106b63:	31 c0                	xor    %eax,%eax
}
80106b65:	5b                   	pop    %ebx
80106b66:	5e                   	pop    %esi
80106b67:	5f                   	pop    %edi
80106b68:	5d                   	pop    %ebp
80106b69:	c3                   	ret    
80106b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b70 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b76:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106b7a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106b80:	89 d6                	mov    %edx,%esi
{
80106b82:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106b83:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106b89:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b8f:	8b 45 08             	mov    0x8(%ebp),%eax
80106b92:	29 f0                	sub    %esi,%eax
80106b94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b97:	eb 1f                	jmp    80106bb8 <mappages+0x48>
80106b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106ba0:	f6 00 01             	testb  $0x1,(%eax)
80106ba3:	75 45                	jne    80106bea <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106ba5:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106ba8:	83 cb 01             	or     $0x1,%ebx
80106bab:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106bad:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106bb0:	74 2e                	je     80106be0 <mappages+0x70>
      break;
    a += PGSIZE;
80106bb2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106bbb:	b9 01 00 00 00       	mov    $0x1,%ecx
80106bc0:	89 f2                	mov    %esi,%edx
80106bc2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106bc5:	89 f8                	mov    %edi,%eax
80106bc7:	e8 24 ff ff ff       	call   80106af0 <walkpgdir>
80106bcc:	85 c0                	test   %eax,%eax
80106bce:	75 d0                	jne    80106ba0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bd8:	5b                   	pop    %ebx
80106bd9:	5e                   	pop    %esi
80106bda:	5f                   	pop    %edi
80106bdb:	5d                   	pop    %ebp
80106bdc:	c3                   	ret    
80106bdd:	8d 76 00             	lea    0x0(%esi),%esi
80106be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106be3:	31 c0                	xor    %eax,%eax
}
80106be5:	5b                   	pop    %ebx
80106be6:	5e                   	pop    %esi
80106be7:	5f                   	pop    %edi
80106be8:	5d                   	pop    %ebp
80106be9:	c3                   	ret    
      panic("remap");
80106bea:	83 ec 0c             	sub    $0xc,%esp
80106bed:	68 e8 7c 10 80       	push   $0x80107ce8
80106bf2:	e8 19 9a ff ff       	call   80100610 <panic>
80106bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bfe:	66 90                	xchg   %ax,%ax

80106c00 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	89 c6                	mov    %eax,%esi
80106c07:	53                   	push   %ebx
80106c08:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c0a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106c10:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c16:	83 ec 1c             	sub    $0x1c,%esp
80106c19:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106c1c:	39 da                	cmp    %ebx,%edx
80106c1e:	73 5b                	jae    80106c7b <deallocuvm.part.0+0x7b>
80106c20:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106c23:	89 d7                	mov    %edx,%edi
80106c25:	eb 14                	jmp    80106c3b <deallocuvm.part.0+0x3b>
80106c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c2e:	66 90                	xchg   %ax,%ax
80106c30:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106c36:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106c39:	76 40                	jbe    80106c7b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106c3b:	31 c9                	xor    %ecx,%ecx
80106c3d:	89 fa                	mov    %edi,%edx
80106c3f:	89 f0                	mov    %esi,%eax
80106c41:	e8 aa fe ff ff       	call   80106af0 <walkpgdir>
80106c46:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106c48:	85 c0                	test   %eax,%eax
80106c4a:	74 44                	je     80106c90 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106c4c:	8b 00                	mov    (%eax),%eax
80106c4e:	a8 01                	test   $0x1,%al
80106c50:	74 de                	je     80106c30 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106c52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c57:	74 47                	je     80106ca0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106c59:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c5c:	05 00 00 00 80       	add    $0x80000000,%eax
80106c61:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106c67:	50                   	push   %eax
80106c68:	e8 53 bb ff ff       	call   801027c0 <kfree>
      *pte = 0;
80106c6d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106c73:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106c76:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106c79:	77 c0                	ja     80106c3b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80106c7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c81:	5b                   	pop    %ebx
80106c82:	5e                   	pop    %esi
80106c83:	5f                   	pop    %edi
80106c84:	5d                   	pop    %ebp
80106c85:	c3                   	ret    
80106c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c8d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c90:	89 fa                	mov    %edi,%edx
80106c92:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106c98:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80106c9e:	eb 96                	jmp    80106c36 <deallocuvm.part.0+0x36>
        panic("kfree");
80106ca0:	83 ec 0c             	sub    $0xc,%esp
80106ca3:	68 96 76 10 80       	push   $0x80107696
80106ca8:	e8 63 99 ff ff       	call   80100610 <panic>
80106cad:	8d 76 00             	lea    0x0(%esi),%esi

80106cb0 <seginit>:
{
80106cb0:	f3 0f 1e fb          	endbr32 
80106cb4:	55                   	push   %ebp
80106cb5:	89 e5                	mov    %esp,%ebp
80106cb7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106cba:	e8 d1 cf ff ff       	call   80103c90 <cpuid>
  pd[0] = size-1;
80106cbf:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106cc4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106cca:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106cce:	c7 80 58 28 11 80 ff 	movl   $0xffff,-0x7feed7a8(%eax)
80106cd5:	ff 00 00 
80106cd8:	c7 80 5c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7a4(%eax)
80106cdf:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ce2:	c7 80 60 28 11 80 ff 	movl   $0xffff,-0x7feed7a0(%eax)
80106ce9:	ff 00 00 
80106cec:	c7 80 64 28 11 80 00 	movl   $0xcf9200,-0x7feed79c(%eax)
80106cf3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106cf6:	c7 80 68 28 11 80 ff 	movl   $0xffff,-0x7feed798(%eax)
80106cfd:	ff 00 00 
80106d00:	c7 80 6c 28 11 80 00 	movl   $0xcffa00,-0x7feed794(%eax)
80106d07:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d0a:	c7 80 70 28 11 80 ff 	movl   $0xffff,-0x7feed790(%eax)
80106d11:	ff 00 00 
80106d14:	c7 80 74 28 11 80 00 	movl   $0xcff200,-0x7feed78c(%eax)
80106d1b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106d1e:	05 50 28 11 80       	add    $0x80112850,%eax
  pd[1] = (uint)p;
80106d23:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106d27:	c1 e8 10             	shr    $0x10,%eax
80106d2a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106d2e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d31:	0f 01 10             	lgdtl  (%eax)
}
80106d34:	c9                   	leave  
80106d35:	c3                   	ret    
80106d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d3d:	8d 76 00             	lea    0x0(%esi),%esi

80106d40 <switchkvm>:
{
80106d40:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d44:	a1 04 55 11 80       	mov    0x80115504,%eax
80106d49:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d4e:	0f 22 d8             	mov    %eax,%cr3
}
80106d51:	c3                   	ret    
80106d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d60 <switchuvm>:
{
80106d60:	f3 0f 1e fb          	endbr32 
80106d64:	55                   	push   %ebp
80106d65:	89 e5                	mov    %esp,%ebp
80106d67:	57                   	push   %edi
80106d68:	56                   	push   %esi
80106d69:	53                   	push   %ebx
80106d6a:	83 ec 1c             	sub    $0x1c,%esp
80106d6d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d70:	85 f6                	test   %esi,%esi
80106d72:	0f 84 cb 00 00 00    	je     80106e43 <switchuvm+0xe3>
  if(p->kstack == 0)
80106d78:	8b 46 08             	mov    0x8(%esi),%eax
80106d7b:	85 c0                	test   %eax,%eax
80106d7d:	0f 84 da 00 00 00    	je     80106e5d <switchuvm+0xfd>
  if(p->pgdir == 0)
80106d83:	8b 46 04             	mov    0x4(%esi),%eax
80106d86:	85 c0                	test   %eax,%eax
80106d88:	0f 84 c2 00 00 00    	je     80106e50 <switchuvm+0xf0>
  pushcli();
80106d8e:	e8 1d da ff ff       	call   801047b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d93:	e8 88 ce ff ff       	call   80103c20 <mycpu>
80106d98:	89 c3                	mov    %eax,%ebx
80106d9a:	e8 81 ce ff ff       	call   80103c20 <mycpu>
80106d9f:	89 c7                	mov    %eax,%edi
80106da1:	e8 7a ce ff ff       	call   80103c20 <mycpu>
80106da6:	83 c7 08             	add    $0x8,%edi
80106da9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106dac:	e8 6f ce ff ff       	call   80103c20 <mycpu>
80106db1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106db4:	ba 67 00 00 00       	mov    $0x67,%edx
80106db9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106dc0:	83 c0 08             	add    $0x8,%eax
80106dc3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106dca:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106dcf:	83 c1 08             	add    $0x8,%ecx
80106dd2:	c1 e8 18             	shr    $0x18,%eax
80106dd5:	c1 e9 10             	shr    $0x10,%ecx
80106dd8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106dde:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106de4:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106de9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106df0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106df5:	e8 26 ce ff ff       	call   80103c20 <mycpu>
80106dfa:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e01:	e8 1a ce ff ff       	call   80103c20 <mycpu>
80106e06:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e0a:	8b 5e 08             	mov    0x8(%esi),%ebx
80106e0d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e13:	e8 08 ce ff ff       	call   80103c20 <mycpu>
80106e18:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e1b:	e8 00 ce ff ff       	call   80103c20 <mycpu>
80106e20:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106e24:	b8 28 00 00 00       	mov    $0x28,%eax
80106e29:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106e2c:	8b 46 04             	mov    0x4(%esi),%eax
80106e2f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e34:	0f 22 d8             	mov    %eax,%cr3
}
80106e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e3a:	5b                   	pop    %ebx
80106e3b:	5e                   	pop    %esi
80106e3c:	5f                   	pop    %edi
80106e3d:	5d                   	pop    %ebp
  popcli();
80106e3e:	e9 bd d9 ff ff       	jmp    80104800 <popcli>
    panic("switchuvm: no process");
80106e43:	83 ec 0c             	sub    $0xc,%esp
80106e46:	68 ee 7c 10 80       	push   $0x80107cee
80106e4b:	e8 c0 97 ff ff       	call   80100610 <panic>
    panic("switchuvm: no pgdir");
80106e50:	83 ec 0c             	sub    $0xc,%esp
80106e53:	68 19 7d 10 80       	push   $0x80107d19
80106e58:	e8 b3 97 ff ff       	call   80100610 <panic>
    panic("switchuvm: no kstack");
80106e5d:	83 ec 0c             	sub    $0xc,%esp
80106e60:	68 04 7d 10 80       	push   $0x80107d04
80106e65:	e8 a6 97 ff ff       	call   80100610 <panic>
80106e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e70 <inituvm>:
{
80106e70:	f3 0f 1e fb          	endbr32 
80106e74:	55                   	push   %ebp
80106e75:	89 e5                	mov    %esp,%ebp
80106e77:	57                   	push   %edi
80106e78:	56                   	push   %esi
80106e79:	53                   	push   %ebx
80106e7a:	83 ec 1c             	sub    $0x1c,%esp
80106e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e80:	8b 75 10             	mov    0x10(%ebp),%esi
80106e83:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e89:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e8f:	77 4b                	ja     80106edc <inituvm+0x6c>
  mem = kalloc();
80106e91:	e8 ea ba ff ff       	call   80102980 <kalloc>
  memset(mem, 0, PGSIZE);
80106e96:	83 ec 04             	sub    $0x4,%esp
80106e99:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106e9e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106ea0:	6a 00                	push   $0x0
80106ea2:	50                   	push   %eax
80106ea3:	e8 18 db ff ff       	call   801049c0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ea8:	58                   	pop    %eax
80106ea9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106eaf:	5a                   	pop    %edx
80106eb0:	6a 06                	push   $0x6
80106eb2:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106eb7:	31 d2                	xor    %edx,%edx
80106eb9:	50                   	push   %eax
80106eba:	89 f8                	mov    %edi,%eax
80106ebc:	e8 af fc ff ff       	call   80106b70 <mappages>
  memmove(mem, init, sz);
80106ec1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ec4:	89 75 10             	mov    %esi,0x10(%ebp)
80106ec7:	83 c4 10             	add    $0x10,%esp
80106eca:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106ecd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ed3:	5b                   	pop    %ebx
80106ed4:	5e                   	pop    %esi
80106ed5:	5f                   	pop    %edi
80106ed6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ed7:	e9 84 db ff ff       	jmp    80104a60 <memmove>
    panic("inituvm: more than a page");
80106edc:	83 ec 0c             	sub    $0xc,%esp
80106edf:	68 2d 7d 10 80       	push   $0x80107d2d
80106ee4:	e8 27 97 ff ff       	call   80100610 <panic>
80106ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ef0 <loaduvm>:
{
80106ef0:	f3 0f 1e fb          	endbr32 
80106ef4:	55                   	push   %ebp
80106ef5:	89 e5                	mov    %esp,%ebp
80106ef7:	57                   	push   %edi
80106ef8:	56                   	push   %esi
80106ef9:	53                   	push   %ebx
80106efa:	83 ec 1c             	sub    $0x1c,%esp
80106efd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f00:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106f03:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106f08:	0f 85 99 00 00 00    	jne    80106fa7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80106f0e:	01 f0                	add    %esi,%eax
80106f10:	89 f3                	mov    %esi,%ebx
80106f12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f15:	8b 45 14             	mov    0x14(%ebp),%eax
80106f18:	01 f0                	add    %esi,%eax
80106f1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106f1d:	85 f6                	test   %esi,%esi
80106f1f:	75 15                	jne    80106f36 <loaduvm+0x46>
80106f21:	eb 6d                	jmp    80106f90 <loaduvm+0xa0>
80106f23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f27:	90                   	nop
80106f28:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106f2e:	89 f0                	mov    %esi,%eax
80106f30:	29 d8                	sub    %ebx,%eax
80106f32:	39 c6                	cmp    %eax,%esi
80106f34:	76 5a                	jbe    80106f90 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f39:	8b 45 08             	mov    0x8(%ebp),%eax
80106f3c:	31 c9                	xor    %ecx,%ecx
80106f3e:	29 da                	sub    %ebx,%edx
80106f40:	e8 ab fb ff ff       	call   80106af0 <walkpgdir>
80106f45:	85 c0                	test   %eax,%eax
80106f47:	74 51                	je     80106f9a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106f49:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f4b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f4e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f58:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106f5e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f61:	29 d9                	sub    %ebx,%ecx
80106f63:	05 00 00 00 80       	add    $0x80000000,%eax
80106f68:	57                   	push   %edi
80106f69:	51                   	push   %ecx
80106f6a:	50                   	push   %eax
80106f6b:	ff 75 10             	pushl  0x10(%ebp)
80106f6e:	e8 3d ae ff ff       	call   80101db0 <readi>
80106f73:	83 c4 10             	add    $0x10,%esp
80106f76:	39 f8                	cmp    %edi,%eax
80106f78:	74 ae                	je     80106f28 <loaduvm+0x38>
}
80106f7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f82:	5b                   	pop    %ebx
80106f83:	5e                   	pop    %esi
80106f84:	5f                   	pop    %edi
80106f85:	5d                   	pop    %ebp
80106f86:	c3                   	ret    
80106f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f8e:	66 90                	xchg   %ax,%ax
80106f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f93:	31 c0                	xor    %eax,%eax
}
80106f95:	5b                   	pop    %ebx
80106f96:	5e                   	pop    %esi
80106f97:	5f                   	pop    %edi
80106f98:	5d                   	pop    %ebp
80106f99:	c3                   	ret    
      panic("loaduvm: address should exist");
80106f9a:	83 ec 0c             	sub    $0xc,%esp
80106f9d:	68 47 7d 10 80       	push   $0x80107d47
80106fa2:	e8 69 96 ff ff       	call   80100610 <panic>
    panic("loaduvm: addr must be page aligned");
80106fa7:	83 ec 0c             	sub    $0xc,%esp
80106faa:	68 e8 7d 10 80       	push   $0x80107de8
80106faf:	e8 5c 96 ff ff       	call   80100610 <panic>
80106fb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fbf:	90                   	nop

80106fc0 <allocuvm>:
{
80106fc0:	f3 0f 1e fb          	endbr32 
80106fc4:	55                   	push   %ebp
80106fc5:	89 e5                	mov    %esp,%ebp
80106fc7:	57                   	push   %edi
80106fc8:	56                   	push   %esi
80106fc9:	53                   	push   %ebx
80106fca:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106fcd:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106fd0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106fd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fd6:	85 c0                	test   %eax,%eax
80106fd8:	0f 88 b2 00 00 00    	js     80107090 <allocuvm+0xd0>
  if(newsz < oldsz)
80106fde:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106fe4:	0f 82 96 00 00 00    	jb     80107080 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106fea:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106ff0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106ff6:	39 75 10             	cmp    %esi,0x10(%ebp)
80106ff9:	77 40                	ja     8010703b <allocuvm+0x7b>
80106ffb:	e9 83 00 00 00       	jmp    80107083 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107000:	83 ec 04             	sub    $0x4,%esp
80107003:	68 00 10 00 00       	push   $0x1000
80107008:	6a 00                	push   $0x0
8010700a:	50                   	push   %eax
8010700b:	e8 b0 d9 ff ff       	call   801049c0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107010:	58                   	pop    %eax
80107011:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107017:	5a                   	pop    %edx
80107018:	6a 06                	push   $0x6
8010701a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010701f:	89 f2                	mov    %esi,%edx
80107021:	50                   	push   %eax
80107022:	89 f8                	mov    %edi,%eax
80107024:	e8 47 fb ff ff       	call   80106b70 <mappages>
80107029:	83 c4 10             	add    $0x10,%esp
8010702c:	85 c0                	test   %eax,%eax
8010702e:	78 78                	js     801070a8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107030:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107036:	39 75 10             	cmp    %esi,0x10(%ebp)
80107039:	76 48                	jbe    80107083 <allocuvm+0xc3>
    mem = kalloc();
8010703b:	e8 40 b9 ff ff       	call   80102980 <kalloc>
80107040:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107042:	85 c0                	test   %eax,%eax
80107044:	75 ba                	jne    80107000 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107046:	83 ec 0c             	sub    $0xc,%esp
80107049:	68 65 7d 10 80       	push   $0x80107d65
8010704e:	e8 3d 96 ff ff       	call   80100690 <cprintf>
  if(newsz >= oldsz)
80107053:	8b 45 0c             	mov    0xc(%ebp),%eax
80107056:	83 c4 10             	add    $0x10,%esp
80107059:	39 45 10             	cmp    %eax,0x10(%ebp)
8010705c:	74 32                	je     80107090 <allocuvm+0xd0>
8010705e:	8b 55 10             	mov    0x10(%ebp),%edx
80107061:	89 c1                	mov    %eax,%ecx
80107063:	89 f8                	mov    %edi,%eax
80107065:	e8 96 fb ff ff       	call   80106c00 <deallocuvm.part.0>
      return 0;
8010706a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107074:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107077:	5b                   	pop    %ebx
80107078:	5e                   	pop    %esi
80107079:	5f                   	pop    %edi
8010707a:	5d                   	pop    %ebp
8010707b:	c3                   	ret    
8010707c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107083:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107089:	5b                   	pop    %ebx
8010708a:	5e                   	pop    %esi
8010708b:	5f                   	pop    %edi
8010708c:	5d                   	pop    %ebp
8010708d:	c3                   	ret    
8010708e:	66 90                	xchg   %ax,%ax
    return 0;
80107090:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107097:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010709a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010709d:	5b                   	pop    %ebx
8010709e:	5e                   	pop    %esi
8010709f:	5f                   	pop    %edi
801070a0:	5d                   	pop    %ebp
801070a1:	c3                   	ret    
801070a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801070a8:	83 ec 0c             	sub    $0xc,%esp
801070ab:	68 7d 7d 10 80       	push   $0x80107d7d
801070b0:	e8 db 95 ff ff       	call   80100690 <cprintf>
  if(newsz >= oldsz)
801070b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801070b8:	83 c4 10             	add    $0x10,%esp
801070bb:	39 45 10             	cmp    %eax,0x10(%ebp)
801070be:	74 0c                	je     801070cc <allocuvm+0x10c>
801070c0:	8b 55 10             	mov    0x10(%ebp),%edx
801070c3:	89 c1                	mov    %eax,%ecx
801070c5:	89 f8                	mov    %edi,%eax
801070c7:	e8 34 fb ff ff       	call   80106c00 <deallocuvm.part.0>
      kfree(mem);
801070cc:	83 ec 0c             	sub    $0xc,%esp
801070cf:	53                   	push   %ebx
801070d0:	e8 eb b6 ff ff       	call   801027c0 <kfree>
      return 0;
801070d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801070dc:	83 c4 10             	add    $0x10,%esp
}
801070df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070e5:	5b                   	pop    %ebx
801070e6:	5e                   	pop    %esi
801070e7:	5f                   	pop    %edi
801070e8:	5d                   	pop    %ebp
801070e9:	c3                   	ret    
801070ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070f0 <deallocuvm>:
{
801070f0:	f3 0f 1e fb          	endbr32 
801070f4:	55                   	push   %ebp
801070f5:	89 e5                	mov    %esp,%ebp
801070f7:	8b 55 0c             	mov    0xc(%ebp),%edx
801070fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070fd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107100:	39 d1                	cmp    %edx,%ecx
80107102:	73 0c                	jae    80107110 <deallocuvm+0x20>
}
80107104:	5d                   	pop    %ebp
80107105:	e9 f6 fa ff ff       	jmp    80106c00 <deallocuvm.part.0>
8010710a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107110:	89 d0                	mov    %edx,%eax
80107112:	5d                   	pop    %ebp
80107113:	c3                   	ret    
80107114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010711b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010711f:	90                   	nop

80107120 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107120:	f3 0f 1e fb          	endbr32 
80107124:	55                   	push   %ebp
80107125:	89 e5                	mov    %esp,%ebp
80107127:	57                   	push   %edi
80107128:	56                   	push   %esi
80107129:	53                   	push   %ebx
8010712a:	83 ec 0c             	sub    $0xc,%esp
8010712d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107130:	85 f6                	test   %esi,%esi
80107132:	74 55                	je     80107189 <freevm+0x69>
  if(newsz >= oldsz)
80107134:	31 c9                	xor    %ecx,%ecx
80107136:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010713b:	89 f0                	mov    %esi,%eax
8010713d:	89 f3                	mov    %esi,%ebx
8010713f:	e8 bc fa ff ff       	call   80106c00 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107144:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010714a:	eb 0b                	jmp    80107157 <freevm+0x37>
8010714c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107150:	83 c3 04             	add    $0x4,%ebx
80107153:	39 df                	cmp    %ebx,%edi
80107155:	74 23                	je     8010717a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107157:	8b 03                	mov    (%ebx),%eax
80107159:	a8 01                	test   $0x1,%al
8010715b:	74 f3                	je     80107150 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010715d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107162:	83 ec 0c             	sub    $0xc,%esp
80107165:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107168:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010716d:	50                   	push   %eax
8010716e:	e8 4d b6 ff ff       	call   801027c0 <kfree>
80107173:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107176:	39 df                	cmp    %ebx,%edi
80107178:	75 dd                	jne    80107157 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010717a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010717d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107180:	5b                   	pop    %ebx
80107181:	5e                   	pop    %esi
80107182:	5f                   	pop    %edi
80107183:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107184:	e9 37 b6 ff ff       	jmp    801027c0 <kfree>
    panic("freevm: no pgdir");
80107189:	83 ec 0c             	sub    $0xc,%esp
8010718c:	68 99 7d 10 80       	push   $0x80107d99
80107191:	e8 7a 94 ff ff       	call   80100610 <panic>
80107196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010719d:	8d 76 00             	lea    0x0(%esi),%esi

801071a0 <setupkvm>:
{
801071a0:	f3 0f 1e fb          	endbr32 
801071a4:	55                   	push   %ebp
801071a5:	89 e5                	mov    %esp,%ebp
801071a7:	56                   	push   %esi
801071a8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801071a9:	e8 d2 b7 ff ff       	call   80102980 <kalloc>
801071ae:	89 c6                	mov    %eax,%esi
801071b0:	85 c0                	test   %eax,%eax
801071b2:	74 42                	je     801071f6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801071b4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071b7:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801071bc:	68 00 10 00 00       	push   $0x1000
801071c1:	6a 00                	push   $0x0
801071c3:	50                   	push   %eax
801071c4:	e8 f7 d7 ff ff       	call   801049c0 <memset>
801071c9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801071cc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801071cf:	83 ec 08             	sub    $0x8,%esp
801071d2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801071d5:	ff 73 0c             	pushl  0xc(%ebx)
801071d8:	8b 13                	mov    (%ebx),%edx
801071da:	50                   	push   %eax
801071db:	29 c1                	sub    %eax,%ecx
801071dd:	89 f0                	mov    %esi,%eax
801071df:	e8 8c f9 ff ff       	call   80106b70 <mappages>
801071e4:	83 c4 10             	add    $0x10,%esp
801071e7:	85 c0                	test   %eax,%eax
801071e9:	78 15                	js     80107200 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071eb:	83 c3 10             	add    $0x10,%ebx
801071ee:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801071f4:	75 d6                	jne    801071cc <setupkvm+0x2c>
}
801071f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071f9:	89 f0                	mov    %esi,%eax
801071fb:	5b                   	pop    %ebx
801071fc:	5e                   	pop    %esi
801071fd:	5d                   	pop    %ebp
801071fe:	c3                   	ret    
801071ff:	90                   	nop
      freevm(pgdir);
80107200:	83 ec 0c             	sub    $0xc,%esp
80107203:	56                   	push   %esi
      return 0;
80107204:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107206:	e8 15 ff ff ff       	call   80107120 <freevm>
      return 0;
8010720b:	83 c4 10             	add    $0x10,%esp
}
8010720e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107211:	89 f0                	mov    %esi,%eax
80107213:	5b                   	pop    %ebx
80107214:	5e                   	pop    %esi
80107215:	5d                   	pop    %ebp
80107216:	c3                   	ret    
80107217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010721e:	66 90                	xchg   %ax,%ax

80107220 <kvmalloc>:
{
80107220:	f3 0f 1e fb          	endbr32 
80107224:	55                   	push   %ebp
80107225:	89 e5                	mov    %esp,%ebp
80107227:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010722a:	e8 71 ff ff ff       	call   801071a0 <setupkvm>
8010722f:	a3 04 55 11 80       	mov    %eax,0x80115504
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107234:	05 00 00 00 80       	add    $0x80000000,%eax
80107239:	0f 22 d8             	mov    %eax,%cr3
}
8010723c:	c9                   	leave  
8010723d:	c3                   	ret    
8010723e:	66 90                	xchg   %ax,%ax

80107240 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107240:	f3 0f 1e fb          	endbr32 
80107244:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107245:	31 c9                	xor    %ecx,%ecx
{
80107247:	89 e5                	mov    %esp,%ebp
80107249:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010724c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010724f:	8b 45 08             	mov    0x8(%ebp),%eax
80107252:	e8 99 f8 ff ff       	call   80106af0 <walkpgdir>
  if(pte == 0)
80107257:	85 c0                	test   %eax,%eax
80107259:	74 05                	je     80107260 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010725b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010725e:	c9                   	leave  
8010725f:	c3                   	ret    
    panic("clearpteu");
80107260:	83 ec 0c             	sub    $0xc,%esp
80107263:	68 aa 7d 10 80       	push   $0x80107daa
80107268:	e8 a3 93 ff ff       	call   80100610 <panic>
8010726d:	8d 76 00             	lea    0x0(%esi),%esi

80107270 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107270:	f3 0f 1e fb          	endbr32 
80107274:	55                   	push   %ebp
80107275:	89 e5                	mov    %esp,%ebp
80107277:	57                   	push   %edi
80107278:	56                   	push   %esi
80107279:	53                   	push   %ebx
8010727a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010727d:	e8 1e ff ff ff       	call   801071a0 <setupkvm>
80107282:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107285:	85 c0                	test   %eax,%eax
80107287:	0f 84 9b 00 00 00    	je     80107328 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010728d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107290:	85 c9                	test   %ecx,%ecx
80107292:	0f 84 90 00 00 00    	je     80107328 <copyuvm+0xb8>
80107298:	31 f6                	xor    %esi,%esi
8010729a:	eb 46                	jmp    801072e2 <copyuvm+0x72>
8010729c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801072a0:	83 ec 04             	sub    $0x4,%esp
801072a3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801072a9:	68 00 10 00 00       	push   $0x1000
801072ae:	57                   	push   %edi
801072af:	50                   	push   %eax
801072b0:	e8 ab d7 ff ff       	call   80104a60 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801072b5:	58                   	pop    %eax
801072b6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072bc:	5a                   	pop    %edx
801072bd:	ff 75 e4             	pushl  -0x1c(%ebp)
801072c0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072c5:	89 f2                	mov    %esi,%edx
801072c7:	50                   	push   %eax
801072c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072cb:	e8 a0 f8 ff ff       	call   80106b70 <mappages>
801072d0:	83 c4 10             	add    $0x10,%esp
801072d3:	85 c0                	test   %eax,%eax
801072d5:	78 61                	js     80107338 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801072d7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801072dd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801072e0:	76 46                	jbe    80107328 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801072e2:	8b 45 08             	mov    0x8(%ebp),%eax
801072e5:	31 c9                	xor    %ecx,%ecx
801072e7:	89 f2                	mov    %esi,%edx
801072e9:	e8 02 f8 ff ff       	call   80106af0 <walkpgdir>
801072ee:	85 c0                	test   %eax,%eax
801072f0:	74 61                	je     80107353 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801072f2:	8b 00                	mov    (%eax),%eax
801072f4:	a8 01                	test   $0x1,%al
801072f6:	74 4e                	je     80107346 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801072f8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801072fa:	25 ff 0f 00 00       	and    $0xfff,%eax
801072ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107302:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107308:	e8 73 b6 ff ff       	call   80102980 <kalloc>
8010730d:	89 c3                	mov    %eax,%ebx
8010730f:	85 c0                	test   %eax,%eax
80107311:	75 8d                	jne    801072a0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107313:	83 ec 0c             	sub    $0xc,%esp
80107316:	ff 75 e0             	pushl  -0x20(%ebp)
80107319:	e8 02 fe ff ff       	call   80107120 <freevm>
  return 0;
8010731e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107325:	83 c4 10             	add    $0x10,%esp
}
80107328:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010732b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010732e:	5b                   	pop    %ebx
8010732f:	5e                   	pop    %esi
80107330:	5f                   	pop    %edi
80107331:	5d                   	pop    %ebp
80107332:	c3                   	ret    
80107333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107337:	90                   	nop
      kfree(mem);
80107338:	83 ec 0c             	sub    $0xc,%esp
8010733b:	53                   	push   %ebx
8010733c:	e8 7f b4 ff ff       	call   801027c0 <kfree>
      goto bad;
80107341:	83 c4 10             	add    $0x10,%esp
80107344:	eb cd                	jmp    80107313 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107346:	83 ec 0c             	sub    $0xc,%esp
80107349:	68 ce 7d 10 80       	push   $0x80107dce
8010734e:	e8 bd 92 ff ff       	call   80100610 <panic>
      panic("copyuvm: pte should exist");
80107353:	83 ec 0c             	sub    $0xc,%esp
80107356:	68 b4 7d 10 80       	push   $0x80107db4
8010735b:	e8 b0 92 ff ff       	call   80100610 <panic>

80107360 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107360:	f3 0f 1e fb          	endbr32 
80107364:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107365:	31 c9                	xor    %ecx,%ecx
{
80107367:	89 e5                	mov    %esp,%ebp
80107369:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010736c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010736f:	8b 45 08             	mov    0x8(%ebp),%eax
80107372:	e8 79 f7 ff ff       	call   80106af0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107377:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107379:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010737a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010737c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107381:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107384:	05 00 00 00 80       	add    $0x80000000,%eax
80107389:	83 fa 05             	cmp    $0x5,%edx
8010738c:	ba 00 00 00 00       	mov    $0x0,%edx
80107391:	0f 45 c2             	cmovne %edx,%eax
}
80107394:	c3                   	ret    
80107395:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010739c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801073a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801073a0:	f3 0f 1e fb          	endbr32 
801073a4:	55                   	push   %ebp
801073a5:	89 e5                	mov    %esp,%ebp
801073a7:	57                   	push   %edi
801073a8:	56                   	push   %esi
801073a9:	53                   	push   %ebx
801073aa:	83 ec 0c             	sub    $0xc,%esp
801073ad:	8b 75 14             	mov    0x14(%ebp),%esi
801073b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801073b3:	85 f6                	test   %esi,%esi
801073b5:	75 3c                	jne    801073f3 <copyout+0x53>
801073b7:	eb 67                	jmp    80107420 <copyout+0x80>
801073b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801073c0:	8b 55 0c             	mov    0xc(%ebp),%edx
801073c3:	89 fb                	mov    %edi,%ebx
801073c5:	29 d3                	sub    %edx,%ebx
801073c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801073cd:	39 f3                	cmp    %esi,%ebx
801073cf:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801073d2:	29 fa                	sub    %edi,%edx
801073d4:	83 ec 04             	sub    $0x4,%esp
801073d7:	01 c2                	add    %eax,%edx
801073d9:	53                   	push   %ebx
801073da:	ff 75 10             	pushl  0x10(%ebp)
801073dd:	52                   	push   %edx
801073de:	e8 7d d6 ff ff       	call   80104a60 <memmove>
    len -= n;
    buf += n;
801073e3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801073e6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801073ec:	83 c4 10             	add    $0x10,%esp
801073ef:	29 de                	sub    %ebx,%esi
801073f1:	74 2d                	je     80107420 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801073f3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801073f5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801073f8:	89 55 0c             	mov    %edx,0xc(%ebp)
801073fb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107401:	57                   	push   %edi
80107402:	ff 75 08             	pushl  0x8(%ebp)
80107405:	e8 56 ff ff ff       	call   80107360 <uva2ka>
    if(pa0 == 0)
8010740a:	83 c4 10             	add    $0x10,%esp
8010740d:	85 c0                	test   %eax,%eax
8010740f:	75 af                	jne    801073c0 <copyout+0x20>
  }
  return 0;
}
80107411:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107414:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107419:	5b                   	pop    %ebx
8010741a:	5e                   	pop    %esi
8010741b:	5f                   	pop    %edi
8010741c:	5d                   	pop    %ebp
8010741d:	c3                   	ret    
8010741e:	66 90                	xchg   %ax,%ax
80107420:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107423:	31 c0                	xor    %eax,%eax
}
80107425:	5b                   	pop    %ebx
80107426:	5e                   	pop    %esi
80107427:	5f                   	pop    %edi
80107428:	5d                   	pop    %ebp
80107429:	c3                   	ret    
