
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
8010002d:	b8 20 35 10 80       	mov    $0x80103520,%eax
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
80100050:	68 c0 75 10 80       	push   $0x801075c0
80100055:	68 e0 b5 10 80       	push   $0x8010b5e0
8010005a:	e8 61 48 00 00       	call   801048c0 <initlock>
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
80100092:	68 c7 75 10 80       	push   $0x801075c7
80100097:	50                   	push   %eax
80100098:	e8 e3 46 00 00       	call   80104780 <initsleeplock>
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
801000e8:	e8 53 49 00 00       	call   80104a40 <acquire>
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
80100162:	e8 99 49 00 00       	call   80104b00 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 46 00 00       	call   801047c0 <acquiresleep>
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
8010018c:	e8 cf 25 00 00       	call   80102760 <iderw>
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
801001a3:	68 ce 75 10 80       	push   $0x801075ce
801001a8:	e8 53 05 00 00       	call   80100700 <panic>
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
801001c2:	e8 99 46 00 00       	call   80104860 <holdingsleep>
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
801001d8:	e9 83 25 00 00       	jmp    80102760 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 df 75 10 80       	push   $0x801075df
801001e5:	e8 16 05 00 00       	call   80100700 <panic>
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
80100203:	e8 58 46 00 00       	call   80104860 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 08 46 00 00       	call   80104820 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010021f:	e8 1c 48 00 00       	call   80104a40 <acquire>
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
80100270:	e9 8b 48 00 00       	jmp    80104b00 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 e6 75 10 80       	push   $0x801075e6
8010027d:	e8 7e 04 00 00       	call   80100700 <panic>
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
801002a5:	e8 76 1a 00 00       	call   80101d20 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801002b1:	e8 8a 47 00 00       	call   80104a40 <acquire>
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
801002c6:	a1 f4 07 11 80       	mov    0x801107f4,%eax
801002cb:	3b 05 f8 07 11 80    	cmp    0x801107f8,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 40 a5 10 80       	push   $0x8010a540
801002e0:	68 f4 07 11 80       	push   $0x801107f4
801002e5:	e8 16 41 00 00       	call   80104400 <sleep>
    while(input.r == input.w){
801002ea:	a1 f4 07 11 80       	mov    0x801107f4,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 f8 07 11 80    	cmp    0x801107f8,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 41 3b 00 00       	call   80103e40 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 40 a5 10 80       	push   $0x8010a540
8010030e:	e8 ed 47 00 00       	call   80104b00 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 24 19 00 00       	call   80101c40 <ilock>
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
80100333:	89 15 f4 07 11 80    	mov    %edx,0x801107f4
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 74 07 11 80 	movsbl -0x7feef88c(%edx),%ecx
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
80100365:	e8 96 47 00 00       	call   80104b00 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 cd 18 00 00       	call   80101c40 <ilock>
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
80100386:	a3 f4 07 11 80       	mov    %eax,0x801107f4
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
801003aa:	e8 11 5e 00 00       	call   801061c0 <uartputc>
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
801004a2:	e8 49 47 00 00       	call   80104bf0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004a7:	b8 80 07 00 00       	mov    $0x780,%eax
801004ac:	83 c4 0c             	add    $0xc,%esp
801004af:	29 d8                	sub    %ebx,%eax
801004b1:	01 c0                	add    %eax,%eax
801004b3:	50                   	push   %eax
801004b4:	6a 00                	push   $0x0
801004b6:	56                   	push   %esi
801004b7:	e8 94 46 00 00       	call   80104b50 <memset>
801004bc:	88 5d e7             	mov    %bl,-0x19(%ebp)
801004bf:	83 c4 10             	add    $0x10,%esp
801004c2:	e9 51 ff ff ff       	jmp    80100418 <consputc.part.0+0x88>
801004c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801004ce:	66 90                	xchg   %ax,%ax
    uartputc('\b'); 
801004d0:	83 ec 0c             	sub    $0xc,%esp
801004d3:	6a 08                	push   $0x8
801004d5:	e8 e6 5c 00 00       	call   801061c0 <uartputc>
    uartputc(' '); 
801004da:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004e1:	e8 da 5c 00 00       	call   801061c0 <uartputc>
    uartputc('\b');
801004e6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004ed:	e8 ce 5c 00 00       	call   801061c0 <uartputc>
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
80100529:	0f b6 92 20 76 10 80 	movzbl -0x7fef89e0(%edx),%edx
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
801005b3:	e8 68 17 00 00       	call   80101d20 <iunlock>
  acquire(&cons.lock);
801005b8:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801005bf:	e8 7c 44 00 00       	call   80104a40 <acquire>
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
801005f7:	e8 04 45 00 00       	call   80104b00 <release>
  ilock(ip);
801005fc:	58                   	pop    %eax
801005fd:	ff 75 08             	pushl  0x8(%ebp)
80100600:	e8 3b 16 00 00       	call   80101c40 <ilock>

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

80100610 <addHistory.part.0>:
void addHistory(char *command){
80100610:	55                   	push   %ebp
80100611:	89 e5                	mov    %esp,%ebp
80100613:	57                   	push   %edi
80100614:	56                   	push   %esi
80100615:	89 c6                	mov    %eax,%esi
80100617:	53                   	push   %ebx
80100618:	83 ec 28             	sub    $0x28,%esp
    int length = strlen(command) <= MAX_COMMAND_LENGTH ? strlen(command) : MAX_COMMAND_LENGTH-1;
8010061b:	50                   	push   %eax
8010061c:	e8 2f 47 00 00       	call   80104d50 <strlen>
80100621:	c7 45 e0 7f 00 00 00 	movl   $0x7f,-0x20(%ebp)
80100628:	83 c4 10             	add    $0x10,%esp
8010062b:	c7 45 e4 7f 00 00 00 	movl   $0x7f,-0x1c(%ebp)
80100632:	3d 80 00 00 00       	cmp    $0x80,%eax
80100637:	0f 8e 8b 00 00 00    	jle    801006c8 <addHistory.part.0+0xb8>
    if(commandHistoryCounter < MAX_HISTORY){
8010063d:	a1 28 a5 10 80       	mov    0x8010a528,%eax
80100642:	83 f8 0f             	cmp    $0xf,%eax
80100645:	7f 49                	jg     80100690 <addHistory.part.0+0x80>
      commandHistoryCounter++;
80100647:	8d 50 01             	lea    0x1(%eax),%edx
8010064a:	89 15 28 a5 10 80    	mov    %edx,0x8010a528
    memmove(commandHistory[commandHistoryCounter-1], command, sizeof(char)* length);
80100650:	c1 e0 07             	shl    $0x7,%eax
80100653:	83 ec 04             	sub    $0x4,%esp
80100656:	ff 75 e0             	pushl  -0x20(%ebp)
80100659:	05 40 ff 10 80       	add    $0x8010ff40,%eax
8010065e:	56                   	push   %esi
8010065f:	50                   	push   %eax
80100660:	e8 8b 45 00 00       	call   80104bf0 <memmove>
    commandHistory[commandHistoryCounter-1][length] = '\0';
80100665:	a1 28 a5 10 80       	mov    0x8010a528,%eax
8010066a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
}
8010066d:	83 c4 10             	add    $0x10,%esp
    commandHistory[commandHistoryCounter-1][length] = '\0';
80100670:	83 e8 01             	sub    $0x1,%eax
80100673:	89 c2                	mov    %eax,%edx
    currentCommandId = commandHistoryCounter - 1;
80100675:	a3 24 a5 10 80       	mov    %eax,0x8010a524
    commandHistory[commandHistoryCounter-1][length] = '\0';
8010067a:	c1 e2 07             	shl    $0x7,%edx
8010067d:	c6 84 11 40 ff 10 80 	movb   $0x0,-0x7fef00c0(%ecx,%edx,1)
80100684:	00 
}
80100685:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100688:	5b                   	pop    %ebx
80100689:	5e                   	pop    %esi
8010068a:	5f                   	pop    %edi
8010068b:	5d                   	pop    %ebp
8010068c:	c3                   	ret    
8010068d:	8d 76 00             	lea    0x0(%esi),%esi
80100690:	bf 40 ff 10 80       	mov    $0x8010ff40,%edi
80100695:	bb c0 06 11 80       	mov    $0x801106c0,%ebx
8010069a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        memmove(commandHistory[i], commandHistory[i+1], sizeof(char)* MAX_COMMAND_LENGTH);
801006a0:	83 ec 04             	sub    $0x4,%esp
801006a3:	89 f8                	mov    %edi,%eax
801006a5:	83 ef 80             	sub    $0xffffff80,%edi
801006a8:	68 80 00 00 00       	push   $0x80
801006ad:	57                   	push   %edi
801006ae:	50                   	push   %eax
801006af:	e8 3c 45 00 00       	call   80104bf0 <memmove>
      for(i = 0; i < MAX_HISTORY - 1; i++){
801006b4:	83 c4 10             	add    $0x10,%esp
801006b7:	39 fb                	cmp    %edi,%ebx
801006b9:	75 e5                	jne    801006a0 <addHistory.part.0+0x90>
801006bb:	a1 28 a5 10 80       	mov    0x8010a528,%eax
801006c0:	83 e8 01             	sub    $0x1,%eax
801006c3:	eb 8b                	jmp    80100650 <addHistory.part.0+0x40>
801006c5:	8d 76 00             	lea    0x0(%esi),%esi
    int length = strlen(command) <= MAX_COMMAND_LENGTH ? strlen(command) : MAX_COMMAND_LENGTH-1;
801006c8:	83 ec 0c             	sub    $0xc,%esp
801006cb:	56                   	push   %esi
801006cc:	e8 7f 46 00 00       	call   80104d50 <strlen>
801006d1:	83 c4 10             	add    $0x10,%esp
801006d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
801006da:	e9 5e ff ff ff       	jmp    8010063d <addHistory.part.0+0x2d>
801006df:	90                   	nop

801006e0 <addHistory>:
void addHistory(char *command){
801006e0:	f3 0f 1e fb          	endbr32 
801006e4:	55                   	push   %ebp
801006e5:	89 e5                	mov    %esp,%ebp
801006e7:	8b 45 08             	mov    0x8(%ebp),%eax
if(command[0]!='\0')
801006ea:	80 38 00             	cmpb   $0x0,(%eax)
801006ed:	75 09                	jne    801006f8 <addHistory+0x18>
}
801006ef:	5d                   	pop    %ebp
801006f0:	c3                   	ret    
801006f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006f8:	5d                   	pop    %ebp
801006f9:	e9 12 ff ff ff       	jmp    80100610 <addHistory.part.0>
801006fe:	66 90                	xchg   %ax,%ax

80100700 <panic>:
{
80100700:	f3 0f 1e fb          	endbr32 
80100704:	55                   	push   %ebp
80100705:	89 e5                	mov    %esp,%ebp
80100707:	56                   	push   %esi
80100708:	53                   	push   %ebx
80100709:	83 ec 30             	sub    $0x30,%esp
8010070c:	fa                   	cli    
  cons.locking = 0;
8010070d:	c7 05 74 a5 10 80 00 	movl   $0x0,0x8010a574
80100714:	00 00 00 
  getcallerpcs(&s, pcs);
80100717:	8d 5d d0             	lea    -0x30(%ebp),%ebx
8010071a:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
8010071d:	e8 5e 26 00 00       	call   80102d80 <lapicid>
80100722:	83 ec 08             	sub    $0x8,%esp
80100725:	50                   	push   %eax
80100726:	68 ed 75 10 80       	push   $0x801075ed
8010072b:	e8 50 00 00 00       	call   80100780 <cprintf>
  cprintf(s);
80100730:	58                   	pop    %eax
80100731:	ff 75 08             	pushl  0x8(%ebp)
80100734:	e8 47 00 00 00       	call   80100780 <cprintf>
  cprintf("\n");
80100739:	c7 04 24 17 7f 10 80 	movl   $0x80107f17,(%esp)
80100740:	e8 3b 00 00 00       	call   80100780 <cprintf>
  getcallerpcs(&s, pcs);
80100745:	8d 45 08             	lea    0x8(%ebp),%eax
80100748:	5a                   	pop    %edx
80100749:	59                   	pop    %ecx
8010074a:	53                   	push   %ebx
8010074b:	50                   	push   %eax
8010074c:	e8 8f 41 00 00       	call   801048e0 <getcallerpcs>
  for(i=0; i<10; i++)
80100751:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100754:	83 ec 08             	sub    $0x8,%esp
80100757:	ff 33                	pushl  (%ebx)
80100759:	83 c3 04             	add    $0x4,%ebx
8010075c:	68 01 76 10 80       	push   $0x80107601
80100761:	e8 1a 00 00 00       	call   80100780 <cprintf>
  for(i=0; i<10; i++)
80100766:	83 c4 10             	add    $0x10,%esp
80100769:	39 f3                	cmp    %esi,%ebx
8010076b:	75 e7                	jne    80100754 <panic+0x54>
  panicked = 1; // freeze other CPU
8010076d:	c7 05 78 a5 10 80 01 	movl   $0x1,0x8010a578
80100774:	00 00 00 
  for(;;)
80100777:	eb fe                	jmp    80100777 <panic+0x77>
80100779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100780 <cprintf>:
{
80100780:	f3 0f 1e fb          	endbr32 
80100784:	55                   	push   %ebp
80100785:	89 e5                	mov    %esp,%ebp
80100787:	57                   	push   %edi
80100788:	56                   	push   %esi
80100789:	53                   	push   %ebx
8010078a:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
8010078d:	a1 74 a5 10 80       	mov    0x8010a574,%eax
80100792:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100795:	85 c0                	test   %eax,%eax
80100797:	0f 85 e8 00 00 00    	jne    80100885 <cprintf+0x105>
  if (fmt == 0)
8010079d:	8b 45 08             	mov    0x8(%ebp),%eax
801007a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007a3:	85 c0                	test   %eax,%eax
801007a5:	0f 84 5a 01 00 00    	je     80100905 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007ab:	0f b6 00             	movzbl (%eax),%eax
801007ae:	85 c0                	test   %eax,%eax
801007b0:	74 36                	je     801007e8 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801007b2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801007b7:	83 f8 25             	cmp    $0x25,%eax
801007ba:	74 44                	je     80100800 <cprintf+0x80>
  if(panicked){
801007bc:	8b 0d 78 a5 10 80    	mov    0x8010a578,%ecx
801007c2:	85 c9                	test   %ecx,%ecx
801007c4:	74 0f                	je     801007d5 <cprintf+0x55>
801007c6:	fa                   	cli    
    for(;;)
801007c7:	eb fe                	jmp    801007c7 <cprintf+0x47>
801007c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007d0:	b8 25 00 00 00       	mov    $0x25,%eax
801007d5:	e8 b6 fb ff ff       	call   80100390 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801007dd:	83 c6 01             	add    $0x1,%esi
801007e0:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
801007e4:	85 c0                	test   %eax,%eax
801007e6:	75 cf                	jne    801007b7 <cprintf+0x37>
  if(locking)
801007e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 fd 00 00 00    	jne    801008f0 <cprintf+0x170>
}
801007f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801007f6:	5b                   	pop    %ebx
801007f7:	5e                   	pop    %esi
801007f8:	5f                   	pop    %edi
801007f9:	5d                   	pop    %ebp
801007fa:	c3                   	ret    
801007fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801007ff:	90                   	nop
    c = fmt[++i] & 0xff;
80100800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100803:	83 c6 01             	add    $0x1,%esi
80100806:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010080a:	85 ff                	test   %edi,%edi
8010080c:	74 da                	je     801007e8 <cprintf+0x68>
    switch(c){
8010080e:	83 ff 70             	cmp    $0x70,%edi
80100811:	74 5a                	je     8010086d <cprintf+0xed>
80100813:	7f 2a                	jg     8010083f <cprintf+0xbf>
80100815:	83 ff 25             	cmp    $0x25,%edi
80100818:	0f 84 92 00 00 00    	je     801008b0 <cprintf+0x130>
8010081e:	83 ff 64             	cmp    $0x64,%edi
80100821:	0f 85 a1 00 00 00    	jne    801008c8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100827:	8b 03                	mov    (%ebx),%eax
80100829:	8d 7b 04             	lea    0x4(%ebx),%edi
8010082c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100831:	ba 0a 00 00 00       	mov    $0xa,%edx
80100836:	89 fb                	mov    %edi,%ebx
80100838:	e8 c3 fc ff ff       	call   80100500 <printint>
      break;
8010083d:	eb 9b                	jmp    801007da <cprintf+0x5a>
    switch(c){
8010083f:	83 ff 73             	cmp    $0x73,%edi
80100842:	75 24                	jne    80100868 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100844:	8d 7b 04             	lea    0x4(%ebx),%edi
80100847:	8b 1b                	mov    (%ebx),%ebx
80100849:	85 db                	test   %ebx,%ebx
8010084b:	75 55                	jne    801008a2 <cprintf+0x122>
        s = "(null)";
8010084d:	bb 05 76 10 80       	mov    $0x80107605,%ebx
      for(; *s; s++)
80100852:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100857:	8b 15 78 a5 10 80    	mov    0x8010a578,%edx
8010085d:	85 d2                	test   %edx,%edx
8010085f:	74 39                	je     8010089a <cprintf+0x11a>
80100861:	fa                   	cli    
    for(;;)
80100862:	eb fe                	jmp    80100862 <cprintf+0xe2>
80100864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100868:	83 ff 78             	cmp    $0x78,%edi
8010086b:	75 5b                	jne    801008c8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010086d:	8b 03                	mov    (%ebx),%eax
8010086f:	8d 7b 04             	lea    0x4(%ebx),%edi
80100872:	31 c9                	xor    %ecx,%ecx
80100874:	ba 10 00 00 00       	mov    $0x10,%edx
80100879:	89 fb                	mov    %edi,%ebx
8010087b:	e8 80 fc ff ff       	call   80100500 <printint>
      break;
80100880:	e9 55 ff ff ff       	jmp    801007da <cprintf+0x5a>
    acquire(&cons.lock);
80100885:	83 ec 0c             	sub    $0xc,%esp
80100888:	68 40 a5 10 80       	push   $0x8010a540
8010088d:	e8 ae 41 00 00       	call   80104a40 <acquire>
80100892:	83 c4 10             	add    $0x10,%esp
80100895:	e9 03 ff ff ff       	jmp    8010079d <cprintf+0x1d>
8010089a:	e8 f1 fa ff ff       	call   80100390 <consputc.part.0>
      for(; *s; s++)
8010089f:	83 c3 01             	add    $0x1,%ebx
801008a2:	0f be 03             	movsbl (%ebx),%eax
801008a5:	84 c0                	test   %al,%al
801008a7:	75 ae                	jne    80100857 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801008a9:	89 fb                	mov    %edi,%ebx
801008ab:	e9 2a ff ff ff       	jmp    801007da <cprintf+0x5a>
  if(panicked){
801008b0:	8b 3d 78 a5 10 80    	mov    0x8010a578,%edi
801008b6:	85 ff                	test   %edi,%edi
801008b8:	0f 84 12 ff ff ff    	je     801007d0 <cprintf+0x50>
801008be:	fa                   	cli    
    for(;;)
801008bf:	eb fe                	jmp    801008bf <cprintf+0x13f>
801008c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801008c8:	8b 0d 78 a5 10 80    	mov    0x8010a578,%ecx
801008ce:	85 c9                	test   %ecx,%ecx
801008d0:	74 06                	je     801008d8 <cprintf+0x158>
801008d2:	fa                   	cli    
    for(;;)
801008d3:	eb fe                	jmp    801008d3 <cprintf+0x153>
801008d5:	8d 76 00             	lea    0x0(%esi),%esi
801008d8:	b8 25 00 00 00       	mov    $0x25,%eax
801008dd:	e8 ae fa ff ff       	call   80100390 <consputc.part.0>
  if(panicked){
801008e2:	8b 15 78 a5 10 80    	mov    0x8010a578,%edx
801008e8:	85 d2                	test   %edx,%edx
801008ea:	74 2c                	je     80100918 <cprintf+0x198>
801008ec:	fa                   	cli    
    for(;;)
801008ed:	eb fe                	jmp    801008ed <cprintf+0x16d>
801008ef:	90                   	nop
    release(&cons.lock);
801008f0:	83 ec 0c             	sub    $0xc,%esp
801008f3:	68 40 a5 10 80       	push   $0x8010a540
801008f8:	e8 03 42 00 00       	call   80104b00 <release>
801008fd:	83 c4 10             	add    $0x10,%esp
}
80100900:	e9 ee fe ff ff       	jmp    801007f3 <cprintf+0x73>
    panic("null fmt");
80100905:	83 ec 0c             	sub    $0xc,%esp
80100908:	68 0c 76 10 80       	push   $0x8010760c
8010090d:	e8 ee fd ff ff       	call   80100700 <panic>
80100912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100918:	89 f8                	mov    %edi,%eax
8010091a:	e8 71 fa ff ff       	call   80100390 <consputc.part.0>
8010091f:	e9 b6 fe ff ff       	jmp    801007da <cprintf+0x5a>
80100924:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010092b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010092f:	90                   	nop

80100930 <vga_move_back_cursor>:
void vga_move_back_cursor(){
80100930:	f3 0f 1e fb          	endbr32 
80100934:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100935:	b8 0e 00 00 00       	mov    $0xe,%eax
8010093a:	89 e5                	mov    %esp,%ebp
8010093c:	57                   	push   %edi
8010093d:	56                   	push   %esi
8010093e:	be d4 03 00 00       	mov    $0x3d4,%esi
80100943:	53                   	push   %ebx
80100944:	89 f2                	mov    %esi,%edx
80100946:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100947:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010094c:	89 da                	mov    %ebx,%edx
8010094e:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010094f:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT+1) << 8;
80100954:	0f b6 c8             	movzbl %al,%ecx
80100957:	89 f2                	mov    %esi,%edx
80100959:	c1 e1 08             	shl    $0x8,%ecx
8010095c:	89 f8                	mov    %edi,%eax
8010095e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010095f:	89 da                	mov    %ebx,%edx
80100961:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100962:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100965:	89 f2                	mov    %esi,%edx
80100967:	09 c1                	or     %eax,%ecx
80100969:	89 f8                	mov    %edi,%eax
  pos--;
8010096b:	83 e9 01             	sub    $0x1,%ecx
8010096e:	ee                   	out    %al,(%dx)
8010096f:	89 c8                	mov    %ecx,%eax
80100971:	89 da                	mov    %ebx,%edx
80100973:	ee                   	out    %al,(%dx)
80100974:	b8 0e 00 00 00       	mov    $0xe,%eax
80100979:	89 f2                	mov    %esi,%edx
8010097b:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
8010097c:	89 c8                	mov    %ecx,%eax
8010097e:	89 da                	mov    %ebx,%edx
80100980:	c1 f8 08             	sar    $0x8,%eax
80100983:	ee                   	out    %al,(%dx)
}
80100984:	5b                   	pop    %ebx
80100985:	5e                   	pop    %esi
80100986:	5f                   	pop    %edi
80100987:	5d                   	pop    %ebp
80100988:	c3                   	ret    
80100989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100990 <vga_move_forward_cursor>:
void vga_move_forward_cursor(){
80100990:	f3 0f 1e fb          	endbr32 
80100994:	55                   	push   %ebp
80100995:	b8 0e 00 00 00       	mov    $0xe,%eax
8010099a:	89 e5                	mov    %esp,%ebp
8010099c:	57                   	push   %edi
8010099d:	56                   	push   %esi
8010099e:	be d4 03 00 00       	mov    $0x3d4,%esi
801009a3:	53                   	push   %ebx
801009a4:	89 f2                	mov    %esi,%edx
801009a6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801009a7:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801009ac:	89 da                	mov    %ebx,%edx
801009ae:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801009af:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT+1) << 8;
801009b4:	0f b6 c8             	movzbl %al,%ecx
801009b7:	89 f2                	mov    %esi,%edx
801009b9:	c1 e1 08             	shl    $0x8,%ecx
801009bc:	89 f8                	mov    %edi,%eax
801009be:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801009bf:	89 da                	mov    %ebx,%edx
801009c1:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
801009c2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801009c5:	89 f2                	mov    %esi,%edx
801009c7:	09 c1                	or     %eax,%ecx
801009c9:	89 f8                	mov    %edi,%eax
  pos++;
801009cb:	83 c1 01             	add    $0x1,%ecx
801009ce:	ee                   	out    %al,(%dx)
801009cf:	89 c8                	mov    %ecx,%eax
801009d1:	89 da                	mov    %ebx,%edx
801009d3:	ee                   	out    %al,(%dx)
801009d4:	b8 0e 00 00 00       	mov    $0xe,%eax
801009d9:	89 f2                	mov    %esi,%edx
801009db:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
801009dc:	89 c8                	mov    %ecx,%eax
801009de:	89 da                	mov    %ebx,%edx
801009e0:	c1 f8 08             	sar    $0x8,%eax
801009e3:	ee                   	out    %al,(%dx)
}
801009e4:	5b                   	pop    %ebx
801009e5:	5e                   	pop    %esi
801009e6:	5f                   	pop    %edi
801009e7:	5d                   	pop    %ebp
801009e8:	c3                   	ret    
801009e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801009f0 <vga_insert_char>:
void vga_insert_char(int c, int back_counter){
801009f0:	f3 0f 1e fb          	endbr32 
801009f4:	55                   	push   %ebp
801009f5:	b8 0e 00 00 00       	mov    $0xe,%eax
801009fa:	89 e5                	mov    %esp,%ebp
801009fc:	57                   	push   %edi
801009fd:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100a02:	56                   	push   %esi
80100a03:	89 fa                	mov    %edi,%edx
80100a05:	53                   	push   %ebx
80100a06:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100a09:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100a0a:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100a0f:	89 ca                	mov    %ecx,%edx
80100a11:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100a12:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a15:	89 fa                	mov    %edi,%edx
80100a17:	c1 e0 08             	shl    $0x8,%eax
80100a1a:	89 c6                	mov    %eax,%esi
80100a1c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100a21:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100a22:	89 ca                	mov    %ecx,%edx
80100a24:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100a25:	0f b6 c0             	movzbl %al,%eax
80100a28:	09 f0                	or     %esi,%eax
  for(int i = pos + back_counter; i >= pos; i--){
80100a2a:	8d 14 18             	lea    (%eax,%ebx,1),%edx
80100a2d:	39 d0                	cmp    %edx,%eax
80100a2f:	7f 1d                	jg     80100a4e <vga_insert_char+0x5e>
80100a31:	8d 94 12 00 80 0b 80 	lea    -0x7ff48000(%edx,%edx,1),%edx
80100a38:	8d b4 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%esi
80100a3f:	90                   	nop
    crt[i+1] = crt[i];
80100a40:	0f b7 0a             	movzwl (%edx),%ecx
80100a43:	83 ea 02             	sub    $0x2,%edx
80100a46:	66 89 4a 04          	mov    %cx,0x4(%edx)
  for(int i = pos + back_counter; i >= pos; i--){
80100a4a:	39 d6                	cmp    %edx,%esi
80100a4c:	75 f2                	jne    80100a40 <vga_insert_char+0x50>
  crt[pos] = (c&0xff) | 0x0700;  
80100a4e:	0f b6 55 08          	movzbl 0x8(%ebp),%edx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a52:	bf d4 03 00 00       	mov    $0x3d4,%edi
  pos += 1;
80100a57:	8d 48 01             	lea    0x1(%eax),%ecx
  crt[pos] = (c&0xff) | 0x0700;  
80100a5a:	80 ce 07             	or     $0x7,%dh
80100a5d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100a64:	80 
80100a65:	b8 0e 00 00 00       	mov    $0xe,%eax
80100a6a:	89 fa                	mov    %edi,%edx
80100a6c:	ee                   	out    %al,(%dx)
80100a6d:	be d5 03 00 00       	mov    $0x3d5,%esi
  outb(CRTPORT+1, pos>>8);
80100a72:	89 c8                	mov    %ecx,%eax
80100a74:	c1 f8 08             	sar    $0x8,%eax
80100a77:	89 f2                	mov    %esi,%edx
80100a79:	ee                   	out    %al,(%dx)
80100a7a:	b8 0f 00 00 00       	mov    $0xf,%eax
80100a7f:	89 fa                	mov    %edi,%edx
80100a81:	ee                   	out    %al,(%dx)
80100a82:	89 c8                	mov    %ecx,%eax
80100a84:	89 f2                	mov    %esi,%edx
80100a86:	ee                   	out    %al,(%dx)
  crt[pos+back_counter] = ' ' | 0x0700;
80100a87:	b8 20 07 00 00       	mov    $0x720,%eax
80100a8c:	01 cb                	add    %ecx,%ebx
80100a8e:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100a95:	80 
}
80100a96:	5b                   	pop    %ebx
80100a97:	5e                   	pop    %esi
80100a98:	5f                   	pop    %edi
80100a99:	5d                   	pop    %ebp
80100a9a:	c3                   	ret    
80100a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a9f:	90                   	nop

80100aa0 <vga_remove_char>:
void vga_remove_char(){
80100aa0:	f3 0f 1e fb          	endbr32 
80100aa4:	55                   	push   %ebp
80100aa5:	b8 0e 00 00 00       	mov    $0xe,%eax
80100aaa:	89 e5                	mov    %esp,%ebp
80100aac:	57                   	push   %edi
80100aad:	56                   	push   %esi
80100aae:	be d4 03 00 00       	mov    $0x3d4,%esi
80100ab3:	53                   	push   %ebx
80100ab4:	89 f2                	mov    %esi,%edx
80100ab6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100ab7:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100abc:	89 da                	mov    %ebx,%edx
80100abe:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100abf:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT+1) << 8;
80100ac4:	0f b6 c8             	movzbl %al,%ecx
80100ac7:	89 f2                	mov    %esi,%edx
80100ac9:	c1 e1 08             	shl    $0x8,%ecx
80100acc:	89 f8                	mov    %edi,%eax
80100ace:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100acf:	89 da                	mov    %ebx,%edx
80100ad1:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100ad2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100ad5:	89 f2                	mov    %esi,%edx
80100ad7:	09 c1                	or     %eax,%ecx
80100ad9:	89 f8                	mov    %edi,%eax
  pos--;
80100adb:	83 e9 01             	sub    $0x1,%ecx
80100ade:	ee                   	out    %al,(%dx)
80100adf:	89 c8                	mov    %ecx,%eax
80100ae1:	89 da                	mov    %ebx,%edx
80100ae3:	ee                   	out    %al,(%dx)
80100ae4:	b8 0e 00 00 00       	mov    $0xe,%eax
80100ae9:	89 f2                	mov    %esi,%edx
80100aeb:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
80100aec:	89 c8                	mov    %ecx,%eax
80100aee:	89 da                	mov    %ebx,%edx
80100af0:	c1 f8 08             	sar    $0x8,%eax
80100af3:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
80100af4:	b8 20 07 00 00       	mov    $0x720,%eax
80100af9:	66 89 84 09 00 80 0b 	mov    %ax,-0x7ff48000(%ecx,%ecx,1)
80100b00:	80 
}
80100b01:	5b                   	pop    %ebx
80100b02:	5e                   	pop    %esi
80100b03:	5f                   	pop    %edi
80100b04:	5d                   	pop    %ebp
80100b05:	c3                   	ret    
80100b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b0d:	8d 76 00             	lea    0x0(%esi),%esi

80100b10 <consoleintr>:
{
80100b10:	f3 0f 1e fb          	endbr32 
80100b14:	55                   	push   %ebp
80100b15:	89 e5                	mov    %esp,%ebp
80100b17:	57                   	push   %edi
80100b18:	56                   	push   %esi
80100b19:	53                   	push   %ebx
80100b1a:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  acquire(&cons.lock);
80100b20:	68 40 a5 10 80       	push   $0x8010a540
80100b25:	e8 16 3f 00 00       	call   80104a40 <acquire>
  while((c = getc()) >= 0){
80100b2a:	83 c4 10             	add    $0x10,%esp
80100b2d:	ff 55 08             	call   *0x8(%ebp)
80100b30:	89 c3                	mov    %eax,%ebx
80100b32:	85 c0                	test   %eax,%eax
80100b34:	0f 88 45 02 00 00    	js     80100d7f <consoleintr+0x26f>
    switch(c){
80100b3a:	83 fb 7f             	cmp    $0x7f,%ebx
80100b3d:	0f 84 77 01 00 00    	je     80100cba <consoleintr+0x1aa>
80100b43:	0f 8f 07 01 00 00    	jg     80100c50 <consoleintr+0x140>
80100b49:	83 fb 10             	cmp    $0x10,%ebx
80100b4c:	0f 84 14 02 00 00    	je     80100d66 <consoleintr+0x256>
80100b52:	83 fb 15             	cmp    $0x15,%ebx
80100b55:	75 39                	jne    80100b90 <consoleintr+0x80>
      while(input.e != input.w &&
80100b57:	a1 fc 07 11 80       	mov    0x801107fc,%eax
80100b5c:	3b 05 f8 07 11 80    	cmp    0x801107f8,%eax
80100b62:	74 c9                	je     80100b2d <consoleintr+0x1d>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100b64:	83 e8 01             	sub    $0x1,%eax
80100b67:	89 c2                	mov    %eax,%edx
80100b69:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100b6c:	80 ba 74 07 11 80 0a 	cmpb   $0xa,-0x7feef88c(%edx)
80100b73:	74 b8                	je     80100b2d <consoleintr+0x1d>
  if(panicked){
80100b75:	8b 1d 78 a5 10 80    	mov    0x8010a578,%ebx
        input.e--;
80100b7b:	a3 fc 07 11 80       	mov    %eax,0x801107fc
  if(panicked){
80100b80:	85 db                	test   %ebx,%ebx
80100b82:	0f 84 cf 01 00 00    	je     80100d57 <consoleintr+0x247>
  asm volatile("cli");
80100b88:	fa                   	cli    
    for(;;)
80100b89:	eb fe                	jmp    80100b89 <consoleintr+0x79>
80100b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b8f:	90                   	nop
    switch(c){
80100b90:	83 fb 08             	cmp    $0x8,%ebx
80100b93:	0f 84 21 01 00 00    	je     80100cba <consoleintr+0x1aa>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100b99:	85 db                	test   %ebx,%ebx
80100b9b:	74 90                	je     80100b2d <consoleintr+0x1d>
80100b9d:	a1 fc 07 11 80       	mov    0x801107fc,%eax
80100ba2:	2b 05 f4 07 11 80    	sub    0x801107f4,%eax
80100ba8:	83 f8 7f             	cmp    $0x7f,%eax
80100bab:	77 80                	ja     80100b2d <consoleintr+0x1d>
        uartputc('-');
80100bad:	83 ec 0c             	sub    $0xc,%esp
80100bb0:	6a 2d                	push   $0x2d
80100bb2:	e8 09 56 00 00       	call   801061c0 <uartputc>
        uartputc(c); 
80100bb7:	89 1c 24             	mov    %ebx,(%esp)
80100bba:	e8 01 56 00 00       	call   801061c0 <uartputc>
        c = (c == '\r') ? '\n' : c;
80100bbf:	a1 fc 07 11 80       	mov    0x801107fc,%eax
80100bc4:	83 c4 10             	add    $0x10,%esp
80100bc7:	83 fb 0d             	cmp    $0xd,%ebx
80100bca:	0f 84 c7 01 00 00    	je     80100d97 <consoleintr+0x287>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100bd0:	88 9d 64 ff ff ff    	mov    %bl,-0x9c(%ebp)
80100bd6:	8d 48 01             	lea    0x1(%eax),%ecx
80100bd9:	83 fb 0a             	cmp    $0xa,%ebx
80100bdc:	0f 84 c4 01 00 00    	je     80100da6 <consoleintr+0x296>
80100be2:	83 fb 04             	cmp    $0x4,%ebx
80100be5:	0f 84 bb 01 00 00    	je     80100da6 <consoleintr+0x296>
80100beb:	8b 3d f4 07 11 80    	mov    0x801107f4,%edi
80100bf1:	8d 97 80 00 00 00    	lea    0x80(%edi),%edx
80100bf7:	39 c2                	cmp    %eax,%edx
80100bf9:	0f 84 a7 01 00 00    	je     80100da6 <consoleintr+0x296>
          if(back_counter == 0){
80100bff:	8b 3d 00 08 11 80    	mov    0x80110800,%edi
80100c05:	8b 35 20 a5 10 80    	mov    0x8010a520,%esi
80100c0b:	8d 57 01             	lea    0x1(%edi),%edx
80100c0e:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
80100c14:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
80100c1a:	85 f6                	test   %esi,%esi
80100c1c:	0f 85 50 02 00 00    	jne    80100e72 <consoleintr+0x362>
            input.buf[input.e++ % INPUT_BUF] = c;
80100c22:	83 e0 7f             	and    $0x7f,%eax
80100c25:	89 0d fc 07 11 80    	mov    %ecx,0x801107fc
80100c2b:	88 98 74 07 11 80    	mov    %bl,-0x7feef88c(%eax)
  if(panicked){
80100c31:	a1 78 a5 10 80       	mov    0x8010a578,%eax
            input.pos ++;
80100c36:	89 15 00 08 11 80    	mov    %edx,0x80110800
  if(panicked){
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 22 02 00 00    	je     80100e66 <consoleintr+0x356>
80100c44:	fa                   	cli    
    for(;;)
80100c45:	eb fe                	jmp    80100c45 <consoleintr+0x135>
80100c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c4e:	66 90                	xchg   %ax,%ax
    switch(c){
80100c50:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80100c56:	0f 84 8c 00 00 00    	je     80100ce8 <consoleintr+0x1d8>
80100c5c:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
80100c62:	0f 85 35 ff ff ff    	jne    80100b9d <consoleintr+0x8d>
      if(input.pos < input.e){   // cannot beyond most left character
80100c68:	a1 00 08 11 80       	mov    0x80110800,%eax
80100c6d:	3b 05 fc 07 11 80    	cmp    0x801107fc,%eax
80100c73:	0f 83 b4 fe ff ff    	jae    80100b2d <consoleintr+0x1d>
        input.pos ++; // move back one
80100c79:	83 c0 01             	add    $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c7c:	be d4 03 00 00       	mov    $0x3d4,%esi
        back_counter -= 1;
80100c81:	83 2d 20 a5 10 80 01 	subl   $0x1,0x8010a520
        input.pos ++; // move back one
80100c88:	a3 00 08 11 80       	mov    %eax,0x80110800
80100c8d:	89 f2                	mov    %esi,%edx
80100c8f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c94:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c95:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100c9a:	89 da                	mov    %ebx,%edx
80100c9c:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c9d:	bf 0f 00 00 00       	mov    $0xf,%edi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100ca2:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100ca5:	89 f2                	mov    %esi,%edx
  pos = inb(CRTPORT+1) << 8;
80100ca7:	c1 e1 08             	shl    $0x8,%ecx
80100caa:	89 f8                	mov    %edi,%eax
80100cac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100cad:	89 da                	mov    %ebx,%edx
80100caf:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100cb0:	0f b6 c0             	movzbl %al,%eax
80100cb3:	09 c1                	or     %eax,%ecx
  pos++;
80100cb5:	83 c1 01             	add    $0x1,%ecx
80100cb8:	eb 7e                	jmp    80100d38 <consoleintr+0x228>
      if(input.e != input.w){
80100cba:	a1 fc 07 11 80       	mov    0x801107fc,%eax
80100cbf:	3b 05 f8 07 11 80    	cmp    0x801107f8,%eax
80100cc5:	0f 84 62 fe ff ff    	je     80100b2d <consoleintr+0x1d>
  if(panicked){
80100ccb:	8b 0d 78 a5 10 80    	mov    0x8010a578,%ecx
        input.e--;
80100cd1:	83 e8 01             	sub    $0x1,%eax
80100cd4:	a3 fc 07 11 80       	mov    %eax,0x801107fc
  if(panicked){
80100cd9:	85 c9                	test   %ecx,%ecx
80100cdb:	0f 84 8f 00 00 00    	je     80100d70 <consoleintr+0x260>
  asm volatile("cli");
80100ce1:	fa                   	cli    
    for(;;)
80100ce2:	eb fe                	jmp    80100ce2 <consoleintr+0x1d2>
80100ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.pos > input.r){   // cannot beyond most left character
80100ce8:	a1 00 08 11 80       	mov    0x80110800,%eax
80100ced:	3b 05 f4 07 11 80    	cmp    0x801107f4,%eax
80100cf3:	0f 86 34 fe ff ff    	jbe    80100b2d <consoleintr+0x1d>
        input.pos --; // move back one
80100cf9:	83 e8 01             	sub    $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100cfc:	be d4 03 00 00       	mov    $0x3d4,%esi
        back_counter += 1;
80100d01:	83 05 20 a5 10 80 01 	addl   $0x1,0x8010a520
        input.pos --; // move back one
80100d08:	a3 00 08 11 80       	mov    %eax,0x80110800
80100d0d:	89 f2                	mov    %esi,%edx
80100d0f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100d14:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d15:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100d1a:	89 da                	mov    %ebx,%edx
80100d1c:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d1d:	bf 0f 00 00 00       	mov    $0xf,%edi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d22:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d25:	89 f2                	mov    %esi,%edx
  pos = inb(CRTPORT+1) << 8;
80100d27:	c1 e1 08             	shl    $0x8,%ecx
80100d2a:	89 f8                	mov    %edi,%eax
80100d2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d2d:	89 da                	mov    %ebx,%edx
80100d2f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100d30:	0f b6 c0             	movzbl %al,%eax
80100d33:	09 c1                	or     %eax,%ecx
  pos--;
80100d35:	83 e9 01             	sub    $0x1,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d38:	89 f8                	mov    %edi,%eax
80100d3a:	89 f2                	mov    %esi,%edx
80100d3c:	ee                   	out    %al,(%dx)
80100d3d:	89 c8                	mov    %ecx,%eax
80100d3f:	89 da                	mov    %ebx,%edx
80100d41:	ee                   	out    %al,(%dx)
80100d42:	b8 0e 00 00 00       	mov    $0xe,%eax
80100d47:	89 f2                	mov    %esi,%edx
80100d49:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
80100d4a:	89 c8                	mov    %ecx,%eax
80100d4c:	89 da                	mov    %ebx,%edx
80100d4e:	c1 f8 08             	sar    $0x8,%eax
80100d51:	ee                   	out    %al,(%dx)
}
80100d52:	e9 d6 fd ff ff       	jmp    80100b2d <consoleintr+0x1d>
80100d57:	b8 00 01 00 00       	mov    $0x100,%eax
80100d5c:	e8 2f f6 ff ff       	call   80100390 <consputc.part.0>
80100d61:	e9 f1 fd ff ff       	jmp    80100b57 <consoleintr+0x47>
      procdump();
80100d66:	e8 45 39 00 00       	call   801046b0 <procdump>
      break;
80100d6b:	e9 bd fd ff ff       	jmp    80100b2d <consoleintr+0x1d>
80100d70:	b8 00 01 00 00       	mov    $0x100,%eax
80100d75:	e8 16 f6 ff ff       	call   80100390 <consputc.part.0>
80100d7a:	e9 ae fd ff ff       	jmp    80100b2d <consoleintr+0x1d>
  release(&cons.lock);
80100d7f:	83 ec 0c             	sub    $0xc,%esp
80100d82:	68 40 a5 10 80       	push   $0x8010a540
80100d87:	e8 74 3d 00 00       	call   80104b00 <release>
}
80100d8c:	83 c4 10             	add    $0x10,%esp
80100d8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d92:	5b                   	pop    %ebx
80100d93:	5e                   	pop    %esi
80100d94:	5f                   	pop    %edi
80100d95:	5d                   	pop    %ebp
80100d96:	c3                   	ret    
        c = (c == '\r') ? '\n' : c;
80100d97:	c6 85 64 ff ff ff 0a 	movb   $0xa,-0x9c(%ebp)
80100d9e:	8d 48 01             	lea    0x1(%eax),%ecx
80100da1:	bb 0a 00 00 00       	mov    $0xa,%ebx
          input.buf[input.e++ % INPUT_BUF] = c;
80100da6:	89 0d fc 07 11 80    	mov    %ecx,0x801107fc
  if(panicked){
80100dac:	8b 15 78 a5 10 80    	mov    0x8010a578,%edx
          input.buf[input.e++ % INPUT_BUF] = c;
80100db2:	83 e0 7f             	and    $0x7f,%eax
80100db5:	0f b6 8d 64 ff ff ff 	movzbl -0x9c(%ebp),%ecx
80100dbc:	88 88 74 07 11 80    	mov    %cl,-0x7feef88c(%eax)
  if(panicked){
80100dc2:	85 d2                	test   %edx,%edx
80100dc4:	74 0a                	je     80100dd0 <consoleintr+0x2c0>
  asm volatile("cli");
80100dc6:	fa                   	cli    
    for(;;)
80100dc7:	eb fe                	jmp    80100dc7 <consoleintr+0x2b7>
80100dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100dd0:	89 d8                	mov    %ebx,%eax
            buffer[k] = input.buf[i % INPUT_BUF];
80100dd2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
80100dd8:	e8 b3 f5 ff ff       	call   80100390 <consputc.part.0>
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
80100ddd:	8b 35 f8 07 11 80    	mov    0x801107f8,%esi
80100de3:	8b 1d fc 07 11 80    	mov    0x801107fc,%ebx
          back_counter = 0;
80100de9:	c7 05 20 a5 10 80 00 	movl   $0x0,0x8010a520
80100df0:	00 00 00 
            buffer[k] = input.buf[i % INPUT_BUF];
80100df3:	29 f7                	sub    %esi,%edi
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
80100df5:	8d 43 ff             	lea    -0x1(%ebx),%eax
80100df8:	89 f2                	mov    %esi,%edx
            buffer[k] = input.buf[i % INPUT_BUF];
80100dfa:	89 bd 64 ff ff ff    	mov    %edi,-0x9c(%ebp)
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
80100e00:	39 c6                	cmp    %eax,%esi
80100e02:	73 27                	jae    80100e2b <consoleintr+0x31b>
            buffer[k] = input.buf[i % INPUT_BUF];
80100e04:	89 d7                	mov    %edx,%edi
80100e06:	c1 ff 1f             	sar    $0x1f,%edi
80100e09:	c1 ef 19             	shr    $0x19,%edi
80100e0c:	8d 0c 3a             	lea    (%edx,%edi,1),%ecx
80100e0f:	83 e1 7f             	and    $0x7f,%ecx
80100e12:	29 f9                	sub    %edi,%ecx
80100e14:	8b bd 64 ff ff ff    	mov    -0x9c(%ebp),%edi
80100e1a:	0f b6 89 74 07 11 80 	movzbl -0x7feef88c(%ecx),%ecx
80100e21:	88 0c 17             	mov    %cl,(%edi,%edx,1)
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
80100e24:	83 c2 01             	add    $0x1,%edx
80100e27:	39 d0                	cmp    %edx,%eax
80100e29:	77 d9                	ja     80100e04 <consoleintr+0x2f4>
          buffer[(input.e-1-input.w) % INPUT_BUF] = '\0';
80100e2b:	29 f0                	sub    %esi,%eax
80100e2d:	83 e0 7f             	and    $0x7f,%eax
80100e30:	c6 84 05 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%eax,1)
80100e37:	00 
if(command[0]!='\0')
80100e38:	80 bd 68 ff ff ff 00 	cmpb   $0x0,-0x98(%ebp)
80100e3f:	0f 85 af 00 00 00    	jne    80100ef4 <consoleintr+0x3e4>
          wakeup(&input.r);
80100e45:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100e48:	89 1d f8 07 11 80    	mov    %ebx,0x801107f8
          wakeup(&input.r);
80100e4e:	68 f4 07 11 80       	push   $0x801107f4
          input.pos = input.e;
80100e53:	89 1d 00 08 11 80    	mov    %ebx,0x80110800
          wakeup(&input.r);
80100e59:	e8 62 37 00 00       	call   801045c0 <wakeup>
80100e5e:	83 c4 10             	add    $0x10,%esp
80100e61:	e9 c7 fc ff ff       	jmp    80100b2d <consoleintr+0x1d>
80100e66:	89 d8                	mov    %ebx,%eax
80100e68:	e8 23 f5 ff ff       	call   80100390 <consputc.part.0>
80100e6d:	e9 bb fc ff ff       	jmp    80100b2d <consoleintr+0x1d>
            for(int k=input.e; k >= input.pos; k--){
80100e72:	39 f8                	cmp    %edi,%eax
80100e74:	72 44                	jb     80100eba <consoleintr+0x3aa>
80100e76:	89 8d 58 ff ff ff    	mov    %ecx,-0xa8(%ebp)
              input.buf[(k + 1) % INPUT_BUF] = input.buf[k % INPUT_BUF];
80100e7c:	89 c6                	mov    %eax,%esi
80100e7e:	c1 fe 1f             	sar    $0x1f,%esi
80100e81:	c1 ee 19             	shr    $0x19,%esi
80100e84:	8d 14 30             	lea    (%eax,%esi,1),%edx
80100e87:	83 e2 7f             	and    $0x7f,%edx
80100e8a:	29 f2                	sub    %esi,%edx
80100e8c:	0f b6 92 74 07 11 80 	movzbl -0x7feef88c(%edx),%edx
80100e93:	89 d1                	mov    %edx,%ecx
80100e95:	8d 50 01             	lea    0x1(%eax),%edx
            for(int k=input.e; k >= input.pos; k--){
80100e98:	83 e8 01             	sub    $0x1,%eax
              input.buf[(k + 1) % INPUT_BUF] = input.buf[k % INPUT_BUF];
80100e9b:	89 d6                	mov    %edx,%esi
80100e9d:	c1 fe 1f             	sar    $0x1f,%esi
80100ea0:	c1 ee 19             	shr    $0x19,%esi
80100ea3:	01 f2                	add    %esi,%edx
80100ea5:	83 e2 7f             	and    $0x7f,%edx
80100ea8:	29 f2                	sub    %esi,%edx
80100eaa:	88 8a 74 07 11 80    	mov    %cl,-0x7feef88c(%edx)
            for(int k=input.e; k >= input.pos; k--){
80100eb0:	39 f8                	cmp    %edi,%eax
80100eb2:	73 c8                	jae    80100e7c <consoleintr+0x36c>
80100eb4:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
            vga_insert_char(c, back_counter);
80100eba:	83 ec 08             	sub    $0x8,%esp
            input.buf[input.pos % INPUT_BUF] = c;
80100ebd:	0f b6 95 64 ff ff ff 	movzbl -0x9c(%ebp),%edx
80100ec4:	89 f8                	mov    %edi,%eax
            vga_insert_char(c, back_counter);
80100ec6:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
            input.buf[input.pos % INPUT_BUF] = c;
80100ecc:	83 e0 7f             	and    $0x7f,%eax
            vga_insert_char(c, back_counter);
80100ecf:	53                   	push   %ebx
            input.buf[input.pos % INPUT_BUF] = c;
80100ed0:	88 90 74 07 11 80    	mov    %dl,-0x7feef88c(%eax)
            input.pos++;
80100ed6:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
            input.e++;
80100edc:	89 0d fc 07 11 80    	mov    %ecx,0x801107fc
            input.pos++;
80100ee2:	a3 00 08 11 80       	mov    %eax,0x80110800
            vga_insert_char(c, back_counter);
80100ee7:	e8 04 fb ff ff       	call   801009f0 <vga_insert_char>
80100eec:	83 c4 10             	add    $0x10,%esp
80100eef:	e9 39 fc ff ff       	jmp    80100b2d <consoleintr+0x1d>
80100ef4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80100efa:	e8 11 f7 ff ff       	call   80100610 <addHistory.part.0>
80100eff:	8b 1d fc 07 11 80    	mov    0x801107fc,%ebx
80100f05:	e9 3b ff ff ff       	jmp    80100e45 <consoleintr+0x335>
80100f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f10 <consoleinit>:

void
consoleinit(void)
{
80100f10:	f3 0f 1e fb          	endbr32 
80100f14:	55                   	push   %ebp
80100f15:	89 e5                	mov    %esp,%ebp
80100f17:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100f1a:	68 15 76 10 80       	push   $0x80107615
80100f1f:	68 40 a5 10 80       	push   $0x8010a540
80100f24:	e8 97 39 00 00       	call   801048c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100f29:	58                   	pop    %eax
80100f2a:	5a                   	pop    %edx
80100f2b:	6a 00                	push   $0x0
80100f2d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100f2f:	c7 05 cc 11 11 80 a0 	movl   $0x801005a0,0x801111cc
80100f36:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100f39:	c7 05 c8 11 11 80 90 	movl   $0x80100290,0x801111c8
80100f40:	02 10 80 
  cons.locking = 1;
80100f43:	c7 05 74 a5 10 80 01 	movl   $0x1,0x8010a574
80100f4a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100f4d:	e8 be 19 00 00       	call   80102910 <ioapicenable>
}
80100f52:	83 c4 10             	add    $0x10,%esp
80100f55:	c9                   	leave  
80100f56:	c3                   	ret    
80100f57:	66 90                	xchg   %ax,%ax
80100f59:	66 90                	xchg   %ax,%ax
80100f5b:	66 90                	xchg   %ax,%ax
80100f5d:	66 90                	xchg   %ax,%ax
80100f5f:	90                   	nop

80100f60 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100f60:	f3 0f 1e fb          	endbr32 
80100f64:	55                   	push   %ebp
80100f65:	89 e5                	mov    %esp,%ebp
80100f67:	57                   	push   %edi
80100f68:	56                   	push   %esi
80100f69:	53                   	push   %ebx
80100f6a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100f70:	e8 cb 2e 00 00       	call   80103e40 <myproc>
80100f75:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100f7b:	e8 90 22 00 00       	call   80103210 <begin_op>

  if((ip = namei(path)) == 0){
80100f80:	83 ec 0c             	sub    $0xc,%esp
80100f83:	ff 75 08             	pushl  0x8(%ebp)
80100f86:	e8 85 15 00 00       	call   80102510 <namei>
80100f8b:	83 c4 10             	add    $0x10,%esp
80100f8e:	85 c0                	test   %eax,%eax
80100f90:	0f 84 fe 02 00 00    	je     80101294 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100f96:	83 ec 0c             	sub    $0xc,%esp
80100f99:	89 c3                	mov    %eax,%ebx
80100f9b:	50                   	push   %eax
80100f9c:	e8 9f 0c 00 00       	call   80101c40 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100fa1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100fa7:	6a 34                	push   $0x34
80100fa9:	6a 00                	push   $0x0
80100fab:	50                   	push   %eax
80100fac:	53                   	push   %ebx
80100fad:	e8 8e 0f 00 00       	call   80101f40 <readi>
80100fb2:	83 c4 20             	add    $0x20,%esp
80100fb5:	83 f8 34             	cmp    $0x34,%eax
80100fb8:	74 26                	je     80100fe0 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100fba:	83 ec 0c             	sub    $0xc,%esp
80100fbd:	53                   	push   %ebx
80100fbe:	e8 1d 0f 00 00       	call   80101ee0 <iunlockput>
    end_op();
80100fc3:	e8 b8 22 00 00       	call   80103280 <end_op>
80100fc8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100fcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd3:	5b                   	pop    %ebx
80100fd4:	5e                   	pop    %esi
80100fd5:	5f                   	pop    %edi
80100fd6:	5d                   	pop    %ebp
80100fd7:	c3                   	ret    
80100fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fdf:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100fe0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100fe7:	45 4c 46 
80100fea:	75 ce                	jne    80100fba <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100fec:	e8 3f 63 00 00       	call   80107330 <setupkvm>
80100ff1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100ff7:	85 c0                	test   %eax,%eax
80100ff9:	74 bf                	je     80100fba <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ffb:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101002:	00 
80101003:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101009:	0f 84 a4 02 00 00    	je     801012b3 <exec+0x353>
  sz = 0;
8010100f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101016:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101019:	31 ff                	xor    %edi,%edi
8010101b:	e9 86 00 00 00       	jmp    801010a6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80101020:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101027:	75 6c                	jne    80101095 <exec+0x135>
    if(ph.memsz < ph.filesz)
80101029:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010102f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101035:	0f 82 87 00 00 00    	jb     801010c2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
8010103b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101041:	72 7f                	jb     801010c2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101043:	83 ec 04             	sub    $0x4,%esp
80101046:	50                   	push   %eax
80101047:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
8010104d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101053:	e8 f8 60 00 00       	call   80107150 <allocuvm>
80101058:	83 c4 10             	add    $0x10,%esp
8010105b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101061:	85 c0                	test   %eax,%eax
80101063:	74 5d                	je     801010c2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101065:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010106b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101070:	75 50                	jne    801010c2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101072:	83 ec 0c             	sub    $0xc,%esp
80101075:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
8010107b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80101081:	53                   	push   %ebx
80101082:	50                   	push   %eax
80101083:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101089:	e8 f2 5f 00 00       	call   80107080 <loaduvm>
8010108e:	83 c4 20             	add    $0x20,%esp
80101091:	85 c0                	test   %eax,%eax
80101093:	78 2d                	js     801010c2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101095:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010109c:	83 c7 01             	add    $0x1,%edi
8010109f:	83 c6 20             	add    $0x20,%esi
801010a2:	39 f8                	cmp    %edi,%eax
801010a4:	7e 3a                	jle    801010e0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801010a6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801010ac:	6a 20                	push   $0x20
801010ae:	56                   	push   %esi
801010af:	50                   	push   %eax
801010b0:	53                   	push   %ebx
801010b1:	e8 8a 0e 00 00       	call   80101f40 <readi>
801010b6:	83 c4 10             	add    $0x10,%esp
801010b9:	83 f8 20             	cmp    $0x20,%eax
801010bc:	0f 84 5e ff ff ff    	je     80101020 <exec+0xc0>
    freevm(pgdir);
801010c2:	83 ec 0c             	sub    $0xc,%esp
801010c5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801010cb:	e8 e0 61 00 00       	call   801072b0 <freevm>
  if(ip){
801010d0:	83 c4 10             	add    $0x10,%esp
801010d3:	e9 e2 fe ff ff       	jmp    80100fba <exec+0x5a>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
801010e0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801010e6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
801010ec:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801010f2:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
801010f8:	83 ec 0c             	sub    $0xc,%esp
801010fb:	53                   	push   %ebx
801010fc:	e8 df 0d 00 00       	call   80101ee0 <iunlockput>
  end_op();
80101101:	e8 7a 21 00 00       	call   80103280 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101106:	83 c4 0c             	add    $0xc,%esp
80101109:	56                   	push   %esi
8010110a:	57                   	push   %edi
8010110b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101111:	57                   	push   %edi
80101112:	e8 39 60 00 00       	call   80107150 <allocuvm>
80101117:	83 c4 10             	add    $0x10,%esp
8010111a:	89 c6                	mov    %eax,%esi
8010111c:	85 c0                	test   %eax,%eax
8010111e:	0f 84 94 00 00 00    	je     801011b8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101124:	83 ec 08             	sub    $0x8,%esp
80101127:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
8010112d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010112f:	50                   	push   %eax
80101130:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80101131:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101133:	e8 98 62 00 00       	call   801073d0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101138:	8b 45 0c             	mov    0xc(%ebp),%eax
8010113b:	83 c4 10             	add    $0x10,%esp
8010113e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101144:	8b 00                	mov    (%eax),%eax
80101146:	85 c0                	test   %eax,%eax
80101148:	0f 84 8b 00 00 00    	je     801011d9 <exec+0x279>
8010114e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101154:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
8010115a:	eb 23                	jmp    8010117f <exec+0x21f>
8010115c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101160:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101163:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010116a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010116d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101173:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101176:	85 c0                	test   %eax,%eax
80101178:	74 59                	je     801011d3 <exec+0x273>
    if(argc >= MAXARG)
8010117a:	83 ff 20             	cmp    $0x20,%edi
8010117d:	74 39                	je     801011b8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	50                   	push   %eax
80101183:	e8 c8 3b 00 00       	call   80104d50 <strlen>
80101188:	f7 d0                	not    %eax
8010118a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010118c:	58                   	pop    %eax
8010118d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101190:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101193:	ff 34 b8             	pushl  (%eax,%edi,4)
80101196:	e8 b5 3b 00 00       	call   80104d50 <strlen>
8010119b:	83 c0 01             	add    $0x1,%eax
8010119e:	50                   	push   %eax
8010119f:	8b 45 0c             	mov    0xc(%ebp),%eax
801011a2:	ff 34 b8             	pushl  (%eax,%edi,4)
801011a5:	53                   	push   %ebx
801011a6:	56                   	push   %esi
801011a7:	e8 84 63 00 00       	call   80107530 <copyout>
801011ac:	83 c4 20             	add    $0x20,%esp
801011af:	85 c0                	test   %eax,%eax
801011b1:	79 ad                	jns    80101160 <exec+0x200>
801011b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011b7:	90                   	nop
    freevm(pgdir);
801011b8:	83 ec 0c             	sub    $0xc,%esp
801011bb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801011c1:	e8 ea 60 00 00       	call   801072b0 <freevm>
801011c6:	83 c4 10             	add    $0x10,%esp
  return -1;
801011c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011ce:	e9 fd fd ff ff       	jmp    80100fd0 <exec+0x70>
801011d3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801011d9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
801011e0:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
801011e2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
801011e9:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801011ed:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
801011ef:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
801011f2:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
801011f8:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801011fa:	50                   	push   %eax
801011fb:	52                   	push   %edx
801011fc:	53                   	push   %ebx
801011fd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101203:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010120a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010120d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101213:	e8 18 63 00 00       	call   80107530 <copyout>
80101218:	83 c4 10             	add    $0x10,%esp
8010121b:	85 c0                	test   %eax,%eax
8010121d:	78 99                	js     801011b8 <exec+0x258>
  for(last=s=path; *s; s++)
8010121f:	8b 45 08             	mov    0x8(%ebp),%eax
80101222:	8b 55 08             	mov    0x8(%ebp),%edx
80101225:	0f b6 00             	movzbl (%eax),%eax
80101228:	84 c0                	test   %al,%al
8010122a:	74 13                	je     8010123f <exec+0x2df>
8010122c:	89 d1                	mov    %edx,%ecx
8010122e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80101230:	83 c1 01             	add    $0x1,%ecx
80101233:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101235:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80101238:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010123b:	84 c0                	test   %al,%al
8010123d:	75 f1                	jne    80101230 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010123f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101245:	83 ec 04             	sub    $0x4,%esp
80101248:	6a 10                	push   $0x10
8010124a:	89 f8                	mov    %edi,%eax
8010124c:	52                   	push   %edx
8010124d:	83 c0 6c             	add    $0x6c,%eax
80101250:	50                   	push   %eax
80101251:	e8 ba 3a 00 00       	call   80104d10 <safestrcpy>
  curproc->pgdir = pgdir;
80101256:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010125c:	89 f8                	mov    %edi,%eax
8010125e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101261:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101263:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101266:	89 c1                	mov    %eax,%ecx
80101268:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010126e:	8b 40 18             	mov    0x18(%eax),%eax
80101271:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101274:	8b 41 18             	mov    0x18(%ecx),%eax
80101277:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010127a:	89 0c 24             	mov    %ecx,(%esp)
8010127d:	e8 6e 5c 00 00       	call   80106ef0 <switchuvm>
  freevm(oldpgdir);
80101282:	89 3c 24             	mov    %edi,(%esp)
80101285:	e8 26 60 00 00       	call   801072b0 <freevm>
  return 0;
8010128a:	83 c4 10             	add    $0x10,%esp
8010128d:	31 c0                	xor    %eax,%eax
8010128f:	e9 3c fd ff ff       	jmp    80100fd0 <exec+0x70>
    end_op();
80101294:	e8 e7 1f 00 00       	call   80103280 <end_op>
    cprintf("exec: fail\n");
80101299:	83 ec 0c             	sub    $0xc,%esp
8010129c:	68 31 76 10 80       	push   $0x80107631
801012a1:	e8 da f4 ff ff       	call   80100780 <cprintf>
    return -1;
801012a6:	83 c4 10             	add    $0x10,%esp
801012a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012ae:	e9 1d fd ff ff       	jmp    80100fd0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801012b3:	31 ff                	xor    %edi,%edi
801012b5:	be 00 20 00 00       	mov    $0x2000,%esi
801012ba:	e9 39 fe ff ff       	jmp    801010f8 <exec+0x198>
801012bf:	90                   	nop

801012c0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801012c0:	f3 0f 1e fb          	endbr32 
801012c4:	55                   	push   %ebp
801012c5:	89 e5                	mov    %esp,%ebp
801012c7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801012ca:	68 3d 76 10 80       	push   $0x8010763d
801012cf:	68 20 08 11 80       	push   $0x80110820
801012d4:	e8 e7 35 00 00       	call   801048c0 <initlock>
}
801012d9:	83 c4 10             	add    $0x10,%esp
801012dc:	c9                   	leave  
801012dd:	c3                   	ret    
801012de:	66 90                	xchg   %ax,%ax

801012e0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801012e0:	f3 0f 1e fb          	endbr32 
801012e4:	55                   	push   %ebp
801012e5:	89 e5                	mov    %esp,%ebp
801012e7:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801012e8:	bb 54 08 11 80       	mov    $0x80110854,%ebx
{
801012ed:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801012f0:	68 20 08 11 80       	push   $0x80110820
801012f5:	e8 46 37 00 00       	call   80104a40 <acquire>
801012fa:	83 c4 10             	add    $0x10,%esp
801012fd:	eb 0c                	jmp    8010130b <filealloc+0x2b>
801012ff:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101300:	83 c3 18             	add    $0x18,%ebx
80101303:	81 fb b4 11 11 80    	cmp    $0x801111b4,%ebx
80101309:	74 25                	je     80101330 <filealloc+0x50>
    if(f->ref == 0){
8010130b:	8b 43 04             	mov    0x4(%ebx),%eax
8010130e:	85 c0                	test   %eax,%eax
80101310:	75 ee                	jne    80101300 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101312:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101315:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010131c:	68 20 08 11 80       	push   $0x80110820
80101321:	e8 da 37 00 00       	call   80104b00 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101326:	89 d8                	mov    %ebx,%eax
      return f;
80101328:	83 c4 10             	add    $0x10,%esp
}
8010132b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010132e:	c9                   	leave  
8010132f:	c3                   	ret    
  release(&ftable.lock);
80101330:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101333:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101335:	68 20 08 11 80       	push   $0x80110820
8010133a:	e8 c1 37 00 00       	call   80104b00 <release>
}
8010133f:	89 d8                	mov    %ebx,%eax
  return 0;
80101341:	83 c4 10             	add    $0x10,%esp
}
80101344:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101347:	c9                   	leave  
80101348:	c3                   	ret    
80101349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101350 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101350:	f3 0f 1e fb          	endbr32 
80101354:	55                   	push   %ebp
80101355:	89 e5                	mov    %esp,%ebp
80101357:	53                   	push   %ebx
80101358:	83 ec 10             	sub    $0x10,%esp
8010135b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010135e:	68 20 08 11 80       	push   $0x80110820
80101363:	e8 d8 36 00 00       	call   80104a40 <acquire>
  if(f->ref < 1)
80101368:	8b 43 04             	mov    0x4(%ebx),%eax
8010136b:	83 c4 10             	add    $0x10,%esp
8010136e:	85 c0                	test   %eax,%eax
80101370:	7e 1a                	jle    8010138c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80101372:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101375:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101378:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
8010137b:	68 20 08 11 80       	push   $0x80110820
80101380:	e8 7b 37 00 00       	call   80104b00 <release>
  return f;
}
80101385:	89 d8                	mov    %ebx,%eax
80101387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010138a:	c9                   	leave  
8010138b:	c3                   	ret    
    panic("filedup");
8010138c:	83 ec 0c             	sub    $0xc,%esp
8010138f:	68 44 76 10 80       	push   $0x80107644
80101394:	e8 67 f3 ff ff       	call   80100700 <panic>
80101399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801013a0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801013a0:	f3 0f 1e fb          	endbr32 
801013a4:	55                   	push   %ebp
801013a5:	89 e5                	mov    %esp,%ebp
801013a7:	57                   	push   %edi
801013a8:	56                   	push   %esi
801013a9:	53                   	push   %ebx
801013aa:	83 ec 28             	sub    $0x28,%esp
801013ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801013b0:	68 20 08 11 80       	push   $0x80110820
801013b5:	e8 86 36 00 00       	call   80104a40 <acquire>
  if(f->ref < 1)
801013ba:	8b 53 04             	mov    0x4(%ebx),%edx
801013bd:	83 c4 10             	add    $0x10,%esp
801013c0:	85 d2                	test   %edx,%edx
801013c2:	0f 8e a1 00 00 00    	jle    80101469 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801013c8:	83 ea 01             	sub    $0x1,%edx
801013cb:	89 53 04             	mov    %edx,0x4(%ebx)
801013ce:	75 40                	jne    80101410 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801013d0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801013d4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801013d7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801013d9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801013df:	8b 73 0c             	mov    0xc(%ebx),%esi
801013e2:	88 45 e7             	mov    %al,-0x19(%ebp)
801013e5:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801013e8:	68 20 08 11 80       	push   $0x80110820
  ff = *f;
801013ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801013f0:	e8 0b 37 00 00       	call   80104b00 <release>

  if(ff.type == FD_PIPE)
801013f5:	83 c4 10             	add    $0x10,%esp
801013f8:	83 ff 01             	cmp    $0x1,%edi
801013fb:	74 53                	je     80101450 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801013fd:	83 ff 02             	cmp    $0x2,%edi
80101400:	74 26                	je     80101428 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101402:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101405:	5b                   	pop    %ebx
80101406:	5e                   	pop    %esi
80101407:	5f                   	pop    %edi
80101408:	5d                   	pop    %ebp
80101409:	c3                   	ret    
8010140a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101410:	c7 45 08 20 08 11 80 	movl   $0x80110820,0x8(%ebp)
}
80101417:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010141a:	5b                   	pop    %ebx
8010141b:	5e                   	pop    %esi
8010141c:	5f                   	pop    %edi
8010141d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010141e:	e9 dd 36 00 00       	jmp    80104b00 <release>
80101423:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101427:	90                   	nop
    begin_op();
80101428:	e8 e3 1d 00 00       	call   80103210 <begin_op>
    iput(ff.ip);
8010142d:	83 ec 0c             	sub    $0xc,%esp
80101430:	ff 75 e0             	pushl  -0x20(%ebp)
80101433:	e8 38 09 00 00       	call   80101d70 <iput>
    end_op();
80101438:	83 c4 10             	add    $0x10,%esp
}
8010143b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010143e:	5b                   	pop    %ebx
8010143f:	5e                   	pop    %esi
80101440:	5f                   	pop    %edi
80101441:	5d                   	pop    %ebp
    end_op();
80101442:	e9 39 1e 00 00       	jmp    80103280 <end_op>
80101447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010144e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101450:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101454:	83 ec 08             	sub    $0x8,%esp
80101457:	53                   	push   %ebx
80101458:	56                   	push   %esi
80101459:	e8 82 25 00 00       	call   801039e0 <pipeclose>
8010145e:	83 c4 10             	add    $0x10,%esp
}
80101461:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101464:	5b                   	pop    %ebx
80101465:	5e                   	pop    %esi
80101466:	5f                   	pop    %edi
80101467:	5d                   	pop    %ebp
80101468:	c3                   	ret    
    panic("fileclose");
80101469:	83 ec 0c             	sub    $0xc,%esp
8010146c:	68 4c 76 10 80       	push   $0x8010764c
80101471:	e8 8a f2 ff ff       	call   80100700 <panic>
80101476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010147d:	8d 76 00             	lea    0x0(%esi),%esi

80101480 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101480:	f3 0f 1e fb          	endbr32 
80101484:	55                   	push   %ebp
80101485:	89 e5                	mov    %esp,%ebp
80101487:	53                   	push   %ebx
80101488:	83 ec 04             	sub    $0x4,%esp
8010148b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010148e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101491:	75 2d                	jne    801014c0 <filestat+0x40>
    ilock(f->ip);
80101493:	83 ec 0c             	sub    $0xc,%esp
80101496:	ff 73 10             	pushl  0x10(%ebx)
80101499:	e8 a2 07 00 00       	call   80101c40 <ilock>
    stati(f->ip, st);
8010149e:	58                   	pop    %eax
8010149f:	5a                   	pop    %edx
801014a0:	ff 75 0c             	pushl  0xc(%ebp)
801014a3:	ff 73 10             	pushl  0x10(%ebx)
801014a6:	e8 65 0a 00 00       	call   80101f10 <stati>
    iunlock(f->ip);
801014ab:	59                   	pop    %ecx
801014ac:	ff 73 10             	pushl  0x10(%ebx)
801014af:	e8 6c 08 00 00       	call   80101d20 <iunlock>
    return 0;
  }
  return -1;
}
801014b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801014b7:	83 c4 10             	add    $0x10,%esp
801014ba:	31 c0                	xor    %eax,%eax
}
801014bc:	c9                   	leave  
801014bd:	c3                   	ret    
801014be:	66 90                	xchg   %ax,%ax
801014c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801014c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801014c8:	c9                   	leave  
801014c9:	c3                   	ret    
801014ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801014d0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801014d0:	f3 0f 1e fb          	endbr32 
801014d4:	55                   	push   %ebp
801014d5:	89 e5                	mov    %esp,%ebp
801014d7:	57                   	push   %edi
801014d8:	56                   	push   %esi
801014d9:	53                   	push   %ebx
801014da:	83 ec 0c             	sub    $0xc,%esp
801014dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
801014e0:	8b 75 0c             	mov    0xc(%ebp),%esi
801014e3:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801014e6:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801014ea:	74 64                	je     80101550 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
801014ec:	8b 03                	mov    (%ebx),%eax
801014ee:	83 f8 01             	cmp    $0x1,%eax
801014f1:	74 45                	je     80101538 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801014f3:	83 f8 02             	cmp    $0x2,%eax
801014f6:	75 5f                	jne    80101557 <fileread+0x87>
    ilock(f->ip);
801014f8:	83 ec 0c             	sub    $0xc,%esp
801014fb:	ff 73 10             	pushl  0x10(%ebx)
801014fe:	e8 3d 07 00 00       	call   80101c40 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101503:	57                   	push   %edi
80101504:	ff 73 14             	pushl  0x14(%ebx)
80101507:	56                   	push   %esi
80101508:	ff 73 10             	pushl  0x10(%ebx)
8010150b:	e8 30 0a 00 00       	call   80101f40 <readi>
80101510:	83 c4 20             	add    $0x20,%esp
80101513:	89 c6                	mov    %eax,%esi
80101515:	85 c0                	test   %eax,%eax
80101517:	7e 03                	jle    8010151c <fileread+0x4c>
      f->off += r;
80101519:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010151c:	83 ec 0c             	sub    $0xc,%esp
8010151f:	ff 73 10             	pushl  0x10(%ebx)
80101522:	e8 f9 07 00 00       	call   80101d20 <iunlock>
    return r;
80101527:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010152a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010152d:	89 f0                	mov    %esi,%eax
8010152f:	5b                   	pop    %ebx
80101530:	5e                   	pop    %esi
80101531:	5f                   	pop    %edi
80101532:	5d                   	pop    %ebp
80101533:	c3                   	ret    
80101534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101538:	8b 43 0c             	mov    0xc(%ebx),%eax
8010153b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010153e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101541:	5b                   	pop    %ebx
80101542:	5e                   	pop    %esi
80101543:	5f                   	pop    %edi
80101544:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101545:	e9 36 26 00 00       	jmp    80103b80 <piperead>
8010154a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101550:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101555:	eb d3                	jmp    8010152a <fileread+0x5a>
  panic("fileread");
80101557:	83 ec 0c             	sub    $0xc,%esp
8010155a:	68 56 76 10 80       	push   $0x80107656
8010155f:	e8 9c f1 ff ff       	call   80100700 <panic>
80101564:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010156b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010156f:	90                   	nop

80101570 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101570:	f3 0f 1e fb          	endbr32 
80101574:	55                   	push   %ebp
80101575:	89 e5                	mov    %esp,%ebp
80101577:	57                   	push   %edi
80101578:	56                   	push   %esi
80101579:	53                   	push   %ebx
8010157a:	83 ec 1c             	sub    $0x1c,%esp
8010157d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101580:	8b 75 08             	mov    0x8(%ebp),%esi
80101583:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101586:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101589:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010158d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101590:	0f 84 c1 00 00 00    	je     80101657 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101596:	8b 06                	mov    (%esi),%eax
80101598:	83 f8 01             	cmp    $0x1,%eax
8010159b:	0f 84 c3 00 00 00    	je     80101664 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801015a1:	83 f8 02             	cmp    $0x2,%eax
801015a4:	0f 85 cc 00 00 00    	jne    80101676 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801015aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801015ad:	31 ff                	xor    %edi,%edi
    while(i < n){
801015af:	85 c0                	test   %eax,%eax
801015b1:	7f 34                	jg     801015e7 <filewrite+0x77>
801015b3:	e9 98 00 00 00       	jmp    80101650 <filewrite+0xe0>
801015b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015bf:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801015c0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801015c3:	83 ec 0c             	sub    $0xc,%esp
801015c6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801015c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801015cc:	e8 4f 07 00 00       	call   80101d20 <iunlock>
      end_op();
801015d1:	e8 aa 1c 00 00       	call   80103280 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801015d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801015d9:	83 c4 10             	add    $0x10,%esp
801015dc:	39 c3                	cmp    %eax,%ebx
801015de:	75 60                	jne    80101640 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
801015e0:	01 df                	add    %ebx,%edi
    while(i < n){
801015e2:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801015e5:	7e 69                	jle    80101650 <filewrite+0xe0>
      int n1 = n - i;
801015e7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801015ea:	b8 00 06 00 00       	mov    $0x600,%eax
801015ef:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
801015f1:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801015f7:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801015fa:	e8 11 1c 00 00       	call   80103210 <begin_op>
      ilock(f->ip);
801015ff:	83 ec 0c             	sub    $0xc,%esp
80101602:	ff 76 10             	pushl  0x10(%esi)
80101605:	e8 36 06 00 00       	call   80101c40 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010160a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010160d:	53                   	push   %ebx
8010160e:	ff 76 14             	pushl  0x14(%esi)
80101611:	01 f8                	add    %edi,%eax
80101613:	50                   	push   %eax
80101614:	ff 76 10             	pushl  0x10(%esi)
80101617:	e8 24 0a 00 00       	call   80102040 <writei>
8010161c:	83 c4 20             	add    $0x20,%esp
8010161f:	85 c0                	test   %eax,%eax
80101621:	7f 9d                	jg     801015c0 <filewrite+0x50>
      iunlock(f->ip);
80101623:	83 ec 0c             	sub    $0xc,%esp
80101626:	ff 76 10             	pushl  0x10(%esi)
80101629:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010162c:	e8 ef 06 00 00       	call   80101d20 <iunlock>
      end_op();
80101631:	e8 4a 1c 00 00       	call   80103280 <end_op>
      if(r < 0)
80101636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101639:	83 c4 10             	add    $0x10,%esp
8010163c:	85 c0                	test   %eax,%eax
8010163e:	75 17                	jne    80101657 <filewrite+0xe7>
        panic("short filewrite");
80101640:	83 ec 0c             	sub    $0xc,%esp
80101643:	68 5f 76 10 80       	push   $0x8010765f
80101648:	e8 b3 f0 ff ff       	call   80100700 <panic>
8010164d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101650:	89 f8                	mov    %edi,%eax
80101652:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101655:	74 05                	je     8010165c <filewrite+0xec>
80101657:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010165c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010165f:	5b                   	pop    %ebx
80101660:	5e                   	pop    %esi
80101661:	5f                   	pop    %edi
80101662:	5d                   	pop    %ebp
80101663:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101664:	8b 46 0c             	mov    0xc(%esi),%eax
80101667:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010166a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010166d:	5b                   	pop    %ebx
8010166e:	5e                   	pop    %esi
8010166f:	5f                   	pop    %edi
80101670:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101671:	e9 0a 24 00 00       	jmp    80103a80 <pipewrite>
  panic("filewrite");
80101676:	83 ec 0c             	sub    $0xc,%esp
80101679:	68 65 76 10 80       	push   $0x80107665
8010167e:	e8 7d f0 ff ff       	call   80100700 <panic>
80101683:	66 90                	xchg   %ax,%ax
80101685:	66 90                	xchg   %ax,%ax
80101687:	66 90                	xchg   %ax,%ax
80101689:	66 90                	xchg   %ax,%ax
8010168b:	66 90                	xchg   %ax,%ax
8010168d:	66 90                	xchg   %ax,%ax
8010168f:	90                   	nop

80101690 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101690:	55                   	push   %ebp
80101691:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101693:	89 d0                	mov    %edx,%eax
80101695:	c1 e8 0c             	shr    $0xc,%eax
80101698:	03 05 38 12 11 80    	add    0x80111238,%eax
{
8010169e:	89 e5                	mov    %esp,%ebp
801016a0:	56                   	push   %esi
801016a1:	53                   	push   %ebx
801016a2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801016a4:	83 ec 08             	sub    $0x8,%esp
801016a7:	50                   	push   %eax
801016a8:	51                   	push   %ecx
801016a9:	e8 22 ea ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801016ae:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801016b0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801016b3:	ba 01 00 00 00       	mov    $0x1,%edx
801016b8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801016bb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801016c1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801016c4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801016c6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801016cb:	85 d1                	test   %edx,%ecx
801016cd:	74 25                	je     801016f4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801016cf:	f7 d2                	not    %edx
  log_write(bp);
801016d1:	83 ec 0c             	sub    $0xc,%esp
801016d4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801016d6:	21 ca                	and    %ecx,%edx
801016d8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801016dc:	50                   	push   %eax
801016dd:	e8 0e 1d 00 00       	call   801033f0 <log_write>
  brelse(bp);
801016e2:	89 34 24             	mov    %esi,(%esp)
801016e5:	e8 06 eb ff ff       	call   801001f0 <brelse>
}
801016ea:	83 c4 10             	add    $0x10,%esp
801016ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016f0:	5b                   	pop    %ebx
801016f1:	5e                   	pop    %esi
801016f2:	5d                   	pop    %ebp
801016f3:	c3                   	ret    
    panic("freeing free block");
801016f4:	83 ec 0c             	sub    $0xc,%esp
801016f7:	68 6f 76 10 80       	push   $0x8010766f
801016fc:	e8 ff ef ff ff       	call   80100700 <panic>
80101701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010170f:	90                   	nop

80101710 <balloc>:
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	57                   	push   %edi
80101714:	56                   	push   %esi
80101715:	53                   	push   %ebx
80101716:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101719:	8b 0d 20 12 11 80    	mov    0x80111220,%ecx
{
8010171f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101722:	85 c9                	test   %ecx,%ecx
80101724:	0f 84 87 00 00 00    	je     801017b1 <balloc+0xa1>
8010172a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101731:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101734:	83 ec 08             	sub    $0x8,%esp
80101737:	89 f0                	mov    %esi,%eax
80101739:	c1 f8 0c             	sar    $0xc,%eax
8010173c:	03 05 38 12 11 80    	add    0x80111238,%eax
80101742:	50                   	push   %eax
80101743:	ff 75 d8             	pushl  -0x28(%ebp)
80101746:	e8 85 e9 ff ff       	call   801000d0 <bread>
8010174b:	83 c4 10             	add    $0x10,%esp
8010174e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101751:	a1 20 12 11 80       	mov    0x80111220,%eax
80101756:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101759:	31 c0                	xor    %eax,%eax
8010175b:	eb 2f                	jmp    8010178c <balloc+0x7c>
8010175d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101760:	89 c1                	mov    %eax,%ecx
80101762:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101767:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010176a:	83 e1 07             	and    $0x7,%ecx
8010176d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010176f:	89 c1                	mov    %eax,%ecx
80101771:	c1 f9 03             	sar    $0x3,%ecx
80101774:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101779:	89 fa                	mov    %edi,%edx
8010177b:	85 df                	test   %ebx,%edi
8010177d:	74 41                	je     801017c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010177f:	83 c0 01             	add    $0x1,%eax
80101782:	83 c6 01             	add    $0x1,%esi
80101785:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010178a:	74 05                	je     80101791 <balloc+0x81>
8010178c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010178f:	77 cf                	ja     80101760 <balloc+0x50>
    brelse(bp);
80101791:	83 ec 0c             	sub    $0xc,%esp
80101794:	ff 75 e4             	pushl  -0x1c(%ebp)
80101797:	e8 54 ea ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010179c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801017a3:	83 c4 10             	add    $0x10,%esp
801017a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801017a9:	39 05 20 12 11 80    	cmp    %eax,0x80111220
801017af:	77 80                	ja     80101731 <balloc+0x21>
  panic("balloc: out of blocks");
801017b1:	83 ec 0c             	sub    $0xc,%esp
801017b4:	68 82 76 10 80       	push   $0x80107682
801017b9:	e8 42 ef ff ff       	call   80100700 <panic>
801017be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801017c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801017c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801017c6:	09 da                	or     %ebx,%edx
801017c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801017cc:	57                   	push   %edi
801017cd:	e8 1e 1c 00 00       	call   801033f0 <log_write>
        brelse(bp);
801017d2:	89 3c 24             	mov    %edi,(%esp)
801017d5:	e8 16 ea ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801017da:	58                   	pop    %eax
801017db:	5a                   	pop    %edx
801017dc:	56                   	push   %esi
801017dd:	ff 75 d8             	pushl  -0x28(%ebp)
801017e0:	e8 eb e8 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801017e5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801017e8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801017ea:	8d 40 5c             	lea    0x5c(%eax),%eax
801017ed:	68 00 02 00 00       	push   $0x200
801017f2:	6a 00                	push   $0x0
801017f4:	50                   	push   %eax
801017f5:	e8 56 33 00 00       	call   80104b50 <memset>
  log_write(bp);
801017fa:	89 1c 24             	mov    %ebx,(%esp)
801017fd:	e8 ee 1b 00 00       	call   801033f0 <log_write>
  brelse(bp);
80101802:	89 1c 24             	mov    %ebx,(%esp)
80101805:	e8 e6 e9 ff ff       	call   801001f0 <brelse>
}
8010180a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180d:	89 f0                	mov    %esi,%eax
8010180f:	5b                   	pop    %ebx
80101810:	5e                   	pop    %esi
80101811:	5f                   	pop    %edi
80101812:	5d                   	pop    %ebp
80101813:	c3                   	ret    
80101814:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010181b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010181f:	90                   	nop

80101820 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	57                   	push   %edi
80101824:	89 c7                	mov    %eax,%edi
80101826:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101827:	31 f6                	xor    %esi,%esi
{
80101829:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010182a:	bb 74 12 11 80       	mov    $0x80111274,%ebx
{
8010182f:	83 ec 28             	sub    $0x28,%esp
80101832:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101835:	68 40 12 11 80       	push   $0x80111240
8010183a:	e8 01 32 00 00       	call   80104a40 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010183f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101842:	83 c4 10             	add    $0x10,%esp
80101845:	eb 1b                	jmp    80101862 <iget+0x42>
80101847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101850:	39 3b                	cmp    %edi,(%ebx)
80101852:	74 6c                	je     801018c0 <iget+0xa0>
80101854:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010185a:	81 fb 94 2e 11 80    	cmp    $0x80112e94,%ebx
80101860:	73 26                	jae    80101888 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101862:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101865:	85 c9                	test   %ecx,%ecx
80101867:	7f e7                	jg     80101850 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101869:	85 f6                	test   %esi,%esi
8010186b:	75 e7                	jne    80101854 <iget+0x34>
8010186d:	89 d8                	mov    %ebx,%eax
8010186f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101875:	85 c9                	test   %ecx,%ecx
80101877:	75 6e                	jne    801018e7 <iget+0xc7>
80101879:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010187b:	81 fb 94 2e 11 80    	cmp    $0x80112e94,%ebx
80101881:	72 df                	jb     80101862 <iget+0x42>
80101883:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101887:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101888:	85 f6                	test   %esi,%esi
8010188a:	74 73                	je     801018ff <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010188c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010188f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101891:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101894:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010189b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801018a2:	68 40 12 11 80       	push   $0x80111240
801018a7:	e8 54 32 00 00       	call   80104b00 <release>

  return ip;
801018ac:	83 c4 10             	add    $0x10,%esp
}
801018af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018b2:	89 f0                	mov    %esi,%eax
801018b4:	5b                   	pop    %ebx
801018b5:	5e                   	pop    %esi
801018b6:	5f                   	pop    %edi
801018b7:	5d                   	pop    %ebp
801018b8:	c3                   	ret    
801018b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018c0:	39 53 04             	cmp    %edx,0x4(%ebx)
801018c3:	75 8f                	jne    80101854 <iget+0x34>
      release(&icache.lock);
801018c5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801018c8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801018cb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801018cd:	68 40 12 11 80       	push   $0x80111240
      ip->ref++;
801018d2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801018d5:	e8 26 32 00 00       	call   80104b00 <release>
      return ip;
801018da:	83 c4 10             	add    $0x10,%esp
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	89 f0                	mov    %esi,%eax
801018e2:	5b                   	pop    %ebx
801018e3:	5e                   	pop    %esi
801018e4:	5f                   	pop    %edi
801018e5:	5d                   	pop    %ebp
801018e6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018e7:	81 fb 94 2e 11 80    	cmp    $0x80112e94,%ebx
801018ed:	73 10                	jae    801018ff <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018ef:	8b 4b 08             	mov    0x8(%ebx),%ecx
801018f2:	85 c9                	test   %ecx,%ecx
801018f4:	0f 8f 56 ff ff ff    	jg     80101850 <iget+0x30>
801018fa:	e9 6e ff ff ff       	jmp    8010186d <iget+0x4d>
    panic("iget: no inodes");
801018ff:	83 ec 0c             	sub    $0xc,%esp
80101902:	68 98 76 10 80       	push   $0x80107698
80101907:	e8 f4 ed ff ff       	call   80100700 <panic>
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	57                   	push   %edi
80101914:	56                   	push   %esi
80101915:	89 c6                	mov    %eax,%esi
80101917:	53                   	push   %ebx
80101918:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010191b:	83 fa 0b             	cmp    $0xb,%edx
8010191e:	0f 86 84 00 00 00    	jbe    801019a8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101924:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101927:	83 fb 7f             	cmp    $0x7f,%ebx
8010192a:	0f 87 98 00 00 00    	ja     801019c8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101930:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101936:	8b 16                	mov    (%esi),%edx
80101938:	85 c0                	test   %eax,%eax
8010193a:	74 54                	je     80101990 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010193c:	83 ec 08             	sub    $0x8,%esp
8010193f:	50                   	push   %eax
80101940:	52                   	push   %edx
80101941:	e8 8a e7 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101946:	83 c4 10             	add    $0x10,%esp
80101949:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010194d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010194f:	8b 1a                	mov    (%edx),%ebx
80101951:	85 db                	test   %ebx,%ebx
80101953:	74 1b                	je     80101970 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101955:	83 ec 0c             	sub    $0xc,%esp
80101958:	57                   	push   %edi
80101959:	e8 92 e8 ff ff       	call   801001f0 <brelse>
    return addr;
8010195e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101961:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101964:	89 d8                	mov    %ebx,%eax
80101966:	5b                   	pop    %ebx
80101967:	5e                   	pop    %esi
80101968:	5f                   	pop    %edi
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010196f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101970:	8b 06                	mov    (%esi),%eax
80101972:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101975:	e8 96 fd ff ff       	call   80101710 <balloc>
8010197a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010197d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101980:	89 c3                	mov    %eax,%ebx
80101982:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101984:	57                   	push   %edi
80101985:	e8 66 1a 00 00       	call   801033f0 <log_write>
8010198a:	83 c4 10             	add    $0x10,%esp
8010198d:	eb c6                	jmp    80101955 <bmap+0x45>
8010198f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101990:	89 d0                	mov    %edx,%eax
80101992:	e8 79 fd ff ff       	call   80101710 <balloc>
80101997:	8b 16                	mov    (%esi),%edx
80101999:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010199f:	eb 9b                	jmp    8010193c <bmap+0x2c>
801019a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801019a8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801019ab:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801019ae:	85 db                	test   %ebx,%ebx
801019b0:	75 af                	jne    80101961 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801019b2:	8b 00                	mov    (%eax),%eax
801019b4:	e8 57 fd ff ff       	call   80101710 <balloc>
801019b9:	89 47 5c             	mov    %eax,0x5c(%edi)
801019bc:	89 c3                	mov    %eax,%ebx
}
801019be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019c1:	89 d8                	mov    %ebx,%eax
801019c3:	5b                   	pop    %ebx
801019c4:	5e                   	pop    %esi
801019c5:	5f                   	pop    %edi
801019c6:	5d                   	pop    %ebp
801019c7:	c3                   	ret    
  panic("bmap: out of range");
801019c8:	83 ec 0c             	sub    $0xc,%esp
801019cb:	68 a8 76 10 80       	push   $0x801076a8
801019d0:	e8 2b ed ff ff       	call   80100700 <panic>
801019d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019e0 <readsb>:
{
801019e0:	f3 0f 1e fb          	endbr32 
801019e4:	55                   	push   %ebp
801019e5:	89 e5                	mov    %esp,%ebp
801019e7:	56                   	push   %esi
801019e8:	53                   	push   %ebx
801019e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801019ec:	83 ec 08             	sub    $0x8,%esp
801019ef:	6a 01                	push   $0x1
801019f1:	ff 75 08             	pushl  0x8(%ebp)
801019f4:	e8 d7 e6 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801019f9:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801019fc:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801019fe:	8d 40 5c             	lea    0x5c(%eax),%eax
80101a01:	6a 1c                	push   $0x1c
80101a03:	50                   	push   %eax
80101a04:	56                   	push   %esi
80101a05:	e8 e6 31 00 00       	call   80104bf0 <memmove>
  brelse(bp);
80101a0a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a0d:	83 c4 10             	add    $0x10,%esp
}
80101a10:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a13:	5b                   	pop    %ebx
80101a14:	5e                   	pop    %esi
80101a15:	5d                   	pop    %ebp
  brelse(bp);
80101a16:	e9 d5 e7 ff ff       	jmp    801001f0 <brelse>
80101a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a1f:	90                   	nop

80101a20 <iinit>:
{
80101a20:	f3 0f 1e fb          	endbr32 
80101a24:	55                   	push   %ebp
80101a25:	89 e5                	mov    %esp,%ebp
80101a27:	53                   	push   %ebx
80101a28:	bb 80 12 11 80       	mov    $0x80111280,%ebx
80101a2d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101a30:	68 bb 76 10 80       	push   $0x801076bb
80101a35:	68 40 12 11 80       	push   $0x80111240
80101a3a:	e8 81 2e 00 00       	call   801048c0 <initlock>
  for(i = 0; i < NINODE; i++) {
80101a3f:	83 c4 10             	add    $0x10,%esp
80101a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101a48:	83 ec 08             	sub    $0x8,%esp
80101a4b:	68 c2 76 10 80       	push   $0x801076c2
80101a50:	53                   	push   %ebx
80101a51:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101a57:	e8 24 2d 00 00       	call   80104780 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101a5c:	83 c4 10             	add    $0x10,%esp
80101a5f:	81 fb a0 2e 11 80    	cmp    $0x80112ea0,%ebx
80101a65:	75 e1                	jne    80101a48 <iinit+0x28>
  readsb(dev, &sb);
80101a67:	83 ec 08             	sub    $0x8,%esp
80101a6a:	68 20 12 11 80       	push   $0x80111220
80101a6f:	ff 75 08             	pushl  0x8(%ebp)
80101a72:	e8 69 ff ff ff       	call   801019e0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101a77:	ff 35 38 12 11 80    	pushl  0x80111238
80101a7d:	ff 35 34 12 11 80    	pushl  0x80111234
80101a83:	ff 35 30 12 11 80    	pushl  0x80111230
80101a89:	ff 35 2c 12 11 80    	pushl  0x8011122c
80101a8f:	ff 35 28 12 11 80    	pushl  0x80111228
80101a95:	ff 35 24 12 11 80    	pushl  0x80111224
80101a9b:	ff 35 20 12 11 80    	pushl  0x80111220
80101aa1:	68 28 77 10 80       	push   $0x80107728
80101aa6:	e8 d5 ec ff ff       	call   80100780 <cprintf>
}
80101aab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101aae:	83 c4 30             	add    $0x30,%esp
80101ab1:	c9                   	leave  
80101ab2:	c3                   	ret    
80101ab3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ac0 <ialloc>:
{
80101ac0:	f3 0f 1e fb          	endbr32 
80101ac4:	55                   	push   %ebp
80101ac5:	89 e5                	mov    %esp,%ebp
80101ac7:	57                   	push   %edi
80101ac8:	56                   	push   %esi
80101ac9:	53                   	push   %ebx
80101aca:	83 ec 1c             	sub    $0x1c,%esp
80101acd:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101ad0:	83 3d 28 12 11 80 01 	cmpl   $0x1,0x80111228
{
80101ad7:	8b 75 08             	mov    0x8(%ebp),%esi
80101ada:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101add:	0f 86 8d 00 00 00    	jbe    80101b70 <ialloc+0xb0>
80101ae3:	bf 01 00 00 00       	mov    $0x1,%edi
80101ae8:	eb 1d                	jmp    80101b07 <ialloc+0x47>
80101aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101af0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101af3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101af6:	53                   	push   %ebx
80101af7:	e8 f4 e6 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101afc:	83 c4 10             	add    $0x10,%esp
80101aff:	3b 3d 28 12 11 80    	cmp    0x80111228,%edi
80101b05:	73 69                	jae    80101b70 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101b07:	89 f8                	mov    %edi,%eax
80101b09:	83 ec 08             	sub    $0x8,%esp
80101b0c:	c1 e8 03             	shr    $0x3,%eax
80101b0f:	03 05 34 12 11 80    	add    0x80111234,%eax
80101b15:	50                   	push   %eax
80101b16:	56                   	push   %esi
80101b17:	e8 b4 e5 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101b1c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101b1f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101b21:	89 f8                	mov    %edi,%eax
80101b23:	83 e0 07             	and    $0x7,%eax
80101b26:	c1 e0 06             	shl    $0x6,%eax
80101b29:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101b2d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101b31:	75 bd                	jne    80101af0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101b33:	83 ec 04             	sub    $0x4,%esp
80101b36:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101b39:	6a 40                	push   $0x40
80101b3b:	6a 00                	push   $0x0
80101b3d:	51                   	push   %ecx
80101b3e:	e8 0d 30 00 00       	call   80104b50 <memset>
      dip->type = type;
80101b43:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101b47:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b4a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101b4d:	89 1c 24             	mov    %ebx,(%esp)
80101b50:	e8 9b 18 00 00       	call   801033f0 <log_write>
      brelse(bp);
80101b55:	89 1c 24             	mov    %ebx,(%esp)
80101b58:	e8 93 e6 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101b5d:	83 c4 10             	add    $0x10,%esp
}
80101b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101b63:	89 fa                	mov    %edi,%edx
}
80101b65:	5b                   	pop    %ebx
      return iget(dev, inum);
80101b66:	89 f0                	mov    %esi,%eax
}
80101b68:	5e                   	pop    %esi
80101b69:	5f                   	pop    %edi
80101b6a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101b6b:	e9 b0 fc ff ff       	jmp    80101820 <iget>
  panic("ialloc: no inodes");
80101b70:	83 ec 0c             	sub    $0xc,%esp
80101b73:	68 c8 76 10 80       	push   $0x801076c8
80101b78:	e8 83 eb ff ff       	call   80100700 <panic>
80101b7d:	8d 76 00             	lea    0x0(%esi),%esi

80101b80 <iupdate>:
{
80101b80:	f3 0f 1e fb          	endbr32 
80101b84:	55                   	push   %ebp
80101b85:	89 e5                	mov    %esp,%ebp
80101b87:	56                   	push   %esi
80101b88:	53                   	push   %ebx
80101b89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b8c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101b8f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b92:	83 ec 08             	sub    $0x8,%esp
80101b95:	c1 e8 03             	shr    $0x3,%eax
80101b98:	03 05 34 12 11 80    	add    0x80111234,%eax
80101b9e:	50                   	push   %eax
80101b9f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101ba2:	e8 29 e5 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101ba7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bab:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101bae:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101bb0:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101bb3:	83 e0 07             	and    $0x7,%eax
80101bb6:	c1 e0 06             	shl    $0x6,%eax
80101bb9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101bbd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101bc0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bc4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101bc7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101bcb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101bcf:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101bd3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101bd7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101bdb:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101bde:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101be1:	6a 34                	push   $0x34
80101be3:	53                   	push   %ebx
80101be4:	50                   	push   %eax
80101be5:	e8 06 30 00 00       	call   80104bf0 <memmove>
  log_write(bp);
80101bea:	89 34 24             	mov    %esi,(%esp)
80101bed:	e8 fe 17 00 00       	call   801033f0 <log_write>
  brelse(bp);
80101bf2:	89 75 08             	mov    %esi,0x8(%ebp)
80101bf5:	83 c4 10             	add    $0x10,%esp
}
80101bf8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101bfb:	5b                   	pop    %ebx
80101bfc:	5e                   	pop    %esi
80101bfd:	5d                   	pop    %ebp
  brelse(bp);
80101bfe:	e9 ed e5 ff ff       	jmp    801001f0 <brelse>
80101c03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c10 <idup>:
{
80101c10:	f3 0f 1e fb          	endbr32 
80101c14:	55                   	push   %ebp
80101c15:	89 e5                	mov    %esp,%ebp
80101c17:	53                   	push   %ebx
80101c18:	83 ec 10             	sub    $0x10,%esp
80101c1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101c1e:	68 40 12 11 80       	push   $0x80111240
80101c23:	e8 18 2e 00 00       	call   80104a40 <acquire>
  ip->ref++;
80101c28:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c2c:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101c33:	e8 c8 2e 00 00       	call   80104b00 <release>
}
80101c38:	89 d8                	mov    %ebx,%eax
80101c3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c3d:	c9                   	leave  
80101c3e:	c3                   	ret    
80101c3f:	90                   	nop

80101c40 <ilock>:
{
80101c40:	f3 0f 1e fb          	endbr32 
80101c44:	55                   	push   %ebp
80101c45:	89 e5                	mov    %esp,%ebp
80101c47:	56                   	push   %esi
80101c48:	53                   	push   %ebx
80101c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101c4c:	85 db                	test   %ebx,%ebx
80101c4e:	0f 84 b3 00 00 00    	je     80101d07 <ilock+0xc7>
80101c54:	8b 53 08             	mov    0x8(%ebx),%edx
80101c57:	85 d2                	test   %edx,%edx
80101c59:	0f 8e a8 00 00 00    	jle    80101d07 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101c5f:	83 ec 0c             	sub    $0xc,%esp
80101c62:	8d 43 0c             	lea    0xc(%ebx),%eax
80101c65:	50                   	push   %eax
80101c66:	e8 55 2b 00 00       	call   801047c0 <acquiresleep>
  if(ip->valid == 0){
80101c6b:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101c6e:	83 c4 10             	add    $0x10,%esp
80101c71:	85 c0                	test   %eax,%eax
80101c73:	74 0b                	je     80101c80 <ilock+0x40>
}
80101c75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c78:	5b                   	pop    %ebx
80101c79:	5e                   	pop    %esi
80101c7a:	5d                   	pop    %ebp
80101c7b:	c3                   	ret    
80101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c80:	8b 43 04             	mov    0x4(%ebx),%eax
80101c83:	83 ec 08             	sub    $0x8,%esp
80101c86:	c1 e8 03             	shr    $0x3,%eax
80101c89:	03 05 34 12 11 80    	add    0x80111234,%eax
80101c8f:	50                   	push   %eax
80101c90:	ff 33                	pushl  (%ebx)
80101c92:	e8 39 e4 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c97:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c9a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101c9c:	8b 43 04             	mov    0x4(%ebx),%eax
80101c9f:	83 e0 07             	and    $0x7,%eax
80101ca2:	c1 e0 06             	shl    $0x6,%eax
80101ca5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101ca9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101cac:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101caf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101cb3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101cb7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101cbb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101cbf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101cc3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101cc7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101ccb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101cce:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101cd1:	6a 34                	push   $0x34
80101cd3:	50                   	push   %eax
80101cd4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101cd7:	50                   	push   %eax
80101cd8:	e8 13 2f 00 00       	call   80104bf0 <memmove>
    brelse(bp);
80101cdd:	89 34 24             	mov    %esi,(%esp)
80101ce0:	e8 0b e5 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101ce5:	83 c4 10             	add    $0x10,%esp
80101ce8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101ced:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101cf4:	0f 85 7b ff ff ff    	jne    80101c75 <ilock+0x35>
      panic("ilock: no type");
80101cfa:	83 ec 0c             	sub    $0xc,%esp
80101cfd:	68 e0 76 10 80       	push   $0x801076e0
80101d02:	e8 f9 e9 ff ff       	call   80100700 <panic>
    panic("ilock");
80101d07:	83 ec 0c             	sub    $0xc,%esp
80101d0a:	68 da 76 10 80       	push   $0x801076da
80101d0f:	e8 ec e9 ff ff       	call   80100700 <panic>
80101d14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d1f:	90                   	nop

80101d20 <iunlock>:
{
80101d20:	f3 0f 1e fb          	endbr32 
80101d24:	55                   	push   %ebp
80101d25:	89 e5                	mov    %esp,%ebp
80101d27:	56                   	push   %esi
80101d28:	53                   	push   %ebx
80101d29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d2c:	85 db                	test   %ebx,%ebx
80101d2e:	74 28                	je     80101d58 <iunlock+0x38>
80101d30:	83 ec 0c             	sub    $0xc,%esp
80101d33:	8d 73 0c             	lea    0xc(%ebx),%esi
80101d36:	56                   	push   %esi
80101d37:	e8 24 2b 00 00       	call   80104860 <holdingsleep>
80101d3c:	83 c4 10             	add    $0x10,%esp
80101d3f:	85 c0                	test   %eax,%eax
80101d41:	74 15                	je     80101d58 <iunlock+0x38>
80101d43:	8b 43 08             	mov    0x8(%ebx),%eax
80101d46:	85 c0                	test   %eax,%eax
80101d48:	7e 0e                	jle    80101d58 <iunlock+0x38>
  releasesleep(&ip->lock);
80101d4a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101d4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d50:	5b                   	pop    %ebx
80101d51:	5e                   	pop    %esi
80101d52:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101d53:	e9 c8 2a 00 00       	jmp    80104820 <releasesleep>
    panic("iunlock");
80101d58:	83 ec 0c             	sub    $0xc,%esp
80101d5b:	68 ef 76 10 80       	push   $0x801076ef
80101d60:	e8 9b e9 ff ff       	call   80100700 <panic>
80101d65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d70 <iput>:
{
80101d70:	f3 0f 1e fb          	endbr32 
80101d74:	55                   	push   %ebp
80101d75:	89 e5                	mov    %esp,%ebp
80101d77:	57                   	push   %edi
80101d78:	56                   	push   %esi
80101d79:	53                   	push   %ebx
80101d7a:	83 ec 28             	sub    $0x28,%esp
80101d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101d80:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101d83:	57                   	push   %edi
80101d84:	e8 37 2a 00 00       	call   801047c0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101d89:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101d8c:	83 c4 10             	add    $0x10,%esp
80101d8f:	85 d2                	test   %edx,%edx
80101d91:	74 07                	je     80101d9a <iput+0x2a>
80101d93:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101d98:	74 36                	je     80101dd0 <iput+0x60>
  releasesleep(&ip->lock);
80101d9a:	83 ec 0c             	sub    $0xc,%esp
80101d9d:	57                   	push   %edi
80101d9e:	e8 7d 2a 00 00       	call   80104820 <releasesleep>
  acquire(&icache.lock);
80101da3:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101daa:	e8 91 2c 00 00       	call   80104a40 <acquire>
  ip->ref--;
80101daf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101db3:	83 c4 10             	add    $0x10,%esp
80101db6:	c7 45 08 40 12 11 80 	movl   $0x80111240,0x8(%ebp)
}
80101dbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc0:	5b                   	pop    %ebx
80101dc1:	5e                   	pop    %esi
80101dc2:	5f                   	pop    %edi
80101dc3:	5d                   	pop    %ebp
  release(&icache.lock);
80101dc4:	e9 37 2d 00 00       	jmp    80104b00 <release>
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	68 40 12 11 80       	push   $0x80111240
80101dd8:	e8 63 2c 00 00       	call   80104a40 <acquire>
    int r = ip->ref;
80101ddd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101de0:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101de7:	e8 14 2d 00 00       	call   80104b00 <release>
    if(r == 1){
80101dec:	83 c4 10             	add    $0x10,%esp
80101def:	83 fe 01             	cmp    $0x1,%esi
80101df2:	75 a6                	jne    80101d9a <iput+0x2a>
80101df4:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101dfa:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101dfd:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101e00:	89 cf                	mov    %ecx,%edi
80101e02:	eb 0b                	jmp    80101e0f <iput+0x9f>
80101e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e08:	83 c6 04             	add    $0x4,%esi
80101e0b:	39 fe                	cmp    %edi,%esi
80101e0d:	74 19                	je     80101e28 <iput+0xb8>
    if(ip->addrs[i]){
80101e0f:	8b 16                	mov    (%esi),%edx
80101e11:	85 d2                	test   %edx,%edx
80101e13:	74 f3                	je     80101e08 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101e15:	8b 03                	mov    (%ebx),%eax
80101e17:	e8 74 f8 ff ff       	call   80101690 <bfree>
      ip->addrs[i] = 0;
80101e1c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101e22:	eb e4                	jmp    80101e08 <iput+0x98>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101e28:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101e2e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101e31:	85 c0                	test   %eax,%eax
80101e33:	75 33                	jne    80101e68 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101e35:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101e38:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101e3f:	53                   	push   %ebx
80101e40:	e8 3b fd ff ff       	call   80101b80 <iupdate>
      ip->type = 0;
80101e45:	31 c0                	xor    %eax,%eax
80101e47:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101e4b:	89 1c 24             	mov    %ebx,(%esp)
80101e4e:	e8 2d fd ff ff       	call   80101b80 <iupdate>
      ip->valid = 0;
80101e53:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101e5a:	83 c4 10             	add    $0x10,%esp
80101e5d:	e9 38 ff ff ff       	jmp    80101d9a <iput+0x2a>
80101e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e68:	83 ec 08             	sub    $0x8,%esp
80101e6b:	50                   	push   %eax
80101e6c:	ff 33                	pushl  (%ebx)
80101e6e:	e8 5d e2 ff ff       	call   801000d0 <bread>
80101e73:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101e76:	83 c4 10             	add    $0x10,%esp
80101e79:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101e7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e82:	8d 70 5c             	lea    0x5c(%eax),%esi
80101e85:	89 cf                	mov    %ecx,%edi
80101e87:	eb 0e                	jmp    80101e97 <iput+0x127>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	83 c6 04             	add    $0x4,%esi
80101e93:	39 f7                	cmp    %esi,%edi
80101e95:	74 19                	je     80101eb0 <iput+0x140>
      if(a[j])
80101e97:	8b 16                	mov    (%esi),%edx
80101e99:	85 d2                	test   %edx,%edx
80101e9b:	74 f3                	je     80101e90 <iput+0x120>
        bfree(ip->dev, a[j]);
80101e9d:	8b 03                	mov    (%ebx),%eax
80101e9f:	e8 ec f7 ff ff       	call   80101690 <bfree>
80101ea4:	eb ea                	jmp    80101e90 <iput+0x120>
80101ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ead:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101eb0:	83 ec 0c             	sub    $0xc,%esp
80101eb3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101eb6:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101eb9:	e8 32 e3 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ebe:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101ec4:	8b 03                	mov    (%ebx),%eax
80101ec6:	e8 c5 f7 ff ff       	call   80101690 <bfree>
    ip->addrs[NDIRECT] = 0;
80101ecb:	83 c4 10             	add    $0x10,%esp
80101ece:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101ed5:	00 00 00 
80101ed8:	e9 58 ff ff ff       	jmp    80101e35 <iput+0xc5>
80101edd:	8d 76 00             	lea    0x0(%esi),%esi

80101ee0 <iunlockput>:
{
80101ee0:	f3 0f 1e fb          	endbr32 
80101ee4:	55                   	push   %ebp
80101ee5:	89 e5                	mov    %esp,%ebp
80101ee7:	53                   	push   %ebx
80101ee8:	83 ec 10             	sub    $0x10,%esp
80101eeb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101eee:	53                   	push   %ebx
80101eef:	e8 2c fe ff ff       	call   80101d20 <iunlock>
  iput(ip);
80101ef4:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ef7:	83 c4 10             	add    $0x10,%esp
}
80101efa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101efd:	c9                   	leave  
  iput(ip);
80101efe:	e9 6d fe ff ff       	jmp    80101d70 <iput>
80101f03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f10 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f10:	f3 0f 1e fb          	endbr32 
80101f14:	55                   	push   %ebp
80101f15:	89 e5                	mov    %esp,%ebp
80101f17:	8b 55 08             	mov    0x8(%ebp),%edx
80101f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101f1d:	8b 0a                	mov    (%edx),%ecx
80101f1f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101f22:	8b 4a 04             	mov    0x4(%edx),%ecx
80101f25:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101f28:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101f2c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101f2f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101f33:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101f37:	8b 52 58             	mov    0x58(%edx),%edx
80101f3a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f3d:	5d                   	pop    %ebp
80101f3e:	c3                   	ret    
80101f3f:	90                   	nop

80101f40 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f40:	f3 0f 1e fb          	endbr32 
80101f44:	55                   	push   %ebp
80101f45:	89 e5                	mov    %esp,%ebp
80101f47:	57                   	push   %edi
80101f48:	56                   	push   %esi
80101f49:	53                   	push   %ebx
80101f4a:	83 ec 1c             	sub    $0x1c,%esp
80101f4d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101f50:	8b 45 08             	mov    0x8(%ebp),%eax
80101f53:	8b 75 10             	mov    0x10(%ebp),%esi
80101f56:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101f59:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f5c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101f61:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101f64:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101f67:	0f 84 a3 00 00 00    	je     80102010 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101f6d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f70:	8b 40 58             	mov    0x58(%eax),%eax
80101f73:	39 c6                	cmp    %eax,%esi
80101f75:	0f 87 b6 00 00 00    	ja     80102031 <readi+0xf1>
80101f7b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101f7e:	31 c9                	xor    %ecx,%ecx
80101f80:	89 da                	mov    %ebx,%edx
80101f82:	01 f2                	add    %esi,%edx
80101f84:	0f 92 c1             	setb   %cl
80101f87:	89 cf                	mov    %ecx,%edi
80101f89:	0f 82 a2 00 00 00    	jb     80102031 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101f8f:	89 c1                	mov    %eax,%ecx
80101f91:	29 f1                	sub    %esi,%ecx
80101f93:	39 d0                	cmp    %edx,%eax
80101f95:	0f 43 cb             	cmovae %ebx,%ecx
80101f98:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f9b:	85 c9                	test   %ecx,%ecx
80101f9d:	74 63                	je     80102002 <readi+0xc2>
80101f9f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fa0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101fa3:	89 f2                	mov    %esi,%edx
80101fa5:	c1 ea 09             	shr    $0x9,%edx
80101fa8:	89 d8                	mov    %ebx,%eax
80101faa:	e8 61 f9 ff ff       	call   80101910 <bmap>
80101faf:	83 ec 08             	sub    $0x8,%esp
80101fb2:	50                   	push   %eax
80101fb3:	ff 33                	pushl  (%ebx)
80101fb5:	e8 16 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101fba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101fbd:	b9 00 02 00 00       	mov    $0x200,%ecx
80101fc2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fc5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101fc7:	89 f0                	mov    %esi,%eax
80101fc9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fce:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101fd0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fd3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101fd5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101fd9:	39 d9                	cmp    %ebx,%ecx
80101fdb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101fde:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fdf:	01 df                	add    %ebx,%edi
80101fe1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101fe3:	50                   	push   %eax
80101fe4:	ff 75 e0             	pushl  -0x20(%ebp)
80101fe7:	e8 04 2c 00 00       	call   80104bf0 <memmove>
    brelse(bp);
80101fec:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101fef:	89 14 24             	mov    %edx,(%esp)
80101ff2:	e8 f9 e1 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ff7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101ffa:	83 c4 10             	add    $0x10,%esp
80101ffd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102000:	77 9e                	ja     80101fa0 <readi+0x60>
  }
  return n;
80102002:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102005:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102008:	5b                   	pop    %ebx
80102009:	5e                   	pop    %esi
8010200a:	5f                   	pop    %edi
8010200b:	5d                   	pop    %ebp
8010200c:	c3                   	ret    
8010200d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102010:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102014:	66 83 f8 09          	cmp    $0x9,%ax
80102018:	77 17                	ja     80102031 <readi+0xf1>
8010201a:	8b 04 c5 c0 11 11 80 	mov    -0x7feeee40(,%eax,8),%eax
80102021:	85 c0                	test   %eax,%eax
80102023:	74 0c                	je     80102031 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102025:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102028:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010202b:	5b                   	pop    %ebx
8010202c:	5e                   	pop    %esi
8010202d:	5f                   	pop    %edi
8010202e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010202f:	ff e0                	jmp    *%eax
      return -1;
80102031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102036:	eb cd                	jmp    80102005 <readi+0xc5>
80102038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010203f:	90                   	nop

80102040 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102040:	f3 0f 1e fb          	endbr32 
80102044:	55                   	push   %ebp
80102045:	89 e5                	mov    %esp,%ebp
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
8010204a:	83 ec 1c             	sub    $0x1c,%esp
8010204d:	8b 45 08             	mov    0x8(%ebp),%eax
80102050:	8b 75 0c             	mov    0xc(%ebp),%esi
80102053:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102056:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
8010205b:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010205e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102061:	8b 75 10             	mov    0x10(%ebp),%esi
80102064:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80102067:	0f 84 b3 00 00 00    	je     80102120 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
8010206d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102070:	39 70 58             	cmp    %esi,0x58(%eax)
80102073:	0f 82 e3 00 00 00    	jb     8010215c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102079:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010207c:	89 f8                	mov    %edi,%eax
8010207e:	01 f0                	add    %esi,%eax
80102080:	0f 82 d6 00 00 00    	jb     8010215c <writei+0x11c>
80102086:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010208b:	0f 87 cb 00 00 00    	ja     8010215c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102091:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102098:	85 ff                	test   %edi,%edi
8010209a:	74 75                	je     80102111 <writei+0xd1>
8010209c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020a0:	8b 7d d8             	mov    -0x28(%ebp),%edi
801020a3:	89 f2                	mov    %esi,%edx
801020a5:	c1 ea 09             	shr    $0x9,%edx
801020a8:	89 f8                	mov    %edi,%eax
801020aa:	e8 61 f8 ff ff       	call   80101910 <bmap>
801020af:	83 ec 08             	sub    $0x8,%esp
801020b2:	50                   	push   %eax
801020b3:	ff 37                	pushl  (%edi)
801020b5:	e8 16 e0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801020ba:	b9 00 02 00 00       	mov    $0x200,%ecx
801020bf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801020c2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020c5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
801020c7:	89 f0                	mov    %esi,%eax
801020c9:	83 c4 0c             	add    $0xc,%esp
801020cc:	25 ff 01 00 00       	and    $0x1ff,%eax
801020d1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
801020d3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801020d7:	39 d9                	cmp    %ebx,%ecx
801020d9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
801020dc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020dd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
801020df:	ff 75 dc             	pushl  -0x24(%ebp)
801020e2:	50                   	push   %eax
801020e3:	e8 08 2b 00 00       	call   80104bf0 <memmove>
    log_write(bp);
801020e8:	89 3c 24             	mov    %edi,(%esp)
801020eb:	e8 00 13 00 00       	call   801033f0 <log_write>
    brelse(bp);
801020f0:	89 3c 24             	mov    %edi,(%esp)
801020f3:	e8 f8 e0 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020f8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102101:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102104:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102107:	77 97                	ja     801020a0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102109:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010210c:	3b 70 58             	cmp    0x58(%eax),%esi
8010210f:	77 37                	ja     80102148 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102111:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102120:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102124:	66 83 f8 09          	cmp    $0x9,%ax
80102128:	77 32                	ja     8010215c <writei+0x11c>
8010212a:	8b 04 c5 c4 11 11 80 	mov    -0x7feeee3c(,%eax,8),%eax
80102131:	85 c0                	test   %eax,%eax
80102133:	74 27                	je     8010215c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102135:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102138:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010213b:	5b                   	pop    %ebx
8010213c:	5e                   	pop    %esi
8010213d:	5f                   	pop    %edi
8010213e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010213f:	ff e0                	jmp    *%eax
80102141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102148:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010214b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010214e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102151:	50                   	push   %eax
80102152:	e8 29 fa ff ff       	call   80101b80 <iupdate>
80102157:	83 c4 10             	add    $0x10,%esp
8010215a:	eb b5                	jmp    80102111 <writei+0xd1>
      return -1;
8010215c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102161:	eb b1                	jmp    80102114 <writei+0xd4>
80102163:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010216a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102170 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102170:	f3 0f 1e fb          	endbr32 
80102174:	55                   	push   %ebp
80102175:	89 e5                	mov    %esp,%ebp
80102177:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010217a:	6a 0e                	push   $0xe
8010217c:	ff 75 0c             	pushl  0xc(%ebp)
8010217f:	ff 75 08             	pushl  0x8(%ebp)
80102182:	e8 d9 2a 00 00       	call   80104c60 <strncmp>
}
80102187:	c9                   	leave  
80102188:	c3                   	ret    
80102189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102190 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102190:	f3 0f 1e fb          	endbr32 
80102194:	55                   	push   %ebp
80102195:	89 e5                	mov    %esp,%ebp
80102197:	57                   	push   %edi
80102198:	56                   	push   %esi
80102199:	53                   	push   %ebx
8010219a:	83 ec 1c             	sub    $0x1c,%esp
8010219d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801021a5:	0f 85 89 00 00 00    	jne    80102234 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021ab:	8b 53 58             	mov    0x58(%ebx),%edx
801021ae:	31 ff                	xor    %edi,%edi
801021b0:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021b3:	85 d2                	test   %edx,%edx
801021b5:	74 42                	je     801021f9 <dirlookup+0x69>
801021b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021be:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021c0:	6a 10                	push   $0x10
801021c2:	57                   	push   %edi
801021c3:	56                   	push   %esi
801021c4:	53                   	push   %ebx
801021c5:	e8 76 fd ff ff       	call   80101f40 <readi>
801021ca:	83 c4 10             	add    $0x10,%esp
801021cd:	83 f8 10             	cmp    $0x10,%eax
801021d0:	75 55                	jne    80102227 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
801021d2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801021d7:	74 18                	je     801021f1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
801021d9:	83 ec 04             	sub    $0x4,%esp
801021dc:	8d 45 da             	lea    -0x26(%ebp),%eax
801021df:	6a 0e                	push   $0xe
801021e1:	50                   	push   %eax
801021e2:	ff 75 0c             	pushl  0xc(%ebp)
801021e5:	e8 76 2a 00 00       	call   80104c60 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801021ea:	83 c4 10             	add    $0x10,%esp
801021ed:	85 c0                	test   %eax,%eax
801021ef:	74 17                	je     80102208 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
801021f1:	83 c7 10             	add    $0x10,%edi
801021f4:	3b 7b 58             	cmp    0x58(%ebx),%edi
801021f7:	72 c7                	jb     801021c0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801021f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801021fc:	31 c0                	xor    %eax,%eax
}
801021fe:	5b                   	pop    %ebx
801021ff:	5e                   	pop    %esi
80102200:	5f                   	pop    %edi
80102201:	5d                   	pop    %ebp
80102202:	c3                   	ret    
80102203:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102207:	90                   	nop
      if(poff)
80102208:	8b 45 10             	mov    0x10(%ebp),%eax
8010220b:	85 c0                	test   %eax,%eax
8010220d:	74 05                	je     80102214 <dirlookup+0x84>
        *poff = off;
8010220f:	8b 45 10             	mov    0x10(%ebp),%eax
80102212:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80102214:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102218:	8b 03                	mov    (%ebx),%eax
8010221a:	e8 01 f6 ff ff       	call   80101820 <iget>
}
8010221f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102222:	5b                   	pop    %ebx
80102223:	5e                   	pop    %esi
80102224:	5f                   	pop    %edi
80102225:	5d                   	pop    %ebp
80102226:	c3                   	ret    
      panic("dirlookup read");
80102227:	83 ec 0c             	sub    $0xc,%esp
8010222a:	68 09 77 10 80       	push   $0x80107709
8010222f:	e8 cc e4 ff ff       	call   80100700 <panic>
    panic("dirlookup not DIR");
80102234:	83 ec 0c             	sub    $0xc,%esp
80102237:	68 f7 76 10 80       	push   $0x801076f7
8010223c:	e8 bf e4 ff ff       	call   80100700 <panic>
80102241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010224f:	90                   	nop

80102250 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	57                   	push   %edi
80102254:	56                   	push   %esi
80102255:	53                   	push   %ebx
80102256:	89 c3                	mov    %eax,%ebx
80102258:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010225b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010225e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102261:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102264:	0f 84 86 01 00 00    	je     801023f0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010226a:	e8 d1 1b 00 00       	call   80103e40 <myproc>
  acquire(&icache.lock);
8010226f:	83 ec 0c             	sub    $0xc,%esp
80102272:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102274:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102277:	68 40 12 11 80       	push   $0x80111240
8010227c:	e8 bf 27 00 00       	call   80104a40 <acquire>
  ip->ref++;
80102281:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102285:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
8010228c:	e8 6f 28 00 00       	call   80104b00 <release>
80102291:	83 c4 10             	add    $0x10,%esp
80102294:	eb 0d                	jmp    801022a3 <namex+0x53>
80102296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010229d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
801022a0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
801022a3:	0f b6 07             	movzbl (%edi),%eax
801022a6:	3c 2f                	cmp    $0x2f,%al
801022a8:	74 f6                	je     801022a0 <namex+0x50>
  if(*path == 0)
801022aa:	84 c0                	test   %al,%al
801022ac:	0f 84 ee 00 00 00    	je     801023a0 <namex+0x150>
  while(*path != '/' && *path != 0)
801022b2:	0f b6 07             	movzbl (%edi),%eax
801022b5:	84 c0                	test   %al,%al
801022b7:	0f 84 fb 00 00 00    	je     801023b8 <namex+0x168>
801022bd:	89 fb                	mov    %edi,%ebx
801022bf:	3c 2f                	cmp    $0x2f,%al
801022c1:	0f 84 f1 00 00 00    	je     801023b8 <namex+0x168>
801022c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ce:	66 90                	xchg   %ax,%ax
801022d0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
801022d4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
801022d7:	3c 2f                	cmp    $0x2f,%al
801022d9:	74 04                	je     801022df <namex+0x8f>
801022db:	84 c0                	test   %al,%al
801022dd:	75 f1                	jne    801022d0 <namex+0x80>
  len = path - s;
801022df:	89 d8                	mov    %ebx,%eax
801022e1:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
801022e3:	83 f8 0d             	cmp    $0xd,%eax
801022e6:	0f 8e 84 00 00 00    	jle    80102370 <namex+0x120>
    memmove(name, s, DIRSIZ);
801022ec:	83 ec 04             	sub    $0x4,%esp
801022ef:	6a 0e                	push   $0xe
801022f1:	57                   	push   %edi
    path++;
801022f2:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
801022f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801022f7:	e8 f4 28 00 00       	call   80104bf0 <memmove>
801022fc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801022ff:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102302:	75 0c                	jne    80102310 <namex+0xc0>
80102304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102308:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
8010230b:	80 3f 2f             	cmpb   $0x2f,(%edi)
8010230e:	74 f8                	je     80102308 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102310:	83 ec 0c             	sub    $0xc,%esp
80102313:	56                   	push   %esi
80102314:	e8 27 f9 ff ff       	call   80101c40 <ilock>
    if(ip->type != T_DIR){
80102319:	83 c4 10             	add    $0x10,%esp
8010231c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102321:	0f 85 a1 00 00 00    	jne    801023c8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102327:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010232a:	85 d2                	test   %edx,%edx
8010232c:	74 09                	je     80102337 <namex+0xe7>
8010232e:	80 3f 00             	cmpb   $0x0,(%edi)
80102331:	0f 84 d9 00 00 00    	je     80102410 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	6a 00                	push   $0x0
8010233c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010233f:	56                   	push   %esi
80102340:	e8 4b fe ff ff       	call   80102190 <dirlookup>
80102345:	83 c4 10             	add    $0x10,%esp
80102348:	89 c3                	mov    %eax,%ebx
8010234a:	85 c0                	test   %eax,%eax
8010234c:	74 7a                	je     801023c8 <namex+0x178>
  iunlock(ip);
8010234e:	83 ec 0c             	sub    $0xc,%esp
80102351:	56                   	push   %esi
80102352:	e8 c9 f9 ff ff       	call   80101d20 <iunlock>
  iput(ip);
80102357:	89 34 24             	mov    %esi,(%esp)
8010235a:	89 de                	mov    %ebx,%esi
8010235c:	e8 0f fa ff ff       	call   80101d70 <iput>
80102361:	83 c4 10             	add    $0x10,%esp
80102364:	e9 3a ff ff ff       	jmp    801022a3 <namex+0x53>
80102369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102370:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102373:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102376:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102379:	83 ec 04             	sub    $0x4,%esp
8010237c:	50                   	push   %eax
8010237d:	57                   	push   %edi
    name[len] = 0;
8010237e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102380:	ff 75 e4             	pushl  -0x1c(%ebp)
80102383:	e8 68 28 00 00       	call   80104bf0 <memmove>
    name[len] = 0;
80102388:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010238b:	83 c4 10             	add    $0x10,%esp
8010238e:	c6 00 00             	movb   $0x0,(%eax)
80102391:	e9 69 ff ff ff       	jmp    801022ff <namex+0xaf>
80102396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010239d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801023a3:	85 c0                	test   %eax,%eax
801023a5:	0f 85 85 00 00 00    	jne    80102430 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
801023ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023ae:	89 f0                	mov    %esi,%eax
801023b0:	5b                   	pop    %ebx
801023b1:	5e                   	pop    %esi
801023b2:	5f                   	pop    %edi
801023b3:	5d                   	pop    %ebp
801023b4:	c3                   	ret    
801023b5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
801023b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801023bb:	89 fb                	mov    %edi,%ebx
801023bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801023c0:	31 c0                	xor    %eax,%eax
801023c2:	eb b5                	jmp    80102379 <namex+0x129>
801023c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801023c8:	83 ec 0c             	sub    $0xc,%esp
801023cb:	56                   	push   %esi
801023cc:	e8 4f f9 ff ff       	call   80101d20 <iunlock>
  iput(ip);
801023d1:	89 34 24             	mov    %esi,(%esp)
      return 0;
801023d4:	31 f6                	xor    %esi,%esi
  iput(ip);
801023d6:	e8 95 f9 ff ff       	call   80101d70 <iput>
      return 0;
801023db:	83 c4 10             	add    $0x10,%esp
}
801023de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023e1:	89 f0                	mov    %esi,%eax
801023e3:	5b                   	pop    %ebx
801023e4:	5e                   	pop    %esi
801023e5:	5f                   	pop    %edi
801023e6:	5d                   	pop    %ebp
801023e7:	c3                   	ret    
801023e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ef:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
801023f0:	ba 01 00 00 00       	mov    $0x1,%edx
801023f5:	b8 01 00 00 00       	mov    $0x1,%eax
801023fa:	89 df                	mov    %ebx,%edi
801023fc:	e8 1f f4 ff ff       	call   80101820 <iget>
80102401:	89 c6                	mov    %eax,%esi
80102403:	e9 9b fe ff ff       	jmp    801022a3 <namex+0x53>
80102408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010240f:	90                   	nop
      iunlock(ip);
80102410:	83 ec 0c             	sub    $0xc,%esp
80102413:	56                   	push   %esi
80102414:	e8 07 f9 ff ff       	call   80101d20 <iunlock>
      return ip;
80102419:	83 c4 10             	add    $0x10,%esp
}
8010241c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010241f:	89 f0                	mov    %esi,%eax
80102421:	5b                   	pop    %ebx
80102422:	5e                   	pop    %esi
80102423:	5f                   	pop    %edi
80102424:	5d                   	pop    %ebp
80102425:	c3                   	ret    
80102426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80102430:	83 ec 0c             	sub    $0xc,%esp
80102433:	56                   	push   %esi
    return 0;
80102434:	31 f6                	xor    %esi,%esi
    iput(ip);
80102436:	e8 35 f9 ff ff       	call   80101d70 <iput>
    return 0;
8010243b:	83 c4 10             	add    $0x10,%esp
8010243e:	e9 68 ff ff ff       	jmp    801023ab <namex+0x15b>
80102443:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010244a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102450 <dirlink>:
{
80102450:	f3 0f 1e fb          	endbr32 
80102454:	55                   	push   %ebp
80102455:	89 e5                	mov    %esp,%ebp
80102457:	57                   	push   %edi
80102458:	56                   	push   %esi
80102459:	53                   	push   %ebx
8010245a:	83 ec 20             	sub    $0x20,%esp
8010245d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102460:	6a 00                	push   $0x0
80102462:	ff 75 0c             	pushl  0xc(%ebp)
80102465:	53                   	push   %ebx
80102466:	e8 25 fd ff ff       	call   80102190 <dirlookup>
8010246b:	83 c4 10             	add    $0x10,%esp
8010246e:	85 c0                	test   %eax,%eax
80102470:	75 6b                	jne    801024dd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102472:	8b 7b 58             	mov    0x58(%ebx),%edi
80102475:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102478:	85 ff                	test   %edi,%edi
8010247a:	74 2d                	je     801024a9 <dirlink+0x59>
8010247c:	31 ff                	xor    %edi,%edi
8010247e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102481:	eb 0d                	jmp    80102490 <dirlink+0x40>
80102483:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102487:	90                   	nop
80102488:	83 c7 10             	add    $0x10,%edi
8010248b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010248e:	73 19                	jae    801024a9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102490:	6a 10                	push   $0x10
80102492:	57                   	push   %edi
80102493:	56                   	push   %esi
80102494:	53                   	push   %ebx
80102495:	e8 a6 fa ff ff       	call   80101f40 <readi>
8010249a:	83 c4 10             	add    $0x10,%esp
8010249d:	83 f8 10             	cmp    $0x10,%eax
801024a0:	75 4e                	jne    801024f0 <dirlink+0xa0>
    if(de.inum == 0)
801024a2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801024a7:	75 df                	jne    80102488 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
801024a9:	83 ec 04             	sub    $0x4,%esp
801024ac:	8d 45 da             	lea    -0x26(%ebp),%eax
801024af:	6a 0e                	push   $0xe
801024b1:	ff 75 0c             	pushl  0xc(%ebp)
801024b4:	50                   	push   %eax
801024b5:	e8 f6 27 00 00       	call   80104cb0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024ba:	6a 10                	push   $0x10
  de.inum = inum;
801024bc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024bf:	57                   	push   %edi
801024c0:	56                   	push   %esi
801024c1:	53                   	push   %ebx
  de.inum = inum;
801024c2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024c6:	e8 75 fb ff ff       	call   80102040 <writei>
801024cb:	83 c4 20             	add    $0x20,%esp
801024ce:	83 f8 10             	cmp    $0x10,%eax
801024d1:	75 2a                	jne    801024fd <dirlink+0xad>
  return 0;
801024d3:	31 c0                	xor    %eax,%eax
}
801024d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024d8:	5b                   	pop    %ebx
801024d9:	5e                   	pop    %esi
801024da:	5f                   	pop    %edi
801024db:	5d                   	pop    %ebp
801024dc:	c3                   	ret    
    iput(ip);
801024dd:	83 ec 0c             	sub    $0xc,%esp
801024e0:	50                   	push   %eax
801024e1:	e8 8a f8 ff ff       	call   80101d70 <iput>
    return -1;
801024e6:	83 c4 10             	add    $0x10,%esp
801024e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024ee:	eb e5                	jmp    801024d5 <dirlink+0x85>
      panic("dirlink read");
801024f0:	83 ec 0c             	sub    $0xc,%esp
801024f3:	68 18 77 10 80       	push   $0x80107718
801024f8:	e8 03 e2 ff ff       	call   80100700 <panic>
    panic("dirlink");
801024fd:	83 ec 0c             	sub    $0xc,%esp
80102500:	68 fe 7c 10 80       	push   $0x80107cfe
80102505:	e8 f6 e1 ff ff       	call   80100700 <panic>
8010250a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102510 <namei>:

struct inode*
namei(char *path)
{
80102510:	f3 0f 1e fb          	endbr32 
80102514:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102515:	31 d2                	xor    %edx,%edx
{
80102517:	89 e5                	mov    %esp,%ebp
80102519:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010251c:	8b 45 08             	mov    0x8(%ebp),%eax
8010251f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102522:	e8 29 fd ff ff       	call   80102250 <namex>
}
80102527:	c9                   	leave  
80102528:	c3                   	ret    
80102529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102530 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102530:	f3 0f 1e fb          	endbr32 
80102534:	55                   	push   %ebp
  return namex(path, 1, name);
80102535:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010253a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010253c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010253f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102542:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102543:	e9 08 fd ff ff       	jmp    80102250 <namex>
80102548:	66 90                	xchg   %ax,%ax
8010254a:	66 90                	xchg   %ax,%ax
8010254c:	66 90                	xchg   %ax,%ax
8010254e:	66 90                	xchg   %ax,%ax

80102550 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	57                   	push   %edi
80102554:	56                   	push   %esi
80102555:	53                   	push   %ebx
80102556:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102559:	85 c0                	test   %eax,%eax
8010255b:	0f 84 b4 00 00 00    	je     80102615 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102561:	8b 70 08             	mov    0x8(%eax),%esi
80102564:	89 c3                	mov    %eax,%ebx
80102566:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010256c:	0f 87 96 00 00 00    	ja     80102608 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102572:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010257e:	66 90                	xchg   %ax,%ax
80102580:	89 ca                	mov    %ecx,%edx
80102582:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102583:	83 e0 c0             	and    $0xffffffc0,%eax
80102586:	3c 40                	cmp    $0x40,%al
80102588:	75 f6                	jne    80102580 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010258a:	31 ff                	xor    %edi,%edi
8010258c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102591:	89 f8                	mov    %edi,%eax
80102593:	ee                   	out    %al,(%dx)
80102594:	b8 01 00 00 00       	mov    $0x1,%eax
80102599:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010259e:	ee                   	out    %al,(%dx)
8010259f:	ba f3 01 00 00       	mov    $0x1f3,%edx
801025a4:	89 f0                	mov    %esi,%eax
801025a6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801025a7:	89 f0                	mov    %esi,%eax
801025a9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801025ae:	c1 f8 08             	sar    $0x8,%eax
801025b1:	ee                   	out    %al,(%dx)
801025b2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801025b7:	89 f8                	mov    %edi,%eax
801025b9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801025ba:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801025be:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025c3:	c1 e0 04             	shl    $0x4,%eax
801025c6:	83 e0 10             	and    $0x10,%eax
801025c9:	83 c8 e0             	or     $0xffffffe0,%eax
801025cc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801025cd:	f6 03 04             	testb  $0x4,(%ebx)
801025d0:	75 16                	jne    801025e8 <idestart+0x98>
801025d2:	b8 20 00 00 00       	mov    $0x20,%eax
801025d7:	89 ca                	mov    %ecx,%edx
801025d9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801025da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025dd:	5b                   	pop    %ebx
801025de:	5e                   	pop    %esi
801025df:	5f                   	pop    %edi
801025e0:	5d                   	pop    %ebp
801025e1:	c3                   	ret    
801025e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025e8:	b8 30 00 00 00       	mov    $0x30,%eax
801025ed:	89 ca                	mov    %ecx,%edx
801025ef:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801025f0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801025f5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801025f8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801025fd:	fc                   	cld    
801025fe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102600:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102603:	5b                   	pop    %ebx
80102604:	5e                   	pop    %esi
80102605:	5f                   	pop    %edi
80102606:	5d                   	pop    %ebp
80102607:	c3                   	ret    
    panic("incorrect blockno");
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	68 84 77 10 80       	push   $0x80107784
80102610:	e8 eb e0 ff ff       	call   80100700 <panic>
    panic("idestart");
80102615:	83 ec 0c             	sub    $0xc,%esp
80102618:	68 7b 77 10 80       	push   $0x8010777b
8010261d:	e8 de e0 ff ff       	call   80100700 <panic>
80102622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102630 <ideinit>:
{
80102630:	f3 0f 1e fb          	endbr32 
80102634:	55                   	push   %ebp
80102635:	89 e5                	mov    %esp,%ebp
80102637:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010263a:	68 96 77 10 80       	push   $0x80107796
8010263f:	68 a0 a5 10 80       	push   $0x8010a5a0
80102644:	e8 77 22 00 00       	call   801048c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102649:	58                   	pop    %eax
8010264a:	a1 60 35 11 80       	mov    0x80113560,%eax
8010264f:	5a                   	pop    %edx
80102650:	83 e8 01             	sub    $0x1,%eax
80102653:	50                   	push   %eax
80102654:	6a 0e                	push   $0xe
80102656:	e8 b5 02 00 00       	call   80102910 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010265b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010265e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102663:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102667:	90                   	nop
80102668:	ec                   	in     (%dx),%al
80102669:	83 e0 c0             	and    $0xffffffc0,%eax
8010266c:	3c 40                	cmp    $0x40,%al
8010266e:	75 f8                	jne    80102668 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102670:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102675:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010267a:	ee                   	out    %al,(%dx)
8010267b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102680:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102685:	eb 0e                	jmp    80102695 <ideinit+0x65>
80102687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102690:	83 e9 01             	sub    $0x1,%ecx
80102693:	74 0f                	je     801026a4 <ideinit+0x74>
80102695:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102696:	84 c0                	test   %al,%al
80102698:	74 f6                	je     80102690 <ideinit+0x60>
      havedisk1 = 1;
8010269a:	c7 05 80 a5 10 80 01 	movl   $0x1,0x8010a580
801026a1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026a4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801026a9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026ae:	ee                   	out    %al,(%dx)
}
801026af:	c9                   	leave  
801026b0:	c3                   	ret    
801026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026bf:	90                   	nop

801026c0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026c0:	f3 0f 1e fb          	endbr32 
801026c4:	55                   	push   %ebp
801026c5:	89 e5                	mov    %esp,%ebp
801026c7:	57                   	push   %edi
801026c8:	56                   	push   %esi
801026c9:	53                   	push   %ebx
801026ca:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026cd:	68 a0 a5 10 80       	push   $0x8010a5a0
801026d2:	e8 69 23 00 00       	call   80104a40 <acquire>

  if((b = idequeue) == 0){
801026d7:	8b 1d 84 a5 10 80    	mov    0x8010a584,%ebx
801026dd:	83 c4 10             	add    $0x10,%esp
801026e0:	85 db                	test   %ebx,%ebx
801026e2:	74 5f                	je     80102743 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801026e4:	8b 43 58             	mov    0x58(%ebx),%eax
801026e7:	a3 84 a5 10 80       	mov    %eax,0x8010a584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801026ec:	8b 33                	mov    (%ebx),%esi
801026ee:	f7 c6 04 00 00 00    	test   $0x4,%esi
801026f4:	75 2b                	jne    80102721 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f6:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026ff:	90                   	nop
80102700:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102701:	89 c1                	mov    %eax,%ecx
80102703:	83 e1 c0             	and    $0xffffffc0,%ecx
80102706:	80 f9 40             	cmp    $0x40,%cl
80102709:	75 f5                	jne    80102700 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010270b:	a8 21                	test   $0x21,%al
8010270d:	75 12                	jne    80102721 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010270f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102712:	b9 80 00 00 00       	mov    $0x80,%ecx
80102717:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010271c:	fc                   	cld    
8010271d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010271f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102721:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102724:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102727:	83 ce 02             	or     $0x2,%esi
8010272a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010272c:	53                   	push   %ebx
8010272d:	e8 8e 1e 00 00       	call   801045c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102732:	a1 84 a5 10 80       	mov    0x8010a584,%eax
80102737:	83 c4 10             	add    $0x10,%esp
8010273a:	85 c0                	test   %eax,%eax
8010273c:	74 05                	je     80102743 <ideintr+0x83>
    idestart(idequeue);
8010273e:	e8 0d fe ff ff       	call   80102550 <idestart>
    release(&idelock);
80102743:	83 ec 0c             	sub    $0xc,%esp
80102746:	68 a0 a5 10 80       	push   $0x8010a5a0
8010274b:	e8 b0 23 00 00       	call   80104b00 <release>

  release(&idelock);
}
80102750:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102753:	5b                   	pop    %ebx
80102754:	5e                   	pop    %esi
80102755:	5f                   	pop    %edi
80102756:	5d                   	pop    %ebp
80102757:	c3                   	ret    
80102758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010275f:	90                   	nop

80102760 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102760:	f3 0f 1e fb          	endbr32 
80102764:	55                   	push   %ebp
80102765:	89 e5                	mov    %esp,%ebp
80102767:	53                   	push   %ebx
80102768:	83 ec 10             	sub    $0x10,%esp
8010276b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010276e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102771:	50                   	push   %eax
80102772:	e8 e9 20 00 00       	call   80104860 <holdingsleep>
80102777:	83 c4 10             	add    $0x10,%esp
8010277a:	85 c0                	test   %eax,%eax
8010277c:	0f 84 cf 00 00 00    	je     80102851 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102782:	8b 03                	mov    (%ebx),%eax
80102784:	83 e0 06             	and    $0x6,%eax
80102787:	83 f8 02             	cmp    $0x2,%eax
8010278a:	0f 84 b4 00 00 00    	je     80102844 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102790:	8b 53 04             	mov    0x4(%ebx),%edx
80102793:	85 d2                	test   %edx,%edx
80102795:	74 0d                	je     801027a4 <iderw+0x44>
80102797:	a1 80 a5 10 80       	mov    0x8010a580,%eax
8010279c:	85 c0                	test   %eax,%eax
8010279e:	0f 84 93 00 00 00    	je     80102837 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801027a4:	83 ec 0c             	sub    $0xc,%esp
801027a7:	68 a0 a5 10 80       	push   $0x8010a5a0
801027ac:	e8 8f 22 00 00       	call   80104a40 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027b1:	a1 84 a5 10 80       	mov    0x8010a584,%eax
  b->qnext = 0;
801027b6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027bd:	83 c4 10             	add    $0x10,%esp
801027c0:	85 c0                	test   %eax,%eax
801027c2:	74 6c                	je     80102830 <iderw+0xd0>
801027c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027c8:	89 c2                	mov    %eax,%edx
801027ca:	8b 40 58             	mov    0x58(%eax),%eax
801027cd:	85 c0                	test   %eax,%eax
801027cf:	75 f7                	jne    801027c8 <iderw+0x68>
801027d1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801027d4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801027d6:	39 1d 84 a5 10 80    	cmp    %ebx,0x8010a584
801027dc:	74 42                	je     80102820 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801027de:	8b 03                	mov    (%ebx),%eax
801027e0:	83 e0 06             	and    $0x6,%eax
801027e3:	83 f8 02             	cmp    $0x2,%eax
801027e6:	74 23                	je     8010280b <iderw+0xab>
801027e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ef:	90                   	nop
    sleep(b, &idelock);
801027f0:	83 ec 08             	sub    $0x8,%esp
801027f3:	68 a0 a5 10 80       	push   $0x8010a5a0
801027f8:	53                   	push   %ebx
801027f9:	e8 02 1c 00 00       	call   80104400 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801027fe:	8b 03                	mov    (%ebx),%eax
80102800:	83 c4 10             	add    $0x10,%esp
80102803:	83 e0 06             	and    $0x6,%eax
80102806:	83 f8 02             	cmp    $0x2,%eax
80102809:	75 e5                	jne    801027f0 <iderw+0x90>
  }


  release(&idelock);
8010280b:	c7 45 08 a0 a5 10 80 	movl   $0x8010a5a0,0x8(%ebp)
}
80102812:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102815:	c9                   	leave  
  release(&idelock);
80102816:	e9 e5 22 00 00       	jmp    80104b00 <release>
8010281b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010281f:	90                   	nop
    idestart(b);
80102820:	89 d8                	mov    %ebx,%eax
80102822:	e8 29 fd ff ff       	call   80102550 <idestart>
80102827:	eb b5                	jmp    801027de <iderw+0x7e>
80102829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102830:	ba 84 a5 10 80       	mov    $0x8010a584,%edx
80102835:	eb 9d                	jmp    801027d4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102837:	83 ec 0c             	sub    $0xc,%esp
8010283a:	68 c5 77 10 80       	push   $0x801077c5
8010283f:	e8 bc de ff ff       	call   80100700 <panic>
    panic("iderw: nothing to do");
80102844:	83 ec 0c             	sub    $0xc,%esp
80102847:	68 b0 77 10 80       	push   $0x801077b0
8010284c:	e8 af de ff ff       	call   80100700 <panic>
    panic("iderw: buf not locked");
80102851:	83 ec 0c             	sub    $0xc,%esp
80102854:	68 9a 77 10 80       	push   $0x8010779a
80102859:	e8 a2 de ff ff       	call   80100700 <panic>
8010285e:	66 90                	xchg   %ax,%ax

80102860 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102860:	f3 0f 1e fb          	endbr32 
80102864:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102865:	c7 05 94 2e 11 80 00 	movl   $0xfec00000,0x80112e94
8010286c:	00 c0 fe 
{
8010286f:	89 e5                	mov    %esp,%ebp
80102871:	56                   	push   %esi
80102872:	53                   	push   %ebx
  ioapic->reg = reg;
80102873:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010287a:	00 00 00 
  return ioapic->data;
8010287d:	8b 15 94 2e 11 80    	mov    0x80112e94,%edx
80102883:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102886:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010288c:	8b 0d 94 2e 11 80    	mov    0x80112e94,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102892:	0f b6 15 c0 2f 11 80 	movzbl 0x80112fc0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102899:	c1 ee 10             	shr    $0x10,%esi
8010289c:	89 f0                	mov    %esi,%eax
8010289e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801028a1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801028a4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801028a7:	39 c2                	cmp    %eax,%edx
801028a9:	74 16                	je     801028c1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028ab:	83 ec 0c             	sub    $0xc,%esp
801028ae:	68 e4 77 10 80       	push   $0x801077e4
801028b3:	e8 c8 de ff ff       	call   80100780 <cprintf>
801028b8:	8b 0d 94 2e 11 80    	mov    0x80112e94,%ecx
801028be:	83 c4 10             	add    $0x10,%esp
801028c1:	83 c6 21             	add    $0x21,%esi
{
801028c4:	ba 10 00 00 00       	mov    $0x10,%edx
801028c9:	b8 20 00 00 00       	mov    $0x20,%eax
801028ce:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801028d0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801028d2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801028d4:	8b 0d 94 2e 11 80    	mov    0x80112e94,%ecx
801028da:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801028dd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801028e3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801028e6:	8d 5a 01             	lea    0x1(%edx),%ebx
801028e9:	83 c2 02             	add    $0x2,%edx
801028ec:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801028ee:	8b 0d 94 2e 11 80    	mov    0x80112e94,%ecx
801028f4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801028fb:	39 f0                	cmp    %esi,%eax
801028fd:	75 d1                	jne    801028d0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801028ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102902:	5b                   	pop    %ebx
80102903:	5e                   	pop    %esi
80102904:	5d                   	pop    %ebp
80102905:	c3                   	ret    
80102906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290d:	8d 76 00             	lea    0x0(%esi),%esi

80102910 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102910:	f3 0f 1e fb          	endbr32 
80102914:	55                   	push   %ebp
  ioapic->reg = reg;
80102915:	8b 0d 94 2e 11 80    	mov    0x80112e94,%ecx
{
8010291b:	89 e5                	mov    %esp,%ebp
8010291d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102920:	8d 50 20             	lea    0x20(%eax),%edx
80102923:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102927:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102929:	8b 0d 94 2e 11 80    	mov    0x80112e94,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010292f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102932:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102935:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102938:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010293a:	a1 94 2e 11 80       	mov    0x80112e94,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010293f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102942:	89 50 10             	mov    %edx,0x10(%eax)
}
80102945:	5d                   	pop    %ebp
80102946:	c3                   	ret    
80102947:	66 90                	xchg   %ax,%ax
80102949:	66 90                	xchg   %ax,%ax
8010294b:	66 90                	xchg   %ax,%ax
8010294d:	66 90                	xchg   %ax,%ax
8010294f:	90                   	nop

80102950 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102950:	f3 0f 1e fb          	endbr32 
80102954:	55                   	push   %ebp
80102955:	89 e5                	mov    %esp,%ebp
80102957:	53                   	push   %ebx
80102958:	83 ec 04             	sub    $0x4,%esp
8010295b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010295e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102964:	75 7a                	jne    801029e0 <kfree+0x90>
80102966:	81 fb 08 5d 11 80    	cmp    $0x80115d08,%ebx
8010296c:	72 72                	jb     801029e0 <kfree+0x90>
8010296e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102974:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102979:	77 65                	ja     801029e0 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010297b:	83 ec 04             	sub    $0x4,%esp
8010297e:	68 00 10 00 00       	push   $0x1000
80102983:	6a 01                	push   $0x1
80102985:	53                   	push   %ebx
80102986:	e8 c5 21 00 00       	call   80104b50 <memset>

  if(kmem.use_lock)
8010298b:	8b 15 d4 2e 11 80    	mov    0x80112ed4,%edx
80102991:	83 c4 10             	add    $0x10,%esp
80102994:	85 d2                	test   %edx,%edx
80102996:	75 20                	jne    801029b8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102998:	a1 d8 2e 11 80       	mov    0x80112ed8,%eax
8010299d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010299f:	a1 d4 2e 11 80       	mov    0x80112ed4,%eax
  kmem.freelist = r;
801029a4:	89 1d d8 2e 11 80    	mov    %ebx,0x80112ed8
  if(kmem.use_lock)
801029aa:	85 c0                	test   %eax,%eax
801029ac:	75 22                	jne    801029d0 <kfree+0x80>
    release(&kmem.lock);
}
801029ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029b1:	c9                   	leave  
801029b2:	c3                   	ret    
801029b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029b7:	90                   	nop
    acquire(&kmem.lock);
801029b8:	83 ec 0c             	sub    $0xc,%esp
801029bb:	68 a0 2e 11 80       	push   $0x80112ea0
801029c0:	e8 7b 20 00 00       	call   80104a40 <acquire>
801029c5:	83 c4 10             	add    $0x10,%esp
801029c8:	eb ce                	jmp    80102998 <kfree+0x48>
801029ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801029d0:	c7 45 08 a0 2e 11 80 	movl   $0x80112ea0,0x8(%ebp)
}
801029d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029da:	c9                   	leave  
    release(&kmem.lock);
801029db:	e9 20 21 00 00       	jmp    80104b00 <release>
    panic("kfree");
801029e0:	83 ec 0c             	sub    $0xc,%esp
801029e3:	68 16 78 10 80       	push   $0x80107816
801029e8:	e8 13 dd ff ff       	call   80100700 <panic>
801029ed:	8d 76 00             	lea    0x0(%esi),%esi

801029f0 <freerange>:
{
801029f0:	f3 0f 1e fb          	endbr32 
801029f4:	55                   	push   %ebp
801029f5:	89 e5                	mov    %esp,%ebp
801029f7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801029f8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801029fb:	8b 75 0c             	mov    0xc(%ebp),%esi
801029fe:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801029ff:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a05:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a0b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a11:	39 de                	cmp    %ebx,%esi
80102a13:	72 1f                	jb     80102a34 <freerange+0x44>
80102a15:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102a18:	83 ec 0c             	sub    $0xc,%esp
80102a1b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a21:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a27:	50                   	push   %eax
80102a28:	e8 23 ff ff ff       	call   80102950 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a2d:	83 c4 10             	add    $0x10,%esp
80102a30:	39 f3                	cmp    %esi,%ebx
80102a32:	76 e4                	jbe    80102a18 <freerange+0x28>
}
80102a34:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a37:	5b                   	pop    %ebx
80102a38:	5e                   	pop    %esi
80102a39:	5d                   	pop    %ebp
80102a3a:	c3                   	ret    
80102a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a3f:	90                   	nop

80102a40 <kinit1>:
{
80102a40:	f3 0f 1e fb          	endbr32 
80102a44:	55                   	push   %ebp
80102a45:	89 e5                	mov    %esp,%ebp
80102a47:	56                   	push   %esi
80102a48:	53                   	push   %ebx
80102a49:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102a4c:	83 ec 08             	sub    $0x8,%esp
80102a4f:	68 1c 78 10 80       	push   $0x8010781c
80102a54:	68 a0 2e 11 80       	push   $0x80112ea0
80102a59:	e8 62 1e 00 00       	call   801048c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a61:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102a64:	c7 05 d4 2e 11 80 00 	movl   $0x0,0x80112ed4
80102a6b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102a6e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a74:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a7a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a80:	39 de                	cmp    %ebx,%esi
80102a82:	72 20                	jb     80102aa4 <kinit1+0x64>
80102a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102a88:	83 ec 0c             	sub    $0xc,%esp
80102a8b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a97:	50                   	push   %eax
80102a98:	e8 b3 fe ff ff       	call   80102950 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a9d:	83 c4 10             	add    $0x10,%esp
80102aa0:	39 de                	cmp    %ebx,%esi
80102aa2:	73 e4                	jae    80102a88 <kinit1+0x48>
}
80102aa4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102aa7:	5b                   	pop    %ebx
80102aa8:	5e                   	pop    %esi
80102aa9:	5d                   	pop    %ebp
80102aaa:	c3                   	ret    
80102aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aaf:	90                   	nop

80102ab0 <kinit2>:
{
80102ab0:	f3 0f 1e fb          	endbr32 
80102ab4:	55                   	push   %ebp
80102ab5:	89 e5                	mov    %esp,%ebp
80102ab7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102ab8:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102abb:	8b 75 0c             	mov    0xc(%ebp),%esi
80102abe:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102abf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ac5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102acb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102ad1:	39 de                	cmp    %ebx,%esi
80102ad3:	72 1f                	jb     80102af4 <kinit2+0x44>
80102ad5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102ad8:	83 ec 0c             	sub    $0xc,%esp
80102adb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ae1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102ae7:	50                   	push   %eax
80102ae8:	e8 63 fe ff ff       	call   80102950 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aed:	83 c4 10             	add    $0x10,%esp
80102af0:	39 de                	cmp    %ebx,%esi
80102af2:	73 e4                	jae    80102ad8 <kinit2+0x28>
  kmem.use_lock = 1;
80102af4:	c7 05 d4 2e 11 80 01 	movl   $0x1,0x80112ed4
80102afb:	00 00 00 
}
80102afe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b01:	5b                   	pop    %ebx
80102b02:	5e                   	pop    %esi
80102b03:	5d                   	pop    %ebp
80102b04:	c3                   	ret    
80102b05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b10 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b10:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102b14:	a1 d4 2e 11 80       	mov    0x80112ed4,%eax
80102b19:	85 c0                	test   %eax,%eax
80102b1b:	75 1b                	jne    80102b38 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102b1d:	a1 d8 2e 11 80       	mov    0x80112ed8,%eax
  if(r)
80102b22:	85 c0                	test   %eax,%eax
80102b24:	74 0a                	je     80102b30 <kalloc+0x20>
    kmem.freelist = r->next;
80102b26:	8b 10                	mov    (%eax),%edx
80102b28:	89 15 d8 2e 11 80    	mov    %edx,0x80112ed8
  if(kmem.use_lock)
80102b2e:	c3                   	ret    
80102b2f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102b30:	c3                   	ret    
80102b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102b38:	55                   	push   %ebp
80102b39:	89 e5                	mov    %esp,%ebp
80102b3b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102b3e:	68 a0 2e 11 80       	push   $0x80112ea0
80102b43:	e8 f8 1e 00 00       	call   80104a40 <acquire>
  r = kmem.freelist;
80102b48:	a1 d8 2e 11 80       	mov    0x80112ed8,%eax
  if(r)
80102b4d:	8b 15 d4 2e 11 80    	mov    0x80112ed4,%edx
80102b53:	83 c4 10             	add    $0x10,%esp
80102b56:	85 c0                	test   %eax,%eax
80102b58:	74 08                	je     80102b62 <kalloc+0x52>
    kmem.freelist = r->next;
80102b5a:	8b 08                	mov    (%eax),%ecx
80102b5c:	89 0d d8 2e 11 80    	mov    %ecx,0x80112ed8
  if(kmem.use_lock)
80102b62:	85 d2                	test   %edx,%edx
80102b64:	74 16                	je     80102b7c <kalloc+0x6c>
    release(&kmem.lock);
80102b66:	83 ec 0c             	sub    $0xc,%esp
80102b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b6c:	68 a0 2e 11 80       	push   $0x80112ea0
80102b71:	e8 8a 1f 00 00       	call   80104b00 <release>
  return (char*)r;
80102b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102b79:	83 c4 10             	add    $0x10,%esp
}
80102b7c:	c9                   	leave  
80102b7d:	c3                   	ret    
80102b7e:	66 90                	xchg   %ax,%ax

80102b80 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b80:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b84:	ba 64 00 00 00       	mov    $0x64,%edx
80102b89:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102b8a:	a8 01                	test   $0x1,%al
80102b8c:	0f 84 be 00 00 00    	je     80102c50 <kbdgetc+0xd0>
{
80102b92:	55                   	push   %ebp
80102b93:	ba 60 00 00 00       	mov    $0x60,%edx
80102b98:	89 e5                	mov    %esp,%ebp
80102b9a:	53                   	push   %ebx
80102b9b:	ec                   	in     (%dx),%al
  return data;
80102b9c:	8b 1d d4 a5 10 80    	mov    0x8010a5d4,%ebx
    return -1;
  data = inb(KBDATAP);
80102ba2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102ba5:	3c e0                	cmp    $0xe0,%al
80102ba7:	74 57                	je     80102c00 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102ba9:	89 d9                	mov    %ebx,%ecx
80102bab:	83 e1 40             	and    $0x40,%ecx
80102bae:	84 c0                	test   %al,%al
80102bb0:	78 5e                	js     80102c10 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102bb2:	85 c9                	test   %ecx,%ecx
80102bb4:	74 09                	je     80102bbf <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102bb6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102bb9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102bbc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102bbf:	0f b6 8a 60 79 10 80 	movzbl -0x7fef86a0(%edx),%ecx
  shift ^= togglecode[data];
80102bc6:	0f b6 82 60 78 10 80 	movzbl -0x7fef87a0(%edx),%eax
  shift |= shiftcode[data];
80102bcd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102bcf:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bd1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102bd3:	89 0d d4 a5 10 80    	mov    %ecx,0x8010a5d4
  c = charcode[shift & (CTL | SHIFT)][data];
80102bd9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102bdc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bdf:	8b 04 85 40 78 10 80 	mov    -0x7fef87c0(,%eax,4),%eax
80102be6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102bea:	74 0b                	je     80102bf7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102bec:	8d 50 9f             	lea    -0x61(%eax),%edx
80102bef:	83 fa 19             	cmp    $0x19,%edx
80102bf2:	77 44                	ja     80102c38 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102bf4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102bf7:	5b                   	pop    %ebx
80102bf8:	5d                   	pop    %ebp
80102bf9:	c3                   	ret    
80102bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102c00:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102c03:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102c05:	89 1d d4 a5 10 80    	mov    %ebx,0x8010a5d4
}
80102c0b:	5b                   	pop    %ebx
80102c0c:	5d                   	pop    %ebp
80102c0d:	c3                   	ret    
80102c0e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102c10:	83 e0 7f             	and    $0x7f,%eax
80102c13:	85 c9                	test   %ecx,%ecx
80102c15:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102c18:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102c1a:	0f b6 8a 60 79 10 80 	movzbl -0x7fef86a0(%edx),%ecx
80102c21:	83 c9 40             	or     $0x40,%ecx
80102c24:	0f b6 c9             	movzbl %cl,%ecx
80102c27:	f7 d1                	not    %ecx
80102c29:	21 d9                	and    %ebx,%ecx
}
80102c2b:	5b                   	pop    %ebx
80102c2c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102c2d:	89 0d d4 a5 10 80    	mov    %ecx,0x8010a5d4
}
80102c33:	c3                   	ret    
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102c38:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102c3b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102c3e:	5b                   	pop    %ebx
80102c3f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102c40:	83 f9 1a             	cmp    $0x1a,%ecx
80102c43:	0f 42 c2             	cmovb  %edx,%eax
}
80102c46:	c3                   	ret    
80102c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c4e:	66 90                	xchg   %ax,%ax
    return -1;
80102c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102c55:	c3                   	ret    
80102c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c5d:	8d 76 00             	lea    0x0(%esi),%esi

80102c60 <kbdintr>:

void
kbdintr(void)
{
80102c60:	f3 0f 1e fb          	endbr32 
80102c64:	55                   	push   %ebp
80102c65:	89 e5                	mov    %esp,%ebp
80102c67:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102c6a:	68 80 2b 10 80       	push   $0x80102b80
80102c6f:	e8 9c de ff ff       	call   80100b10 <consoleintr>
}
80102c74:	83 c4 10             	add    $0x10,%esp
80102c77:	c9                   	leave  
80102c78:	c3                   	ret    
80102c79:	66 90                	xchg   %ax,%ax
80102c7b:	66 90                	xchg   %ax,%ax
80102c7d:	66 90                	xchg   %ax,%ax
80102c7f:	90                   	nop

80102c80 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102c80:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102c84:	a1 dc 2e 11 80       	mov    0x80112edc,%eax
80102c89:	85 c0                	test   %eax,%eax
80102c8b:	0f 84 c7 00 00 00    	je     80102d58 <lapicinit+0xd8>
  lapic[index] = value;
80102c91:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102c98:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c9b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c9e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ca5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ca8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cab:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102cb2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102cb5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cb8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102cbf:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102cc2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cc5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102ccc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ccf:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cd2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102cd9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cdc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102cdf:	8b 50 30             	mov    0x30(%eax),%edx
80102ce2:	c1 ea 10             	shr    $0x10,%edx
80102ce5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102ceb:	75 73                	jne    80102d60 <lapicinit+0xe0>
  lapic[index] = value;
80102ced:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102cf4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cf7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cfa:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d01:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d04:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d07:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d0e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d11:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d14:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d1b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d1e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d21:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d28:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d2b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d2e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102d35:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102d38:	8b 50 20             	mov    0x20(%eax),%edx
80102d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d3f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102d40:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102d46:	80 e6 10             	and    $0x10,%dh
80102d49:	75 f5                	jne    80102d40 <lapicinit+0xc0>
  lapic[index] = value;
80102d4b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102d52:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d55:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102d58:	c3                   	ret    
80102d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102d60:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102d67:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d6a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102d6d:	e9 7b ff ff ff       	jmp    80102ced <lapicinit+0x6d>
80102d72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d80 <lapicid>:

int
lapicid(void)
{
80102d80:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102d84:	a1 dc 2e 11 80       	mov    0x80112edc,%eax
80102d89:	85 c0                	test   %eax,%eax
80102d8b:	74 0b                	je     80102d98 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102d8d:	8b 40 20             	mov    0x20(%eax),%eax
80102d90:	c1 e8 18             	shr    $0x18,%eax
80102d93:	c3                   	ret    
80102d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102d98:	31 c0                	xor    %eax,%eax
}
80102d9a:	c3                   	ret    
80102d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d9f:	90                   	nop

80102da0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102da0:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102da4:	a1 dc 2e 11 80       	mov    0x80112edc,%eax
80102da9:	85 c0                	test   %eax,%eax
80102dab:	74 0d                	je     80102dba <lapiceoi+0x1a>
  lapic[index] = value;
80102dad:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102db4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102db7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102dba:	c3                   	ret    
80102dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dbf:	90                   	nop

80102dc0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102dc0:	f3 0f 1e fb          	endbr32 
}
80102dc4:	c3                   	ret    
80102dc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102dd0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102dd0:	f3 0f 1e fb          	endbr32 
80102dd4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dd5:	b8 0f 00 00 00       	mov    $0xf,%eax
80102dda:	ba 70 00 00 00       	mov    $0x70,%edx
80102ddf:	89 e5                	mov    %esp,%ebp
80102de1:	53                   	push   %ebx
80102de2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102de5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102de8:	ee                   	out    %al,(%dx)
80102de9:	b8 0a 00 00 00       	mov    $0xa,%eax
80102dee:	ba 71 00 00 00       	mov    $0x71,%edx
80102df3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102df4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102df6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102df9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102dff:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e01:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102e04:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102e06:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e09:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102e0c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102e12:	a1 dc 2e 11 80       	mov    0x80112edc,%eax
80102e17:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e1d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e20:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e27:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e2a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e2d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102e34:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e37:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e3a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e40:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e43:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e49:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e4c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e52:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e55:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102e5b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102e5c:	8b 40 20             	mov    0x20(%eax),%eax
}
80102e5f:	5d                   	pop    %ebp
80102e60:	c3                   	ret    
80102e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop

80102e70 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102e70:	f3 0f 1e fb          	endbr32 
80102e74:	55                   	push   %ebp
80102e75:	b8 0b 00 00 00       	mov    $0xb,%eax
80102e7a:	ba 70 00 00 00       	mov    $0x70,%edx
80102e7f:	89 e5                	mov    %esp,%ebp
80102e81:	57                   	push   %edi
80102e82:	56                   	push   %esi
80102e83:	53                   	push   %ebx
80102e84:	83 ec 4c             	sub    $0x4c,%esp
80102e87:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e88:	ba 71 00 00 00       	mov    $0x71,%edx
80102e8d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102e8e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e91:	bb 70 00 00 00       	mov    $0x70,%ebx
80102e96:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ea0:	31 c0                	xor    %eax,%eax
80102ea2:	89 da                	mov    %ebx,%edx
80102ea4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ea5:	b9 71 00 00 00       	mov    $0x71,%ecx
80102eaa:	89 ca                	mov    %ecx,%edx
80102eac:	ec                   	in     (%dx),%al
80102ead:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eb0:	89 da                	mov    %ebx,%edx
80102eb2:	b8 02 00 00 00       	mov    $0x2,%eax
80102eb7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eb8:	89 ca                	mov    %ecx,%edx
80102eba:	ec                   	in     (%dx),%al
80102ebb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ebe:	89 da                	mov    %ebx,%edx
80102ec0:	b8 04 00 00 00       	mov    $0x4,%eax
80102ec5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ec6:	89 ca                	mov    %ecx,%edx
80102ec8:	ec                   	in     (%dx),%al
80102ec9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ecc:	89 da                	mov    %ebx,%edx
80102ece:	b8 07 00 00 00       	mov    $0x7,%eax
80102ed3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ed4:	89 ca                	mov    %ecx,%edx
80102ed6:	ec                   	in     (%dx),%al
80102ed7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eda:	89 da                	mov    %ebx,%edx
80102edc:	b8 08 00 00 00       	mov    $0x8,%eax
80102ee1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ee2:	89 ca                	mov    %ecx,%edx
80102ee4:	ec                   	in     (%dx),%al
80102ee5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ee7:	89 da                	mov    %ebx,%edx
80102ee9:	b8 09 00 00 00       	mov    $0x9,%eax
80102eee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eef:	89 ca                	mov    %ecx,%edx
80102ef1:	ec                   	in     (%dx),%al
80102ef2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ef4:	89 da                	mov    %ebx,%edx
80102ef6:	b8 0a 00 00 00       	mov    $0xa,%eax
80102efb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102efc:	89 ca                	mov    %ecx,%edx
80102efe:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102eff:	84 c0                	test   %al,%al
80102f01:	78 9d                	js     80102ea0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102f03:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102f07:	89 fa                	mov    %edi,%edx
80102f09:	0f b6 fa             	movzbl %dl,%edi
80102f0c:	89 f2                	mov    %esi,%edx
80102f0e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102f11:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102f15:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f18:	89 da                	mov    %ebx,%edx
80102f1a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102f1d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102f20:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102f24:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102f27:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102f2a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102f2e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102f31:	31 c0                	xor    %eax,%eax
80102f33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f34:	89 ca                	mov    %ecx,%edx
80102f36:	ec                   	in     (%dx),%al
80102f37:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f3a:	89 da                	mov    %ebx,%edx
80102f3c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102f3f:	b8 02 00 00 00       	mov    $0x2,%eax
80102f44:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f45:	89 ca                	mov    %ecx,%edx
80102f47:	ec                   	in     (%dx),%al
80102f48:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f4b:	89 da                	mov    %ebx,%edx
80102f4d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102f50:	b8 04 00 00 00       	mov    $0x4,%eax
80102f55:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f56:	89 ca                	mov    %ecx,%edx
80102f58:	ec                   	in     (%dx),%al
80102f59:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f5c:	89 da                	mov    %ebx,%edx
80102f5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102f61:	b8 07 00 00 00       	mov    $0x7,%eax
80102f66:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f67:	89 ca                	mov    %ecx,%edx
80102f69:	ec                   	in     (%dx),%al
80102f6a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f6d:	89 da                	mov    %ebx,%edx
80102f6f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f72:	b8 08 00 00 00       	mov    $0x8,%eax
80102f77:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f78:	89 ca                	mov    %ecx,%edx
80102f7a:	ec                   	in     (%dx),%al
80102f7b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f7e:	89 da                	mov    %ebx,%edx
80102f80:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102f83:	b8 09 00 00 00       	mov    $0x9,%eax
80102f88:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f89:	89 ca                	mov    %ecx,%edx
80102f8b:	ec                   	in     (%dx),%al
80102f8c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f8f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102f92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f95:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102f98:	6a 18                	push   $0x18
80102f9a:	50                   	push   %eax
80102f9b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102f9e:	50                   	push   %eax
80102f9f:	e8 fc 1b 00 00       	call   80104ba0 <memcmp>
80102fa4:	83 c4 10             	add    $0x10,%esp
80102fa7:	85 c0                	test   %eax,%eax
80102fa9:	0f 85 f1 fe ff ff    	jne    80102ea0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102faf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102fb3:	75 78                	jne    8010302d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102fb5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102fb8:	89 c2                	mov    %eax,%edx
80102fba:	83 e0 0f             	and    $0xf,%eax
80102fbd:	c1 ea 04             	shr    $0x4,%edx
80102fc0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fc3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fc6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102fc9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102fcc:	89 c2                	mov    %eax,%edx
80102fce:	83 e0 0f             	and    $0xf,%eax
80102fd1:	c1 ea 04             	shr    $0x4,%edx
80102fd4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fd7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fda:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102fdd:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102fe0:	89 c2                	mov    %eax,%edx
80102fe2:	83 e0 0f             	and    $0xf,%eax
80102fe5:	c1 ea 04             	shr    $0x4,%edx
80102fe8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102feb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fee:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ff1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ff4:	89 c2                	mov    %eax,%edx
80102ff6:	83 e0 0f             	and    $0xf,%eax
80102ff9:	c1 ea 04             	shr    $0x4,%edx
80102ffc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103002:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103005:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103008:	89 c2                	mov    %eax,%edx
8010300a:	83 e0 0f             	and    $0xf,%eax
8010300d:	c1 ea 04             	shr    $0x4,%edx
80103010:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103013:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103016:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103019:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010301c:	89 c2                	mov    %eax,%edx
8010301e:	83 e0 0f             	and    $0xf,%eax
80103021:	c1 ea 04             	shr    $0x4,%edx
80103024:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103027:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010302a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010302d:	8b 75 08             	mov    0x8(%ebp),%esi
80103030:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103033:	89 06                	mov    %eax,(%esi)
80103035:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103038:	89 46 04             	mov    %eax,0x4(%esi)
8010303b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010303e:	89 46 08             	mov    %eax,0x8(%esi)
80103041:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103044:	89 46 0c             	mov    %eax,0xc(%esi)
80103047:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010304a:	89 46 10             	mov    %eax,0x10(%esi)
8010304d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103050:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103053:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010305a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010305d:	5b                   	pop    %ebx
8010305e:	5e                   	pop    %esi
8010305f:	5f                   	pop    %edi
80103060:	5d                   	pop    %ebp
80103061:	c3                   	ret    
80103062:	66 90                	xchg   %ax,%ax
80103064:	66 90                	xchg   %ax,%ax
80103066:	66 90                	xchg   %ax,%ax
80103068:	66 90                	xchg   %ax,%ax
8010306a:	66 90                	xchg   %ax,%ax
8010306c:	66 90                	xchg   %ax,%ax
8010306e:	66 90                	xchg   %ax,%ax

80103070 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103070:	8b 0d 28 2f 11 80    	mov    0x80112f28,%ecx
80103076:	85 c9                	test   %ecx,%ecx
80103078:	0f 8e 8a 00 00 00    	jle    80103108 <install_trans+0x98>
{
8010307e:	55                   	push   %ebp
8010307f:	89 e5                	mov    %esp,%ebp
80103081:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103082:	31 ff                	xor    %edi,%edi
{
80103084:	56                   	push   %esi
80103085:	53                   	push   %ebx
80103086:	83 ec 0c             	sub    $0xc,%esp
80103089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103090:	a1 14 2f 11 80       	mov    0x80112f14,%eax
80103095:	83 ec 08             	sub    $0x8,%esp
80103098:	01 f8                	add    %edi,%eax
8010309a:	83 c0 01             	add    $0x1,%eax
8010309d:	50                   	push   %eax
8010309e:	ff 35 24 2f 11 80    	pushl  0x80112f24
801030a4:	e8 27 d0 ff ff       	call   801000d0 <bread>
801030a9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030ab:	58                   	pop    %eax
801030ac:	5a                   	pop    %edx
801030ad:	ff 34 bd 2c 2f 11 80 	pushl  -0x7feed0d4(,%edi,4)
801030b4:	ff 35 24 2f 11 80    	pushl  0x80112f24
  for (tail = 0; tail < log.lh.n; tail++) {
801030ba:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030bd:	e8 0e d0 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030c2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030c5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030c7:	8d 46 5c             	lea    0x5c(%esi),%eax
801030ca:	68 00 02 00 00       	push   $0x200
801030cf:	50                   	push   %eax
801030d0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801030d3:	50                   	push   %eax
801030d4:	e8 17 1b 00 00       	call   80104bf0 <memmove>
    bwrite(dbuf);  // write dst to disk
801030d9:	89 1c 24             	mov    %ebx,(%esp)
801030dc:	e8 cf d0 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801030e1:	89 34 24             	mov    %esi,(%esp)
801030e4:	e8 07 d1 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801030e9:	89 1c 24             	mov    %ebx,(%esp)
801030ec:	e8 ff d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030f1:	83 c4 10             	add    $0x10,%esp
801030f4:	39 3d 28 2f 11 80    	cmp    %edi,0x80112f28
801030fa:	7f 94                	jg     80103090 <install_trans+0x20>
  }
}
801030fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030ff:	5b                   	pop    %ebx
80103100:	5e                   	pop    %esi
80103101:	5f                   	pop    %edi
80103102:	5d                   	pop    %ebp
80103103:	c3                   	ret    
80103104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103108:	c3                   	ret    
80103109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103110 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	53                   	push   %ebx
80103114:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103117:	ff 35 14 2f 11 80    	pushl  0x80112f14
8010311d:	ff 35 24 2f 11 80    	pushl  0x80112f24
80103123:	e8 a8 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103128:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010312b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010312d:	a1 28 2f 11 80       	mov    0x80112f28,%eax
80103132:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103135:	85 c0                	test   %eax,%eax
80103137:	7e 19                	jle    80103152 <write_head+0x42>
80103139:	31 d2                	xor    %edx,%edx
8010313b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010313f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103140:	8b 0c 95 2c 2f 11 80 	mov    -0x7feed0d4(,%edx,4),%ecx
80103147:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010314b:	83 c2 01             	add    $0x1,%edx
8010314e:	39 d0                	cmp    %edx,%eax
80103150:	75 ee                	jne    80103140 <write_head+0x30>
  }
  bwrite(buf);
80103152:	83 ec 0c             	sub    $0xc,%esp
80103155:	53                   	push   %ebx
80103156:	e8 55 d0 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010315b:	89 1c 24             	mov    %ebx,(%esp)
8010315e:	e8 8d d0 ff ff       	call   801001f0 <brelse>
}
80103163:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103166:	83 c4 10             	add    $0x10,%esp
80103169:	c9                   	leave  
8010316a:	c3                   	ret    
8010316b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010316f:	90                   	nop

80103170 <initlog>:
{
80103170:	f3 0f 1e fb          	endbr32 
80103174:	55                   	push   %ebp
80103175:	89 e5                	mov    %esp,%ebp
80103177:	53                   	push   %ebx
80103178:	83 ec 2c             	sub    $0x2c,%esp
8010317b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010317e:	68 60 7a 10 80       	push   $0x80107a60
80103183:	68 e0 2e 11 80       	push   $0x80112ee0
80103188:	e8 33 17 00 00       	call   801048c0 <initlock>
  readsb(dev, &sb);
8010318d:	58                   	pop    %eax
8010318e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103191:	5a                   	pop    %edx
80103192:	50                   	push   %eax
80103193:	53                   	push   %ebx
80103194:	e8 47 e8 ff ff       	call   801019e0 <readsb>
  log.start = sb.logstart;
80103199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010319c:	59                   	pop    %ecx
  log.dev = dev;
8010319d:	89 1d 24 2f 11 80    	mov    %ebx,0x80112f24
  log.size = sb.nlog;
801031a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801031a6:	a3 14 2f 11 80       	mov    %eax,0x80112f14
  log.size = sb.nlog;
801031ab:	89 15 18 2f 11 80    	mov    %edx,0x80112f18
  struct buf *buf = bread(log.dev, log.start);
801031b1:	5a                   	pop    %edx
801031b2:	50                   	push   %eax
801031b3:	53                   	push   %ebx
801031b4:	e8 17 cf ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801031b9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801031bc:	8b 48 5c             	mov    0x5c(%eax),%ecx
801031bf:	89 0d 28 2f 11 80    	mov    %ecx,0x80112f28
  for (i = 0; i < log.lh.n; i++) {
801031c5:	85 c9                	test   %ecx,%ecx
801031c7:	7e 19                	jle    801031e2 <initlog+0x72>
801031c9:	31 d2                	xor    %edx,%edx
801031cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031cf:	90                   	nop
    log.lh.block[i] = lh->block[i];
801031d0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
801031d4:	89 1c 95 2c 2f 11 80 	mov    %ebx,-0x7feed0d4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801031db:	83 c2 01             	add    $0x1,%edx
801031de:	39 d1                	cmp    %edx,%ecx
801031e0:	75 ee                	jne    801031d0 <initlog+0x60>
  brelse(buf);
801031e2:	83 ec 0c             	sub    $0xc,%esp
801031e5:	50                   	push   %eax
801031e6:	e8 05 d0 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801031eb:	e8 80 fe ff ff       	call   80103070 <install_trans>
  log.lh.n = 0;
801031f0:	c7 05 28 2f 11 80 00 	movl   $0x0,0x80112f28
801031f7:	00 00 00 
  write_head(); // clear the log
801031fa:	e8 11 ff ff ff       	call   80103110 <write_head>
}
801031ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103202:	83 c4 10             	add    $0x10,%esp
80103205:	c9                   	leave  
80103206:	c3                   	ret    
80103207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320e:	66 90                	xchg   %ax,%ax

80103210 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103210:	f3 0f 1e fb          	endbr32 
80103214:	55                   	push   %ebp
80103215:	89 e5                	mov    %esp,%ebp
80103217:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010321a:	68 e0 2e 11 80       	push   $0x80112ee0
8010321f:	e8 1c 18 00 00       	call   80104a40 <acquire>
80103224:	83 c4 10             	add    $0x10,%esp
80103227:	eb 1c                	jmp    80103245 <begin_op+0x35>
80103229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103230:	83 ec 08             	sub    $0x8,%esp
80103233:	68 e0 2e 11 80       	push   $0x80112ee0
80103238:	68 e0 2e 11 80       	push   $0x80112ee0
8010323d:	e8 be 11 00 00       	call   80104400 <sleep>
80103242:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103245:	a1 20 2f 11 80       	mov    0x80112f20,%eax
8010324a:	85 c0                	test   %eax,%eax
8010324c:	75 e2                	jne    80103230 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010324e:	a1 1c 2f 11 80       	mov    0x80112f1c,%eax
80103253:	8b 15 28 2f 11 80    	mov    0x80112f28,%edx
80103259:	83 c0 01             	add    $0x1,%eax
8010325c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010325f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103262:	83 fa 1e             	cmp    $0x1e,%edx
80103265:	7f c9                	jg     80103230 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103267:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010326a:	a3 1c 2f 11 80       	mov    %eax,0x80112f1c
      release(&log.lock);
8010326f:	68 e0 2e 11 80       	push   $0x80112ee0
80103274:	e8 87 18 00 00       	call   80104b00 <release>
      break;
    }
  }
}
80103279:	83 c4 10             	add    $0x10,%esp
8010327c:	c9                   	leave  
8010327d:	c3                   	ret    
8010327e:	66 90                	xchg   %ax,%ax

80103280 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103280:	f3 0f 1e fb          	endbr32 
80103284:	55                   	push   %ebp
80103285:	89 e5                	mov    %esp,%ebp
80103287:	57                   	push   %edi
80103288:	56                   	push   %esi
80103289:	53                   	push   %ebx
8010328a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010328d:	68 e0 2e 11 80       	push   $0x80112ee0
80103292:	e8 a9 17 00 00       	call   80104a40 <acquire>
  log.outstanding -= 1;
80103297:	a1 1c 2f 11 80       	mov    0x80112f1c,%eax
  if(log.committing)
8010329c:	8b 35 20 2f 11 80    	mov    0x80112f20,%esi
801032a2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801032a5:	8d 58 ff             	lea    -0x1(%eax),%ebx
801032a8:	89 1d 1c 2f 11 80    	mov    %ebx,0x80112f1c
  if(log.committing)
801032ae:	85 f6                	test   %esi,%esi
801032b0:	0f 85 1e 01 00 00    	jne    801033d4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801032b6:	85 db                	test   %ebx,%ebx
801032b8:	0f 85 f2 00 00 00    	jne    801033b0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801032be:	c7 05 20 2f 11 80 01 	movl   $0x1,0x80112f20
801032c5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801032c8:	83 ec 0c             	sub    $0xc,%esp
801032cb:	68 e0 2e 11 80       	push   $0x80112ee0
801032d0:	e8 2b 18 00 00       	call   80104b00 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801032d5:	8b 0d 28 2f 11 80    	mov    0x80112f28,%ecx
801032db:	83 c4 10             	add    $0x10,%esp
801032de:	85 c9                	test   %ecx,%ecx
801032e0:	7f 3e                	jg     80103320 <end_op+0xa0>
    acquire(&log.lock);
801032e2:	83 ec 0c             	sub    $0xc,%esp
801032e5:	68 e0 2e 11 80       	push   $0x80112ee0
801032ea:	e8 51 17 00 00       	call   80104a40 <acquire>
    wakeup(&log);
801032ef:	c7 04 24 e0 2e 11 80 	movl   $0x80112ee0,(%esp)
    log.committing = 0;
801032f6:	c7 05 20 2f 11 80 00 	movl   $0x0,0x80112f20
801032fd:	00 00 00 
    wakeup(&log);
80103300:	e8 bb 12 00 00       	call   801045c0 <wakeup>
    release(&log.lock);
80103305:	c7 04 24 e0 2e 11 80 	movl   $0x80112ee0,(%esp)
8010330c:	e8 ef 17 00 00       	call   80104b00 <release>
80103311:	83 c4 10             	add    $0x10,%esp
}
80103314:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103317:	5b                   	pop    %ebx
80103318:	5e                   	pop    %esi
80103319:	5f                   	pop    %edi
8010331a:	5d                   	pop    %ebp
8010331b:	c3                   	ret    
8010331c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103320:	a1 14 2f 11 80       	mov    0x80112f14,%eax
80103325:	83 ec 08             	sub    $0x8,%esp
80103328:	01 d8                	add    %ebx,%eax
8010332a:	83 c0 01             	add    $0x1,%eax
8010332d:	50                   	push   %eax
8010332e:	ff 35 24 2f 11 80    	pushl  0x80112f24
80103334:	e8 97 cd ff ff       	call   801000d0 <bread>
80103339:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010333b:	58                   	pop    %eax
8010333c:	5a                   	pop    %edx
8010333d:	ff 34 9d 2c 2f 11 80 	pushl  -0x7feed0d4(,%ebx,4)
80103344:	ff 35 24 2f 11 80    	pushl  0x80112f24
  for (tail = 0; tail < log.lh.n; tail++) {
8010334a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010334d:	e8 7e cd ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103352:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103355:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103357:	8d 40 5c             	lea    0x5c(%eax),%eax
8010335a:	68 00 02 00 00       	push   $0x200
8010335f:	50                   	push   %eax
80103360:	8d 46 5c             	lea    0x5c(%esi),%eax
80103363:	50                   	push   %eax
80103364:	e8 87 18 00 00       	call   80104bf0 <memmove>
    bwrite(to);  // write the log
80103369:	89 34 24             	mov    %esi,(%esp)
8010336c:	e8 3f ce ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103371:	89 3c 24             	mov    %edi,(%esp)
80103374:	e8 77 ce ff ff       	call   801001f0 <brelse>
    brelse(to);
80103379:	89 34 24             	mov    %esi,(%esp)
8010337c:	e8 6f ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103381:	83 c4 10             	add    $0x10,%esp
80103384:	3b 1d 28 2f 11 80    	cmp    0x80112f28,%ebx
8010338a:	7c 94                	jl     80103320 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010338c:	e8 7f fd ff ff       	call   80103110 <write_head>
    install_trans(); // Now install writes to home locations
80103391:	e8 da fc ff ff       	call   80103070 <install_trans>
    log.lh.n = 0;
80103396:	c7 05 28 2f 11 80 00 	movl   $0x0,0x80112f28
8010339d:	00 00 00 
    write_head();    // Erase the transaction from the log
801033a0:	e8 6b fd ff ff       	call   80103110 <write_head>
801033a5:	e9 38 ff ff ff       	jmp    801032e2 <end_op+0x62>
801033aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801033b0:	83 ec 0c             	sub    $0xc,%esp
801033b3:	68 e0 2e 11 80       	push   $0x80112ee0
801033b8:	e8 03 12 00 00       	call   801045c0 <wakeup>
  release(&log.lock);
801033bd:	c7 04 24 e0 2e 11 80 	movl   $0x80112ee0,(%esp)
801033c4:	e8 37 17 00 00       	call   80104b00 <release>
801033c9:	83 c4 10             	add    $0x10,%esp
}
801033cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033cf:	5b                   	pop    %ebx
801033d0:	5e                   	pop    %esi
801033d1:	5f                   	pop    %edi
801033d2:	5d                   	pop    %ebp
801033d3:	c3                   	ret    
    panic("log.committing");
801033d4:	83 ec 0c             	sub    $0xc,%esp
801033d7:	68 64 7a 10 80       	push   $0x80107a64
801033dc:	e8 1f d3 ff ff       	call   80100700 <panic>
801033e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ef:	90                   	nop

801033f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801033f0:	f3 0f 1e fb          	endbr32 
801033f4:	55                   	push   %ebp
801033f5:	89 e5                	mov    %esp,%ebp
801033f7:	53                   	push   %ebx
801033f8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033fb:	8b 15 28 2f 11 80    	mov    0x80112f28,%edx
{
80103401:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103404:	83 fa 1d             	cmp    $0x1d,%edx
80103407:	0f 8f 91 00 00 00    	jg     8010349e <log_write+0xae>
8010340d:	a1 18 2f 11 80       	mov    0x80112f18,%eax
80103412:	83 e8 01             	sub    $0x1,%eax
80103415:	39 c2                	cmp    %eax,%edx
80103417:	0f 8d 81 00 00 00    	jge    8010349e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010341d:	a1 1c 2f 11 80       	mov    0x80112f1c,%eax
80103422:	85 c0                	test   %eax,%eax
80103424:	0f 8e 81 00 00 00    	jle    801034ab <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010342a:	83 ec 0c             	sub    $0xc,%esp
8010342d:	68 e0 2e 11 80       	push   $0x80112ee0
80103432:	e8 09 16 00 00       	call   80104a40 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103437:	8b 15 28 2f 11 80    	mov    0x80112f28,%edx
8010343d:	83 c4 10             	add    $0x10,%esp
80103440:	85 d2                	test   %edx,%edx
80103442:	7e 4e                	jle    80103492 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103444:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103447:	31 c0                	xor    %eax,%eax
80103449:	eb 0c                	jmp    80103457 <log_write+0x67>
8010344b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010344f:	90                   	nop
80103450:	83 c0 01             	add    $0x1,%eax
80103453:	39 c2                	cmp    %eax,%edx
80103455:	74 29                	je     80103480 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103457:	39 0c 85 2c 2f 11 80 	cmp    %ecx,-0x7feed0d4(,%eax,4)
8010345e:	75 f0                	jne    80103450 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103460:	89 0c 85 2c 2f 11 80 	mov    %ecx,-0x7feed0d4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103467:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010346a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010346d:	c7 45 08 e0 2e 11 80 	movl   $0x80112ee0,0x8(%ebp)
}
80103474:	c9                   	leave  
  release(&log.lock);
80103475:	e9 86 16 00 00       	jmp    80104b00 <release>
8010347a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103480:	89 0c 95 2c 2f 11 80 	mov    %ecx,-0x7feed0d4(,%edx,4)
    log.lh.n++;
80103487:	83 c2 01             	add    $0x1,%edx
8010348a:	89 15 28 2f 11 80    	mov    %edx,0x80112f28
80103490:	eb d5                	jmp    80103467 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103492:	8b 43 08             	mov    0x8(%ebx),%eax
80103495:	a3 2c 2f 11 80       	mov    %eax,0x80112f2c
  if (i == log.lh.n)
8010349a:	75 cb                	jne    80103467 <log_write+0x77>
8010349c:	eb e9                	jmp    80103487 <log_write+0x97>
    panic("too big a transaction");
8010349e:	83 ec 0c             	sub    $0xc,%esp
801034a1:	68 73 7a 10 80       	push   $0x80107a73
801034a6:	e8 55 d2 ff ff       	call   80100700 <panic>
    panic("log_write outside of trans");
801034ab:	83 ec 0c             	sub    $0xc,%esp
801034ae:	68 89 7a 10 80       	push   $0x80107a89
801034b3:	e8 48 d2 ff ff       	call   80100700 <panic>
801034b8:	66 90                	xchg   %ax,%ax
801034ba:	66 90                	xchg   %ax,%ax
801034bc:	66 90                	xchg   %ax,%ax
801034be:	66 90                	xchg   %ax,%ax

801034c0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	53                   	push   %ebx
801034c4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801034c7:	e8 54 09 00 00       	call   80103e20 <cpuid>
801034cc:	89 c3                	mov    %eax,%ebx
801034ce:	e8 4d 09 00 00       	call   80103e20 <cpuid>
801034d3:	83 ec 04             	sub    $0x4,%esp
801034d6:	53                   	push   %ebx
801034d7:	50                   	push   %eax
801034d8:	68 a4 7a 10 80       	push   $0x80107aa4
801034dd:	e8 9e d2 ff ff       	call   80100780 <cprintf>
  idtinit();       // load idt register
801034e2:	e8 19 29 00 00       	call   80105e00 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801034e7:	e8 c4 08 00 00       	call   80103db0 <mycpu>
801034ec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801034ee:	b8 01 00 00 00       	mov    $0x1,%eax
801034f3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801034fa:	e8 11 0c 00 00       	call   80104110 <scheduler>
801034ff:	90                   	nop

80103500 <mpenter>:
{
80103500:	f3 0f 1e fb          	endbr32 
80103504:	55                   	push   %ebp
80103505:	89 e5                	mov    %esp,%ebp
80103507:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010350a:	e8 c1 39 00 00       	call   80106ed0 <switchkvm>
  seginit();
8010350f:	e8 2c 39 00 00       	call   80106e40 <seginit>
  lapicinit();
80103514:	e8 67 f7 ff ff       	call   80102c80 <lapicinit>
  mpmain();
80103519:	e8 a2 ff ff ff       	call   801034c0 <mpmain>
8010351e:	66 90                	xchg   %ax,%ax

80103520 <main>:
{
80103520:	f3 0f 1e fb          	endbr32 
80103524:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103528:	83 e4 f0             	and    $0xfffffff0,%esp
8010352b:	ff 71 fc             	pushl  -0x4(%ecx)
8010352e:	55                   	push   %ebp
8010352f:	89 e5                	mov    %esp,%ebp
80103531:	53                   	push   %ebx
80103532:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103533:	83 ec 08             	sub    $0x8,%esp
80103536:	68 00 00 40 80       	push   $0x80400000
8010353b:	68 08 5d 11 80       	push   $0x80115d08
80103540:	e8 fb f4 ff ff       	call   80102a40 <kinit1>
  kvmalloc();      // kernel page table
80103545:	e8 66 3e 00 00       	call   801073b0 <kvmalloc>
  mpinit();        // detect other processors
8010354a:	e8 81 01 00 00       	call   801036d0 <mpinit>
  lapicinit();     // interrupt controller
8010354f:	e8 2c f7 ff ff       	call   80102c80 <lapicinit>
  seginit();       // segment descriptors
80103554:	e8 e7 38 00 00       	call   80106e40 <seginit>
  picinit();       // disable pic
80103559:	e8 52 03 00 00       	call   801038b0 <picinit>
  ioapicinit();    // another interrupt controller
8010355e:	e8 fd f2 ff ff       	call   80102860 <ioapicinit>
  consoleinit();   // console hardware
80103563:	e8 a8 d9 ff ff       	call   80100f10 <consoleinit>
  uartinit();      // serial port
80103568:	e8 93 2b 00 00       	call   80106100 <uartinit>
  pinit();         // process table
8010356d:	e8 1e 08 00 00       	call   80103d90 <pinit>
  tvinit();        // trap vectors
80103572:	e8 09 28 00 00       	call   80105d80 <tvinit>
  binit();         // buffer cache
80103577:	e8 c4 ca ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010357c:	e8 3f dd ff ff       	call   801012c0 <fileinit>
  ideinit();       // disk 
80103581:	e8 aa f0 ff ff       	call   80102630 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103586:	83 c4 0c             	add    $0xc,%esp
80103589:	68 8a 00 00 00       	push   $0x8a
8010358e:	68 8c a4 10 80       	push   $0x8010a48c
80103593:	68 00 70 00 80       	push   $0x80007000
80103598:	e8 53 16 00 00       	call   80104bf0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010359d:	83 c4 10             	add    $0x10,%esp
801035a0:	69 05 60 35 11 80 b0 	imul   $0xb0,0x80113560,%eax
801035a7:	00 00 00 
801035aa:	05 e0 2f 11 80       	add    $0x80112fe0,%eax
801035af:	3d e0 2f 11 80       	cmp    $0x80112fe0,%eax
801035b4:	76 7a                	jbe    80103630 <main+0x110>
801035b6:	bb e0 2f 11 80       	mov    $0x80112fe0,%ebx
801035bb:	eb 1c                	jmp    801035d9 <main+0xb9>
801035bd:	8d 76 00             	lea    0x0(%esi),%esi
801035c0:	69 05 60 35 11 80 b0 	imul   $0xb0,0x80113560,%eax
801035c7:	00 00 00 
801035ca:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801035d0:	05 e0 2f 11 80       	add    $0x80112fe0,%eax
801035d5:	39 c3                	cmp    %eax,%ebx
801035d7:	73 57                	jae    80103630 <main+0x110>
    if(c == mycpu())  // We've started already.
801035d9:	e8 d2 07 00 00       	call   80103db0 <mycpu>
801035de:	39 c3                	cmp    %eax,%ebx
801035e0:	74 de                	je     801035c0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801035e2:	e8 29 f5 ff ff       	call   80102b10 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801035e7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801035ea:	c7 05 f8 6f 00 80 00 	movl   $0x80103500,0x80006ff8
801035f1:	35 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801035f4:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801035fb:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801035fe:	05 00 10 00 00       	add    $0x1000,%eax
80103603:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103608:	0f b6 03             	movzbl (%ebx),%eax
8010360b:	68 00 70 00 00       	push   $0x7000
80103610:	50                   	push   %eax
80103611:	e8 ba f7 ff ff       	call   80102dd0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103616:	83 c4 10             	add    $0x10,%esp
80103619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103620:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103626:	85 c0                	test   %eax,%eax
80103628:	74 f6                	je     80103620 <main+0x100>
8010362a:	eb 94                	jmp    801035c0 <main+0xa0>
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103630:	83 ec 08             	sub    $0x8,%esp
80103633:	68 00 00 00 8e       	push   $0x8e000000
80103638:	68 00 00 40 80       	push   $0x80400000
8010363d:	e8 6e f4 ff ff       	call   80102ab0 <kinit2>
  userinit();      // first user process
80103642:	e8 29 08 00 00       	call   80103e70 <userinit>
  mpmain();        // finish this processor's setup
80103647:	e8 74 fe ff ff       	call   801034c0 <mpmain>
8010364c:	66 90                	xchg   %ax,%ax
8010364e:	66 90                	xchg   %ax,%ax

80103650 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	57                   	push   %edi
80103654:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103655:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010365b:	53                   	push   %ebx
  e = addr+len;
8010365c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010365f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103662:	39 de                	cmp    %ebx,%esi
80103664:	72 10                	jb     80103676 <mpsearch1+0x26>
80103666:	eb 50                	jmp    801036b8 <mpsearch1+0x68>
80103668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010366f:	90                   	nop
80103670:	89 fe                	mov    %edi,%esi
80103672:	39 fb                	cmp    %edi,%ebx
80103674:	76 42                	jbe    801036b8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103676:	83 ec 04             	sub    $0x4,%esp
80103679:	8d 7e 10             	lea    0x10(%esi),%edi
8010367c:	6a 04                	push   $0x4
8010367e:	68 b8 7a 10 80       	push   $0x80107ab8
80103683:	56                   	push   %esi
80103684:	e8 17 15 00 00       	call   80104ba0 <memcmp>
80103689:	83 c4 10             	add    $0x10,%esp
8010368c:	85 c0                	test   %eax,%eax
8010368e:	75 e0                	jne    80103670 <mpsearch1+0x20>
80103690:	89 f2                	mov    %esi,%edx
80103692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103698:	0f b6 0a             	movzbl (%edx),%ecx
8010369b:	83 c2 01             	add    $0x1,%edx
8010369e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801036a0:	39 fa                	cmp    %edi,%edx
801036a2:	75 f4                	jne    80103698 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036a4:	84 c0                	test   %al,%al
801036a6:	75 c8                	jne    80103670 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801036a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ab:	89 f0                	mov    %esi,%eax
801036ad:	5b                   	pop    %ebx
801036ae:	5e                   	pop    %esi
801036af:	5f                   	pop    %edi
801036b0:	5d                   	pop    %ebp
801036b1:	c3                   	ret    
801036b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036bb:	31 f6                	xor    %esi,%esi
}
801036bd:	5b                   	pop    %ebx
801036be:	89 f0                	mov    %esi,%eax
801036c0:	5e                   	pop    %esi
801036c1:	5f                   	pop    %edi
801036c2:	5d                   	pop    %ebp
801036c3:	c3                   	ret    
801036c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036cf:	90                   	nop

801036d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801036d0:	f3 0f 1e fb          	endbr32 
801036d4:	55                   	push   %ebp
801036d5:	89 e5                	mov    %esp,%ebp
801036d7:	57                   	push   %edi
801036d8:	56                   	push   %esi
801036d9:	53                   	push   %ebx
801036da:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801036dd:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801036e4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801036eb:	c1 e0 08             	shl    $0x8,%eax
801036ee:	09 d0                	or     %edx,%eax
801036f0:	c1 e0 04             	shl    $0x4,%eax
801036f3:	75 1b                	jne    80103710 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801036f5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801036fc:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103703:	c1 e0 08             	shl    $0x8,%eax
80103706:	09 d0                	or     %edx,%eax
80103708:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010370b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103710:	ba 00 04 00 00       	mov    $0x400,%edx
80103715:	e8 36 ff ff ff       	call   80103650 <mpsearch1>
8010371a:	89 c6                	mov    %eax,%esi
8010371c:	85 c0                	test   %eax,%eax
8010371e:	0f 84 4c 01 00 00    	je     80103870 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103724:	8b 5e 04             	mov    0x4(%esi),%ebx
80103727:	85 db                	test   %ebx,%ebx
80103729:	0f 84 61 01 00 00    	je     80103890 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010372f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103732:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103738:	6a 04                	push   $0x4
8010373a:	68 bd 7a 10 80       	push   $0x80107abd
8010373f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103740:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103743:	e8 58 14 00 00       	call   80104ba0 <memcmp>
80103748:	83 c4 10             	add    $0x10,%esp
8010374b:	85 c0                	test   %eax,%eax
8010374d:	0f 85 3d 01 00 00    	jne    80103890 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103753:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010375a:	3c 01                	cmp    $0x1,%al
8010375c:	74 08                	je     80103766 <mpinit+0x96>
8010375e:	3c 04                	cmp    $0x4,%al
80103760:	0f 85 2a 01 00 00    	jne    80103890 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103766:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010376d:	66 85 d2             	test   %dx,%dx
80103770:	74 26                	je     80103798 <mpinit+0xc8>
80103772:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103775:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103777:	31 d2                	xor    %edx,%edx
80103779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103780:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103787:	83 c0 01             	add    $0x1,%eax
8010378a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010378c:	39 f8                	cmp    %edi,%eax
8010378e:	75 f0                	jne    80103780 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103790:	84 d2                	test   %dl,%dl
80103792:	0f 85 f8 00 00 00    	jne    80103890 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103798:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010379e:	a3 dc 2e 11 80       	mov    %eax,0x80112edc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037a3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801037a9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801037b0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037b5:	03 55 e4             	add    -0x1c(%ebp),%edx
801037b8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801037bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037bf:	90                   	nop
801037c0:	39 c2                	cmp    %eax,%edx
801037c2:	76 15                	jbe    801037d9 <mpinit+0x109>
    switch(*p){
801037c4:	0f b6 08             	movzbl (%eax),%ecx
801037c7:	80 f9 02             	cmp    $0x2,%cl
801037ca:	74 5c                	je     80103828 <mpinit+0x158>
801037cc:	77 42                	ja     80103810 <mpinit+0x140>
801037ce:	84 c9                	test   %cl,%cl
801037d0:	74 6e                	je     80103840 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801037d2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037d5:	39 c2                	cmp    %eax,%edx
801037d7:	77 eb                	ja     801037c4 <mpinit+0xf4>
801037d9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801037dc:	85 db                	test   %ebx,%ebx
801037de:	0f 84 b9 00 00 00    	je     8010389d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801037e4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
801037e8:	74 15                	je     801037ff <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037ea:	b8 70 00 00 00       	mov    $0x70,%eax
801037ef:	ba 22 00 00 00       	mov    $0x22,%edx
801037f4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037f5:	ba 23 00 00 00       	mov    $0x23,%edx
801037fa:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801037fb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037fe:	ee                   	out    %al,(%dx)
  }
}
801037ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103802:	5b                   	pop    %ebx
80103803:	5e                   	pop    %esi
80103804:	5f                   	pop    %edi
80103805:	5d                   	pop    %ebp
80103806:	c3                   	ret    
80103807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010380e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103810:	83 e9 03             	sub    $0x3,%ecx
80103813:	80 f9 01             	cmp    $0x1,%cl
80103816:	76 ba                	jbe    801037d2 <mpinit+0x102>
80103818:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010381f:	eb 9f                	jmp    801037c0 <mpinit+0xf0>
80103821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103828:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010382c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010382f:	88 0d c0 2f 11 80    	mov    %cl,0x80112fc0
      continue;
80103835:	eb 89                	jmp    801037c0 <mpinit+0xf0>
80103837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010383e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103840:	8b 0d 60 35 11 80    	mov    0x80113560,%ecx
80103846:	83 f9 07             	cmp    $0x7,%ecx
80103849:	7f 19                	jg     80103864 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010384b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103851:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103855:	83 c1 01             	add    $0x1,%ecx
80103858:	89 0d 60 35 11 80    	mov    %ecx,0x80113560
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010385e:	88 9f e0 2f 11 80    	mov    %bl,-0x7feed020(%edi)
      p += sizeof(struct mpproc);
80103864:	83 c0 14             	add    $0x14,%eax
      continue;
80103867:	e9 54 ff ff ff       	jmp    801037c0 <mpinit+0xf0>
8010386c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103870:	ba 00 00 01 00       	mov    $0x10000,%edx
80103875:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010387a:	e8 d1 fd ff ff       	call   80103650 <mpsearch1>
8010387f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103881:	85 c0                	test   %eax,%eax
80103883:	0f 85 9b fe ff ff    	jne    80103724 <mpinit+0x54>
80103889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103890:	83 ec 0c             	sub    $0xc,%esp
80103893:	68 c2 7a 10 80       	push   $0x80107ac2
80103898:	e8 63 ce ff ff       	call   80100700 <panic>
    panic("Didn't find a suitable machine");
8010389d:	83 ec 0c             	sub    $0xc,%esp
801038a0:	68 dc 7a 10 80       	push   $0x80107adc
801038a5:	e8 56 ce ff ff       	call   80100700 <panic>
801038aa:	66 90                	xchg   %ax,%ax
801038ac:	66 90                	xchg   %ax,%ax
801038ae:	66 90                	xchg   %ax,%ax

801038b0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801038b0:	f3 0f 1e fb          	endbr32 
801038b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038b9:	ba 21 00 00 00       	mov    $0x21,%edx
801038be:	ee                   	out    %al,(%dx)
801038bf:	ba a1 00 00 00       	mov    $0xa1,%edx
801038c4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801038c5:	c3                   	ret    
801038c6:	66 90                	xchg   %ax,%ax
801038c8:	66 90                	xchg   %ax,%ax
801038ca:	66 90                	xchg   %ax,%ax
801038cc:	66 90                	xchg   %ax,%ax
801038ce:	66 90                	xchg   %ax,%ax

801038d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801038d0:	f3 0f 1e fb          	endbr32 
801038d4:	55                   	push   %ebp
801038d5:	89 e5                	mov    %esp,%ebp
801038d7:	57                   	push   %edi
801038d8:	56                   	push   %esi
801038d9:	53                   	push   %ebx
801038da:	83 ec 0c             	sub    $0xc,%esp
801038dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
801038e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801038e3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801038e9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801038ef:	e8 ec d9 ff ff       	call   801012e0 <filealloc>
801038f4:	89 03                	mov    %eax,(%ebx)
801038f6:	85 c0                	test   %eax,%eax
801038f8:	0f 84 ac 00 00 00    	je     801039aa <pipealloc+0xda>
801038fe:	e8 dd d9 ff ff       	call   801012e0 <filealloc>
80103903:	89 06                	mov    %eax,(%esi)
80103905:	85 c0                	test   %eax,%eax
80103907:	0f 84 8b 00 00 00    	je     80103998 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010390d:	e8 fe f1 ff ff       	call   80102b10 <kalloc>
80103912:	89 c7                	mov    %eax,%edi
80103914:	85 c0                	test   %eax,%eax
80103916:	0f 84 b4 00 00 00    	je     801039d0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010391c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103923:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103926:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103929:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103930:	00 00 00 
  p->nwrite = 0;
80103933:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010393a:	00 00 00 
  p->nread = 0;
8010393d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103944:	00 00 00 
  initlock(&p->lock, "pipe");
80103947:	68 fb 7a 10 80       	push   $0x80107afb
8010394c:	50                   	push   %eax
8010394d:	e8 6e 0f 00 00       	call   801048c0 <initlock>
  (*f0)->type = FD_PIPE;
80103952:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103954:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103957:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010395d:	8b 03                	mov    (%ebx),%eax
8010395f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103963:	8b 03                	mov    (%ebx),%eax
80103965:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103969:	8b 03                	mov    (%ebx),%eax
8010396b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010396e:	8b 06                	mov    (%esi),%eax
80103970:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103976:	8b 06                	mov    (%esi),%eax
80103978:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010397c:	8b 06                	mov    (%esi),%eax
8010397e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103982:	8b 06                	mov    (%esi),%eax
80103984:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103987:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010398a:	31 c0                	xor    %eax,%eax
}
8010398c:	5b                   	pop    %ebx
8010398d:	5e                   	pop    %esi
8010398e:	5f                   	pop    %edi
8010398f:	5d                   	pop    %ebp
80103990:	c3                   	ret    
80103991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103998:	8b 03                	mov    (%ebx),%eax
8010399a:	85 c0                	test   %eax,%eax
8010399c:	74 1e                	je     801039bc <pipealloc+0xec>
    fileclose(*f0);
8010399e:	83 ec 0c             	sub    $0xc,%esp
801039a1:	50                   	push   %eax
801039a2:	e8 f9 d9 ff ff       	call   801013a0 <fileclose>
801039a7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801039aa:	8b 06                	mov    (%esi),%eax
801039ac:	85 c0                	test   %eax,%eax
801039ae:	74 0c                	je     801039bc <pipealloc+0xec>
    fileclose(*f1);
801039b0:	83 ec 0c             	sub    $0xc,%esp
801039b3:	50                   	push   %eax
801039b4:	e8 e7 d9 ff ff       	call   801013a0 <fileclose>
801039b9:	83 c4 10             	add    $0x10,%esp
}
801039bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801039bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801039c4:	5b                   	pop    %ebx
801039c5:	5e                   	pop    %esi
801039c6:	5f                   	pop    %edi
801039c7:	5d                   	pop    %ebp
801039c8:	c3                   	ret    
801039c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801039d0:	8b 03                	mov    (%ebx),%eax
801039d2:	85 c0                	test   %eax,%eax
801039d4:	75 c8                	jne    8010399e <pipealloc+0xce>
801039d6:	eb d2                	jmp    801039aa <pipealloc+0xda>
801039d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039df:	90                   	nop

801039e0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801039e0:	f3 0f 1e fb          	endbr32 
801039e4:	55                   	push   %ebp
801039e5:	89 e5                	mov    %esp,%ebp
801039e7:	56                   	push   %esi
801039e8:	53                   	push   %ebx
801039e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801039ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801039ef:	83 ec 0c             	sub    $0xc,%esp
801039f2:	53                   	push   %ebx
801039f3:	e8 48 10 00 00       	call   80104a40 <acquire>
  if(writable){
801039f8:	83 c4 10             	add    $0x10,%esp
801039fb:	85 f6                	test   %esi,%esi
801039fd:	74 41                	je     80103a40 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801039ff:	83 ec 0c             	sub    $0xc,%esp
80103a02:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103a08:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103a0f:	00 00 00 
    wakeup(&p->nread);
80103a12:	50                   	push   %eax
80103a13:	e8 a8 0b 00 00       	call   801045c0 <wakeup>
80103a18:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103a1b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103a21:	85 d2                	test   %edx,%edx
80103a23:	75 0a                	jne    80103a2f <pipeclose+0x4f>
80103a25:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103a2b:	85 c0                	test   %eax,%eax
80103a2d:	74 31                	je     80103a60 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103a2f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103a32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a35:	5b                   	pop    %ebx
80103a36:	5e                   	pop    %esi
80103a37:	5d                   	pop    %ebp
    release(&p->lock);
80103a38:	e9 c3 10 00 00       	jmp    80104b00 <release>
80103a3d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103a40:	83 ec 0c             	sub    $0xc,%esp
80103a43:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103a49:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103a50:	00 00 00 
    wakeup(&p->nwrite);
80103a53:	50                   	push   %eax
80103a54:	e8 67 0b 00 00       	call   801045c0 <wakeup>
80103a59:	83 c4 10             	add    $0x10,%esp
80103a5c:	eb bd                	jmp    80103a1b <pipeclose+0x3b>
80103a5e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103a60:	83 ec 0c             	sub    $0xc,%esp
80103a63:	53                   	push   %ebx
80103a64:	e8 97 10 00 00       	call   80104b00 <release>
    kfree((char*)p);
80103a69:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103a6c:	83 c4 10             	add    $0x10,%esp
}
80103a6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a72:	5b                   	pop    %ebx
80103a73:	5e                   	pop    %esi
80103a74:	5d                   	pop    %ebp
    kfree((char*)p);
80103a75:	e9 d6 ee ff ff       	jmp    80102950 <kfree>
80103a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a80 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103a80:	f3 0f 1e fb          	endbr32 
80103a84:	55                   	push   %ebp
80103a85:	89 e5                	mov    %esp,%ebp
80103a87:	57                   	push   %edi
80103a88:	56                   	push   %esi
80103a89:	53                   	push   %ebx
80103a8a:	83 ec 28             	sub    $0x28,%esp
80103a8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103a90:	53                   	push   %ebx
80103a91:	e8 aa 0f 00 00       	call   80104a40 <acquire>
  for(i = 0; i < n; i++){
80103a96:	8b 45 10             	mov    0x10(%ebp),%eax
80103a99:	83 c4 10             	add    $0x10,%esp
80103a9c:	85 c0                	test   %eax,%eax
80103a9e:	0f 8e bc 00 00 00    	jle    80103b60 <pipewrite+0xe0>
80103aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103aa7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103aad:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103ab3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ab6:	03 45 10             	add    0x10(%ebp),%eax
80103ab9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103abc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ac2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ac8:	89 ca                	mov    %ecx,%edx
80103aca:	05 00 02 00 00       	add    $0x200,%eax
80103acf:	39 c1                	cmp    %eax,%ecx
80103ad1:	74 3b                	je     80103b0e <pipewrite+0x8e>
80103ad3:	eb 63                	jmp    80103b38 <pipewrite+0xb8>
80103ad5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103ad8:	e8 63 03 00 00       	call   80103e40 <myproc>
80103add:	8b 48 24             	mov    0x24(%eax),%ecx
80103ae0:	85 c9                	test   %ecx,%ecx
80103ae2:	75 34                	jne    80103b18 <pipewrite+0x98>
      wakeup(&p->nread);
80103ae4:	83 ec 0c             	sub    $0xc,%esp
80103ae7:	57                   	push   %edi
80103ae8:	e8 d3 0a 00 00       	call   801045c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103aed:	58                   	pop    %eax
80103aee:	5a                   	pop    %edx
80103aef:	53                   	push   %ebx
80103af0:	56                   	push   %esi
80103af1:	e8 0a 09 00 00       	call   80104400 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103af6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103afc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103b02:	83 c4 10             	add    $0x10,%esp
80103b05:	05 00 02 00 00       	add    $0x200,%eax
80103b0a:	39 c2                	cmp    %eax,%edx
80103b0c:	75 2a                	jne    80103b38 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103b0e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103b14:	85 c0                	test   %eax,%eax
80103b16:	75 c0                	jne    80103ad8 <pipewrite+0x58>
        release(&p->lock);
80103b18:	83 ec 0c             	sub    $0xc,%esp
80103b1b:	53                   	push   %ebx
80103b1c:	e8 df 0f 00 00       	call   80104b00 <release>
        return -1;
80103b21:	83 c4 10             	add    $0x10,%esp
80103b24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103b29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b2c:	5b                   	pop    %ebx
80103b2d:	5e                   	pop    %esi
80103b2e:	5f                   	pop    %edi
80103b2f:	5d                   	pop    %ebp
80103b30:	c3                   	ret    
80103b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b38:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103b3b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103b3e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103b44:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103b4a:	0f b6 06             	movzbl (%esi),%eax
80103b4d:	83 c6 01             	add    $0x1,%esi
80103b50:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103b53:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103b57:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103b5a:	0f 85 5c ff ff ff    	jne    80103abc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103b60:	83 ec 0c             	sub    $0xc,%esp
80103b63:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103b69:	50                   	push   %eax
80103b6a:	e8 51 0a 00 00       	call   801045c0 <wakeup>
  release(&p->lock);
80103b6f:	89 1c 24             	mov    %ebx,(%esp)
80103b72:	e8 89 0f 00 00       	call   80104b00 <release>
  return n;
80103b77:	8b 45 10             	mov    0x10(%ebp),%eax
80103b7a:	83 c4 10             	add    $0x10,%esp
80103b7d:	eb aa                	jmp    80103b29 <pipewrite+0xa9>
80103b7f:	90                   	nop

80103b80 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103b80:	f3 0f 1e fb          	endbr32 
80103b84:	55                   	push   %ebp
80103b85:	89 e5                	mov    %esp,%ebp
80103b87:	57                   	push   %edi
80103b88:	56                   	push   %esi
80103b89:	53                   	push   %ebx
80103b8a:	83 ec 18             	sub    $0x18,%esp
80103b8d:	8b 75 08             	mov    0x8(%ebp),%esi
80103b90:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103b93:	56                   	push   %esi
80103b94:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103b9a:	e8 a1 0e 00 00       	call   80104a40 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b9f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103ba5:	83 c4 10             	add    $0x10,%esp
80103ba8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103bae:	74 33                	je     80103be3 <piperead+0x63>
80103bb0:	eb 3b                	jmp    80103bed <piperead+0x6d>
80103bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103bb8:	e8 83 02 00 00       	call   80103e40 <myproc>
80103bbd:	8b 48 24             	mov    0x24(%eax),%ecx
80103bc0:	85 c9                	test   %ecx,%ecx
80103bc2:	0f 85 88 00 00 00    	jne    80103c50 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103bc8:	83 ec 08             	sub    $0x8,%esp
80103bcb:	56                   	push   %esi
80103bcc:	53                   	push   %ebx
80103bcd:	e8 2e 08 00 00       	call   80104400 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103bd2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103bd8:	83 c4 10             	add    $0x10,%esp
80103bdb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103be1:	75 0a                	jne    80103bed <piperead+0x6d>
80103be3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103be9:	85 c0                	test   %eax,%eax
80103beb:	75 cb                	jne    80103bb8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103bed:	8b 55 10             	mov    0x10(%ebp),%edx
80103bf0:	31 db                	xor    %ebx,%ebx
80103bf2:	85 d2                	test   %edx,%edx
80103bf4:	7f 28                	jg     80103c1e <piperead+0x9e>
80103bf6:	eb 34                	jmp    80103c2c <piperead+0xac>
80103bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bff:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103c00:	8d 48 01             	lea    0x1(%eax),%ecx
80103c03:	25 ff 01 00 00       	and    $0x1ff,%eax
80103c08:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103c0e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103c13:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c16:	83 c3 01             	add    $0x1,%ebx
80103c19:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103c1c:	74 0e                	je     80103c2c <piperead+0xac>
    if(p->nread == p->nwrite)
80103c1e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103c24:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103c2a:	75 d4                	jne    80103c00 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103c2c:	83 ec 0c             	sub    $0xc,%esp
80103c2f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103c35:	50                   	push   %eax
80103c36:	e8 85 09 00 00       	call   801045c0 <wakeup>
  release(&p->lock);
80103c3b:	89 34 24             	mov    %esi,(%esp)
80103c3e:	e8 bd 0e 00 00       	call   80104b00 <release>
  return i;
80103c43:	83 c4 10             	add    $0x10,%esp
}
80103c46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c49:	89 d8                	mov    %ebx,%eax
80103c4b:	5b                   	pop    %ebx
80103c4c:	5e                   	pop    %esi
80103c4d:	5f                   	pop    %edi
80103c4e:	5d                   	pop    %ebp
80103c4f:	c3                   	ret    
      release(&p->lock);
80103c50:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103c53:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103c58:	56                   	push   %esi
80103c59:	e8 a2 0e 00 00       	call   80104b00 <release>
      return -1;
80103c5e:	83 c4 10             	add    $0x10,%esp
}
80103c61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c64:	89 d8                	mov    %ebx,%eax
80103c66:	5b                   	pop    %ebx
80103c67:	5e                   	pop    %esi
80103c68:	5f                   	pop    %edi
80103c69:	5d                   	pop    %ebp
80103c6a:	c3                   	ret    
80103c6b:	66 90                	xchg   %ax,%ax
80103c6d:	66 90                	xchg   %ax,%ax
80103c6f:	90                   	nop

80103c70 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c74:	bb b4 35 11 80       	mov    $0x801135b4,%ebx
{
80103c79:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103c7c:	68 80 35 11 80       	push   $0x80113580
80103c81:	e8 ba 0d 00 00       	call   80104a40 <acquire>
80103c86:	83 c4 10             	add    $0x10,%esp
80103c89:	eb 10                	jmp    80103c9b <allocproc+0x2b>
80103c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c8f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c90:	83 c3 7c             	add    $0x7c,%ebx
80103c93:	81 fb b4 54 11 80    	cmp    $0x801154b4,%ebx
80103c99:	74 75                	je     80103d10 <allocproc+0xa0>
    if(p->state == UNUSED)
80103c9b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103c9e:	85 c0                	test   %eax,%eax
80103ca0:	75 ee                	jne    80103c90 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103ca2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103ca7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103caa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103cb1:	89 43 10             	mov    %eax,0x10(%ebx)
80103cb4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103cb7:	68 80 35 11 80       	push   $0x80113580
  p->pid = nextpid++;
80103cbc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103cc2:	e8 39 0e 00 00       	call   80104b00 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103cc7:	e8 44 ee ff ff       	call   80102b10 <kalloc>
80103ccc:	83 c4 10             	add    $0x10,%esp
80103ccf:	89 43 08             	mov    %eax,0x8(%ebx)
80103cd2:	85 c0                	test   %eax,%eax
80103cd4:	74 53                	je     80103d29 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103cd6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103cdc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103cdf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103ce4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103ce7:	c7 40 14 66 5d 10 80 	movl   $0x80105d66,0x14(%eax)
  p->context = (struct context*)sp;
80103cee:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103cf1:	6a 14                	push   $0x14
80103cf3:	6a 00                	push   $0x0
80103cf5:	50                   	push   %eax
80103cf6:	e8 55 0e 00 00       	call   80104b50 <memset>
  p->context->eip = (uint)forkret;
80103cfb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103cfe:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103d01:	c7 40 10 40 3d 10 80 	movl   $0x80103d40,0x10(%eax)
}
80103d08:	89 d8                	mov    %ebx,%eax
80103d0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d0d:	c9                   	leave  
80103d0e:	c3                   	ret    
80103d0f:	90                   	nop
  release(&ptable.lock);
80103d10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103d13:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103d15:	68 80 35 11 80       	push   $0x80113580
80103d1a:	e8 e1 0d 00 00       	call   80104b00 <release>
}
80103d1f:	89 d8                	mov    %ebx,%eax
  return 0;
80103d21:	83 c4 10             	add    $0x10,%esp
}
80103d24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d27:	c9                   	leave  
80103d28:	c3                   	ret    
    p->state = UNUSED;
80103d29:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103d30:	31 db                	xor    %ebx,%ebx
}
80103d32:	89 d8                	mov    %ebx,%eax
80103d34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d37:	c9                   	leave  
80103d38:	c3                   	ret    
80103d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d40 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103d40:	f3 0f 1e fb          	endbr32 
80103d44:	55                   	push   %ebp
80103d45:	89 e5                	mov    %esp,%ebp
80103d47:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103d4a:	68 80 35 11 80       	push   $0x80113580
80103d4f:	e8 ac 0d 00 00       	call   80104b00 <release>

  if (first) {
80103d54:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103d59:	83 c4 10             	add    $0x10,%esp
80103d5c:	85 c0                	test   %eax,%eax
80103d5e:	75 08                	jne    80103d68 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103d60:	c9                   	leave  
80103d61:	c3                   	ret    
80103d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103d68:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103d6f:	00 00 00 
    iinit(ROOTDEV);
80103d72:	83 ec 0c             	sub    $0xc,%esp
80103d75:	6a 01                	push   $0x1
80103d77:	e8 a4 dc ff ff       	call   80101a20 <iinit>
    initlog(ROOTDEV);
80103d7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103d83:	e8 e8 f3 ff ff       	call   80103170 <initlog>
}
80103d88:	83 c4 10             	add    $0x10,%esp
80103d8b:	c9                   	leave  
80103d8c:	c3                   	ret    
80103d8d:	8d 76 00             	lea    0x0(%esi),%esi

80103d90 <pinit>:
{
80103d90:	f3 0f 1e fb          	endbr32 
80103d94:	55                   	push   %ebp
80103d95:	89 e5                	mov    %esp,%ebp
80103d97:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103d9a:	68 00 7b 10 80       	push   $0x80107b00
80103d9f:	68 80 35 11 80       	push   $0x80113580
80103da4:	e8 17 0b 00 00       	call   801048c0 <initlock>
}
80103da9:	83 c4 10             	add    $0x10,%esp
80103dac:	c9                   	leave  
80103dad:	c3                   	ret    
80103dae:	66 90                	xchg   %ax,%ax

80103db0 <mycpu>:
{
80103db0:	f3 0f 1e fb          	endbr32 
80103db4:	55                   	push   %ebp
80103db5:	89 e5                	mov    %esp,%ebp
80103db7:	56                   	push   %esi
80103db8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103db9:	9c                   	pushf  
80103dba:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103dbb:	f6 c4 02             	test   $0x2,%ah
80103dbe:	75 4a                	jne    80103e0a <mycpu+0x5a>
  apicid = lapicid();
80103dc0:	e8 bb ef ff ff       	call   80102d80 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103dc5:	8b 35 60 35 11 80    	mov    0x80113560,%esi
  apicid = lapicid();
80103dcb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103dcd:	85 f6                	test   %esi,%esi
80103dcf:	7e 2c                	jle    80103dfd <mycpu+0x4d>
80103dd1:	31 d2                	xor    %edx,%edx
80103dd3:	eb 0a                	jmp    80103ddf <mycpu+0x2f>
80103dd5:	8d 76 00             	lea    0x0(%esi),%esi
80103dd8:	83 c2 01             	add    $0x1,%edx
80103ddb:	39 f2                	cmp    %esi,%edx
80103ddd:	74 1e                	je     80103dfd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103ddf:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103de5:	0f b6 81 e0 2f 11 80 	movzbl -0x7feed020(%ecx),%eax
80103dec:	39 d8                	cmp    %ebx,%eax
80103dee:	75 e8                	jne    80103dd8 <mycpu+0x28>
}
80103df0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103df3:	8d 81 e0 2f 11 80    	lea    -0x7feed020(%ecx),%eax
}
80103df9:	5b                   	pop    %ebx
80103dfa:	5e                   	pop    %esi
80103dfb:	5d                   	pop    %ebp
80103dfc:	c3                   	ret    
  panic("unknown apicid\n");
80103dfd:	83 ec 0c             	sub    $0xc,%esp
80103e00:	68 07 7b 10 80       	push   $0x80107b07
80103e05:	e8 f6 c8 ff ff       	call   80100700 <panic>
    panic("mycpu called with interrupts enabled\n");
80103e0a:	83 ec 0c             	sub    $0xc,%esp
80103e0d:	68 e4 7b 10 80       	push   $0x80107be4
80103e12:	e8 e9 c8 ff ff       	call   80100700 <panic>
80103e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e1e:	66 90                	xchg   %ax,%ax

80103e20 <cpuid>:
cpuid() {
80103e20:	f3 0f 1e fb          	endbr32 
80103e24:	55                   	push   %ebp
80103e25:	89 e5                	mov    %esp,%ebp
80103e27:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103e2a:	e8 81 ff ff ff       	call   80103db0 <mycpu>
}
80103e2f:	c9                   	leave  
  return mycpu()-cpus;
80103e30:	2d e0 2f 11 80       	sub    $0x80112fe0,%eax
80103e35:	c1 f8 04             	sar    $0x4,%eax
80103e38:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103e3e:	c3                   	ret    
80103e3f:	90                   	nop

80103e40 <myproc>:
myproc(void) {
80103e40:	f3 0f 1e fb          	endbr32 
80103e44:	55                   	push   %ebp
80103e45:	89 e5                	mov    %esp,%ebp
80103e47:	53                   	push   %ebx
80103e48:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103e4b:	e8 f0 0a 00 00       	call   80104940 <pushcli>
  c = mycpu();
80103e50:	e8 5b ff ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80103e55:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e5b:	e8 30 0b 00 00       	call   80104990 <popcli>
}
80103e60:	83 c4 04             	add    $0x4,%esp
80103e63:	89 d8                	mov    %ebx,%eax
80103e65:	5b                   	pop    %ebx
80103e66:	5d                   	pop    %ebp
80103e67:	c3                   	ret    
80103e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e6f:	90                   	nop

80103e70 <userinit>:
{
80103e70:	f3 0f 1e fb          	endbr32 
80103e74:	55                   	push   %ebp
80103e75:	89 e5                	mov    %esp,%ebp
80103e77:	53                   	push   %ebx
80103e78:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103e7b:	e8 f0 fd ff ff       	call   80103c70 <allocproc>
80103e80:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103e82:	a3 d8 a5 10 80       	mov    %eax,0x8010a5d8
  if((p->pgdir = setupkvm()) == 0)
80103e87:	e8 a4 34 00 00       	call   80107330 <setupkvm>
80103e8c:	89 43 04             	mov    %eax,0x4(%ebx)
80103e8f:	85 c0                	test   %eax,%eax
80103e91:	0f 84 bd 00 00 00    	je     80103f54 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103e97:	83 ec 04             	sub    $0x4,%esp
80103e9a:	68 2c 00 00 00       	push   $0x2c
80103e9f:	68 60 a4 10 80       	push   $0x8010a460
80103ea4:	50                   	push   %eax
80103ea5:	e8 56 31 00 00       	call   80107000 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103eaa:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103ead:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103eb3:	6a 4c                	push   $0x4c
80103eb5:	6a 00                	push   $0x0
80103eb7:	ff 73 18             	pushl  0x18(%ebx)
80103eba:	e8 91 0c 00 00       	call   80104b50 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ebf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ec2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ec7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103eca:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ecf:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ed3:	8b 43 18             	mov    0x18(%ebx),%eax
80103ed6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103eda:	8b 43 18             	mov    0x18(%ebx),%eax
80103edd:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ee1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ee5:	8b 43 18             	mov    0x18(%ebx),%eax
80103ee8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103eec:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103ef0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ef3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103efa:	8b 43 18             	mov    0x18(%ebx),%eax
80103efd:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103f04:	8b 43 18             	mov    0x18(%ebx),%eax
80103f07:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f0e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103f11:	6a 10                	push   $0x10
80103f13:	68 30 7b 10 80       	push   $0x80107b30
80103f18:	50                   	push   %eax
80103f19:	e8 f2 0d 00 00       	call   80104d10 <safestrcpy>
  p->cwd = namei("/");
80103f1e:	c7 04 24 39 7b 10 80 	movl   $0x80107b39,(%esp)
80103f25:	e8 e6 e5 ff ff       	call   80102510 <namei>
80103f2a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103f2d:	c7 04 24 80 35 11 80 	movl   $0x80113580,(%esp)
80103f34:	e8 07 0b 00 00       	call   80104a40 <acquire>
  p->state = RUNNABLE;
80103f39:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103f40:	c7 04 24 80 35 11 80 	movl   $0x80113580,(%esp)
80103f47:	e8 b4 0b 00 00       	call   80104b00 <release>
}
80103f4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f4f:	83 c4 10             	add    $0x10,%esp
80103f52:	c9                   	leave  
80103f53:	c3                   	ret    
    panic("userinit: out of memory?");
80103f54:	83 ec 0c             	sub    $0xc,%esp
80103f57:	68 17 7b 10 80       	push   $0x80107b17
80103f5c:	e8 9f c7 ff ff       	call   80100700 <panic>
80103f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f6f:	90                   	nop

80103f70 <growproc>:
{
80103f70:	f3 0f 1e fb          	endbr32 
80103f74:	55                   	push   %ebp
80103f75:	89 e5                	mov    %esp,%ebp
80103f77:	56                   	push   %esi
80103f78:	53                   	push   %ebx
80103f79:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103f7c:	e8 bf 09 00 00       	call   80104940 <pushcli>
  c = mycpu();
80103f81:	e8 2a fe ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80103f86:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f8c:	e8 ff 09 00 00       	call   80104990 <popcli>
  sz = curproc->sz;
80103f91:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103f93:	85 f6                	test   %esi,%esi
80103f95:	7f 19                	jg     80103fb0 <growproc+0x40>
  } else if(n < 0){
80103f97:	75 37                	jne    80103fd0 <growproc+0x60>
  switchuvm(curproc);
80103f99:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f9c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f9e:	53                   	push   %ebx
80103f9f:	e8 4c 2f 00 00       	call   80106ef0 <switchuvm>
  return 0;
80103fa4:	83 c4 10             	add    $0x10,%esp
80103fa7:	31 c0                	xor    %eax,%eax
}
80103fa9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fac:	5b                   	pop    %ebx
80103fad:	5e                   	pop    %esi
80103fae:	5d                   	pop    %ebp
80103faf:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fb0:	83 ec 04             	sub    $0x4,%esp
80103fb3:	01 c6                	add    %eax,%esi
80103fb5:	56                   	push   %esi
80103fb6:	50                   	push   %eax
80103fb7:	ff 73 04             	pushl  0x4(%ebx)
80103fba:	e8 91 31 00 00       	call   80107150 <allocuvm>
80103fbf:	83 c4 10             	add    $0x10,%esp
80103fc2:	85 c0                	test   %eax,%eax
80103fc4:	75 d3                	jne    80103f99 <growproc+0x29>
      return -1;
80103fc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fcb:	eb dc                	jmp    80103fa9 <growproc+0x39>
80103fcd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fd0:	83 ec 04             	sub    $0x4,%esp
80103fd3:	01 c6                	add    %eax,%esi
80103fd5:	56                   	push   %esi
80103fd6:	50                   	push   %eax
80103fd7:	ff 73 04             	pushl  0x4(%ebx)
80103fda:	e8 a1 32 00 00       	call   80107280 <deallocuvm>
80103fdf:	83 c4 10             	add    $0x10,%esp
80103fe2:	85 c0                	test   %eax,%eax
80103fe4:	75 b3                	jne    80103f99 <growproc+0x29>
80103fe6:	eb de                	jmp    80103fc6 <growproc+0x56>
80103fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fef:	90                   	nop

80103ff0 <fork>:
{
80103ff0:	f3 0f 1e fb          	endbr32 
80103ff4:	55                   	push   %ebp
80103ff5:	89 e5                	mov    %esp,%ebp
80103ff7:	57                   	push   %edi
80103ff8:	56                   	push   %esi
80103ff9:	53                   	push   %ebx
80103ffa:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ffd:	e8 3e 09 00 00       	call   80104940 <pushcli>
  c = mycpu();
80104002:	e8 a9 fd ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80104007:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010400d:	e8 7e 09 00 00       	call   80104990 <popcli>
  if((np = allocproc()) == 0){
80104012:	e8 59 fc ff ff       	call   80103c70 <allocproc>
80104017:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010401a:	85 c0                	test   %eax,%eax
8010401c:	0f 84 bb 00 00 00    	je     801040dd <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104022:	83 ec 08             	sub    $0x8,%esp
80104025:	ff 33                	pushl  (%ebx)
80104027:	89 c7                	mov    %eax,%edi
80104029:	ff 73 04             	pushl  0x4(%ebx)
8010402c:	e8 cf 33 00 00       	call   80107400 <copyuvm>
80104031:	83 c4 10             	add    $0x10,%esp
80104034:	89 47 04             	mov    %eax,0x4(%edi)
80104037:	85 c0                	test   %eax,%eax
80104039:	0f 84 a5 00 00 00    	je     801040e4 <fork+0xf4>
  np->sz = curproc->sz;
8010403f:	8b 03                	mov    (%ebx),%eax
80104041:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104044:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104046:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104049:	89 c8                	mov    %ecx,%eax
8010404b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010404e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104053:	8b 73 18             	mov    0x18(%ebx),%esi
80104056:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104058:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010405a:	8b 40 18             	mov    0x18(%eax),%eax
8010405d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104068:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010406c:	85 c0                	test   %eax,%eax
8010406e:	74 13                	je     80104083 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104070:	83 ec 0c             	sub    $0xc,%esp
80104073:	50                   	push   %eax
80104074:	e8 d7 d2 ff ff       	call   80101350 <filedup>
80104079:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010407c:	83 c4 10             	add    $0x10,%esp
8010407f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104083:	83 c6 01             	add    $0x1,%esi
80104086:	83 fe 10             	cmp    $0x10,%esi
80104089:	75 dd                	jne    80104068 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010408b:	83 ec 0c             	sub    $0xc,%esp
8010408e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104091:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104094:	e8 77 db ff ff       	call   80101c10 <idup>
80104099:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010409c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010409f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040a2:	8d 47 6c             	lea    0x6c(%edi),%eax
801040a5:	6a 10                	push   $0x10
801040a7:	53                   	push   %ebx
801040a8:	50                   	push   %eax
801040a9:	e8 62 0c 00 00       	call   80104d10 <safestrcpy>
  pid = np->pid;
801040ae:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801040b1:	c7 04 24 80 35 11 80 	movl   $0x80113580,(%esp)
801040b8:	e8 83 09 00 00       	call   80104a40 <acquire>
  np->state = RUNNABLE;
801040bd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801040c4:	c7 04 24 80 35 11 80 	movl   $0x80113580,(%esp)
801040cb:	e8 30 0a 00 00       	call   80104b00 <release>
  return pid;
801040d0:	83 c4 10             	add    $0x10,%esp
}
801040d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040d6:	89 d8                	mov    %ebx,%eax
801040d8:	5b                   	pop    %ebx
801040d9:	5e                   	pop    %esi
801040da:	5f                   	pop    %edi
801040db:	5d                   	pop    %ebp
801040dc:	c3                   	ret    
    return -1;
801040dd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801040e2:	eb ef                	jmp    801040d3 <fork+0xe3>
    kfree(np->kstack);
801040e4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801040e7:	83 ec 0c             	sub    $0xc,%esp
801040ea:	ff 73 08             	pushl  0x8(%ebx)
801040ed:	e8 5e e8 ff ff       	call   80102950 <kfree>
    np->kstack = 0;
801040f2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801040f9:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801040fc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104103:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104108:	eb c9                	jmp    801040d3 <fork+0xe3>
8010410a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104110 <scheduler>:
{
80104110:	f3 0f 1e fb          	endbr32 
80104114:	55                   	push   %ebp
80104115:	89 e5                	mov    %esp,%ebp
80104117:	57                   	push   %edi
80104118:	56                   	push   %esi
80104119:	53                   	push   %ebx
8010411a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010411d:	e8 8e fc ff ff       	call   80103db0 <mycpu>
  c->proc = 0;
80104122:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104129:	00 00 00 
  struct cpu *c = mycpu();
8010412c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010412e:	8d 78 04             	lea    0x4(%eax),%edi
80104131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104138:	fb                   	sti    
    acquire(&ptable.lock);
80104139:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010413c:	bb b4 35 11 80       	mov    $0x801135b4,%ebx
    acquire(&ptable.lock);
80104141:	68 80 35 11 80       	push   $0x80113580
80104146:	e8 f5 08 00 00       	call   80104a40 <acquire>
8010414b:	83 c4 10             	add    $0x10,%esp
8010414e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104150:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104154:	75 33                	jne    80104189 <scheduler+0x79>
      switchuvm(p);
80104156:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104159:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010415f:	53                   	push   %ebx
80104160:	e8 8b 2d 00 00       	call   80106ef0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104165:	58                   	pop    %eax
80104166:	5a                   	pop    %edx
80104167:	ff 73 1c             	pushl  0x1c(%ebx)
8010416a:	57                   	push   %edi
      p->state = RUNNING;
8010416b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104172:	e8 fc 0b 00 00       	call   80104d73 <swtch>
      switchkvm();
80104177:	e8 54 2d 00 00       	call   80106ed0 <switchkvm>
      c->proc = 0;
8010417c:	83 c4 10             	add    $0x10,%esp
8010417f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104186:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104189:	83 c3 7c             	add    $0x7c,%ebx
8010418c:	81 fb b4 54 11 80    	cmp    $0x801154b4,%ebx
80104192:	75 bc                	jne    80104150 <scheduler+0x40>
    release(&ptable.lock);
80104194:	83 ec 0c             	sub    $0xc,%esp
80104197:	68 80 35 11 80       	push   $0x80113580
8010419c:	e8 5f 09 00 00       	call   80104b00 <release>
    sti();
801041a1:	83 c4 10             	add    $0x10,%esp
801041a4:	eb 92                	jmp    80104138 <scheduler+0x28>
801041a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ad:	8d 76 00             	lea    0x0(%esi),%esi

801041b0 <sched>:
{
801041b0:	f3 0f 1e fb          	endbr32 
801041b4:	55                   	push   %ebp
801041b5:	89 e5                	mov    %esp,%ebp
801041b7:	56                   	push   %esi
801041b8:	53                   	push   %ebx
  pushcli();
801041b9:	e8 82 07 00 00       	call   80104940 <pushcli>
  c = mycpu();
801041be:	e8 ed fb ff ff       	call   80103db0 <mycpu>
  p = c->proc;
801041c3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041c9:	e8 c2 07 00 00       	call   80104990 <popcli>
  if(!holding(&ptable.lock))
801041ce:	83 ec 0c             	sub    $0xc,%esp
801041d1:	68 80 35 11 80       	push   $0x80113580
801041d6:	e8 15 08 00 00       	call   801049f0 <holding>
801041db:	83 c4 10             	add    $0x10,%esp
801041de:	85 c0                	test   %eax,%eax
801041e0:	74 4f                	je     80104231 <sched+0x81>
  if(mycpu()->ncli != 1)
801041e2:	e8 c9 fb ff ff       	call   80103db0 <mycpu>
801041e7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801041ee:	75 68                	jne    80104258 <sched+0xa8>
  if(p->state == RUNNING)
801041f0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801041f4:	74 55                	je     8010424b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041f6:	9c                   	pushf  
801041f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041f8:	f6 c4 02             	test   $0x2,%ah
801041fb:	75 41                	jne    8010423e <sched+0x8e>
  intena = mycpu()->intena;
801041fd:	e8 ae fb ff ff       	call   80103db0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104202:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104205:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010420b:	e8 a0 fb ff ff       	call   80103db0 <mycpu>
80104210:	83 ec 08             	sub    $0x8,%esp
80104213:	ff 70 04             	pushl  0x4(%eax)
80104216:	53                   	push   %ebx
80104217:	e8 57 0b 00 00       	call   80104d73 <swtch>
  mycpu()->intena = intena;
8010421c:	e8 8f fb ff ff       	call   80103db0 <mycpu>
}
80104221:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104224:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010422a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010422d:	5b                   	pop    %ebx
8010422e:	5e                   	pop    %esi
8010422f:	5d                   	pop    %ebp
80104230:	c3                   	ret    
    panic("sched ptable.lock");
80104231:	83 ec 0c             	sub    $0xc,%esp
80104234:	68 3b 7b 10 80       	push   $0x80107b3b
80104239:	e8 c2 c4 ff ff       	call   80100700 <panic>
    panic("sched interruptible");
8010423e:	83 ec 0c             	sub    $0xc,%esp
80104241:	68 67 7b 10 80       	push   $0x80107b67
80104246:	e8 b5 c4 ff ff       	call   80100700 <panic>
    panic("sched running");
8010424b:	83 ec 0c             	sub    $0xc,%esp
8010424e:	68 59 7b 10 80       	push   $0x80107b59
80104253:	e8 a8 c4 ff ff       	call   80100700 <panic>
    panic("sched locks");
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	68 4d 7b 10 80       	push   $0x80107b4d
80104260:	e8 9b c4 ff ff       	call   80100700 <panic>
80104265:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010426c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104270 <exit>:
{
80104270:	f3 0f 1e fb          	endbr32 
80104274:	55                   	push   %ebp
80104275:	89 e5                	mov    %esp,%ebp
80104277:	57                   	push   %edi
80104278:	56                   	push   %esi
80104279:	53                   	push   %ebx
8010427a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010427d:	e8 be 06 00 00       	call   80104940 <pushcli>
  c = mycpu();
80104282:	e8 29 fb ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80104287:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010428d:	e8 fe 06 00 00       	call   80104990 <popcli>
  if(curproc == initproc)
80104292:	8d 5e 28             	lea    0x28(%esi),%ebx
80104295:	8d 7e 68             	lea    0x68(%esi),%edi
80104298:	39 35 d8 a5 10 80    	cmp    %esi,0x8010a5d8
8010429e:	0f 84 f3 00 00 00    	je     80104397 <exit+0x127>
801042a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801042a8:	8b 03                	mov    (%ebx),%eax
801042aa:	85 c0                	test   %eax,%eax
801042ac:	74 12                	je     801042c0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801042ae:	83 ec 0c             	sub    $0xc,%esp
801042b1:	50                   	push   %eax
801042b2:	e8 e9 d0 ff ff       	call   801013a0 <fileclose>
      curproc->ofile[fd] = 0;
801042b7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801042bd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801042c0:	83 c3 04             	add    $0x4,%ebx
801042c3:	39 df                	cmp    %ebx,%edi
801042c5:	75 e1                	jne    801042a8 <exit+0x38>
  begin_op();
801042c7:	e8 44 ef ff ff       	call   80103210 <begin_op>
  iput(curproc->cwd);
801042cc:	83 ec 0c             	sub    $0xc,%esp
801042cf:	ff 76 68             	pushl  0x68(%esi)
801042d2:	e8 99 da ff ff       	call   80101d70 <iput>
  end_op();
801042d7:	e8 a4 ef ff ff       	call   80103280 <end_op>
  curproc->cwd = 0;
801042dc:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801042e3:	c7 04 24 80 35 11 80 	movl   $0x80113580,(%esp)
801042ea:	e8 51 07 00 00       	call   80104a40 <acquire>
  wakeup1(curproc->parent);
801042ef:	8b 56 14             	mov    0x14(%esi),%edx
801042f2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042f5:	b8 b4 35 11 80       	mov    $0x801135b4,%eax
801042fa:	eb 0e                	jmp    8010430a <exit+0x9a>
801042fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104300:	83 c0 7c             	add    $0x7c,%eax
80104303:	3d b4 54 11 80       	cmp    $0x801154b4,%eax
80104308:	74 1c                	je     80104326 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
8010430a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010430e:	75 f0                	jne    80104300 <exit+0x90>
80104310:	3b 50 20             	cmp    0x20(%eax),%edx
80104313:	75 eb                	jne    80104300 <exit+0x90>
      p->state = RUNNABLE;
80104315:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010431c:	83 c0 7c             	add    $0x7c,%eax
8010431f:	3d b4 54 11 80       	cmp    $0x801154b4,%eax
80104324:	75 e4                	jne    8010430a <exit+0x9a>
      p->parent = initproc;
80104326:	8b 0d d8 a5 10 80    	mov    0x8010a5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010432c:	ba b4 35 11 80       	mov    $0x801135b4,%edx
80104331:	eb 10                	jmp    80104343 <exit+0xd3>
80104333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104337:	90                   	nop
80104338:	83 c2 7c             	add    $0x7c,%edx
8010433b:	81 fa b4 54 11 80    	cmp    $0x801154b4,%edx
80104341:	74 3b                	je     8010437e <exit+0x10e>
    if(p->parent == curproc){
80104343:	39 72 14             	cmp    %esi,0x14(%edx)
80104346:	75 f0                	jne    80104338 <exit+0xc8>
      if(p->state == ZOMBIE)
80104348:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010434c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010434f:	75 e7                	jne    80104338 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104351:	b8 b4 35 11 80       	mov    $0x801135b4,%eax
80104356:	eb 12                	jmp    8010436a <exit+0xfa>
80104358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010435f:	90                   	nop
80104360:	83 c0 7c             	add    $0x7c,%eax
80104363:	3d b4 54 11 80       	cmp    $0x801154b4,%eax
80104368:	74 ce                	je     80104338 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
8010436a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010436e:	75 f0                	jne    80104360 <exit+0xf0>
80104370:	3b 48 20             	cmp    0x20(%eax),%ecx
80104373:	75 eb                	jne    80104360 <exit+0xf0>
      p->state = RUNNABLE;
80104375:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010437c:	eb e2                	jmp    80104360 <exit+0xf0>
  curproc->state = ZOMBIE;
8010437e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104385:	e8 26 fe ff ff       	call   801041b0 <sched>
  panic("zombie exit");
8010438a:	83 ec 0c             	sub    $0xc,%esp
8010438d:	68 88 7b 10 80       	push   $0x80107b88
80104392:	e8 69 c3 ff ff       	call   80100700 <panic>
    panic("init exiting");
80104397:	83 ec 0c             	sub    $0xc,%esp
8010439a:	68 7b 7b 10 80       	push   $0x80107b7b
8010439f:	e8 5c c3 ff ff       	call   80100700 <panic>
801043a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043af:	90                   	nop

801043b0 <yield>:
{
801043b0:	f3 0f 1e fb          	endbr32 
801043b4:	55                   	push   %ebp
801043b5:	89 e5                	mov    %esp,%ebp
801043b7:	53                   	push   %ebx
801043b8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801043bb:	68 80 35 11 80       	push   $0x80113580
801043c0:	e8 7b 06 00 00       	call   80104a40 <acquire>
  pushcli();
801043c5:	e8 76 05 00 00       	call   80104940 <pushcli>
  c = mycpu();
801043ca:	e8 e1 f9 ff ff       	call   80103db0 <mycpu>
  p = c->proc;
801043cf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043d5:	e8 b6 05 00 00       	call   80104990 <popcli>
  myproc()->state = RUNNABLE;
801043da:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801043e1:	e8 ca fd ff ff       	call   801041b0 <sched>
  release(&ptable.lock);
801043e6:	c7 04 24 80 35 11 80 	movl   $0x80113580,(%esp)
801043ed:	e8 0e 07 00 00       	call   80104b00 <release>
}
801043f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043f5:	83 c4 10             	add    $0x10,%esp
801043f8:	c9                   	leave  
801043f9:	c3                   	ret    
801043fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104400 <sleep>:
{
80104400:	f3 0f 1e fb          	endbr32 
80104404:	55                   	push   %ebp
80104405:	89 e5                	mov    %esp,%ebp
80104407:	57                   	push   %edi
80104408:	56                   	push   %esi
80104409:	53                   	push   %ebx
8010440a:	83 ec 0c             	sub    $0xc,%esp
8010440d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104410:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104413:	e8 28 05 00 00       	call   80104940 <pushcli>
  c = mycpu();
80104418:	e8 93 f9 ff ff       	call   80103db0 <mycpu>
  p = c->proc;
8010441d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104423:	e8 68 05 00 00       	call   80104990 <popcli>
  if(p == 0)
80104428:	85 db                	test   %ebx,%ebx
8010442a:	0f 84 83 00 00 00    	je     801044b3 <sleep+0xb3>
  if(lk == 0)
80104430:	85 f6                	test   %esi,%esi
80104432:	74 72                	je     801044a6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104434:	81 fe 80 35 11 80    	cmp    $0x80113580,%esi
8010443a:	74 4c                	je     80104488 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010443c:	83 ec 0c             	sub    $0xc,%esp
8010443f:	68 80 35 11 80       	push   $0x80113580
80104444:	e8 f7 05 00 00       	call   80104a40 <acquire>
    release(lk);
80104449:	89 34 24             	mov    %esi,(%esp)
8010444c:	e8 af 06 00 00       	call   80104b00 <release>
  p->chan = chan;
80104451:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104454:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010445b:	e8 50 fd ff ff       	call   801041b0 <sched>
  p->chan = 0;
80104460:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104467:	c7 04 24 80 35 11 80 	movl   $0x80113580,(%esp)
8010446e:	e8 8d 06 00 00       	call   80104b00 <release>
    acquire(lk);
80104473:	89 75 08             	mov    %esi,0x8(%ebp)
80104476:	83 c4 10             	add    $0x10,%esp
}
80104479:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010447c:	5b                   	pop    %ebx
8010447d:	5e                   	pop    %esi
8010447e:	5f                   	pop    %edi
8010447f:	5d                   	pop    %ebp
    acquire(lk);
80104480:	e9 bb 05 00 00       	jmp    80104a40 <acquire>
80104485:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104488:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010448b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104492:	e8 19 fd ff ff       	call   801041b0 <sched>
  p->chan = 0;
80104497:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010449e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044a1:	5b                   	pop    %ebx
801044a2:	5e                   	pop    %esi
801044a3:	5f                   	pop    %edi
801044a4:	5d                   	pop    %ebp
801044a5:	c3                   	ret    
    panic("sleep without lk");
801044a6:	83 ec 0c             	sub    $0xc,%esp
801044a9:	68 9a 7b 10 80       	push   $0x80107b9a
801044ae:	e8 4d c2 ff ff       	call   80100700 <panic>
    panic("sleep");
801044b3:	83 ec 0c             	sub    $0xc,%esp
801044b6:	68 94 7b 10 80       	push   $0x80107b94
801044bb:	e8 40 c2 ff ff       	call   80100700 <panic>

801044c0 <wait>:
{
801044c0:	f3 0f 1e fb          	endbr32 
801044c4:	55                   	push   %ebp
801044c5:	89 e5                	mov    %esp,%ebp
801044c7:	56                   	push   %esi
801044c8:	53                   	push   %ebx
  pushcli();
801044c9:	e8 72 04 00 00       	call   80104940 <pushcli>
  c = mycpu();
801044ce:	e8 dd f8 ff ff       	call   80103db0 <mycpu>
  p = c->proc;
801044d3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801044d9:	e8 b2 04 00 00       	call   80104990 <popcli>
  acquire(&ptable.lock);
801044de:	83 ec 0c             	sub    $0xc,%esp
801044e1:	68 80 35 11 80       	push   $0x80113580
801044e6:	e8 55 05 00 00       	call   80104a40 <acquire>
801044eb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801044ee:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044f0:	bb b4 35 11 80       	mov    $0x801135b4,%ebx
801044f5:	eb 14                	jmp    8010450b <wait+0x4b>
801044f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044fe:	66 90                	xchg   %ax,%ax
80104500:	83 c3 7c             	add    $0x7c,%ebx
80104503:	81 fb b4 54 11 80    	cmp    $0x801154b4,%ebx
80104509:	74 1b                	je     80104526 <wait+0x66>
      if(p->parent != curproc)
8010450b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010450e:	75 f0                	jne    80104500 <wait+0x40>
      if(p->state == ZOMBIE){
80104510:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104514:	74 32                	je     80104548 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104516:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104519:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010451e:	81 fb b4 54 11 80    	cmp    $0x801154b4,%ebx
80104524:	75 e5                	jne    8010450b <wait+0x4b>
    if(!havekids || curproc->killed){
80104526:	85 c0                	test   %eax,%eax
80104528:	74 74                	je     8010459e <wait+0xde>
8010452a:	8b 46 24             	mov    0x24(%esi),%eax
8010452d:	85 c0                	test   %eax,%eax
8010452f:	75 6d                	jne    8010459e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104531:	83 ec 08             	sub    $0x8,%esp
80104534:	68 80 35 11 80       	push   $0x80113580
80104539:	56                   	push   %esi
8010453a:	e8 c1 fe ff ff       	call   80104400 <sleep>
    havekids = 0;
8010453f:	83 c4 10             	add    $0x10,%esp
80104542:	eb aa                	jmp    801044ee <wait+0x2e>
80104544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104548:	83 ec 0c             	sub    $0xc,%esp
8010454b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010454e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104551:	e8 fa e3 ff ff       	call   80102950 <kfree>
        freevm(p->pgdir);
80104556:	5a                   	pop    %edx
80104557:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010455a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104561:	e8 4a 2d 00 00       	call   801072b0 <freevm>
        release(&ptable.lock);
80104566:	c7 04 24 80 35 11 80 	movl   $0x80113580,(%esp)
        p->pid = 0;
8010456d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104574:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010457b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010457f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104586:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010458d:	e8 6e 05 00 00       	call   80104b00 <release>
        return pid;
80104592:	83 c4 10             	add    $0x10,%esp
}
80104595:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104598:	89 f0                	mov    %esi,%eax
8010459a:	5b                   	pop    %ebx
8010459b:	5e                   	pop    %esi
8010459c:	5d                   	pop    %ebp
8010459d:	c3                   	ret    
      release(&ptable.lock);
8010459e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801045a1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801045a6:	68 80 35 11 80       	push   $0x80113580
801045ab:	e8 50 05 00 00       	call   80104b00 <release>
      return -1;
801045b0:	83 c4 10             	add    $0x10,%esp
801045b3:	eb e0                	jmp    80104595 <wait+0xd5>
801045b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801045c0:	f3 0f 1e fb          	endbr32 
801045c4:	55                   	push   %ebp
801045c5:	89 e5                	mov    %esp,%ebp
801045c7:	53                   	push   %ebx
801045c8:	83 ec 10             	sub    $0x10,%esp
801045cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801045ce:	68 80 35 11 80       	push   $0x80113580
801045d3:	e8 68 04 00 00       	call   80104a40 <acquire>
801045d8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045db:	b8 b4 35 11 80       	mov    $0x801135b4,%eax
801045e0:	eb 10                	jmp    801045f2 <wakeup+0x32>
801045e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045e8:	83 c0 7c             	add    $0x7c,%eax
801045eb:	3d b4 54 11 80       	cmp    $0x801154b4,%eax
801045f0:	74 1c                	je     8010460e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
801045f2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045f6:	75 f0                	jne    801045e8 <wakeup+0x28>
801045f8:	3b 58 20             	cmp    0x20(%eax),%ebx
801045fb:	75 eb                	jne    801045e8 <wakeup+0x28>
      p->state = RUNNABLE;
801045fd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104604:	83 c0 7c             	add    $0x7c,%eax
80104607:	3d b4 54 11 80       	cmp    $0x801154b4,%eax
8010460c:	75 e4                	jne    801045f2 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010460e:	c7 45 08 80 35 11 80 	movl   $0x80113580,0x8(%ebp)
}
80104615:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104618:	c9                   	leave  
  release(&ptable.lock);
80104619:	e9 e2 04 00 00       	jmp    80104b00 <release>
8010461e:	66 90                	xchg   %ax,%ax

80104620 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104620:	f3 0f 1e fb          	endbr32 
80104624:	55                   	push   %ebp
80104625:	89 e5                	mov    %esp,%ebp
80104627:	53                   	push   %ebx
80104628:	83 ec 10             	sub    $0x10,%esp
8010462b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010462e:	68 80 35 11 80       	push   $0x80113580
80104633:	e8 08 04 00 00       	call   80104a40 <acquire>
80104638:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010463b:	b8 b4 35 11 80       	mov    $0x801135b4,%eax
80104640:	eb 10                	jmp    80104652 <kill+0x32>
80104642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104648:	83 c0 7c             	add    $0x7c,%eax
8010464b:	3d b4 54 11 80       	cmp    $0x801154b4,%eax
80104650:	74 36                	je     80104688 <kill+0x68>
    if(p->pid == pid){
80104652:	39 58 10             	cmp    %ebx,0x10(%eax)
80104655:	75 f1                	jne    80104648 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104657:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010465b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104662:	75 07                	jne    8010466b <kill+0x4b>
        p->state = RUNNABLE;
80104664:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010466b:	83 ec 0c             	sub    $0xc,%esp
8010466e:	68 80 35 11 80       	push   $0x80113580
80104673:	e8 88 04 00 00       	call   80104b00 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104678:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010467b:	83 c4 10             	add    $0x10,%esp
8010467e:	31 c0                	xor    %eax,%eax
}
80104680:	c9                   	leave  
80104681:	c3                   	ret    
80104682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104688:	83 ec 0c             	sub    $0xc,%esp
8010468b:	68 80 35 11 80       	push   $0x80113580
80104690:	e8 6b 04 00 00       	call   80104b00 <release>
}
80104695:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104698:	83 c4 10             	add    $0x10,%esp
8010469b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046a0:	c9                   	leave  
801046a1:	c3                   	ret    
801046a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046b0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801046b0:	f3 0f 1e fb          	endbr32 
801046b4:	55                   	push   %ebp
801046b5:	89 e5                	mov    %esp,%ebp
801046b7:	57                   	push   %edi
801046b8:	56                   	push   %esi
801046b9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801046bc:	53                   	push   %ebx
801046bd:	bb 20 36 11 80       	mov    $0x80113620,%ebx
801046c2:	83 ec 3c             	sub    $0x3c,%esp
801046c5:	eb 28                	jmp    801046ef <procdump+0x3f>
801046c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ce:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801046d0:	83 ec 0c             	sub    $0xc,%esp
801046d3:	68 17 7f 10 80       	push   $0x80107f17
801046d8:	e8 a3 c0 ff ff       	call   80100780 <cprintf>
801046dd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046e0:	83 c3 7c             	add    $0x7c,%ebx
801046e3:	81 fb 20 55 11 80    	cmp    $0x80115520,%ebx
801046e9:	0f 84 81 00 00 00    	je     80104770 <procdump+0xc0>
    if(p->state == UNUSED)
801046ef:	8b 43 a0             	mov    -0x60(%ebx),%eax
801046f2:	85 c0                	test   %eax,%eax
801046f4:	74 ea                	je     801046e0 <procdump+0x30>
      state = "???";
801046f6:	ba ab 7b 10 80       	mov    $0x80107bab,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046fb:	83 f8 05             	cmp    $0x5,%eax
801046fe:	77 11                	ja     80104711 <procdump+0x61>
80104700:	8b 14 85 0c 7c 10 80 	mov    -0x7fef83f4(,%eax,4),%edx
      state = "???";
80104707:	b8 ab 7b 10 80       	mov    $0x80107bab,%eax
8010470c:	85 d2                	test   %edx,%edx
8010470e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104711:	53                   	push   %ebx
80104712:	52                   	push   %edx
80104713:	ff 73 a4             	pushl  -0x5c(%ebx)
80104716:	68 af 7b 10 80       	push   $0x80107baf
8010471b:	e8 60 c0 ff ff       	call   80100780 <cprintf>
    if(p->state == SLEEPING){
80104720:	83 c4 10             	add    $0x10,%esp
80104723:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104727:	75 a7                	jne    801046d0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104729:	83 ec 08             	sub    $0x8,%esp
8010472c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010472f:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104732:	50                   	push   %eax
80104733:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104736:	8b 40 0c             	mov    0xc(%eax),%eax
80104739:	83 c0 08             	add    $0x8,%eax
8010473c:	50                   	push   %eax
8010473d:	e8 9e 01 00 00       	call   801048e0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104742:	83 c4 10             	add    $0x10,%esp
80104745:	8d 76 00             	lea    0x0(%esi),%esi
80104748:	8b 17                	mov    (%edi),%edx
8010474a:	85 d2                	test   %edx,%edx
8010474c:	74 82                	je     801046d0 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010474e:	83 ec 08             	sub    $0x8,%esp
80104751:	83 c7 04             	add    $0x4,%edi
80104754:	52                   	push   %edx
80104755:	68 01 76 10 80       	push   $0x80107601
8010475a:	e8 21 c0 ff ff       	call   80100780 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010475f:	83 c4 10             	add    $0x10,%esp
80104762:	39 fe                	cmp    %edi,%esi
80104764:	75 e2                	jne    80104748 <procdump+0x98>
80104766:	e9 65 ff ff ff       	jmp    801046d0 <procdump+0x20>
8010476b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010476f:	90                   	nop
  }
}
80104770:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104773:	5b                   	pop    %ebx
80104774:	5e                   	pop    %esi
80104775:	5f                   	pop    %edi
80104776:	5d                   	pop    %ebp
80104777:	c3                   	ret    
80104778:	66 90                	xchg   %ax,%ax
8010477a:	66 90                	xchg   %ax,%ax
8010477c:	66 90                	xchg   %ax,%ax
8010477e:	66 90                	xchg   %ax,%ax

80104780 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104780:	f3 0f 1e fb          	endbr32 
80104784:	55                   	push   %ebp
80104785:	89 e5                	mov    %esp,%ebp
80104787:	53                   	push   %ebx
80104788:	83 ec 0c             	sub    $0xc,%esp
8010478b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010478e:	68 24 7c 10 80       	push   $0x80107c24
80104793:	8d 43 04             	lea    0x4(%ebx),%eax
80104796:	50                   	push   %eax
80104797:	e8 24 01 00 00       	call   801048c0 <initlock>
  lk->name = name;
8010479c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010479f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801047a5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801047a8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801047af:	89 43 38             	mov    %eax,0x38(%ebx)
}
801047b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047b5:	c9                   	leave  
801047b6:	c3                   	ret    
801047b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047be:	66 90                	xchg   %ax,%ax

801047c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801047c0:	f3 0f 1e fb          	endbr32 
801047c4:	55                   	push   %ebp
801047c5:	89 e5                	mov    %esp,%ebp
801047c7:	56                   	push   %esi
801047c8:	53                   	push   %ebx
801047c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047cc:	8d 73 04             	lea    0x4(%ebx),%esi
801047cf:	83 ec 0c             	sub    $0xc,%esp
801047d2:	56                   	push   %esi
801047d3:	e8 68 02 00 00       	call   80104a40 <acquire>
  while (lk->locked) {
801047d8:	8b 13                	mov    (%ebx),%edx
801047da:	83 c4 10             	add    $0x10,%esp
801047dd:	85 d2                	test   %edx,%edx
801047df:	74 1a                	je     801047fb <acquiresleep+0x3b>
801047e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801047e8:	83 ec 08             	sub    $0x8,%esp
801047eb:	56                   	push   %esi
801047ec:	53                   	push   %ebx
801047ed:	e8 0e fc ff ff       	call   80104400 <sleep>
  while (lk->locked) {
801047f2:	8b 03                	mov    (%ebx),%eax
801047f4:	83 c4 10             	add    $0x10,%esp
801047f7:	85 c0                	test   %eax,%eax
801047f9:	75 ed                	jne    801047e8 <acquiresleep+0x28>
  }
  lk->locked = 1;
801047fb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104801:	e8 3a f6 ff ff       	call   80103e40 <myproc>
80104806:	8b 40 10             	mov    0x10(%eax),%eax
80104809:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010480c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010480f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104812:	5b                   	pop    %ebx
80104813:	5e                   	pop    %esi
80104814:	5d                   	pop    %ebp
  release(&lk->lk);
80104815:	e9 e6 02 00 00       	jmp    80104b00 <release>
8010481a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104820 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104820:	f3 0f 1e fb          	endbr32 
80104824:	55                   	push   %ebp
80104825:	89 e5                	mov    %esp,%ebp
80104827:	56                   	push   %esi
80104828:	53                   	push   %ebx
80104829:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010482c:	8d 73 04             	lea    0x4(%ebx),%esi
8010482f:	83 ec 0c             	sub    $0xc,%esp
80104832:	56                   	push   %esi
80104833:	e8 08 02 00 00       	call   80104a40 <acquire>
  lk->locked = 0;
80104838:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010483e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104845:	89 1c 24             	mov    %ebx,(%esp)
80104848:	e8 73 fd ff ff       	call   801045c0 <wakeup>
  release(&lk->lk);
8010484d:	89 75 08             	mov    %esi,0x8(%ebp)
80104850:	83 c4 10             	add    $0x10,%esp
}
80104853:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104856:	5b                   	pop    %ebx
80104857:	5e                   	pop    %esi
80104858:	5d                   	pop    %ebp
  release(&lk->lk);
80104859:	e9 a2 02 00 00       	jmp    80104b00 <release>
8010485e:	66 90                	xchg   %ax,%ax

80104860 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104860:	f3 0f 1e fb          	endbr32 
80104864:	55                   	push   %ebp
80104865:	89 e5                	mov    %esp,%ebp
80104867:	57                   	push   %edi
80104868:	31 ff                	xor    %edi,%edi
8010486a:	56                   	push   %esi
8010486b:	53                   	push   %ebx
8010486c:	83 ec 18             	sub    $0x18,%esp
8010486f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104872:	8d 73 04             	lea    0x4(%ebx),%esi
80104875:	56                   	push   %esi
80104876:	e8 c5 01 00 00       	call   80104a40 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010487b:	8b 03                	mov    (%ebx),%eax
8010487d:	83 c4 10             	add    $0x10,%esp
80104880:	85 c0                	test   %eax,%eax
80104882:	75 1c                	jne    801048a0 <holdingsleep+0x40>
  release(&lk->lk);
80104884:	83 ec 0c             	sub    $0xc,%esp
80104887:	56                   	push   %esi
80104888:	e8 73 02 00 00       	call   80104b00 <release>
  return r;
}
8010488d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104890:	89 f8                	mov    %edi,%eax
80104892:	5b                   	pop    %ebx
80104893:	5e                   	pop    %esi
80104894:	5f                   	pop    %edi
80104895:	5d                   	pop    %ebp
80104896:	c3                   	ret    
80104897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
801048a0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801048a3:	e8 98 f5 ff ff       	call   80103e40 <myproc>
801048a8:	39 58 10             	cmp    %ebx,0x10(%eax)
801048ab:	0f 94 c0             	sete   %al
801048ae:	0f b6 c0             	movzbl %al,%eax
801048b1:	89 c7                	mov    %eax,%edi
801048b3:	eb cf                	jmp    80104884 <holdingsleep+0x24>
801048b5:	66 90                	xchg   %ax,%ax
801048b7:	66 90                	xchg   %ax,%ax
801048b9:	66 90                	xchg   %ax,%ax
801048bb:	66 90                	xchg   %ax,%ax
801048bd:	66 90                	xchg   %ax,%ax
801048bf:	90                   	nop

801048c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801048c0:	f3 0f 1e fb          	endbr32 
801048c4:	55                   	push   %ebp
801048c5:	89 e5                	mov    %esp,%ebp
801048c7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801048ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801048cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801048d3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801048d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801048dd:	5d                   	pop    %ebp
801048de:	c3                   	ret    
801048df:	90                   	nop

801048e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801048e0:	f3 0f 1e fb          	endbr32 
801048e4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801048e5:	31 d2                	xor    %edx,%edx
{
801048e7:	89 e5                	mov    %esp,%ebp
801048e9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801048ea:	8b 45 08             	mov    0x8(%ebp),%eax
{
801048ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801048f0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801048f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048f7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048f8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801048fe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104904:	77 1a                	ja     80104920 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104906:	8b 58 04             	mov    0x4(%eax),%ebx
80104909:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010490c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010490f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104911:	83 fa 0a             	cmp    $0xa,%edx
80104914:	75 e2                	jne    801048f8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104916:	5b                   	pop    %ebx
80104917:	5d                   	pop    %ebp
80104918:	c3                   	ret    
80104919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104920:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104923:	8d 51 28             	lea    0x28(%ecx),%edx
80104926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104930:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104936:	83 c0 04             	add    $0x4,%eax
80104939:	39 d0                	cmp    %edx,%eax
8010493b:	75 f3                	jne    80104930 <getcallerpcs+0x50>
}
8010493d:	5b                   	pop    %ebx
8010493e:	5d                   	pop    %ebp
8010493f:	c3                   	ret    

80104940 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104940:	f3 0f 1e fb          	endbr32 
80104944:	55                   	push   %ebp
80104945:	89 e5                	mov    %esp,%ebp
80104947:	53                   	push   %ebx
80104948:	83 ec 04             	sub    $0x4,%esp
8010494b:	9c                   	pushf  
8010494c:	5b                   	pop    %ebx
  asm volatile("cli");
8010494d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010494e:	e8 5d f4 ff ff       	call   80103db0 <mycpu>
80104953:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104959:	85 c0                	test   %eax,%eax
8010495b:	74 13                	je     80104970 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010495d:	e8 4e f4 ff ff       	call   80103db0 <mycpu>
80104962:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104969:	83 c4 04             	add    $0x4,%esp
8010496c:	5b                   	pop    %ebx
8010496d:	5d                   	pop    %ebp
8010496e:	c3                   	ret    
8010496f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104970:	e8 3b f4 ff ff       	call   80103db0 <mycpu>
80104975:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010497b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104981:	eb da                	jmp    8010495d <pushcli+0x1d>
80104983:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104990 <popcli>:

void
popcli(void)
{
80104990:	f3 0f 1e fb          	endbr32 
80104994:	55                   	push   %ebp
80104995:	89 e5                	mov    %esp,%ebp
80104997:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010499a:	9c                   	pushf  
8010499b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010499c:	f6 c4 02             	test   $0x2,%ah
8010499f:	75 31                	jne    801049d2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801049a1:	e8 0a f4 ff ff       	call   80103db0 <mycpu>
801049a6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801049ad:	78 30                	js     801049df <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049af:	e8 fc f3 ff ff       	call   80103db0 <mycpu>
801049b4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801049ba:	85 d2                	test   %edx,%edx
801049bc:	74 02                	je     801049c0 <popcli+0x30>
    sti();
}
801049be:	c9                   	leave  
801049bf:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049c0:	e8 eb f3 ff ff       	call   80103db0 <mycpu>
801049c5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049cb:	85 c0                	test   %eax,%eax
801049cd:	74 ef                	je     801049be <popcli+0x2e>
  asm volatile("sti");
801049cf:	fb                   	sti    
}
801049d0:	c9                   	leave  
801049d1:	c3                   	ret    
    panic("popcli - interruptible");
801049d2:	83 ec 0c             	sub    $0xc,%esp
801049d5:	68 2f 7c 10 80       	push   $0x80107c2f
801049da:	e8 21 bd ff ff       	call   80100700 <panic>
    panic("popcli");
801049df:	83 ec 0c             	sub    $0xc,%esp
801049e2:	68 46 7c 10 80       	push   $0x80107c46
801049e7:	e8 14 bd ff ff       	call   80100700 <panic>
801049ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049f0 <holding>:
{
801049f0:	f3 0f 1e fb          	endbr32 
801049f4:	55                   	push   %ebp
801049f5:	89 e5                	mov    %esp,%ebp
801049f7:	56                   	push   %esi
801049f8:	53                   	push   %ebx
801049f9:	8b 75 08             	mov    0x8(%ebp),%esi
801049fc:	31 db                	xor    %ebx,%ebx
  pushcli();
801049fe:	e8 3d ff ff ff       	call   80104940 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a03:	8b 06                	mov    (%esi),%eax
80104a05:	85 c0                	test   %eax,%eax
80104a07:	75 0f                	jne    80104a18 <holding+0x28>
  popcli();
80104a09:	e8 82 ff ff ff       	call   80104990 <popcli>
}
80104a0e:	89 d8                	mov    %ebx,%eax
80104a10:	5b                   	pop    %ebx
80104a11:	5e                   	pop    %esi
80104a12:	5d                   	pop    %ebp
80104a13:	c3                   	ret    
80104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104a18:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a1b:	e8 90 f3 ff ff       	call   80103db0 <mycpu>
80104a20:	39 c3                	cmp    %eax,%ebx
80104a22:	0f 94 c3             	sete   %bl
  popcli();
80104a25:	e8 66 ff ff ff       	call   80104990 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104a2a:	0f b6 db             	movzbl %bl,%ebx
}
80104a2d:	89 d8                	mov    %ebx,%eax
80104a2f:	5b                   	pop    %ebx
80104a30:	5e                   	pop    %esi
80104a31:	5d                   	pop    %ebp
80104a32:	c3                   	ret    
80104a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a40 <acquire>:
{
80104a40:	f3 0f 1e fb          	endbr32 
80104a44:	55                   	push   %ebp
80104a45:	89 e5                	mov    %esp,%ebp
80104a47:	56                   	push   %esi
80104a48:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104a49:	e8 f2 fe ff ff       	call   80104940 <pushcli>
  if(holding(lk))
80104a4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a51:	83 ec 0c             	sub    $0xc,%esp
80104a54:	53                   	push   %ebx
80104a55:	e8 96 ff ff ff       	call   801049f0 <holding>
80104a5a:	83 c4 10             	add    $0x10,%esp
80104a5d:	85 c0                	test   %eax,%eax
80104a5f:	0f 85 7f 00 00 00    	jne    80104ae4 <acquire+0xa4>
80104a65:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104a67:	ba 01 00 00 00       	mov    $0x1,%edx
80104a6c:	eb 05                	jmp    80104a73 <acquire+0x33>
80104a6e:	66 90                	xchg   %ax,%ax
80104a70:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a73:	89 d0                	mov    %edx,%eax
80104a75:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104a78:	85 c0                	test   %eax,%eax
80104a7a:	75 f4                	jne    80104a70 <acquire+0x30>
  __sync_synchronize();
80104a7c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104a81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a84:	e8 27 f3 ff ff       	call   80103db0 <mycpu>
80104a89:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104a8c:	89 e8                	mov    %ebp,%eax
80104a8e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a90:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104a96:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104a9c:	77 22                	ja     80104ac0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104a9e:	8b 50 04             	mov    0x4(%eax),%edx
80104aa1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104aa5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104aa8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104aaa:	83 fe 0a             	cmp    $0xa,%esi
80104aad:	75 e1                	jne    80104a90 <acquire+0x50>
}
80104aaf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ab2:	5b                   	pop    %ebx
80104ab3:	5e                   	pop    %esi
80104ab4:	5d                   	pop    %ebp
80104ab5:	c3                   	ret    
80104ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104ac0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104ac4:	83 c3 34             	add    $0x34,%ebx
80104ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ace:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ad0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ad6:	83 c0 04             	add    $0x4,%eax
80104ad9:	39 d8                	cmp    %ebx,%eax
80104adb:	75 f3                	jne    80104ad0 <acquire+0x90>
}
80104add:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ae0:	5b                   	pop    %ebx
80104ae1:	5e                   	pop    %esi
80104ae2:	5d                   	pop    %ebp
80104ae3:	c3                   	ret    
    panic("acquire");
80104ae4:	83 ec 0c             	sub    $0xc,%esp
80104ae7:	68 4d 7c 10 80       	push   $0x80107c4d
80104aec:	e8 0f bc ff ff       	call   80100700 <panic>
80104af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aff:	90                   	nop

80104b00 <release>:
{
80104b00:	f3 0f 1e fb          	endbr32 
80104b04:	55                   	push   %ebp
80104b05:	89 e5                	mov    %esp,%ebp
80104b07:	53                   	push   %ebx
80104b08:	83 ec 10             	sub    $0x10,%esp
80104b0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104b0e:	53                   	push   %ebx
80104b0f:	e8 dc fe ff ff       	call   801049f0 <holding>
80104b14:	83 c4 10             	add    $0x10,%esp
80104b17:	85 c0                	test   %eax,%eax
80104b19:	74 22                	je     80104b3d <release+0x3d>
  lk->pcs[0] = 0;
80104b1b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104b22:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104b29:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104b2e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104b34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b37:	c9                   	leave  
  popcli();
80104b38:	e9 53 fe ff ff       	jmp    80104990 <popcli>
    panic("release");
80104b3d:	83 ec 0c             	sub    $0xc,%esp
80104b40:	68 55 7c 10 80       	push   $0x80107c55
80104b45:	e8 b6 bb ff ff       	call   80100700 <panic>
80104b4a:	66 90                	xchg   %ax,%ax
80104b4c:	66 90                	xchg   %ax,%ax
80104b4e:	66 90                	xchg   %ax,%ax

80104b50 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b50:	f3 0f 1e fb          	endbr32 
80104b54:	55                   	push   %ebp
80104b55:	89 e5                	mov    %esp,%ebp
80104b57:	57                   	push   %edi
80104b58:	8b 55 08             	mov    0x8(%ebp),%edx
80104b5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b5e:	53                   	push   %ebx
80104b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104b62:	89 d7                	mov    %edx,%edi
80104b64:	09 cf                	or     %ecx,%edi
80104b66:	83 e7 03             	and    $0x3,%edi
80104b69:	75 25                	jne    80104b90 <memset+0x40>
    c &= 0xFF;
80104b6b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104b6e:	c1 e0 18             	shl    $0x18,%eax
80104b71:	89 fb                	mov    %edi,%ebx
80104b73:	c1 e9 02             	shr    $0x2,%ecx
80104b76:	c1 e3 10             	shl    $0x10,%ebx
80104b79:	09 d8                	or     %ebx,%eax
80104b7b:	09 f8                	or     %edi,%eax
80104b7d:	c1 e7 08             	shl    $0x8,%edi
80104b80:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104b82:	89 d7                	mov    %edx,%edi
80104b84:	fc                   	cld    
80104b85:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104b87:	5b                   	pop    %ebx
80104b88:	89 d0                	mov    %edx,%eax
80104b8a:	5f                   	pop    %edi
80104b8b:	5d                   	pop    %ebp
80104b8c:	c3                   	ret    
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104b90:	89 d7                	mov    %edx,%edi
80104b92:	fc                   	cld    
80104b93:	f3 aa                	rep stos %al,%es:(%edi)
80104b95:	5b                   	pop    %ebx
80104b96:	89 d0                	mov    %edx,%eax
80104b98:	5f                   	pop    %edi
80104b99:	5d                   	pop    %ebp
80104b9a:	c3                   	ret    
80104b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b9f:	90                   	nop

80104ba0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ba0:	f3 0f 1e fb          	endbr32 
80104ba4:	55                   	push   %ebp
80104ba5:	89 e5                	mov    %esp,%ebp
80104ba7:	56                   	push   %esi
80104ba8:	8b 75 10             	mov    0x10(%ebp),%esi
80104bab:	8b 55 08             	mov    0x8(%ebp),%edx
80104bae:	53                   	push   %ebx
80104baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104bb2:	85 f6                	test   %esi,%esi
80104bb4:	74 2a                	je     80104be0 <memcmp+0x40>
80104bb6:	01 c6                	add    %eax,%esi
80104bb8:	eb 10                	jmp    80104bca <memcmp+0x2a>
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104bc0:	83 c0 01             	add    $0x1,%eax
80104bc3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104bc6:	39 f0                	cmp    %esi,%eax
80104bc8:	74 16                	je     80104be0 <memcmp+0x40>
    if(*s1 != *s2)
80104bca:	0f b6 0a             	movzbl (%edx),%ecx
80104bcd:	0f b6 18             	movzbl (%eax),%ebx
80104bd0:	38 d9                	cmp    %bl,%cl
80104bd2:	74 ec                	je     80104bc0 <memcmp+0x20>
      return *s1 - *s2;
80104bd4:	0f b6 c1             	movzbl %cl,%eax
80104bd7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104bd9:	5b                   	pop    %ebx
80104bda:	5e                   	pop    %esi
80104bdb:	5d                   	pop    %ebp
80104bdc:	c3                   	ret    
80104bdd:	8d 76 00             	lea    0x0(%esi),%esi
80104be0:	5b                   	pop    %ebx
  return 0;
80104be1:	31 c0                	xor    %eax,%eax
}
80104be3:	5e                   	pop    %esi
80104be4:	5d                   	pop    %ebp
80104be5:	c3                   	ret    
80104be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bed:	8d 76 00             	lea    0x0(%esi),%esi

80104bf0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104bf0:	f3 0f 1e fb          	endbr32 
80104bf4:	55                   	push   %ebp
80104bf5:	89 e5                	mov    %esp,%ebp
80104bf7:	57                   	push   %edi
80104bf8:	8b 55 08             	mov    0x8(%ebp),%edx
80104bfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104bfe:	56                   	push   %esi
80104bff:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104c02:	39 d6                	cmp    %edx,%esi
80104c04:	73 2a                	jae    80104c30 <memmove+0x40>
80104c06:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104c09:	39 fa                	cmp    %edi,%edx
80104c0b:	73 23                	jae    80104c30 <memmove+0x40>
80104c0d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104c10:	85 c9                	test   %ecx,%ecx
80104c12:	74 13                	je     80104c27 <memmove+0x37>
80104c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104c18:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104c1c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104c1f:	83 e8 01             	sub    $0x1,%eax
80104c22:	83 f8 ff             	cmp    $0xffffffff,%eax
80104c25:	75 f1                	jne    80104c18 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104c27:	5e                   	pop    %esi
80104c28:	89 d0                	mov    %edx,%eax
80104c2a:	5f                   	pop    %edi
80104c2b:	5d                   	pop    %ebp
80104c2c:	c3                   	ret    
80104c2d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104c30:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104c33:	89 d7                	mov    %edx,%edi
80104c35:	85 c9                	test   %ecx,%ecx
80104c37:	74 ee                	je     80104c27 <memmove+0x37>
80104c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104c40:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104c41:	39 f0                	cmp    %esi,%eax
80104c43:	75 fb                	jne    80104c40 <memmove+0x50>
}
80104c45:	5e                   	pop    %esi
80104c46:	89 d0                	mov    %edx,%eax
80104c48:	5f                   	pop    %edi
80104c49:	5d                   	pop    %ebp
80104c4a:	c3                   	ret    
80104c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c4f:	90                   	nop

80104c50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104c50:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104c54:	eb 9a                	jmp    80104bf0 <memmove>
80104c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi

80104c60 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104c60:	f3 0f 1e fb          	endbr32 
80104c64:	55                   	push   %ebp
80104c65:	89 e5                	mov    %esp,%ebp
80104c67:	56                   	push   %esi
80104c68:	8b 75 10             	mov    0x10(%ebp),%esi
80104c6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c6e:	53                   	push   %ebx
80104c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104c72:	85 f6                	test   %esi,%esi
80104c74:	74 32                	je     80104ca8 <strncmp+0x48>
80104c76:	01 c6                	add    %eax,%esi
80104c78:	eb 14                	jmp    80104c8e <strncmp+0x2e>
80104c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c80:	38 da                	cmp    %bl,%dl
80104c82:	75 14                	jne    80104c98 <strncmp+0x38>
    n--, p++, q++;
80104c84:	83 c0 01             	add    $0x1,%eax
80104c87:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104c8a:	39 f0                	cmp    %esi,%eax
80104c8c:	74 1a                	je     80104ca8 <strncmp+0x48>
80104c8e:	0f b6 11             	movzbl (%ecx),%edx
80104c91:	0f b6 18             	movzbl (%eax),%ebx
80104c94:	84 d2                	test   %dl,%dl
80104c96:	75 e8                	jne    80104c80 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104c98:	0f b6 c2             	movzbl %dl,%eax
80104c9b:	29 d8                	sub    %ebx,%eax
}
80104c9d:	5b                   	pop    %ebx
80104c9e:	5e                   	pop    %esi
80104c9f:	5d                   	pop    %ebp
80104ca0:	c3                   	ret    
80104ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ca8:	5b                   	pop    %ebx
    return 0;
80104ca9:	31 c0                	xor    %eax,%eax
}
80104cab:	5e                   	pop    %esi
80104cac:	5d                   	pop    %ebp
80104cad:	c3                   	ret    
80104cae:	66 90                	xchg   %ax,%ax

80104cb0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104cb0:	f3 0f 1e fb          	endbr32 
80104cb4:	55                   	push   %ebp
80104cb5:	89 e5                	mov    %esp,%ebp
80104cb7:	57                   	push   %edi
80104cb8:	56                   	push   %esi
80104cb9:	8b 75 08             	mov    0x8(%ebp),%esi
80104cbc:	53                   	push   %ebx
80104cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104cc0:	89 f2                	mov    %esi,%edx
80104cc2:	eb 1b                	jmp    80104cdf <strncpy+0x2f>
80104cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cc8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104ccc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104ccf:	83 c2 01             	add    $0x1,%edx
80104cd2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104cd6:	89 f9                	mov    %edi,%ecx
80104cd8:	88 4a ff             	mov    %cl,-0x1(%edx)
80104cdb:	84 c9                	test   %cl,%cl
80104cdd:	74 09                	je     80104ce8 <strncpy+0x38>
80104cdf:	89 c3                	mov    %eax,%ebx
80104ce1:	83 e8 01             	sub    $0x1,%eax
80104ce4:	85 db                	test   %ebx,%ebx
80104ce6:	7f e0                	jg     80104cc8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104ce8:	89 d1                	mov    %edx,%ecx
80104cea:	85 c0                	test   %eax,%eax
80104cec:	7e 15                	jle    80104d03 <strncpy+0x53>
80104cee:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104cf0:	83 c1 01             	add    $0x1,%ecx
80104cf3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104cf7:	89 c8                	mov    %ecx,%eax
80104cf9:	f7 d0                	not    %eax
80104cfb:	01 d0                	add    %edx,%eax
80104cfd:	01 d8                	add    %ebx,%eax
80104cff:	85 c0                	test   %eax,%eax
80104d01:	7f ed                	jg     80104cf0 <strncpy+0x40>
  return os;
}
80104d03:	5b                   	pop    %ebx
80104d04:	89 f0                	mov    %esi,%eax
80104d06:	5e                   	pop    %esi
80104d07:	5f                   	pop    %edi
80104d08:	5d                   	pop    %ebp
80104d09:	c3                   	ret    
80104d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d10:	f3 0f 1e fb          	endbr32 
80104d14:	55                   	push   %ebp
80104d15:	89 e5                	mov    %esp,%ebp
80104d17:	56                   	push   %esi
80104d18:	8b 55 10             	mov    0x10(%ebp),%edx
80104d1b:	8b 75 08             	mov    0x8(%ebp),%esi
80104d1e:	53                   	push   %ebx
80104d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104d22:	85 d2                	test   %edx,%edx
80104d24:	7e 21                	jle    80104d47 <safestrcpy+0x37>
80104d26:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104d2a:	89 f2                	mov    %esi,%edx
80104d2c:	eb 12                	jmp    80104d40 <safestrcpy+0x30>
80104d2e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d30:	0f b6 08             	movzbl (%eax),%ecx
80104d33:	83 c0 01             	add    $0x1,%eax
80104d36:	83 c2 01             	add    $0x1,%edx
80104d39:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d3c:	84 c9                	test   %cl,%cl
80104d3e:	74 04                	je     80104d44 <safestrcpy+0x34>
80104d40:	39 d8                	cmp    %ebx,%eax
80104d42:	75 ec                	jne    80104d30 <safestrcpy+0x20>
    ;
  *s = 0;
80104d44:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104d47:	89 f0                	mov    %esi,%eax
80104d49:	5b                   	pop    %ebx
80104d4a:	5e                   	pop    %esi
80104d4b:	5d                   	pop    %ebp
80104d4c:	c3                   	ret    
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi

80104d50 <strlen>:

int
strlen(const char *s)
{
80104d50:	f3 0f 1e fb          	endbr32 
80104d54:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d55:	31 c0                	xor    %eax,%eax
{
80104d57:	89 e5                	mov    %esp,%ebp
80104d59:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104d5c:	80 3a 00             	cmpb   $0x0,(%edx)
80104d5f:	74 10                	je     80104d71 <strlen+0x21>
80104d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d68:	83 c0 01             	add    $0x1,%eax
80104d6b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d6f:	75 f7                	jne    80104d68 <strlen+0x18>
    ;
  return n;
}
80104d71:	5d                   	pop    %ebp
80104d72:	c3                   	ret    

80104d73 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d73:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d77:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104d7b:	55                   	push   %ebp
  pushl %ebx
80104d7c:	53                   	push   %ebx
  pushl %esi
80104d7d:	56                   	push   %esi
  pushl %edi
80104d7e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104d7f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104d81:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104d83:	5f                   	pop    %edi
  popl %esi
80104d84:	5e                   	pop    %esi
  popl %ebx
80104d85:	5b                   	pop    %ebx
  popl %ebp
80104d86:	5d                   	pop    %ebp
  ret
80104d87:	c3                   	ret    
80104d88:	66 90                	xchg   %ax,%ax
80104d8a:	66 90                	xchg   %ax,%ax
80104d8c:	66 90                	xchg   %ax,%ax
80104d8e:	66 90                	xchg   %ax,%ax

80104d90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104d90:	f3 0f 1e fb          	endbr32 
80104d94:	55                   	push   %ebp
80104d95:	89 e5                	mov    %esp,%ebp
80104d97:	53                   	push   %ebx
80104d98:	83 ec 04             	sub    $0x4,%esp
80104d9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104d9e:	e8 9d f0 ff ff       	call   80103e40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104da3:	8b 00                	mov    (%eax),%eax
80104da5:	39 d8                	cmp    %ebx,%eax
80104da7:	76 17                	jbe    80104dc0 <fetchint+0x30>
80104da9:	8d 53 04             	lea    0x4(%ebx),%edx
80104dac:	39 d0                	cmp    %edx,%eax
80104dae:	72 10                	jb     80104dc0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104db0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104db3:	8b 13                	mov    (%ebx),%edx
80104db5:	89 10                	mov    %edx,(%eax)
  return 0;
80104db7:	31 c0                	xor    %eax,%eax
}
80104db9:	83 c4 04             	add    $0x4,%esp
80104dbc:	5b                   	pop    %ebx
80104dbd:	5d                   	pop    %ebp
80104dbe:	c3                   	ret    
80104dbf:	90                   	nop
    return -1;
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc5:	eb f2                	jmp    80104db9 <fetchint+0x29>
80104dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dce:	66 90                	xchg   %ax,%ax

80104dd0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104dd0:	f3 0f 1e fb          	endbr32 
80104dd4:	55                   	push   %ebp
80104dd5:	89 e5                	mov    %esp,%ebp
80104dd7:	53                   	push   %ebx
80104dd8:	83 ec 04             	sub    $0x4,%esp
80104ddb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104dde:	e8 5d f0 ff ff       	call   80103e40 <myproc>

  if(addr >= curproc->sz)
80104de3:	39 18                	cmp    %ebx,(%eax)
80104de5:	76 31                	jbe    80104e18 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104de7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dea:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104dec:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104dee:	39 d3                	cmp    %edx,%ebx
80104df0:	73 26                	jae    80104e18 <fetchstr+0x48>
80104df2:	89 d8                	mov    %ebx,%eax
80104df4:	eb 11                	jmp    80104e07 <fetchstr+0x37>
80104df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dfd:	8d 76 00             	lea    0x0(%esi),%esi
80104e00:	83 c0 01             	add    $0x1,%eax
80104e03:	39 c2                	cmp    %eax,%edx
80104e05:	76 11                	jbe    80104e18 <fetchstr+0x48>
    if(*s == 0)
80104e07:	80 38 00             	cmpb   $0x0,(%eax)
80104e0a:	75 f4                	jne    80104e00 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104e0c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104e0f:	29 d8                	sub    %ebx,%eax
}
80104e11:	5b                   	pop    %ebx
80104e12:	5d                   	pop    %ebp
80104e13:	c3                   	ret    
80104e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e18:	83 c4 04             	add    $0x4,%esp
    return -1;
80104e1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e20:	5b                   	pop    %ebx
80104e21:	5d                   	pop    %ebp
80104e22:	c3                   	ret    
80104e23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e30 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e30:	f3 0f 1e fb          	endbr32 
80104e34:	55                   	push   %ebp
80104e35:	89 e5                	mov    %esp,%ebp
80104e37:	56                   	push   %esi
80104e38:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e39:	e8 02 f0 ff ff       	call   80103e40 <myproc>
80104e3e:	8b 55 08             	mov    0x8(%ebp),%edx
80104e41:	8b 40 18             	mov    0x18(%eax),%eax
80104e44:	8b 40 44             	mov    0x44(%eax),%eax
80104e47:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104e4a:	e8 f1 ef ff ff       	call   80103e40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e4f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e52:	8b 00                	mov    (%eax),%eax
80104e54:	39 c6                	cmp    %eax,%esi
80104e56:	73 18                	jae    80104e70 <argint+0x40>
80104e58:	8d 53 08             	lea    0x8(%ebx),%edx
80104e5b:	39 d0                	cmp    %edx,%eax
80104e5d:	72 11                	jb     80104e70 <argint+0x40>
  *ip = *(int*)(addr);
80104e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e62:	8b 53 04             	mov    0x4(%ebx),%edx
80104e65:	89 10                	mov    %edx,(%eax)
  return 0;
80104e67:	31 c0                	xor    %eax,%eax
}
80104e69:	5b                   	pop    %ebx
80104e6a:	5e                   	pop    %esi
80104e6b:	5d                   	pop    %ebp
80104e6c:	c3                   	ret    
80104e6d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e75:	eb f2                	jmp    80104e69 <argint+0x39>
80104e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e7e:	66 90                	xchg   %ax,%ax

80104e80 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e80:	f3 0f 1e fb          	endbr32 
80104e84:	55                   	push   %ebp
80104e85:	89 e5                	mov    %esp,%ebp
80104e87:	56                   	push   %esi
80104e88:	53                   	push   %ebx
80104e89:	83 ec 10             	sub    $0x10,%esp
80104e8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104e8f:	e8 ac ef ff ff       	call   80103e40 <myproc>
 
  if(argint(n, &i) < 0)
80104e94:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104e97:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104e99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e9c:	50                   	push   %eax
80104e9d:	ff 75 08             	pushl  0x8(%ebp)
80104ea0:	e8 8b ff ff ff       	call   80104e30 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ea5:	83 c4 10             	add    $0x10,%esp
80104ea8:	85 c0                	test   %eax,%eax
80104eaa:	78 24                	js     80104ed0 <argptr+0x50>
80104eac:	85 db                	test   %ebx,%ebx
80104eae:	78 20                	js     80104ed0 <argptr+0x50>
80104eb0:	8b 16                	mov    (%esi),%edx
80104eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb5:	39 c2                	cmp    %eax,%edx
80104eb7:	76 17                	jbe    80104ed0 <argptr+0x50>
80104eb9:	01 c3                	add    %eax,%ebx
80104ebb:	39 da                	cmp    %ebx,%edx
80104ebd:	72 11                	jb     80104ed0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ec2:	89 02                	mov    %eax,(%edx)
  return 0;
80104ec4:	31 c0                	xor    %eax,%eax
}
80104ec6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ec9:	5b                   	pop    %ebx
80104eca:	5e                   	pop    %esi
80104ecb:	5d                   	pop    %ebp
80104ecc:	c3                   	ret    
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ed5:	eb ef                	jmp    80104ec6 <argptr+0x46>
80104ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ede:	66 90                	xchg   %ax,%ax

80104ee0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ee0:	f3 0f 1e fb          	endbr32 
80104ee4:	55                   	push   %ebp
80104ee5:	89 e5                	mov    %esp,%ebp
80104ee7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104eea:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eed:	50                   	push   %eax
80104eee:	ff 75 08             	pushl  0x8(%ebp)
80104ef1:	e8 3a ff ff ff       	call   80104e30 <argint>
80104ef6:	83 c4 10             	add    $0x10,%esp
80104ef9:	85 c0                	test   %eax,%eax
80104efb:	78 13                	js     80104f10 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104efd:	83 ec 08             	sub    $0x8,%esp
80104f00:	ff 75 0c             	pushl  0xc(%ebp)
80104f03:	ff 75 f4             	pushl  -0xc(%ebp)
80104f06:	e8 c5 fe ff ff       	call   80104dd0 <fetchstr>
80104f0b:	83 c4 10             	add    $0x10,%esp
}
80104f0e:	c9                   	leave  
80104f0f:	c3                   	ret    
80104f10:	c9                   	leave  
    return -1;
80104f11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f16:	c3                   	ret    
80104f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1e:	66 90                	xchg   %ax,%ax

80104f20 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104f20:	f3 0f 1e fb          	endbr32 
80104f24:	55                   	push   %ebp
80104f25:	89 e5                	mov    %esp,%ebp
80104f27:	53                   	push   %ebx
80104f28:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104f2b:	e8 10 ef ff ff       	call   80103e40 <myproc>
80104f30:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f32:	8b 40 18             	mov    0x18(%eax),%eax
80104f35:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f38:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f3b:	83 fa 14             	cmp    $0x14,%edx
80104f3e:	77 20                	ja     80104f60 <syscall+0x40>
80104f40:	8b 14 85 80 7c 10 80 	mov    -0x7fef8380(,%eax,4),%edx
80104f47:	85 d2                	test   %edx,%edx
80104f49:	74 15                	je     80104f60 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104f4b:	ff d2                	call   *%edx
80104f4d:	89 c2                	mov    %eax,%edx
80104f4f:	8b 43 18             	mov    0x18(%ebx),%eax
80104f52:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104f55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f58:	c9                   	leave  
80104f59:	c3                   	ret    
80104f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104f60:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104f61:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104f64:	50                   	push   %eax
80104f65:	ff 73 10             	pushl  0x10(%ebx)
80104f68:	68 5d 7c 10 80       	push   $0x80107c5d
80104f6d:	e8 0e b8 ff ff       	call   80100780 <cprintf>
    curproc->tf->eax = -1;
80104f72:	8b 43 18             	mov    0x18(%ebx),%eax
80104f75:	83 c4 10             	add    $0x10,%esp
80104f78:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104f7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f82:	c9                   	leave  
80104f83:	c3                   	ret    
80104f84:	66 90                	xchg   %ax,%ax
80104f86:	66 90                	xchg   %ax,%ax
80104f88:	66 90                	xchg   %ax,%ax
80104f8a:	66 90                	xchg   %ax,%ax
80104f8c:	66 90                	xchg   %ax,%ax
80104f8e:	66 90                	xchg   %ax,%ax

80104f90 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	57                   	push   %edi
80104f94:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104f95:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104f98:	53                   	push   %ebx
80104f99:	83 ec 34             	sub    $0x34,%esp
80104f9c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104f9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104fa2:	57                   	push   %edi
80104fa3:	50                   	push   %eax
{
80104fa4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104fa7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104faa:	e8 81 d5 ff ff       	call   80102530 <nameiparent>
80104faf:	83 c4 10             	add    $0x10,%esp
80104fb2:	85 c0                	test   %eax,%eax
80104fb4:	0f 84 46 01 00 00    	je     80105100 <create+0x170>
    return 0;
  ilock(dp);
80104fba:	83 ec 0c             	sub    $0xc,%esp
80104fbd:	89 c3                	mov    %eax,%ebx
80104fbf:	50                   	push   %eax
80104fc0:	e8 7b cc ff ff       	call   80101c40 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104fc5:	83 c4 0c             	add    $0xc,%esp
80104fc8:	6a 00                	push   $0x0
80104fca:	57                   	push   %edi
80104fcb:	53                   	push   %ebx
80104fcc:	e8 bf d1 ff ff       	call   80102190 <dirlookup>
80104fd1:	83 c4 10             	add    $0x10,%esp
80104fd4:	89 c6                	mov    %eax,%esi
80104fd6:	85 c0                	test   %eax,%eax
80104fd8:	74 56                	je     80105030 <create+0xa0>
    iunlockput(dp);
80104fda:	83 ec 0c             	sub    $0xc,%esp
80104fdd:	53                   	push   %ebx
80104fde:	e8 fd ce ff ff       	call   80101ee0 <iunlockput>
    ilock(ip);
80104fe3:	89 34 24             	mov    %esi,(%esp)
80104fe6:	e8 55 cc ff ff       	call   80101c40 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104feb:	83 c4 10             	add    $0x10,%esp
80104fee:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104ff3:	75 1b                	jne    80105010 <create+0x80>
80104ff5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104ffa:	75 14                	jne    80105010 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fff:	89 f0                	mov    %esi,%eax
80105001:	5b                   	pop    %ebx
80105002:	5e                   	pop    %esi
80105003:	5f                   	pop    %edi
80105004:	5d                   	pop    %ebp
80105005:	c3                   	ret    
80105006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010500d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105010:	83 ec 0c             	sub    $0xc,%esp
80105013:	56                   	push   %esi
    return 0;
80105014:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105016:	e8 c5 ce ff ff       	call   80101ee0 <iunlockput>
    return 0;
8010501b:	83 c4 10             	add    $0x10,%esp
}
8010501e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105021:	89 f0                	mov    %esi,%eax
80105023:	5b                   	pop    %ebx
80105024:	5e                   	pop    %esi
80105025:	5f                   	pop    %edi
80105026:	5d                   	pop    %ebp
80105027:	c3                   	ret    
80105028:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010502f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105030:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105034:	83 ec 08             	sub    $0x8,%esp
80105037:	50                   	push   %eax
80105038:	ff 33                	pushl  (%ebx)
8010503a:	e8 81 ca ff ff       	call   80101ac0 <ialloc>
8010503f:	83 c4 10             	add    $0x10,%esp
80105042:	89 c6                	mov    %eax,%esi
80105044:	85 c0                	test   %eax,%eax
80105046:	0f 84 cd 00 00 00    	je     80105119 <create+0x189>
  ilock(ip);
8010504c:	83 ec 0c             	sub    $0xc,%esp
8010504f:	50                   	push   %eax
80105050:	e8 eb cb ff ff       	call   80101c40 <ilock>
  ip->major = major;
80105055:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105059:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010505d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105061:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105065:	b8 01 00 00 00       	mov    $0x1,%eax
8010506a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010506e:	89 34 24             	mov    %esi,(%esp)
80105071:	e8 0a cb ff ff       	call   80101b80 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105076:	83 c4 10             	add    $0x10,%esp
80105079:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010507e:	74 30                	je     801050b0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105080:	83 ec 04             	sub    $0x4,%esp
80105083:	ff 76 04             	pushl  0x4(%esi)
80105086:	57                   	push   %edi
80105087:	53                   	push   %ebx
80105088:	e8 c3 d3 ff ff       	call   80102450 <dirlink>
8010508d:	83 c4 10             	add    $0x10,%esp
80105090:	85 c0                	test   %eax,%eax
80105092:	78 78                	js     8010510c <create+0x17c>
  iunlockput(dp);
80105094:	83 ec 0c             	sub    $0xc,%esp
80105097:	53                   	push   %ebx
80105098:	e8 43 ce ff ff       	call   80101ee0 <iunlockput>
  return ip;
8010509d:	83 c4 10             	add    $0x10,%esp
}
801050a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050a3:	89 f0                	mov    %esi,%eax
801050a5:	5b                   	pop    %ebx
801050a6:	5e                   	pop    %esi
801050a7:	5f                   	pop    %edi
801050a8:	5d                   	pop    %ebp
801050a9:	c3                   	ret    
801050aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801050b0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801050b3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801050b8:	53                   	push   %ebx
801050b9:	e8 c2 ca ff ff       	call   80101b80 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801050be:	83 c4 0c             	add    $0xc,%esp
801050c1:	ff 76 04             	pushl  0x4(%esi)
801050c4:	68 f4 7c 10 80       	push   $0x80107cf4
801050c9:	56                   	push   %esi
801050ca:	e8 81 d3 ff ff       	call   80102450 <dirlink>
801050cf:	83 c4 10             	add    $0x10,%esp
801050d2:	85 c0                	test   %eax,%eax
801050d4:	78 18                	js     801050ee <create+0x15e>
801050d6:	83 ec 04             	sub    $0x4,%esp
801050d9:	ff 73 04             	pushl  0x4(%ebx)
801050dc:	68 f3 7c 10 80       	push   $0x80107cf3
801050e1:	56                   	push   %esi
801050e2:	e8 69 d3 ff ff       	call   80102450 <dirlink>
801050e7:	83 c4 10             	add    $0x10,%esp
801050ea:	85 c0                	test   %eax,%eax
801050ec:	79 92                	jns    80105080 <create+0xf0>
      panic("create dots");
801050ee:	83 ec 0c             	sub    $0xc,%esp
801050f1:	68 e7 7c 10 80       	push   $0x80107ce7
801050f6:	e8 05 b6 ff ff       	call   80100700 <panic>
801050fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050ff:	90                   	nop
}
80105100:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105103:	31 f6                	xor    %esi,%esi
}
80105105:	5b                   	pop    %ebx
80105106:	89 f0                	mov    %esi,%eax
80105108:	5e                   	pop    %esi
80105109:	5f                   	pop    %edi
8010510a:	5d                   	pop    %ebp
8010510b:	c3                   	ret    
    panic("create: dirlink");
8010510c:	83 ec 0c             	sub    $0xc,%esp
8010510f:	68 f6 7c 10 80       	push   $0x80107cf6
80105114:	e8 e7 b5 ff ff       	call   80100700 <panic>
    panic("create: ialloc");
80105119:	83 ec 0c             	sub    $0xc,%esp
8010511c:	68 d8 7c 10 80       	push   $0x80107cd8
80105121:	e8 da b5 ff ff       	call   80100700 <panic>
80105126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010512d:	8d 76 00             	lea    0x0(%esi),%esi

80105130 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	56                   	push   %esi
80105134:	89 d6                	mov    %edx,%esi
80105136:	53                   	push   %ebx
80105137:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105139:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010513c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010513f:	50                   	push   %eax
80105140:	6a 00                	push   $0x0
80105142:	e8 e9 fc ff ff       	call   80104e30 <argint>
80105147:	83 c4 10             	add    $0x10,%esp
8010514a:	85 c0                	test   %eax,%eax
8010514c:	78 2a                	js     80105178 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010514e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105152:	77 24                	ja     80105178 <argfd.constprop.0+0x48>
80105154:	e8 e7 ec ff ff       	call   80103e40 <myproc>
80105159:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010515c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105160:	85 c0                	test   %eax,%eax
80105162:	74 14                	je     80105178 <argfd.constprop.0+0x48>
  if(pfd)
80105164:	85 db                	test   %ebx,%ebx
80105166:	74 02                	je     8010516a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105168:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010516a:	89 06                	mov    %eax,(%esi)
  return 0;
8010516c:	31 c0                	xor    %eax,%eax
}
8010516e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105171:	5b                   	pop    %ebx
80105172:	5e                   	pop    %esi
80105173:	5d                   	pop    %ebp
80105174:	c3                   	ret    
80105175:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010517d:	eb ef                	jmp    8010516e <argfd.constprop.0+0x3e>
8010517f:	90                   	nop

80105180 <sys_dup>:
{
80105180:	f3 0f 1e fb          	endbr32 
80105184:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105185:	31 c0                	xor    %eax,%eax
{
80105187:	89 e5                	mov    %esp,%ebp
80105189:	56                   	push   %esi
8010518a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010518b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010518e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105191:	e8 9a ff ff ff       	call   80105130 <argfd.constprop.0>
80105196:	85 c0                	test   %eax,%eax
80105198:	78 1e                	js     801051b8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010519a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010519d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010519f:	e8 9c ec ff ff       	call   80103e40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801051a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801051a8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051ac:	85 d2                	test   %edx,%edx
801051ae:	74 20                	je     801051d0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801051b0:	83 c3 01             	add    $0x1,%ebx
801051b3:	83 fb 10             	cmp    $0x10,%ebx
801051b6:	75 f0                	jne    801051a8 <sys_dup+0x28>
}
801051b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801051bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801051c0:	89 d8                	mov    %ebx,%eax
801051c2:	5b                   	pop    %ebx
801051c3:	5e                   	pop    %esi
801051c4:	5d                   	pop    %ebp
801051c5:	c3                   	ret    
801051c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801051d0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801051d4:	83 ec 0c             	sub    $0xc,%esp
801051d7:	ff 75 f4             	pushl  -0xc(%ebp)
801051da:	e8 71 c1 ff ff       	call   80101350 <filedup>
  return fd;
801051df:	83 c4 10             	add    $0x10,%esp
}
801051e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051e5:	89 d8                	mov    %ebx,%eax
801051e7:	5b                   	pop    %ebx
801051e8:	5e                   	pop    %esi
801051e9:	5d                   	pop    %ebp
801051ea:	c3                   	ret    
801051eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051ef:	90                   	nop

801051f0 <sys_read>:
{
801051f0:	f3 0f 1e fb          	endbr32 
801051f4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051f5:	31 c0                	xor    %eax,%eax
{
801051f7:	89 e5                	mov    %esp,%ebp
801051f9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051fc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051ff:	e8 2c ff ff ff       	call   80105130 <argfd.constprop.0>
80105204:	85 c0                	test   %eax,%eax
80105206:	78 48                	js     80105250 <sys_read+0x60>
80105208:	83 ec 08             	sub    $0x8,%esp
8010520b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010520e:	50                   	push   %eax
8010520f:	6a 02                	push   $0x2
80105211:	e8 1a fc ff ff       	call   80104e30 <argint>
80105216:	83 c4 10             	add    $0x10,%esp
80105219:	85 c0                	test   %eax,%eax
8010521b:	78 33                	js     80105250 <sys_read+0x60>
8010521d:	83 ec 04             	sub    $0x4,%esp
80105220:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105223:	ff 75 f0             	pushl  -0x10(%ebp)
80105226:	50                   	push   %eax
80105227:	6a 01                	push   $0x1
80105229:	e8 52 fc ff ff       	call   80104e80 <argptr>
8010522e:	83 c4 10             	add    $0x10,%esp
80105231:	85 c0                	test   %eax,%eax
80105233:	78 1b                	js     80105250 <sys_read+0x60>
  return fileread(f, p, n);
80105235:	83 ec 04             	sub    $0x4,%esp
80105238:	ff 75 f0             	pushl  -0x10(%ebp)
8010523b:	ff 75 f4             	pushl  -0xc(%ebp)
8010523e:	ff 75 ec             	pushl  -0x14(%ebp)
80105241:	e8 8a c2 ff ff       	call   801014d0 <fileread>
80105246:	83 c4 10             	add    $0x10,%esp
}
80105249:	c9                   	leave  
8010524a:	c3                   	ret    
8010524b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010524f:	90                   	nop
80105250:	c9                   	leave  
    return -1;
80105251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105256:	c3                   	ret    
80105257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010525e:	66 90                	xchg   %ax,%ax

80105260 <sys_write>:
{
80105260:	f3 0f 1e fb          	endbr32 
80105264:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105265:	31 c0                	xor    %eax,%eax
{
80105267:	89 e5                	mov    %esp,%ebp
80105269:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010526c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010526f:	e8 bc fe ff ff       	call   80105130 <argfd.constprop.0>
80105274:	85 c0                	test   %eax,%eax
80105276:	78 48                	js     801052c0 <sys_write+0x60>
80105278:	83 ec 08             	sub    $0x8,%esp
8010527b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010527e:	50                   	push   %eax
8010527f:	6a 02                	push   $0x2
80105281:	e8 aa fb ff ff       	call   80104e30 <argint>
80105286:	83 c4 10             	add    $0x10,%esp
80105289:	85 c0                	test   %eax,%eax
8010528b:	78 33                	js     801052c0 <sys_write+0x60>
8010528d:	83 ec 04             	sub    $0x4,%esp
80105290:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105293:	ff 75 f0             	pushl  -0x10(%ebp)
80105296:	50                   	push   %eax
80105297:	6a 01                	push   $0x1
80105299:	e8 e2 fb ff ff       	call   80104e80 <argptr>
8010529e:	83 c4 10             	add    $0x10,%esp
801052a1:	85 c0                	test   %eax,%eax
801052a3:	78 1b                	js     801052c0 <sys_write+0x60>
  return filewrite(f, p, n);
801052a5:	83 ec 04             	sub    $0x4,%esp
801052a8:	ff 75 f0             	pushl  -0x10(%ebp)
801052ab:	ff 75 f4             	pushl  -0xc(%ebp)
801052ae:	ff 75 ec             	pushl  -0x14(%ebp)
801052b1:	e8 ba c2 ff ff       	call   80101570 <filewrite>
801052b6:	83 c4 10             	add    $0x10,%esp
}
801052b9:	c9                   	leave  
801052ba:	c3                   	ret    
801052bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052bf:	90                   	nop
801052c0:	c9                   	leave  
    return -1;
801052c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052c6:	c3                   	ret    
801052c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ce:	66 90                	xchg   %ax,%ax

801052d0 <sys_close>:
{
801052d0:	f3 0f 1e fb          	endbr32 
801052d4:	55                   	push   %ebp
801052d5:	89 e5                	mov    %esp,%ebp
801052d7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801052da:	8d 55 f4             	lea    -0xc(%ebp),%edx
801052dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052e0:	e8 4b fe ff ff       	call   80105130 <argfd.constprop.0>
801052e5:	85 c0                	test   %eax,%eax
801052e7:	78 27                	js     80105310 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801052e9:	e8 52 eb ff ff       	call   80103e40 <myproc>
801052ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801052f1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801052f4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801052fb:	00 
  fileclose(f);
801052fc:	ff 75 f4             	pushl  -0xc(%ebp)
801052ff:	e8 9c c0 ff ff       	call   801013a0 <fileclose>
  return 0;
80105304:	83 c4 10             	add    $0x10,%esp
80105307:	31 c0                	xor    %eax,%eax
}
80105309:	c9                   	leave  
8010530a:	c3                   	ret    
8010530b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010530f:	90                   	nop
80105310:	c9                   	leave  
    return -1;
80105311:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105316:	c3                   	ret    
80105317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010531e:	66 90                	xchg   %ax,%ax

80105320 <sys_fstat>:
{
80105320:	f3 0f 1e fb          	endbr32 
80105324:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105325:	31 c0                	xor    %eax,%eax
{
80105327:	89 e5                	mov    %esp,%ebp
80105329:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010532c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010532f:	e8 fc fd ff ff       	call   80105130 <argfd.constprop.0>
80105334:	85 c0                	test   %eax,%eax
80105336:	78 30                	js     80105368 <sys_fstat+0x48>
80105338:	83 ec 04             	sub    $0x4,%esp
8010533b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010533e:	6a 14                	push   $0x14
80105340:	50                   	push   %eax
80105341:	6a 01                	push   $0x1
80105343:	e8 38 fb ff ff       	call   80104e80 <argptr>
80105348:	83 c4 10             	add    $0x10,%esp
8010534b:	85 c0                	test   %eax,%eax
8010534d:	78 19                	js     80105368 <sys_fstat+0x48>
  return filestat(f, st);
8010534f:	83 ec 08             	sub    $0x8,%esp
80105352:	ff 75 f4             	pushl  -0xc(%ebp)
80105355:	ff 75 f0             	pushl  -0x10(%ebp)
80105358:	e8 23 c1 ff ff       	call   80101480 <filestat>
8010535d:	83 c4 10             	add    $0x10,%esp
}
80105360:	c9                   	leave  
80105361:	c3                   	ret    
80105362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105368:	c9                   	leave  
    return -1;
80105369:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010536e:	c3                   	ret    
8010536f:	90                   	nop

80105370 <sys_link>:
{
80105370:	f3 0f 1e fb          	endbr32 
80105374:	55                   	push   %ebp
80105375:	89 e5                	mov    %esp,%ebp
80105377:	57                   	push   %edi
80105378:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105379:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010537c:	53                   	push   %ebx
8010537d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105380:	50                   	push   %eax
80105381:	6a 00                	push   $0x0
80105383:	e8 58 fb ff ff       	call   80104ee0 <argstr>
80105388:	83 c4 10             	add    $0x10,%esp
8010538b:	85 c0                	test   %eax,%eax
8010538d:	0f 88 ff 00 00 00    	js     80105492 <sys_link+0x122>
80105393:	83 ec 08             	sub    $0x8,%esp
80105396:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105399:	50                   	push   %eax
8010539a:	6a 01                	push   $0x1
8010539c:	e8 3f fb ff ff       	call   80104ee0 <argstr>
801053a1:	83 c4 10             	add    $0x10,%esp
801053a4:	85 c0                	test   %eax,%eax
801053a6:	0f 88 e6 00 00 00    	js     80105492 <sys_link+0x122>
  begin_op();
801053ac:	e8 5f de ff ff       	call   80103210 <begin_op>
  if((ip = namei(old)) == 0){
801053b1:	83 ec 0c             	sub    $0xc,%esp
801053b4:	ff 75 d4             	pushl  -0x2c(%ebp)
801053b7:	e8 54 d1 ff ff       	call   80102510 <namei>
801053bc:	83 c4 10             	add    $0x10,%esp
801053bf:	89 c3                	mov    %eax,%ebx
801053c1:	85 c0                	test   %eax,%eax
801053c3:	0f 84 e8 00 00 00    	je     801054b1 <sys_link+0x141>
  ilock(ip);
801053c9:	83 ec 0c             	sub    $0xc,%esp
801053cc:	50                   	push   %eax
801053cd:	e8 6e c8 ff ff       	call   80101c40 <ilock>
  if(ip->type == T_DIR){
801053d2:	83 c4 10             	add    $0x10,%esp
801053d5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053da:	0f 84 b9 00 00 00    	je     80105499 <sys_link+0x129>
  iupdate(ip);
801053e0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801053e3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801053e8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801053eb:	53                   	push   %ebx
801053ec:	e8 8f c7 ff ff       	call   80101b80 <iupdate>
  iunlock(ip);
801053f1:	89 1c 24             	mov    %ebx,(%esp)
801053f4:	e8 27 c9 ff ff       	call   80101d20 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801053f9:	58                   	pop    %eax
801053fa:	5a                   	pop    %edx
801053fb:	57                   	push   %edi
801053fc:	ff 75 d0             	pushl  -0x30(%ebp)
801053ff:	e8 2c d1 ff ff       	call   80102530 <nameiparent>
80105404:	83 c4 10             	add    $0x10,%esp
80105407:	89 c6                	mov    %eax,%esi
80105409:	85 c0                	test   %eax,%eax
8010540b:	74 5f                	je     8010546c <sys_link+0xfc>
  ilock(dp);
8010540d:	83 ec 0c             	sub    $0xc,%esp
80105410:	50                   	push   %eax
80105411:	e8 2a c8 ff ff       	call   80101c40 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105416:	8b 03                	mov    (%ebx),%eax
80105418:	83 c4 10             	add    $0x10,%esp
8010541b:	39 06                	cmp    %eax,(%esi)
8010541d:	75 41                	jne    80105460 <sys_link+0xf0>
8010541f:	83 ec 04             	sub    $0x4,%esp
80105422:	ff 73 04             	pushl  0x4(%ebx)
80105425:	57                   	push   %edi
80105426:	56                   	push   %esi
80105427:	e8 24 d0 ff ff       	call   80102450 <dirlink>
8010542c:	83 c4 10             	add    $0x10,%esp
8010542f:	85 c0                	test   %eax,%eax
80105431:	78 2d                	js     80105460 <sys_link+0xf0>
  iunlockput(dp);
80105433:	83 ec 0c             	sub    $0xc,%esp
80105436:	56                   	push   %esi
80105437:	e8 a4 ca ff ff       	call   80101ee0 <iunlockput>
  iput(ip);
8010543c:	89 1c 24             	mov    %ebx,(%esp)
8010543f:	e8 2c c9 ff ff       	call   80101d70 <iput>
  end_op();
80105444:	e8 37 de ff ff       	call   80103280 <end_op>
  return 0;
80105449:	83 c4 10             	add    $0x10,%esp
8010544c:	31 c0                	xor    %eax,%eax
}
8010544e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105451:	5b                   	pop    %ebx
80105452:	5e                   	pop    %esi
80105453:	5f                   	pop    %edi
80105454:	5d                   	pop    %ebp
80105455:	c3                   	ret    
80105456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010545d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105460:	83 ec 0c             	sub    $0xc,%esp
80105463:	56                   	push   %esi
80105464:	e8 77 ca ff ff       	call   80101ee0 <iunlockput>
    goto bad;
80105469:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010546c:	83 ec 0c             	sub    $0xc,%esp
8010546f:	53                   	push   %ebx
80105470:	e8 cb c7 ff ff       	call   80101c40 <ilock>
  ip->nlink--;
80105475:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010547a:	89 1c 24             	mov    %ebx,(%esp)
8010547d:	e8 fe c6 ff ff       	call   80101b80 <iupdate>
  iunlockput(ip);
80105482:	89 1c 24             	mov    %ebx,(%esp)
80105485:	e8 56 ca ff ff       	call   80101ee0 <iunlockput>
  end_op();
8010548a:	e8 f1 dd ff ff       	call   80103280 <end_op>
  return -1;
8010548f:	83 c4 10             	add    $0x10,%esp
80105492:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105497:	eb b5                	jmp    8010544e <sys_link+0xde>
    iunlockput(ip);
80105499:	83 ec 0c             	sub    $0xc,%esp
8010549c:	53                   	push   %ebx
8010549d:	e8 3e ca ff ff       	call   80101ee0 <iunlockput>
    end_op();
801054a2:	e8 d9 dd ff ff       	call   80103280 <end_op>
    return -1;
801054a7:	83 c4 10             	add    $0x10,%esp
801054aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054af:	eb 9d                	jmp    8010544e <sys_link+0xde>
    end_op();
801054b1:	e8 ca dd ff ff       	call   80103280 <end_op>
    return -1;
801054b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054bb:	eb 91                	jmp    8010544e <sys_link+0xde>
801054bd:	8d 76 00             	lea    0x0(%esi),%esi

801054c0 <sys_unlink>:
{
801054c0:	f3 0f 1e fb          	endbr32 
801054c4:	55                   	push   %ebp
801054c5:	89 e5                	mov    %esp,%ebp
801054c7:	57                   	push   %edi
801054c8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801054c9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801054cc:	53                   	push   %ebx
801054cd:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801054d0:	50                   	push   %eax
801054d1:	6a 00                	push   $0x0
801054d3:	e8 08 fa ff ff       	call   80104ee0 <argstr>
801054d8:	83 c4 10             	add    $0x10,%esp
801054db:	85 c0                	test   %eax,%eax
801054dd:	0f 88 7d 01 00 00    	js     80105660 <sys_unlink+0x1a0>
  begin_op();
801054e3:	e8 28 dd ff ff       	call   80103210 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801054e8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801054eb:	83 ec 08             	sub    $0x8,%esp
801054ee:	53                   	push   %ebx
801054ef:	ff 75 c0             	pushl  -0x40(%ebp)
801054f2:	e8 39 d0 ff ff       	call   80102530 <nameiparent>
801054f7:	83 c4 10             	add    $0x10,%esp
801054fa:	89 c6                	mov    %eax,%esi
801054fc:	85 c0                	test   %eax,%eax
801054fe:	0f 84 66 01 00 00    	je     8010566a <sys_unlink+0x1aa>
  ilock(dp);
80105504:	83 ec 0c             	sub    $0xc,%esp
80105507:	50                   	push   %eax
80105508:	e8 33 c7 ff ff       	call   80101c40 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010550d:	58                   	pop    %eax
8010550e:	5a                   	pop    %edx
8010550f:	68 f4 7c 10 80       	push   $0x80107cf4
80105514:	53                   	push   %ebx
80105515:	e8 56 cc ff ff       	call   80102170 <namecmp>
8010551a:	83 c4 10             	add    $0x10,%esp
8010551d:	85 c0                	test   %eax,%eax
8010551f:	0f 84 03 01 00 00    	je     80105628 <sys_unlink+0x168>
80105525:	83 ec 08             	sub    $0x8,%esp
80105528:	68 f3 7c 10 80       	push   $0x80107cf3
8010552d:	53                   	push   %ebx
8010552e:	e8 3d cc ff ff       	call   80102170 <namecmp>
80105533:	83 c4 10             	add    $0x10,%esp
80105536:	85 c0                	test   %eax,%eax
80105538:	0f 84 ea 00 00 00    	je     80105628 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010553e:	83 ec 04             	sub    $0x4,%esp
80105541:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105544:	50                   	push   %eax
80105545:	53                   	push   %ebx
80105546:	56                   	push   %esi
80105547:	e8 44 cc ff ff       	call   80102190 <dirlookup>
8010554c:	83 c4 10             	add    $0x10,%esp
8010554f:	89 c3                	mov    %eax,%ebx
80105551:	85 c0                	test   %eax,%eax
80105553:	0f 84 cf 00 00 00    	je     80105628 <sys_unlink+0x168>
  ilock(ip);
80105559:	83 ec 0c             	sub    $0xc,%esp
8010555c:	50                   	push   %eax
8010555d:	e8 de c6 ff ff       	call   80101c40 <ilock>
  if(ip->nlink < 1)
80105562:	83 c4 10             	add    $0x10,%esp
80105565:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010556a:	0f 8e 23 01 00 00    	jle    80105693 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105570:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105575:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105578:	74 66                	je     801055e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010557a:	83 ec 04             	sub    $0x4,%esp
8010557d:	6a 10                	push   $0x10
8010557f:	6a 00                	push   $0x0
80105581:	57                   	push   %edi
80105582:	e8 c9 f5 ff ff       	call   80104b50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105587:	6a 10                	push   $0x10
80105589:	ff 75 c4             	pushl  -0x3c(%ebp)
8010558c:	57                   	push   %edi
8010558d:	56                   	push   %esi
8010558e:	e8 ad ca ff ff       	call   80102040 <writei>
80105593:	83 c4 20             	add    $0x20,%esp
80105596:	83 f8 10             	cmp    $0x10,%eax
80105599:	0f 85 e7 00 00 00    	jne    80105686 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010559f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055a4:	0f 84 96 00 00 00    	je     80105640 <sys_unlink+0x180>
  iunlockput(dp);
801055aa:	83 ec 0c             	sub    $0xc,%esp
801055ad:	56                   	push   %esi
801055ae:	e8 2d c9 ff ff       	call   80101ee0 <iunlockput>
  ip->nlink--;
801055b3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055b8:	89 1c 24             	mov    %ebx,(%esp)
801055bb:	e8 c0 c5 ff ff       	call   80101b80 <iupdate>
  iunlockput(ip);
801055c0:	89 1c 24             	mov    %ebx,(%esp)
801055c3:	e8 18 c9 ff ff       	call   80101ee0 <iunlockput>
  end_op();
801055c8:	e8 b3 dc ff ff       	call   80103280 <end_op>
  return 0;
801055cd:	83 c4 10             	add    $0x10,%esp
801055d0:	31 c0                	xor    %eax,%eax
}
801055d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055d5:	5b                   	pop    %ebx
801055d6:	5e                   	pop    %esi
801055d7:	5f                   	pop    %edi
801055d8:	5d                   	pop    %ebp
801055d9:	c3                   	ret    
801055da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801055e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801055e4:	76 94                	jbe    8010557a <sys_unlink+0xba>
801055e6:	ba 20 00 00 00       	mov    $0x20,%edx
801055eb:	eb 0b                	jmp    801055f8 <sys_unlink+0x138>
801055ed:	8d 76 00             	lea    0x0(%esi),%esi
801055f0:	83 c2 10             	add    $0x10,%edx
801055f3:	39 53 58             	cmp    %edx,0x58(%ebx)
801055f6:	76 82                	jbe    8010557a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055f8:	6a 10                	push   $0x10
801055fa:	52                   	push   %edx
801055fb:	57                   	push   %edi
801055fc:	53                   	push   %ebx
801055fd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105600:	e8 3b c9 ff ff       	call   80101f40 <readi>
80105605:	83 c4 10             	add    $0x10,%esp
80105608:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010560b:	83 f8 10             	cmp    $0x10,%eax
8010560e:	75 69                	jne    80105679 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105610:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105615:	74 d9                	je     801055f0 <sys_unlink+0x130>
    iunlockput(ip);
80105617:	83 ec 0c             	sub    $0xc,%esp
8010561a:	53                   	push   %ebx
8010561b:	e8 c0 c8 ff ff       	call   80101ee0 <iunlockput>
    goto bad;
80105620:	83 c4 10             	add    $0x10,%esp
80105623:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105627:	90                   	nop
  iunlockput(dp);
80105628:	83 ec 0c             	sub    $0xc,%esp
8010562b:	56                   	push   %esi
8010562c:	e8 af c8 ff ff       	call   80101ee0 <iunlockput>
  end_op();
80105631:	e8 4a dc ff ff       	call   80103280 <end_op>
  return -1;
80105636:	83 c4 10             	add    $0x10,%esp
80105639:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010563e:	eb 92                	jmp    801055d2 <sys_unlink+0x112>
    iupdate(dp);
80105640:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105643:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105648:	56                   	push   %esi
80105649:	e8 32 c5 ff ff       	call   80101b80 <iupdate>
8010564e:	83 c4 10             	add    $0x10,%esp
80105651:	e9 54 ff ff ff       	jmp    801055aa <sys_unlink+0xea>
80105656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105665:	e9 68 ff ff ff       	jmp    801055d2 <sys_unlink+0x112>
    end_op();
8010566a:	e8 11 dc ff ff       	call   80103280 <end_op>
    return -1;
8010566f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105674:	e9 59 ff ff ff       	jmp    801055d2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105679:	83 ec 0c             	sub    $0xc,%esp
8010567c:	68 18 7d 10 80       	push   $0x80107d18
80105681:	e8 7a b0 ff ff       	call   80100700 <panic>
    panic("unlink: writei");
80105686:	83 ec 0c             	sub    $0xc,%esp
80105689:	68 2a 7d 10 80       	push   $0x80107d2a
8010568e:	e8 6d b0 ff ff       	call   80100700 <panic>
    panic("unlink: nlink < 1");
80105693:	83 ec 0c             	sub    $0xc,%esp
80105696:	68 06 7d 10 80       	push   $0x80107d06
8010569b:	e8 60 b0 ff ff       	call   80100700 <panic>

801056a0 <sys_open>:

int
sys_open(void)
{
801056a0:	f3 0f 1e fb          	endbr32 
801056a4:	55                   	push   %ebp
801056a5:	89 e5                	mov    %esp,%ebp
801056a7:	57                   	push   %edi
801056a8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801056ac:	53                   	push   %ebx
801056ad:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056b0:	50                   	push   %eax
801056b1:	6a 00                	push   $0x0
801056b3:	e8 28 f8 ff ff       	call   80104ee0 <argstr>
801056b8:	83 c4 10             	add    $0x10,%esp
801056bb:	85 c0                	test   %eax,%eax
801056bd:	0f 88 8a 00 00 00    	js     8010574d <sys_open+0xad>
801056c3:	83 ec 08             	sub    $0x8,%esp
801056c6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056c9:	50                   	push   %eax
801056ca:	6a 01                	push   $0x1
801056cc:	e8 5f f7 ff ff       	call   80104e30 <argint>
801056d1:	83 c4 10             	add    $0x10,%esp
801056d4:	85 c0                	test   %eax,%eax
801056d6:	78 75                	js     8010574d <sys_open+0xad>
    return -1;

  begin_op();
801056d8:	e8 33 db ff ff       	call   80103210 <begin_op>

  if(omode & O_CREATE){
801056dd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801056e1:	75 75                	jne    80105758 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801056e3:	83 ec 0c             	sub    $0xc,%esp
801056e6:	ff 75 e0             	pushl  -0x20(%ebp)
801056e9:	e8 22 ce ff ff       	call   80102510 <namei>
801056ee:	83 c4 10             	add    $0x10,%esp
801056f1:	89 c6                	mov    %eax,%esi
801056f3:	85 c0                	test   %eax,%eax
801056f5:	74 7e                	je     80105775 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801056f7:	83 ec 0c             	sub    $0xc,%esp
801056fa:	50                   	push   %eax
801056fb:	e8 40 c5 ff ff       	call   80101c40 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105700:	83 c4 10             	add    $0x10,%esp
80105703:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105708:	0f 84 c2 00 00 00    	je     801057d0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010570e:	e8 cd bb ff ff       	call   801012e0 <filealloc>
80105713:	89 c7                	mov    %eax,%edi
80105715:	85 c0                	test   %eax,%eax
80105717:	74 23                	je     8010573c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105719:	e8 22 e7 ff ff       	call   80103e40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010571e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105720:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105724:	85 d2                	test   %edx,%edx
80105726:	74 60                	je     80105788 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105728:	83 c3 01             	add    $0x1,%ebx
8010572b:	83 fb 10             	cmp    $0x10,%ebx
8010572e:	75 f0                	jne    80105720 <sys_open+0x80>
    if(f)
      fileclose(f);
80105730:	83 ec 0c             	sub    $0xc,%esp
80105733:	57                   	push   %edi
80105734:	e8 67 bc ff ff       	call   801013a0 <fileclose>
80105739:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010573c:	83 ec 0c             	sub    $0xc,%esp
8010573f:	56                   	push   %esi
80105740:	e8 9b c7 ff ff       	call   80101ee0 <iunlockput>
    end_op();
80105745:	e8 36 db ff ff       	call   80103280 <end_op>
    return -1;
8010574a:	83 c4 10             	add    $0x10,%esp
8010574d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105752:	eb 6d                	jmp    801057c1 <sys_open+0x121>
80105754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105758:	83 ec 0c             	sub    $0xc,%esp
8010575b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010575e:	31 c9                	xor    %ecx,%ecx
80105760:	ba 02 00 00 00       	mov    $0x2,%edx
80105765:	6a 00                	push   $0x0
80105767:	e8 24 f8 ff ff       	call   80104f90 <create>
    if(ip == 0){
8010576c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010576f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105771:	85 c0                	test   %eax,%eax
80105773:	75 99                	jne    8010570e <sys_open+0x6e>
      end_op();
80105775:	e8 06 db ff ff       	call   80103280 <end_op>
      return -1;
8010577a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010577f:	eb 40                	jmp    801057c1 <sys_open+0x121>
80105781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105788:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010578b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010578f:	56                   	push   %esi
80105790:	e8 8b c5 ff ff       	call   80101d20 <iunlock>
  end_op();
80105795:	e8 e6 da ff ff       	call   80103280 <end_op>

  f->type = FD_INODE;
8010579a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801057a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057a3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801057a6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801057a9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801057ab:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801057b2:	f7 d0                	not    %eax
801057b4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057b7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801057ba:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057bd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801057c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057c4:	89 d8                	mov    %ebx,%eax
801057c6:	5b                   	pop    %ebx
801057c7:	5e                   	pop    %esi
801057c8:	5f                   	pop    %edi
801057c9:	5d                   	pop    %ebp
801057ca:	c3                   	ret    
801057cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057cf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801057d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801057d3:	85 c9                	test   %ecx,%ecx
801057d5:	0f 84 33 ff ff ff    	je     8010570e <sys_open+0x6e>
801057db:	e9 5c ff ff ff       	jmp    8010573c <sys_open+0x9c>

801057e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801057e0:	f3 0f 1e fb          	endbr32 
801057e4:	55                   	push   %ebp
801057e5:	89 e5                	mov    %esp,%ebp
801057e7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801057ea:	e8 21 da ff ff       	call   80103210 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801057ef:	83 ec 08             	sub    $0x8,%esp
801057f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057f5:	50                   	push   %eax
801057f6:	6a 00                	push   $0x0
801057f8:	e8 e3 f6 ff ff       	call   80104ee0 <argstr>
801057fd:	83 c4 10             	add    $0x10,%esp
80105800:	85 c0                	test   %eax,%eax
80105802:	78 34                	js     80105838 <sys_mkdir+0x58>
80105804:	83 ec 0c             	sub    $0xc,%esp
80105807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010580a:	31 c9                	xor    %ecx,%ecx
8010580c:	ba 01 00 00 00       	mov    $0x1,%edx
80105811:	6a 00                	push   $0x0
80105813:	e8 78 f7 ff ff       	call   80104f90 <create>
80105818:	83 c4 10             	add    $0x10,%esp
8010581b:	85 c0                	test   %eax,%eax
8010581d:	74 19                	je     80105838 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010581f:	83 ec 0c             	sub    $0xc,%esp
80105822:	50                   	push   %eax
80105823:	e8 b8 c6 ff ff       	call   80101ee0 <iunlockput>
  end_op();
80105828:	e8 53 da ff ff       	call   80103280 <end_op>
  return 0;
8010582d:	83 c4 10             	add    $0x10,%esp
80105830:	31 c0                	xor    %eax,%eax
}
80105832:	c9                   	leave  
80105833:	c3                   	ret    
80105834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105838:	e8 43 da ff ff       	call   80103280 <end_op>
    return -1;
8010583d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105842:	c9                   	leave  
80105843:	c3                   	ret    
80105844:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010584f:	90                   	nop

80105850 <sys_mknod>:

int
sys_mknod(void)
{
80105850:	f3 0f 1e fb          	endbr32 
80105854:	55                   	push   %ebp
80105855:	89 e5                	mov    %esp,%ebp
80105857:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010585a:	e8 b1 d9 ff ff       	call   80103210 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010585f:	83 ec 08             	sub    $0x8,%esp
80105862:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105865:	50                   	push   %eax
80105866:	6a 00                	push   $0x0
80105868:	e8 73 f6 ff ff       	call   80104ee0 <argstr>
8010586d:	83 c4 10             	add    $0x10,%esp
80105870:	85 c0                	test   %eax,%eax
80105872:	78 64                	js     801058d8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105874:	83 ec 08             	sub    $0x8,%esp
80105877:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010587a:	50                   	push   %eax
8010587b:	6a 01                	push   $0x1
8010587d:	e8 ae f5 ff ff       	call   80104e30 <argint>
  if((argstr(0, &path)) < 0 ||
80105882:	83 c4 10             	add    $0x10,%esp
80105885:	85 c0                	test   %eax,%eax
80105887:	78 4f                	js     801058d8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105889:	83 ec 08             	sub    $0x8,%esp
8010588c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010588f:	50                   	push   %eax
80105890:	6a 02                	push   $0x2
80105892:	e8 99 f5 ff ff       	call   80104e30 <argint>
     argint(1, &major) < 0 ||
80105897:	83 c4 10             	add    $0x10,%esp
8010589a:	85 c0                	test   %eax,%eax
8010589c:	78 3a                	js     801058d8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010589e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801058a2:	83 ec 0c             	sub    $0xc,%esp
801058a5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801058a9:	ba 03 00 00 00       	mov    $0x3,%edx
801058ae:	50                   	push   %eax
801058af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801058b2:	e8 d9 f6 ff ff       	call   80104f90 <create>
     argint(2, &minor) < 0 ||
801058b7:	83 c4 10             	add    $0x10,%esp
801058ba:	85 c0                	test   %eax,%eax
801058bc:	74 1a                	je     801058d8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
801058be:	83 ec 0c             	sub    $0xc,%esp
801058c1:	50                   	push   %eax
801058c2:	e8 19 c6 ff ff       	call   80101ee0 <iunlockput>
  end_op();
801058c7:	e8 b4 d9 ff ff       	call   80103280 <end_op>
  return 0;
801058cc:	83 c4 10             	add    $0x10,%esp
801058cf:	31 c0                	xor    %eax,%eax
}
801058d1:	c9                   	leave  
801058d2:	c3                   	ret    
801058d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058d7:	90                   	nop
    end_op();
801058d8:	e8 a3 d9 ff ff       	call   80103280 <end_op>
    return -1;
801058dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058e2:	c9                   	leave  
801058e3:	c3                   	ret    
801058e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058ef:	90                   	nop

801058f0 <sys_chdir>:

int
sys_chdir(void)
{
801058f0:	f3 0f 1e fb          	endbr32 
801058f4:	55                   	push   %ebp
801058f5:	89 e5                	mov    %esp,%ebp
801058f7:	56                   	push   %esi
801058f8:	53                   	push   %ebx
801058f9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801058fc:	e8 3f e5 ff ff       	call   80103e40 <myproc>
80105901:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105903:	e8 08 d9 ff ff       	call   80103210 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105908:	83 ec 08             	sub    $0x8,%esp
8010590b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010590e:	50                   	push   %eax
8010590f:	6a 00                	push   $0x0
80105911:	e8 ca f5 ff ff       	call   80104ee0 <argstr>
80105916:	83 c4 10             	add    $0x10,%esp
80105919:	85 c0                	test   %eax,%eax
8010591b:	78 73                	js     80105990 <sys_chdir+0xa0>
8010591d:	83 ec 0c             	sub    $0xc,%esp
80105920:	ff 75 f4             	pushl  -0xc(%ebp)
80105923:	e8 e8 cb ff ff       	call   80102510 <namei>
80105928:	83 c4 10             	add    $0x10,%esp
8010592b:	89 c3                	mov    %eax,%ebx
8010592d:	85 c0                	test   %eax,%eax
8010592f:	74 5f                	je     80105990 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105931:	83 ec 0c             	sub    $0xc,%esp
80105934:	50                   	push   %eax
80105935:	e8 06 c3 ff ff       	call   80101c40 <ilock>
  if(ip->type != T_DIR){
8010593a:	83 c4 10             	add    $0x10,%esp
8010593d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105942:	75 2c                	jne    80105970 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105944:	83 ec 0c             	sub    $0xc,%esp
80105947:	53                   	push   %ebx
80105948:	e8 d3 c3 ff ff       	call   80101d20 <iunlock>
  iput(curproc->cwd);
8010594d:	58                   	pop    %eax
8010594e:	ff 76 68             	pushl  0x68(%esi)
80105951:	e8 1a c4 ff ff       	call   80101d70 <iput>
  end_op();
80105956:	e8 25 d9 ff ff       	call   80103280 <end_op>
  curproc->cwd = ip;
8010595b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010595e:	83 c4 10             	add    $0x10,%esp
80105961:	31 c0                	xor    %eax,%eax
}
80105963:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105966:	5b                   	pop    %ebx
80105967:	5e                   	pop    %esi
80105968:	5d                   	pop    %ebp
80105969:	c3                   	ret    
8010596a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105970:	83 ec 0c             	sub    $0xc,%esp
80105973:	53                   	push   %ebx
80105974:	e8 67 c5 ff ff       	call   80101ee0 <iunlockput>
    end_op();
80105979:	e8 02 d9 ff ff       	call   80103280 <end_op>
    return -1;
8010597e:	83 c4 10             	add    $0x10,%esp
80105981:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105986:	eb db                	jmp    80105963 <sys_chdir+0x73>
80105988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598f:	90                   	nop
    end_op();
80105990:	e8 eb d8 ff ff       	call   80103280 <end_op>
    return -1;
80105995:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010599a:	eb c7                	jmp    80105963 <sys_chdir+0x73>
8010599c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059a0 <sys_exec>:

int
sys_exec(void)
{
801059a0:	f3 0f 1e fb          	endbr32 
801059a4:	55                   	push   %ebp
801059a5:	89 e5                	mov    %esp,%ebp
801059a7:	57                   	push   %edi
801059a8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059a9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801059af:	53                   	push   %ebx
801059b0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059b6:	50                   	push   %eax
801059b7:	6a 00                	push   $0x0
801059b9:	e8 22 f5 ff ff       	call   80104ee0 <argstr>
801059be:	83 c4 10             	add    $0x10,%esp
801059c1:	85 c0                	test   %eax,%eax
801059c3:	0f 88 8b 00 00 00    	js     80105a54 <sys_exec+0xb4>
801059c9:	83 ec 08             	sub    $0x8,%esp
801059cc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801059d2:	50                   	push   %eax
801059d3:	6a 01                	push   $0x1
801059d5:	e8 56 f4 ff ff       	call   80104e30 <argint>
801059da:	83 c4 10             	add    $0x10,%esp
801059dd:	85 c0                	test   %eax,%eax
801059df:	78 73                	js     80105a54 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801059e1:	83 ec 04             	sub    $0x4,%esp
801059e4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801059ea:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801059ec:	68 80 00 00 00       	push   $0x80
801059f1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801059f7:	6a 00                	push   $0x0
801059f9:	50                   	push   %eax
801059fa:	e8 51 f1 ff ff       	call   80104b50 <memset>
801059ff:	83 c4 10             	add    $0x10,%esp
80105a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a08:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a0e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105a15:	83 ec 08             	sub    $0x8,%esp
80105a18:	57                   	push   %edi
80105a19:	01 f0                	add    %esi,%eax
80105a1b:	50                   	push   %eax
80105a1c:	e8 6f f3 ff ff       	call   80104d90 <fetchint>
80105a21:	83 c4 10             	add    $0x10,%esp
80105a24:	85 c0                	test   %eax,%eax
80105a26:	78 2c                	js     80105a54 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105a28:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a2e:	85 c0                	test   %eax,%eax
80105a30:	74 36                	je     80105a68 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a32:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105a38:	83 ec 08             	sub    $0x8,%esp
80105a3b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105a3e:	52                   	push   %edx
80105a3f:	50                   	push   %eax
80105a40:	e8 8b f3 ff ff       	call   80104dd0 <fetchstr>
80105a45:	83 c4 10             	add    $0x10,%esp
80105a48:	85 c0                	test   %eax,%eax
80105a4a:	78 08                	js     80105a54 <sys_exec+0xb4>
  for(i=0;; i++){
80105a4c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105a4f:	83 fb 20             	cmp    $0x20,%ebx
80105a52:	75 b4                	jne    80105a08 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105a54:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a5c:	5b                   	pop    %ebx
80105a5d:	5e                   	pop    %esi
80105a5e:	5f                   	pop    %edi
80105a5f:	5d                   	pop    %ebp
80105a60:	c3                   	ret    
80105a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105a68:	83 ec 08             	sub    $0x8,%esp
80105a6b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105a71:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105a78:	00 00 00 00 
  return exec(path, argv);
80105a7c:	50                   	push   %eax
80105a7d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105a83:	e8 d8 b4 ff ff       	call   80100f60 <exec>
80105a88:	83 c4 10             	add    $0x10,%esp
}
80105a8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a8e:	5b                   	pop    %ebx
80105a8f:	5e                   	pop    %esi
80105a90:	5f                   	pop    %edi
80105a91:	5d                   	pop    %ebp
80105a92:	c3                   	ret    
80105a93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105aa0 <sys_pipe>:

int
sys_pipe(void)
{
80105aa0:	f3 0f 1e fb          	endbr32 
80105aa4:	55                   	push   %ebp
80105aa5:	89 e5                	mov    %esp,%ebp
80105aa7:	57                   	push   %edi
80105aa8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105aa9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105aac:	53                   	push   %ebx
80105aad:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ab0:	6a 08                	push   $0x8
80105ab2:	50                   	push   %eax
80105ab3:	6a 00                	push   $0x0
80105ab5:	e8 c6 f3 ff ff       	call   80104e80 <argptr>
80105aba:	83 c4 10             	add    $0x10,%esp
80105abd:	85 c0                	test   %eax,%eax
80105abf:	78 4e                	js     80105b0f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ac1:	83 ec 08             	sub    $0x8,%esp
80105ac4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ac7:	50                   	push   %eax
80105ac8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105acb:	50                   	push   %eax
80105acc:	e8 ff dd ff ff       	call   801038d0 <pipealloc>
80105ad1:	83 c4 10             	add    $0x10,%esp
80105ad4:	85 c0                	test   %eax,%eax
80105ad6:	78 37                	js     80105b0f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ad8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105adb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105add:	e8 5e e3 ff ff       	call   80103e40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105ae8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105aec:	85 f6                	test   %esi,%esi
80105aee:	74 30                	je     80105b20 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105af0:	83 c3 01             	add    $0x1,%ebx
80105af3:	83 fb 10             	cmp    $0x10,%ebx
80105af6:	75 f0                	jne    80105ae8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105af8:	83 ec 0c             	sub    $0xc,%esp
80105afb:	ff 75 e0             	pushl  -0x20(%ebp)
80105afe:	e8 9d b8 ff ff       	call   801013a0 <fileclose>
    fileclose(wf);
80105b03:	58                   	pop    %eax
80105b04:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b07:	e8 94 b8 ff ff       	call   801013a0 <fileclose>
    return -1;
80105b0c:	83 c4 10             	add    $0x10,%esp
80105b0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b14:	eb 5b                	jmp    80105b71 <sys_pipe+0xd1>
80105b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b1d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105b20:	8d 73 08             	lea    0x8(%ebx),%esi
80105b23:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105b2a:	e8 11 e3 ff ff       	call   80103e40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b2f:	31 d2                	xor    %edx,%edx
80105b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105b38:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105b3c:	85 c9                	test   %ecx,%ecx
80105b3e:	74 20                	je     80105b60 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105b40:	83 c2 01             	add    $0x1,%edx
80105b43:	83 fa 10             	cmp    $0x10,%edx
80105b46:	75 f0                	jne    80105b38 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105b48:	e8 f3 e2 ff ff       	call   80103e40 <myproc>
80105b4d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105b54:	00 
80105b55:	eb a1                	jmp    80105af8 <sys_pipe+0x58>
80105b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105b60:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105b64:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b67:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105b69:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b6c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105b6f:	31 c0                	xor    %eax,%eax
}
80105b71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b74:	5b                   	pop    %ebx
80105b75:	5e                   	pop    %esi
80105b76:	5f                   	pop    %edi
80105b77:	5d                   	pop    %ebp
80105b78:	c3                   	ret    
80105b79:	66 90                	xchg   %ax,%ax
80105b7b:	66 90                	xchg   %ax,%ax
80105b7d:	66 90                	xchg   %ax,%ax
80105b7f:	90                   	nop

80105b80 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105b80:	f3 0f 1e fb          	endbr32 
  return fork();
80105b84:	e9 67 e4 ff ff       	jmp    80103ff0 <fork>
80105b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b90 <sys_exit>:
}

int
sys_exit(void)
{
80105b90:	f3 0f 1e fb          	endbr32 
80105b94:	55                   	push   %ebp
80105b95:	89 e5                	mov    %esp,%ebp
80105b97:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b9a:	e8 d1 e6 ff ff       	call   80104270 <exit>
  return 0;  // not reached
}
80105b9f:	31 c0                	xor    %eax,%eax
80105ba1:	c9                   	leave  
80105ba2:	c3                   	ret    
80105ba3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bb0 <sys_wait>:

int
sys_wait(void)
{
80105bb0:	f3 0f 1e fb          	endbr32 
  return wait();
80105bb4:	e9 07 e9 ff ff       	jmp    801044c0 <wait>
80105bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bc0 <sys_kill>:
}

int
sys_kill(void)
{
80105bc0:	f3 0f 1e fb          	endbr32 
80105bc4:	55                   	push   %ebp
80105bc5:	89 e5                	mov    %esp,%ebp
80105bc7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105bca:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bcd:	50                   	push   %eax
80105bce:	6a 00                	push   $0x0
80105bd0:	e8 5b f2 ff ff       	call   80104e30 <argint>
80105bd5:	83 c4 10             	add    $0x10,%esp
80105bd8:	85 c0                	test   %eax,%eax
80105bda:	78 14                	js     80105bf0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105bdc:	83 ec 0c             	sub    $0xc,%esp
80105bdf:	ff 75 f4             	pushl  -0xc(%ebp)
80105be2:	e8 39 ea ff ff       	call   80104620 <kill>
80105be7:	83 c4 10             	add    $0x10,%esp
}
80105bea:	c9                   	leave  
80105beb:	c3                   	ret    
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bf0:	c9                   	leave  
    return -1;
80105bf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bf6:	c3                   	ret    
80105bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bfe:	66 90                	xchg   %ax,%ax

80105c00 <sys_getpid>:

int
sys_getpid(void)
{
80105c00:	f3 0f 1e fb          	endbr32 
80105c04:	55                   	push   %ebp
80105c05:	89 e5                	mov    %esp,%ebp
80105c07:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c0a:	e8 31 e2 ff ff       	call   80103e40 <myproc>
80105c0f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c12:	c9                   	leave  
80105c13:	c3                   	ret    
80105c14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c1f:	90                   	nop

80105c20 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c20:	f3 0f 1e fb          	endbr32 
80105c24:	55                   	push   %ebp
80105c25:	89 e5                	mov    %esp,%ebp
80105c27:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c28:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c2b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c2e:	50                   	push   %eax
80105c2f:	6a 00                	push   $0x0
80105c31:	e8 fa f1 ff ff       	call   80104e30 <argint>
80105c36:	83 c4 10             	add    $0x10,%esp
80105c39:	85 c0                	test   %eax,%eax
80105c3b:	78 23                	js     80105c60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c3d:	e8 fe e1 ff ff       	call   80103e40 <myproc>
  if(growproc(n) < 0)
80105c42:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105c45:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c47:	ff 75 f4             	pushl  -0xc(%ebp)
80105c4a:	e8 21 e3 ff ff       	call   80103f70 <growproc>
80105c4f:	83 c4 10             	add    $0x10,%esp
80105c52:	85 c0                	test   %eax,%eax
80105c54:	78 0a                	js     80105c60 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105c56:	89 d8                	mov    %ebx,%eax
80105c58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c5b:	c9                   	leave  
80105c5c:	c3                   	ret    
80105c5d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c60:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c65:	eb ef                	jmp    80105c56 <sys_sbrk+0x36>
80105c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c6e:	66 90                	xchg   %ax,%ax

80105c70 <sys_sleep>:

int
sys_sleep(void)
{
80105c70:	f3 0f 1e fb          	endbr32 
80105c74:	55                   	push   %ebp
80105c75:	89 e5                	mov    %esp,%ebp
80105c77:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c78:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c7b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c7e:	50                   	push   %eax
80105c7f:	6a 00                	push   $0x0
80105c81:	e8 aa f1 ff ff       	call   80104e30 <argint>
80105c86:	83 c4 10             	add    $0x10,%esp
80105c89:	85 c0                	test   %eax,%eax
80105c8b:	0f 88 86 00 00 00    	js     80105d17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105c91:	83 ec 0c             	sub    $0xc,%esp
80105c94:	68 c0 54 11 80       	push   $0x801154c0
80105c99:	e8 a2 ed ff ff       	call   80104a40 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105ca1:	8b 1d 00 5d 11 80    	mov    0x80115d00,%ebx
  while(ticks - ticks0 < n){
80105ca7:	83 c4 10             	add    $0x10,%esp
80105caa:	85 d2                	test   %edx,%edx
80105cac:	75 23                	jne    80105cd1 <sys_sleep+0x61>
80105cae:	eb 50                	jmp    80105d00 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105cb0:	83 ec 08             	sub    $0x8,%esp
80105cb3:	68 c0 54 11 80       	push   $0x801154c0
80105cb8:	68 00 5d 11 80       	push   $0x80115d00
80105cbd:	e8 3e e7 ff ff       	call   80104400 <sleep>
  while(ticks - ticks0 < n){
80105cc2:	a1 00 5d 11 80       	mov    0x80115d00,%eax
80105cc7:	83 c4 10             	add    $0x10,%esp
80105cca:	29 d8                	sub    %ebx,%eax
80105ccc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105ccf:	73 2f                	jae    80105d00 <sys_sleep+0x90>
    if(myproc()->killed){
80105cd1:	e8 6a e1 ff ff       	call   80103e40 <myproc>
80105cd6:	8b 40 24             	mov    0x24(%eax),%eax
80105cd9:	85 c0                	test   %eax,%eax
80105cdb:	74 d3                	je     80105cb0 <sys_sleep+0x40>
      release(&tickslock);
80105cdd:	83 ec 0c             	sub    $0xc,%esp
80105ce0:	68 c0 54 11 80       	push   $0x801154c0
80105ce5:	e8 16 ee ff ff       	call   80104b00 <release>
  }
  release(&tickslock);
  return 0;
}
80105cea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105ced:	83 c4 10             	add    $0x10,%esp
80105cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cf5:	c9                   	leave  
80105cf6:	c3                   	ret    
80105cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cfe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105d00:	83 ec 0c             	sub    $0xc,%esp
80105d03:	68 c0 54 11 80       	push   $0x801154c0
80105d08:	e8 f3 ed ff ff       	call   80104b00 <release>
  return 0;
80105d0d:	83 c4 10             	add    $0x10,%esp
80105d10:	31 c0                	xor    %eax,%eax
}
80105d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d15:	c9                   	leave  
80105d16:	c3                   	ret    
    return -1;
80105d17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d1c:	eb f4                	jmp    80105d12 <sys_sleep+0xa2>
80105d1e:	66 90                	xchg   %ax,%ax

80105d20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d20:	f3 0f 1e fb          	endbr32 
80105d24:	55                   	push   %ebp
80105d25:	89 e5                	mov    %esp,%ebp
80105d27:	53                   	push   %ebx
80105d28:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d2b:	68 c0 54 11 80       	push   $0x801154c0
80105d30:	e8 0b ed ff ff       	call   80104a40 <acquire>
  xticks = ticks;
80105d35:	8b 1d 00 5d 11 80    	mov    0x80115d00,%ebx
  release(&tickslock);
80105d3b:	c7 04 24 c0 54 11 80 	movl   $0x801154c0,(%esp)
80105d42:	e8 b9 ed ff ff       	call   80104b00 <release>
  return xticks;
}
80105d47:	89 d8                	mov    %ebx,%eax
80105d49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d4c:	c9                   	leave  
80105d4d:	c3                   	ret    

80105d4e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d4e:	1e                   	push   %ds
  pushl %es
80105d4f:	06                   	push   %es
  pushl %fs
80105d50:	0f a0                	push   %fs
  pushl %gs
80105d52:	0f a8                	push   %gs
  pushal
80105d54:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d55:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d59:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d5b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d5d:	54                   	push   %esp
  call trap
80105d5e:	e8 cd 00 00 00       	call   80105e30 <trap>
  addl $4, %esp
80105d63:	83 c4 04             	add    $0x4,%esp

80105d66 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d66:	61                   	popa   
  popl %gs
80105d67:	0f a9                	pop    %gs
  popl %fs
80105d69:	0f a1                	pop    %fs
  popl %es
80105d6b:	07                   	pop    %es
  popl %ds
80105d6c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d6d:	83 c4 08             	add    $0x8,%esp
  iret
80105d70:	cf                   	iret   
80105d71:	66 90                	xchg   %ax,%ax
80105d73:	66 90                	xchg   %ax,%ax
80105d75:	66 90                	xchg   %ax,%ax
80105d77:	66 90                	xchg   %ax,%ax
80105d79:	66 90                	xchg   %ax,%ax
80105d7b:	66 90                	xchg   %ax,%ax
80105d7d:	66 90                	xchg   %ax,%ax
80105d7f:	90                   	nop

80105d80 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d80:	f3 0f 1e fb          	endbr32 
80105d84:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d85:	31 c0                	xor    %eax,%eax
{
80105d87:	89 e5                	mov    %esp,%ebp
80105d89:	83 ec 08             	sub    $0x8,%esp
80105d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d90:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105d97:	c7 04 c5 02 55 11 80 	movl   $0x8e000008,-0x7feeaafe(,%eax,8)
80105d9e:	08 00 00 8e 
80105da2:	66 89 14 c5 00 55 11 	mov    %dx,-0x7feeab00(,%eax,8)
80105da9:	80 
80105daa:	c1 ea 10             	shr    $0x10,%edx
80105dad:	66 89 14 c5 06 55 11 	mov    %dx,-0x7feeaafa(,%eax,8)
80105db4:	80 
  for(i = 0; i < 256; i++)
80105db5:	83 c0 01             	add    $0x1,%eax
80105db8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105dbd:	75 d1                	jne    80105d90 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105dbf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105dc2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105dc7:	c7 05 02 57 11 80 08 	movl   $0xef000008,0x80115702
80105dce:	00 00 ef 
  initlock(&tickslock, "time");
80105dd1:	68 39 7d 10 80       	push   $0x80107d39
80105dd6:	68 c0 54 11 80       	push   $0x801154c0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ddb:	66 a3 00 57 11 80    	mov    %ax,0x80115700
80105de1:	c1 e8 10             	shr    $0x10,%eax
80105de4:	66 a3 06 57 11 80    	mov    %ax,0x80115706
  initlock(&tickslock, "time");
80105dea:	e8 d1 ea ff ff       	call   801048c0 <initlock>
}
80105def:	83 c4 10             	add    $0x10,%esp
80105df2:	c9                   	leave  
80105df3:	c3                   	ret    
80105df4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dff:	90                   	nop

80105e00 <idtinit>:

void
idtinit(void)
{
80105e00:	f3 0f 1e fb          	endbr32 
80105e04:	55                   	push   %ebp
  pd[0] = size-1;
80105e05:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e0a:	89 e5                	mov    %esp,%ebp
80105e0c:	83 ec 10             	sub    $0x10,%esp
80105e0f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e13:	b8 00 55 11 80       	mov    $0x80115500,%eax
80105e18:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e1c:	c1 e8 10             	shr    $0x10,%eax
80105e1f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105e23:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e26:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105e29:	c9                   	leave  
80105e2a:	c3                   	ret    
80105e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e2f:	90                   	nop

80105e30 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105e30:	f3 0f 1e fb          	endbr32 
80105e34:	55                   	push   %ebp
80105e35:	89 e5                	mov    %esp,%ebp
80105e37:	57                   	push   %edi
80105e38:	56                   	push   %esi
80105e39:	53                   	push   %ebx
80105e3a:	83 ec 1c             	sub    $0x1c,%esp
80105e3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105e40:	8b 43 30             	mov    0x30(%ebx),%eax
80105e43:	83 f8 40             	cmp    $0x40,%eax
80105e46:	0f 84 bc 01 00 00    	je     80106008 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e4c:	83 e8 20             	sub    $0x20,%eax
80105e4f:	83 f8 1f             	cmp    $0x1f,%eax
80105e52:	77 08                	ja     80105e5c <trap+0x2c>
80105e54:	3e ff 24 85 e0 7d 10 	notrack jmp *-0x7fef8220(,%eax,4)
80105e5b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e5c:	e8 df df ff ff       	call   80103e40 <myproc>
80105e61:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e64:	85 c0                	test   %eax,%eax
80105e66:	0f 84 eb 01 00 00    	je     80106057 <trap+0x227>
80105e6c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105e70:	0f 84 e1 01 00 00    	je     80106057 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e76:	0f 20 d1             	mov    %cr2,%ecx
80105e79:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e7c:	e8 9f df ff ff       	call   80103e20 <cpuid>
80105e81:	8b 73 30             	mov    0x30(%ebx),%esi
80105e84:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e87:	8b 43 34             	mov    0x34(%ebx),%eax
80105e8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105e8d:	e8 ae df ff ff       	call   80103e40 <myproc>
80105e92:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105e95:	e8 a6 df ff ff       	call   80103e40 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e9a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ea0:	51                   	push   %ecx
80105ea1:	57                   	push   %edi
80105ea2:	52                   	push   %edx
80105ea3:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ea6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105ea7:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105eaa:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ead:	56                   	push   %esi
80105eae:	ff 70 10             	pushl  0x10(%eax)
80105eb1:	68 9c 7d 10 80       	push   $0x80107d9c
80105eb6:	e8 c5 a8 ff ff       	call   80100780 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105ebb:	83 c4 20             	add    $0x20,%esp
80105ebe:	e8 7d df ff ff       	call   80103e40 <myproc>
80105ec3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eca:	e8 71 df ff ff       	call   80103e40 <myproc>
80105ecf:	85 c0                	test   %eax,%eax
80105ed1:	74 1d                	je     80105ef0 <trap+0xc0>
80105ed3:	e8 68 df ff ff       	call   80103e40 <myproc>
80105ed8:	8b 50 24             	mov    0x24(%eax),%edx
80105edb:	85 d2                	test   %edx,%edx
80105edd:	74 11                	je     80105ef0 <trap+0xc0>
80105edf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ee3:	83 e0 03             	and    $0x3,%eax
80105ee6:	66 83 f8 03          	cmp    $0x3,%ax
80105eea:	0f 84 50 01 00 00    	je     80106040 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ef0:	e8 4b df ff ff       	call   80103e40 <myproc>
80105ef5:	85 c0                	test   %eax,%eax
80105ef7:	74 0f                	je     80105f08 <trap+0xd8>
80105ef9:	e8 42 df ff ff       	call   80103e40 <myproc>
80105efe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105f02:	0f 84 e8 00 00 00    	je     80105ff0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f08:	e8 33 df ff ff       	call   80103e40 <myproc>
80105f0d:	85 c0                	test   %eax,%eax
80105f0f:	74 1d                	je     80105f2e <trap+0xfe>
80105f11:	e8 2a df ff ff       	call   80103e40 <myproc>
80105f16:	8b 40 24             	mov    0x24(%eax),%eax
80105f19:	85 c0                	test   %eax,%eax
80105f1b:	74 11                	je     80105f2e <trap+0xfe>
80105f1d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105f21:	83 e0 03             	and    $0x3,%eax
80105f24:	66 83 f8 03          	cmp    $0x3,%ax
80105f28:	0f 84 03 01 00 00    	je     80106031 <trap+0x201>
    exit();
}
80105f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f31:	5b                   	pop    %ebx
80105f32:	5e                   	pop    %esi
80105f33:	5f                   	pop    %edi
80105f34:	5d                   	pop    %ebp
80105f35:	c3                   	ret    
    ideintr();
80105f36:	e8 85 c7 ff ff       	call   801026c0 <ideintr>
    lapiceoi();
80105f3b:	e8 60 ce ff ff       	call   80102da0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f40:	e8 fb de ff ff       	call   80103e40 <myproc>
80105f45:	85 c0                	test   %eax,%eax
80105f47:	75 8a                	jne    80105ed3 <trap+0xa3>
80105f49:	eb a5                	jmp    80105ef0 <trap+0xc0>
    if(cpuid() == 0){
80105f4b:	e8 d0 de ff ff       	call   80103e20 <cpuid>
80105f50:	85 c0                	test   %eax,%eax
80105f52:	75 e7                	jne    80105f3b <trap+0x10b>
      acquire(&tickslock);
80105f54:	83 ec 0c             	sub    $0xc,%esp
80105f57:	68 c0 54 11 80       	push   $0x801154c0
80105f5c:	e8 df ea ff ff       	call   80104a40 <acquire>
      wakeup(&ticks);
80105f61:	c7 04 24 00 5d 11 80 	movl   $0x80115d00,(%esp)
      ticks++;
80105f68:	83 05 00 5d 11 80 01 	addl   $0x1,0x80115d00
      wakeup(&ticks);
80105f6f:	e8 4c e6 ff ff       	call   801045c0 <wakeup>
      release(&tickslock);
80105f74:	c7 04 24 c0 54 11 80 	movl   $0x801154c0,(%esp)
80105f7b:	e8 80 eb ff ff       	call   80104b00 <release>
80105f80:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105f83:	eb b6                	jmp    80105f3b <trap+0x10b>
    kbdintr();
80105f85:	e8 d6 cc ff ff       	call   80102c60 <kbdintr>
    lapiceoi();
80105f8a:	e8 11 ce ff ff       	call   80102da0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f8f:	e8 ac de ff ff       	call   80103e40 <myproc>
80105f94:	85 c0                	test   %eax,%eax
80105f96:	0f 85 37 ff ff ff    	jne    80105ed3 <trap+0xa3>
80105f9c:	e9 4f ff ff ff       	jmp    80105ef0 <trap+0xc0>
    uartintr();
80105fa1:	e8 4a 02 00 00       	call   801061f0 <uartintr>
    lapiceoi();
80105fa6:	e8 f5 cd ff ff       	call   80102da0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fab:	e8 90 de ff ff       	call   80103e40 <myproc>
80105fb0:	85 c0                	test   %eax,%eax
80105fb2:	0f 85 1b ff ff ff    	jne    80105ed3 <trap+0xa3>
80105fb8:	e9 33 ff ff ff       	jmp    80105ef0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105fbd:	8b 7b 38             	mov    0x38(%ebx),%edi
80105fc0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105fc4:	e8 57 de ff ff       	call   80103e20 <cpuid>
80105fc9:	57                   	push   %edi
80105fca:	56                   	push   %esi
80105fcb:	50                   	push   %eax
80105fcc:	68 44 7d 10 80       	push   $0x80107d44
80105fd1:	e8 aa a7 ff ff       	call   80100780 <cprintf>
    lapiceoi();
80105fd6:	e8 c5 cd ff ff       	call   80102da0 <lapiceoi>
    break;
80105fdb:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fde:	e8 5d de ff ff       	call   80103e40 <myproc>
80105fe3:	85 c0                	test   %eax,%eax
80105fe5:	0f 85 e8 fe ff ff    	jne    80105ed3 <trap+0xa3>
80105feb:	e9 00 ff ff ff       	jmp    80105ef0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80105ff0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105ff4:	0f 85 0e ff ff ff    	jne    80105f08 <trap+0xd8>
    yield();
80105ffa:	e8 b1 e3 ff ff       	call   801043b0 <yield>
80105fff:	e9 04 ff ff ff       	jmp    80105f08 <trap+0xd8>
80106004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106008:	e8 33 de ff ff       	call   80103e40 <myproc>
8010600d:	8b 70 24             	mov    0x24(%eax),%esi
80106010:	85 f6                	test   %esi,%esi
80106012:	75 3c                	jne    80106050 <trap+0x220>
    myproc()->tf = tf;
80106014:	e8 27 de ff ff       	call   80103e40 <myproc>
80106019:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010601c:	e8 ff ee ff ff       	call   80104f20 <syscall>
    if(myproc()->killed)
80106021:	e8 1a de ff ff       	call   80103e40 <myproc>
80106026:	8b 48 24             	mov    0x24(%eax),%ecx
80106029:	85 c9                	test   %ecx,%ecx
8010602b:	0f 84 fd fe ff ff    	je     80105f2e <trap+0xfe>
}
80106031:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106034:	5b                   	pop    %ebx
80106035:	5e                   	pop    %esi
80106036:	5f                   	pop    %edi
80106037:	5d                   	pop    %ebp
      exit();
80106038:	e9 33 e2 ff ff       	jmp    80104270 <exit>
8010603d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106040:	e8 2b e2 ff ff       	call   80104270 <exit>
80106045:	e9 a6 fe ff ff       	jmp    80105ef0 <trap+0xc0>
8010604a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106050:	e8 1b e2 ff ff       	call   80104270 <exit>
80106055:	eb bd                	jmp    80106014 <trap+0x1e4>
80106057:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010605a:	e8 c1 dd ff ff       	call   80103e20 <cpuid>
8010605f:	83 ec 0c             	sub    $0xc,%esp
80106062:	56                   	push   %esi
80106063:	57                   	push   %edi
80106064:	50                   	push   %eax
80106065:	ff 73 30             	pushl  0x30(%ebx)
80106068:	68 68 7d 10 80       	push   $0x80107d68
8010606d:	e8 0e a7 ff ff       	call   80100780 <cprintf>
      panic("trap");
80106072:	83 c4 14             	add    $0x14,%esp
80106075:	68 3e 7d 10 80       	push   $0x80107d3e
8010607a:	e8 81 a6 ff ff       	call   80100700 <panic>
8010607f:	90                   	nop

80106080 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106080:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106084:	a1 dc a5 10 80       	mov    0x8010a5dc,%eax
80106089:	85 c0                	test   %eax,%eax
8010608b:	74 1b                	je     801060a8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010608d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106092:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106093:	a8 01                	test   $0x1,%al
80106095:	74 11                	je     801060a8 <uartgetc+0x28>
80106097:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010609c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010609d:	0f b6 c0             	movzbl %al,%eax
801060a0:	c3                   	ret    
801060a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801060a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060ad:	c3                   	ret    
801060ae:	66 90                	xchg   %ax,%ax

801060b0 <uartputc.part.0>:
uartputc(int c)
801060b0:	55                   	push   %ebp
801060b1:	89 e5                	mov    %esp,%ebp
801060b3:	57                   	push   %edi
801060b4:	89 c7                	mov    %eax,%edi
801060b6:	56                   	push   %esi
801060b7:	be fd 03 00 00       	mov    $0x3fd,%esi
801060bc:	53                   	push   %ebx
801060bd:	bb 80 00 00 00       	mov    $0x80,%ebx
801060c2:	83 ec 0c             	sub    $0xc,%esp
801060c5:	eb 1b                	jmp    801060e2 <uartputc.part.0+0x32>
801060c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ce:	66 90                	xchg   %ax,%ax
    microdelay(10);
801060d0:	83 ec 0c             	sub    $0xc,%esp
801060d3:	6a 0a                	push   $0xa
801060d5:	e8 e6 cc ff ff       	call   80102dc0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060da:	83 c4 10             	add    $0x10,%esp
801060dd:	83 eb 01             	sub    $0x1,%ebx
801060e0:	74 07                	je     801060e9 <uartputc.part.0+0x39>
801060e2:	89 f2                	mov    %esi,%edx
801060e4:	ec                   	in     (%dx),%al
801060e5:	a8 20                	test   $0x20,%al
801060e7:	74 e7                	je     801060d0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060e9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060ee:	89 f8                	mov    %edi,%eax
801060f0:	ee                   	out    %al,(%dx)
}
801060f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060f4:	5b                   	pop    %ebx
801060f5:	5e                   	pop    %esi
801060f6:	5f                   	pop    %edi
801060f7:	5d                   	pop    %ebp
801060f8:	c3                   	ret    
801060f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106100 <uartinit>:
{
80106100:	f3 0f 1e fb          	endbr32 
80106104:	55                   	push   %ebp
80106105:	31 c9                	xor    %ecx,%ecx
80106107:	89 c8                	mov    %ecx,%eax
80106109:	89 e5                	mov    %esp,%ebp
8010610b:	57                   	push   %edi
8010610c:	56                   	push   %esi
8010610d:	53                   	push   %ebx
8010610e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106113:	89 da                	mov    %ebx,%edx
80106115:	83 ec 0c             	sub    $0xc,%esp
80106118:	ee                   	out    %al,(%dx)
80106119:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010611e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106123:	89 fa                	mov    %edi,%edx
80106125:	ee                   	out    %al,(%dx)
80106126:	b8 0c 00 00 00       	mov    $0xc,%eax
8010612b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106130:	ee                   	out    %al,(%dx)
80106131:	be f9 03 00 00       	mov    $0x3f9,%esi
80106136:	89 c8                	mov    %ecx,%eax
80106138:	89 f2                	mov    %esi,%edx
8010613a:	ee                   	out    %al,(%dx)
8010613b:	b8 03 00 00 00       	mov    $0x3,%eax
80106140:	89 fa                	mov    %edi,%edx
80106142:	ee                   	out    %al,(%dx)
80106143:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106148:	89 c8                	mov    %ecx,%eax
8010614a:	ee                   	out    %al,(%dx)
8010614b:	b8 01 00 00 00       	mov    $0x1,%eax
80106150:	89 f2                	mov    %esi,%edx
80106152:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106153:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106158:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106159:	3c ff                	cmp    $0xff,%al
8010615b:	74 52                	je     801061af <uartinit+0xaf>
  uart = 1;
8010615d:	c7 05 dc a5 10 80 01 	movl   $0x1,0x8010a5dc
80106164:	00 00 00 
80106167:	89 da                	mov    %ebx,%edx
80106169:	ec                   	in     (%dx),%al
8010616a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010616f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106170:	83 ec 08             	sub    $0x8,%esp
80106173:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106178:	bb 60 7e 10 80       	mov    $0x80107e60,%ebx
  ioapicenable(IRQ_COM1, 0);
8010617d:	6a 00                	push   $0x0
8010617f:	6a 04                	push   $0x4
80106181:	e8 8a c7 ff ff       	call   80102910 <ioapicenable>
80106186:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106189:	b8 78 00 00 00       	mov    $0x78,%eax
8010618e:	eb 04                	jmp    80106194 <uartinit+0x94>
80106190:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106194:	8b 15 dc a5 10 80    	mov    0x8010a5dc,%edx
8010619a:	85 d2                	test   %edx,%edx
8010619c:	74 08                	je     801061a6 <uartinit+0xa6>
    uartputc(*p);
8010619e:	0f be c0             	movsbl %al,%eax
801061a1:	e8 0a ff ff ff       	call   801060b0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801061a6:	89 f0                	mov    %esi,%eax
801061a8:	83 c3 01             	add    $0x1,%ebx
801061ab:	84 c0                	test   %al,%al
801061ad:	75 e1                	jne    80106190 <uartinit+0x90>
}
801061af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061b2:	5b                   	pop    %ebx
801061b3:	5e                   	pop    %esi
801061b4:	5f                   	pop    %edi
801061b5:	5d                   	pop    %ebp
801061b6:	c3                   	ret    
801061b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061be:	66 90                	xchg   %ax,%ax

801061c0 <uartputc>:
{
801061c0:	f3 0f 1e fb          	endbr32 
801061c4:	55                   	push   %ebp
  if(!uart)
801061c5:	8b 15 dc a5 10 80    	mov    0x8010a5dc,%edx
{
801061cb:	89 e5                	mov    %esp,%ebp
801061cd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801061d0:	85 d2                	test   %edx,%edx
801061d2:	74 0c                	je     801061e0 <uartputc+0x20>
}
801061d4:	5d                   	pop    %ebp
801061d5:	e9 d6 fe ff ff       	jmp    801060b0 <uartputc.part.0>
801061da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801061e0:	5d                   	pop    %ebp
801061e1:	c3                   	ret    
801061e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061f0 <uartintr>:

void
uartintr(void)
{
801061f0:	f3 0f 1e fb          	endbr32 
801061f4:	55                   	push   %ebp
801061f5:	89 e5                	mov    %esp,%ebp
801061f7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801061fa:	68 80 60 10 80       	push   $0x80106080
801061ff:	e8 0c a9 ff ff       	call   80100b10 <consoleintr>
}
80106204:	83 c4 10             	add    $0x10,%esp
80106207:	c9                   	leave  
80106208:	c3                   	ret    

80106209 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $0
8010620b:	6a 00                	push   $0x0
  jmp alltraps
8010620d:	e9 3c fb ff ff       	jmp    80105d4e <alltraps>

80106212 <vector1>:
.globl vector1
vector1:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $1
80106214:	6a 01                	push   $0x1
  jmp alltraps
80106216:	e9 33 fb ff ff       	jmp    80105d4e <alltraps>

8010621b <vector2>:
.globl vector2
vector2:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $2
8010621d:	6a 02                	push   $0x2
  jmp alltraps
8010621f:	e9 2a fb ff ff       	jmp    80105d4e <alltraps>

80106224 <vector3>:
.globl vector3
vector3:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $3
80106226:	6a 03                	push   $0x3
  jmp alltraps
80106228:	e9 21 fb ff ff       	jmp    80105d4e <alltraps>

8010622d <vector4>:
.globl vector4
vector4:
  pushl $0
8010622d:	6a 00                	push   $0x0
  pushl $4
8010622f:	6a 04                	push   $0x4
  jmp alltraps
80106231:	e9 18 fb ff ff       	jmp    80105d4e <alltraps>

80106236 <vector5>:
.globl vector5
vector5:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $5
80106238:	6a 05                	push   $0x5
  jmp alltraps
8010623a:	e9 0f fb ff ff       	jmp    80105d4e <alltraps>

8010623f <vector6>:
.globl vector6
vector6:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $6
80106241:	6a 06                	push   $0x6
  jmp alltraps
80106243:	e9 06 fb ff ff       	jmp    80105d4e <alltraps>

80106248 <vector7>:
.globl vector7
vector7:
  pushl $0
80106248:	6a 00                	push   $0x0
  pushl $7
8010624a:	6a 07                	push   $0x7
  jmp alltraps
8010624c:	e9 fd fa ff ff       	jmp    80105d4e <alltraps>

80106251 <vector8>:
.globl vector8
vector8:
  pushl $8
80106251:	6a 08                	push   $0x8
  jmp alltraps
80106253:	e9 f6 fa ff ff       	jmp    80105d4e <alltraps>

80106258 <vector9>:
.globl vector9
vector9:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $9
8010625a:	6a 09                	push   $0x9
  jmp alltraps
8010625c:	e9 ed fa ff ff       	jmp    80105d4e <alltraps>

80106261 <vector10>:
.globl vector10
vector10:
  pushl $10
80106261:	6a 0a                	push   $0xa
  jmp alltraps
80106263:	e9 e6 fa ff ff       	jmp    80105d4e <alltraps>

80106268 <vector11>:
.globl vector11
vector11:
  pushl $11
80106268:	6a 0b                	push   $0xb
  jmp alltraps
8010626a:	e9 df fa ff ff       	jmp    80105d4e <alltraps>

8010626f <vector12>:
.globl vector12
vector12:
  pushl $12
8010626f:	6a 0c                	push   $0xc
  jmp alltraps
80106271:	e9 d8 fa ff ff       	jmp    80105d4e <alltraps>

80106276 <vector13>:
.globl vector13
vector13:
  pushl $13
80106276:	6a 0d                	push   $0xd
  jmp alltraps
80106278:	e9 d1 fa ff ff       	jmp    80105d4e <alltraps>

8010627d <vector14>:
.globl vector14
vector14:
  pushl $14
8010627d:	6a 0e                	push   $0xe
  jmp alltraps
8010627f:	e9 ca fa ff ff       	jmp    80105d4e <alltraps>

80106284 <vector15>:
.globl vector15
vector15:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $15
80106286:	6a 0f                	push   $0xf
  jmp alltraps
80106288:	e9 c1 fa ff ff       	jmp    80105d4e <alltraps>

8010628d <vector16>:
.globl vector16
vector16:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $16
8010628f:	6a 10                	push   $0x10
  jmp alltraps
80106291:	e9 b8 fa ff ff       	jmp    80105d4e <alltraps>

80106296 <vector17>:
.globl vector17
vector17:
  pushl $17
80106296:	6a 11                	push   $0x11
  jmp alltraps
80106298:	e9 b1 fa ff ff       	jmp    80105d4e <alltraps>

8010629d <vector18>:
.globl vector18
vector18:
  pushl $0
8010629d:	6a 00                	push   $0x0
  pushl $18
8010629f:	6a 12                	push   $0x12
  jmp alltraps
801062a1:	e9 a8 fa ff ff       	jmp    80105d4e <alltraps>

801062a6 <vector19>:
.globl vector19
vector19:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $19
801062a8:	6a 13                	push   $0x13
  jmp alltraps
801062aa:	e9 9f fa ff ff       	jmp    80105d4e <alltraps>

801062af <vector20>:
.globl vector20
vector20:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $20
801062b1:	6a 14                	push   $0x14
  jmp alltraps
801062b3:	e9 96 fa ff ff       	jmp    80105d4e <alltraps>

801062b8 <vector21>:
.globl vector21
vector21:
  pushl $0
801062b8:	6a 00                	push   $0x0
  pushl $21
801062ba:	6a 15                	push   $0x15
  jmp alltraps
801062bc:	e9 8d fa ff ff       	jmp    80105d4e <alltraps>

801062c1 <vector22>:
.globl vector22
vector22:
  pushl $0
801062c1:	6a 00                	push   $0x0
  pushl $22
801062c3:	6a 16                	push   $0x16
  jmp alltraps
801062c5:	e9 84 fa ff ff       	jmp    80105d4e <alltraps>

801062ca <vector23>:
.globl vector23
vector23:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $23
801062cc:	6a 17                	push   $0x17
  jmp alltraps
801062ce:	e9 7b fa ff ff       	jmp    80105d4e <alltraps>

801062d3 <vector24>:
.globl vector24
vector24:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $24
801062d5:	6a 18                	push   $0x18
  jmp alltraps
801062d7:	e9 72 fa ff ff       	jmp    80105d4e <alltraps>

801062dc <vector25>:
.globl vector25
vector25:
  pushl $0
801062dc:	6a 00                	push   $0x0
  pushl $25
801062de:	6a 19                	push   $0x19
  jmp alltraps
801062e0:	e9 69 fa ff ff       	jmp    80105d4e <alltraps>

801062e5 <vector26>:
.globl vector26
vector26:
  pushl $0
801062e5:	6a 00                	push   $0x0
  pushl $26
801062e7:	6a 1a                	push   $0x1a
  jmp alltraps
801062e9:	e9 60 fa ff ff       	jmp    80105d4e <alltraps>

801062ee <vector27>:
.globl vector27
vector27:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $27
801062f0:	6a 1b                	push   $0x1b
  jmp alltraps
801062f2:	e9 57 fa ff ff       	jmp    80105d4e <alltraps>

801062f7 <vector28>:
.globl vector28
vector28:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $28
801062f9:	6a 1c                	push   $0x1c
  jmp alltraps
801062fb:	e9 4e fa ff ff       	jmp    80105d4e <alltraps>

80106300 <vector29>:
.globl vector29
vector29:
  pushl $0
80106300:	6a 00                	push   $0x0
  pushl $29
80106302:	6a 1d                	push   $0x1d
  jmp alltraps
80106304:	e9 45 fa ff ff       	jmp    80105d4e <alltraps>

80106309 <vector30>:
.globl vector30
vector30:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $30
8010630b:	6a 1e                	push   $0x1e
  jmp alltraps
8010630d:	e9 3c fa ff ff       	jmp    80105d4e <alltraps>

80106312 <vector31>:
.globl vector31
vector31:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $31
80106314:	6a 1f                	push   $0x1f
  jmp alltraps
80106316:	e9 33 fa ff ff       	jmp    80105d4e <alltraps>

8010631b <vector32>:
.globl vector32
vector32:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $32
8010631d:	6a 20                	push   $0x20
  jmp alltraps
8010631f:	e9 2a fa ff ff       	jmp    80105d4e <alltraps>

80106324 <vector33>:
.globl vector33
vector33:
  pushl $0
80106324:	6a 00                	push   $0x0
  pushl $33
80106326:	6a 21                	push   $0x21
  jmp alltraps
80106328:	e9 21 fa ff ff       	jmp    80105d4e <alltraps>

8010632d <vector34>:
.globl vector34
vector34:
  pushl $0
8010632d:	6a 00                	push   $0x0
  pushl $34
8010632f:	6a 22                	push   $0x22
  jmp alltraps
80106331:	e9 18 fa ff ff       	jmp    80105d4e <alltraps>

80106336 <vector35>:
.globl vector35
vector35:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $35
80106338:	6a 23                	push   $0x23
  jmp alltraps
8010633a:	e9 0f fa ff ff       	jmp    80105d4e <alltraps>

8010633f <vector36>:
.globl vector36
vector36:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $36
80106341:	6a 24                	push   $0x24
  jmp alltraps
80106343:	e9 06 fa ff ff       	jmp    80105d4e <alltraps>

80106348 <vector37>:
.globl vector37
vector37:
  pushl $0
80106348:	6a 00                	push   $0x0
  pushl $37
8010634a:	6a 25                	push   $0x25
  jmp alltraps
8010634c:	e9 fd f9 ff ff       	jmp    80105d4e <alltraps>

80106351 <vector38>:
.globl vector38
vector38:
  pushl $0
80106351:	6a 00                	push   $0x0
  pushl $38
80106353:	6a 26                	push   $0x26
  jmp alltraps
80106355:	e9 f4 f9 ff ff       	jmp    80105d4e <alltraps>

8010635a <vector39>:
.globl vector39
vector39:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $39
8010635c:	6a 27                	push   $0x27
  jmp alltraps
8010635e:	e9 eb f9 ff ff       	jmp    80105d4e <alltraps>

80106363 <vector40>:
.globl vector40
vector40:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $40
80106365:	6a 28                	push   $0x28
  jmp alltraps
80106367:	e9 e2 f9 ff ff       	jmp    80105d4e <alltraps>

8010636c <vector41>:
.globl vector41
vector41:
  pushl $0
8010636c:	6a 00                	push   $0x0
  pushl $41
8010636e:	6a 29                	push   $0x29
  jmp alltraps
80106370:	e9 d9 f9 ff ff       	jmp    80105d4e <alltraps>

80106375 <vector42>:
.globl vector42
vector42:
  pushl $0
80106375:	6a 00                	push   $0x0
  pushl $42
80106377:	6a 2a                	push   $0x2a
  jmp alltraps
80106379:	e9 d0 f9 ff ff       	jmp    80105d4e <alltraps>

8010637e <vector43>:
.globl vector43
vector43:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $43
80106380:	6a 2b                	push   $0x2b
  jmp alltraps
80106382:	e9 c7 f9 ff ff       	jmp    80105d4e <alltraps>

80106387 <vector44>:
.globl vector44
vector44:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $44
80106389:	6a 2c                	push   $0x2c
  jmp alltraps
8010638b:	e9 be f9 ff ff       	jmp    80105d4e <alltraps>

80106390 <vector45>:
.globl vector45
vector45:
  pushl $0
80106390:	6a 00                	push   $0x0
  pushl $45
80106392:	6a 2d                	push   $0x2d
  jmp alltraps
80106394:	e9 b5 f9 ff ff       	jmp    80105d4e <alltraps>

80106399 <vector46>:
.globl vector46
vector46:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $46
8010639b:	6a 2e                	push   $0x2e
  jmp alltraps
8010639d:	e9 ac f9 ff ff       	jmp    80105d4e <alltraps>

801063a2 <vector47>:
.globl vector47
vector47:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $47
801063a4:	6a 2f                	push   $0x2f
  jmp alltraps
801063a6:	e9 a3 f9 ff ff       	jmp    80105d4e <alltraps>

801063ab <vector48>:
.globl vector48
vector48:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $48
801063ad:	6a 30                	push   $0x30
  jmp alltraps
801063af:	e9 9a f9 ff ff       	jmp    80105d4e <alltraps>

801063b4 <vector49>:
.globl vector49
vector49:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $49
801063b6:	6a 31                	push   $0x31
  jmp alltraps
801063b8:	e9 91 f9 ff ff       	jmp    80105d4e <alltraps>

801063bd <vector50>:
.globl vector50
vector50:
  pushl $0
801063bd:	6a 00                	push   $0x0
  pushl $50
801063bf:	6a 32                	push   $0x32
  jmp alltraps
801063c1:	e9 88 f9 ff ff       	jmp    80105d4e <alltraps>

801063c6 <vector51>:
.globl vector51
vector51:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $51
801063c8:	6a 33                	push   $0x33
  jmp alltraps
801063ca:	e9 7f f9 ff ff       	jmp    80105d4e <alltraps>

801063cf <vector52>:
.globl vector52
vector52:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $52
801063d1:	6a 34                	push   $0x34
  jmp alltraps
801063d3:	e9 76 f9 ff ff       	jmp    80105d4e <alltraps>

801063d8 <vector53>:
.globl vector53
vector53:
  pushl $0
801063d8:	6a 00                	push   $0x0
  pushl $53
801063da:	6a 35                	push   $0x35
  jmp alltraps
801063dc:	e9 6d f9 ff ff       	jmp    80105d4e <alltraps>

801063e1 <vector54>:
.globl vector54
vector54:
  pushl $0
801063e1:	6a 00                	push   $0x0
  pushl $54
801063e3:	6a 36                	push   $0x36
  jmp alltraps
801063e5:	e9 64 f9 ff ff       	jmp    80105d4e <alltraps>

801063ea <vector55>:
.globl vector55
vector55:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $55
801063ec:	6a 37                	push   $0x37
  jmp alltraps
801063ee:	e9 5b f9 ff ff       	jmp    80105d4e <alltraps>

801063f3 <vector56>:
.globl vector56
vector56:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $56
801063f5:	6a 38                	push   $0x38
  jmp alltraps
801063f7:	e9 52 f9 ff ff       	jmp    80105d4e <alltraps>

801063fc <vector57>:
.globl vector57
vector57:
  pushl $0
801063fc:	6a 00                	push   $0x0
  pushl $57
801063fe:	6a 39                	push   $0x39
  jmp alltraps
80106400:	e9 49 f9 ff ff       	jmp    80105d4e <alltraps>

80106405 <vector58>:
.globl vector58
vector58:
  pushl $0
80106405:	6a 00                	push   $0x0
  pushl $58
80106407:	6a 3a                	push   $0x3a
  jmp alltraps
80106409:	e9 40 f9 ff ff       	jmp    80105d4e <alltraps>

8010640e <vector59>:
.globl vector59
vector59:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $59
80106410:	6a 3b                	push   $0x3b
  jmp alltraps
80106412:	e9 37 f9 ff ff       	jmp    80105d4e <alltraps>

80106417 <vector60>:
.globl vector60
vector60:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $60
80106419:	6a 3c                	push   $0x3c
  jmp alltraps
8010641b:	e9 2e f9 ff ff       	jmp    80105d4e <alltraps>

80106420 <vector61>:
.globl vector61
vector61:
  pushl $0
80106420:	6a 00                	push   $0x0
  pushl $61
80106422:	6a 3d                	push   $0x3d
  jmp alltraps
80106424:	e9 25 f9 ff ff       	jmp    80105d4e <alltraps>

80106429 <vector62>:
.globl vector62
vector62:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $62
8010642b:	6a 3e                	push   $0x3e
  jmp alltraps
8010642d:	e9 1c f9 ff ff       	jmp    80105d4e <alltraps>

80106432 <vector63>:
.globl vector63
vector63:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $63
80106434:	6a 3f                	push   $0x3f
  jmp alltraps
80106436:	e9 13 f9 ff ff       	jmp    80105d4e <alltraps>

8010643b <vector64>:
.globl vector64
vector64:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $64
8010643d:	6a 40                	push   $0x40
  jmp alltraps
8010643f:	e9 0a f9 ff ff       	jmp    80105d4e <alltraps>

80106444 <vector65>:
.globl vector65
vector65:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $65
80106446:	6a 41                	push   $0x41
  jmp alltraps
80106448:	e9 01 f9 ff ff       	jmp    80105d4e <alltraps>

8010644d <vector66>:
.globl vector66
vector66:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $66
8010644f:	6a 42                	push   $0x42
  jmp alltraps
80106451:	e9 f8 f8 ff ff       	jmp    80105d4e <alltraps>

80106456 <vector67>:
.globl vector67
vector67:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $67
80106458:	6a 43                	push   $0x43
  jmp alltraps
8010645a:	e9 ef f8 ff ff       	jmp    80105d4e <alltraps>

8010645f <vector68>:
.globl vector68
vector68:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $68
80106461:	6a 44                	push   $0x44
  jmp alltraps
80106463:	e9 e6 f8 ff ff       	jmp    80105d4e <alltraps>

80106468 <vector69>:
.globl vector69
vector69:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $69
8010646a:	6a 45                	push   $0x45
  jmp alltraps
8010646c:	e9 dd f8 ff ff       	jmp    80105d4e <alltraps>

80106471 <vector70>:
.globl vector70
vector70:
  pushl $0
80106471:	6a 00                	push   $0x0
  pushl $70
80106473:	6a 46                	push   $0x46
  jmp alltraps
80106475:	e9 d4 f8 ff ff       	jmp    80105d4e <alltraps>

8010647a <vector71>:
.globl vector71
vector71:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $71
8010647c:	6a 47                	push   $0x47
  jmp alltraps
8010647e:	e9 cb f8 ff ff       	jmp    80105d4e <alltraps>

80106483 <vector72>:
.globl vector72
vector72:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $72
80106485:	6a 48                	push   $0x48
  jmp alltraps
80106487:	e9 c2 f8 ff ff       	jmp    80105d4e <alltraps>

8010648c <vector73>:
.globl vector73
vector73:
  pushl $0
8010648c:	6a 00                	push   $0x0
  pushl $73
8010648e:	6a 49                	push   $0x49
  jmp alltraps
80106490:	e9 b9 f8 ff ff       	jmp    80105d4e <alltraps>

80106495 <vector74>:
.globl vector74
vector74:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $74
80106497:	6a 4a                	push   $0x4a
  jmp alltraps
80106499:	e9 b0 f8 ff ff       	jmp    80105d4e <alltraps>

8010649e <vector75>:
.globl vector75
vector75:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $75
801064a0:	6a 4b                	push   $0x4b
  jmp alltraps
801064a2:	e9 a7 f8 ff ff       	jmp    80105d4e <alltraps>

801064a7 <vector76>:
.globl vector76
vector76:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $76
801064a9:	6a 4c                	push   $0x4c
  jmp alltraps
801064ab:	e9 9e f8 ff ff       	jmp    80105d4e <alltraps>

801064b0 <vector77>:
.globl vector77
vector77:
  pushl $0
801064b0:	6a 00                	push   $0x0
  pushl $77
801064b2:	6a 4d                	push   $0x4d
  jmp alltraps
801064b4:	e9 95 f8 ff ff       	jmp    80105d4e <alltraps>

801064b9 <vector78>:
.globl vector78
vector78:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $78
801064bb:	6a 4e                	push   $0x4e
  jmp alltraps
801064bd:	e9 8c f8 ff ff       	jmp    80105d4e <alltraps>

801064c2 <vector79>:
.globl vector79
vector79:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $79
801064c4:	6a 4f                	push   $0x4f
  jmp alltraps
801064c6:	e9 83 f8 ff ff       	jmp    80105d4e <alltraps>

801064cb <vector80>:
.globl vector80
vector80:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $80
801064cd:	6a 50                	push   $0x50
  jmp alltraps
801064cf:	e9 7a f8 ff ff       	jmp    80105d4e <alltraps>

801064d4 <vector81>:
.globl vector81
vector81:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $81
801064d6:	6a 51                	push   $0x51
  jmp alltraps
801064d8:	e9 71 f8 ff ff       	jmp    80105d4e <alltraps>

801064dd <vector82>:
.globl vector82
vector82:
  pushl $0
801064dd:	6a 00                	push   $0x0
  pushl $82
801064df:	6a 52                	push   $0x52
  jmp alltraps
801064e1:	e9 68 f8 ff ff       	jmp    80105d4e <alltraps>

801064e6 <vector83>:
.globl vector83
vector83:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $83
801064e8:	6a 53                	push   $0x53
  jmp alltraps
801064ea:	e9 5f f8 ff ff       	jmp    80105d4e <alltraps>

801064ef <vector84>:
.globl vector84
vector84:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $84
801064f1:	6a 54                	push   $0x54
  jmp alltraps
801064f3:	e9 56 f8 ff ff       	jmp    80105d4e <alltraps>

801064f8 <vector85>:
.globl vector85
vector85:
  pushl $0
801064f8:	6a 00                	push   $0x0
  pushl $85
801064fa:	6a 55                	push   $0x55
  jmp alltraps
801064fc:	e9 4d f8 ff ff       	jmp    80105d4e <alltraps>

80106501 <vector86>:
.globl vector86
vector86:
  pushl $0
80106501:	6a 00                	push   $0x0
  pushl $86
80106503:	6a 56                	push   $0x56
  jmp alltraps
80106505:	e9 44 f8 ff ff       	jmp    80105d4e <alltraps>

8010650a <vector87>:
.globl vector87
vector87:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $87
8010650c:	6a 57                	push   $0x57
  jmp alltraps
8010650e:	e9 3b f8 ff ff       	jmp    80105d4e <alltraps>

80106513 <vector88>:
.globl vector88
vector88:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $88
80106515:	6a 58                	push   $0x58
  jmp alltraps
80106517:	e9 32 f8 ff ff       	jmp    80105d4e <alltraps>

8010651c <vector89>:
.globl vector89
vector89:
  pushl $0
8010651c:	6a 00                	push   $0x0
  pushl $89
8010651e:	6a 59                	push   $0x59
  jmp alltraps
80106520:	e9 29 f8 ff ff       	jmp    80105d4e <alltraps>

80106525 <vector90>:
.globl vector90
vector90:
  pushl $0
80106525:	6a 00                	push   $0x0
  pushl $90
80106527:	6a 5a                	push   $0x5a
  jmp alltraps
80106529:	e9 20 f8 ff ff       	jmp    80105d4e <alltraps>

8010652e <vector91>:
.globl vector91
vector91:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $91
80106530:	6a 5b                	push   $0x5b
  jmp alltraps
80106532:	e9 17 f8 ff ff       	jmp    80105d4e <alltraps>

80106537 <vector92>:
.globl vector92
vector92:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $92
80106539:	6a 5c                	push   $0x5c
  jmp alltraps
8010653b:	e9 0e f8 ff ff       	jmp    80105d4e <alltraps>

80106540 <vector93>:
.globl vector93
vector93:
  pushl $0
80106540:	6a 00                	push   $0x0
  pushl $93
80106542:	6a 5d                	push   $0x5d
  jmp alltraps
80106544:	e9 05 f8 ff ff       	jmp    80105d4e <alltraps>

80106549 <vector94>:
.globl vector94
vector94:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $94
8010654b:	6a 5e                	push   $0x5e
  jmp alltraps
8010654d:	e9 fc f7 ff ff       	jmp    80105d4e <alltraps>

80106552 <vector95>:
.globl vector95
vector95:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $95
80106554:	6a 5f                	push   $0x5f
  jmp alltraps
80106556:	e9 f3 f7 ff ff       	jmp    80105d4e <alltraps>

8010655b <vector96>:
.globl vector96
vector96:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $96
8010655d:	6a 60                	push   $0x60
  jmp alltraps
8010655f:	e9 ea f7 ff ff       	jmp    80105d4e <alltraps>

80106564 <vector97>:
.globl vector97
vector97:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $97
80106566:	6a 61                	push   $0x61
  jmp alltraps
80106568:	e9 e1 f7 ff ff       	jmp    80105d4e <alltraps>

8010656d <vector98>:
.globl vector98
vector98:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $98
8010656f:	6a 62                	push   $0x62
  jmp alltraps
80106571:	e9 d8 f7 ff ff       	jmp    80105d4e <alltraps>

80106576 <vector99>:
.globl vector99
vector99:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $99
80106578:	6a 63                	push   $0x63
  jmp alltraps
8010657a:	e9 cf f7 ff ff       	jmp    80105d4e <alltraps>

8010657f <vector100>:
.globl vector100
vector100:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $100
80106581:	6a 64                	push   $0x64
  jmp alltraps
80106583:	e9 c6 f7 ff ff       	jmp    80105d4e <alltraps>

80106588 <vector101>:
.globl vector101
vector101:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $101
8010658a:	6a 65                	push   $0x65
  jmp alltraps
8010658c:	e9 bd f7 ff ff       	jmp    80105d4e <alltraps>

80106591 <vector102>:
.globl vector102
vector102:
  pushl $0
80106591:	6a 00                	push   $0x0
  pushl $102
80106593:	6a 66                	push   $0x66
  jmp alltraps
80106595:	e9 b4 f7 ff ff       	jmp    80105d4e <alltraps>

8010659a <vector103>:
.globl vector103
vector103:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $103
8010659c:	6a 67                	push   $0x67
  jmp alltraps
8010659e:	e9 ab f7 ff ff       	jmp    80105d4e <alltraps>

801065a3 <vector104>:
.globl vector104
vector104:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $104
801065a5:	6a 68                	push   $0x68
  jmp alltraps
801065a7:	e9 a2 f7 ff ff       	jmp    80105d4e <alltraps>

801065ac <vector105>:
.globl vector105
vector105:
  pushl $0
801065ac:	6a 00                	push   $0x0
  pushl $105
801065ae:	6a 69                	push   $0x69
  jmp alltraps
801065b0:	e9 99 f7 ff ff       	jmp    80105d4e <alltraps>

801065b5 <vector106>:
.globl vector106
vector106:
  pushl $0
801065b5:	6a 00                	push   $0x0
  pushl $106
801065b7:	6a 6a                	push   $0x6a
  jmp alltraps
801065b9:	e9 90 f7 ff ff       	jmp    80105d4e <alltraps>

801065be <vector107>:
.globl vector107
vector107:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $107
801065c0:	6a 6b                	push   $0x6b
  jmp alltraps
801065c2:	e9 87 f7 ff ff       	jmp    80105d4e <alltraps>

801065c7 <vector108>:
.globl vector108
vector108:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $108
801065c9:	6a 6c                	push   $0x6c
  jmp alltraps
801065cb:	e9 7e f7 ff ff       	jmp    80105d4e <alltraps>

801065d0 <vector109>:
.globl vector109
vector109:
  pushl $0
801065d0:	6a 00                	push   $0x0
  pushl $109
801065d2:	6a 6d                	push   $0x6d
  jmp alltraps
801065d4:	e9 75 f7 ff ff       	jmp    80105d4e <alltraps>

801065d9 <vector110>:
.globl vector110
vector110:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $110
801065db:	6a 6e                	push   $0x6e
  jmp alltraps
801065dd:	e9 6c f7 ff ff       	jmp    80105d4e <alltraps>

801065e2 <vector111>:
.globl vector111
vector111:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $111
801065e4:	6a 6f                	push   $0x6f
  jmp alltraps
801065e6:	e9 63 f7 ff ff       	jmp    80105d4e <alltraps>

801065eb <vector112>:
.globl vector112
vector112:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $112
801065ed:	6a 70                	push   $0x70
  jmp alltraps
801065ef:	e9 5a f7 ff ff       	jmp    80105d4e <alltraps>

801065f4 <vector113>:
.globl vector113
vector113:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $113
801065f6:	6a 71                	push   $0x71
  jmp alltraps
801065f8:	e9 51 f7 ff ff       	jmp    80105d4e <alltraps>

801065fd <vector114>:
.globl vector114
vector114:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $114
801065ff:	6a 72                	push   $0x72
  jmp alltraps
80106601:	e9 48 f7 ff ff       	jmp    80105d4e <alltraps>

80106606 <vector115>:
.globl vector115
vector115:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $115
80106608:	6a 73                	push   $0x73
  jmp alltraps
8010660a:	e9 3f f7 ff ff       	jmp    80105d4e <alltraps>

8010660f <vector116>:
.globl vector116
vector116:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $116
80106611:	6a 74                	push   $0x74
  jmp alltraps
80106613:	e9 36 f7 ff ff       	jmp    80105d4e <alltraps>

80106618 <vector117>:
.globl vector117
vector117:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $117
8010661a:	6a 75                	push   $0x75
  jmp alltraps
8010661c:	e9 2d f7 ff ff       	jmp    80105d4e <alltraps>

80106621 <vector118>:
.globl vector118
vector118:
  pushl $0
80106621:	6a 00                	push   $0x0
  pushl $118
80106623:	6a 76                	push   $0x76
  jmp alltraps
80106625:	e9 24 f7 ff ff       	jmp    80105d4e <alltraps>

8010662a <vector119>:
.globl vector119
vector119:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $119
8010662c:	6a 77                	push   $0x77
  jmp alltraps
8010662e:	e9 1b f7 ff ff       	jmp    80105d4e <alltraps>

80106633 <vector120>:
.globl vector120
vector120:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $120
80106635:	6a 78                	push   $0x78
  jmp alltraps
80106637:	e9 12 f7 ff ff       	jmp    80105d4e <alltraps>

8010663c <vector121>:
.globl vector121
vector121:
  pushl $0
8010663c:	6a 00                	push   $0x0
  pushl $121
8010663e:	6a 79                	push   $0x79
  jmp alltraps
80106640:	e9 09 f7 ff ff       	jmp    80105d4e <alltraps>

80106645 <vector122>:
.globl vector122
vector122:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $122
80106647:	6a 7a                	push   $0x7a
  jmp alltraps
80106649:	e9 00 f7 ff ff       	jmp    80105d4e <alltraps>

8010664e <vector123>:
.globl vector123
vector123:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $123
80106650:	6a 7b                	push   $0x7b
  jmp alltraps
80106652:	e9 f7 f6 ff ff       	jmp    80105d4e <alltraps>

80106657 <vector124>:
.globl vector124
vector124:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $124
80106659:	6a 7c                	push   $0x7c
  jmp alltraps
8010665b:	e9 ee f6 ff ff       	jmp    80105d4e <alltraps>

80106660 <vector125>:
.globl vector125
vector125:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $125
80106662:	6a 7d                	push   $0x7d
  jmp alltraps
80106664:	e9 e5 f6 ff ff       	jmp    80105d4e <alltraps>

80106669 <vector126>:
.globl vector126
vector126:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $126
8010666b:	6a 7e                	push   $0x7e
  jmp alltraps
8010666d:	e9 dc f6 ff ff       	jmp    80105d4e <alltraps>

80106672 <vector127>:
.globl vector127
vector127:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $127
80106674:	6a 7f                	push   $0x7f
  jmp alltraps
80106676:	e9 d3 f6 ff ff       	jmp    80105d4e <alltraps>

8010667b <vector128>:
.globl vector128
vector128:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $128
8010667d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106682:	e9 c7 f6 ff ff       	jmp    80105d4e <alltraps>

80106687 <vector129>:
.globl vector129
vector129:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $129
80106689:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010668e:	e9 bb f6 ff ff       	jmp    80105d4e <alltraps>

80106693 <vector130>:
.globl vector130
vector130:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $130
80106695:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010669a:	e9 af f6 ff ff       	jmp    80105d4e <alltraps>

8010669f <vector131>:
.globl vector131
vector131:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $131
801066a1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801066a6:	e9 a3 f6 ff ff       	jmp    80105d4e <alltraps>

801066ab <vector132>:
.globl vector132
vector132:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $132
801066ad:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801066b2:	e9 97 f6 ff ff       	jmp    80105d4e <alltraps>

801066b7 <vector133>:
.globl vector133
vector133:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $133
801066b9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801066be:	e9 8b f6 ff ff       	jmp    80105d4e <alltraps>

801066c3 <vector134>:
.globl vector134
vector134:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $134
801066c5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801066ca:	e9 7f f6 ff ff       	jmp    80105d4e <alltraps>

801066cf <vector135>:
.globl vector135
vector135:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $135
801066d1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801066d6:	e9 73 f6 ff ff       	jmp    80105d4e <alltraps>

801066db <vector136>:
.globl vector136
vector136:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $136
801066dd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801066e2:	e9 67 f6 ff ff       	jmp    80105d4e <alltraps>

801066e7 <vector137>:
.globl vector137
vector137:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $137
801066e9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801066ee:	e9 5b f6 ff ff       	jmp    80105d4e <alltraps>

801066f3 <vector138>:
.globl vector138
vector138:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $138
801066f5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801066fa:	e9 4f f6 ff ff       	jmp    80105d4e <alltraps>

801066ff <vector139>:
.globl vector139
vector139:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $139
80106701:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106706:	e9 43 f6 ff ff       	jmp    80105d4e <alltraps>

8010670b <vector140>:
.globl vector140
vector140:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $140
8010670d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106712:	e9 37 f6 ff ff       	jmp    80105d4e <alltraps>

80106717 <vector141>:
.globl vector141
vector141:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $141
80106719:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010671e:	e9 2b f6 ff ff       	jmp    80105d4e <alltraps>

80106723 <vector142>:
.globl vector142
vector142:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $142
80106725:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010672a:	e9 1f f6 ff ff       	jmp    80105d4e <alltraps>

8010672f <vector143>:
.globl vector143
vector143:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $143
80106731:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106736:	e9 13 f6 ff ff       	jmp    80105d4e <alltraps>

8010673b <vector144>:
.globl vector144
vector144:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $144
8010673d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106742:	e9 07 f6 ff ff       	jmp    80105d4e <alltraps>

80106747 <vector145>:
.globl vector145
vector145:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $145
80106749:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010674e:	e9 fb f5 ff ff       	jmp    80105d4e <alltraps>

80106753 <vector146>:
.globl vector146
vector146:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $146
80106755:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010675a:	e9 ef f5 ff ff       	jmp    80105d4e <alltraps>

8010675f <vector147>:
.globl vector147
vector147:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $147
80106761:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106766:	e9 e3 f5 ff ff       	jmp    80105d4e <alltraps>

8010676b <vector148>:
.globl vector148
vector148:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $148
8010676d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106772:	e9 d7 f5 ff ff       	jmp    80105d4e <alltraps>

80106777 <vector149>:
.globl vector149
vector149:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $149
80106779:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010677e:	e9 cb f5 ff ff       	jmp    80105d4e <alltraps>

80106783 <vector150>:
.globl vector150
vector150:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $150
80106785:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010678a:	e9 bf f5 ff ff       	jmp    80105d4e <alltraps>

8010678f <vector151>:
.globl vector151
vector151:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $151
80106791:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106796:	e9 b3 f5 ff ff       	jmp    80105d4e <alltraps>

8010679b <vector152>:
.globl vector152
vector152:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $152
8010679d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801067a2:	e9 a7 f5 ff ff       	jmp    80105d4e <alltraps>

801067a7 <vector153>:
.globl vector153
vector153:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $153
801067a9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801067ae:	e9 9b f5 ff ff       	jmp    80105d4e <alltraps>

801067b3 <vector154>:
.globl vector154
vector154:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $154
801067b5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801067ba:	e9 8f f5 ff ff       	jmp    80105d4e <alltraps>

801067bf <vector155>:
.globl vector155
vector155:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $155
801067c1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801067c6:	e9 83 f5 ff ff       	jmp    80105d4e <alltraps>

801067cb <vector156>:
.globl vector156
vector156:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $156
801067cd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801067d2:	e9 77 f5 ff ff       	jmp    80105d4e <alltraps>

801067d7 <vector157>:
.globl vector157
vector157:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $157
801067d9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801067de:	e9 6b f5 ff ff       	jmp    80105d4e <alltraps>

801067e3 <vector158>:
.globl vector158
vector158:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $158
801067e5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801067ea:	e9 5f f5 ff ff       	jmp    80105d4e <alltraps>

801067ef <vector159>:
.globl vector159
vector159:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $159
801067f1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801067f6:	e9 53 f5 ff ff       	jmp    80105d4e <alltraps>

801067fb <vector160>:
.globl vector160
vector160:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $160
801067fd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106802:	e9 47 f5 ff ff       	jmp    80105d4e <alltraps>

80106807 <vector161>:
.globl vector161
vector161:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $161
80106809:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010680e:	e9 3b f5 ff ff       	jmp    80105d4e <alltraps>

80106813 <vector162>:
.globl vector162
vector162:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $162
80106815:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010681a:	e9 2f f5 ff ff       	jmp    80105d4e <alltraps>

8010681f <vector163>:
.globl vector163
vector163:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $163
80106821:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106826:	e9 23 f5 ff ff       	jmp    80105d4e <alltraps>

8010682b <vector164>:
.globl vector164
vector164:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $164
8010682d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106832:	e9 17 f5 ff ff       	jmp    80105d4e <alltraps>

80106837 <vector165>:
.globl vector165
vector165:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $165
80106839:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010683e:	e9 0b f5 ff ff       	jmp    80105d4e <alltraps>

80106843 <vector166>:
.globl vector166
vector166:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $166
80106845:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010684a:	e9 ff f4 ff ff       	jmp    80105d4e <alltraps>

8010684f <vector167>:
.globl vector167
vector167:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $167
80106851:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106856:	e9 f3 f4 ff ff       	jmp    80105d4e <alltraps>

8010685b <vector168>:
.globl vector168
vector168:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $168
8010685d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106862:	e9 e7 f4 ff ff       	jmp    80105d4e <alltraps>

80106867 <vector169>:
.globl vector169
vector169:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $169
80106869:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010686e:	e9 db f4 ff ff       	jmp    80105d4e <alltraps>

80106873 <vector170>:
.globl vector170
vector170:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $170
80106875:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010687a:	e9 cf f4 ff ff       	jmp    80105d4e <alltraps>

8010687f <vector171>:
.globl vector171
vector171:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $171
80106881:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106886:	e9 c3 f4 ff ff       	jmp    80105d4e <alltraps>

8010688b <vector172>:
.globl vector172
vector172:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $172
8010688d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106892:	e9 b7 f4 ff ff       	jmp    80105d4e <alltraps>

80106897 <vector173>:
.globl vector173
vector173:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $173
80106899:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010689e:	e9 ab f4 ff ff       	jmp    80105d4e <alltraps>

801068a3 <vector174>:
.globl vector174
vector174:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $174
801068a5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801068aa:	e9 9f f4 ff ff       	jmp    80105d4e <alltraps>

801068af <vector175>:
.globl vector175
vector175:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $175
801068b1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801068b6:	e9 93 f4 ff ff       	jmp    80105d4e <alltraps>

801068bb <vector176>:
.globl vector176
vector176:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $176
801068bd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801068c2:	e9 87 f4 ff ff       	jmp    80105d4e <alltraps>

801068c7 <vector177>:
.globl vector177
vector177:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $177
801068c9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801068ce:	e9 7b f4 ff ff       	jmp    80105d4e <alltraps>

801068d3 <vector178>:
.globl vector178
vector178:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $178
801068d5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801068da:	e9 6f f4 ff ff       	jmp    80105d4e <alltraps>

801068df <vector179>:
.globl vector179
vector179:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $179
801068e1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801068e6:	e9 63 f4 ff ff       	jmp    80105d4e <alltraps>

801068eb <vector180>:
.globl vector180
vector180:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $180
801068ed:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801068f2:	e9 57 f4 ff ff       	jmp    80105d4e <alltraps>

801068f7 <vector181>:
.globl vector181
vector181:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $181
801068f9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801068fe:	e9 4b f4 ff ff       	jmp    80105d4e <alltraps>

80106903 <vector182>:
.globl vector182
vector182:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $182
80106905:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010690a:	e9 3f f4 ff ff       	jmp    80105d4e <alltraps>

8010690f <vector183>:
.globl vector183
vector183:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $183
80106911:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106916:	e9 33 f4 ff ff       	jmp    80105d4e <alltraps>

8010691b <vector184>:
.globl vector184
vector184:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $184
8010691d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106922:	e9 27 f4 ff ff       	jmp    80105d4e <alltraps>

80106927 <vector185>:
.globl vector185
vector185:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $185
80106929:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010692e:	e9 1b f4 ff ff       	jmp    80105d4e <alltraps>

80106933 <vector186>:
.globl vector186
vector186:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $186
80106935:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010693a:	e9 0f f4 ff ff       	jmp    80105d4e <alltraps>

8010693f <vector187>:
.globl vector187
vector187:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $187
80106941:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106946:	e9 03 f4 ff ff       	jmp    80105d4e <alltraps>

8010694b <vector188>:
.globl vector188
vector188:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $188
8010694d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106952:	e9 f7 f3 ff ff       	jmp    80105d4e <alltraps>

80106957 <vector189>:
.globl vector189
vector189:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $189
80106959:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010695e:	e9 eb f3 ff ff       	jmp    80105d4e <alltraps>

80106963 <vector190>:
.globl vector190
vector190:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $190
80106965:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010696a:	e9 df f3 ff ff       	jmp    80105d4e <alltraps>

8010696f <vector191>:
.globl vector191
vector191:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $191
80106971:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106976:	e9 d3 f3 ff ff       	jmp    80105d4e <alltraps>

8010697b <vector192>:
.globl vector192
vector192:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $192
8010697d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106982:	e9 c7 f3 ff ff       	jmp    80105d4e <alltraps>

80106987 <vector193>:
.globl vector193
vector193:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $193
80106989:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010698e:	e9 bb f3 ff ff       	jmp    80105d4e <alltraps>

80106993 <vector194>:
.globl vector194
vector194:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $194
80106995:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010699a:	e9 af f3 ff ff       	jmp    80105d4e <alltraps>

8010699f <vector195>:
.globl vector195
vector195:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $195
801069a1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801069a6:	e9 a3 f3 ff ff       	jmp    80105d4e <alltraps>

801069ab <vector196>:
.globl vector196
vector196:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $196
801069ad:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801069b2:	e9 97 f3 ff ff       	jmp    80105d4e <alltraps>

801069b7 <vector197>:
.globl vector197
vector197:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $197
801069b9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801069be:	e9 8b f3 ff ff       	jmp    80105d4e <alltraps>

801069c3 <vector198>:
.globl vector198
vector198:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $198
801069c5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801069ca:	e9 7f f3 ff ff       	jmp    80105d4e <alltraps>

801069cf <vector199>:
.globl vector199
vector199:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $199
801069d1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801069d6:	e9 73 f3 ff ff       	jmp    80105d4e <alltraps>

801069db <vector200>:
.globl vector200
vector200:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $200
801069dd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801069e2:	e9 67 f3 ff ff       	jmp    80105d4e <alltraps>

801069e7 <vector201>:
.globl vector201
vector201:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $201
801069e9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801069ee:	e9 5b f3 ff ff       	jmp    80105d4e <alltraps>

801069f3 <vector202>:
.globl vector202
vector202:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $202
801069f5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801069fa:	e9 4f f3 ff ff       	jmp    80105d4e <alltraps>

801069ff <vector203>:
.globl vector203
vector203:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $203
80106a01:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a06:	e9 43 f3 ff ff       	jmp    80105d4e <alltraps>

80106a0b <vector204>:
.globl vector204
vector204:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $204
80106a0d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a12:	e9 37 f3 ff ff       	jmp    80105d4e <alltraps>

80106a17 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $205
80106a19:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a1e:	e9 2b f3 ff ff       	jmp    80105d4e <alltraps>

80106a23 <vector206>:
.globl vector206
vector206:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $206
80106a25:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a2a:	e9 1f f3 ff ff       	jmp    80105d4e <alltraps>

80106a2f <vector207>:
.globl vector207
vector207:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $207
80106a31:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a36:	e9 13 f3 ff ff       	jmp    80105d4e <alltraps>

80106a3b <vector208>:
.globl vector208
vector208:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $208
80106a3d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a42:	e9 07 f3 ff ff       	jmp    80105d4e <alltraps>

80106a47 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $209
80106a49:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a4e:	e9 fb f2 ff ff       	jmp    80105d4e <alltraps>

80106a53 <vector210>:
.globl vector210
vector210:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $210
80106a55:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a5a:	e9 ef f2 ff ff       	jmp    80105d4e <alltraps>

80106a5f <vector211>:
.globl vector211
vector211:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $211
80106a61:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a66:	e9 e3 f2 ff ff       	jmp    80105d4e <alltraps>

80106a6b <vector212>:
.globl vector212
vector212:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $212
80106a6d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a72:	e9 d7 f2 ff ff       	jmp    80105d4e <alltraps>

80106a77 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $213
80106a79:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a7e:	e9 cb f2 ff ff       	jmp    80105d4e <alltraps>

80106a83 <vector214>:
.globl vector214
vector214:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $214
80106a85:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a8a:	e9 bf f2 ff ff       	jmp    80105d4e <alltraps>

80106a8f <vector215>:
.globl vector215
vector215:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $215
80106a91:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a96:	e9 b3 f2 ff ff       	jmp    80105d4e <alltraps>

80106a9b <vector216>:
.globl vector216
vector216:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $216
80106a9d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106aa2:	e9 a7 f2 ff ff       	jmp    80105d4e <alltraps>

80106aa7 <vector217>:
.globl vector217
vector217:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $217
80106aa9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106aae:	e9 9b f2 ff ff       	jmp    80105d4e <alltraps>

80106ab3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $218
80106ab5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106aba:	e9 8f f2 ff ff       	jmp    80105d4e <alltraps>

80106abf <vector219>:
.globl vector219
vector219:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $219
80106ac1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ac6:	e9 83 f2 ff ff       	jmp    80105d4e <alltraps>

80106acb <vector220>:
.globl vector220
vector220:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $220
80106acd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ad2:	e9 77 f2 ff ff       	jmp    80105d4e <alltraps>

80106ad7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $221
80106ad9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106ade:	e9 6b f2 ff ff       	jmp    80105d4e <alltraps>

80106ae3 <vector222>:
.globl vector222
vector222:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $222
80106ae5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106aea:	e9 5f f2 ff ff       	jmp    80105d4e <alltraps>

80106aef <vector223>:
.globl vector223
vector223:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $223
80106af1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106af6:	e9 53 f2 ff ff       	jmp    80105d4e <alltraps>

80106afb <vector224>:
.globl vector224
vector224:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $224
80106afd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b02:	e9 47 f2 ff ff       	jmp    80105d4e <alltraps>

80106b07 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $225
80106b09:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b0e:	e9 3b f2 ff ff       	jmp    80105d4e <alltraps>

80106b13 <vector226>:
.globl vector226
vector226:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $226
80106b15:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b1a:	e9 2f f2 ff ff       	jmp    80105d4e <alltraps>

80106b1f <vector227>:
.globl vector227
vector227:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $227
80106b21:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b26:	e9 23 f2 ff ff       	jmp    80105d4e <alltraps>

80106b2b <vector228>:
.globl vector228
vector228:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $228
80106b2d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b32:	e9 17 f2 ff ff       	jmp    80105d4e <alltraps>

80106b37 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $229
80106b39:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b3e:	e9 0b f2 ff ff       	jmp    80105d4e <alltraps>

80106b43 <vector230>:
.globl vector230
vector230:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $230
80106b45:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b4a:	e9 ff f1 ff ff       	jmp    80105d4e <alltraps>

80106b4f <vector231>:
.globl vector231
vector231:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $231
80106b51:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b56:	e9 f3 f1 ff ff       	jmp    80105d4e <alltraps>

80106b5b <vector232>:
.globl vector232
vector232:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $232
80106b5d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b62:	e9 e7 f1 ff ff       	jmp    80105d4e <alltraps>

80106b67 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $233
80106b69:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b6e:	e9 db f1 ff ff       	jmp    80105d4e <alltraps>

80106b73 <vector234>:
.globl vector234
vector234:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $234
80106b75:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b7a:	e9 cf f1 ff ff       	jmp    80105d4e <alltraps>

80106b7f <vector235>:
.globl vector235
vector235:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $235
80106b81:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b86:	e9 c3 f1 ff ff       	jmp    80105d4e <alltraps>

80106b8b <vector236>:
.globl vector236
vector236:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $236
80106b8d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b92:	e9 b7 f1 ff ff       	jmp    80105d4e <alltraps>

80106b97 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $237
80106b99:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b9e:	e9 ab f1 ff ff       	jmp    80105d4e <alltraps>

80106ba3 <vector238>:
.globl vector238
vector238:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $238
80106ba5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106baa:	e9 9f f1 ff ff       	jmp    80105d4e <alltraps>

80106baf <vector239>:
.globl vector239
vector239:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $239
80106bb1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106bb6:	e9 93 f1 ff ff       	jmp    80105d4e <alltraps>

80106bbb <vector240>:
.globl vector240
vector240:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $240
80106bbd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106bc2:	e9 87 f1 ff ff       	jmp    80105d4e <alltraps>

80106bc7 <vector241>:
.globl vector241
vector241:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $241
80106bc9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106bce:	e9 7b f1 ff ff       	jmp    80105d4e <alltraps>

80106bd3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $242
80106bd5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106bda:	e9 6f f1 ff ff       	jmp    80105d4e <alltraps>

80106bdf <vector243>:
.globl vector243
vector243:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $243
80106be1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106be6:	e9 63 f1 ff ff       	jmp    80105d4e <alltraps>

80106beb <vector244>:
.globl vector244
vector244:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $244
80106bed:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106bf2:	e9 57 f1 ff ff       	jmp    80105d4e <alltraps>

80106bf7 <vector245>:
.globl vector245
vector245:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $245
80106bf9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106bfe:	e9 4b f1 ff ff       	jmp    80105d4e <alltraps>

80106c03 <vector246>:
.globl vector246
vector246:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $246
80106c05:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c0a:	e9 3f f1 ff ff       	jmp    80105d4e <alltraps>

80106c0f <vector247>:
.globl vector247
vector247:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $247
80106c11:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c16:	e9 33 f1 ff ff       	jmp    80105d4e <alltraps>

80106c1b <vector248>:
.globl vector248
vector248:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $248
80106c1d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c22:	e9 27 f1 ff ff       	jmp    80105d4e <alltraps>

80106c27 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $249
80106c29:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c2e:	e9 1b f1 ff ff       	jmp    80105d4e <alltraps>

80106c33 <vector250>:
.globl vector250
vector250:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $250
80106c35:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c3a:	e9 0f f1 ff ff       	jmp    80105d4e <alltraps>

80106c3f <vector251>:
.globl vector251
vector251:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $251
80106c41:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c46:	e9 03 f1 ff ff       	jmp    80105d4e <alltraps>

80106c4b <vector252>:
.globl vector252
vector252:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $252
80106c4d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c52:	e9 f7 f0 ff ff       	jmp    80105d4e <alltraps>

80106c57 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $253
80106c59:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c5e:	e9 eb f0 ff ff       	jmp    80105d4e <alltraps>

80106c63 <vector254>:
.globl vector254
vector254:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $254
80106c65:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c6a:	e9 df f0 ff ff       	jmp    80105d4e <alltraps>

80106c6f <vector255>:
.globl vector255
vector255:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $255
80106c71:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c76:	e9 d3 f0 ff ff       	jmp    80105d4e <alltraps>
80106c7b:	66 90                	xchg   %ax,%ax
80106c7d:	66 90                	xchg   %ax,%ax
80106c7f:	90                   	nop

80106c80 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106c87:	c1 ea 16             	shr    $0x16,%edx
{
80106c8a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106c8b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106c8e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106c91:	8b 1f                	mov    (%edi),%ebx
80106c93:	f6 c3 01             	test   $0x1,%bl
80106c96:	74 28                	je     80106cc0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c98:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106c9e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ca4:	89 f0                	mov    %esi,%eax
}
80106ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106ca9:	c1 e8 0a             	shr    $0xa,%eax
80106cac:	25 fc 0f 00 00       	and    $0xffc,%eax
80106cb1:	01 d8                	add    %ebx,%eax
}
80106cb3:	5b                   	pop    %ebx
80106cb4:	5e                   	pop    %esi
80106cb5:	5f                   	pop    %edi
80106cb6:	5d                   	pop    %ebp
80106cb7:	c3                   	ret    
80106cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cbf:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106cc0:	85 c9                	test   %ecx,%ecx
80106cc2:	74 2c                	je     80106cf0 <walkpgdir+0x70>
80106cc4:	e8 47 be ff ff       	call   80102b10 <kalloc>
80106cc9:	89 c3                	mov    %eax,%ebx
80106ccb:	85 c0                	test   %eax,%eax
80106ccd:	74 21                	je     80106cf0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106ccf:	83 ec 04             	sub    $0x4,%esp
80106cd2:	68 00 10 00 00       	push   $0x1000
80106cd7:	6a 00                	push   $0x0
80106cd9:	50                   	push   %eax
80106cda:	e8 71 de ff ff       	call   80104b50 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106cdf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ce5:	83 c4 10             	add    $0x10,%esp
80106ce8:	83 c8 07             	or     $0x7,%eax
80106ceb:	89 07                	mov    %eax,(%edi)
80106ced:	eb b5                	jmp    80106ca4 <walkpgdir+0x24>
80106cef:	90                   	nop
}
80106cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106cf3:	31 c0                	xor    %eax,%eax
}
80106cf5:	5b                   	pop    %ebx
80106cf6:	5e                   	pop    %esi
80106cf7:	5f                   	pop    %edi
80106cf8:	5d                   	pop    %ebp
80106cf9:	c3                   	ret    
80106cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d00 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	57                   	push   %edi
80106d04:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d06:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106d0a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106d10:	89 d6                	mov    %edx,%esi
{
80106d12:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106d13:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106d19:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d1f:	8b 45 08             	mov    0x8(%ebp),%eax
80106d22:	29 f0                	sub    %esi,%eax
80106d24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d27:	eb 1f                	jmp    80106d48 <mappages+0x48>
80106d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106d30:	f6 00 01             	testb  $0x1,(%eax)
80106d33:	75 45                	jne    80106d7a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d35:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106d38:	83 cb 01             	or     $0x1,%ebx
80106d3b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106d3d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106d40:	74 2e                	je     80106d70 <mappages+0x70>
      break;
    a += PGSIZE;
80106d42:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106d48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d4b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106d50:	89 f2                	mov    %esi,%edx
80106d52:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106d55:	89 f8                	mov    %edi,%eax
80106d57:	e8 24 ff ff ff       	call   80106c80 <walkpgdir>
80106d5c:	85 c0                	test   %eax,%eax
80106d5e:	75 d0                	jne    80106d30 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d68:	5b                   	pop    %ebx
80106d69:	5e                   	pop    %esi
80106d6a:	5f                   	pop    %edi
80106d6b:	5d                   	pop    %ebp
80106d6c:	c3                   	ret    
80106d6d:	8d 76 00             	lea    0x0(%esi),%esi
80106d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d73:	31 c0                	xor    %eax,%eax
}
80106d75:	5b                   	pop    %ebx
80106d76:	5e                   	pop    %esi
80106d77:	5f                   	pop    %edi
80106d78:	5d                   	pop    %ebp
80106d79:	c3                   	ret    
      panic("remap");
80106d7a:	83 ec 0c             	sub    $0xc,%esp
80106d7d:	68 68 7e 10 80       	push   $0x80107e68
80106d82:	e8 79 99 ff ff       	call   80100700 <panic>
80106d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d8e:	66 90                	xchg   %ax,%ax

80106d90 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	57                   	push   %edi
80106d94:	56                   	push   %esi
80106d95:	89 c6                	mov    %eax,%esi
80106d97:	53                   	push   %ebx
80106d98:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106d9a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106da0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106da6:	83 ec 1c             	sub    $0x1c,%esp
80106da9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106dac:	39 da                	cmp    %ebx,%edx
80106dae:	73 5b                	jae    80106e0b <deallocuvm.part.0+0x7b>
80106db0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106db3:	89 d7                	mov    %edx,%edi
80106db5:	eb 14                	jmp    80106dcb <deallocuvm.part.0+0x3b>
80106db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dbe:	66 90                	xchg   %ax,%ax
80106dc0:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106dc6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106dc9:	76 40                	jbe    80106e0b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106dcb:	31 c9                	xor    %ecx,%ecx
80106dcd:	89 fa                	mov    %edi,%edx
80106dcf:	89 f0                	mov    %esi,%eax
80106dd1:	e8 aa fe ff ff       	call   80106c80 <walkpgdir>
80106dd6:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106dd8:	85 c0                	test   %eax,%eax
80106dda:	74 44                	je     80106e20 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106ddc:	8b 00                	mov    (%eax),%eax
80106dde:	a8 01                	test   $0x1,%al
80106de0:	74 de                	je     80106dc0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106de2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106de7:	74 47                	je     80106e30 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106de9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106dec:	05 00 00 00 80       	add    $0x80000000,%eax
80106df1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106df7:	50                   	push   %eax
80106df8:	e8 53 bb ff ff       	call   80102950 <kfree>
      *pte = 0;
80106dfd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106e03:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106e06:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106e09:	77 c0                	ja     80106dcb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80106e0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e11:	5b                   	pop    %ebx
80106e12:	5e                   	pop    %esi
80106e13:	5f                   	pop    %edi
80106e14:	5d                   	pop    %ebp
80106e15:	c3                   	ret    
80106e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e1d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106e20:	89 fa                	mov    %edi,%edx
80106e22:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106e28:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80106e2e:	eb 96                	jmp    80106dc6 <deallocuvm.part.0+0x36>
        panic("kfree");
80106e30:	83 ec 0c             	sub    $0xc,%esp
80106e33:	68 16 78 10 80       	push   $0x80107816
80106e38:	e8 c3 98 ff ff       	call   80100700 <panic>
80106e3d:	8d 76 00             	lea    0x0(%esi),%esi

80106e40 <seginit>:
{
80106e40:	f3 0f 1e fb          	endbr32 
80106e44:	55                   	push   %ebp
80106e45:	89 e5                	mov    %esp,%ebp
80106e47:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e4a:	e8 d1 cf ff ff       	call   80103e20 <cpuid>
  pd[0] = size-1;
80106e4f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106e54:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106e5a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e5e:	c7 80 58 30 11 80 ff 	movl   $0xffff,-0x7feecfa8(%eax)
80106e65:	ff 00 00 
80106e68:	c7 80 5c 30 11 80 00 	movl   $0xcf9a00,-0x7feecfa4(%eax)
80106e6f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e72:	c7 80 60 30 11 80 ff 	movl   $0xffff,-0x7feecfa0(%eax)
80106e79:	ff 00 00 
80106e7c:	c7 80 64 30 11 80 00 	movl   $0xcf9200,-0x7feecf9c(%eax)
80106e83:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e86:	c7 80 68 30 11 80 ff 	movl   $0xffff,-0x7feecf98(%eax)
80106e8d:	ff 00 00 
80106e90:	c7 80 6c 30 11 80 00 	movl   $0xcffa00,-0x7feecf94(%eax)
80106e97:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e9a:	c7 80 70 30 11 80 ff 	movl   $0xffff,-0x7feecf90(%eax)
80106ea1:	ff 00 00 
80106ea4:	c7 80 74 30 11 80 00 	movl   $0xcff200,-0x7feecf8c(%eax)
80106eab:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106eae:	05 50 30 11 80       	add    $0x80113050,%eax
  pd[1] = (uint)p;
80106eb3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106eb7:	c1 e8 10             	shr    $0x10,%eax
80106eba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106ebe:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ec1:	0f 01 10             	lgdtl  (%eax)
}
80106ec4:	c9                   	leave  
80106ec5:	c3                   	ret    
80106ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ecd:	8d 76 00             	lea    0x0(%esi),%esi

80106ed0 <switchkvm>:
{
80106ed0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ed4:	a1 04 5d 11 80       	mov    0x80115d04,%eax
80106ed9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ede:	0f 22 d8             	mov    %eax,%cr3
}
80106ee1:	c3                   	ret    
80106ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ef0 <switchuvm>:
{
80106ef0:	f3 0f 1e fb          	endbr32 
80106ef4:	55                   	push   %ebp
80106ef5:	89 e5                	mov    %esp,%ebp
80106ef7:	57                   	push   %edi
80106ef8:	56                   	push   %esi
80106ef9:	53                   	push   %ebx
80106efa:	83 ec 1c             	sub    $0x1c,%esp
80106efd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106f00:	85 f6                	test   %esi,%esi
80106f02:	0f 84 cb 00 00 00    	je     80106fd3 <switchuvm+0xe3>
  if(p->kstack == 0)
80106f08:	8b 46 08             	mov    0x8(%esi),%eax
80106f0b:	85 c0                	test   %eax,%eax
80106f0d:	0f 84 da 00 00 00    	je     80106fed <switchuvm+0xfd>
  if(p->pgdir == 0)
80106f13:	8b 46 04             	mov    0x4(%esi),%eax
80106f16:	85 c0                	test   %eax,%eax
80106f18:	0f 84 c2 00 00 00    	je     80106fe0 <switchuvm+0xf0>
  pushcli();
80106f1e:	e8 1d da ff ff       	call   80104940 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f23:	e8 88 ce ff ff       	call   80103db0 <mycpu>
80106f28:	89 c3                	mov    %eax,%ebx
80106f2a:	e8 81 ce ff ff       	call   80103db0 <mycpu>
80106f2f:	89 c7                	mov    %eax,%edi
80106f31:	e8 7a ce ff ff       	call   80103db0 <mycpu>
80106f36:	83 c7 08             	add    $0x8,%edi
80106f39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f3c:	e8 6f ce ff ff       	call   80103db0 <mycpu>
80106f41:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f44:	ba 67 00 00 00       	mov    $0x67,%edx
80106f49:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f50:	83 c0 08             	add    $0x8,%eax
80106f53:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f5a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f5f:	83 c1 08             	add    $0x8,%ecx
80106f62:	c1 e8 18             	shr    $0x18,%eax
80106f65:	c1 e9 10             	shr    $0x10,%ecx
80106f68:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f6e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f74:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f79:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f80:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106f85:	e8 26 ce ff ff       	call   80103db0 <mycpu>
80106f8a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f91:	e8 1a ce ff ff       	call   80103db0 <mycpu>
80106f96:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f9a:	8b 5e 08             	mov    0x8(%esi),%ebx
80106f9d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fa3:	e8 08 ce ff ff       	call   80103db0 <mycpu>
80106fa8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fab:	e8 00 ce ff ff       	call   80103db0 <mycpu>
80106fb0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106fb4:	b8 28 00 00 00       	mov    $0x28,%eax
80106fb9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106fbc:	8b 46 04             	mov    0x4(%esi),%eax
80106fbf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fc4:	0f 22 d8             	mov    %eax,%cr3
}
80106fc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fca:	5b                   	pop    %ebx
80106fcb:	5e                   	pop    %esi
80106fcc:	5f                   	pop    %edi
80106fcd:	5d                   	pop    %ebp
  popcli();
80106fce:	e9 bd d9 ff ff       	jmp    80104990 <popcli>
    panic("switchuvm: no process");
80106fd3:	83 ec 0c             	sub    $0xc,%esp
80106fd6:	68 6e 7e 10 80       	push   $0x80107e6e
80106fdb:	e8 20 97 ff ff       	call   80100700 <panic>
    panic("switchuvm: no pgdir");
80106fe0:	83 ec 0c             	sub    $0xc,%esp
80106fe3:	68 99 7e 10 80       	push   $0x80107e99
80106fe8:	e8 13 97 ff ff       	call   80100700 <panic>
    panic("switchuvm: no kstack");
80106fed:	83 ec 0c             	sub    $0xc,%esp
80106ff0:	68 84 7e 10 80       	push   $0x80107e84
80106ff5:	e8 06 97 ff ff       	call   80100700 <panic>
80106ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107000 <inituvm>:
{
80107000:	f3 0f 1e fb          	endbr32 
80107004:	55                   	push   %ebp
80107005:	89 e5                	mov    %esp,%ebp
80107007:	57                   	push   %edi
80107008:	56                   	push   %esi
80107009:	53                   	push   %ebx
8010700a:	83 ec 1c             	sub    $0x1c,%esp
8010700d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107010:	8b 75 10             	mov    0x10(%ebp),%esi
80107013:	8b 7d 08             	mov    0x8(%ebp),%edi
80107016:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107019:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010701f:	77 4b                	ja     8010706c <inituvm+0x6c>
  mem = kalloc();
80107021:	e8 ea ba ff ff       	call   80102b10 <kalloc>
  memset(mem, 0, PGSIZE);
80107026:	83 ec 04             	sub    $0x4,%esp
80107029:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010702e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107030:	6a 00                	push   $0x0
80107032:	50                   	push   %eax
80107033:	e8 18 db ff ff       	call   80104b50 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107038:	58                   	pop    %eax
80107039:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010703f:	5a                   	pop    %edx
80107040:	6a 06                	push   $0x6
80107042:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107047:	31 d2                	xor    %edx,%edx
80107049:	50                   	push   %eax
8010704a:	89 f8                	mov    %edi,%eax
8010704c:	e8 af fc ff ff       	call   80106d00 <mappages>
  memmove(mem, init, sz);
80107051:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107054:	89 75 10             	mov    %esi,0x10(%ebp)
80107057:	83 c4 10             	add    $0x10,%esp
8010705a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010705d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107060:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107063:	5b                   	pop    %ebx
80107064:	5e                   	pop    %esi
80107065:	5f                   	pop    %edi
80107066:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107067:	e9 84 db ff ff       	jmp    80104bf0 <memmove>
    panic("inituvm: more than a page");
8010706c:	83 ec 0c             	sub    $0xc,%esp
8010706f:	68 ad 7e 10 80       	push   $0x80107ead
80107074:	e8 87 96 ff ff       	call   80100700 <panic>
80107079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107080 <loaduvm>:
{
80107080:	f3 0f 1e fb          	endbr32 
80107084:	55                   	push   %ebp
80107085:	89 e5                	mov    %esp,%ebp
80107087:	57                   	push   %edi
80107088:	56                   	push   %esi
80107089:	53                   	push   %ebx
8010708a:	83 ec 1c             	sub    $0x1c,%esp
8010708d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107090:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107093:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107098:	0f 85 99 00 00 00    	jne    80107137 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010709e:	01 f0                	add    %esi,%eax
801070a0:	89 f3                	mov    %esi,%ebx
801070a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070a5:	8b 45 14             	mov    0x14(%ebp),%eax
801070a8:	01 f0                	add    %esi,%eax
801070aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801070ad:	85 f6                	test   %esi,%esi
801070af:	75 15                	jne    801070c6 <loaduvm+0x46>
801070b1:	eb 6d                	jmp    80107120 <loaduvm+0xa0>
801070b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070b7:	90                   	nop
801070b8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801070be:	89 f0                	mov    %esi,%eax
801070c0:	29 d8                	sub    %ebx,%eax
801070c2:	39 c6                	cmp    %eax,%esi
801070c4:	76 5a                	jbe    80107120 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801070c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801070c9:	8b 45 08             	mov    0x8(%ebp),%eax
801070cc:	31 c9                	xor    %ecx,%ecx
801070ce:	29 da                	sub    %ebx,%edx
801070d0:	e8 ab fb ff ff       	call   80106c80 <walkpgdir>
801070d5:	85 c0                	test   %eax,%eax
801070d7:	74 51                	je     8010712a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801070d9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801070de:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801070e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801070e8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801070ee:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070f1:	29 d9                	sub    %ebx,%ecx
801070f3:	05 00 00 00 80       	add    $0x80000000,%eax
801070f8:	57                   	push   %edi
801070f9:	51                   	push   %ecx
801070fa:	50                   	push   %eax
801070fb:	ff 75 10             	pushl  0x10(%ebp)
801070fe:	e8 3d ae ff ff       	call   80101f40 <readi>
80107103:	83 c4 10             	add    $0x10,%esp
80107106:	39 f8                	cmp    %edi,%eax
80107108:	74 ae                	je     801070b8 <loaduvm+0x38>
}
8010710a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010710d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107112:	5b                   	pop    %ebx
80107113:	5e                   	pop    %esi
80107114:	5f                   	pop    %edi
80107115:	5d                   	pop    %ebp
80107116:	c3                   	ret    
80107117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010711e:	66 90                	xchg   %ax,%ax
80107120:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107123:	31 c0                	xor    %eax,%eax
}
80107125:	5b                   	pop    %ebx
80107126:	5e                   	pop    %esi
80107127:	5f                   	pop    %edi
80107128:	5d                   	pop    %ebp
80107129:	c3                   	ret    
      panic("loaduvm: address should exist");
8010712a:	83 ec 0c             	sub    $0xc,%esp
8010712d:	68 c7 7e 10 80       	push   $0x80107ec7
80107132:	e8 c9 95 ff ff       	call   80100700 <panic>
    panic("loaduvm: addr must be page aligned");
80107137:	83 ec 0c             	sub    $0xc,%esp
8010713a:	68 68 7f 10 80       	push   $0x80107f68
8010713f:	e8 bc 95 ff ff       	call   80100700 <panic>
80107144:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010714b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010714f:	90                   	nop

80107150 <allocuvm>:
{
80107150:	f3 0f 1e fb          	endbr32 
80107154:	55                   	push   %ebp
80107155:	89 e5                	mov    %esp,%ebp
80107157:	57                   	push   %edi
80107158:	56                   	push   %esi
80107159:	53                   	push   %ebx
8010715a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010715d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107160:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107163:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107166:	85 c0                	test   %eax,%eax
80107168:	0f 88 b2 00 00 00    	js     80107220 <allocuvm+0xd0>
  if(newsz < oldsz)
8010716e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107171:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107174:	0f 82 96 00 00 00    	jb     80107210 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010717a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107180:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107186:	39 75 10             	cmp    %esi,0x10(%ebp)
80107189:	77 40                	ja     801071cb <allocuvm+0x7b>
8010718b:	e9 83 00 00 00       	jmp    80107213 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107190:	83 ec 04             	sub    $0x4,%esp
80107193:	68 00 10 00 00       	push   $0x1000
80107198:	6a 00                	push   $0x0
8010719a:	50                   	push   %eax
8010719b:	e8 b0 d9 ff ff       	call   80104b50 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801071a0:	58                   	pop    %eax
801071a1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071a7:	5a                   	pop    %edx
801071a8:	6a 06                	push   $0x6
801071aa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071af:	89 f2                	mov    %esi,%edx
801071b1:	50                   	push   %eax
801071b2:	89 f8                	mov    %edi,%eax
801071b4:	e8 47 fb ff ff       	call   80106d00 <mappages>
801071b9:	83 c4 10             	add    $0x10,%esp
801071bc:	85 c0                	test   %eax,%eax
801071be:	78 78                	js     80107238 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801071c0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801071c6:	39 75 10             	cmp    %esi,0x10(%ebp)
801071c9:	76 48                	jbe    80107213 <allocuvm+0xc3>
    mem = kalloc();
801071cb:	e8 40 b9 ff ff       	call   80102b10 <kalloc>
801071d0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801071d2:	85 c0                	test   %eax,%eax
801071d4:	75 ba                	jne    80107190 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801071d6:	83 ec 0c             	sub    $0xc,%esp
801071d9:	68 e5 7e 10 80       	push   $0x80107ee5
801071de:	e8 9d 95 ff ff       	call   80100780 <cprintf>
  if(newsz >= oldsz)
801071e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801071e6:	83 c4 10             	add    $0x10,%esp
801071e9:	39 45 10             	cmp    %eax,0x10(%ebp)
801071ec:	74 32                	je     80107220 <allocuvm+0xd0>
801071ee:	8b 55 10             	mov    0x10(%ebp),%edx
801071f1:	89 c1                	mov    %eax,%ecx
801071f3:	89 f8                	mov    %edi,%eax
801071f5:	e8 96 fb ff ff       	call   80106d90 <deallocuvm.part.0>
      return 0;
801071fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107201:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107204:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107207:	5b                   	pop    %ebx
80107208:	5e                   	pop    %esi
80107209:	5f                   	pop    %edi
8010720a:	5d                   	pop    %ebp
8010720b:	c3                   	ret    
8010720c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107210:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107213:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107216:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107219:	5b                   	pop    %ebx
8010721a:	5e                   	pop    %esi
8010721b:	5f                   	pop    %edi
8010721c:	5d                   	pop    %ebp
8010721d:	c3                   	ret    
8010721e:	66 90                	xchg   %ax,%ax
    return 0;
80107220:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107227:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010722a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010722d:	5b                   	pop    %ebx
8010722e:	5e                   	pop    %esi
8010722f:	5f                   	pop    %edi
80107230:	5d                   	pop    %ebp
80107231:	c3                   	ret    
80107232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107238:	83 ec 0c             	sub    $0xc,%esp
8010723b:	68 fd 7e 10 80       	push   $0x80107efd
80107240:	e8 3b 95 ff ff       	call   80100780 <cprintf>
  if(newsz >= oldsz)
80107245:	8b 45 0c             	mov    0xc(%ebp),%eax
80107248:	83 c4 10             	add    $0x10,%esp
8010724b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010724e:	74 0c                	je     8010725c <allocuvm+0x10c>
80107250:	8b 55 10             	mov    0x10(%ebp),%edx
80107253:	89 c1                	mov    %eax,%ecx
80107255:	89 f8                	mov    %edi,%eax
80107257:	e8 34 fb ff ff       	call   80106d90 <deallocuvm.part.0>
      kfree(mem);
8010725c:	83 ec 0c             	sub    $0xc,%esp
8010725f:	53                   	push   %ebx
80107260:	e8 eb b6 ff ff       	call   80102950 <kfree>
      return 0;
80107265:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010726c:	83 c4 10             	add    $0x10,%esp
}
8010726f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107272:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107275:	5b                   	pop    %ebx
80107276:	5e                   	pop    %esi
80107277:	5f                   	pop    %edi
80107278:	5d                   	pop    %ebp
80107279:	c3                   	ret    
8010727a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107280 <deallocuvm>:
{
80107280:	f3 0f 1e fb          	endbr32 
80107284:	55                   	push   %ebp
80107285:	89 e5                	mov    %esp,%ebp
80107287:	8b 55 0c             	mov    0xc(%ebp),%edx
8010728a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010728d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107290:	39 d1                	cmp    %edx,%ecx
80107292:	73 0c                	jae    801072a0 <deallocuvm+0x20>
}
80107294:	5d                   	pop    %ebp
80107295:	e9 f6 fa ff ff       	jmp    80106d90 <deallocuvm.part.0>
8010729a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072a0:	89 d0                	mov    %edx,%eax
801072a2:	5d                   	pop    %ebp
801072a3:	c3                   	ret    
801072a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072af:	90                   	nop

801072b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801072b0:	f3 0f 1e fb          	endbr32 
801072b4:	55                   	push   %ebp
801072b5:	89 e5                	mov    %esp,%ebp
801072b7:	57                   	push   %edi
801072b8:	56                   	push   %esi
801072b9:	53                   	push   %ebx
801072ba:	83 ec 0c             	sub    $0xc,%esp
801072bd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801072c0:	85 f6                	test   %esi,%esi
801072c2:	74 55                	je     80107319 <freevm+0x69>
  if(newsz >= oldsz)
801072c4:	31 c9                	xor    %ecx,%ecx
801072c6:	ba 00 00 00 80       	mov    $0x80000000,%edx
801072cb:	89 f0                	mov    %esi,%eax
801072cd:	89 f3                	mov    %esi,%ebx
801072cf:	e8 bc fa ff ff       	call   80106d90 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072d4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801072da:	eb 0b                	jmp    801072e7 <freevm+0x37>
801072dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072e0:	83 c3 04             	add    $0x4,%ebx
801072e3:	39 df                	cmp    %ebx,%edi
801072e5:	74 23                	je     8010730a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072e7:	8b 03                	mov    (%ebx),%eax
801072e9:	a8 01                	test   $0x1,%al
801072eb:	74 f3                	je     801072e0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801072f2:	83 ec 0c             	sub    $0xc,%esp
801072f5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072f8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801072fd:	50                   	push   %eax
801072fe:	e8 4d b6 ff ff       	call   80102950 <kfree>
80107303:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107306:	39 df                	cmp    %ebx,%edi
80107308:	75 dd                	jne    801072e7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010730a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010730d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107310:	5b                   	pop    %ebx
80107311:	5e                   	pop    %esi
80107312:	5f                   	pop    %edi
80107313:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107314:	e9 37 b6 ff ff       	jmp    80102950 <kfree>
    panic("freevm: no pgdir");
80107319:	83 ec 0c             	sub    $0xc,%esp
8010731c:	68 19 7f 10 80       	push   $0x80107f19
80107321:	e8 da 93 ff ff       	call   80100700 <panic>
80107326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010732d:	8d 76 00             	lea    0x0(%esi),%esi

80107330 <setupkvm>:
{
80107330:	f3 0f 1e fb          	endbr32 
80107334:	55                   	push   %ebp
80107335:	89 e5                	mov    %esp,%ebp
80107337:	56                   	push   %esi
80107338:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107339:	e8 d2 b7 ff ff       	call   80102b10 <kalloc>
8010733e:	89 c6                	mov    %eax,%esi
80107340:	85 c0                	test   %eax,%eax
80107342:	74 42                	je     80107386 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107344:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107347:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
8010734c:	68 00 10 00 00       	push   $0x1000
80107351:	6a 00                	push   $0x0
80107353:	50                   	push   %eax
80107354:	e8 f7 d7 ff ff       	call   80104b50 <memset>
80107359:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010735c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010735f:	83 ec 08             	sub    $0x8,%esp
80107362:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107365:	ff 73 0c             	pushl  0xc(%ebx)
80107368:	8b 13                	mov    (%ebx),%edx
8010736a:	50                   	push   %eax
8010736b:	29 c1                	sub    %eax,%ecx
8010736d:	89 f0                	mov    %esi,%eax
8010736f:	e8 8c f9 ff ff       	call   80106d00 <mappages>
80107374:	83 c4 10             	add    $0x10,%esp
80107377:	85 c0                	test   %eax,%eax
80107379:	78 15                	js     80107390 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010737b:	83 c3 10             	add    $0x10,%ebx
8010737e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107384:	75 d6                	jne    8010735c <setupkvm+0x2c>
}
80107386:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107389:	89 f0                	mov    %esi,%eax
8010738b:	5b                   	pop    %ebx
8010738c:	5e                   	pop    %esi
8010738d:	5d                   	pop    %ebp
8010738e:	c3                   	ret    
8010738f:	90                   	nop
      freevm(pgdir);
80107390:	83 ec 0c             	sub    $0xc,%esp
80107393:	56                   	push   %esi
      return 0;
80107394:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107396:	e8 15 ff ff ff       	call   801072b0 <freevm>
      return 0;
8010739b:	83 c4 10             	add    $0x10,%esp
}
8010739e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073a1:	89 f0                	mov    %esi,%eax
801073a3:	5b                   	pop    %ebx
801073a4:	5e                   	pop    %esi
801073a5:	5d                   	pop    %ebp
801073a6:	c3                   	ret    
801073a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ae:	66 90                	xchg   %ax,%ax

801073b0 <kvmalloc>:
{
801073b0:	f3 0f 1e fb          	endbr32 
801073b4:	55                   	push   %ebp
801073b5:	89 e5                	mov    %esp,%ebp
801073b7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801073ba:	e8 71 ff ff ff       	call   80107330 <setupkvm>
801073bf:	a3 04 5d 11 80       	mov    %eax,0x80115d04
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073c4:	05 00 00 00 80       	add    $0x80000000,%eax
801073c9:	0f 22 d8             	mov    %eax,%cr3
}
801073cc:	c9                   	leave  
801073cd:	c3                   	ret    
801073ce:	66 90                	xchg   %ax,%ax

801073d0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801073d0:	f3 0f 1e fb          	endbr32 
801073d4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801073d5:	31 c9                	xor    %ecx,%ecx
{
801073d7:	89 e5                	mov    %esp,%ebp
801073d9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801073dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801073df:	8b 45 08             	mov    0x8(%ebp),%eax
801073e2:	e8 99 f8 ff ff       	call   80106c80 <walkpgdir>
  if(pte == 0)
801073e7:	85 c0                	test   %eax,%eax
801073e9:	74 05                	je     801073f0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801073eb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801073ee:	c9                   	leave  
801073ef:	c3                   	ret    
    panic("clearpteu");
801073f0:	83 ec 0c             	sub    $0xc,%esp
801073f3:	68 2a 7f 10 80       	push   $0x80107f2a
801073f8:	e8 03 93 ff ff       	call   80100700 <panic>
801073fd:	8d 76 00             	lea    0x0(%esi),%esi

80107400 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107400:	f3 0f 1e fb          	endbr32 
80107404:	55                   	push   %ebp
80107405:	89 e5                	mov    %esp,%ebp
80107407:	57                   	push   %edi
80107408:	56                   	push   %esi
80107409:	53                   	push   %ebx
8010740a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010740d:	e8 1e ff ff ff       	call   80107330 <setupkvm>
80107412:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107415:	85 c0                	test   %eax,%eax
80107417:	0f 84 9b 00 00 00    	je     801074b8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010741d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107420:	85 c9                	test   %ecx,%ecx
80107422:	0f 84 90 00 00 00    	je     801074b8 <copyuvm+0xb8>
80107428:	31 f6                	xor    %esi,%esi
8010742a:	eb 46                	jmp    80107472 <copyuvm+0x72>
8010742c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107430:	83 ec 04             	sub    $0x4,%esp
80107433:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107439:	68 00 10 00 00       	push   $0x1000
8010743e:	57                   	push   %edi
8010743f:	50                   	push   %eax
80107440:	e8 ab d7 ff ff       	call   80104bf0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107445:	58                   	pop    %eax
80107446:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010744c:	5a                   	pop    %edx
8010744d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107450:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107455:	89 f2                	mov    %esi,%edx
80107457:	50                   	push   %eax
80107458:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010745b:	e8 a0 f8 ff ff       	call   80106d00 <mappages>
80107460:	83 c4 10             	add    $0x10,%esp
80107463:	85 c0                	test   %eax,%eax
80107465:	78 61                	js     801074c8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107467:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010746d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107470:	76 46                	jbe    801074b8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107472:	8b 45 08             	mov    0x8(%ebp),%eax
80107475:	31 c9                	xor    %ecx,%ecx
80107477:	89 f2                	mov    %esi,%edx
80107479:	e8 02 f8 ff ff       	call   80106c80 <walkpgdir>
8010747e:	85 c0                	test   %eax,%eax
80107480:	74 61                	je     801074e3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107482:	8b 00                	mov    (%eax),%eax
80107484:	a8 01                	test   $0x1,%al
80107486:	74 4e                	je     801074d6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107488:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010748a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010748f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107492:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107498:	e8 73 b6 ff ff       	call   80102b10 <kalloc>
8010749d:	89 c3                	mov    %eax,%ebx
8010749f:	85 c0                	test   %eax,%eax
801074a1:	75 8d                	jne    80107430 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801074a3:	83 ec 0c             	sub    $0xc,%esp
801074a6:	ff 75 e0             	pushl  -0x20(%ebp)
801074a9:	e8 02 fe ff ff       	call   801072b0 <freevm>
  return 0;
801074ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801074b5:	83 c4 10             	add    $0x10,%esp
}
801074b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074be:	5b                   	pop    %ebx
801074bf:	5e                   	pop    %esi
801074c0:	5f                   	pop    %edi
801074c1:	5d                   	pop    %ebp
801074c2:	c3                   	ret    
801074c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074c7:	90                   	nop
      kfree(mem);
801074c8:	83 ec 0c             	sub    $0xc,%esp
801074cb:	53                   	push   %ebx
801074cc:	e8 7f b4 ff ff       	call   80102950 <kfree>
      goto bad;
801074d1:	83 c4 10             	add    $0x10,%esp
801074d4:	eb cd                	jmp    801074a3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801074d6:	83 ec 0c             	sub    $0xc,%esp
801074d9:	68 4e 7f 10 80       	push   $0x80107f4e
801074de:	e8 1d 92 ff ff       	call   80100700 <panic>
      panic("copyuvm: pte should exist");
801074e3:	83 ec 0c             	sub    $0xc,%esp
801074e6:	68 34 7f 10 80       	push   $0x80107f34
801074eb:	e8 10 92 ff ff       	call   80100700 <panic>

801074f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801074f0:	f3 0f 1e fb          	endbr32 
801074f4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801074f5:	31 c9                	xor    %ecx,%ecx
{
801074f7:	89 e5                	mov    %esp,%ebp
801074f9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801074fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801074ff:	8b 45 08             	mov    0x8(%ebp),%eax
80107502:	e8 79 f7 ff ff       	call   80106c80 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107507:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107509:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010750a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010750c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107511:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107514:	05 00 00 00 80       	add    $0x80000000,%eax
80107519:	83 fa 05             	cmp    $0x5,%edx
8010751c:	ba 00 00 00 00       	mov    $0x0,%edx
80107521:	0f 45 c2             	cmovne %edx,%eax
}
80107524:	c3                   	ret    
80107525:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010752c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107530 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107530:	f3 0f 1e fb          	endbr32 
80107534:	55                   	push   %ebp
80107535:	89 e5                	mov    %esp,%ebp
80107537:	57                   	push   %edi
80107538:	56                   	push   %esi
80107539:	53                   	push   %ebx
8010753a:	83 ec 0c             	sub    $0xc,%esp
8010753d:	8b 75 14             	mov    0x14(%ebp),%esi
80107540:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107543:	85 f6                	test   %esi,%esi
80107545:	75 3c                	jne    80107583 <copyout+0x53>
80107547:	eb 67                	jmp    801075b0 <copyout+0x80>
80107549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107550:	8b 55 0c             	mov    0xc(%ebp),%edx
80107553:	89 fb                	mov    %edi,%ebx
80107555:	29 d3                	sub    %edx,%ebx
80107557:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010755d:	39 f3                	cmp    %esi,%ebx
8010755f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107562:	29 fa                	sub    %edi,%edx
80107564:	83 ec 04             	sub    $0x4,%esp
80107567:	01 c2                	add    %eax,%edx
80107569:	53                   	push   %ebx
8010756a:	ff 75 10             	pushl  0x10(%ebp)
8010756d:	52                   	push   %edx
8010756e:	e8 7d d6 ff ff       	call   80104bf0 <memmove>
    len -= n;
    buf += n;
80107573:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107576:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010757c:	83 c4 10             	add    $0x10,%esp
8010757f:	29 de                	sub    %ebx,%esi
80107581:	74 2d                	je     801075b0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107583:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107585:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107588:	89 55 0c             	mov    %edx,0xc(%ebp)
8010758b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107591:	57                   	push   %edi
80107592:	ff 75 08             	pushl  0x8(%ebp)
80107595:	e8 56 ff ff ff       	call   801074f0 <uva2ka>
    if(pa0 == 0)
8010759a:	83 c4 10             	add    $0x10,%esp
8010759d:	85 c0                	test   %eax,%eax
8010759f:	75 af                	jne    80107550 <copyout+0x20>
  }
  return 0;
}
801075a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801075a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075a9:	5b                   	pop    %ebx
801075aa:	5e                   	pop    %esi
801075ab:	5f                   	pop    %edi
801075ac:	5d                   	pop    %ebp
801075ad:	c3                   	ret    
801075ae:	66 90                	xchg   %ax,%ax
801075b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075b3:	31 c0                	xor    %eax,%eax
}
801075b5:	5b                   	pop    %ebx
801075b6:	5e                   	pop    %esi
801075b7:	5f                   	pop    %edi
801075b8:	5d                   	pop    %ebp
801075b9:	c3                   	ret    
