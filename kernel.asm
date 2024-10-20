
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
8010002d:	b8 a0 36 10 80       	mov    $0x801036a0,%eax
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
80100050:	68 40 77 10 80       	push   $0x80107740
80100055:	68 e0 c5 10 80       	push   $0x8010c5e0
8010005a:	e8 e1 49 00 00       	call   80104a40 <initlock>
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
80100092:	68 47 77 10 80       	push   $0x80107747
80100097:	50                   	push   %eax
80100098:	e8 63 48 00 00       	call   80104900 <initsleeplock>
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
801000e8:	e8 d3 4a 00 00       	call   80104bc0 <acquire>
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
80100162:	e8 19 4b 00 00       	call   80104c80 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 47 00 00       	call   80104940 <acquiresleep>
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
8010018c:	e8 4f 27 00 00       	call   801028e0 <iderw>
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
801001a3:	68 4e 77 10 80       	push   $0x8010774e
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
801001c2:	e8 19 48 00 00       	call   801049e0 <holdingsleep>
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
801001d8:	e9 03 27 00 00       	jmp    801028e0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 5f 77 10 80       	push   $0x8010775f
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
80100203:	e8 d8 47 00 00       	call   801049e0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 88 47 00 00       	call   801049a0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010021f:	e8 9c 49 00 00       	call   80104bc0 <acquire>
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
80100270:	e9 0b 4a 00 00       	jmp    80104c80 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 66 77 10 80       	push   $0x80107766
8010027d:	e8 7e 04 00 00       	call   80100700 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:

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
801002a5:	e8 f6 1b 00 00       	call   80101ea0 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
801002b1:	e8 0a 49 00 00       	call   80104bc0 <acquire>
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
801002c6:	a1 f4 17 11 80       	mov    0x801117f4,%eax
801002cb:	3b 05 f8 17 11 80    	cmp    0x801117f8,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 40 b5 10 80       	push   $0x8010b540
801002e0:	68 f4 17 11 80       	push   $0x801117f4
801002e5:	e8 96 42 00 00       	call   80104580 <sleep>
    while(input.r == input.w){
801002ea:	a1 f4 17 11 80       	mov    0x801117f4,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 f8 17 11 80    	cmp    0x801117f8,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 c1 3c 00 00       	call   80103fc0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&input.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 40 17 11 80       	push   $0x80111740
8010030e:	e8 6d 49 00 00       	call   80104c80 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 a4 1a 00 00       	call   80101dc0 <ilock>
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
80100333:	89 15 f4 17 11 80    	mov    %edx,0x801117f4
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 74 17 11 80 	movsbl -0x7feee88c(%edx),%ecx
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
80100360:	68 40 b5 10 80       	push   $0x8010b540
80100365:	e8 16 49 00 00       	call   80104c80 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 4d 1a 00 00       	call   80101dc0 <ilock>
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
80100386:	a3 f4 17 11 80       	mov    %eax,0x801117f4
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
801003aa:	e8 91 5f 00 00       	call   80106340 <uartputc>
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
801004a2:	e8 c9 48 00 00       	call   80104d70 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004a7:	b8 80 07 00 00       	mov    $0x780,%eax
801004ac:	83 c4 0c             	add    $0xc,%esp
801004af:	29 d8                	sub    %ebx,%eax
801004b1:	01 c0                	add    %eax,%eax
801004b3:	50                   	push   %eax
801004b4:	6a 00                	push   $0x0
801004b6:	56                   	push   %esi
801004b7:	e8 14 48 00 00       	call   80104cd0 <memset>
801004bc:	88 5d e7             	mov    %bl,-0x19(%ebp)
801004bf:	83 c4 10             	add    $0x10,%esp
801004c2:	e9 51 ff ff ff       	jmp    80100418 <consputc.part.0+0x88>
801004c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801004ce:	66 90                	xchg   %ax,%ax
    uartputc('\b'); 
801004d0:	83 ec 0c             	sub    $0xc,%esp
801004d3:	6a 08                	push   $0x8
801004d5:	e8 66 5e 00 00       	call   80106340 <uartputc>
    uartputc(' '); 
801004da:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004e1:	e8 5a 5e 00 00       	call   80106340 <uartputc>
    uartputc('\b');
801004e6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004ed:	e8 4e 5e 00 00       	call   80106340 <uartputc>
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
80100529:	0f b6 92 d8 77 10 80 	movzbl -0x7fef8828(%edx),%edx
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
80100563:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
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
801005b3:	e8 e8 18 00 00       	call   80101ea0 <iunlock>
  acquire(&cons.lock);
801005b8:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
801005bf:	e8 fc 45 00 00       	call   80104bc0 <acquire>
  for(i = 0; i < n; i++)
801005c4:	83 c4 10             	add    $0x10,%esp
801005c7:	85 db                	test   %ebx,%ebx
801005c9:	7e 24                	jle    801005ef <consolewrite+0x4f>
801005cb:	8b 7d 0c             	mov    0xc(%ebp),%edi
801005ce:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
801005d1:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
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
801005f2:	68 40 b5 10 80       	push   $0x8010b540
801005f7:	e8 84 46 00 00       	call   80104c80 <release>
  ilock(ip);
801005fc:	58                   	pop    %eax
801005fd:	ff 75 08             	pushl  0x8(%ebp)
80100600:	e8 bb 17 00 00       	call   80101dc0 <ilock>

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
8010061c:	e8 af 48 00 00       	call   80104ed0 <strlen>
80100621:	c7 45 e0 7f 00 00 00 	movl   $0x7f,-0x20(%ebp)
80100628:	83 c4 10             	add    $0x10,%esp
8010062b:	c7 45 e4 7f 00 00 00 	movl   $0x7f,-0x1c(%ebp)
80100632:	3d 80 00 00 00       	cmp    $0x80,%eax
80100637:	0f 8e 8b 00 00 00    	jle    801006c8 <addHistory.part.0+0xb8>
    if(commandHistoryCounter < MAX_HISTORY){
8010063d:	a1 30 b5 10 80       	mov    0x8010b530,%eax
80100642:	83 f8 0f             	cmp    $0xf,%eax
80100645:	7f 49                	jg     80100690 <addHistory.part.0+0x80>
      commandHistoryCounter++;
80100647:	8d 50 01             	lea    0x1(%eax),%edx
8010064a:	89 15 30 b5 10 80    	mov    %edx,0x8010b530
    memmove(commandHistory[commandHistoryCounter-1], command, sizeof(char)* length);
80100650:	c1 e0 07             	shl    $0x7,%eax
80100653:	83 ec 04             	sub    $0x4,%esp
80100656:	ff 75 e0             	pushl  -0x20(%ebp)
80100659:	05 40 0f 11 80       	add    $0x80110f40,%eax
8010065e:	56                   	push   %esi
8010065f:	50                   	push   %eax
80100660:	e8 0b 47 00 00       	call   80104d70 <memmove>
    commandHistory[commandHistoryCounter-1][length] = '\0';
80100665:	a1 30 b5 10 80       	mov    0x8010b530,%eax
8010066a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
}
8010066d:	83 c4 10             	add    $0x10,%esp
    commandHistory[commandHistoryCounter-1][length] = '\0';
80100670:	83 e8 01             	sub    $0x1,%eax
80100673:	89 c2                	mov    %eax,%edx
    currentCommandId = commandHistoryCounter - 1;
80100675:	a3 2c b5 10 80       	mov    %eax,0x8010b52c
    commandHistory[commandHistoryCounter-1][length] = '\0';
8010067a:	c1 e2 07             	shl    $0x7,%edx
8010067d:	c6 84 11 40 0f 11 80 	movb   $0x0,-0x7feef0c0(%ecx,%edx,1)
80100684:	00 
}
80100685:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100688:	5b                   	pop    %ebx
80100689:	5e                   	pop    %esi
8010068a:	5f                   	pop    %edi
8010068b:	5d                   	pop    %ebp
8010068c:	c3                   	ret    
8010068d:	8d 76 00             	lea    0x0(%esi),%esi
80100690:	bf 40 0f 11 80       	mov    $0x80110f40,%edi
80100695:	bb c0 16 11 80       	mov    $0x801116c0,%ebx
8010069a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        memmove(commandHistory[i], commandHistory[i+1], sizeof(char)* MAX_COMMAND_LENGTH);
801006a0:	83 ec 04             	sub    $0x4,%esp
801006a3:	89 f8                	mov    %edi,%eax
801006a5:	83 ef 80             	sub    $0xffffff80,%edi
801006a8:	68 80 00 00 00       	push   $0x80
801006ad:	57                   	push   %edi
801006ae:	50                   	push   %eax
801006af:	e8 bc 46 00 00       	call   80104d70 <memmove>
      for(i = 0; i < MAX_HISTORY - 1; i++){
801006b4:	83 c4 10             	add    $0x10,%esp
801006b7:	39 fb                	cmp    %edi,%ebx
801006b9:	75 e5                	jne    801006a0 <addHistory.part.0+0x90>
801006bb:	a1 30 b5 10 80       	mov    0x8010b530,%eax
801006c0:	83 e8 01             	sub    $0x1,%eax
801006c3:	eb 8b                	jmp    80100650 <addHistory.part.0+0x40>
801006c5:	8d 76 00             	lea    0x0(%esi),%esi
    int length = strlen(command) <= MAX_COMMAND_LENGTH ? strlen(command) : MAX_COMMAND_LENGTH-1;
801006c8:	83 ec 0c             	sub    $0xc,%esp
801006cb:	56                   	push   %esi
801006cc:	e8 ff 47 00 00       	call   80104ed0 <strlen>
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
8010070d:	c7 05 74 b5 10 80 00 	movl   $0x0,0x8010b574
80100714:	00 00 00 
  getcallerpcs(&s, pcs);
80100717:	8d 5d d0             	lea    -0x30(%ebp),%ebx
8010071a:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
8010071d:	e8 de 27 00 00       	call   80102f00 <lapicid>
80100722:	83 ec 08             	sub    $0x8,%esp
80100725:	50                   	push   %eax
80100726:	68 6d 77 10 80       	push   $0x8010776d
8010072b:	e8 50 00 00 00       	call   80100780 <cprintf>
  cprintf(s);
80100730:	58                   	pop    %eax
80100731:	ff 75 08             	pushl  0x8(%ebp)
80100734:	e8 47 00 00 00       	call   80100780 <cprintf>
  cprintf("\n");
80100739:	c7 04 24 b7 80 10 80 	movl   $0x801080b7,(%esp)
80100740:	e8 3b 00 00 00       	call   80100780 <cprintf>
  getcallerpcs(&s, pcs);
80100745:	8d 45 08             	lea    0x8(%ebp),%eax
80100748:	5a                   	pop    %edx
80100749:	59                   	pop    %ecx
8010074a:	53                   	push   %ebx
8010074b:	50                   	push   %eax
8010074c:	e8 0f 43 00 00       	call   80104a60 <getcallerpcs>
  for(i=0; i<10; i++)
80100751:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100754:	83 ec 08             	sub    $0x8,%esp
80100757:	ff 33                	pushl  (%ebx)
80100759:	83 c3 04             	add    $0x4,%ebx
8010075c:	68 81 77 10 80       	push   $0x80107781
80100761:	e8 1a 00 00 00       	call   80100780 <cprintf>
  for(i=0; i<10; i++)
80100766:	83 c4 10             	add    $0x10,%esp
80100769:	39 f3                	cmp    %esi,%ebx
8010076b:	75 e7                	jne    80100754 <panic+0x54>
  panicked = 1; // freeze other CPU
8010076d:	c7 05 78 b5 10 80 01 	movl   $0x1,0x8010b578
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
8010078d:	a1 74 b5 10 80       	mov    0x8010b574,%eax
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
801007bc:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
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
8010084d:	bb 85 77 10 80       	mov    $0x80107785,%ebx
      for(; *s; s++)
80100852:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100857:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
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
80100888:	68 40 b5 10 80       	push   $0x8010b540
8010088d:	e8 2e 43 00 00       	call   80104bc0 <acquire>
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
801008b0:	8b 3d 78 b5 10 80    	mov    0x8010b578,%edi
801008b6:	85 ff                	test   %edi,%edi
801008b8:	0f 84 12 ff ff ff    	je     801007d0 <cprintf+0x50>
801008be:	fa                   	cli    
    for(;;)
801008bf:	eb fe                	jmp    801008bf <cprintf+0x13f>
801008c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801008c8:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
801008ce:	85 c9                	test   %ecx,%ecx
801008d0:	74 06                	je     801008d8 <cprintf+0x158>
801008d2:	fa                   	cli    
    for(;;)
801008d3:	eb fe                	jmp    801008d3 <cprintf+0x153>
801008d5:	8d 76 00             	lea    0x0(%esi),%esi
801008d8:	b8 25 00 00 00       	mov    $0x25,%eax
801008dd:	e8 ae fa ff ff       	call   80100390 <consputc.part.0>
  if(panicked){
801008e2:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
801008e8:	85 d2                	test   %edx,%edx
801008ea:	74 2c                	je     80100918 <cprintf+0x198>
801008ec:	fa                   	cli    
    for(;;)
801008ed:	eb fe                	jmp    801008ed <cprintf+0x16d>
801008ef:	90                   	nop
    release(&cons.lock);
801008f0:	83 ec 0c             	sub    $0xc,%esp
801008f3:	68 40 b5 10 80       	push   $0x8010b540
801008f8:	e8 83 43 00 00       	call   80104c80 <release>
801008fd:	83 c4 10             	add    $0x10,%esp
}
80100900:	e9 ee fe ff ff       	jmp    801007f3 <cprintf+0x73>
    panic("null fmt");
80100905:	83 ec 0c             	sub    $0xc,%esp
80100908:	68 8c 77 10 80       	push   $0x8010778c
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
80100b1a:	81 ec b8 00 00 00    	sub    $0xb8,%esp
  acquire(&cons.lock);
80100b20:	68 40 b5 10 80       	push   $0x8010b540
80100b25:	e8 96 40 00 00       	call   80104bc0 <acquire>
  while((c = getc()) >= 0){
80100b2a:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100b2d:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
80100b34:	00 00 00 
  while((c = getc()) >= 0){
80100b37:	ff 55 08             	call   *0x8(%ebp)
80100b3a:	89 c3                	mov    %eax,%ebx
80100b3c:	85 c0                	test   %eax,%eax
80100b3e:	0f 88 cb 00 00 00    	js     80100c0f <consoleintr+0xff>
    switch(c){
80100b44:	83 fb 7f             	cmp    $0x7f,%ebx
80100b47:	0f 84 f4 00 00 00    	je     80100c41 <consoleintr+0x131>
80100b4d:	0f 8f 1d 01 00 00    	jg     80100c70 <consoleintr+0x160>
80100b53:	83 fb 10             	cmp    $0x10,%ebx
80100b56:	0f 84 b9 01 00 00    	je     80100d15 <consoleintr+0x205>
80100b5c:	7e 42                	jle    80100ba0 <consoleintr+0x90>
80100b5e:	83 fb 15             	cmp    $0x15,%ebx
80100b61:	0f 85 59 02 00 00    	jne    80100dc0 <consoleintr+0x2b0>
      while(input.e != input.w &&
80100b67:	a1 fc 17 11 80       	mov    0x801117fc,%eax
80100b6c:	39 05 f8 17 11 80    	cmp    %eax,0x801117f8
80100b72:	74 c3                	je     80100b37 <consoleintr+0x27>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100b74:	83 e8 01             	sub    $0x1,%eax
80100b77:	89 c2                	mov    %eax,%edx
80100b79:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100b7c:	80 ba 74 17 11 80 0a 	cmpb   $0xa,-0x7feee88c(%edx)
80100b83:	74 b2                	je     80100b37 <consoleintr+0x27>
        input.e--;
80100b85:	a3 fc 17 11 80       	mov    %eax,0x801117fc
  if(panicked){
80100b8a:	a1 78 b5 10 80       	mov    0x8010b578,%eax
80100b8f:	85 c0                	test   %eax,%eax
80100b91:	0f 84 fc 01 00 00    	je     80100d93 <consoleintr+0x283>
  asm volatile("cli");
80100b97:	fa                   	cli    
    for(;;)
80100b98:	eb fe                	jmp    80100b98 <consoleintr+0x88>
80100b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100ba0:	83 fb 06             	cmp    $0x6,%ebx
80100ba3:	0f 85 8f 00 00 00    	jne    80100c38 <consoleintr+0x128>
        capturing = 0;
80100ba9:	c7 05 24 b5 10 80 00 	movl   $0x0,0x8010b524
80100bb0:	00 00 00 
        cprintf("\nPasted input: ");
80100bb3:	83 ec 0c             	sub    $0xc,%esp
        for (int i = 0; i < input_index; i++) {
80100bb6:	31 db                	xor    %ebx,%ebx
        cprintf("\nPasted input: ");
80100bb8:	68 95 77 10 80       	push   $0x80107795
80100bbd:	e8 be fb ff ff       	call   80100780 <cprintf>
        for (int i = 0; i < input_index; i++) {
80100bc2:	8b 3d 20 b5 10 80    	mov    0x8010b520,%edi
80100bc8:	83 c4 10             	add    $0x10,%esp
80100bcb:	85 ff                	test   %edi,%edi
80100bcd:	7e 23                	jle    80100bf2 <consoleintr+0xe2>
            cprintf("%c", input_buffer[i]); // Print captured input
80100bcf:	0f be 83 20 18 11 80 	movsbl -0x7feee7e0(%ebx),%eax
80100bd6:	83 ec 08             	sub    $0x8,%esp
        for (int i = 0; i < input_index; i++) {
80100bd9:	83 c3 01             	add    $0x1,%ebx
            cprintf("%c", input_buffer[i]); // Print captured input
80100bdc:	50                   	push   %eax
80100bdd:	68 a5 77 10 80       	push   $0x801077a5
80100be2:	e8 99 fb ff ff       	call   80100780 <cprintf>
        for (int i = 0; i < input_index; i++) {
80100be7:	83 c4 10             	add    $0x10,%esp
80100bea:	39 1d 20 b5 10 80    	cmp    %ebx,0x8010b520
80100bf0:	7f dd                	jg     80100bcf <consoleintr+0xbf>
        cprintf("\n");
80100bf2:	83 ec 0c             	sub    $0xc,%esp
80100bf5:	68 b7 80 10 80       	push   $0x801080b7
80100bfa:	e8 81 fb ff ff       	call   80100780 <cprintf>
        break;
80100bff:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100c02:	ff 55 08             	call   *0x8(%ebp)
80100c05:	89 c3                	mov    %eax,%ebx
80100c07:	85 c0                	test   %eax,%eax
80100c09:	0f 89 35 ff ff ff    	jns    80100b44 <consoleintr+0x34>
  release(&cons.lock);
80100c0f:	83 ec 0c             	sub    $0xc,%esp
80100c12:	68 40 b5 10 80       	push   $0x8010b540
80100c17:	e8 64 40 00 00       	call   80104c80 <release>
    if (doprocdump)
80100c1c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80100c22:	83 c4 10             	add    $0x10,%esp
80100c25:	85 c0                	test   %eax,%eax
80100c27:	0f 85 b3 03 00 00    	jne    80100fe0 <consoleintr+0x4d0>
}
80100c2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c30:	5b                   	pop    %ebx
80100c31:	5e                   	pop    %esi
80100c32:	5f                   	pop    %edi
80100c33:	5d                   	pop    %ebp
80100c34:	c3                   	ret    
80100c35:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100c38:	83 fb 08             	cmp    $0x8,%ebx
80100c3b:	0f 85 77 01 00 00    	jne    80100db8 <consoleintr+0x2a8>
      if(input.e != input.w){
80100c41:	a1 fc 17 11 80       	mov    0x801117fc,%eax
80100c46:	3b 05 f8 17 11 80    	cmp    0x801117f8,%eax
80100c4c:	0f 84 e5 fe ff ff    	je     80100b37 <consoleintr+0x27>
        input.e--;
80100c52:	83 e8 01             	sub    $0x1,%eax
80100c55:	a3 fc 17 11 80       	mov    %eax,0x801117fc
  if(panicked){
80100c5a:	a1 78 b5 10 80       	mov    0x8010b578,%eax
80100c5f:	85 c0                	test   %eax,%eax
80100c61:	0f 84 39 02 00 00    	je     80100ea0 <consoleintr+0x390>
80100c67:	fa                   	cli    
    for(;;)
80100c68:	eb fe                	jmp    80100c68 <consoleintr+0x158>
80100c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100c70:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80100c76:	0f 84 a8 00 00 00    	je     80100d24 <consoleintr+0x214>
80100c7c:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
80100c82:	75 5c                	jne    80100ce0 <consoleintr+0x1d0>
      if(input.pos < input.e){   // cannot beyond most left character
80100c84:	a1 00 18 11 80       	mov    0x80111800,%eax
80100c89:	3b 05 fc 17 11 80    	cmp    0x801117fc,%eax
80100c8f:	0f 83 a2 fe ff ff    	jae    80100b37 <consoleintr+0x27>
        input.pos ++; // move back one
80100c95:	83 c0 01             	add    $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c98:	be d4 03 00 00       	mov    $0x3d4,%esi
        back_counter -= 1;
80100c9d:	83 2d 28 b5 10 80 01 	subl   $0x1,0x8010b528
        input.pos ++; // move back one
80100ca4:	a3 00 18 11 80       	mov    %eax,0x80111800
80100ca9:	89 f2                	mov    %esi,%edx
80100cab:	b8 0e 00 00 00       	mov    $0xe,%eax
80100cb0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100cb1:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100cb6:	89 da                	mov    %ebx,%edx
80100cb8:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100cb9:	bf 0f 00 00 00       	mov    $0xf,%edi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100cbe:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100cc1:	89 f2                	mov    %esi,%edx
  pos = inb(CRTPORT+1) << 8;
80100cc3:	c1 e1 08             	shl    $0x8,%ecx
80100cc6:	89 f8                	mov    %edi,%eax
80100cc8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100cc9:	89 da                	mov    %ebx,%edx
80100ccb:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100ccc:	0f b6 c0             	movzbl %al,%eax
80100ccf:	09 c1                	or     %eax,%ecx
  pos++;
80100cd1:	83 c1 01             	add    $0x1,%ecx
80100cd4:	e9 9b 00 00 00       	jmp    80100d74 <consoleintr+0x264>
80100cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100ce0:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80100ce6:	0f 85 d4 00 00 00    	jne    80100dc0 <consoleintr+0x2b0>
        capturing = 1; // Start capturing
80100cec:	c7 05 24 b5 10 80 01 	movl   $0x1,0x8010b524
80100cf3:	00 00 00 
        cprintf("Capturing input... (type your input)\n");
80100cf6:	83 ec 0c             	sub    $0xc,%esp
80100cf9:	68 b0 77 10 80       	push   $0x801077b0
        input_index = 0; // Reset index
80100cfe:	c7 05 20 b5 10 80 00 	movl   $0x0,0x8010b520
80100d05:	00 00 00 
        cprintf("Capturing input... (type your input)\n");
80100d08:	e8 73 fa ff ff       	call   80100780 <cprintf>
      break;
80100d0d:	83 c4 10             	add    $0x10,%esp
80100d10:	e9 22 fe ff ff       	jmp    80100b37 <consoleintr+0x27>
    switch(c){
80100d15:	c7 85 60 ff ff ff 01 	movl   $0x1,-0xa0(%ebp)
80100d1c:	00 00 00 
80100d1f:	e9 13 fe ff ff       	jmp    80100b37 <consoleintr+0x27>
      if(input.pos > input.r){  
80100d24:	a1 00 18 11 80       	mov    0x80111800,%eax
80100d29:	3b 05 f4 17 11 80    	cmp    0x801117f4,%eax
80100d2f:	0f 86 02 fe ff ff    	jbe    80100b37 <consoleintr+0x27>
        input.pos --;
80100d35:	83 e8 01             	sub    $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d38:	be d4 03 00 00       	mov    $0x3d4,%esi
        back_counter += 1;
80100d3d:	83 05 28 b5 10 80 01 	addl   $0x1,0x8010b528
        input.pos --;
80100d44:	a3 00 18 11 80       	mov    %eax,0x80111800
80100d49:	89 f2                	mov    %esi,%edx
80100d4b:	b8 0e 00 00 00       	mov    $0xe,%eax
80100d50:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d51:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100d56:	89 da                	mov    %ebx,%edx
80100d58:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d59:	bf 0f 00 00 00       	mov    $0xf,%edi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d5e:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d61:	89 f2                	mov    %esi,%edx
  pos = inb(CRTPORT+1) << 8;
80100d63:	c1 e1 08             	shl    $0x8,%ecx
80100d66:	89 f8                	mov    %edi,%eax
80100d68:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d69:	89 da                	mov    %ebx,%edx
80100d6b:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100d6c:	0f b6 c0             	movzbl %al,%eax
80100d6f:	09 c1                	or     %eax,%ecx
  pos--;
80100d71:	83 e9 01             	sub    $0x1,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d74:	89 f8                	mov    %edi,%eax
80100d76:	89 f2                	mov    %esi,%edx
80100d78:	ee                   	out    %al,(%dx)
80100d79:	89 c8                	mov    %ecx,%eax
80100d7b:	89 da                	mov    %ebx,%edx
80100d7d:	ee                   	out    %al,(%dx)
80100d7e:	b8 0e 00 00 00       	mov    $0xe,%eax
80100d83:	89 f2                	mov    %esi,%edx
80100d85:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
80100d86:	89 c8                	mov    %ecx,%eax
80100d88:	89 da                	mov    %ebx,%edx
80100d8a:	c1 f8 08             	sar    $0x8,%eax
80100d8d:	ee                   	out    %al,(%dx)
}
80100d8e:	e9 a4 fd ff ff       	jmp    80100b37 <consoleintr+0x27>
80100d93:	b8 00 01 00 00       	mov    $0x100,%eax
80100d98:	e8 f3 f5 ff ff       	call   80100390 <consputc.part.0>
      while(input.e != input.w &&
80100d9d:	a1 fc 17 11 80       	mov    0x801117fc,%eax
80100da2:	3b 05 f8 17 11 80    	cmp    0x801117f8,%eax
80100da8:	0f 85 c6 fd ff ff    	jne    80100b74 <consoleintr+0x64>
80100dae:	e9 84 fd ff ff       	jmp    80100b37 <consoleintr+0x27>
80100db3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100db7:	90                   	nop
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100db8:	85 db                	test   %ebx,%ebx
80100dba:	0f 84 77 fd ff ff    	je     80100b37 <consoleintr+0x27>
80100dc0:	a1 fc 17 11 80       	mov    0x801117fc,%eax
80100dc5:	2b 05 f4 17 11 80    	sub    0x801117f4,%eax
80100dcb:	83 f8 7f             	cmp    $0x7f,%eax
80100dce:	0f 87 63 fd ff ff    	ja     80100b37 <consoleintr+0x27>
            if (capturing) {
80100dd4:	8b 35 24 b5 10 80    	mov    0x8010b524,%esi
80100dda:	85 f6                	test   %esi,%esi
80100ddc:	74 28                	je     80100e06 <consoleintr+0x2f6>
              if (input_index < MAX_INPUT_SIZE - 1) { // Avoid overflow
80100dde:	a1 20 b5 10 80       	mov    0x8010b520,%eax
80100de3:	83 f8 62             	cmp    $0x62,%eax
80100de6:	0f 8e 91 01 00 00    	jle    80100f7d <consoleintr+0x46d>
              if (c != '\n') { // Don't echo newline
80100dec:	83 fb 0a             	cmp    $0xa,%ebx
80100def:	0f 84 af 01 00 00    	je     80100fa4 <consoleintr+0x494>
                  cprintf("%c", c); // Echo back the character
80100df5:	83 ec 08             	sub    $0x8,%esp
80100df8:	53                   	push   %ebx
80100df9:	68 a5 77 10 80       	push   $0x801077a5
80100dfe:	e8 7d f9 ff ff       	call   80100780 <cprintf>
80100e03:	83 c4 10             	add    $0x10,%esp
        uartputc('-');
80100e06:	83 ec 0c             	sub    $0xc,%esp
80100e09:	6a 2d                	push   $0x2d
80100e0b:	e8 30 55 00 00       	call   80106340 <uartputc>
        uartputc(c); 
80100e10:	89 1c 24             	mov    %ebx,(%esp)
80100e13:	e8 28 55 00 00       	call   80106340 <uartputc>
        c = (c == '\r') ? '\n' : c;
80100e18:	83 c4 10             	add    $0x10,%esp
80100e1b:	83 fb 0d             	cmp    $0xd,%ebx
80100e1e:	0f 84 8b 00 00 00    	je     80100eaf <consoleintr+0x39f>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100e24:	a1 fc 17 11 80       	mov    0x801117fc,%eax
80100e29:	88 9d 64 ff ff ff    	mov    %bl,-0x9c(%ebp)
80100e2f:	8d 48 01             	lea    0x1(%eax),%ecx
80100e32:	83 fb 0a             	cmp    $0xa,%ebx
80100e35:	0f 84 88 00 00 00    	je     80100ec3 <consoleintr+0x3b3>
80100e3b:	83 fb 04             	cmp    $0x4,%ebx
80100e3e:	0f 84 7f 00 00 00    	je     80100ec3 <consoleintr+0x3b3>
80100e44:	8b 3d f4 17 11 80    	mov    0x801117f4,%edi
80100e4a:	8d 97 80 00 00 00    	lea    0x80(%edi),%edx
80100e50:	39 c2                	cmp    %eax,%edx
80100e52:	74 6f                	je     80100ec3 <consoleintr+0x3b3>
          if(back_counter == 0){
80100e54:	8b 3d 00 18 11 80    	mov    0x80111800,%edi
80100e5a:	8b 35 28 b5 10 80    	mov    0x8010b528,%esi
80100e60:	8d 57 01             	lea    0x1(%edi),%edx
80100e63:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
80100e69:	89 95 58 ff ff ff    	mov    %edx,-0xa8(%ebp)
80100e6f:	85 f6                	test   %esi,%esi
80100e71:	0f 85 73 01 00 00    	jne    80100fea <consoleintr+0x4da>
            input.pos ++;
80100e77:	89 15 00 18 11 80    	mov    %edx,0x80111800
  if(panicked){
80100e7d:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
            input.buf[input.e++ % INPUT_BUF] = c;
80100e83:	83 e0 7f             	and    $0x7f,%eax
80100e86:	89 0d fc 17 11 80    	mov    %ecx,0x801117fc
80100e8c:	88 98 74 17 11 80    	mov    %bl,-0x7feee88c(%eax)
  if(panicked){
80100e92:	85 d2                	test   %edx,%edx
80100e94:	0f 84 fe 00 00 00    	je     80100f98 <consoleintr+0x488>
  asm volatile("cli");
80100e9a:	fa                   	cli    
    for(;;)
80100e9b:	eb fe                	jmp    80100e9b <consoleintr+0x38b>
80100e9d:	8d 76 00             	lea    0x0(%esi),%esi
80100ea0:	b8 00 01 00 00       	mov    $0x100,%eax
80100ea5:	e8 e6 f4 ff ff       	call   80100390 <consputc.part.0>
80100eaa:	e9 88 fc ff ff       	jmp    80100b37 <consoleintr+0x27>
80100eaf:	a1 fc 17 11 80       	mov    0x801117fc,%eax
        c = (c == '\r') ? '\n' : c;
80100eb4:	c6 85 64 ff ff ff 0a 	movb   $0xa,-0x9c(%ebp)
80100ebb:	bb 0a 00 00 00       	mov    $0xa,%ebx
80100ec0:	8d 48 01             	lea    0x1(%eax),%ecx
          input.buf[input.e++ % INPUT_BUF] = c;
80100ec3:	89 0d fc 17 11 80    	mov    %ecx,0x801117fc
80100ec9:	0f b6 8d 64 ff ff ff 	movzbl -0x9c(%ebp),%ecx
80100ed0:	83 e0 7f             	and    $0x7f,%eax
80100ed3:	88 88 74 17 11 80    	mov    %cl,-0x7feee88c(%eax)
  if(panicked){
80100ed9:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
80100edf:	85 c9                	test   %ecx,%ecx
80100ee1:	0f 85 aa 00 00 00    	jne    80100f91 <consoleintr+0x481>
80100ee7:	89 d8                	mov    %ebx,%eax
            buffer[k] = input.buf[i % INPUT_BUF];
80100ee9:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
80100eef:	e8 9c f4 ff ff       	call   80100390 <consputc.part.0>
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
80100ef4:	8b 35 f8 17 11 80    	mov    0x801117f8,%esi
80100efa:	8b 1d fc 17 11 80    	mov    0x801117fc,%ebx
          back_counter = 0;
80100f00:	c7 05 28 b5 10 80 00 	movl   $0x0,0x8010b528
80100f07:	00 00 00 
            buffer[k] = input.buf[i % INPUT_BUF];
80100f0a:	29 f7                	sub    %esi,%edi
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
80100f0c:	8d 43 ff             	lea    -0x1(%ebx),%eax
80100f0f:	89 f2                	mov    %esi,%edx
            buffer[k] = input.buf[i % INPUT_BUF];
80100f11:	89 bd 64 ff ff ff    	mov    %edi,-0x9c(%ebp)
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
80100f17:	39 f0                	cmp    %esi,%eax
80100f19:	76 27                	jbe    80100f42 <consoleintr+0x432>
            buffer[k] = input.buf[i % INPUT_BUF];
80100f1b:	89 d7                	mov    %edx,%edi
80100f1d:	c1 ff 1f             	sar    $0x1f,%edi
80100f20:	c1 ef 19             	shr    $0x19,%edi
80100f23:	8d 0c 3a             	lea    (%edx,%edi,1),%ecx
80100f26:	83 e1 7f             	and    $0x7f,%ecx
80100f29:	29 f9                	sub    %edi,%ecx
80100f2b:	8b bd 64 ff ff ff    	mov    -0x9c(%ebp),%edi
80100f31:	0f b6 89 74 17 11 80 	movzbl -0x7feee88c(%ecx),%ecx
80100f38:	88 0c 17             	mov    %cl,(%edi,%edx,1)
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
80100f3b:	83 c2 01             	add    $0x1,%edx
80100f3e:	39 d0                	cmp    %edx,%eax
80100f40:	77 d9                	ja     80100f1b <consoleintr+0x40b>
          buffer[(input.e-1-input.w) % INPUT_BUF] = '\0';
80100f42:	29 f0                	sub    %esi,%eax
80100f44:	83 e0 7f             	and    $0x7f,%eax
80100f47:	c6 84 05 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%eax,1)
80100f4e:	00 
if(command[0]!='\0')
80100f4f:	80 bd 68 ff ff ff 00 	cmpb   $0x0,-0x98(%ebp)
80100f56:	0f 85 10 01 00 00    	jne    8010106c <consoleintr+0x55c>
          wakeup(&input.r);
80100f5c:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100f5f:	89 1d f8 17 11 80    	mov    %ebx,0x801117f8
          wakeup(&input.r);
80100f65:	68 f4 17 11 80       	push   $0x801117f4
          input.pos = input.e;
80100f6a:	89 1d 00 18 11 80    	mov    %ebx,0x80111800
          wakeup(&input.r);
80100f70:	e8 cb 37 00 00       	call   80104740 <wakeup>
80100f75:	83 c4 10             	add    $0x10,%esp
80100f78:	e9 ba fb ff ff       	jmp    80100b37 <consoleintr+0x27>
                  input_buffer[input_index++] = c; // Store character
80100f7d:	8d 50 01             	lea    0x1(%eax),%edx
80100f80:	88 98 20 18 11 80    	mov    %bl,-0x7feee7e0(%eax)
80100f86:	89 15 20 b5 10 80    	mov    %edx,0x8010b520
80100f8c:	e9 5b fe ff ff       	jmp    80100dec <consoleintr+0x2dc>
80100f91:	fa                   	cli    
    for(;;)
80100f92:	eb fe                	jmp    80100f92 <consoleintr+0x482>
80100f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f98:	89 d8                	mov    %ebx,%eax
80100f9a:	e8 f1 f3 ff ff       	call   80100390 <consputc.part.0>
80100f9f:	e9 93 fb ff ff       	jmp    80100b37 <consoleintr+0x27>
                  cprintf("\n"); // Handle newline
80100fa4:	83 ec 0c             	sub    $0xc,%esp
80100fa7:	68 b7 80 10 80       	push   $0x801080b7
80100fac:	e8 cf f7 ff ff       	call   80100780 <cprintf>
        uartputc('-');
80100fb1:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
80100fb8:	e8 83 53 00 00       	call   80106340 <uartputc>
        uartputc(c); 
80100fbd:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80100fc4:	e8 77 53 00 00       	call   80106340 <uartputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100fc9:	a1 fc 17 11 80       	mov    0x801117fc,%eax
        uartputc(c); 
80100fce:	c6 85 64 ff ff ff 0a 	movb   $0xa,-0x9c(%ebp)
80100fd5:	83 c4 10             	add    $0x10,%esp
80100fd8:	8d 48 01             	lea    0x1(%eax),%ecx
80100fdb:	e9 e3 fe ff ff       	jmp    80100ec3 <consoleintr+0x3b3>
    procdump(); // now call procdump() wo. cons.lock held
80100fe0:	e8 4b 38 00 00       	call   80104830 <procdump>
}
80100fe5:	e9 43 fc ff ff       	jmp    80100c2d <consoleintr+0x11d>
            for(int k=input.e; k >= input.pos; k--){
80100fea:	39 f8                	cmp    %edi,%eax
80100fec:	72 44                	jb     80101032 <consoleintr+0x522>
80100fee:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
              input.buf[(k + 1) % INPUT_BUF] = input.buf[k % INPUT_BUF];
80100ff4:	89 c6                	mov    %eax,%esi
80100ff6:	c1 fe 1f             	sar    $0x1f,%esi
80100ff9:	c1 ee 19             	shr    $0x19,%esi
80100ffc:	8d 14 30             	lea    (%eax,%esi,1),%edx
80100fff:	83 e2 7f             	and    $0x7f,%edx
80101002:	29 f2                	sub    %esi,%edx
80101004:	0f b6 92 74 17 11 80 	movzbl -0x7feee88c(%edx),%edx
8010100b:	89 d1                	mov    %edx,%ecx
8010100d:	8d 50 01             	lea    0x1(%eax),%edx
            for(int k=input.e; k >= input.pos; k--){
80101010:	83 e8 01             	sub    $0x1,%eax
              input.buf[(k + 1) % INPUT_BUF] = input.buf[k % INPUT_BUF];
80101013:	89 d6                	mov    %edx,%esi
80101015:	c1 fe 1f             	sar    $0x1f,%esi
80101018:	c1 ee 19             	shr    $0x19,%esi
8010101b:	01 f2                	add    %esi,%edx
8010101d:	83 e2 7f             	and    $0x7f,%edx
80101020:	29 f2                	sub    %esi,%edx
80101022:	88 8a 74 17 11 80    	mov    %cl,-0x7feee88c(%edx)
            for(int k=input.e; k >= input.pos; k--){
80101028:	39 f8                	cmp    %edi,%eax
8010102a:	73 c8                	jae    80100ff4 <consoleintr+0x4e4>
8010102c:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
            vga_insert_char(c, back_counter);
80101032:	83 ec 08             	sub    $0x8,%esp
            input.buf[input.pos % INPUT_BUF] = c;
80101035:	0f b6 95 64 ff ff ff 	movzbl -0x9c(%ebp),%edx
8010103c:	89 f8                	mov    %edi,%eax
            vga_insert_char(c, back_counter);
8010103e:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
            input.buf[input.pos % INPUT_BUF] = c;
80101044:	83 e0 7f             	and    $0x7f,%eax
            vga_insert_char(c, back_counter);
80101047:	53                   	push   %ebx
            input.buf[input.pos % INPUT_BUF] = c;
80101048:	88 90 74 17 11 80    	mov    %dl,-0x7feee88c(%eax)
            input.pos++;
8010104e:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
            input.e++;
80101054:	89 0d fc 17 11 80    	mov    %ecx,0x801117fc
            input.pos++;
8010105a:	a3 00 18 11 80       	mov    %eax,0x80111800
            vga_insert_char(c, back_counter);
8010105f:	e8 8c f9 ff ff       	call   801009f0 <vga_insert_char>
80101064:	83 c4 10             	add    $0x10,%esp
80101067:	e9 cb fa ff ff       	jmp    80100b37 <consoleintr+0x27>
8010106c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80101072:	e8 99 f5 ff ff       	call   80100610 <addHistory.part.0>
80101077:	8b 1d fc 17 11 80    	mov    0x801117fc,%ebx
8010107d:	e9 da fe ff ff       	jmp    80100f5c <consoleintr+0x44c>
80101082:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101090 <consoleinit>:

void
consoleinit(void)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
8010109a:	68 a8 77 10 80       	push   $0x801077a8
8010109f:	68 40 b5 10 80       	push   $0x8010b540
801010a4:	e8 97 39 00 00       	call   80104a40 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801010a9:	58                   	pop    %eax
801010aa:	5a                   	pop    %edx
801010ab:	6a 00                	push   $0x0
801010ad:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801010af:	c7 05 4c 22 11 80 a0 	movl   $0x801005a0,0x8011224c
801010b6:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801010b9:	c7 05 48 22 11 80 90 	movl   $0x80100290,0x80112248
801010c0:	02 10 80 
  cons.locking = 1;
801010c3:	c7 05 74 b5 10 80 01 	movl   $0x1,0x8010b574
801010ca:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801010cd:	e8 be 19 00 00       	call   80102a90 <ioapicenable>
}
801010d2:	83 c4 10             	add    $0x10,%esp
801010d5:	c9                   	leave  
801010d6:	c3                   	ret    
801010d7:	66 90                	xchg   %ax,%ax
801010d9:	66 90                	xchg   %ax,%ax
801010db:	66 90                	xchg   %ax,%ax
801010dd:	66 90                	xchg   %ax,%ax
801010df:	90                   	nop

801010e0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801010e0:	f3 0f 1e fb          	endbr32 
801010e4:	55                   	push   %ebp
801010e5:	89 e5                	mov    %esp,%ebp
801010e7:	57                   	push   %edi
801010e8:	56                   	push   %esi
801010e9:	53                   	push   %ebx
801010ea:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801010f0:	e8 cb 2e 00 00       	call   80103fc0 <myproc>
801010f5:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
801010fb:	e8 90 22 00 00       	call   80103390 <begin_op>

  if((ip = namei(path)) == 0){
80101100:	83 ec 0c             	sub    $0xc,%esp
80101103:	ff 75 08             	pushl  0x8(%ebp)
80101106:	e8 85 15 00 00       	call   80102690 <namei>
8010110b:	83 c4 10             	add    $0x10,%esp
8010110e:	85 c0                	test   %eax,%eax
80101110:	0f 84 fe 02 00 00    	je     80101414 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101116:	83 ec 0c             	sub    $0xc,%esp
80101119:	89 c3                	mov    %eax,%ebx
8010111b:	50                   	push   %eax
8010111c:	e8 9f 0c 00 00       	call   80101dc0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80101121:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101127:	6a 34                	push   $0x34
80101129:	6a 00                	push   $0x0
8010112b:	50                   	push   %eax
8010112c:	53                   	push   %ebx
8010112d:	e8 8e 0f 00 00       	call   801020c0 <readi>
80101132:	83 c4 20             	add    $0x20,%esp
80101135:	83 f8 34             	cmp    $0x34,%eax
80101138:	74 26                	je     80101160 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
8010113a:	83 ec 0c             	sub    $0xc,%esp
8010113d:	53                   	push   %ebx
8010113e:	e8 1d 0f 00 00       	call   80102060 <iunlockput>
    end_op();
80101143:	e8 b8 22 00 00       	call   80103400 <end_op>
80101148:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
8010114b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101150:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101153:	5b                   	pop    %ebx
80101154:	5e                   	pop    %esi
80101155:	5f                   	pop    %edi
80101156:	5d                   	pop    %ebp
80101157:	c3                   	ret    
80101158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010115f:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80101160:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101167:	45 4c 46 
8010116a:	75 ce                	jne    8010113a <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
8010116c:	e8 3f 63 00 00       	call   801074b0 <setupkvm>
80101171:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101177:	85 c0                	test   %eax,%eax
80101179:	74 bf                	je     8010113a <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010117b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101182:	00 
80101183:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101189:	0f 84 a4 02 00 00    	je     80101433 <exec+0x353>
  sz = 0;
8010118f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101196:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101199:	31 ff                	xor    %edi,%edi
8010119b:	e9 86 00 00 00       	jmp    80101226 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
801011a0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801011a7:	75 6c                	jne    80101215 <exec+0x135>
    if(ph.memsz < ph.filesz)
801011a9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801011af:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801011b5:	0f 82 87 00 00 00    	jb     80101242 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801011bb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801011c1:	72 7f                	jb     80101242 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801011c3:	83 ec 04             	sub    $0x4,%esp
801011c6:	50                   	push   %eax
801011c7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801011cd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801011d3:	e8 f8 60 00 00       	call   801072d0 <allocuvm>
801011d8:	83 c4 10             	add    $0x10,%esp
801011db:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801011e1:	85 c0                	test   %eax,%eax
801011e3:	74 5d                	je     80101242 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
801011e5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
801011eb:	a9 ff 0f 00 00       	test   $0xfff,%eax
801011f0:	75 50                	jne    80101242 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
801011f2:	83 ec 0c             	sub    $0xc,%esp
801011f5:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
801011fb:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80101201:	53                   	push   %ebx
80101202:	50                   	push   %eax
80101203:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101209:	e8 f2 5f 00 00       	call   80107200 <loaduvm>
8010120e:	83 c4 20             	add    $0x20,%esp
80101211:	85 c0                	test   %eax,%eax
80101213:	78 2d                	js     80101242 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101215:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010121c:	83 c7 01             	add    $0x1,%edi
8010121f:	83 c6 20             	add    $0x20,%esi
80101222:	39 f8                	cmp    %edi,%eax
80101224:	7e 3a                	jle    80101260 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101226:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010122c:	6a 20                	push   $0x20
8010122e:	56                   	push   %esi
8010122f:	50                   	push   %eax
80101230:	53                   	push   %ebx
80101231:	e8 8a 0e 00 00       	call   801020c0 <readi>
80101236:	83 c4 10             	add    $0x10,%esp
80101239:	83 f8 20             	cmp    $0x20,%eax
8010123c:	0f 84 5e ff ff ff    	je     801011a0 <exec+0xc0>
    freevm(pgdir);
80101242:	83 ec 0c             	sub    $0xc,%esp
80101245:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010124b:	e8 e0 61 00 00       	call   80107430 <freevm>
  if(ip){
80101250:	83 c4 10             	add    $0x10,%esp
80101253:	e9 e2 fe ff ff       	jmp    8010113a <exec+0x5a>
80101258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010125f:	90                   	nop
80101260:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80101266:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
8010126c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80101272:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80101278:	83 ec 0c             	sub    $0xc,%esp
8010127b:	53                   	push   %ebx
8010127c:	e8 df 0d 00 00       	call   80102060 <iunlockput>
  end_op();
80101281:	e8 7a 21 00 00       	call   80103400 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101286:	83 c4 0c             	add    $0xc,%esp
80101289:	56                   	push   %esi
8010128a:	57                   	push   %edi
8010128b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101291:	57                   	push   %edi
80101292:	e8 39 60 00 00       	call   801072d0 <allocuvm>
80101297:	83 c4 10             	add    $0x10,%esp
8010129a:	89 c6                	mov    %eax,%esi
8010129c:	85 c0                	test   %eax,%eax
8010129e:	0f 84 94 00 00 00    	je     80101338 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801012a4:	83 ec 08             	sub    $0x8,%esp
801012a7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
801012ad:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801012af:	50                   	push   %eax
801012b0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
801012b1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801012b3:	e8 98 62 00 00       	call   80107550 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
801012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801012bb:	83 c4 10             	add    $0x10,%esp
801012be:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
801012c4:	8b 00                	mov    (%eax),%eax
801012c6:	85 c0                	test   %eax,%eax
801012c8:	0f 84 8b 00 00 00    	je     80101359 <exec+0x279>
801012ce:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
801012d4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
801012da:	eb 23                	jmp    801012ff <exec+0x21f>
801012dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012e0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
801012e3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
801012ea:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
801012ed:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
801012f3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 59                	je     80101353 <exec+0x273>
    if(argc >= MAXARG)
801012fa:	83 ff 20             	cmp    $0x20,%edi
801012fd:	74 39                	je     80101338 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801012ff:	83 ec 0c             	sub    $0xc,%esp
80101302:	50                   	push   %eax
80101303:	e8 c8 3b 00 00       	call   80104ed0 <strlen>
80101308:	f7 d0                	not    %eax
8010130a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010130c:	58                   	pop    %eax
8010130d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101310:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101313:	ff 34 b8             	pushl  (%eax,%edi,4)
80101316:	e8 b5 3b 00 00       	call   80104ed0 <strlen>
8010131b:	83 c0 01             	add    $0x1,%eax
8010131e:	50                   	push   %eax
8010131f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101322:	ff 34 b8             	pushl  (%eax,%edi,4)
80101325:	53                   	push   %ebx
80101326:	56                   	push   %esi
80101327:	e8 84 63 00 00       	call   801076b0 <copyout>
8010132c:	83 c4 20             	add    $0x20,%esp
8010132f:	85 c0                	test   %eax,%eax
80101331:	79 ad                	jns    801012e0 <exec+0x200>
80101333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101337:	90                   	nop
    freevm(pgdir);
80101338:	83 ec 0c             	sub    $0xc,%esp
8010133b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101341:	e8 ea 60 00 00       	call   80107430 <freevm>
80101346:	83 c4 10             	add    $0x10,%esp
  return -1;
80101349:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010134e:	e9 fd fd ff ff       	jmp    80101150 <exec+0x70>
80101353:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101359:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101360:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101362:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101369:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010136d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010136f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101372:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101378:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010137a:	50                   	push   %eax
8010137b:	52                   	push   %edx
8010137c:	53                   	push   %ebx
8010137d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101383:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010138a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010138d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101393:	e8 18 63 00 00       	call   801076b0 <copyout>
80101398:	83 c4 10             	add    $0x10,%esp
8010139b:	85 c0                	test   %eax,%eax
8010139d:	78 99                	js     80101338 <exec+0x258>
  for(last=s=path; *s; s++)
8010139f:	8b 45 08             	mov    0x8(%ebp),%eax
801013a2:	8b 55 08             	mov    0x8(%ebp),%edx
801013a5:	0f b6 00             	movzbl (%eax),%eax
801013a8:	84 c0                	test   %al,%al
801013aa:	74 13                	je     801013bf <exec+0x2df>
801013ac:	89 d1                	mov    %edx,%ecx
801013ae:	66 90                	xchg   %ax,%ax
    if(*s == '/')
801013b0:	83 c1 01             	add    $0x1,%ecx
801013b3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801013b5:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
801013b8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
801013bb:	84 c0                	test   %al,%al
801013bd:	75 f1                	jne    801013b0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801013bf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801013c5:	83 ec 04             	sub    $0x4,%esp
801013c8:	6a 10                	push   $0x10
801013ca:	89 f8                	mov    %edi,%eax
801013cc:	52                   	push   %edx
801013cd:	83 c0 6c             	add    $0x6c,%eax
801013d0:	50                   	push   %eax
801013d1:	e8 ba 3a 00 00       	call   80104e90 <safestrcpy>
  curproc->pgdir = pgdir;
801013d6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801013dc:	89 f8                	mov    %edi,%eax
801013de:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
801013e1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
801013e3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
801013e6:	89 c1                	mov    %eax,%ecx
801013e8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801013ee:	8b 40 18             	mov    0x18(%eax),%eax
801013f1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801013f4:	8b 41 18             	mov    0x18(%ecx),%eax
801013f7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
801013fa:	89 0c 24             	mov    %ecx,(%esp)
801013fd:	e8 6e 5c 00 00       	call   80107070 <switchuvm>
  freevm(oldpgdir);
80101402:	89 3c 24             	mov    %edi,(%esp)
80101405:	e8 26 60 00 00       	call   80107430 <freevm>
  return 0;
8010140a:	83 c4 10             	add    $0x10,%esp
8010140d:	31 c0                	xor    %eax,%eax
8010140f:	e9 3c fd ff ff       	jmp    80101150 <exec+0x70>
    end_op();
80101414:	e8 e7 1f 00 00       	call   80103400 <end_op>
    cprintf("exec: fail\n");
80101419:	83 ec 0c             	sub    $0xc,%esp
8010141c:	68 e9 77 10 80       	push   $0x801077e9
80101421:	e8 5a f3 ff ff       	call   80100780 <cprintf>
    return -1;
80101426:	83 c4 10             	add    $0x10,%esp
80101429:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010142e:	e9 1d fd ff ff       	jmp    80101150 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101433:	31 ff                	xor    %edi,%edi
80101435:	be 00 20 00 00       	mov    $0x2000,%esi
8010143a:	e9 39 fe ff ff       	jmp    80101278 <exec+0x198>
8010143f:	90                   	nop

80101440 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101440:	f3 0f 1e fb          	endbr32 
80101444:	55                   	push   %ebp
80101445:	89 e5                	mov    %esp,%ebp
80101447:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
8010144a:	68 f5 77 10 80       	push   $0x801077f5
8010144f:	68 a0 18 11 80       	push   $0x801118a0
80101454:	e8 e7 35 00 00       	call   80104a40 <initlock>
}
80101459:	83 c4 10             	add    $0x10,%esp
8010145c:	c9                   	leave  
8010145d:	c3                   	ret    
8010145e:	66 90                	xchg   %ax,%ax

80101460 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101460:	f3 0f 1e fb          	endbr32 
80101464:	55                   	push   %ebp
80101465:	89 e5                	mov    %esp,%ebp
80101467:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101468:	bb d4 18 11 80       	mov    $0x801118d4,%ebx
{
8010146d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80101470:	68 a0 18 11 80       	push   $0x801118a0
80101475:	e8 46 37 00 00       	call   80104bc0 <acquire>
8010147a:	83 c4 10             	add    $0x10,%esp
8010147d:	eb 0c                	jmp    8010148b <filealloc+0x2b>
8010147f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101480:	83 c3 18             	add    $0x18,%ebx
80101483:	81 fb 34 22 11 80    	cmp    $0x80112234,%ebx
80101489:	74 25                	je     801014b0 <filealloc+0x50>
    if(f->ref == 0){
8010148b:	8b 43 04             	mov    0x4(%ebx),%eax
8010148e:	85 c0                	test   %eax,%eax
80101490:	75 ee                	jne    80101480 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101492:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101495:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010149c:	68 a0 18 11 80       	push   $0x801118a0
801014a1:	e8 da 37 00 00       	call   80104c80 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801014a6:	89 d8                	mov    %ebx,%eax
      return f;
801014a8:	83 c4 10             	add    $0x10,%esp
}
801014ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014ae:	c9                   	leave  
801014af:	c3                   	ret    
  release(&ftable.lock);
801014b0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801014b3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801014b5:	68 a0 18 11 80       	push   $0x801118a0
801014ba:	e8 c1 37 00 00       	call   80104c80 <release>
}
801014bf:	89 d8                	mov    %ebx,%eax
  return 0;
801014c1:	83 c4 10             	add    $0x10,%esp
}
801014c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014c7:	c9                   	leave  
801014c8:	c3                   	ret    
801014c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014d0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801014d0:	f3 0f 1e fb          	endbr32 
801014d4:	55                   	push   %ebp
801014d5:	89 e5                	mov    %esp,%ebp
801014d7:	53                   	push   %ebx
801014d8:	83 ec 10             	sub    $0x10,%esp
801014db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801014de:	68 a0 18 11 80       	push   $0x801118a0
801014e3:	e8 d8 36 00 00       	call   80104bc0 <acquire>
  if(f->ref < 1)
801014e8:	8b 43 04             	mov    0x4(%ebx),%eax
801014eb:	83 c4 10             	add    $0x10,%esp
801014ee:	85 c0                	test   %eax,%eax
801014f0:	7e 1a                	jle    8010150c <filedup+0x3c>
    panic("filedup");
  f->ref++;
801014f2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801014f5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801014f8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801014fb:	68 a0 18 11 80       	push   $0x801118a0
80101500:	e8 7b 37 00 00       	call   80104c80 <release>
  return f;
}
80101505:	89 d8                	mov    %ebx,%eax
80101507:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010150a:	c9                   	leave  
8010150b:	c3                   	ret    
    panic("filedup");
8010150c:	83 ec 0c             	sub    $0xc,%esp
8010150f:	68 fc 77 10 80       	push   $0x801077fc
80101514:	e8 e7 f1 ff ff       	call   80100700 <panic>
80101519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101520 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101520:	f3 0f 1e fb          	endbr32 
80101524:	55                   	push   %ebp
80101525:	89 e5                	mov    %esp,%ebp
80101527:	57                   	push   %edi
80101528:	56                   	push   %esi
80101529:	53                   	push   %ebx
8010152a:	83 ec 28             	sub    $0x28,%esp
8010152d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80101530:	68 a0 18 11 80       	push   $0x801118a0
80101535:	e8 86 36 00 00       	call   80104bc0 <acquire>
  if(f->ref < 1)
8010153a:	8b 53 04             	mov    0x4(%ebx),%edx
8010153d:	83 c4 10             	add    $0x10,%esp
80101540:	85 d2                	test   %edx,%edx
80101542:	0f 8e a1 00 00 00    	jle    801015e9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101548:	83 ea 01             	sub    $0x1,%edx
8010154b:	89 53 04             	mov    %edx,0x4(%ebx)
8010154e:	75 40                	jne    80101590 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101550:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101554:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101557:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101559:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010155f:	8b 73 0c             	mov    0xc(%ebx),%esi
80101562:	88 45 e7             	mov    %al,-0x19(%ebp)
80101565:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101568:	68 a0 18 11 80       	push   $0x801118a0
  ff = *f;
8010156d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101570:	e8 0b 37 00 00       	call   80104c80 <release>

  if(ff.type == FD_PIPE)
80101575:	83 c4 10             	add    $0x10,%esp
80101578:	83 ff 01             	cmp    $0x1,%edi
8010157b:	74 53                	je     801015d0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
8010157d:	83 ff 02             	cmp    $0x2,%edi
80101580:	74 26                	je     801015a8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101582:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101585:	5b                   	pop    %ebx
80101586:	5e                   	pop    %esi
80101587:	5f                   	pop    %edi
80101588:	5d                   	pop    %ebp
80101589:	c3                   	ret    
8010158a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101590:	c7 45 08 a0 18 11 80 	movl   $0x801118a0,0x8(%ebp)
}
80101597:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010159a:	5b                   	pop    %ebx
8010159b:	5e                   	pop    %esi
8010159c:	5f                   	pop    %edi
8010159d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010159e:	e9 dd 36 00 00       	jmp    80104c80 <release>
801015a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015a7:	90                   	nop
    begin_op();
801015a8:	e8 e3 1d 00 00       	call   80103390 <begin_op>
    iput(ff.ip);
801015ad:	83 ec 0c             	sub    $0xc,%esp
801015b0:	ff 75 e0             	pushl  -0x20(%ebp)
801015b3:	e8 38 09 00 00       	call   80101ef0 <iput>
    end_op();
801015b8:	83 c4 10             	add    $0x10,%esp
}
801015bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015be:	5b                   	pop    %ebx
801015bf:	5e                   	pop    %esi
801015c0:	5f                   	pop    %edi
801015c1:	5d                   	pop    %ebp
    end_op();
801015c2:	e9 39 1e 00 00       	jmp    80103400 <end_op>
801015c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ce:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801015d0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801015d4:	83 ec 08             	sub    $0x8,%esp
801015d7:	53                   	push   %ebx
801015d8:	56                   	push   %esi
801015d9:	e8 82 25 00 00       	call   80103b60 <pipeclose>
801015de:	83 c4 10             	add    $0x10,%esp
}
801015e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015e4:	5b                   	pop    %ebx
801015e5:	5e                   	pop    %esi
801015e6:	5f                   	pop    %edi
801015e7:	5d                   	pop    %ebp
801015e8:	c3                   	ret    
    panic("fileclose");
801015e9:	83 ec 0c             	sub    $0xc,%esp
801015ec:	68 04 78 10 80       	push   $0x80107804
801015f1:	e8 0a f1 ff ff       	call   80100700 <panic>
801015f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015fd:	8d 76 00             	lea    0x0(%esi),%esi

80101600 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101600:	f3 0f 1e fb          	endbr32 
80101604:	55                   	push   %ebp
80101605:	89 e5                	mov    %esp,%ebp
80101607:	53                   	push   %ebx
80101608:	83 ec 04             	sub    $0x4,%esp
8010160b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010160e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101611:	75 2d                	jne    80101640 <filestat+0x40>
    ilock(f->ip);
80101613:	83 ec 0c             	sub    $0xc,%esp
80101616:	ff 73 10             	pushl  0x10(%ebx)
80101619:	e8 a2 07 00 00       	call   80101dc0 <ilock>
    stati(f->ip, st);
8010161e:	58                   	pop    %eax
8010161f:	5a                   	pop    %edx
80101620:	ff 75 0c             	pushl  0xc(%ebp)
80101623:	ff 73 10             	pushl  0x10(%ebx)
80101626:	e8 65 0a 00 00       	call   80102090 <stati>
    iunlock(f->ip);
8010162b:	59                   	pop    %ecx
8010162c:	ff 73 10             	pushl  0x10(%ebx)
8010162f:	e8 6c 08 00 00       	call   80101ea0 <iunlock>
    return 0;
  }
  return -1;
}
80101634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101637:	83 c4 10             	add    $0x10,%esp
8010163a:	31 c0                	xor    %eax,%eax
}
8010163c:	c9                   	leave  
8010163d:	c3                   	ret    
8010163e:	66 90                	xchg   %ax,%ax
80101640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101643:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101648:	c9                   	leave  
80101649:	c3                   	ret    
8010164a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101650 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101650:	f3 0f 1e fb          	endbr32 
80101654:	55                   	push   %ebp
80101655:	89 e5                	mov    %esp,%ebp
80101657:	57                   	push   %edi
80101658:	56                   	push   %esi
80101659:	53                   	push   %ebx
8010165a:	83 ec 0c             	sub    $0xc,%esp
8010165d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101660:	8b 75 0c             	mov    0xc(%ebp),%esi
80101663:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101666:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010166a:	74 64                	je     801016d0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010166c:	8b 03                	mov    (%ebx),%eax
8010166e:	83 f8 01             	cmp    $0x1,%eax
80101671:	74 45                	je     801016b8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101673:	83 f8 02             	cmp    $0x2,%eax
80101676:	75 5f                	jne    801016d7 <fileread+0x87>
    ilock(f->ip);
80101678:	83 ec 0c             	sub    $0xc,%esp
8010167b:	ff 73 10             	pushl  0x10(%ebx)
8010167e:	e8 3d 07 00 00       	call   80101dc0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101683:	57                   	push   %edi
80101684:	ff 73 14             	pushl  0x14(%ebx)
80101687:	56                   	push   %esi
80101688:	ff 73 10             	pushl  0x10(%ebx)
8010168b:	e8 30 0a 00 00       	call   801020c0 <readi>
80101690:	83 c4 20             	add    $0x20,%esp
80101693:	89 c6                	mov    %eax,%esi
80101695:	85 c0                	test   %eax,%eax
80101697:	7e 03                	jle    8010169c <fileread+0x4c>
      f->off += r;
80101699:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010169c:	83 ec 0c             	sub    $0xc,%esp
8010169f:	ff 73 10             	pushl  0x10(%ebx)
801016a2:	e8 f9 07 00 00       	call   80101ea0 <iunlock>
    return r;
801016a7:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801016aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016ad:	89 f0                	mov    %esi,%eax
801016af:	5b                   	pop    %ebx
801016b0:	5e                   	pop    %esi
801016b1:	5f                   	pop    %edi
801016b2:	5d                   	pop    %ebp
801016b3:	c3                   	ret    
801016b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801016b8:	8b 43 0c             	mov    0xc(%ebx),%eax
801016bb:	89 45 08             	mov    %eax,0x8(%ebp)
}
801016be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016c1:	5b                   	pop    %ebx
801016c2:	5e                   	pop    %esi
801016c3:	5f                   	pop    %edi
801016c4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801016c5:	e9 36 26 00 00       	jmp    80103d00 <piperead>
801016ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801016d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801016d5:	eb d3                	jmp    801016aa <fileread+0x5a>
  panic("fileread");
801016d7:	83 ec 0c             	sub    $0xc,%esp
801016da:	68 0e 78 10 80       	push   $0x8010780e
801016df:	e8 1c f0 ff ff       	call   80100700 <panic>
801016e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801016ef:	90                   	nop

801016f0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801016f0:	f3 0f 1e fb          	endbr32 
801016f4:	55                   	push   %ebp
801016f5:	89 e5                	mov    %esp,%ebp
801016f7:	57                   	push   %edi
801016f8:	56                   	push   %esi
801016f9:	53                   	push   %ebx
801016fa:	83 ec 1c             	sub    $0x1c,%esp
801016fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101700:	8b 75 08             	mov    0x8(%ebp),%esi
80101703:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101706:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101709:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010170d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101710:	0f 84 c1 00 00 00    	je     801017d7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101716:	8b 06                	mov    (%esi),%eax
80101718:	83 f8 01             	cmp    $0x1,%eax
8010171b:	0f 84 c3 00 00 00    	je     801017e4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101721:	83 f8 02             	cmp    $0x2,%eax
80101724:	0f 85 cc 00 00 00    	jne    801017f6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010172a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010172d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010172f:	85 c0                	test   %eax,%eax
80101731:	7f 34                	jg     80101767 <filewrite+0x77>
80101733:	e9 98 00 00 00       	jmp    801017d0 <filewrite+0xe0>
80101738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010173f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101740:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101743:	83 ec 0c             	sub    $0xc,%esp
80101746:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101749:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010174c:	e8 4f 07 00 00       	call   80101ea0 <iunlock>
      end_op();
80101751:	e8 aa 1c 00 00       	call   80103400 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101756:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101759:	83 c4 10             	add    $0x10,%esp
8010175c:	39 c3                	cmp    %eax,%ebx
8010175e:	75 60                	jne    801017c0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101760:	01 df                	add    %ebx,%edi
    while(i < n){
80101762:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101765:	7e 69                	jle    801017d0 <filewrite+0xe0>
      int n1 = n - i;
80101767:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010176a:	b8 00 06 00 00       	mov    $0x600,%eax
8010176f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101771:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101777:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010177a:	e8 11 1c 00 00       	call   80103390 <begin_op>
      ilock(f->ip);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	ff 76 10             	pushl  0x10(%esi)
80101785:	e8 36 06 00 00       	call   80101dc0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010178a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010178d:	53                   	push   %ebx
8010178e:	ff 76 14             	pushl  0x14(%esi)
80101791:	01 f8                	add    %edi,%eax
80101793:	50                   	push   %eax
80101794:	ff 76 10             	pushl  0x10(%esi)
80101797:	e8 24 0a 00 00       	call   801021c0 <writei>
8010179c:	83 c4 20             	add    $0x20,%esp
8010179f:	85 c0                	test   %eax,%eax
801017a1:	7f 9d                	jg     80101740 <filewrite+0x50>
      iunlock(f->ip);
801017a3:	83 ec 0c             	sub    $0xc,%esp
801017a6:	ff 76 10             	pushl  0x10(%esi)
801017a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801017ac:	e8 ef 06 00 00       	call   80101ea0 <iunlock>
      end_op();
801017b1:	e8 4a 1c 00 00       	call   80103400 <end_op>
      if(r < 0)
801017b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801017b9:	83 c4 10             	add    $0x10,%esp
801017bc:	85 c0                	test   %eax,%eax
801017be:	75 17                	jne    801017d7 <filewrite+0xe7>
        panic("short filewrite");
801017c0:	83 ec 0c             	sub    $0xc,%esp
801017c3:	68 17 78 10 80       	push   $0x80107817
801017c8:	e8 33 ef ff ff       	call   80100700 <panic>
801017cd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801017d0:	89 f8                	mov    %edi,%eax
801017d2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801017d5:	74 05                	je     801017dc <filewrite+0xec>
801017d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801017dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017df:	5b                   	pop    %ebx
801017e0:	5e                   	pop    %esi
801017e1:	5f                   	pop    %edi
801017e2:	5d                   	pop    %ebp
801017e3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801017e4:	8b 46 0c             	mov    0xc(%esi),%eax
801017e7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801017ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017ed:	5b                   	pop    %ebx
801017ee:	5e                   	pop    %esi
801017ef:	5f                   	pop    %edi
801017f0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801017f1:	e9 0a 24 00 00       	jmp    80103c00 <pipewrite>
  panic("filewrite");
801017f6:	83 ec 0c             	sub    $0xc,%esp
801017f9:	68 1d 78 10 80       	push   $0x8010781d
801017fe:	e8 fd ee ff ff       	call   80100700 <panic>
80101803:	66 90                	xchg   %ax,%ax
80101805:	66 90                	xchg   %ax,%ax
80101807:	66 90                	xchg   %ax,%ax
80101809:	66 90                	xchg   %ax,%ax
8010180b:	66 90                	xchg   %ax,%ax
8010180d:	66 90                	xchg   %ax,%ax
8010180f:	90                   	nop

80101810 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101810:	55                   	push   %ebp
80101811:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101813:	89 d0                	mov    %edx,%eax
80101815:	c1 e8 0c             	shr    $0xc,%eax
80101818:	03 05 b8 22 11 80    	add    0x801122b8,%eax
{
8010181e:	89 e5                	mov    %esp,%ebp
80101820:	56                   	push   %esi
80101821:	53                   	push   %ebx
80101822:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101824:	83 ec 08             	sub    $0x8,%esp
80101827:	50                   	push   %eax
80101828:	51                   	push   %ecx
80101829:	e8 a2 e8 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010182e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101830:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101833:	ba 01 00 00 00       	mov    $0x1,%edx
80101838:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010183b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101841:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101844:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101846:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010184b:	85 d1                	test   %edx,%ecx
8010184d:	74 25                	je     80101874 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010184f:	f7 d2                	not    %edx
  log_write(bp);
80101851:	83 ec 0c             	sub    $0xc,%esp
80101854:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101856:	21 ca                	and    %ecx,%edx
80101858:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010185c:	50                   	push   %eax
8010185d:	e8 0e 1d 00 00       	call   80103570 <log_write>
  brelse(bp);
80101862:	89 34 24             	mov    %esi,(%esp)
80101865:	e8 86 e9 ff ff       	call   801001f0 <brelse>
}
8010186a:	83 c4 10             	add    $0x10,%esp
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
80101873:	c3                   	ret    
    panic("freeing free block");
80101874:	83 ec 0c             	sub    $0xc,%esp
80101877:	68 27 78 10 80       	push   $0x80107827
8010187c:	e8 7f ee ff ff       	call   80100700 <panic>
80101881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101888:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188f:	90                   	nop

80101890 <balloc>:
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	57                   	push   %edi
80101894:	56                   	push   %esi
80101895:	53                   	push   %ebx
80101896:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101899:	8b 0d a0 22 11 80    	mov    0x801122a0,%ecx
{
8010189f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801018a2:	85 c9                	test   %ecx,%ecx
801018a4:	0f 84 87 00 00 00    	je     80101931 <balloc+0xa1>
801018aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801018b1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801018b4:	83 ec 08             	sub    $0x8,%esp
801018b7:	89 f0                	mov    %esi,%eax
801018b9:	c1 f8 0c             	sar    $0xc,%eax
801018bc:	03 05 b8 22 11 80    	add    0x801122b8,%eax
801018c2:	50                   	push   %eax
801018c3:	ff 75 d8             	pushl  -0x28(%ebp)
801018c6:	e8 05 e8 ff ff       	call   801000d0 <bread>
801018cb:	83 c4 10             	add    $0x10,%esp
801018ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801018d1:	a1 a0 22 11 80       	mov    0x801122a0,%eax
801018d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801018d9:	31 c0                	xor    %eax,%eax
801018db:	eb 2f                	jmp    8010190c <balloc+0x7c>
801018dd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801018e0:	89 c1                	mov    %eax,%ecx
801018e2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801018e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801018ea:	83 e1 07             	and    $0x7,%ecx
801018ed:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801018ef:	89 c1                	mov    %eax,%ecx
801018f1:	c1 f9 03             	sar    $0x3,%ecx
801018f4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801018f9:	89 fa                	mov    %edi,%edx
801018fb:	85 df                	test   %ebx,%edi
801018fd:	74 41                	je     80101940 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801018ff:	83 c0 01             	add    $0x1,%eax
80101902:	83 c6 01             	add    $0x1,%esi
80101905:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010190a:	74 05                	je     80101911 <balloc+0x81>
8010190c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010190f:	77 cf                	ja     801018e0 <balloc+0x50>
    brelse(bp);
80101911:	83 ec 0c             	sub    $0xc,%esp
80101914:	ff 75 e4             	pushl  -0x1c(%ebp)
80101917:	e8 d4 e8 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010191c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
80101926:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101929:	39 05 a0 22 11 80    	cmp    %eax,0x801122a0
8010192f:	77 80                	ja     801018b1 <balloc+0x21>
  panic("balloc: out of blocks");
80101931:	83 ec 0c             	sub    $0xc,%esp
80101934:	68 3a 78 10 80       	push   $0x8010783a
80101939:	e8 c2 ed ff ff       	call   80100700 <panic>
8010193e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101940:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101943:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101946:	09 da                	or     %ebx,%edx
80101948:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010194c:	57                   	push   %edi
8010194d:	e8 1e 1c 00 00       	call   80103570 <log_write>
        brelse(bp);
80101952:	89 3c 24             	mov    %edi,(%esp)
80101955:	e8 96 e8 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010195a:	58                   	pop    %eax
8010195b:	5a                   	pop    %edx
8010195c:	56                   	push   %esi
8010195d:	ff 75 d8             	pushl  -0x28(%ebp)
80101960:	e8 6b e7 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101965:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101968:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010196a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010196d:	68 00 02 00 00       	push   $0x200
80101972:	6a 00                	push   $0x0
80101974:	50                   	push   %eax
80101975:	e8 56 33 00 00       	call   80104cd0 <memset>
  log_write(bp);
8010197a:	89 1c 24             	mov    %ebx,(%esp)
8010197d:	e8 ee 1b 00 00       	call   80103570 <log_write>
  brelse(bp);
80101982:	89 1c 24             	mov    %ebx,(%esp)
80101985:	e8 66 e8 ff ff       	call   801001f0 <brelse>
}
8010198a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010198d:	89 f0                	mov    %esi,%eax
8010198f:	5b                   	pop    %ebx
80101990:	5e                   	pop    %esi
80101991:	5f                   	pop    %edi
80101992:	5d                   	pop    %ebp
80101993:	c3                   	ret    
80101994:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010199b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010199f:	90                   	nop

801019a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	57                   	push   %edi
801019a4:	89 c7                	mov    %eax,%edi
801019a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801019a7:	31 f6                	xor    %esi,%esi
{
801019a9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019aa:	bb f4 22 11 80       	mov    $0x801122f4,%ebx
{
801019af:	83 ec 28             	sub    $0x28,%esp
801019b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801019b5:	68 c0 22 11 80       	push   $0x801122c0
801019ba:	e8 01 32 00 00       	call   80104bc0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801019c2:	83 c4 10             	add    $0x10,%esp
801019c5:	eb 1b                	jmp    801019e2 <iget+0x42>
801019c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ce:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801019d0:	39 3b                	cmp    %edi,(%ebx)
801019d2:	74 6c                	je     80101a40 <iget+0xa0>
801019d4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019da:	81 fb 14 3f 11 80    	cmp    $0x80113f14,%ebx
801019e0:	73 26                	jae    80101a08 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801019e2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801019e5:	85 c9                	test   %ecx,%ecx
801019e7:	7f e7                	jg     801019d0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801019e9:	85 f6                	test   %esi,%esi
801019eb:	75 e7                	jne    801019d4 <iget+0x34>
801019ed:	89 d8                	mov    %ebx,%eax
801019ef:	81 c3 90 00 00 00    	add    $0x90,%ebx
801019f5:	85 c9                	test   %ecx,%ecx
801019f7:	75 6e                	jne    80101a67 <iget+0xc7>
801019f9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019fb:	81 fb 14 3f 11 80    	cmp    $0x80113f14,%ebx
80101a01:	72 df                	jb     801019e2 <iget+0x42>
80101a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a07:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101a08:	85 f6                	test   %esi,%esi
80101a0a:	74 73                	je     80101a7f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101a0c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101a0f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101a11:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101a14:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101a1b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101a22:	68 c0 22 11 80       	push   $0x801122c0
80101a27:	e8 54 32 00 00       	call   80104c80 <release>

  return ip;
80101a2c:	83 c4 10             	add    $0x10,%esp
}
80101a2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a32:	89 f0                	mov    %esi,%eax
80101a34:	5b                   	pop    %ebx
80101a35:	5e                   	pop    %esi
80101a36:	5f                   	pop    %edi
80101a37:	5d                   	pop    %ebp
80101a38:	c3                   	ret    
80101a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a40:	39 53 04             	cmp    %edx,0x4(%ebx)
80101a43:	75 8f                	jne    801019d4 <iget+0x34>
      release(&icache.lock);
80101a45:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101a48:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101a4b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101a4d:	68 c0 22 11 80       	push   $0x801122c0
      ip->ref++;
80101a52:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101a55:	e8 26 32 00 00       	call   80104c80 <release>
      return ip;
80101a5a:	83 c4 10             	add    $0x10,%esp
}
80101a5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a60:	89 f0                	mov    %esi,%eax
80101a62:	5b                   	pop    %ebx
80101a63:	5e                   	pop    %esi
80101a64:	5f                   	pop    %edi
80101a65:	5d                   	pop    %ebp
80101a66:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a67:	81 fb 14 3f 11 80    	cmp    $0x80113f14,%ebx
80101a6d:	73 10                	jae    80101a7f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a6f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101a72:	85 c9                	test   %ecx,%ecx
80101a74:	0f 8f 56 ff ff ff    	jg     801019d0 <iget+0x30>
80101a7a:	e9 6e ff ff ff       	jmp    801019ed <iget+0x4d>
    panic("iget: no inodes");
80101a7f:	83 ec 0c             	sub    $0xc,%esp
80101a82:	68 50 78 10 80       	push   $0x80107850
80101a87:	e8 74 ec ff ff       	call   80100700 <panic>
80101a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a90 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	89 c6                	mov    %eax,%esi
80101a97:	53                   	push   %ebx
80101a98:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101a9b:	83 fa 0b             	cmp    $0xb,%edx
80101a9e:	0f 86 84 00 00 00    	jbe    80101b28 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101aa4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101aa7:	83 fb 7f             	cmp    $0x7f,%ebx
80101aaa:	0f 87 98 00 00 00    	ja     80101b48 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101ab0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ab6:	8b 16                	mov    (%esi),%edx
80101ab8:	85 c0                	test   %eax,%eax
80101aba:	74 54                	je     80101b10 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101abc:	83 ec 08             	sub    $0x8,%esp
80101abf:	50                   	push   %eax
80101ac0:	52                   	push   %edx
80101ac1:	e8 0a e6 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101ac6:	83 c4 10             	add    $0x10,%esp
80101ac9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
80101acd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101acf:	8b 1a                	mov    (%edx),%ebx
80101ad1:	85 db                	test   %ebx,%ebx
80101ad3:	74 1b                	je     80101af0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101ad5:	83 ec 0c             	sub    $0xc,%esp
80101ad8:	57                   	push   %edi
80101ad9:	e8 12 e7 ff ff       	call   801001f0 <brelse>
    return addr;
80101ade:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101ae1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ae4:	89 d8                	mov    %ebx,%eax
80101ae6:	5b                   	pop    %ebx
80101ae7:	5e                   	pop    %esi
80101ae8:	5f                   	pop    %edi
80101ae9:	5d                   	pop    %ebp
80101aea:	c3                   	ret    
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101af0:	8b 06                	mov    (%esi),%eax
80101af2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101af5:	e8 96 fd ff ff       	call   80101890 <balloc>
80101afa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101afd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101b00:	89 c3                	mov    %eax,%ebx
80101b02:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101b04:	57                   	push   %edi
80101b05:	e8 66 1a 00 00       	call   80103570 <log_write>
80101b0a:	83 c4 10             	add    $0x10,%esp
80101b0d:	eb c6                	jmp    80101ad5 <bmap+0x45>
80101b0f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b10:	89 d0                	mov    %edx,%eax
80101b12:	e8 79 fd ff ff       	call   80101890 <balloc>
80101b17:	8b 16                	mov    (%esi),%edx
80101b19:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101b1f:	eb 9b                	jmp    80101abc <bmap+0x2c>
80101b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101b28:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80101b2b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101b2e:	85 db                	test   %ebx,%ebx
80101b30:	75 af                	jne    80101ae1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b32:	8b 00                	mov    (%eax),%eax
80101b34:	e8 57 fd ff ff       	call   80101890 <balloc>
80101b39:	89 47 5c             	mov    %eax,0x5c(%edi)
80101b3c:	89 c3                	mov    %eax,%ebx
}
80101b3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b41:	89 d8                	mov    %ebx,%eax
80101b43:	5b                   	pop    %ebx
80101b44:	5e                   	pop    %esi
80101b45:	5f                   	pop    %edi
80101b46:	5d                   	pop    %ebp
80101b47:	c3                   	ret    
  panic("bmap: out of range");
80101b48:	83 ec 0c             	sub    $0xc,%esp
80101b4b:	68 60 78 10 80       	push   $0x80107860
80101b50:	e8 ab eb ff ff       	call   80100700 <panic>
80101b55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b60 <readsb>:
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	56                   	push   %esi
80101b68:	53                   	push   %ebx
80101b69:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101b6c:	83 ec 08             	sub    $0x8,%esp
80101b6f:	6a 01                	push   $0x1
80101b71:	ff 75 08             	pushl  0x8(%ebp)
80101b74:	e8 57 e5 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101b79:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101b7c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101b7e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101b81:	6a 1c                	push   $0x1c
80101b83:	50                   	push   %eax
80101b84:	56                   	push   %esi
80101b85:	e8 e6 31 00 00       	call   80104d70 <memmove>
  brelse(bp);
80101b8a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b8d:	83 c4 10             	add    $0x10,%esp
}
80101b90:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b93:	5b                   	pop    %ebx
80101b94:	5e                   	pop    %esi
80101b95:	5d                   	pop    %ebp
  brelse(bp);
80101b96:	e9 55 e6 ff ff       	jmp    801001f0 <brelse>
80101b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b9f:	90                   	nop

80101ba0 <iinit>:
{
80101ba0:	f3 0f 1e fb          	endbr32 
80101ba4:	55                   	push   %ebp
80101ba5:	89 e5                	mov    %esp,%ebp
80101ba7:	53                   	push   %ebx
80101ba8:	bb 00 23 11 80       	mov    $0x80112300,%ebx
80101bad:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101bb0:	68 73 78 10 80       	push   $0x80107873
80101bb5:	68 c0 22 11 80       	push   $0x801122c0
80101bba:	e8 81 2e 00 00       	call   80104a40 <initlock>
  for(i = 0; i < NINODE; i++) {
80101bbf:	83 c4 10             	add    $0x10,%esp
80101bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101bc8:	83 ec 08             	sub    $0x8,%esp
80101bcb:	68 7a 78 10 80       	push   $0x8010787a
80101bd0:	53                   	push   %ebx
80101bd1:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101bd7:	e8 24 2d 00 00       	call   80104900 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101bdc:	83 c4 10             	add    $0x10,%esp
80101bdf:	81 fb 20 3f 11 80    	cmp    $0x80113f20,%ebx
80101be5:	75 e1                	jne    80101bc8 <iinit+0x28>
  readsb(dev, &sb);
80101be7:	83 ec 08             	sub    $0x8,%esp
80101bea:	68 a0 22 11 80       	push   $0x801122a0
80101bef:	ff 75 08             	pushl  0x8(%ebp)
80101bf2:	e8 69 ff ff ff       	call   80101b60 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101bf7:	ff 35 b8 22 11 80    	pushl  0x801122b8
80101bfd:	ff 35 b4 22 11 80    	pushl  0x801122b4
80101c03:	ff 35 b0 22 11 80    	pushl  0x801122b0
80101c09:	ff 35 ac 22 11 80    	pushl  0x801122ac
80101c0f:	ff 35 a8 22 11 80    	pushl  0x801122a8
80101c15:	ff 35 a4 22 11 80    	pushl  0x801122a4
80101c1b:	ff 35 a0 22 11 80    	pushl  0x801122a0
80101c21:	68 e0 78 10 80       	push   $0x801078e0
80101c26:	e8 55 eb ff ff       	call   80100780 <cprintf>
}
80101c2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c2e:	83 c4 30             	add    $0x30,%esp
80101c31:	c9                   	leave  
80101c32:	c3                   	ret    
80101c33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c40 <ialloc>:
{
80101c40:	f3 0f 1e fb          	endbr32 
80101c44:	55                   	push   %ebp
80101c45:	89 e5                	mov    %esp,%ebp
80101c47:	57                   	push   %edi
80101c48:	56                   	push   %esi
80101c49:	53                   	push   %ebx
80101c4a:	83 ec 1c             	sub    $0x1c,%esp
80101c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101c50:	83 3d a8 22 11 80 01 	cmpl   $0x1,0x801122a8
{
80101c57:	8b 75 08             	mov    0x8(%ebp),%esi
80101c5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101c5d:	0f 86 8d 00 00 00    	jbe    80101cf0 <ialloc+0xb0>
80101c63:	bf 01 00 00 00       	mov    $0x1,%edi
80101c68:	eb 1d                	jmp    80101c87 <ialloc+0x47>
80101c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101c70:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101c73:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101c76:	53                   	push   %ebx
80101c77:	e8 74 e5 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101c7c:	83 c4 10             	add    $0x10,%esp
80101c7f:	3b 3d a8 22 11 80    	cmp    0x801122a8,%edi
80101c85:	73 69                	jae    80101cf0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101c87:	89 f8                	mov    %edi,%eax
80101c89:	83 ec 08             	sub    $0x8,%esp
80101c8c:	c1 e8 03             	shr    $0x3,%eax
80101c8f:	03 05 b4 22 11 80    	add    0x801122b4,%eax
80101c95:	50                   	push   %eax
80101c96:	56                   	push   %esi
80101c97:	e8 34 e4 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101c9c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101c9f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101ca1:	89 f8                	mov    %edi,%eax
80101ca3:	83 e0 07             	and    $0x7,%eax
80101ca6:	c1 e0 06             	shl    $0x6,%eax
80101ca9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101cad:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101cb1:	75 bd                	jne    80101c70 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101cb3:	83 ec 04             	sub    $0x4,%esp
80101cb6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101cb9:	6a 40                	push   $0x40
80101cbb:	6a 00                	push   $0x0
80101cbd:	51                   	push   %ecx
80101cbe:	e8 0d 30 00 00       	call   80104cd0 <memset>
      dip->type = type;
80101cc3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101cc7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101cca:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101ccd:	89 1c 24             	mov    %ebx,(%esp)
80101cd0:	e8 9b 18 00 00       	call   80103570 <log_write>
      brelse(bp);
80101cd5:	89 1c 24             	mov    %ebx,(%esp)
80101cd8:	e8 13 e5 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101cdd:	83 c4 10             	add    $0x10,%esp
}
80101ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101ce3:	89 fa                	mov    %edi,%edx
}
80101ce5:	5b                   	pop    %ebx
      return iget(dev, inum);
80101ce6:	89 f0                	mov    %esi,%eax
}
80101ce8:	5e                   	pop    %esi
80101ce9:	5f                   	pop    %edi
80101cea:	5d                   	pop    %ebp
      return iget(dev, inum);
80101ceb:	e9 b0 fc ff ff       	jmp    801019a0 <iget>
  panic("ialloc: no inodes");
80101cf0:	83 ec 0c             	sub    $0xc,%esp
80101cf3:	68 80 78 10 80       	push   $0x80107880
80101cf8:	e8 03 ea ff ff       	call   80100700 <panic>
80101cfd:	8d 76 00             	lea    0x0(%esi),%esi

80101d00 <iupdate>:
{
80101d00:	f3 0f 1e fb          	endbr32 
80101d04:	55                   	push   %ebp
80101d05:	89 e5                	mov    %esp,%ebp
80101d07:	56                   	push   %esi
80101d08:	53                   	push   %ebx
80101d09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d0c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d0f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d12:	83 ec 08             	sub    $0x8,%esp
80101d15:	c1 e8 03             	shr    $0x3,%eax
80101d18:	03 05 b4 22 11 80    	add    0x801122b4,%eax
80101d1e:	50                   	push   %eax
80101d1f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101d22:	e8 a9 e3 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101d27:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d2b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d2e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101d30:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101d33:	83 e0 07             	and    $0x7,%eax
80101d36:	c1 e0 06             	shl    $0x6,%eax
80101d39:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101d3d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101d40:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d44:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101d47:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101d4b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101d4f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101d53:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101d57:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101d5b:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101d5e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d61:	6a 34                	push   $0x34
80101d63:	53                   	push   %ebx
80101d64:	50                   	push   %eax
80101d65:	e8 06 30 00 00       	call   80104d70 <memmove>
  log_write(bp);
80101d6a:	89 34 24             	mov    %esi,(%esp)
80101d6d:	e8 fe 17 00 00       	call   80103570 <log_write>
  brelse(bp);
80101d72:	89 75 08             	mov    %esi,0x8(%ebp)
80101d75:	83 c4 10             	add    $0x10,%esp
}
80101d78:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d7b:	5b                   	pop    %ebx
80101d7c:	5e                   	pop    %esi
80101d7d:	5d                   	pop    %ebp
  brelse(bp);
80101d7e:	e9 6d e4 ff ff       	jmp    801001f0 <brelse>
80101d83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101d90 <idup>:
{
80101d90:	f3 0f 1e fb          	endbr32 
80101d94:	55                   	push   %ebp
80101d95:	89 e5                	mov    %esp,%ebp
80101d97:	53                   	push   %ebx
80101d98:	83 ec 10             	sub    $0x10,%esp
80101d9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101d9e:	68 c0 22 11 80       	push   $0x801122c0
80101da3:	e8 18 2e 00 00       	call   80104bc0 <acquire>
  ip->ref++;
80101da8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101dac:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
80101db3:	e8 c8 2e 00 00       	call   80104c80 <release>
}
80101db8:	89 d8                	mov    %ebx,%eax
80101dba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101dbd:	c9                   	leave  
80101dbe:	c3                   	ret    
80101dbf:	90                   	nop

80101dc0 <ilock>:
{
80101dc0:	f3 0f 1e fb          	endbr32 
80101dc4:	55                   	push   %ebp
80101dc5:	89 e5                	mov    %esp,%ebp
80101dc7:	56                   	push   %esi
80101dc8:	53                   	push   %ebx
80101dc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101dcc:	85 db                	test   %ebx,%ebx
80101dce:	0f 84 b3 00 00 00    	je     80101e87 <ilock+0xc7>
80101dd4:	8b 53 08             	mov    0x8(%ebx),%edx
80101dd7:	85 d2                	test   %edx,%edx
80101dd9:	0f 8e a8 00 00 00    	jle    80101e87 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101ddf:	83 ec 0c             	sub    $0xc,%esp
80101de2:	8d 43 0c             	lea    0xc(%ebx),%eax
80101de5:	50                   	push   %eax
80101de6:	e8 55 2b 00 00       	call   80104940 <acquiresleep>
  if(ip->valid == 0){
80101deb:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101dee:	83 c4 10             	add    $0x10,%esp
80101df1:	85 c0                	test   %eax,%eax
80101df3:	74 0b                	je     80101e00 <ilock+0x40>
}
80101df5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101df8:	5b                   	pop    %ebx
80101df9:	5e                   	pop    %esi
80101dfa:	5d                   	pop    %ebp
80101dfb:	c3                   	ret    
80101dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101e00:	8b 43 04             	mov    0x4(%ebx),%eax
80101e03:	83 ec 08             	sub    $0x8,%esp
80101e06:	c1 e8 03             	shr    $0x3,%eax
80101e09:	03 05 b4 22 11 80    	add    0x801122b4,%eax
80101e0f:	50                   	push   %eax
80101e10:	ff 33                	pushl  (%ebx)
80101e12:	e8 b9 e2 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101e17:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101e1a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101e1c:	8b 43 04             	mov    0x4(%ebx),%eax
80101e1f:	83 e0 07             	and    $0x7,%eax
80101e22:	c1 e0 06             	shl    $0x6,%eax
80101e25:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101e29:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101e2c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101e2f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101e33:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101e37:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101e3b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101e3f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101e43:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101e47:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101e4b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101e4e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101e51:	6a 34                	push   $0x34
80101e53:	50                   	push   %eax
80101e54:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101e57:	50                   	push   %eax
80101e58:	e8 13 2f 00 00       	call   80104d70 <memmove>
    brelse(bp);
80101e5d:	89 34 24             	mov    %esi,(%esp)
80101e60:	e8 8b e3 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101e6d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101e74:	0f 85 7b ff ff ff    	jne    80101df5 <ilock+0x35>
      panic("ilock: no type");
80101e7a:	83 ec 0c             	sub    $0xc,%esp
80101e7d:	68 98 78 10 80       	push   $0x80107898
80101e82:	e8 79 e8 ff ff       	call   80100700 <panic>
    panic("ilock");
80101e87:	83 ec 0c             	sub    $0xc,%esp
80101e8a:	68 92 78 10 80       	push   $0x80107892
80101e8f:	e8 6c e8 ff ff       	call   80100700 <panic>
80101e94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e9f:	90                   	nop

80101ea0 <iunlock>:
{
80101ea0:	f3 0f 1e fb          	endbr32 
80101ea4:	55                   	push   %ebp
80101ea5:	89 e5                	mov    %esp,%ebp
80101ea7:	56                   	push   %esi
80101ea8:	53                   	push   %ebx
80101ea9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101eac:	85 db                	test   %ebx,%ebx
80101eae:	74 28                	je     80101ed8 <iunlock+0x38>
80101eb0:	83 ec 0c             	sub    $0xc,%esp
80101eb3:	8d 73 0c             	lea    0xc(%ebx),%esi
80101eb6:	56                   	push   %esi
80101eb7:	e8 24 2b 00 00       	call   801049e0 <holdingsleep>
80101ebc:	83 c4 10             	add    $0x10,%esp
80101ebf:	85 c0                	test   %eax,%eax
80101ec1:	74 15                	je     80101ed8 <iunlock+0x38>
80101ec3:	8b 43 08             	mov    0x8(%ebx),%eax
80101ec6:	85 c0                	test   %eax,%eax
80101ec8:	7e 0e                	jle    80101ed8 <iunlock+0x38>
  releasesleep(&ip->lock);
80101eca:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101ecd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101ed3:	e9 c8 2a 00 00       	jmp    801049a0 <releasesleep>
    panic("iunlock");
80101ed8:	83 ec 0c             	sub    $0xc,%esp
80101edb:	68 a7 78 10 80       	push   $0x801078a7
80101ee0:	e8 1b e8 ff ff       	call   80100700 <panic>
80101ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ef0 <iput>:
{
80101ef0:	f3 0f 1e fb          	endbr32 
80101ef4:	55                   	push   %ebp
80101ef5:	89 e5                	mov    %esp,%ebp
80101ef7:	57                   	push   %edi
80101ef8:	56                   	push   %esi
80101ef9:	53                   	push   %ebx
80101efa:	83 ec 28             	sub    $0x28,%esp
80101efd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101f00:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101f03:	57                   	push   %edi
80101f04:	e8 37 2a 00 00       	call   80104940 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101f09:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101f0c:	83 c4 10             	add    $0x10,%esp
80101f0f:	85 d2                	test   %edx,%edx
80101f11:	74 07                	je     80101f1a <iput+0x2a>
80101f13:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101f18:	74 36                	je     80101f50 <iput+0x60>
  releasesleep(&ip->lock);
80101f1a:	83 ec 0c             	sub    $0xc,%esp
80101f1d:	57                   	push   %edi
80101f1e:	e8 7d 2a 00 00       	call   801049a0 <releasesleep>
  acquire(&icache.lock);
80101f23:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
80101f2a:	e8 91 2c 00 00       	call   80104bc0 <acquire>
  ip->ref--;
80101f2f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101f33:	83 c4 10             	add    $0x10,%esp
80101f36:	c7 45 08 c0 22 11 80 	movl   $0x801122c0,0x8(%ebp)
}
80101f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f40:	5b                   	pop    %ebx
80101f41:	5e                   	pop    %esi
80101f42:	5f                   	pop    %edi
80101f43:	5d                   	pop    %ebp
  release(&icache.lock);
80101f44:	e9 37 2d 00 00       	jmp    80104c80 <release>
80101f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	68 c0 22 11 80       	push   $0x801122c0
80101f58:	e8 63 2c 00 00       	call   80104bc0 <acquire>
    int r = ip->ref;
80101f5d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101f60:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
80101f67:	e8 14 2d 00 00       	call   80104c80 <release>
    if(r == 1){
80101f6c:	83 c4 10             	add    $0x10,%esp
80101f6f:	83 fe 01             	cmp    $0x1,%esi
80101f72:	75 a6                	jne    80101f1a <iput+0x2a>
80101f74:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101f7a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101f7d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101f80:	89 cf                	mov    %ecx,%edi
80101f82:	eb 0b                	jmp    80101f8f <iput+0x9f>
80101f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101f88:	83 c6 04             	add    $0x4,%esi
80101f8b:	39 fe                	cmp    %edi,%esi
80101f8d:	74 19                	je     80101fa8 <iput+0xb8>
    if(ip->addrs[i]){
80101f8f:	8b 16                	mov    (%esi),%edx
80101f91:	85 d2                	test   %edx,%edx
80101f93:	74 f3                	je     80101f88 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101f95:	8b 03                	mov    (%ebx),%eax
80101f97:	e8 74 f8 ff ff       	call   80101810 <bfree>
      ip->addrs[i] = 0;
80101f9c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101fa2:	eb e4                	jmp    80101f88 <iput+0x98>
80101fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101fa8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101fae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101fb1:	85 c0                	test   %eax,%eax
80101fb3:	75 33                	jne    80101fe8 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101fb5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101fb8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101fbf:	53                   	push   %ebx
80101fc0:	e8 3b fd ff ff       	call   80101d00 <iupdate>
      ip->type = 0;
80101fc5:	31 c0                	xor    %eax,%eax
80101fc7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101fcb:	89 1c 24             	mov    %ebx,(%esp)
80101fce:	e8 2d fd ff ff       	call   80101d00 <iupdate>
      ip->valid = 0;
80101fd3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101fda:	83 c4 10             	add    $0x10,%esp
80101fdd:	e9 38 ff ff ff       	jmp    80101f1a <iput+0x2a>
80101fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101fe8:	83 ec 08             	sub    $0x8,%esp
80101feb:	50                   	push   %eax
80101fec:	ff 33                	pushl  (%ebx)
80101fee:	e8 dd e0 ff ff       	call   801000d0 <bread>
80101ff3:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ff6:	83 c4 10             	add    $0x10,%esp
80101ff9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101fff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102002:	8d 70 5c             	lea    0x5c(%eax),%esi
80102005:	89 cf                	mov    %ecx,%edi
80102007:	eb 0e                	jmp    80102017 <iput+0x127>
80102009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102010:	83 c6 04             	add    $0x4,%esi
80102013:	39 f7                	cmp    %esi,%edi
80102015:	74 19                	je     80102030 <iput+0x140>
      if(a[j])
80102017:	8b 16                	mov    (%esi),%edx
80102019:	85 d2                	test   %edx,%edx
8010201b:	74 f3                	je     80102010 <iput+0x120>
        bfree(ip->dev, a[j]);
8010201d:	8b 03                	mov    (%ebx),%eax
8010201f:	e8 ec f7 ff ff       	call   80101810 <bfree>
80102024:	eb ea                	jmp    80102010 <iput+0x120>
80102026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010202d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80102030:	83 ec 0c             	sub    $0xc,%esp
80102033:	ff 75 e4             	pushl  -0x1c(%ebp)
80102036:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102039:	e8 b2 e1 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010203e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80102044:	8b 03                	mov    (%ebx),%eax
80102046:	e8 c5 f7 ff ff       	call   80101810 <bfree>
    ip->addrs[NDIRECT] = 0;
8010204b:	83 c4 10             	add    $0x10,%esp
8010204e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80102055:	00 00 00 
80102058:	e9 58 ff ff ff       	jmp    80101fb5 <iput+0xc5>
8010205d:	8d 76 00             	lea    0x0(%esi),%esi

80102060 <iunlockput>:
{
80102060:	f3 0f 1e fb          	endbr32 
80102064:	55                   	push   %ebp
80102065:	89 e5                	mov    %esp,%ebp
80102067:	53                   	push   %ebx
80102068:	83 ec 10             	sub    $0x10,%esp
8010206b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010206e:	53                   	push   %ebx
8010206f:	e8 2c fe ff ff       	call   80101ea0 <iunlock>
  iput(ip);
80102074:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102077:	83 c4 10             	add    $0x10,%esp
}
8010207a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010207d:	c9                   	leave  
  iput(ip);
8010207e:	e9 6d fe ff ff       	jmp    80101ef0 <iput>
80102083:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010208a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102090 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102090:	f3 0f 1e fb          	endbr32 
80102094:	55                   	push   %ebp
80102095:	89 e5                	mov    %esp,%ebp
80102097:	8b 55 08             	mov    0x8(%ebp),%edx
8010209a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
8010209d:	8b 0a                	mov    (%edx),%ecx
8010209f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801020a2:	8b 4a 04             	mov    0x4(%edx),%ecx
801020a5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801020a8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801020ac:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801020af:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801020b3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801020b7:	8b 52 58             	mov    0x58(%edx),%edx
801020ba:	89 50 10             	mov    %edx,0x10(%eax)
}
801020bd:	5d                   	pop    %ebp
801020be:	c3                   	ret    
801020bf:	90                   	nop

801020c0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801020c0:	f3 0f 1e fb          	endbr32 
801020c4:	55                   	push   %ebp
801020c5:	89 e5                	mov    %esp,%ebp
801020c7:	57                   	push   %edi
801020c8:	56                   	push   %esi
801020c9:	53                   	push   %ebx
801020ca:	83 ec 1c             	sub    $0x1c,%esp
801020cd:	8b 7d 0c             	mov    0xc(%ebp),%edi
801020d0:	8b 45 08             	mov    0x8(%ebp),%eax
801020d3:	8b 75 10             	mov    0x10(%ebp),%esi
801020d6:	89 7d e0             	mov    %edi,-0x20(%ebp)
801020d9:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020dc:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801020e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
801020e4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801020e7:	0f 84 a3 00 00 00    	je     80102190 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801020ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
801020f0:	8b 40 58             	mov    0x58(%eax),%eax
801020f3:	39 c6                	cmp    %eax,%esi
801020f5:	0f 87 b6 00 00 00    	ja     801021b1 <readi+0xf1>
801020fb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801020fe:	31 c9                	xor    %ecx,%ecx
80102100:	89 da                	mov    %ebx,%edx
80102102:	01 f2                	add    %esi,%edx
80102104:	0f 92 c1             	setb   %cl
80102107:	89 cf                	mov    %ecx,%edi
80102109:	0f 82 a2 00 00 00    	jb     801021b1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010210f:	89 c1                	mov    %eax,%ecx
80102111:	29 f1                	sub    %esi,%ecx
80102113:	39 d0                	cmp    %edx,%eax
80102115:	0f 43 cb             	cmovae %ebx,%ecx
80102118:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010211b:	85 c9                	test   %ecx,%ecx
8010211d:	74 63                	je     80102182 <readi+0xc2>
8010211f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102120:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102123:	89 f2                	mov    %esi,%edx
80102125:	c1 ea 09             	shr    $0x9,%edx
80102128:	89 d8                	mov    %ebx,%eax
8010212a:	e8 61 f9 ff ff       	call   80101a90 <bmap>
8010212f:	83 ec 08             	sub    $0x8,%esp
80102132:	50                   	push   %eax
80102133:	ff 33                	pushl  (%ebx)
80102135:	e8 96 df ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010213a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010213d:	b9 00 02 00 00       	mov    $0x200,%ecx
80102142:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102145:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102147:	89 f0                	mov    %esi,%eax
80102149:	25 ff 01 00 00       	and    $0x1ff,%eax
8010214e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102150:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102153:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102155:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102159:	39 d9                	cmp    %ebx,%ecx
8010215b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010215e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010215f:	01 df                	add    %ebx,%edi
80102161:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102163:	50                   	push   %eax
80102164:	ff 75 e0             	pushl  -0x20(%ebp)
80102167:	e8 04 2c 00 00       	call   80104d70 <memmove>
    brelse(bp);
8010216c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010216f:	89 14 24             	mov    %edx,(%esp)
80102172:	e8 79 e0 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102177:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010217a:	83 c4 10             	add    $0x10,%esp
8010217d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102180:	77 9e                	ja     80102120 <readi+0x60>
  }
  return n;
80102182:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102185:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102188:	5b                   	pop    %ebx
80102189:	5e                   	pop    %esi
8010218a:	5f                   	pop    %edi
8010218b:	5d                   	pop    %ebp
8010218c:	c3                   	ret    
8010218d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102190:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102194:	66 83 f8 09          	cmp    $0x9,%ax
80102198:	77 17                	ja     801021b1 <readi+0xf1>
8010219a:	8b 04 c5 40 22 11 80 	mov    -0x7feeddc0(,%eax,8),%eax
801021a1:	85 c0                	test   %eax,%eax
801021a3:	74 0c                	je     801021b1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
801021a5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801021a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021ab:	5b                   	pop    %ebx
801021ac:	5e                   	pop    %esi
801021ad:	5f                   	pop    %edi
801021ae:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
801021af:	ff e0                	jmp    *%eax
      return -1;
801021b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021b6:	eb cd                	jmp    80102185 <readi+0xc5>
801021b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021bf:	90                   	nop

801021c0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801021c0:	f3 0f 1e fb          	endbr32 
801021c4:	55                   	push   %ebp
801021c5:	89 e5                	mov    %esp,%ebp
801021c7:	57                   	push   %edi
801021c8:	56                   	push   %esi
801021c9:	53                   	push   %ebx
801021ca:	83 ec 1c             	sub    $0x1c,%esp
801021cd:	8b 45 08             	mov    0x8(%ebp),%eax
801021d0:	8b 75 0c             	mov    0xc(%ebp),%esi
801021d3:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801021d6:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801021db:	89 75 dc             	mov    %esi,-0x24(%ebp)
801021de:	89 45 d8             	mov    %eax,-0x28(%ebp)
801021e1:	8b 75 10             	mov    0x10(%ebp),%esi
801021e4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
801021e7:	0f 84 b3 00 00 00    	je     801022a0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801021ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
801021f0:	39 70 58             	cmp    %esi,0x58(%eax)
801021f3:	0f 82 e3 00 00 00    	jb     801022dc <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
801021f9:	8b 7d e0             	mov    -0x20(%ebp),%edi
801021fc:	89 f8                	mov    %edi,%eax
801021fe:	01 f0                	add    %esi,%eax
80102200:	0f 82 d6 00 00 00    	jb     801022dc <writei+0x11c>
80102206:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010220b:	0f 87 cb 00 00 00    	ja     801022dc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102211:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102218:	85 ff                	test   %edi,%edi
8010221a:	74 75                	je     80102291 <writei+0xd1>
8010221c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102220:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102223:	89 f2                	mov    %esi,%edx
80102225:	c1 ea 09             	shr    $0x9,%edx
80102228:	89 f8                	mov    %edi,%eax
8010222a:	e8 61 f8 ff ff       	call   80101a90 <bmap>
8010222f:	83 ec 08             	sub    $0x8,%esp
80102232:	50                   	push   %eax
80102233:	ff 37                	pushl  (%edi)
80102235:	e8 96 de ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010223a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010223f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102242:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102245:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102247:	89 f0                	mov    %esi,%eax
80102249:	83 c4 0c             	add    $0xc,%esp
8010224c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102251:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102253:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102257:	39 d9                	cmp    %ebx,%ecx
80102259:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010225c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010225d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
8010225f:	ff 75 dc             	pushl  -0x24(%ebp)
80102262:	50                   	push   %eax
80102263:	e8 08 2b 00 00       	call   80104d70 <memmove>
    log_write(bp);
80102268:	89 3c 24             	mov    %edi,(%esp)
8010226b:	e8 00 13 00 00       	call   80103570 <log_write>
    brelse(bp);
80102270:	89 3c 24             	mov    %edi,(%esp)
80102273:	e8 78 df ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102278:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010227b:	83 c4 10             	add    $0x10,%esp
8010227e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102281:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102284:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102287:	77 97                	ja     80102220 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102289:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010228c:	3b 70 58             	cmp    0x58(%eax),%esi
8010228f:	77 37                	ja     801022c8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102291:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102294:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102297:	5b                   	pop    %ebx
80102298:	5e                   	pop    %esi
80102299:	5f                   	pop    %edi
8010229a:	5d                   	pop    %ebp
8010229b:	c3                   	ret    
8010229c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801022a0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801022a4:	66 83 f8 09          	cmp    $0x9,%ax
801022a8:	77 32                	ja     801022dc <writei+0x11c>
801022aa:	8b 04 c5 44 22 11 80 	mov    -0x7feeddbc(,%eax,8),%eax
801022b1:	85 c0                	test   %eax,%eax
801022b3:	74 27                	je     801022dc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
801022b5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801022b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022bb:	5b                   	pop    %ebx
801022bc:	5e                   	pop    %esi
801022bd:	5f                   	pop    %edi
801022be:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801022bf:	ff e0                	jmp    *%eax
801022c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
801022c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
801022cb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
801022ce:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801022d1:	50                   	push   %eax
801022d2:	e8 29 fa ff ff       	call   80101d00 <iupdate>
801022d7:	83 c4 10             	add    $0x10,%esp
801022da:	eb b5                	jmp    80102291 <writei+0xd1>
      return -1;
801022dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022e1:	eb b1                	jmp    80102294 <writei+0xd4>
801022e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022f0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801022f0:	f3 0f 1e fb          	endbr32 
801022f4:	55                   	push   %ebp
801022f5:	89 e5                	mov    %esp,%ebp
801022f7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801022fa:	6a 0e                	push   $0xe
801022fc:	ff 75 0c             	pushl  0xc(%ebp)
801022ff:	ff 75 08             	pushl  0x8(%ebp)
80102302:	e8 d9 2a 00 00       	call   80104de0 <strncmp>
}
80102307:	c9                   	leave  
80102308:	c3                   	ret    
80102309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102310 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102310:	f3 0f 1e fb          	endbr32 
80102314:	55                   	push   %ebp
80102315:	89 e5                	mov    %esp,%ebp
80102317:	57                   	push   %edi
80102318:	56                   	push   %esi
80102319:	53                   	push   %ebx
8010231a:	83 ec 1c             	sub    $0x1c,%esp
8010231d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102320:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102325:	0f 85 89 00 00 00    	jne    801023b4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010232b:	8b 53 58             	mov    0x58(%ebx),%edx
8010232e:	31 ff                	xor    %edi,%edi
80102330:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102333:	85 d2                	test   %edx,%edx
80102335:	74 42                	je     80102379 <dirlookup+0x69>
80102337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010233e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102340:	6a 10                	push   $0x10
80102342:	57                   	push   %edi
80102343:	56                   	push   %esi
80102344:	53                   	push   %ebx
80102345:	e8 76 fd ff ff       	call   801020c0 <readi>
8010234a:	83 c4 10             	add    $0x10,%esp
8010234d:	83 f8 10             	cmp    $0x10,%eax
80102350:	75 55                	jne    801023a7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80102352:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102357:	74 18                	je     80102371 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80102359:	83 ec 04             	sub    $0x4,%esp
8010235c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010235f:	6a 0e                	push   $0xe
80102361:	50                   	push   %eax
80102362:	ff 75 0c             	pushl  0xc(%ebp)
80102365:	e8 76 2a 00 00       	call   80104de0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
8010236a:	83 c4 10             	add    $0x10,%esp
8010236d:	85 c0                	test   %eax,%eax
8010236f:	74 17                	je     80102388 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102371:	83 c7 10             	add    $0x10,%edi
80102374:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102377:	72 c7                	jb     80102340 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102379:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010237c:	31 c0                	xor    %eax,%eax
}
8010237e:	5b                   	pop    %ebx
8010237f:	5e                   	pop    %esi
80102380:	5f                   	pop    %edi
80102381:	5d                   	pop    %ebp
80102382:	c3                   	ret    
80102383:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102387:	90                   	nop
      if(poff)
80102388:	8b 45 10             	mov    0x10(%ebp),%eax
8010238b:	85 c0                	test   %eax,%eax
8010238d:	74 05                	je     80102394 <dirlookup+0x84>
        *poff = off;
8010238f:	8b 45 10             	mov    0x10(%ebp),%eax
80102392:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80102394:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102398:	8b 03                	mov    (%ebx),%eax
8010239a:	e8 01 f6 ff ff       	call   801019a0 <iget>
}
8010239f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023a2:	5b                   	pop    %ebx
801023a3:	5e                   	pop    %esi
801023a4:	5f                   	pop    %edi
801023a5:	5d                   	pop    %ebp
801023a6:	c3                   	ret    
      panic("dirlookup read");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 c1 78 10 80       	push   $0x801078c1
801023af:	e8 4c e3 ff ff       	call   80100700 <panic>
    panic("dirlookup not DIR");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 af 78 10 80       	push   $0x801078af
801023bc:	e8 3f e3 ff ff       	call   80100700 <panic>
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023cf:	90                   	nop

801023d0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	57                   	push   %edi
801023d4:	56                   	push   %esi
801023d5:	53                   	push   %ebx
801023d6:	89 c3                	mov    %eax,%ebx
801023d8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801023db:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801023de:	89 55 e0             	mov    %edx,-0x20(%ebp)
801023e1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801023e4:	0f 84 86 01 00 00    	je     80102570 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801023ea:	e8 d1 1b 00 00       	call   80103fc0 <myproc>
  acquire(&icache.lock);
801023ef:	83 ec 0c             	sub    $0xc,%esp
801023f2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
801023f4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801023f7:	68 c0 22 11 80       	push   $0x801122c0
801023fc:	e8 bf 27 00 00       	call   80104bc0 <acquire>
  ip->ref++;
80102401:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102405:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
8010240c:	e8 6f 28 00 00       	call   80104c80 <release>
80102411:	83 c4 10             	add    $0x10,%esp
80102414:	eb 0d                	jmp    80102423 <namex+0x53>
80102416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010241d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80102420:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102423:	0f b6 07             	movzbl (%edi),%eax
80102426:	3c 2f                	cmp    $0x2f,%al
80102428:	74 f6                	je     80102420 <namex+0x50>
  if(*path == 0)
8010242a:	84 c0                	test   %al,%al
8010242c:	0f 84 ee 00 00 00    	je     80102520 <namex+0x150>
  while(*path != '/' && *path != 0)
80102432:	0f b6 07             	movzbl (%edi),%eax
80102435:	84 c0                	test   %al,%al
80102437:	0f 84 fb 00 00 00    	je     80102538 <namex+0x168>
8010243d:	89 fb                	mov    %edi,%ebx
8010243f:	3c 2f                	cmp    $0x2f,%al
80102441:	0f 84 f1 00 00 00    	je     80102538 <namex+0x168>
80102447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010244e:	66 90                	xchg   %ax,%ax
80102450:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80102454:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80102457:	3c 2f                	cmp    $0x2f,%al
80102459:	74 04                	je     8010245f <namex+0x8f>
8010245b:	84 c0                	test   %al,%al
8010245d:	75 f1                	jne    80102450 <namex+0x80>
  len = path - s;
8010245f:	89 d8                	mov    %ebx,%eax
80102461:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80102463:	83 f8 0d             	cmp    $0xd,%eax
80102466:	0f 8e 84 00 00 00    	jle    801024f0 <namex+0x120>
    memmove(name, s, DIRSIZ);
8010246c:	83 ec 04             	sub    $0x4,%esp
8010246f:	6a 0e                	push   $0xe
80102471:	57                   	push   %edi
    path++;
80102472:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80102474:	ff 75 e4             	pushl  -0x1c(%ebp)
80102477:	e8 f4 28 00 00       	call   80104d70 <memmove>
8010247c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010247f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102482:	75 0c                	jne    80102490 <namex+0xc0>
80102484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102488:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
8010248b:	80 3f 2f             	cmpb   $0x2f,(%edi)
8010248e:	74 f8                	je     80102488 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102490:	83 ec 0c             	sub    $0xc,%esp
80102493:	56                   	push   %esi
80102494:	e8 27 f9 ff ff       	call   80101dc0 <ilock>
    if(ip->type != T_DIR){
80102499:	83 c4 10             	add    $0x10,%esp
8010249c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801024a1:	0f 85 a1 00 00 00    	jne    80102548 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801024a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801024aa:	85 d2                	test   %edx,%edx
801024ac:	74 09                	je     801024b7 <namex+0xe7>
801024ae:	80 3f 00             	cmpb   $0x0,(%edi)
801024b1:	0f 84 d9 00 00 00    	je     80102590 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024b7:	83 ec 04             	sub    $0x4,%esp
801024ba:	6a 00                	push   $0x0
801024bc:	ff 75 e4             	pushl  -0x1c(%ebp)
801024bf:	56                   	push   %esi
801024c0:	e8 4b fe ff ff       	call   80102310 <dirlookup>
801024c5:	83 c4 10             	add    $0x10,%esp
801024c8:	89 c3                	mov    %eax,%ebx
801024ca:	85 c0                	test   %eax,%eax
801024cc:	74 7a                	je     80102548 <namex+0x178>
  iunlock(ip);
801024ce:	83 ec 0c             	sub    $0xc,%esp
801024d1:	56                   	push   %esi
801024d2:	e8 c9 f9 ff ff       	call   80101ea0 <iunlock>
  iput(ip);
801024d7:	89 34 24             	mov    %esi,(%esp)
801024da:	89 de                	mov    %ebx,%esi
801024dc:	e8 0f fa ff ff       	call   80101ef0 <iput>
801024e1:	83 c4 10             	add    $0x10,%esp
801024e4:	e9 3a ff ff ff       	jmp    80102423 <namex+0x53>
801024e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801024f3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801024f6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
801024f9:	83 ec 04             	sub    $0x4,%esp
801024fc:	50                   	push   %eax
801024fd:	57                   	push   %edi
    name[len] = 0;
801024fe:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102500:	ff 75 e4             	pushl  -0x1c(%ebp)
80102503:	e8 68 28 00 00       	call   80104d70 <memmove>
    name[len] = 0;
80102508:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010250b:	83 c4 10             	add    $0x10,%esp
8010250e:	c6 00 00             	movb   $0x0,(%eax)
80102511:	e9 69 ff ff ff       	jmp    8010247f <namex+0xaf>
80102516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010251d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102520:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102523:	85 c0                	test   %eax,%eax
80102525:	0f 85 85 00 00 00    	jne    801025b0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010252b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010252e:	89 f0                	mov    %esi,%eax
80102530:	5b                   	pop    %ebx
80102531:	5e                   	pop    %esi
80102532:	5f                   	pop    %edi
80102533:	5d                   	pop    %ebp
80102534:	c3                   	ret    
80102535:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102538:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010253b:	89 fb                	mov    %edi,%ebx
8010253d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102540:	31 c0                	xor    %eax,%eax
80102542:	eb b5                	jmp    801024f9 <namex+0x129>
80102544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	56                   	push   %esi
8010254c:	e8 4f f9 ff ff       	call   80101ea0 <iunlock>
  iput(ip);
80102551:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102554:	31 f6                	xor    %esi,%esi
  iput(ip);
80102556:	e8 95 f9 ff ff       	call   80101ef0 <iput>
      return 0;
8010255b:	83 c4 10             	add    $0x10,%esp
}
8010255e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102561:	89 f0                	mov    %esi,%eax
80102563:	5b                   	pop    %ebx
80102564:	5e                   	pop    %esi
80102565:	5f                   	pop    %edi
80102566:	5d                   	pop    %ebp
80102567:	c3                   	ret    
80102568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010256f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80102570:	ba 01 00 00 00       	mov    $0x1,%edx
80102575:	b8 01 00 00 00       	mov    $0x1,%eax
8010257a:	89 df                	mov    %ebx,%edi
8010257c:	e8 1f f4 ff ff       	call   801019a0 <iget>
80102581:	89 c6                	mov    %eax,%esi
80102583:	e9 9b fe ff ff       	jmp    80102423 <namex+0x53>
80102588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010258f:	90                   	nop
      iunlock(ip);
80102590:	83 ec 0c             	sub    $0xc,%esp
80102593:	56                   	push   %esi
80102594:	e8 07 f9 ff ff       	call   80101ea0 <iunlock>
      return ip;
80102599:	83 c4 10             	add    $0x10,%esp
}
8010259c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010259f:	89 f0                	mov    %esi,%eax
801025a1:	5b                   	pop    %ebx
801025a2:	5e                   	pop    %esi
801025a3:	5f                   	pop    %edi
801025a4:	5d                   	pop    %ebp
801025a5:	c3                   	ret    
801025a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ad:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
801025b0:	83 ec 0c             	sub    $0xc,%esp
801025b3:	56                   	push   %esi
    return 0;
801025b4:	31 f6                	xor    %esi,%esi
    iput(ip);
801025b6:	e8 35 f9 ff ff       	call   80101ef0 <iput>
    return 0;
801025bb:	83 c4 10             	add    $0x10,%esp
801025be:	e9 68 ff ff ff       	jmp    8010252b <namex+0x15b>
801025c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801025d0 <dirlink>:
{
801025d0:	f3 0f 1e fb          	endbr32 
801025d4:	55                   	push   %ebp
801025d5:	89 e5                	mov    %esp,%ebp
801025d7:	57                   	push   %edi
801025d8:	56                   	push   %esi
801025d9:	53                   	push   %ebx
801025da:	83 ec 20             	sub    $0x20,%esp
801025dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801025e0:	6a 00                	push   $0x0
801025e2:	ff 75 0c             	pushl  0xc(%ebp)
801025e5:	53                   	push   %ebx
801025e6:	e8 25 fd ff ff       	call   80102310 <dirlookup>
801025eb:	83 c4 10             	add    $0x10,%esp
801025ee:	85 c0                	test   %eax,%eax
801025f0:	75 6b                	jne    8010265d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
801025f2:	8b 7b 58             	mov    0x58(%ebx),%edi
801025f5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801025f8:	85 ff                	test   %edi,%edi
801025fa:	74 2d                	je     80102629 <dirlink+0x59>
801025fc:	31 ff                	xor    %edi,%edi
801025fe:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102601:	eb 0d                	jmp    80102610 <dirlink+0x40>
80102603:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102607:	90                   	nop
80102608:	83 c7 10             	add    $0x10,%edi
8010260b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010260e:	73 19                	jae    80102629 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102610:	6a 10                	push   $0x10
80102612:	57                   	push   %edi
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	e8 a6 fa ff ff       	call   801020c0 <readi>
8010261a:	83 c4 10             	add    $0x10,%esp
8010261d:	83 f8 10             	cmp    $0x10,%eax
80102620:	75 4e                	jne    80102670 <dirlink+0xa0>
    if(de.inum == 0)
80102622:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102627:	75 df                	jne    80102608 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102629:	83 ec 04             	sub    $0x4,%esp
8010262c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010262f:	6a 0e                	push   $0xe
80102631:	ff 75 0c             	pushl  0xc(%ebp)
80102634:	50                   	push   %eax
80102635:	e8 f6 27 00 00       	call   80104e30 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010263a:	6a 10                	push   $0x10
  de.inum = inum;
8010263c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010263f:	57                   	push   %edi
80102640:	56                   	push   %esi
80102641:	53                   	push   %ebx
  de.inum = inum;
80102642:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102646:	e8 75 fb ff ff       	call   801021c0 <writei>
8010264b:	83 c4 20             	add    $0x20,%esp
8010264e:	83 f8 10             	cmp    $0x10,%eax
80102651:	75 2a                	jne    8010267d <dirlink+0xad>
  return 0;
80102653:	31 c0                	xor    %eax,%eax
}
80102655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102658:	5b                   	pop    %ebx
80102659:	5e                   	pop    %esi
8010265a:	5f                   	pop    %edi
8010265b:	5d                   	pop    %ebp
8010265c:	c3                   	ret    
    iput(ip);
8010265d:	83 ec 0c             	sub    $0xc,%esp
80102660:	50                   	push   %eax
80102661:	e8 8a f8 ff ff       	call   80101ef0 <iput>
    return -1;
80102666:	83 c4 10             	add    $0x10,%esp
80102669:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010266e:	eb e5                	jmp    80102655 <dirlink+0x85>
      panic("dirlink read");
80102670:	83 ec 0c             	sub    $0xc,%esp
80102673:	68 d0 78 10 80       	push   $0x801078d0
80102678:	e8 83 e0 ff ff       	call   80100700 <panic>
    panic("dirlink");
8010267d:	83 ec 0c             	sub    $0xc,%esp
80102680:	68 9e 7e 10 80       	push   $0x80107e9e
80102685:	e8 76 e0 ff ff       	call   80100700 <panic>
8010268a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102690 <namei>:

struct inode*
namei(char *path)
{
80102690:	f3 0f 1e fb          	endbr32 
80102694:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102695:	31 d2                	xor    %edx,%edx
{
80102697:	89 e5                	mov    %esp,%ebp
80102699:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010269c:	8b 45 08             	mov    0x8(%ebp),%eax
8010269f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801026a2:	e8 29 fd ff ff       	call   801023d0 <namex>
}
801026a7:	c9                   	leave  
801026a8:	c3                   	ret    
801026a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801026b0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801026b0:	f3 0f 1e fb          	endbr32 
801026b4:	55                   	push   %ebp
  return namex(path, 1, name);
801026b5:	ba 01 00 00 00       	mov    $0x1,%edx
{
801026ba:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801026bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801026bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
801026c2:	5d                   	pop    %ebp
  return namex(path, 1, name);
801026c3:	e9 08 fd ff ff       	jmp    801023d0 <namex>
801026c8:	66 90                	xchg   %ax,%ax
801026ca:	66 90                	xchg   %ax,%ax
801026cc:	66 90                	xchg   %ax,%ax
801026ce:	66 90                	xchg   %ax,%ax

801026d0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	57                   	push   %edi
801026d4:	56                   	push   %esi
801026d5:	53                   	push   %ebx
801026d6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801026d9:	85 c0                	test   %eax,%eax
801026db:	0f 84 b4 00 00 00    	je     80102795 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801026e1:	8b 70 08             	mov    0x8(%eax),%esi
801026e4:	89 c3                	mov    %eax,%ebx
801026e6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801026ec:	0f 87 96 00 00 00    	ja     80102788 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801026f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026fe:	66 90                	xchg   %ax,%ax
80102700:	89 ca                	mov    %ecx,%edx
80102702:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102703:	83 e0 c0             	and    $0xffffffc0,%eax
80102706:	3c 40                	cmp    $0x40,%al
80102708:	75 f6                	jne    80102700 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010270a:	31 ff                	xor    %edi,%edi
8010270c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102711:	89 f8                	mov    %edi,%eax
80102713:	ee                   	out    %al,(%dx)
80102714:	b8 01 00 00 00       	mov    $0x1,%eax
80102719:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010271e:	ee                   	out    %al,(%dx)
8010271f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102724:	89 f0                	mov    %esi,%eax
80102726:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102727:	89 f0                	mov    %esi,%eax
80102729:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010272e:	c1 f8 08             	sar    $0x8,%eax
80102731:	ee                   	out    %al,(%dx)
80102732:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102737:	89 f8                	mov    %edi,%eax
80102739:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010273a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010273e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102743:	c1 e0 04             	shl    $0x4,%eax
80102746:	83 e0 10             	and    $0x10,%eax
80102749:	83 c8 e0             	or     $0xffffffe0,%eax
8010274c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010274d:	f6 03 04             	testb  $0x4,(%ebx)
80102750:	75 16                	jne    80102768 <idestart+0x98>
80102752:	b8 20 00 00 00       	mov    $0x20,%eax
80102757:	89 ca                	mov    %ecx,%edx
80102759:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010275a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010275d:	5b                   	pop    %ebx
8010275e:	5e                   	pop    %esi
8010275f:	5f                   	pop    %edi
80102760:	5d                   	pop    %ebp
80102761:	c3                   	ret    
80102762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102768:	b8 30 00 00 00       	mov    $0x30,%eax
8010276d:	89 ca                	mov    %ecx,%edx
8010276f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102770:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102775:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102778:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010277d:	fc                   	cld    
8010277e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102780:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102783:	5b                   	pop    %ebx
80102784:	5e                   	pop    %esi
80102785:	5f                   	pop    %edi
80102786:	5d                   	pop    %ebp
80102787:	c3                   	ret    
    panic("incorrect blockno");
80102788:	83 ec 0c             	sub    $0xc,%esp
8010278b:	68 3c 79 10 80       	push   $0x8010793c
80102790:	e8 6b df ff ff       	call   80100700 <panic>
    panic("idestart");
80102795:	83 ec 0c             	sub    $0xc,%esp
80102798:	68 33 79 10 80       	push   $0x80107933
8010279d:	e8 5e df ff ff       	call   80100700 <panic>
801027a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801027b0 <ideinit>:
{
801027b0:	f3 0f 1e fb          	endbr32 
801027b4:	55                   	push   %ebp
801027b5:	89 e5                	mov    %esp,%ebp
801027b7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801027ba:	68 4e 79 10 80       	push   $0x8010794e
801027bf:	68 a0 b5 10 80       	push   $0x8010b5a0
801027c4:	e8 77 22 00 00       	call   80104a40 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801027c9:	58                   	pop    %eax
801027ca:	a1 e0 45 11 80       	mov    0x801145e0,%eax
801027cf:	5a                   	pop    %edx
801027d0:	83 e8 01             	sub    $0x1,%eax
801027d3:	50                   	push   %eax
801027d4:	6a 0e                	push   $0xe
801027d6:	e8 b5 02 00 00       	call   80102a90 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801027db:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027de:	ba f7 01 00 00       	mov    $0x1f7,%edx
801027e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027e7:	90                   	nop
801027e8:	ec                   	in     (%dx),%al
801027e9:	83 e0 c0             	and    $0xffffffc0,%eax
801027ec:	3c 40                	cmp    $0x40,%al
801027ee:	75 f8                	jne    801027e8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027f0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801027f5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801027fa:	ee                   	out    %al,(%dx)
801027fb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102800:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102805:	eb 0e                	jmp    80102815 <ideinit+0x65>
80102807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010280e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102810:	83 e9 01             	sub    $0x1,%ecx
80102813:	74 0f                	je     80102824 <ideinit+0x74>
80102815:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102816:	84 c0                	test   %al,%al
80102818:	74 f6                	je     80102810 <ideinit+0x60>
      havedisk1 = 1;
8010281a:	c7 05 80 b5 10 80 01 	movl   $0x1,0x8010b580
80102821:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102824:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102829:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010282e:	ee                   	out    %al,(%dx)
}
8010282f:	c9                   	leave  
80102830:	c3                   	ret    
80102831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010283f:	90                   	nop

80102840 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102840:	f3 0f 1e fb          	endbr32 
80102844:	55                   	push   %ebp
80102845:	89 e5                	mov    %esp,%ebp
80102847:	57                   	push   %edi
80102848:	56                   	push   %esi
80102849:	53                   	push   %ebx
8010284a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010284d:	68 a0 b5 10 80       	push   $0x8010b5a0
80102852:	e8 69 23 00 00       	call   80104bc0 <acquire>

  if((b = idequeue) == 0){
80102857:	8b 1d 84 b5 10 80    	mov    0x8010b584,%ebx
8010285d:	83 c4 10             	add    $0x10,%esp
80102860:	85 db                	test   %ebx,%ebx
80102862:	74 5f                	je     801028c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102864:	8b 43 58             	mov    0x58(%ebx),%eax
80102867:	a3 84 b5 10 80       	mov    %eax,0x8010b584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010286c:	8b 33                	mov    (%ebx),%esi
8010286e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102874:	75 2b                	jne    801028a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102876:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010287b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010287f:	90                   	nop
80102880:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102881:	89 c1                	mov    %eax,%ecx
80102883:	83 e1 c0             	and    $0xffffffc0,%ecx
80102886:	80 f9 40             	cmp    $0x40,%cl
80102889:	75 f5                	jne    80102880 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010288b:	a8 21                	test   $0x21,%al
8010288d:	75 12                	jne    801028a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010288f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102892:	b9 80 00 00 00       	mov    $0x80,%ecx
80102897:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010289c:	fc                   	cld    
8010289d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010289f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801028a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801028a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801028a7:	83 ce 02             	or     $0x2,%esi
801028aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801028ac:	53                   	push   %ebx
801028ad:	e8 8e 1e 00 00       	call   80104740 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801028b2:	a1 84 b5 10 80       	mov    0x8010b584,%eax
801028b7:	83 c4 10             	add    $0x10,%esp
801028ba:	85 c0                	test   %eax,%eax
801028bc:	74 05                	je     801028c3 <ideintr+0x83>
    idestart(idequeue);
801028be:	e8 0d fe ff ff       	call   801026d0 <idestart>
    release(&idelock);
801028c3:	83 ec 0c             	sub    $0xc,%esp
801028c6:	68 a0 b5 10 80       	push   $0x8010b5a0
801028cb:	e8 b0 23 00 00       	call   80104c80 <release>

  release(&idelock);
}
801028d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028d3:	5b                   	pop    %ebx
801028d4:	5e                   	pop    %esi
801028d5:	5f                   	pop    %edi
801028d6:	5d                   	pop    %ebp
801028d7:	c3                   	ret    
801028d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028df:	90                   	nop

801028e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801028e0:	f3 0f 1e fb          	endbr32 
801028e4:	55                   	push   %ebp
801028e5:	89 e5                	mov    %esp,%ebp
801028e7:	53                   	push   %ebx
801028e8:	83 ec 10             	sub    $0x10,%esp
801028eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801028ee:	8d 43 0c             	lea    0xc(%ebx),%eax
801028f1:	50                   	push   %eax
801028f2:	e8 e9 20 00 00       	call   801049e0 <holdingsleep>
801028f7:	83 c4 10             	add    $0x10,%esp
801028fa:	85 c0                	test   %eax,%eax
801028fc:	0f 84 cf 00 00 00    	je     801029d1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102902:	8b 03                	mov    (%ebx),%eax
80102904:	83 e0 06             	and    $0x6,%eax
80102907:	83 f8 02             	cmp    $0x2,%eax
8010290a:	0f 84 b4 00 00 00    	je     801029c4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102910:	8b 53 04             	mov    0x4(%ebx),%edx
80102913:	85 d2                	test   %edx,%edx
80102915:	74 0d                	je     80102924 <iderw+0x44>
80102917:	a1 80 b5 10 80       	mov    0x8010b580,%eax
8010291c:	85 c0                	test   %eax,%eax
8010291e:	0f 84 93 00 00 00    	je     801029b7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102924:	83 ec 0c             	sub    $0xc,%esp
80102927:	68 a0 b5 10 80       	push   $0x8010b5a0
8010292c:	e8 8f 22 00 00       	call   80104bc0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102931:	a1 84 b5 10 80       	mov    0x8010b584,%eax
  b->qnext = 0;
80102936:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010293d:	83 c4 10             	add    $0x10,%esp
80102940:	85 c0                	test   %eax,%eax
80102942:	74 6c                	je     801029b0 <iderw+0xd0>
80102944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102948:	89 c2                	mov    %eax,%edx
8010294a:	8b 40 58             	mov    0x58(%eax),%eax
8010294d:	85 c0                	test   %eax,%eax
8010294f:	75 f7                	jne    80102948 <iderw+0x68>
80102951:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102954:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102956:	39 1d 84 b5 10 80    	cmp    %ebx,0x8010b584
8010295c:	74 42                	je     801029a0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010295e:	8b 03                	mov    (%ebx),%eax
80102960:	83 e0 06             	and    $0x6,%eax
80102963:	83 f8 02             	cmp    $0x2,%eax
80102966:	74 23                	je     8010298b <iderw+0xab>
80102968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010296f:	90                   	nop
    sleep(b, &idelock);
80102970:	83 ec 08             	sub    $0x8,%esp
80102973:	68 a0 b5 10 80       	push   $0x8010b5a0
80102978:	53                   	push   %ebx
80102979:	e8 02 1c 00 00       	call   80104580 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010297e:	8b 03                	mov    (%ebx),%eax
80102980:	83 c4 10             	add    $0x10,%esp
80102983:	83 e0 06             	and    $0x6,%eax
80102986:	83 f8 02             	cmp    $0x2,%eax
80102989:	75 e5                	jne    80102970 <iderw+0x90>
  }


  release(&idelock);
8010298b:	c7 45 08 a0 b5 10 80 	movl   $0x8010b5a0,0x8(%ebp)
}
80102992:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102995:	c9                   	leave  
  release(&idelock);
80102996:	e9 e5 22 00 00       	jmp    80104c80 <release>
8010299b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010299f:	90                   	nop
    idestart(b);
801029a0:	89 d8                	mov    %ebx,%eax
801029a2:	e8 29 fd ff ff       	call   801026d0 <idestart>
801029a7:	eb b5                	jmp    8010295e <iderw+0x7e>
801029a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029b0:	ba 84 b5 10 80       	mov    $0x8010b584,%edx
801029b5:	eb 9d                	jmp    80102954 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801029b7:	83 ec 0c             	sub    $0xc,%esp
801029ba:	68 7d 79 10 80       	push   $0x8010797d
801029bf:	e8 3c dd ff ff       	call   80100700 <panic>
    panic("iderw: nothing to do");
801029c4:	83 ec 0c             	sub    $0xc,%esp
801029c7:	68 68 79 10 80       	push   $0x80107968
801029cc:	e8 2f dd ff ff       	call   80100700 <panic>
    panic("iderw: buf not locked");
801029d1:	83 ec 0c             	sub    $0xc,%esp
801029d4:	68 52 79 10 80       	push   $0x80107952
801029d9:	e8 22 dd ff ff       	call   80100700 <panic>
801029de:	66 90                	xchg   %ax,%ax

801029e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801029e0:	f3 0f 1e fb          	endbr32 
801029e4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801029e5:	c7 05 14 3f 11 80 00 	movl   $0xfec00000,0x80113f14
801029ec:	00 c0 fe 
{
801029ef:	89 e5                	mov    %esp,%ebp
801029f1:	56                   	push   %esi
801029f2:	53                   	push   %ebx
  ioapic->reg = reg;
801029f3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801029fa:	00 00 00 
  return ioapic->data;
801029fd:	8b 15 14 3f 11 80    	mov    0x80113f14,%edx
80102a03:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102a06:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102a0c:	8b 0d 14 3f 11 80    	mov    0x80113f14,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102a12:	0f b6 15 40 40 11 80 	movzbl 0x80114040,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a19:	c1 ee 10             	shr    $0x10,%esi
80102a1c:	89 f0                	mov    %esi,%eax
80102a1e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102a21:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102a24:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102a27:	39 c2                	cmp    %eax,%edx
80102a29:	74 16                	je     80102a41 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a2b:	83 ec 0c             	sub    $0xc,%esp
80102a2e:	68 9c 79 10 80       	push   $0x8010799c
80102a33:	e8 48 dd ff ff       	call   80100780 <cprintf>
80102a38:	8b 0d 14 3f 11 80    	mov    0x80113f14,%ecx
80102a3e:	83 c4 10             	add    $0x10,%esp
80102a41:	83 c6 21             	add    $0x21,%esi
{
80102a44:	ba 10 00 00 00       	mov    $0x10,%edx
80102a49:	b8 20 00 00 00       	mov    $0x20,%eax
80102a4e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102a50:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a52:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102a54:	8b 0d 14 3f 11 80    	mov    0x80113f14,%ecx
80102a5a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a5d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102a63:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102a66:	8d 5a 01             	lea    0x1(%edx),%ebx
80102a69:	83 c2 02             	add    $0x2,%edx
80102a6c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102a6e:	8b 0d 14 3f 11 80    	mov    0x80113f14,%ecx
80102a74:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102a7b:	39 f0                	cmp    %esi,%eax
80102a7d:	75 d1                	jne    80102a50 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a82:	5b                   	pop    %ebx
80102a83:	5e                   	pop    %esi
80102a84:	5d                   	pop    %ebp
80102a85:	c3                   	ret    
80102a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a8d:	8d 76 00             	lea    0x0(%esi),%esi

80102a90 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a90:	f3 0f 1e fb          	endbr32 
80102a94:	55                   	push   %ebp
  ioapic->reg = reg;
80102a95:	8b 0d 14 3f 11 80    	mov    0x80113f14,%ecx
{
80102a9b:	89 e5                	mov    %esp,%ebp
80102a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102aa0:	8d 50 20             	lea    0x20(%eax),%edx
80102aa3:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102aa7:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102aa9:	8b 0d 14 3f 11 80    	mov    0x80113f14,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102aaf:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102ab2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102ab8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102aba:	a1 14 3f 11 80       	mov    0x80113f14,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102abf:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102ac2:	89 50 10             	mov    %edx,0x10(%eax)
}
80102ac5:	5d                   	pop    %ebp
80102ac6:	c3                   	ret    
80102ac7:	66 90                	xchg   %ax,%ax
80102ac9:	66 90                	xchg   %ax,%ax
80102acb:	66 90                	xchg   %ax,%ax
80102acd:	66 90                	xchg   %ax,%ax
80102acf:	90                   	nop

80102ad0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102ad0:	f3 0f 1e fb          	endbr32 
80102ad4:	55                   	push   %ebp
80102ad5:	89 e5                	mov    %esp,%ebp
80102ad7:	53                   	push   %ebx
80102ad8:	83 ec 04             	sub    $0x4,%esp
80102adb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102ade:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102ae4:	75 7a                	jne    80102b60 <kfree+0x90>
80102ae6:	81 fb 88 6d 11 80    	cmp    $0x80116d88,%ebx
80102aec:	72 72                	jb     80102b60 <kfree+0x90>
80102aee:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102af4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102af9:	77 65                	ja     80102b60 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102afb:	83 ec 04             	sub    $0x4,%esp
80102afe:	68 00 10 00 00       	push   $0x1000
80102b03:	6a 01                	push   $0x1
80102b05:	53                   	push   %ebx
80102b06:	e8 c5 21 00 00       	call   80104cd0 <memset>

  if(kmem.use_lock)
80102b0b:	8b 15 54 3f 11 80    	mov    0x80113f54,%edx
80102b11:	83 c4 10             	add    $0x10,%esp
80102b14:	85 d2                	test   %edx,%edx
80102b16:	75 20                	jne    80102b38 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102b18:	a1 58 3f 11 80       	mov    0x80113f58,%eax
80102b1d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102b1f:	a1 54 3f 11 80       	mov    0x80113f54,%eax
  kmem.freelist = r;
80102b24:	89 1d 58 3f 11 80    	mov    %ebx,0x80113f58
  if(kmem.use_lock)
80102b2a:	85 c0                	test   %eax,%eax
80102b2c:	75 22                	jne    80102b50 <kfree+0x80>
    release(&kmem.lock);
}
80102b2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b31:	c9                   	leave  
80102b32:	c3                   	ret    
80102b33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b37:	90                   	nop
    acquire(&kmem.lock);
80102b38:	83 ec 0c             	sub    $0xc,%esp
80102b3b:	68 20 3f 11 80       	push   $0x80113f20
80102b40:	e8 7b 20 00 00       	call   80104bc0 <acquire>
80102b45:	83 c4 10             	add    $0x10,%esp
80102b48:	eb ce                	jmp    80102b18 <kfree+0x48>
80102b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102b50:	c7 45 08 20 3f 11 80 	movl   $0x80113f20,0x8(%ebp)
}
80102b57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b5a:	c9                   	leave  
    release(&kmem.lock);
80102b5b:	e9 20 21 00 00       	jmp    80104c80 <release>
    panic("kfree");
80102b60:	83 ec 0c             	sub    $0xc,%esp
80102b63:	68 ce 79 10 80       	push   $0x801079ce
80102b68:	e8 93 db ff ff       	call   80100700 <panic>
80102b6d:	8d 76 00             	lea    0x0(%esi),%esi

80102b70 <freerange>:
{
80102b70:	f3 0f 1e fb          	endbr32 
80102b74:	55                   	push   %ebp
80102b75:	89 e5                	mov    %esp,%ebp
80102b77:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102b78:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102b7b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102b7e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102b7f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b85:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b8b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b91:	39 de                	cmp    %ebx,%esi
80102b93:	72 1f                	jb     80102bb4 <freerange+0x44>
80102b95:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102b98:	83 ec 0c             	sub    $0xc,%esp
80102b9b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ba1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102ba7:	50                   	push   %eax
80102ba8:	e8 23 ff ff ff       	call   80102ad0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bad:	83 c4 10             	add    $0x10,%esp
80102bb0:	39 f3                	cmp    %esi,%ebx
80102bb2:	76 e4                	jbe    80102b98 <freerange+0x28>
}
80102bb4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102bb7:	5b                   	pop    %ebx
80102bb8:	5e                   	pop    %esi
80102bb9:	5d                   	pop    %ebp
80102bba:	c3                   	ret    
80102bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bbf:	90                   	nop

80102bc0 <kinit1>:
{
80102bc0:	f3 0f 1e fb          	endbr32 
80102bc4:	55                   	push   %ebp
80102bc5:	89 e5                	mov    %esp,%ebp
80102bc7:	56                   	push   %esi
80102bc8:	53                   	push   %ebx
80102bc9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102bcc:	83 ec 08             	sub    $0x8,%esp
80102bcf:	68 d4 79 10 80       	push   $0x801079d4
80102bd4:	68 20 3f 11 80       	push   $0x80113f20
80102bd9:	e8 62 1e 00 00       	call   80104a40 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102bde:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102be1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102be4:	c7 05 54 3f 11 80 00 	movl   $0x0,0x80113f54
80102beb:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102bee:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102bf4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bfa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c00:	39 de                	cmp    %ebx,%esi
80102c02:	72 20                	jb     80102c24 <kinit1+0x64>
80102c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102c08:	83 ec 0c             	sub    $0xc,%esp
80102c0b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c11:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102c17:	50                   	push   %eax
80102c18:	e8 b3 fe ff ff       	call   80102ad0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c1d:	83 c4 10             	add    $0x10,%esp
80102c20:	39 de                	cmp    %ebx,%esi
80102c22:	73 e4                	jae    80102c08 <kinit1+0x48>
}
80102c24:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c27:	5b                   	pop    %ebx
80102c28:	5e                   	pop    %esi
80102c29:	5d                   	pop    %ebp
80102c2a:	c3                   	ret    
80102c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c2f:	90                   	nop

80102c30 <kinit2>:
{
80102c30:	f3 0f 1e fb          	endbr32 
80102c34:	55                   	push   %ebp
80102c35:	89 e5                	mov    %esp,%ebp
80102c37:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102c38:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102c3b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102c3e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102c3f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c45:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c4b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c51:	39 de                	cmp    %ebx,%esi
80102c53:	72 1f                	jb     80102c74 <kinit2+0x44>
80102c55:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102c58:	83 ec 0c             	sub    $0xc,%esp
80102c5b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c61:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102c67:	50                   	push   %eax
80102c68:	e8 63 fe ff ff       	call   80102ad0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c6d:	83 c4 10             	add    $0x10,%esp
80102c70:	39 de                	cmp    %ebx,%esi
80102c72:	73 e4                	jae    80102c58 <kinit2+0x28>
  kmem.use_lock = 1;
80102c74:	c7 05 54 3f 11 80 01 	movl   $0x1,0x80113f54
80102c7b:	00 00 00 
}
80102c7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c81:	5b                   	pop    %ebx
80102c82:	5e                   	pop    %esi
80102c83:	5d                   	pop    %ebp
80102c84:	c3                   	ret    
80102c85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c90 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c90:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102c94:	a1 54 3f 11 80       	mov    0x80113f54,%eax
80102c99:	85 c0                	test   %eax,%eax
80102c9b:	75 1b                	jne    80102cb8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102c9d:	a1 58 3f 11 80       	mov    0x80113f58,%eax
  if(r)
80102ca2:	85 c0                	test   %eax,%eax
80102ca4:	74 0a                	je     80102cb0 <kalloc+0x20>
    kmem.freelist = r->next;
80102ca6:	8b 10                	mov    (%eax),%edx
80102ca8:	89 15 58 3f 11 80    	mov    %edx,0x80113f58
  if(kmem.use_lock)
80102cae:	c3                   	ret    
80102caf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102cb0:	c3                   	ret    
80102cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102cb8:	55                   	push   %ebp
80102cb9:	89 e5                	mov    %esp,%ebp
80102cbb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102cbe:	68 20 3f 11 80       	push   $0x80113f20
80102cc3:	e8 f8 1e 00 00       	call   80104bc0 <acquire>
  r = kmem.freelist;
80102cc8:	a1 58 3f 11 80       	mov    0x80113f58,%eax
  if(r)
80102ccd:	8b 15 54 3f 11 80    	mov    0x80113f54,%edx
80102cd3:	83 c4 10             	add    $0x10,%esp
80102cd6:	85 c0                	test   %eax,%eax
80102cd8:	74 08                	je     80102ce2 <kalloc+0x52>
    kmem.freelist = r->next;
80102cda:	8b 08                	mov    (%eax),%ecx
80102cdc:	89 0d 58 3f 11 80    	mov    %ecx,0x80113f58
  if(kmem.use_lock)
80102ce2:	85 d2                	test   %edx,%edx
80102ce4:	74 16                	je     80102cfc <kalloc+0x6c>
    release(&kmem.lock);
80102ce6:	83 ec 0c             	sub    $0xc,%esp
80102ce9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102cec:	68 20 3f 11 80       	push   $0x80113f20
80102cf1:	e8 8a 1f 00 00       	call   80104c80 <release>
  return (char*)r;
80102cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102cf9:	83 c4 10             	add    $0x10,%esp
}
80102cfc:	c9                   	leave  
80102cfd:	c3                   	ret    
80102cfe:	66 90                	xchg   %ax,%ax

80102d00 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d00:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d04:	ba 64 00 00 00       	mov    $0x64,%edx
80102d09:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102d0a:	a8 01                	test   $0x1,%al
80102d0c:	0f 84 be 00 00 00    	je     80102dd0 <kbdgetc+0xd0>
{
80102d12:	55                   	push   %ebp
80102d13:	ba 60 00 00 00       	mov    $0x60,%edx
80102d18:	89 e5                	mov    %esp,%ebp
80102d1a:	53                   	push   %ebx
80102d1b:	ec                   	in     (%dx),%al
  return data;
80102d1c:	8b 1d d4 b5 10 80    	mov    0x8010b5d4,%ebx
    return -1;
  data = inb(KBDATAP);
80102d22:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102d25:	3c e0                	cmp    $0xe0,%al
80102d27:	74 57                	je     80102d80 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102d29:	89 d9                	mov    %ebx,%ecx
80102d2b:	83 e1 40             	and    $0x40,%ecx
80102d2e:	84 c0                	test   %al,%al
80102d30:	78 5e                	js     80102d90 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102d32:	85 c9                	test   %ecx,%ecx
80102d34:	74 09                	je     80102d3f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d36:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102d39:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102d3c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102d3f:	0f b6 8a 00 7b 10 80 	movzbl -0x7fef8500(%edx),%ecx
  shift ^= togglecode[data];
80102d46:	0f b6 82 00 7a 10 80 	movzbl -0x7fef8600(%edx),%eax
  shift |= shiftcode[data];
80102d4d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102d4f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d51:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102d53:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
  c = charcode[shift & (CTL | SHIFT)][data];
80102d59:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102d5c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d5f:	8b 04 85 e0 79 10 80 	mov    -0x7fef8620(,%eax,4),%eax
80102d66:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102d6a:	74 0b                	je     80102d77 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102d6c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102d6f:	83 fa 19             	cmp    $0x19,%edx
80102d72:	77 44                	ja     80102db8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102d74:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102d77:	5b                   	pop    %ebx
80102d78:	5d                   	pop    %ebp
80102d79:	c3                   	ret    
80102d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102d80:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102d83:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102d85:	89 1d d4 b5 10 80    	mov    %ebx,0x8010b5d4
}
80102d8b:	5b                   	pop    %ebx
80102d8c:	5d                   	pop    %ebp
80102d8d:	c3                   	ret    
80102d8e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102d90:	83 e0 7f             	and    $0x7f,%eax
80102d93:	85 c9                	test   %ecx,%ecx
80102d95:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102d98:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102d9a:	0f b6 8a 00 7b 10 80 	movzbl -0x7fef8500(%edx),%ecx
80102da1:	83 c9 40             	or     $0x40,%ecx
80102da4:	0f b6 c9             	movzbl %cl,%ecx
80102da7:	f7 d1                	not    %ecx
80102da9:	21 d9                	and    %ebx,%ecx
}
80102dab:	5b                   	pop    %ebx
80102dac:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102dad:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
}
80102db3:	c3                   	ret    
80102db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102db8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102dbb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102dbe:	5b                   	pop    %ebx
80102dbf:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102dc0:	83 f9 1a             	cmp    $0x1a,%ecx
80102dc3:	0f 42 c2             	cmovb  %edx,%eax
}
80102dc6:	c3                   	ret    
80102dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dce:	66 90                	xchg   %ax,%ax
    return -1;
80102dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102dd5:	c3                   	ret    
80102dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ddd:	8d 76 00             	lea    0x0(%esi),%esi

80102de0 <kbdintr>:

void
kbdintr(void)
{
80102de0:	f3 0f 1e fb          	endbr32 
80102de4:	55                   	push   %ebp
80102de5:	89 e5                	mov    %esp,%ebp
80102de7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102dea:	68 00 2d 10 80       	push   $0x80102d00
80102def:	e8 1c dd ff ff       	call   80100b10 <consoleintr>
}
80102df4:	83 c4 10             	add    $0x10,%esp
80102df7:	c9                   	leave  
80102df8:	c3                   	ret    
80102df9:	66 90                	xchg   %ax,%ax
80102dfb:	66 90                	xchg   %ax,%ax
80102dfd:	66 90                	xchg   %ax,%ax
80102dff:	90                   	nop

80102e00 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102e00:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102e04:	a1 5c 3f 11 80       	mov    0x80113f5c,%eax
80102e09:	85 c0                	test   %eax,%eax
80102e0b:	0f 84 c7 00 00 00    	je     80102ed8 <lapicinit+0xd8>
  lapic[index] = value;
80102e11:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102e18:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e1b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e1e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102e25:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e28:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e2b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102e32:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102e35:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e38:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102e3f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102e42:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e45:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102e4c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e4f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e52:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102e59:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e5c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e5f:	8b 50 30             	mov    0x30(%eax),%edx
80102e62:	c1 ea 10             	shr    $0x10,%edx
80102e65:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102e6b:	75 73                	jne    80102ee0 <lapicinit+0xe0>
  lapic[index] = value;
80102e6d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102e74:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e77:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e7a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102e81:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e84:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e87:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102e8e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e91:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e94:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102e9b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e9e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ea1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102ea8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102eab:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eae:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102eb5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102eb8:	8b 50 20             	mov    0x20(%eax),%edx
80102ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ebf:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102ec0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102ec6:	80 e6 10             	and    $0x10,%dh
80102ec9:	75 f5                	jne    80102ec0 <lapicinit+0xc0>
  lapic[index] = value;
80102ecb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102ed2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ed5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102ed8:	c3                   	ret    
80102ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102ee0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102ee7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102eea:	8b 50 20             	mov    0x20(%eax),%edx
}
80102eed:	e9 7b ff ff ff       	jmp    80102e6d <lapicinit+0x6d>
80102ef2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f00 <lapicid>:

int
lapicid(void)
{
80102f00:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102f04:	a1 5c 3f 11 80       	mov    0x80113f5c,%eax
80102f09:	85 c0                	test   %eax,%eax
80102f0b:	74 0b                	je     80102f18 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102f0d:	8b 40 20             	mov    0x20(%eax),%eax
80102f10:	c1 e8 18             	shr    $0x18,%eax
80102f13:	c3                   	ret    
80102f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102f18:	31 c0                	xor    %eax,%eax
}
80102f1a:	c3                   	ret    
80102f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f1f:	90                   	nop

80102f20 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f20:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102f24:	a1 5c 3f 11 80       	mov    0x80113f5c,%eax
80102f29:	85 c0                	test   %eax,%eax
80102f2b:	74 0d                	je     80102f3a <lapiceoi+0x1a>
  lapic[index] = value;
80102f2d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102f34:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f37:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102f3a:	c3                   	ret    
80102f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f40:	f3 0f 1e fb          	endbr32 
}
80102f44:	c3                   	ret    
80102f45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102f50 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f50:	f3 0f 1e fb          	endbr32 
80102f54:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f55:	b8 0f 00 00 00       	mov    $0xf,%eax
80102f5a:	ba 70 00 00 00       	mov    $0x70,%edx
80102f5f:	89 e5                	mov    %esp,%ebp
80102f61:	53                   	push   %ebx
80102f62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102f65:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f68:	ee                   	out    %al,(%dx)
80102f69:	b8 0a 00 00 00       	mov    $0xa,%eax
80102f6e:	ba 71 00 00 00       	mov    $0x71,%edx
80102f73:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102f74:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f76:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102f79:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102f7f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102f81:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102f84:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102f86:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102f89:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102f8c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102f92:	a1 5c 3f 11 80       	mov    0x80113f5c,%eax
80102f97:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f9d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fa0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102fa7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102faa:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fad:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102fb4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fb7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fba:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102fc0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fc3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102fc9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fcc:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102fd2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fd5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102fdb:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102fdc:	8b 40 20             	mov    0x20(%eax),%eax
}
80102fdf:	5d                   	pop    %ebp
80102fe0:	c3                   	ret    
80102fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fef:	90                   	nop

80102ff0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102ff0:	f3 0f 1e fb          	endbr32 
80102ff4:	55                   	push   %ebp
80102ff5:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ffa:	ba 70 00 00 00       	mov    $0x70,%edx
80102fff:	89 e5                	mov    %esp,%ebp
80103001:	57                   	push   %edi
80103002:	56                   	push   %esi
80103003:	53                   	push   %ebx
80103004:	83 ec 4c             	sub    $0x4c,%esp
80103007:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103008:	ba 71 00 00 00       	mov    $0x71,%edx
8010300d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010300e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103011:	bb 70 00 00 00       	mov    $0x70,%ebx
80103016:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103020:	31 c0                	xor    %eax,%eax
80103022:	89 da                	mov    %ebx,%edx
80103024:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103025:	b9 71 00 00 00       	mov    $0x71,%ecx
8010302a:	89 ca                	mov    %ecx,%edx
8010302c:	ec                   	in     (%dx),%al
8010302d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103030:	89 da                	mov    %ebx,%edx
80103032:	b8 02 00 00 00       	mov    $0x2,%eax
80103037:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103038:	89 ca                	mov    %ecx,%edx
8010303a:	ec                   	in     (%dx),%al
8010303b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010303e:	89 da                	mov    %ebx,%edx
80103040:	b8 04 00 00 00       	mov    $0x4,%eax
80103045:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103046:	89 ca                	mov    %ecx,%edx
80103048:	ec                   	in     (%dx),%al
80103049:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010304c:	89 da                	mov    %ebx,%edx
8010304e:	b8 07 00 00 00       	mov    $0x7,%eax
80103053:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103054:	89 ca                	mov    %ecx,%edx
80103056:	ec                   	in     (%dx),%al
80103057:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010305a:	89 da                	mov    %ebx,%edx
8010305c:	b8 08 00 00 00       	mov    $0x8,%eax
80103061:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103062:	89 ca                	mov    %ecx,%edx
80103064:	ec                   	in     (%dx),%al
80103065:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103067:	89 da                	mov    %ebx,%edx
80103069:	b8 09 00 00 00       	mov    $0x9,%eax
8010306e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010306f:	89 ca                	mov    %ecx,%edx
80103071:	ec                   	in     (%dx),%al
80103072:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103074:	89 da                	mov    %ebx,%edx
80103076:	b8 0a 00 00 00       	mov    $0xa,%eax
8010307b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010307c:	89 ca                	mov    %ecx,%edx
8010307e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010307f:	84 c0                	test   %al,%al
80103081:	78 9d                	js     80103020 <cmostime+0x30>
  return inb(CMOS_RETURN);
80103083:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103087:	89 fa                	mov    %edi,%edx
80103089:	0f b6 fa             	movzbl %dl,%edi
8010308c:	89 f2                	mov    %esi,%edx
8010308e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103091:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103095:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103098:	89 da                	mov    %ebx,%edx
8010309a:	89 7d c8             	mov    %edi,-0x38(%ebp)
8010309d:	89 45 bc             	mov    %eax,-0x44(%ebp)
801030a0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801030a4:	89 75 cc             	mov    %esi,-0x34(%ebp)
801030a7:	89 45 c0             	mov    %eax,-0x40(%ebp)
801030aa:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801030ae:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801030b1:	31 c0                	xor    %eax,%eax
801030b3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030b4:	89 ca                	mov    %ecx,%edx
801030b6:	ec                   	in     (%dx),%al
801030b7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ba:	89 da                	mov    %ebx,%edx
801030bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
801030bf:	b8 02 00 00 00       	mov    $0x2,%eax
801030c4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030c5:	89 ca                	mov    %ecx,%edx
801030c7:	ec                   	in     (%dx),%al
801030c8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030cb:	89 da                	mov    %ebx,%edx
801030cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801030d0:	b8 04 00 00 00       	mov    $0x4,%eax
801030d5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030d6:	89 ca                	mov    %ecx,%edx
801030d8:	ec                   	in     (%dx),%al
801030d9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030dc:	89 da                	mov    %ebx,%edx
801030de:	89 45 d8             	mov    %eax,-0x28(%ebp)
801030e1:	b8 07 00 00 00       	mov    $0x7,%eax
801030e6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030e7:	89 ca                	mov    %ecx,%edx
801030e9:	ec                   	in     (%dx),%al
801030ea:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ed:	89 da                	mov    %ebx,%edx
801030ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
801030f2:	b8 08 00 00 00       	mov    $0x8,%eax
801030f7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030f8:	89 ca                	mov    %ecx,%edx
801030fa:	ec                   	in     (%dx),%al
801030fb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030fe:	89 da                	mov    %ebx,%edx
80103100:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103103:	b8 09 00 00 00       	mov    $0x9,%eax
80103108:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103109:	89 ca                	mov    %ecx,%edx
8010310b:	ec                   	in     (%dx),%al
8010310c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010310f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103112:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103115:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103118:	6a 18                	push   $0x18
8010311a:	50                   	push   %eax
8010311b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010311e:	50                   	push   %eax
8010311f:	e8 fc 1b 00 00       	call   80104d20 <memcmp>
80103124:	83 c4 10             	add    $0x10,%esp
80103127:	85 c0                	test   %eax,%eax
80103129:	0f 85 f1 fe ff ff    	jne    80103020 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
8010312f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103133:	75 78                	jne    801031ad <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103135:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103138:	89 c2                	mov    %eax,%edx
8010313a:	83 e0 0f             	and    $0xf,%eax
8010313d:	c1 ea 04             	shr    $0x4,%edx
80103140:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103143:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103146:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103149:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010314c:	89 c2                	mov    %eax,%edx
8010314e:	83 e0 0f             	and    $0xf,%eax
80103151:	c1 ea 04             	shr    $0x4,%edx
80103154:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103157:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010315a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010315d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103160:	89 c2                	mov    %eax,%edx
80103162:	83 e0 0f             	and    $0xf,%eax
80103165:	c1 ea 04             	shr    $0x4,%edx
80103168:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010316b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010316e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103171:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103174:	89 c2                	mov    %eax,%edx
80103176:	83 e0 0f             	and    $0xf,%eax
80103179:	c1 ea 04             	shr    $0x4,%edx
8010317c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010317f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103182:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103185:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103188:	89 c2                	mov    %eax,%edx
8010318a:	83 e0 0f             	and    $0xf,%eax
8010318d:	c1 ea 04             	shr    $0x4,%edx
80103190:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103193:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103196:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103199:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010319c:	89 c2                	mov    %eax,%edx
8010319e:	83 e0 0f             	and    $0xf,%eax
801031a1:	c1 ea 04             	shr    $0x4,%edx
801031a4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031a7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801031ad:	8b 75 08             	mov    0x8(%ebp),%esi
801031b0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801031b3:	89 06                	mov    %eax,(%esi)
801031b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
801031b8:	89 46 04             	mov    %eax,0x4(%esi)
801031bb:	8b 45 c0             	mov    -0x40(%ebp),%eax
801031be:	89 46 08             	mov    %eax,0x8(%esi)
801031c1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801031c4:	89 46 0c             	mov    %eax,0xc(%esi)
801031c7:	8b 45 c8             	mov    -0x38(%ebp),%eax
801031ca:	89 46 10             	mov    %eax,0x10(%esi)
801031cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
801031d0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801031d3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801031da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031dd:	5b                   	pop    %ebx
801031de:	5e                   	pop    %esi
801031df:	5f                   	pop    %edi
801031e0:	5d                   	pop    %ebp
801031e1:	c3                   	ret    
801031e2:	66 90                	xchg   %ax,%ax
801031e4:	66 90                	xchg   %ax,%ax
801031e6:	66 90                	xchg   %ax,%ax
801031e8:	66 90                	xchg   %ax,%ax
801031ea:	66 90                	xchg   %ax,%ax
801031ec:	66 90                	xchg   %ax,%ax
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801031f0:	8b 0d a8 3f 11 80    	mov    0x80113fa8,%ecx
801031f6:	85 c9                	test   %ecx,%ecx
801031f8:	0f 8e 8a 00 00 00    	jle    80103288 <install_trans+0x98>
{
801031fe:	55                   	push   %ebp
801031ff:	89 e5                	mov    %esp,%ebp
80103201:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103202:	31 ff                	xor    %edi,%edi
{
80103204:	56                   	push   %esi
80103205:	53                   	push   %ebx
80103206:	83 ec 0c             	sub    $0xc,%esp
80103209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103210:	a1 94 3f 11 80       	mov    0x80113f94,%eax
80103215:	83 ec 08             	sub    $0x8,%esp
80103218:	01 f8                	add    %edi,%eax
8010321a:	83 c0 01             	add    $0x1,%eax
8010321d:	50                   	push   %eax
8010321e:	ff 35 a4 3f 11 80    	pushl  0x80113fa4
80103224:	e8 a7 ce ff ff       	call   801000d0 <bread>
80103229:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010322b:	58                   	pop    %eax
8010322c:	5a                   	pop    %edx
8010322d:	ff 34 bd ac 3f 11 80 	pushl  -0x7feec054(,%edi,4)
80103234:	ff 35 a4 3f 11 80    	pushl  0x80113fa4
  for (tail = 0; tail < log.lh.n; tail++) {
8010323a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010323d:	e8 8e ce ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103242:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103245:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103247:	8d 46 5c             	lea    0x5c(%esi),%eax
8010324a:	68 00 02 00 00       	push   $0x200
8010324f:	50                   	push   %eax
80103250:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103253:	50                   	push   %eax
80103254:	e8 17 1b 00 00       	call   80104d70 <memmove>
    bwrite(dbuf);  // write dst to disk
80103259:	89 1c 24             	mov    %ebx,(%esp)
8010325c:	e8 4f cf ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103261:	89 34 24             	mov    %esi,(%esp)
80103264:	e8 87 cf ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103269:	89 1c 24             	mov    %ebx,(%esp)
8010326c:	e8 7f cf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103271:	83 c4 10             	add    $0x10,%esp
80103274:	39 3d a8 3f 11 80    	cmp    %edi,0x80113fa8
8010327a:	7f 94                	jg     80103210 <install_trans+0x20>
  }
}
8010327c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010327f:	5b                   	pop    %ebx
80103280:	5e                   	pop    %esi
80103281:	5f                   	pop    %edi
80103282:	5d                   	pop    %ebp
80103283:	c3                   	ret    
80103284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103288:	c3                   	ret    
80103289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103290 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	53                   	push   %ebx
80103294:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103297:	ff 35 94 3f 11 80    	pushl  0x80113f94
8010329d:	ff 35 a4 3f 11 80    	pushl  0x80113fa4
801032a3:	e8 28 ce ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801032a8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801032ab:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801032ad:	a1 a8 3f 11 80       	mov    0x80113fa8,%eax
801032b2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801032b5:	85 c0                	test   %eax,%eax
801032b7:	7e 19                	jle    801032d2 <write_head+0x42>
801032b9:	31 d2                	xor    %edx,%edx
801032bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032bf:	90                   	nop
    hb->block[i] = log.lh.block[i];
801032c0:	8b 0c 95 ac 3f 11 80 	mov    -0x7feec054(,%edx,4),%ecx
801032c7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801032cb:	83 c2 01             	add    $0x1,%edx
801032ce:	39 d0                	cmp    %edx,%eax
801032d0:	75 ee                	jne    801032c0 <write_head+0x30>
  }
  bwrite(buf);
801032d2:	83 ec 0c             	sub    $0xc,%esp
801032d5:	53                   	push   %ebx
801032d6:	e8 d5 ce ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801032db:	89 1c 24             	mov    %ebx,(%esp)
801032de:	e8 0d cf ff ff       	call   801001f0 <brelse>
}
801032e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032e6:	83 c4 10             	add    $0x10,%esp
801032e9:	c9                   	leave  
801032ea:	c3                   	ret    
801032eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ef:	90                   	nop

801032f0 <initlog>:
{
801032f0:	f3 0f 1e fb          	endbr32 
801032f4:	55                   	push   %ebp
801032f5:	89 e5                	mov    %esp,%ebp
801032f7:	53                   	push   %ebx
801032f8:	83 ec 2c             	sub    $0x2c,%esp
801032fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801032fe:	68 00 7c 10 80       	push   $0x80107c00
80103303:	68 60 3f 11 80       	push   $0x80113f60
80103308:	e8 33 17 00 00       	call   80104a40 <initlock>
  readsb(dev, &sb);
8010330d:	58                   	pop    %eax
8010330e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103311:	5a                   	pop    %edx
80103312:	50                   	push   %eax
80103313:	53                   	push   %ebx
80103314:	e8 47 e8 ff ff       	call   80101b60 <readsb>
  log.start = sb.logstart;
80103319:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010331c:	59                   	pop    %ecx
  log.dev = dev;
8010331d:	89 1d a4 3f 11 80    	mov    %ebx,0x80113fa4
  log.size = sb.nlog;
80103323:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103326:	a3 94 3f 11 80       	mov    %eax,0x80113f94
  log.size = sb.nlog;
8010332b:	89 15 98 3f 11 80    	mov    %edx,0x80113f98
  struct buf *buf = bread(log.dev, log.start);
80103331:	5a                   	pop    %edx
80103332:	50                   	push   %eax
80103333:	53                   	push   %ebx
80103334:	e8 97 cd ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103339:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010333c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010333f:	89 0d a8 3f 11 80    	mov    %ecx,0x80113fa8
  for (i = 0; i < log.lh.n; i++) {
80103345:	85 c9                	test   %ecx,%ecx
80103347:	7e 19                	jle    80103362 <initlog+0x72>
80103349:	31 d2                	xor    %edx,%edx
8010334b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010334f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103350:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103354:	89 1c 95 ac 3f 11 80 	mov    %ebx,-0x7feec054(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010335b:	83 c2 01             	add    $0x1,%edx
8010335e:	39 d1                	cmp    %edx,%ecx
80103360:	75 ee                	jne    80103350 <initlog+0x60>
  brelse(buf);
80103362:	83 ec 0c             	sub    $0xc,%esp
80103365:	50                   	push   %eax
80103366:	e8 85 ce ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010336b:	e8 80 fe ff ff       	call   801031f0 <install_trans>
  log.lh.n = 0;
80103370:	c7 05 a8 3f 11 80 00 	movl   $0x0,0x80113fa8
80103377:	00 00 00 
  write_head(); // clear the log
8010337a:	e8 11 ff ff ff       	call   80103290 <write_head>
}
8010337f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103382:	83 c4 10             	add    $0x10,%esp
80103385:	c9                   	leave  
80103386:	c3                   	ret    
80103387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010338e:	66 90                	xchg   %ax,%ax

80103390 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103390:	f3 0f 1e fb          	endbr32 
80103394:	55                   	push   %ebp
80103395:	89 e5                	mov    %esp,%ebp
80103397:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010339a:	68 60 3f 11 80       	push   $0x80113f60
8010339f:	e8 1c 18 00 00       	call   80104bc0 <acquire>
801033a4:	83 c4 10             	add    $0x10,%esp
801033a7:	eb 1c                	jmp    801033c5 <begin_op+0x35>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801033b0:	83 ec 08             	sub    $0x8,%esp
801033b3:	68 60 3f 11 80       	push   $0x80113f60
801033b8:	68 60 3f 11 80       	push   $0x80113f60
801033bd:	e8 be 11 00 00       	call   80104580 <sleep>
801033c2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801033c5:	a1 a0 3f 11 80       	mov    0x80113fa0,%eax
801033ca:	85 c0                	test   %eax,%eax
801033cc:	75 e2                	jne    801033b0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801033ce:	a1 9c 3f 11 80       	mov    0x80113f9c,%eax
801033d3:	8b 15 a8 3f 11 80    	mov    0x80113fa8,%edx
801033d9:	83 c0 01             	add    $0x1,%eax
801033dc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801033df:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801033e2:	83 fa 1e             	cmp    $0x1e,%edx
801033e5:	7f c9                	jg     801033b0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801033e7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801033ea:	a3 9c 3f 11 80       	mov    %eax,0x80113f9c
      release(&log.lock);
801033ef:	68 60 3f 11 80       	push   $0x80113f60
801033f4:	e8 87 18 00 00       	call   80104c80 <release>
      break;
    }
  }
}
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	c9                   	leave  
801033fd:	c3                   	ret    
801033fe:	66 90                	xchg   %ax,%ax

80103400 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103400:	f3 0f 1e fb          	endbr32 
80103404:	55                   	push   %ebp
80103405:	89 e5                	mov    %esp,%ebp
80103407:	57                   	push   %edi
80103408:	56                   	push   %esi
80103409:	53                   	push   %ebx
8010340a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010340d:	68 60 3f 11 80       	push   $0x80113f60
80103412:	e8 a9 17 00 00       	call   80104bc0 <acquire>
  log.outstanding -= 1;
80103417:	a1 9c 3f 11 80       	mov    0x80113f9c,%eax
  if(log.committing)
8010341c:	8b 35 a0 3f 11 80    	mov    0x80113fa0,%esi
80103422:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103425:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103428:	89 1d 9c 3f 11 80    	mov    %ebx,0x80113f9c
  if(log.committing)
8010342e:	85 f6                	test   %esi,%esi
80103430:	0f 85 1e 01 00 00    	jne    80103554 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103436:	85 db                	test   %ebx,%ebx
80103438:	0f 85 f2 00 00 00    	jne    80103530 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010343e:	c7 05 a0 3f 11 80 01 	movl   $0x1,0x80113fa0
80103445:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103448:	83 ec 0c             	sub    $0xc,%esp
8010344b:	68 60 3f 11 80       	push   $0x80113f60
80103450:	e8 2b 18 00 00       	call   80104c80 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103455:	8b 0d a8 3f 11 80    	mov    0x80113fa8,%ecx
8010345b:	83 c4 10             	add    $0x10,%esp
8010345e:	85 c9                	test   %ecx,%ecx
80103460:	7f 3e                	jg     801034a0 <end_op+0xa0>
    acquire(&log.lock);
80103462:	83 ec 0c             	sub    $0xc,%esp
80103465:	68 60 3f 11 80       	push   $0x80113f60
8010346a:	e8 51 17 00 00       	call   80104bc0 <acquire>
    wakeup(&log);
8010346f:	c7 04 24 60 3f 11 80 	movl   $0x80113f60,(%esp)
    log.committing = 0;
80103476:	c7 05 a0 3f 11 80 00 	movl   $0x0,0x80113fa0
8010347d:	00 00 00 
    wakeup(&log);
80103480:	e8 bb 12 00 00       	call   80104740 <wakeup>
    release(&log.lock);
80103485:	c7 04 24 60 3f 11 80 	movl   $0x80113f60,(%esp)
8010348c:	e8 ef 17 00 00       	call   80104c80 <release>
80103491:	83 c4 10             	add    $0x10,%esp
}
80103494:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103497:	5b                   	pop    %ebx
80103498:	5e                   	pop    %esi
80103499:	5f                   	pop    %edi
8010349a:	5d                   	pop    %ebp
8010349b:	c3                   	ret    
8010349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801034a0:	a1 94 3f 11 80       	mov    0x80113f94,%eax
801034a5:	83 ec 08             	sub    $0x8,%esp
801034a8:	01 d8                	add    %ebx,%eax
801034aa:	83 c0 01             	add    $0x1,%eax
801034ad:	50                   	push   %eax
801034ae:	ff 35 a4 3f 11 80    	pushl  0x80113fa4
801034b4:	e8 17 cc ff ff       	call   801000d0 <bread>
801034b9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034bb:	58                   	pop    %eax
801034bc:	5a                   	pop    %edx
801034bd:	ff 34 9d ac 3f 11 80 	pushl  -0x7feec054(,%ebx,4)
801034c4:	ff 35 a4 3f 11 80    	pushl  0x80113fa4
  for (tail = 0; tail < log.lh.n; tail++) {
801034ca:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034cd:	e8 fe cb ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801034d2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034d5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801034d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801034da:	68 00 02 00 00       	push   $0x200
801034df:	50                   	push   %eax
801034e0:	8d 46 5c             	lea    0x5c(%esi),%eax
801034e3:	50                   	push   %eax
801034e4:	e8 87 18 00 00       	call   80104d70 <memmove>
    bwrite(to);  // write the log
801034e9:	89 34 24             	mov    %esi,(%esp)
801034ec:	e8 bf cc ff ff       	call   801001b0 <bwrite>
    brelse(from);
801034f1:	89 3c 24             	mov    %edi,(%esp)
801034f4:	e8 f7 cc ff ff       	call   801001f0 <brelse>
    brelse(to);
801034f9:	89 34 24             	mov    %esi,(%esp)
801034fc:	e8 ef cc ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103501:	83 c4 10             	add    $0x10,%esp
80103504:	3b 1d a8 3f 11 80    	cmp    0x80113fa8,%ebx
8010350a:	7c 94                	jl     801034a0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010350c:	e8 7f fd ff ff       	call   80103290 <write_head>
    install_trans(); // Now install writes to home locations
80103511:	e8 da fc ff ff       	call   801031f0 <install_trans>
    log.lh.n = 0;
80103516:	c7 05 a8 3f 11 80 00 	movl   $0x0,0x80113fa8
8010351d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103520:	e8 6b fd ff ff       	call   80103290 <write_head>
80103525:	e9 38 ff ff ff       	jmp    80103462 <end_op+0x62>
8010352a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103530:	83 ec 0c             	sub    $0xc,%esp
80103533:	68 60 3f 11 80       	push   $0x80113f60
80103538:	e8 03 12 00 00       	call   80104740 <wakeup>
  release(&log.lock);
8010353d:	c7 04 24 60 3f 11 80 	movl   $0x80113f60,(%esp)
80103544:	e8 37 17 00 00       	call   80104c80 <release>
80103549:	83 c4 10             	add    $0x10,%esp
}
8010354c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010354f:	5b                   	pop    %ebx
80103550:	5e                   	pop    %esi
80103551:	5f                   	pop    %edi
80103552:	5d                   	pop    %ebp
80103553:	c3                   	ret    
    panic("log.committing");
80103554:	83 ec 0c             	sub    $0xc,%esp
80103557:	68 04 7c 10 80       	push   $0x80107c04
8010355c:	e8 9f d1 ff ff       	call   80100700 <panic>
80103561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010356f:	90                   	nop

80103570 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103570:	f3 0f 1e fb          	endbr32 
80103574:	55                   	push   %ebp
80103575:	89 e5                	mov    %esp,%ebp
80103577:	53                   	push   %ebx
80103578:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010357b:	8b 15 a8 3f 11 80    	mov    0x80113fa8,%edx
{
80103581:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103584:	83 fa 1d             	cmp    $0x1d,%edx
80103587:	0f 8f 91 00 00 00    	jg     8010361e <log_write+0xae>
8010358d:	a1 98 3f 11 80       	mov    0x80113f98,%eax
80103592:	83 e8 01             	sub    $0x1,%eax
80103595:	39 c2                	cmp    %eax,%edx
80103597:	0f 8d 81 00 00 00    	jge    8010361e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010359d:	a1 9c 3f 11 80       	mov    0x80113f9c,%eax
801035a2:	85 c0                	test   %eax,%eax
801035a4:	0f 8e 81 00 00 00    	jle    8010362b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801035aa:	83 ec 0c             	sub    $0xc,%esp
801035ad:	68 60 3f 11 80       	push   $0x80113f60
801035b2:	e8 09 16 00 00       	call   80104bc0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801035b7:	8b 15 a8 3f 11 80    	mov    0x80113fa8,%edx
801035bd:	83 c4 10             	add    $0x10,%esp
801035c0:	85 d2                	test   %edx,%edx
801035c2:	7e 4e                	jle    80103612 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801035c4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801035c7:	31 c0                	xor    %eax,%eax
801035c9:	eb 0c                	jmp    801035d7 <log_write+0x67>
801035cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035cf:	90                   	nop
801035d0:	83 c0 01             	add    $0x1,%eax
801035d3:	39 c2                	cmp    %eax,%edx
801035d5:	74 29                	je     80103600 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801035d7:	39 0c 85 ac 3f 11 80 	cmp    %ecx,-0x7feec054(,%eax,4)
801035de:	75 f0                	jne    801035d0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801035e0:	89 0c 85 ac 3f 11 80 	mov    %ecx,-0x7feec054(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801035e7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801035ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801035ed:	c7 45 08 60 3f 11 80 	movl   $0x80113f60,0x8(%ebp)
}
801035f4:	c9                   	leave  
  release(&log.lock);
801035f5:	e9 86 16 00 00       	jmp    80104c80 <release>
801035fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103600:	89 0c 95 ac 3f 11 80 	mov    %ecx,-0x7feec054(,%edx,4)
    log.lh.n++;
80103607:	83 c2 01             	add    $0x1,%edx
8010360a:	89 15 a8 3f 11 80    	mov    %edx,0x80113fa8
80103610:	eb d5                	jmp    801035e7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103612:	8b 43 08             	mov    0x8(%ebx),%eax
80103615:	a3 ac 3f 11 80       	mov    %eax,0x80113fac
  if (i == log.lh.n)
8010361a:	75 cb                	jne    801035e7 <log_write+0x77>
8010361c:	eb e9                	jmp    80103607 <log_write+0x97>
    panic("too big a transaction");
8010361e:	83 ec 0c             	sub    $0xc,%esp
80103621:	68 13 7c 10 80       	push   $0x80107c13
80103626:	e8 d5 d0 ff ff       	call   80100700 <panic>
    panic("log_write outside of trans");
8010362b:	83 ec 0c             	sub    $0xc,%esp
8010362e:	68 29 7c 10 80       	push   $0x80107c29
80103633:	e8 c8 d0 ff ff       	call   80100700 <panic>
80103638:	66 90                	xchg   %ax,%ax
8010363a:	66 90                	xchg   %ax,%ax
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	53                   	push   %ebx
80103644:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103647:	e8 54 09 00 00       	call   80103fa0 <cpuid>
8010364c:	89 c3                	mov    %eax,%ebx
8010364e:	e8 4d 09 00 00       	call   80103fa0 <cpuid>
80103653:	83 ec 04             	sub    $0x4,%esp
80103656:	53                   	push   %ebx
80103657:	50                   	push   %eax
80103658:	68 44 7c 10 80       	push   $0x80107c44
8010365d:	e8 1e d1 ff ff       	call   80100780 <cprintf>
  idtinit();       // load idt register
80103662:	e8 19 29 00 00       	call   80105f80 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103667:	e8 c4 08 00 00       	call   80103f30 <mycpu>
8010366c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010366e:	b8 01 00 00 00       	mov    $0x1,%eax
80103673:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010367a:	e8 11 0c 00 00       	call   80104290 <scheduler>
8010367f:	90                   	nop

80103680 <mpenter>:
{
80103680:	f3 0f 1e fb          	endbr32 
80103684:	55                   	push   %ebp
80103685:	89 e5                	mov    %esp,%ebp
80103687:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010368a:	e8 c1 39 00 00       	call   80107050 <switchkvm>
  seginit();
8010368f:	e8 2c 39 00 00       	call   80106fc0 <seginit>
  lapicinit();
80103694:	e8 67 f7 ff ff       	call   80102e00 <lapicinit>
  mpmain();
80103699:	e8 a2 ff ff ff       	call   80103640 <mpmain>
8010369e:	66 90                	xchg   %ax,%ax

801036a0 <main>:
{
801036a0:	f3 0f 1e fb          	endbr32 
801036a4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801036a8:	83 e4 f0             	and    $0xfffffff0,%esp
801036ab:	ff 71 fc             	pushl  -0x4(%ecx)
801036ae:	55                   	push   %ebp
801036af:	89 e5                	mov    %esp,%ebp
801036b1:	53                   	push   %ebx
801036b2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801036b3:	83 ec 08             	sub    $0x8,%esp
801036b6:	68 00 00 40 80       	push   $0x80400000
801036bb:	68 88 6d 11 80       	push   $0x80116d88
801036c0:	e8 fb f4 ff ff       	call   80102bc0 <kinit1>
  kvmalloc();      // kernel page table
801036c5:	e8 66 3e 00 00       	call   80107530 <kvmalloc>
  mpinit();        // detect other processors
801036ca:	e8 81 01 00 00       	call   80103850 <mpinit>
  lapicinit();     // interrupt controller
801036cf:	e8 2c f7 ff ff       	call   80102e00 <lapicinit>
  seginit();       // segment descriptors
801036d4:	e8 e7 38 00 00       	call   80106fc0 <seginit>
  picinit();       // disable pic
801036d9:	e8 52 03 00 00       	call   80103a30 <picinit>
  ioapicinit();    // another interrupt controller
801036de:	e8 fd f2 ff ff       	call   801029e0 <ioapicinit>
  consoleinit();   // console hardware
801036e3:	e8 a8 d9 ff ff       	call   80101090 <consoleinit>
  uartinit();      // serial port
801036e8:	e8 93 2b 00 00       	call   80106280 <uartinit>
  pinit();         // process table
801036ed:	e8 1e 08 00 00       	call   80103f10 <pinit>
  tvinit();        // trap vectors
801036f2:	e8 09 28 00 00       	call   80105f00 <tvinit>
  binit();         // buffer cache
801036f7:	e8 44 c9 ff ff       	call   80100040 <binit>
  fileinit();      // file table
801036fc:	e8 3f dd ff ff       	call   80101440 <fileinit>
  ideinit();       // disk 
80103701:	e8 aa f0 ff ff       	call   801027b0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103706:	83 c4 0c             	add    $0xc,%esp
80103709:	68 8a 00 00 00       	push   $0x8a
8010370e:	68 8c b4 10 80       	push   $0x8010b48c
80103713:	68 00 70 00 80       	push   $0x80007000
80103718:	e8 53 16 00 00       	call   80104d70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010371d:	83 c4 10             	add    $0x10,%esp
80103720:	69 05 e0 45 11 80 b0 	imul   $0xb0,0x801145e0,%eax
80103727:	00 00 00 
8010372a:	05 60 40 11 80       	add    $0x80114060,%eax
8010372f:	3d 60 40 11 80       	cmp    $0x80114060,%eax
80103734:	76 7a                	jbe    801037b0 <main+0x110>
80103736:	bb 60 40 11 80       	mov    $0x80114060,%ebx
8010373b:	eb 1c                	jmp    80103759 <main+0xb9>
8010373d:	8d 76 00             	lea    0x0(%esi),%esi
80103740:	69 05 e0 45 11 80 b0 	imul   $0xb0,0x801145e0,%eax
80103747:	00 00 00 
8010374a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103750:	05 60 40 11 80       	add    $0x80114060,%eax
80103755:	39 c3                	cmp    %eax,%ebx
80103757:	73 57                	jae    801037b0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103759:	e8 d2 07 00 00       	call   80103f30 <mycpu>
8010375e:	39 c3                	cmp    %eax,%ebx
80103760:	74 de                	je     80103740 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103762:	e8 29 f5 ff ff       	call   80102c90 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103767:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010376a:	c7 05 f8 6f 00 80 80 	movl   $0x80103680,0x80006ff8
80103771:	36 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103774:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010377b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010377e:	05 00 10 00 00       	add    $0x1000,%eax
80103783:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103788:	0f b6 03             	movzbl (%ebx),%eax
8010378b:	68 00 70 00 00       	push   $0x7000
80103790:	50                   	push   %eax
80103791:	e8 ba f7 ff ff       	call   80102f50 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103796:	83 c4 10             	add    $0x10,%esp
80103799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801037a6:	85 c0                	test   %eax,%eax
801037a8:	74 f6                	je     801037a0 <main+0x100>
801037aa:	eb 94                	jmp    80103740 <main+0xa0>
801037ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037b0:	83 ec 08             	sub    $0x8,%esp
801037b3:	68 00 00 00 8e       	push   $0x8e000000
801037b8:	68 00 00 40 80       	push   $0x80400000
801037bd:	e8 6e f4 ff ff       	call   80102c30 <kinit2>
  userinit();      // first user process
801037c2:	e8 29 08 00 00       	call   80103ff0 <userinit>
  mpmain();        // finish this processor's setup
801037c7:	e8 74 fe ff ff       	call   80103640 <mpmain>
801037cc:	66 90                	xchg   %ax,%ax
801037ce:	66 90                	xchg   %ax,%ax

801037d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	57                   	push   %edi
801037d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801037d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801037db:	53                   	push   %ebx
  e = addr+len;
801037dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801037df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801037e2:	39 de                	cmp    %ebx,%esi
801037e4:	72 10                	jb     801037f6 <mpsearch1+0x26>
801037e6:	eb 50                	jmp    80103838 <mpsearch1+0x68>
801037e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037ef:	90                   	nop
801037f0:	89 fe                	mov    %edi,%esi
801037f2:	39 fb                	cmp    %edi,%ebx
801037f4:	76 42                	jbe    80103838 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801037f6:	83 ec 04             	sub    $0x4,%esp
801037f9:	8d 7e 10             	lea    0x10(%esi),%edi
801037fc:	6a 04                	push   $0x4
801037fe:	68 58 7c 10 80       	push   $0x80107c58
80103803:	56                   	push   %esi
80103804:	e8 17 15 00 00       	call   80104d20 <memcmp>
80103809:	83 c4 10             	add    $0x10,%esp
8010380c:	85 c0                	test   %eax,%eax
8010380e:	75 e0                	jne    801037f0 <mpsearch1+0x20>
80103810:	89 f2                	mov    %esi,%edx
80103812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103818:	0f b6 0a             	movzbl (%edx),%ecx
8010381b:	83 c2 01             	add    $0x1,%edx
8010381e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103820:	39 fa                	cmp    %edi,%edx
80103822:	75 f4                	jne    80103818 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103824:	84 c0                	test   %al,%al
80103826:	75 c8                	jne    801037f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103828:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010382b:	89 f0                	mov    %esi,%eax
8010382d:	5b                   	pop    %ebx
8010382e:	5e                   	pop    %esi
8010382f:	5f                   	pop    %edi
80103830:	5d                   	pop    %ebp
80103831:	c3                   	ret    
80103832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103838:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010383b:	31 f6                	xor    %esi,%esi
}
8010383d:	5b                   	pop    %ebx
8010383e:	89 f0                	mov    %esi,%eax
80103840:	5e                   	pop    %esi
80103841:	5f                   	pop    %edi
80103842:	5d                   	pop    %ebp
80103843:	c3                   	ret    
80103844:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010384b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010384f:	90                   	nop

80103850 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103850:	f3 0f 1e fb          	endbr32 
80103854:	55                   	push   %ebp
80103855:	89 e5                	mov    %esp,%ebp
80103857:	57                   	push   %edi
80103858:	56                   	push   %esi
80103859:	53                   	push   %ebx
8010385a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010385d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103864:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010386b:	c1 e0 08             	shl    $0x8,%eax
8010386e:	09 d0                	or     %edx,%eax
80103870:	c1 e0 04             	shl    $0x4,%eax
80103873:	75 1b                	jne    80103890 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103875:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010387c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103883:	c1 e0 08             	shl    $0x8,%eax
80103886:	09 d0                	or     %edx,%eax
80103888:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010388b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103890:	ba 00 04 00 00       	mov    $0x400,%edx
80103895:	e8 36 ff ff ff       	call   801037d0 <mpsearch1>
8010389a:	89 c6                	mov    %eax,%esi
8010389c:	85 c0                	test   %eax,%eax
8010389e:	0f 84 4c 01 00 00    	je     801039f0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801038a4:	8b 5e 04             	mov    0x4(%esi),%ebx
801038a7:	85 db                	test   %ebx,%ebx
801038a9:	0f 84 61 01 00 00    	je     80103a10 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801038af:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801038b2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801038b8:	6a 04                	push   $0x4
801038ba:	68 5d 7c 10 80       	push   $0x80107c5d
801038bf:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801038c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801038c3:	e8 58 14 00 00       	call   80104d20 <memcmp>
801038c8:	83 c4 10             	add    $0x10,%esp
801038cb:	85 c0                	test   %eax,%eax
801038cd:	0f 85 3d 01 00 00    	jne    80103a10 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801038d3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801038da:	3c 01                	cmp    $0x1,%al
801038dc:	74 08                	je     801038e6 <mpinit+0x96>
801038de:	3c 04                	cmp    $0x4,%al
801038e0:	0f 85 2a 01 00 00    	jne    80103a10 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801038e6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801038ed:	66 85 d2             	test   %dx,%dx
801038f0:	74 26                	je     80103918 <mpinit+0xc8>
801038f2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801038f5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801038f7:	31 d2                	xor    %edx,%edx
801038f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103900:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103907:	83 c0 01             	add    $0x1,%eax
8010390a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010390c:	39 f8                	cmp    %edi,%eax
8010390e:	75 f0                	jne    80103900 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103910:	84 d2                	test   %dl,%dl
80103912:	0f 85 f8 00 00 00    	jne    80103a10 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103918:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010391e:	a3 5c 3f 11 80       	mov    %eax,0x80113f5c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103923:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103929:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103930:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103935:	03 55 e4             	add    -0x1c(%ebp),%edx
80103938:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010393b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010393f:	90                   	nop
80103940:	39 c2                	cmp    %eax,%edx
80103942:	76 15                	jbe    80103959 <mpinit+0x109>
    switch(*p){
80103944:	0f b6 08             	movzbl (%eax),%ecx
80103947:	80 f9 02             	cmp    $0x2,%cl
8010394a:	74 5c                	je     801039a8 <mpinit+0x158>
8010394c:	77 42                	ja     80103990 <mpinit+0x140>
8010394e:	84 c9                	test   %cl,%cl
80103950:	74 6e                	je     801039c0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103952:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103955:	39 c2                	cmp    %eax,%edx
80103957:	77 eb                	ja     80103944 <mpinit+0xf4>
80103959:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010395c:	85 db                	test   %ebx,%ebx
8010395e:	0f 84 b9 00 00 00    	je     80103a1d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103964:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103968:	74 15                	je     8010397f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010396a:	b8 70 00 00 00       	mov    $0x70,%eax
8010396f:	ba 22 00 00 00       	mov    $0x22,%edx
80103974:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103975:	ba 23 00 00 00       	mov    $0x23,%edx
8010397a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010397b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010397e:	ee                   	out    %al,(%dx)
  }
}
8010397f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103982:	5b                   	pop    %ebx
80103983:	5e                   	pop    %esi
80103984:	5f                   	pop    %edi
80103985:	5d                   	pop    %ebp
80103986:	c3                   	ret    
80103987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010398e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103990:	83 e9 03             	sub    $0x3,%ecx
80103993:	80 f9 01             	cmp    $0x1,%cl
80103996:	76 ba                	jbe    80103952 <mpinit+0x102>
80103998:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010399f:	eb 9f                	jmp    80103940 <mpinit+0xf0>
801039a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801039a8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801039ac:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801039af:	88 0d 40 40 11 80    	mov    %cl,0x80114040
      continue;
801039b5:	eb 89                	jmp    80103940 <mpinit+0xf0>
801039b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039be:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801039c0:	8b 0d e0 45 11 80    	mov    0x801145e0,%ecx
801039c6:	83 f9 07             	cmp    $0x7,%ecx
801039c9:	7f 19                	jg     801039e4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801039cb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801039d1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801039d5:	83 c1 01             	add    $0x1,%ecx
801039d8:	89 0d e0 45 11 80    	mov    %ecx,0x801145e0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801039de:	88 9f 60 40 11 80    	mov    %bl,-0x7feebfa0(%edi)
      p += sizeof(struct mpproc);
801039e4:	83 c0 14             	add    $0x14,%eax
      continue;
801039e7:	e9 54 ff ff ff       	jmp    80103940 <mpinit+0xf0>
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801039f0:	ba 00 00 01 00       	mov    $0x10000,%edx
801039f5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801039fa:	e8 d1 fd ff ff       	call   801037d0 <mpsearch1>
801039ff:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a01:	85 c0                	test   %eax,%eax
80103a03:	0f 85 9b fe ff ff    	jne    801038a4 <mpinit+0x54>
80103a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103a10:	83 ec 0c             	sub    $0xc,%esp
80103a13:	68 62 7c 10 80       	push   $0x80107c62
80103a18:	e8 e3 cc ff ff       	call   80100700 <panic>
    panic("Didn't find a suitable machine");
80103a1d:	83 ec 0c             	sub    $0xc,%esp
80103a20:	68 7c 7c 10 80       	push   $0x80107c7c
80103a25:	e8 d6 cc ff ff       	call   80100700 <panic>
80103a2a:	66 90                	xchg   %ax,%ax
80103a2c:	66 90                	xchg   %ax,%ax
80103a2e:	66 90                	xchg   %ax,%ax

80103a30 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103a30:	f3 0f 1e fb          	endbr32 
80103a34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a39:	ba 21 00 00 00       	mov    $0x21,%edx
80103a3e:	ee                   	out    %al,(%dx)
80103a3f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103a44:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103a45:	c3                   	ret    
80103a46:	66 90                	xchg   %ax,%ax
80103a48:	66 90                	xchg   %ax,%ax
80103a4a:	66 90                	xchg   %ax,%ax
80103a4c:	66 90                	xchg   %ax,%ax
80103a4e:	66 90                	xchg   %ax,%ax

80103a50 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103a50:	f3 0f 1e fb          	endbr32 
80103a54:	55                   	push   %ebp
80103a55:	89 e5                	mov    %esp,%ebp
80103a57:	57                   	push   %edi
80103a58:	56                   	push   %esi
80103a59:	53                   	push   %ebx
80103a5a:	83 ec 0c             	sub    $0xc,%esp
80103a5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a60:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103a63:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103a69:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103a6f:	e8 ec d9 ff ff       	call   80101460 <filealloc>
80103a74:	89 03                	mov    %eax,(%ebx)
80103a76:	85 c0                	test   %eax,%eax
80103a78:	0f 84 ac 00 00 00    	je     80103b2a <pipealloc+0xda>
80103a7e:	e8 dd d9 ff ff       	call   80101460 <filealloc>
80103a83:	89 06                	mov    %eax,(%esi)
80103a85:	85 c0                	test   %eax,%eax
80103a87:	0f 84 8b 00 00 00    	je     80103b18 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103a8d:	e8 fe f1 ff ff       	call   80102c90 <kalloc>
80103a92:	89 c7                	mov    %eax,%edi
80103a94:	85 c0                	test   %eax,%eax
80103a96:	0f 84 b4 00 00 00    	je     80103b50 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103a9c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103aa3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103aa6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103aa9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ab0:	00 00 00 
  p->nwrite = 0;
80103ab3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103aba:	00 00 00 
  p->nread = 0;
80103abd:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103ac4:	00 00 00 
  initlock(&p->lock, "pipe");
80103ac7:	68 9b 7c 10 80       	push   $0x80107c9b
80103acc:	50                   	push   %eax
80103acd:	e8 6e 0f 00 00       	call   80104a40 <initlock>
  (*f0)->type = FD_PIPE;
80103ad2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103ad4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103ad7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103add:	8b 03                	mov    (%ebx),%eax
80103adf:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103ae3:	8b 03                	mov    (%ebx),%eax
80103ae5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103ae9:	8b 03                	mov    (%ebx),%eax
80103aeb:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103aee:	8b 06                	mov    (%esi),%eax
80103af0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103af6:	8b 06                	mov    (%esi),%eax
80103af8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103afc:	8b 06                	mov    (%esi),%eax
80103afe:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103b02:	8b 06                	mov    (%esi),%eax
80103b04:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103b07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103b0a:	31 c0                	xor    %eax,%eax
}
80103b0c:	5b                   	pop    %ebx
80103b0d:	5e                   	pop    %esi
80103b0e:	5f                   	pop    %edi
80103b0f:	5d                   	pop    %ebp
80103b10:	c3                   	ret    
80103b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103b18:	8b 03                	mov    (%ebx),%eax
80103b1a:	85 c0                	test   %eax,%eax
80103b1c:	74 1e                	je     80103b3c <pipealloc+0xec>
    fileclose(*f0);
80103b1e:	83 ec 0c             	sub    $0xc,%esp
80103b21:	50                   	push   %eax
80103b22:	e8 f9 d9 ff ff       	call   80101520 <fileclose>
80103b27:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103b2a:	8b 06                	mov    (%esi),%eax
80103b2c:	85 c0                	test   %eax,%eax
80103b2e:	74 0c                	je     80103b3c <pipealloc+0xec>
    fileclose(*f1);
80103b30:	83 ec 0c             	sub    $0xc,%esp
80103b33:	50                   	push   %eax
80103b34:	e8 e7 d9 ff ff       	call   80101520 <fileclose>
80103b39:	83 c4 10             	add    $0x10,%esp
}
80103b3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103b3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103b44:	5b                   	pop    %ebx
80103b45:	5e                   	pop    %esi
80103b46:	5f                   	pop    %edi
80103b47:	5d                   	pop    %ebp
80103b48:	c3                   	ret    
80103b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103b50:	8b 03                	mov    (%ebx),%eax
80103b52:	85 c0                	test   %eax,%eax
80103b54:	75 c8                	jne    80103b1e <pipealloc+0xce>
80103b56:	eb d2                	jmp    80103b2a <pipealloc+0xda>
80103b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5f:	90                   	nop

80103b60 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103b60:	f3 0f 1e fb          	endbr32 
80103b64:	55                   	push   %ebp
80103b65:	89 e5                	mov    %esp,%ebp
80103b67:	56                   	push   %esi
80103b68:	53                   	push   %ebx
80103b69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103b6f:	83 ec 0c             	sub    $0xc,%esp
80103b72:	53                   	push   %ebx
80103b73:	e8 48 10 00 00       	call   80104bc0 <acquire>
  if(writable){
80103b78:	83 c4 10             	add    $0x10,%esp
80103b7b:	85 f6                	test   %esi,%esi
80103b7d:	74 41                	je     80103bc0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103b7f:	83 ec 0c             	sub    $0xc,%esp
80103b82:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103b88:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103b8f:	00 00 00 
    wakeup(&p->nread);
80103b92:	50                   	push   %eax
80103b93:	e8 a8 0b 00 00       	call   80104740 <wakeup>
80103b98:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103b9b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103ba1:	85 d2                	test   %edx,%edx
80103ba3:	75 0a                	jne    80103baf <pipeclose+0x4f>
80103ba5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103bab:	85 c0                	test   %eax,%eax
80103bad:	74 31                	je     80103be0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103baf:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103bb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bb5:	5b                   	pop    %ebx
80103bb6:	5e                   	pop    %esi
80103bb7:	5d                   	pop    %ebp
    release(&p->lock);
80103bb8:	e9 c3 10 00 00       	jmp    80104c80 <release>
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103bc0:	83 ec 0c             	sub    $0xc,%esp
80103bc3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103bc9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103bd0:	00 00 00 
    wakeup(&p->nwrite);
80103bd3:	50                   	push   %eax
80103bd4:	e8 67 0b 00 00       	call   80104740 <wakeup>
80103bd9:	83 c4 10             	add    $0x10,%esp
80103bdc:	eb bd                	jmp    80103b9b <pipeclose+0x3b>
80103bde:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103be0:	83 ec 0c             	sub    $0xc,%esp
80103be3:	53                   	push   %ebx
80103be4:	e8 97 10 00 00       	call   80104c80 <release>
    kfree((char*)p);
80103be9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103bec:	83 c4 10             	add    $0x10,%esp
}
80103bef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bf2:	5b                   	pop    %ebx
80103bf3:	5e                   	pop    %esi
80103bf4:	5d                   	pop    %ebp
    kfree((char*)p);
80103bf5:	e9 d6 ee ff ff       	jmp    80102ad0 <kfree>
80103bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c00 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103c00:	f3 0f 1e fb          	endbr32 
80103c04:	55                   	push   %ebp
80103c05:	89 e5                	mov    %esp,%ebp
80103c07:	57                   	push   %edi
80103c08:	56                   	push   %esi
80103c09:	53                   	push   %ebx
80103c0a:	83 ec 28             	sub    $0x28,%esp
80103c0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103c10:	53                   	push   %ebx
80103c11:	e8 aa 0f 00 00       	call   80104bc0 <acquire>
  for(i = 0; i < n; i++){
80103c16:	8b 45 10             	mov    0x10(%ebp),%eax
80103c19:	83 c4 10             	add    $0x10,%esp
80103c1c:	85 c0                	test   %eax,%eax
80103c1e:	0f 8e bc 00 00 00    	jle    80103ce0 <pipewrite+0xe0>
80103c24:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c27:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103c2d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103c33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c36:	03 45 10             	add    0x10(%ebp),%eax
80103c39:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c3c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c42:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c48:	89 ca                	mov    %ecx,%edx
80103c4a:	05 00 02 00 00       	add    $0x200,%eax
80103c4f:	39 c1                	cmp    %eax,%ecx
80103c51:	74 3b                	je     80103c8e <pipewrite+0x8e>
80103c53:	eb 63                	jmp    80103cb8 <pipewrite+0xb8>
80103c55:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103c58:	e8 63 03 00 00       	call   80103fc0 <myproc>
80103c5d:	8b 48 24             	mov    0x24(%eax),%ecx
80103c60:	85 c9                	test   %ecx,%ecx
80103c62:	75 34                	jne    80103c98 <pipewrite+0x98>
      wakeup(&p->nread);
80103c64:	83 ec 0c             	sub    $0xc,%esp
80103c67:	57                   	push   %edi
80103c68:	e8 d3 0a 00 00       	call   80104740 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c6d:	58                   	pop    %eax
80103c6e:	5a                   	pop    %edx
80103c6f:	53                   	push   %ebx
80103c70:	56                   	push   %esi
80103c71:	e8 0a 09 00 00       	call   80104580 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c76:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103c7c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103c82:	83 c4 10             	add    $0x10,%esp
80103c85:	05 00 02 00 00       	add    $0x200,%eax
80103c8a:	39 c2                	cmp    %eax,%edx
80103c8c:	75 2a                	jne    80103cb8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103c8e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103c94:	85 c0                	test   %eax,%eax
80103c96:	75 c0                	jne    80103c58 <pipewrite+0x58>
        release(&p->lock);
80103c98:	83 ec 0c             	sub    $0xc,%esp
80103c9b:	53                   	push   %ebx
80103c9c:	e8 df 0f 00 00       	call   80104c80 <release>
        return -1;
80103ca1:	83 c4 10             	add    $0x10,%esp
80103ca4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103ca9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cac:	5b                   	pop    %ebx
80103cad:	5e                   	pop    %esi
80103cae:	5f                   	pop    %edi
80103caf:	5d                   	pop    %ebp
80103cb0:	c3                   	ret    
80103cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103cb8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103cbb:	8d 4a 01             	lea    0x1(%edx),%ecx
80103cbe:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103cc4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103cca:	0f b6 06             	movzbl (%esi),%eax
80103ccd:	83 c6 01             	add    $0x1,%esi
80103cd0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103cd3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103cd7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103cda:	0f 85 5c ff ff ff    	jne    80103c3c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103ce0:	83 ec 0c             	sub    $0xc,%esp
80103ce3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103ce9:	50                   	push   %eax
80103cea:	e8 51 0a 00 00       	call   80104740 <wakeup>
  release(&p->lock);
80103cef:	89 1c 24             	mov    %ebx,(%esp)
80103cf2:	e8 89 0f 00 00       	call   80104c80 <release>
  return n;
80103cf7:	8b 45 10             	mov    0x10(%ebp),%eax
80103cfa:	83 c4 10             	add    $0x10,%esp
80103cfd:	eb aa                	jmp    80103ca9 <pipewrite+0xa9>
80103cff:	90                   	nop

80103d00 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103d00:	f3 0f 1e fb          	endbr32 
80103d04:	55                   	push   %ebp
80103d05:	89 e5                	mov    %esp,%ebp
80103d07:	57                   	push   %edi
80103d08:	56                   	push   %esi
80103d09:	53                   	push   %ebx
80103d0a:	83 ec 18             	sub    $0x18,%esp
80103d0d:	8b 75 08             	mov    0x8(%ebp),%esi
80103d10:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103d13:	56                   	push   %esi
80103d14:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103d1a:	e8 a1 0e 00 00       	call   80104bc0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d1f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103d25:	83 c4 10             	add    $0x10,%esp
80103d28:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103d2e:	74 33                	je     80103d63 <piperead+0x63>
80103d30:	eb 3b                	jmp    80103d6d <piperead+0x6d>
80103d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103d38:	e8 83 02 00 00       	call   80103fc0 <myproc>
80103d3d:	8b 48 24             	mov    0x24(%eax),%ecx
80103d40:	85 c9                	test   %ecx,%ecx
80103d42:	0f 85 88 00 00 00    	jne    80103dd0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103d48:	83 ec 08             	sub    $0x8,%esp
80103d4b:	56                   	push   %esi
80103d4c:	53                   	push   %ebx
80103d4d:	e8 2e 08 00 00       	call   80104580 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d52:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103d58:	83 c4 10             	add    $0x10,%esp
80103d5b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103d61:	75 0a                	jne    80103d6d <piperead+0x6d>
80103d63:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103d69:	85 c0                	test   %eax,%eax
80103d6b:	75 cb                	jne    80103d38 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103d6d:	8b 55 10             	mov    0x10(%ebp),%edx
80103d70:	31 db                	xor    %ebx,%ebx
80103d72:	85 d2                	test   %edx,%edx
80103d74:	7f 28                	jg     80103d9e <piperead+0x9e>
80103d76:	eb 34                	jmp    80103dac <piperead+0xac>
80103d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d7f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103d80:	8d 48 01             	lea    0x1(%eax),%ecx
80103d83:	25 ff 01 00 00       	and    $0x1ff,%eax
80103d88:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103d8e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103d93:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103d96:	83 c3 01             	add    $0x1,%ebx
80103d99:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103d9c:	74 0e                	je     80103dac <piperead+0xac>
    if(p->nread == p->nwrite)
80103d9e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103da4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103daa:	75 d4                	jne    80103d80 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103dac:	83 ec 0c             	sub    $0xc,%esp
80103daf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103db5:	50                   	push   %eax
80103db6:	e8 85 09 00 00       	call   80104740 <wakeup>
  release(&p->lock);
80103dbb:	89 34 24             	mov    %esi,(%esp)
80103dbe:	e8 bd 0e 00 00       	call   80104c80 <release>
  return i;
80103dc3:	83 c4 10             	add    $0x10,%esp
}
80103dc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dc9:	89 d8                	mov    %ebx,%eax
80103dcb:	5b                   	pop    %ebx
80103dcc:	5e                   	pop    %esi
80103dcd:	5f                   	pop    %edi
80103dce:	5d                   	pop    %ebp
80103dcf:	c3                   	ret    
      release(&p->lock);
80103dd0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103dd3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103dd8:	56                   	push   %esi
80103dd9:	e8 a2 0e 00 00       	call   80104c80 <release>
      return -1;
80103dde:	83 c4 10             	add    $0x10,%esp
}
80103de1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103de4:	89 d8                	mov    %ebx,%eax
80103de6:	5b                   	pop    %ebx
80103de7:	5e                   	pop    %esi
80103de8:	5f                   	pop    %edi
80103de9:	5d                   	pop    %ebp
80103dea:	c3                   	ret    
80103deb:	66 90                	xchg   %ax,%ax
80103ded:	66 90                	xchg   %ax,%ax
80103def:	90                   	nop

80103df0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103df4:	bb 34 46 11 80       	mov    $0x80114634,%ebx
{
80103df9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103dfc:	68 00 46 11 80       	push   $0x80114600
80103e01:	e8 ba 0d 00 00       	call   80104bc0 <acquire>
80103e06:	83 c4 10             	add    $0x10,%esp
80103e09:	eb 10                	jmp    80103e1b <allocproc+0x2b>
80103e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e0f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e10:	83 c3 7c             	add    $0x7c,%ebx
80103e13:	81 fb 34 65 11 80    	cmp    $0x80116534,%ebx
80103e19:	74 75                	je     80103e90 <allocproc+0xa0>
    if(p->state == UNUSED)
80103e1b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103e1e:	85 c0                	test   %eax,%eax
80103e20:	75 ee                	jne    80103e10 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103e22:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103e27:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103e2a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103e31:	89 43 10             	mov    %eax,0x10(%ebx)
80103e34:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103e37:	68 00 46 11 80       	push   $0x80114600
  p->pid = nextpid++;
80103e3c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103e42:	e8 39 0e 00 00       	call   80104c80 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103e47:	e8 44 ee ff ff       	call   80102c90 <kalloc>
80103e4c:	83 c4 10             	add    $0x10,%esp
80103e4f:	89 43 08             	mov    %eax,0x8(%ebx)
80103e52:	85 c0                	test   %eax,%eax
80103e54:	74 53                	je     80103ea9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103e56:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103e5c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103e5f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103e64:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103e67:	c7 40 14 e6 5e 10 80 	movl   $0x80105ee6,0x14(%eax)
  p->context = (struct context*)sp;
80103e6e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103e71:	6a 14                	push   $0x14
80103e73:	6a 00                	push   $0x0
80103e75:	50                   	push   %eax
80103e76:	e8 55 0e 00 00       	call   80104cd0 <memset>
  p->context->eip = (uint)forkret;
80103e7b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103e7e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103e81:	c7 40 10 c0 3e 10 80 	movl   $0x80103ec0,0x10(%eax)
}
80103e88:	89 d8                	mov    %ebx,%eax
80103e8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e8d:	c9                   	leave  
80103e8e:	c3                   	ret    
80103e8f:	90                   	nop
  release(&ptable.lock);
80103e90:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103e93:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103e95:	68 00 46 11 80       	push   $0x80114600
80103e9a:	e8 e1 0d 00 00       	call   80104c80 <release>
}
80103e9f:	89 d8                	mov    %ebx,%eax
  return 0;
80103ea1:	83 c4 10             	add    $0x10,%esp
}
80103ea4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ea7:	c9                   	leave  
80103ea8:	c3                   	ret    
    p->state = UNUSED;
80103ea9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103eb0:	31 db                	xor    %ebx,%ebx
}
80103eb2:	89 d8                	mov    %ebx,%eax
80103eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103eb7:	c9                   	leave  
80103eb8:	c3                   	ret    
80103eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ec0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103ec0:	f3 0f 1e fb          	endbr32 
80103ec4:	55                   	push   %ebp
80103ec5:	89 e5                	mov    %esp,%ebp
80103ec7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103eca:	68 00 46 11 80       	push   $0x80114600
80103ecf:	e8 ac 0d 00 00       	call   80104c80 <release>

  if (first) {
80103ed4:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103ed9:	83 c4 10             	add    $0x10,%esp
80103edc:	85 c0                	test   %eax,%eax
80103ede:	75 08                	jne    80103ee8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103ee0:	c9                   	leave  
80103ee1:	c3                   	ret    
80103ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103ee8:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103eef:	00 00 00 
    iinit(ROOTDEV);
80103ef2:	83 ec 0c             	sub    $0xc,%esp
80103ef5:	6a 01                	push   $0x1
80103ef7:	e8 a4 dc ff ff       	call   80101ba0 <iinit>
    initlog(ROOTDEV);
80103efc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103f03:	e8 e8 f3 ff ff       	call   801032f0 <initlog>
}
80103f08:	83 c4 10             	add    $0x10,%esp
80103f0b:	c9                   	leave  
80103f0c:	c3                   	ret    
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi

80103f10 <pinit>:
{
80103f10:	f3 0f 1e fb          	endbr32 
80103f14:	55                   	push   %ebp
80103f15:	89 e5                	mov    %esp,%ebp
80103f17:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103f1a:	68 a0 7c 10 80       	push   $0x80107ca0
80103f1f:	68 00 46 11 80       	push   $0x80114600
80103f24:	e8 17 0b 00 00       	call   80104a40 <initlock>
}
80103f29:	83 c4 10             	add    $0x10,%esp
80103f2c:	c9                   	leave  
80103f2d:	c3                   	ret    
80103f2e:	66 90                	xchg   %ax,%ax

80103f30 <mycpu>:
{
80103f30:	f3 0f 1e fb          	endbr32 
80103f34:	55                   	push   %ebp
80103f35:	89 e5                	mov    %esp,%ebp
80103f37:	56                   	push   %esi
80103f38:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f39:	9c                   	pushf  
80103f3a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f3b:	f6 c4 02             	test   $0x2,%ah
80103f3e:	75 4a                	jne    80103f8a <mycpu+0x5a>
  apicid = lapicid();
80103f40:	e8 bb ef ff ff       	call   80102f00 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103f45:	8b 35 e0 45 11 80    	mov    0x801145e0,%esi
  apicid = lapicid();
80103f4b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103f4d:	85 f6                	test   %esi,%esi
80103f4f:	7e 2c                	jle    80103f7d <mycpu+0x4d>
80103f51:	31 d2                	xor    %edx,%edx
80103f53:	eb 0a                	jmp    80103f5f <mycpu+0x2f>
80103f55:	8d 76 00             	lea    0x0(%esi),%esi
80103f58:	83 c2 01             	add    $0x1,%edx
80103f5b:	39 f2                	cmp    %esi,%edx
80103f5d:	74 1e                	je     80103f7d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103f5f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103f65:	0f b6 81 60 40 11 80 	movzbl -0x7feebfa0(%ecx),%eax
80103f6c:	39 d8                	cmp    %ebx,%eax
80103f6e:	75 e8                	jne    80103f58 <mycpu+0x28>
}
80103f70:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103f73:	8d 81 60 40 11 80    	lea    -0x7feebfa0(%ecx),%eax
}
80103f79:	5b                   	pop    %ebx
80103f7a:	5e                   	pop    %esi
80103f7b:	5d                   	pop    %ebp
80103f7c:	c3                   	ret    
  panic("unknown apicid\n");
80103f7d:	83 ec 0c             	sub    $0xc,%esp
80103f80:	68 a7 7c 10 80       	push   $0x80107ca7
80103f85:	e8 76 c7 ff ff       	call   80100700 <panic>
    panic("mycpu called with interrupts enabled\n");
80103f8a:	83 ec 0c             	sub    $0xc,%esp
80103f8d:	68 84 7d 10 80       	push   $0x80107d84
80103f92:	e8 69 c7 ff ff       	call   80100700 <panic>
80103f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f9e:	66 90                	xchg   %ax,%ax

80103fa0 <cpuid>:
cpuid() {
80103fa0:	f3 0f 1e fb          	endbr32 
80103fa4:	55                   	push   %ebp
80103fa5:	89 e5                	mov    %esp,%ebp
80103fa7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103faa:	e8 81 ff ff ff       	call   80103f30 <mycpu>
}
80103faf:	c9                   	leave  
  return mycpu()-cpus;
80103fb0:	2d 60 40 11 80       	sub    $0x80114060,%eax
80103fb5:	c1 f8 04             	sar    $0x4,%eax
80103fb8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103fbe:	c3                   	ret    
80103fbf:	90                   	nop

80103fc0 <myproc>:
myproc(void) {
80103fc0:	f3 0f 1e fb          	endbr32 
80103fc4:	55                   	push   %ebp
80103fc5:	89 e5                	mov    %esp,%ebp
80103fc7:	53                   	push   %ebx
80103fc8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103fcb:	e8 f0 0a 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
80103fd0:	e8 5b ff ff ff       	call   80103f30 <mycpu>
  p = c->proc;
80103fd5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fdb:	e8 30 0b 00 00       	call   80104b10 <popcli>
}
80103fe0:	83 c4 04             	add    $0x4,%esp
80103fe3:	89 d8                	mov    %ebx,%eax
80103fe5:	5b                   	pop    %ebx
80103fe6:	5d                   	pop    %ebp
80103fe7:	c3                   	ret    
80103fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fef:	90                   	nop

80103ff0 <userinit>:
{
80103ff0:	f3 0f 1e fb          	endbr32 
80103ff4:	55                   	push   %ebp
80103ff5:	89 e5                	mov    %esp,%ebp
80103ff7:	53                   	push   %ebx
80103ff8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ffb:	e8 f0 fd ff ff       	call   80103df0 <allocproc>
80104000:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104002:	a3 d8 b5 10 80       	mov    %eax,0x8010b5d8
  if((p->pgdir = setupkvm()) == 0)
80104007:	e8 a4 34 00 00       	call   801074b0 <setupkvm>
8010400c:	89 43 04             	mov    %eax,0x4(%ebx)
8010400f:	85 c0                	test   %eax,%eax
80104011:	0f 84 bd 00 00 00    	je     801040d4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104017:	83 ec 04             	sub    $0x4,%esp
8010401a:	68 2c 00 00 00       	push   $0x2c
8010401f:	68 60 b4 10 80       	push   $0x8010b460
80104024:	50                   	push   %eax
80104025:	e8 56 31 00 00       	call   80107180 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010402a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010402d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104033:	6a 4c                	push   $0x4c
80104035:	6a 00                	push   $0x0
80104037:	ff 73 18             	pushl  0x18(%ebx)
8010403a:	e8 91 0c 00 00       	call   80104cd0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010403f:	8b 43 18             	mov    0x18(%ebx),%eax
80104042:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104047:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010404a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010404f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104053:	8b 43 18             	mov    0x18(%ebx),%eax
80104056:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010405a:	8b 43 18             	mov    0x18(%ebx),%eax
8010405d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104061:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104065:	8b 43 18             	mov    0x18(%ebx),%eax
80104068:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010406c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104070:	8b 43 18             	mov    0x18(%ebx),%eax
80104073:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010407a:	8b 43 18             	mov    0x18(%ebx),%eax
8010407d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104084:	8b 43 18             	mov    0x18(%ebx),%eax
80104087:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010408e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104091:	6a 10                	push   $0x10
80104093:	68 d0 7c 10 80       	push   $0x80107cd0
80104098:	50                   	push   %eax
80104099:	e8 f2 0d 00 00       	call   80104e90 <safestrcpy>
  p->cwd = namei("/");
8010409e:	c7 04 24 d9 7c 10 80 	movl   $0x80107cd9,(%esp)
801040a5:	e8 e6 e5 ff ff       	call   80102690 <namei>
801040aa:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801040ad:	c7 04 24 00 46 11 80 	movl   $0x80114600,(%esp)
801040b4:	e8 07 0b 00 00       	call   80104bc0 <acquire>
  p->state = RUNNABLE;
801040b9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801040c0:	c7 04 24 00 46 11 80 	movl   $0x80114600,(%esp)
801040c7:	e8 b4 0b 00 00       	call   80104c80 <release>
}
801040cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040cf:	83 c4 10             	add    $0x10,%esp
801040d2:	c9                   	leave  
801040d3:	c3                   	ret    
    panic("userinit: out of memory?");
801040d4:	83 ec 0c             	sub    $0xc,%esp
801040d7:	68 b7 7c 10 80       	push   $0x80107cb7
801040dc:	e8 1f c6 ff ff       	call   80100700 <panic>
801040e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ef:	90                   	nop

801040f0 <growproc>:
{
801040f0:	f3 0f 1e fb          	endbr32 
801040f4:	55                   	push   %ebp
801040f5:	89 e5                	mov    %esp,%ebp
801040f7:	56                   	push   %esi
801040f8:	53                   	push   %ebx
801040f9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801040fc:	e8 bf 09 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
80104101:	e8 2a fe ff ff       	call   80103f30 <mycpu>
  p = c->proc;
80104106:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010410c:	e8 ff 09 00 00       	call   80104b10 <popcli>
  sz = curproc->sz;
80104111:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104113:	85 f6                	test   %esi,%esi
80104115:	7f 19                	jg     80104130 <growproc+0x40>
  } else if(n < 0){
80104117:	75 37                	jne    80104150 <growproc+0x60>
  switchuvm(curproc);
80104119:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010411c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010411e:	53                   	push   %ebx
8010411f:	e8 4c 2f 00 00       	call   80107070 <switchuvm>
  return 0;
80104124:	83 c4 10             	add    $0x10,%esp
80104127:	31 c0                	xor    %eax,%eax
}
80104129:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010412c:	5b                   	pop    %ebx
8010412d:	5e                   	pop    %esi
8010412e:	5d                   	pop    %ebp
8010412f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104130:	83 ec 04             	sub    $0x4,%esp
80104133:	01 c6                	add    %eax,%esi
80104135:	56                   	push   %esi
80104136:	50                   	push   %eax
80104137:	ff 73 04             	pushl  0x4(%ebx)
8010413a:	e8 91 31 00 00       	call   801072d0 <allocuvm>
8010413f:	83 c4 10             	add    $0x10,%esp
80104142:	85 c0                	test   %eax,%eax
80104144:	75 d3                	jne    80104119 <growproc+0x29>
      return -1;
80104146:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010414b:	eb dc                	jmp    80104129 <growproc+0x39>
8010414d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104150:	83 ec 04             	sub    $0x4,%esp
80104153:	01 c6                	add    %eax,%esi
80104155:	56                   	push   %esi
80104156:	50                   	push   %eax
80104157:	ff 73 04             	pushl  0x4(%ebx)
8010415a:	e8 a1 32 00 00       	call   80107400 <deallocuvm>
8010415f:	83 c4 10             	add    $0x10,%esp
80104162:	85 c0                	test   %eax,%eax
80104164:	75 b3                	jne    80104119 <growproc+0x29>
80104166:	eb de                	jmp    80104146 <growproc+0x56>
80104168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416f:	90                   	nop

80104170 <fork>:
{
80104170:	f3 0f 1e fb          	endbr32 
80104174:	55                   	push   %ebp
80104175:	89 e5                	mov    %esp,%ebp
80104177:	57                   	push   %edi
80104178:	56                   	push   %esi
80104179:	53                   	push   %ebx
8010417a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010417d:	e8 3e 09 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
80104182:	e8 a9 fd ff ff       	call   80103f30 <mycpu>
  p = c->proc;
80104187:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010418d:	e8 7e 09 00 00       	call   80104b10 <popcli>
  if((np = allocproc()) == 0){
80104192:	e8 59 fc ff ff       	call   80103df0 <allocproc>
80104197:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010419a:	85 c0                	test   %eax,%eax
8010419c:	0f 84 bb 00 00 00    	je     8010425d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801041a2:	83 ec 08             	sub    $0x8,%esp
801041a5:	ff 33                	pushl  (%ebx)
801041a7:	89 c7                	mov    %eax,%edi
801041a9:	ff 73 04             	pushl  0x4(%ebx)
801041ac:	e8 cf 33 00 00       	call   80107580 <copyuvm>
801041b1:	83 c4 10             	add    $0x10,%esp
801041b4:	89 47 04             	mov    %eax,0x4(%edi)
801041b7:	85 c0                	test   %eax,%eax
801041b9:	0f 84 a5 00 00 00    	je     80104264 <fork+0xf4>
  np->sz = curproc->sz;
801041bf:	8b 03                	mov    (%ebx),%eax
801041c1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801041c4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801041c6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801041c9:	89 c8                	mov    %ecx,%eax
801041cb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801041ce:	b9 13 00 00 00       	mov    $0x13,%ecx
801041d3:	8b 73 18             	mov    0x18(%ebx),%esi
801041d6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801041d8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801041da:	8b 40 18             	mov    0x18(%eax),%eax
801041dd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
801041e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
801041e8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801041ec:	85 c0                	test   %eax,%eax
801041ee:	74 13                	je     80104203 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
801041f0:	83 ec 0c             	sub    $0xc,%esp
801041f3:	50                   	push   %eax
801041f4:	e8 d7 d2 ff ff       	call   801014d0 <filedup>
801041f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801041fc:	83 c4 10             	add    $0x10,%esp
801041ff:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104203:	83 c6 01             	add    $0x1,%esi
80104206:	83 fe 10             	cmp    $0x10,%esi
80104209:	75 dd                	jne    801041e8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010420b:	83 ec 0c             	sub    $0xc,%esp
8010420e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104211:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104214:	e8 77 db ff ff       	call   80101d90 <idup>
80104219:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010421c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010421f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104222:	8d 47 6c             	lea    0x6c(%edi),%eax
80104225:	6a 10                	push   $0x10
80104227:	53                   	push   %ebx
80104228:	50                   	push   %eax
80104229:	e8 62 0c 00 00       	call   80104e90 <safestrcpy>
  pid = np->pid;
8010422e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104231:	c7 04 24 00 46 11 80 	movl   $0x80114600,(%esp)
80104238:	e8 83 09 00 00       	call   80104bc0 <acquire>
  np->state = RUNNABLE;
8010423d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104244:	c7 04 24 00 46 11 80 	movl   $0x80114600,(%esp)
8010424b:	e8 30 0a 00 00       	call   80104c80 <release>
  return pid;
80104250:	83 c4 10             	add    $0x10,%esp
}
80104253:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104256:	89 d8                	mov    %ebx,%eax
80104258:	5b                   	pop    %ebx
80104259:	5e                   	pop    %esi
8010425a:	5f                   	pop    %edi
8010425b:	5d                   	pop    %ebp
8010425c:	c3                   	ret    
    return -1;
8010425d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104262:	eb ef                	jmp    80104253 <fork+0xe3>
    kfree(np->kstack);
80104264:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104267:	83 ec 0c             	sub    $0xc,%esp
8010426a:	ff 73 08             	pushl  0x8(%ebx)
8010426d:	e8 5e e8 ff ff       	call   80102ad0 <kfree>
    np->kstack = 0;
80104272:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104279:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010427c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104283:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104288:	eb c9                	jmp    80104253 <fork+0xe3>
8010428a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104290 <scheduler>:
{
80104290:	f3 0f 1e fb          	endbr32 
80104294:	55                   	push   %ebp
80104295:	89 e5                	mov    %esp,%ebp
80104297:	57                   	push   %edi
80104298:	56                   	push   %esi
80104299:	53                   	push   %ebx
8010429a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010429d:	e8 8e fc ff ff       	call   80103f30 <mycpu>
  c->proc = 0;
801042a2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801042a9:	00 00 00 
  struct cpu *c = mycpu();
801042ac:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801042ae:	8d 78 04             	lea    0x4(%eax),%edi
801042b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
801042b8:	fb                   	sti    
    acquire(&ptable.lock);
801042b9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042bc:	bb 34 46 11 80       	mov    $0x80114634,%ebx
    acquire(&ptable.lock);
801042c1:	68 00 46 11 80       	push   $0x80114600
801042c6:	e8 f5 08 00 00       	call   80104bc0 <acquire>
801042cb:	83 c4 10             	add    $0x10,%esp
801042ce:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
801042d0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801042d4:	75 33                	jne    80104309 <scheduler+0x79>
      switchuvm(p);
801042d6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801042d9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801042df:	53                   	push   %ebx
801042e0:	e8 8b 2d 00 00       	call   80107070 <switchuvm>
      swtch(&(c->scheduler), p->context);
801042e5:	58                   	pop    %eax
801042e6:	5a                   	pop    %edx
801042e7:	ff 73 1c             	pushl  0x1c(%ebx)
801042ea:	57                   	push   %edi
      p->state = RUNNING;
801042eb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801042f2:	e8 fc 0b 00 00       	call   80104ef3 <swtch>
      switchkvm();
801042f7:	e8 54 2d 00 00       	call   80107050 <switchkvm>
      c->proc = 0;
801042fc:	83 c4 10             	add    $0x10,%esp
801042ff:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104306:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104309:	83 c3 7c             	add    $0x7c,%ebx
8010430c:	81 fb 34 65 11 80    	cmp    $0x80116534,%ebx
80104312:	75 bc                	jne    801042d0 <scheduler+0x40>
    release(&ptable.lock);
80104314:	83 ec 0c             	sub    $0xc,%esp
80104317:	68 00 46 11 80       	push   $0x80114600
8010431c:	e8 5f 09 00 00       	call   80104c80 <release>
    sti();
80104321:	83 c4 10             	add    $0x10,%esp
80104324:	eb 92                	jmp    801042b8 <scheduler+0x28>
80104326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010432d:	8d 76 00             	lea    0x0(%esi),%esi

80104330 <sched>:
{
80104330:	f3 0f 1e fb          	endbr32 
80104334:	55                   	push   %ebp
80104335:	89 e5                	mov    %esp,%ebp
80104337:	56                   	push   %esi
80104338:	53                   	push   %ebx
  pushcli();
80104339:	e8 82 07 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
8010433e:	e8 ed fb ff ff       	call   80103f30 <mycpu>
  p = c->proc;
80104343:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104349:	e8 c2 07 00 00       	call   80104b10 <popcli>
  if(!holding(&ptable.lock))
8010434e:	83 ec 0c             	sub    $0xc,%esp
80104351:	68 00 46 11 80       	push   $0x80114600
80104356:	e8 15 08 00 00       	call   80104b70 <holding>
8010435b:	83 c4 10             	add    $0x10,%esp
8010435e:	85 c0                	test   %eax,%eax
80104360:	74 4f                	je     801043b1 <sched+0x81>
  if(mycpu()->ncli != 1)
80104362:	e8 c9 fb ff ff       	call   80103f30 <mycpu>
80104367:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010436e:	75 68                	jne    801043d8 <sched+0xa8>
  if(p->state == RUNNING)
80104370:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104374:	74 55                	je     801043cb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104376:	9c                   	pushf  
80104377:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104378:	f6 c4 02             	test   $0x2,%ah
8010437b:	75 41                	jne    801043be <sched+0x8e>
  intena = mycpu()->intena;
8010437d:	e8 ae fb ff ff       	call   80103f30 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104382:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104385:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010438b:	e8 a0 fb ff ff       	call   80103f30 <mycpu>
80104390:	83 ec 08             	sub    $0x8,%esp
80104393:	ff 70 04             	pushl  0x4(%eax)
80104396:	53                   	push   %ebx
80104397:	e8 57 0b 00 00       	call   80104ef3 <swtch>
  mycpu()->intena = intena;
8010439c:	e8 8f fb ff ff       	call   80103f30 <mycpu>
}
801043a1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801043a4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801043aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043ad:	5b                   	pop    %ebx
801043ae:	5e                   	pop    %esi
801043af:	5d                   	pop    %ebp
801043b0:	c3                   	ret    
    panic("sched ptable.lock");
801043b1:	83 ec 0c             	sub    $0xc,%esp
801043b4:	68 db 7c 10 80       	push   $0x80107cdb
801043b9:	e8 42 c3 ff ff       	call   80100700 <panic>
    panic("sched interruptible");
801043be:	83 ec 0c             	sub    $0xc,%esp
801043c1:	68 07 7d 10 80       	push   $0x80107d07
801043c6:	e8 35 c3 ff ff       	call   80100700 <panic>
    panic("sched running");
801043cb:	83 ec 0c             	sub    $0xc,%esp
801043ce:	68 f9 7c 10 80       	push   $0x80107cf9
801043d3:	e8 28 c3 ff ff       	call   80100700 <panic>
    panic("sched locks");
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	68 ed 7c 10 80       	push   $0x80107ced
801043e0:	e8 1b c3 ff ff       	call   80100700 <panic>
801043e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043f0 <exit>:
{
801043f0:	f3 0f 1e fb          	endbr32 
801043f4:	55                   	push   %ebp
801043f5:	89 e5                	mov    %esp,%ebp
801043f7:	57                   	push   %edi
801043f8:	56                   	push   %esi
801043f9:	53                   	push   %ebx
801043fa:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801043fd:	e8 be 06 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
80104402:	e8 29 fb ff ff       	call   80103f30 <mycpu>
  p = c->proc;
80104407:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010440d:	e8 fe 06 00 00       	call   80104b10 <popcli>
  if(curproc == initproc)
80104412:	8d 5e 28             	lea    0x28(%esi),%ebx
80104415:	8d 7e 68             	lea    0x68(%esi),%edi
80104418:	39 35 d8 b5 10 80    	cmp    %esi,0x8010b5d8
8010441e:	0f 84 f3 00 00 00    	je     80104517 <exit+0x127>
80104424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104428:	8b 03                	mov    (%ebx),%eax
8010442a:	85 c0                	test   %eax,%eax
8010442c:	74 12                	je     80104440 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010442e:	83 ec 0c             	sub    $0xc,%esp
80104431:	50                   	push   %eax
80104432:	e8 e9 d0 ff ff       	call   80101520 <fileclose>
      curproc->ofile[fd] = 0;
80104437:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010443d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104440:	83 c3 04             	add    $0x4,%ebx
80104443:	39 df                	cmp    %ebx,%edi
80104445:	75 e1                	jne    80104428 <exit+0x38>
  begin_op();
80104447:	e8 44 ef ff ff       	call   80103390 <begin_op>
  iput(curproc->cwd);
8010444c:	83 ec 0c             	sub    $0xc,%esp
8010444f:	ff 76 68             	pushl  0x68(%esi)
80104452:	e8 99 da ff ff       	call   80101ef0 <iput>
  end_op();
80104457:	e8 a4 ef ff ff       	call   80103400 <end_op>
  curproc->cwd = 0;
8010445c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104463:	c7 04 24 00 46 11 80 	movl   $0x80114600,(%esp)
8010446a:	e8 51 07 00 00       	call   80104bc0 <acquire>
  wakeup1(curproc->parent);
8010446f:	8b 56 14             	mov    0x14(%esi),%edx
80104472:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104475:	b8 34 46 11 80       	mov    $0x80114634,%eax
8010447a:	eb 0e                	jmp    8010448a <exit+0x9a>
8010447c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104480:	83 c0 7c             	add    $0x7c,%eax
80104483:	3d 34 65 11 80       	cmp    $0x80116534,%eax
80104488:	74 1c                	je     801044a6 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
8010448a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010448e:	75 f0                	jne    80104480 <exit+0x90>
80104490:	3b 50 20             	cmp    0x20(%eax),%edx
80104493:	75 eb                	jne    80104480 <exit+0x90>
      p->state = RUNNABLE;
80104495:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010449c:	83 c0 7c             	add    $0x7c,%eax
8010449f:	3d 34 65 11 80       	cmp    $0x80116534,%eax
801044a4:	75 e4                	jne    8010448a <exit+0x9a>
      p->parent = initproc;
801044a6:	8b 0d d8 b5 10 80    	mov    0x8010b5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ac:	ba 34 46 11 80       	mov    $0x80114634,%edx
801044b1:	eb 10                	jmp    801044c3 <exit+0xd3>
801044b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044b7:	90                   	nop
801044b8:	83 c2 7c             	add    $0x7c,%edx
801044bb:	81 fa 34 65 11 80    	cmp    $0x80116534,%edx
801044c1:	74 3b                	je     801044fe <exit+0x10e>
    if(p->parent == curproc){
801044c3:	39 72 14             	cmp    %esi,0x14(%edx)
801044c6:	75 f0                	jne    801044b8 <exit+0xc8>
      if(p->state == ZOMBIE)
801044c8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801044cc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801044cf:	75 e7                	jne    801044b8 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044d1:	b8 34 46 11 80       	mov    $0x80114634,%eax
801044d6:	eb 12                	jmp    801044ea <exit+0xfa>
801044d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044df:	90                   	nop
801044e0:	83 c0 7c             	add    $0x7c,%eax
801044e3:	3d 34 65 11 80       	cmp    $0x80116534,%eax
801044e8:	74 ce                	je     801044b8 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
801044ea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044ee:	75 f0                	jne    801044e0 <exit+0xf0>
801044f0:	3b 48 20             	cmp    0x20(%eax),%ecx
801044f3:	75 eb                	jne    801044e0 <exit+0xf0>
      p->state = RUNNABLE;
801044f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801044fc:	eb e2                	jmp    801044e0 <exit+0xf0>
  curproc->state = ZOMBIE;
801044fe:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104505:	e8 26 fe ff ff       	call   80104330 <sched>
  panic("zombie exit");
8010450a:	83 ec 0c             	sub    $0xc,%esp
8010450d:	68 28 7d 10 80       	push   $0x80107d28
80104512:	e8 e9 c1 ff ff       	call   80100700 <panic>
    panic("init exiting");
80104517:	83 ec 0c             	sub    $0xc,%esp
8010451a:	68 1b 7d 10 80       	push   $0x80107d1b
8010451f:	e8 dc c1 ff ff       	call   80100700 <panic>
80104524:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010452b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010452f:	90                   	nop

80104530 <yield>:
{
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
80104535:	89 e5                	mov    %esp,%ebp
80104537:	53                   	push   %ebx
80104538:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010453b:	68 00 46 11 80       	push   $0x80114600
80104540:	e8 7b 06 00 00       	call   80104bc0 <acquire>
  pushcli();
80104545:	e8 76 05 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
8010454a:	e8 e1 f9 ff ff       	call   80103f30 <mycpu>
  p = c->proc;
8010454f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104555:	e8 b6 05 00 00       	call   80104b10 <popcli>
  myproc()->state = RUNNABLE;
8010455a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104561:	e8 ca fd ff ff       	call   80104330 <sched>
  release(&ptable.lock);
80104566:	c7 04 24 00 46 11 80 	movl   $0x80114600,(%esp)
8010456d:	e8 0e 07 00 00       	call   80104c80 <release>
}
80104572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104575:	83 c4 10             	add    $0x10,%esp
80104578:	c9                   	leave  
80104579:	c3                   	ret    
8010457a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104580 <sleep>:
{
80104580:	f3 0f 1e fb          	endbr32 
80104584:	55                   	push   %ebp
80104585:	89 e5                	mov    %esp,%ebp
80104587:	57                   	push   %edi
80104588:	56                   	push   %esi
80104589:	53                   	push   %ebx
8010458a:	83 ec 0c             	sub    $0xc,%esp
8010458d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104590:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104593:	e8 28 05 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
80104598:	e8 93 f9 ff ff       	call   80103f30 <mycpu>
  p = c->proc;
8010459d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045a3:	e8 68 05 00 00       	call   80104b10 <popcli>
  if(p == 0)
801045a8:	85 db                	test   %ebx,%ebx
801045aa:	0f 84 83 00 00 00    	je     80104633 <sleep+0xb3>
  if(lk == 0)
801045b0:	85 f6                	test   %esi,%esi
801045b2:	74 72                	je     80104626 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801045b4:	81 fe 00 46 11 80    	cmp    $0x80114600,%esi
801045ba:	74 4c                	je     80104608 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801045bc:	83 ec 0c             	sub    $0xc,%esp
801045bf:	68 00 46 11 80       	push   $0x80114600
801045c4:	e8 f7 05 00 00       	call   80104bc0 <acquire>
    release(lk);
801045c9:	89 34 24             	mov    %esi,(%esp)
801045cc:	e8 af 06 00 00       	call   80104c80 <release>
  p->chan = chan;
801045d1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801045d4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801045db:	e8 50 fd ff ff       	call   80104330 <sched>
  p->chan = 0;
801045e0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801045e7:	c7 04 24 00 46 11 80 	movl   $0x80114600,(%esp)
801045ee:	e8 8d 06 00 00       	call   80104c80 <release>
    acquire(lk);
801045f3:	89 75 08             	mov    %esi,0x8(%ebp)
801045f6:	83 c4 10             	add    $0x10,%esp
}
801045f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045fc:	5b                   	pop    %ebx
801045fd:	5e                   	pop    %esi
801045fe:	5f                   	pop    %edi
801045ff:	5d                   	pop    %ebp
    acquire(lk);
80104600:	e9 bb 05 00 00       	jmp    80104bc0 <acquire>
80104605:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104608:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010460b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104612:	e8 19 fd ff ff       	call   80104330 <sched>
  p->chan = 0;
80104617:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010461e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104621:	5b                   	pop    %ebx
80104622:	5e                   	pop    %esi
80104623:	5f                   	pop    %edi
80104624:	5d                   	pop    %ebp
80104625:	c3                   	ret    
    panic("sleep without lk");
80104626:	83 ec 0c             	sub    $0xc,%esp
80104629:	68 3a 7d 10 80       	push   $0x80107d3a
8010462e:	e8 cd c0 ff ff       	call   80100700 <panic>
    panic("sleep");
80104633:	83 ec 0c             	sub    $0xc,%esp
80104636:	68 34 7d 10 80       	push   $0x80107d34
8010463b:	e8 c0 c0 ff ff       	call   80100700 <panic>

80104640 <wait>:
{
80104640:	f3 0f 1e fb          	endbr32 
80104644:	55                   	push   %ebp
80104645:	89 e5                	mov    %esp,%ebp
80104647:	56                   	push   %esi
80104648:	53                   	push   %ebx
  pushcli();
80104649:	e8 72 04 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
8010464e:	e8 dd f8 ff ff       	call   80103f30 <mycpu>
  p = c->proc;
80104653:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104659:	e8 b2 04 00 00       	call   80104b10 <popcli>
  acquire(&ptable.lock);
8010465e:	83 ec 0c             	sub    $0xc,%esp
80104661:	68 00 46 11 80       	push   $0x80114600
80104666:	e8 55 05 00 00       	call   80104bc0 <acquire>
8010466b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010466e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104670:	bb 34 46 11 80       	mov    $0x80114634,%ebx
80104675:	eb 14                	jmp    8010468b <wait+0x4b>
80104677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010467e:	66 90                	xchg   %ax,%ax
80104680:	83 c3 7c             	add    $0x7c,%ebx
80104683:	81 fb 34 65 11 80    	cmp    $0x80116534,%ebx
80104689:	74 1b                	je     801046a6 <wait+0x66>
      if(p->parent != curproc)
8010468b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010468e:	75 f0                	jne    80104680 <wait+0x40>
      if(p->state == ZOMBIE){
80104690:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104694:	74 32                	je     801046c8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104696:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104699:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010469e:	81 fb 34 65 11 80    	cmp    $0x80116534,%ebx
801046a4:	75 e5                	jne    8010468b <wait+0x4b>
    if(!havekids || curproc->killed){
801046a6:	85 c0                	test   %eax,%eax
801046a8:	74 74                	je     8010471e <wait+0xde>
801046aa:	8b 46 24             	mov    0x24(%esi),%eax
801046ad:	85 c0                	test   %eax,%eax
801046af:	75 6d                	jne    8010471e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801046b1:	83 ec 08             	sub    $0x8,%esp
801046b4:	68 00 46 11 80       	push   $0x80114600
801046b9:	56                   	push   %esi
801046ba:	e8 c1 fe ff ff       	call   80104580 <sleep>
    havekids = 0;
801046bf:	83 c4 10             	add    $0x10,%esp
801046c2:	eb aa                	jmp    8010466e <wait+0x2e>
801046c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801046c8:	83 ec 0c             	sub    $0xc,%esp
801046cb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801046ce:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801046d1:	e8 fa e3 ff ff       	call   80102ad0 <kfree>
        freevm(p->pgdir);
801046d6:	5a                   	pop    %edx
801046d7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801046da:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801046e1:	e8 4a 2d 00 00       	call   80107430 <freevm>
        release(&ptable.lock);
801046e6:	c7 04 24 00 46 11 80 	movl   $0x80114600,(%esp)
        p->pid = 0;
801046ed:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801046f4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801046fb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801046ff:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104706:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010470d:	e8 6e 05 00 00       	call   80104c80 <release>
        return pid;
80104712:	83 c4 10             	add    $0x10,%esp
}
80104715:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104718:	89 f0                	mov    %esi,%eax
8010471a:	5b                   	pop    %ebx
8010471b:	5e                   	pop    %esi
8010471c:	5d                   	pop    %ebp
8010471d:	c3                   	ret    
      release(&ptable.lock);
8010471e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104721:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104726:	68 00 46 11 80       	push   $0x80114600
8010472b:	e8 50 05 00 00       	call   80104c80 <release>
      return -1;
80104730:	83 c4 10             	add    $0x10,%esp
80104733:	eb e0                	jmp    80104715 <wait+0xd5>
80104735:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104740 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104740:	f3 0f 1e fb          	endbr32 
80104744:	55                   	push   %ebp
80104745:	89 e5                	mov    %esp,%ebp
80104747:	53                   	push   %ebx
80104748:	83 ec 10             	sub    $0x10,%esp
8010474b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010474e:	68 00 46 11 80       	push   $0x80114600
80104753:	e8 68 04 00 00       	call   80104bc0 <acquire>
80104758:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010475b:	b8 34 46 11 80       	mov    $0x80114634,%eax
80104760:	eb 10                	jmp    80104772 <wakeup+0x32>
80104762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104768:	83 c0 7c             	add    $0x7c,%eax
8010476b:	3d 34 65 11 80       	cmp    $0x80116534,%eax
80104770:	74 1c                	je     8010478e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104772:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104776:	75 f0                	jne    80104768 <wakeup+0x28>
80104778:	3b 58 20             	cmp    0x20(%eax),%ebx
8010477b:	75 eb                	jne    80104768 <wakeup+0x28>
      p->state = RUNNABLE;
8010477d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104784:	83 c0 7c             	add    $0x7c,%eax
80104787:	3d 34 65 11 80       	cmp    $0x80116534,%eax
8010478c:	75 e4                	jne    80104772 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010478e:	c7 45 08 00 46 11 80 	movl   $0x80114600,0x8(%ebp)
}
80104795:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104798:	c9                   	leave  
  release(&ptable.lock);
80104799:	e9 e2 04 00 00       	jmp    80104c80 <release>
8010479e:	66 90                	xchg   %ax,%ax

801047a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801047a0:	f3 0f 1e fb          	endbr32 
801047a4:	55                   	push   %ebp
801047a5:	89 e5                	mov    %esp,%ebp
801047a7:	53                   	push   %ebx
801047a8:	83 ec 10             	sub    $0x10,%esp
801047ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801047ae:	68 00 46 11 80       	push   $0x80114600
801047b3:	e8 08 04 00 00       	call   80104bc0 <acquire>
801047b8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047bb:	b8 34 46 11 80       	mov    $0x80114634,%eax
801047c0:	eb 10                	jmp    801047d2 <kill+0x32>
801047c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047c8:	83 c0 7c             	add    $0x7c,%eax
801047cb:	3d 34 65 11 80       	cmp    $0x80116534,%eax
801047d0:	74 36                	je     80104808 <kill+0x68>
    if(p->pid == pid){
801047d2:	39 58 10             	cmp    %ebx,0x10(%eax)
801047d5:	75 f1                	jne    801047c8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801047d7:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801047db:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801047e2:	75 07                	jne    801047eb <kill+0x4b>
        p->state = RUNNABLE;
801047e4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801047eb:	83 ec 0c             	sub    $0xc,%esp
801047ee:	68 00 46 11 80       	push   $0x80114600
801047f3:	e8 88 04 00 00       	call   80104c80 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801047f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801047fb:	83 c4 10             	add    $0x10,%esp
801047fe:	31 c0                	xor    %eax,%eax
}
80104800:	c9                   	leave  
80104801:	c3                   	ret    
80104802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104808:	83 ec 0c             	sub    $0xc,%esp
8010480b:	68 00 46 11 80       	push   $0x80114600
80104810:	e8 6b 04 00 00       	call   80104c80 <release>
}
80104815:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104818:	83 c4 10             	add    $0x10,%esp
8010481b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104820:	c9                   	leave  
80104821:	c3                   	ret    
80104822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104830 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104830:	f3 0f 1e fb          	endbr32 
80104834:	55                   	push   %ebp
80104835:	89 e5                	mov    %esp,%ebp
80104837:	57                   	push   %edi
80104838:	56                   	push   %esi
80104839:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010483c:	53                   	push   %ebx
8010483d:	bb a0 46 11 80       	mov    $0x801146a0,%ebx
80104842:	83 ec 3c             	sub    $0x3c,%esp
80104845:	eb 28                	jmp    8010486f <procdump+0x3f>
80104847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104850:	83 ec 0c             	sub    $0xc,%esp
80104853:	68 b7 80 10 80       	push   $0x801080b7
80104858:	e8 23 bf ff ff       	call   80100780 <cprintf>
8010485d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104860:	83 c3 7c             	add    $0x7c,%ebx
80104863:	81 fb a0 65 11 80    	cmp    $0x801165a0,%ebx
80104869:	0f 84 81 00 00 00    	je     801048f0 <procdump+0xc0>
    if(p->state == UNUSED)
8010486f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104872:	85 c0                	test   %eax,%eax
80104874:	74 ea                	je     80104860 <procdump+0x30>
      state = "???";
80104876:	ba 4b 7d 10 80       	mov    $0x80107d4b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010487b:	83 f8 05             	cmp    $0x5,%eax
8010487e:	77 11                	ja     80104891 <procdump+0x61>
80104880:	8b 14 85 ac 7d 10 80 	mov    -0x7fef8254(,%eax,4),%edx
      state = "???";
80104887:	b8 4b 7d 10 80       	mov    $0x80107d4b,%eax
8010488c:	85 d2                	test   %edx,%edx
8010488e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104891:	53                   	push   %ebx
80104892:	52                   	push   %edx
80104893:	ff 73 a4             	pushl  -0x5c(%ebx)
80104896:	68 4f 7d 10 80       	push   $0x80107d4f
8010489b:	e8 e0 be ff ff       	call   80100780 <cprintf>
    if(p->state == SLEEPING){
801048a0:	83 c4 10             	add    $0x10,%esp
801048a3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801048a7:	75 a7                	jne    80104850 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801048a9:	83 ec 08             	sub    $0x8,%esp
801048ac:	8d 45 c0             	lea    -0x40(%ebp),%eax
801048af:	8d 7d c0             	lea    -0x40(%ebp),%edi
801048b2:	50                   	push   %eax
801048b3:	8b 43 b0             	mov    -0x50(%ebx),%eax
801048b6:	8b 40 0c             	mov    0xc(%eax),%eax
801048b9:	83 c0 08             	add    $0x8,%eax
801048bc:	50                   	push   %eax
801048bd:	e8 9e 01 00 00       	call   80104a60 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801048c2:	83 c4 10             	add    $0x10,%esp
801048c5:	8d 76 00             	lea    0x0(%esi),%esi
801048c8:	8b 17                	mov    (%edi),%edx
801048ca:	85 d2                	test   %edx,%edx
801048cc:	74 82                	je     80104850 <procdump+0x20>
        cprintf(" %p", pc[i]);
801048ce:	83 ec 08             	sub    $0x8,%esp
801048d1:	83 c7 04             	add    $0x4,%edi
801048d4:	52                   	push   %edx
801048d5:	68 81 77 10 80       	push   $0x80107781
801048da:	e8 a1 be ff ff       	call   80100780 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801048df:	83 c4 10             	add    $0x10,%esp
801048e2:	39 fe                	cmp    %edi,%esi
801048e4:	75 e2                	jne    801048c8 <procdump+0x98>
801048e6:	e9 65 ff ff ff       	jmp    80104850 <procdump+0x20>
801048eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048ef:	90                   	nop
  }
}
801048f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048f3:	5b                   	pop    %ebx
801048f4:	5e                   	pop    %esi
801048f5:	5f                   	pop    %edi
801048f6:	5d                   	pop    %ebp
801048f7:	c3                   	ret    
801048f8:	66 90                	xchg   %ax,%ax
801048fa:	66 90                	xchg   %ax,%ax
801048fc:	66 90                	xchg   %ax,%ax
801048fe:	66 90                	xchg   %ax,%ax

80104900 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104900:	f3 0f 1e fb          	endbr32 
80104904:	55                   	push   %ebp
80104905:	89 e5                	mov    %esp,%ebp
80104907:	53                   	push   %ebx
80104908:	83 ec 0c             	sub    $0xc,%esp
8010490b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010490e:	68 c4 7d 10 80       	push   $0x80107dc4
80104913:	8d 43 04             	lea    0x4(%ebx),%eax
80104916:	50                   	push   %eax
80104917:	e8 24 01 00 00       	call   80104a40 <initlock>
  lk->name = name;
8010491c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010491f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104925:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104928:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010492f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104932:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104935:	c9                   	leave  
80104936:	c3                   	ret    
80104937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493e:	66 90                	xchg   %ax,%ax

80104940 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104940:	f3 0f 1e fb          	endbr32 
80104944:	55                   	push   %ebp
80104945:	89 e5                	mov    %esp,%ebp
80104947:	56                   	push   %esi
80104948:	53                   	push   %ebx
80104949:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010494c:	8d 73 04             	lea    0x4(%ebx),%esi
8010494f:	83 ec 0c             	sub    $0xc,%esp
80104952:	56                   	push   %esi
80104953:	e8 68 02 00 00       	call   80104bc0 <acquire>
  while (lk->locked) {
80104958:	8b 13                	mov    (%ebx),%edx
8010495a:	83 c4 10             	add    $0x10,%esp
8010495d:	85 d2                	test   %edx,%edx
8010495f:	74 1a                	je     8010497b <acquiresleep+0x3b>
80104961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104968:	83 ec 08             	sub    $0x8,%esp
8010496b:	56                   	push   %esi
8010496c:	53                   	push   %ebx
8010496d:	e8 0e fc ff ff       	call   80104580 <sleep>
  while (lk->locked) {
80104972:	8b 03                	mov    (%ebx),%eax
80104974:	83 c4 10             	add    $0x10,%esp
80104977:	85 c0                	test   %eax,%eax
80104979:	75 ed                	jne    80104968 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010497b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104981:	e8 3a f6 ff ff       	call   80103fc0 <myproc>
80104986:	8b 40 10             	mov    0x10(%eax),%eax
80104989:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010498c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010498f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104992:	5b                   	pop    %ebx
80104993:	5e                   	pop    %esi
80104994:	5d                   	pop    %ebp
  release(&lk->lk);
80104995:	e9 e6 02 00 00       	jmp    80104c80 <release>
8010499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801049a0:	f3 0f 1e fb          	endbr32 
801049a4:	55                   	push   %ebp
801049a5:	89 e5                	mov    %esp,%ebp
801049a7:	56                   	push   %esi
801049a8:	53                   	push   %ebx
801049a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049ac:	8d 73 04             	lea    0x4(%ebx),%esi
801049af:	83 ec 0c             	sub    $0xc,%esp
801049b2:	56                   	push   %esi
801049b3:	e8 08 02 00 00       	call   80104bc0 <acquire>
  lk->locked = 0;
801049b8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801049be:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801049c5:	89 1c 24             	mov    %ebx,(%esp)
801049c8:	e8 73 fd ff ff       	call   80104740 <wakeup>
  release(&lk->lk);
801049cd:	89 75 08             	mov    %esi,0x8(%ebp)
801049d0:	83 c4 10             	add    $0x10,%esp
}
801049d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049d6:	5b                   	pop    %ebx
801049d7:	5e                   	pop    %esi
801049d8:	5d                   	pop    %ebp
  release(&lk->lk);
801049d9:	e9 a2 02 00 00       	jmp    80104c80 <release>
801049de:	66 90                	xchg   %ax,%ax

801049e0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801049e0:	f3 0f 1e fb          	endbr32 
801049e4:	55                   	push   %ebp
801049e5:	89 e5                	mov    %esp,%ebp
801049e7:	57                   	push   %edi
801049e8:	31 ff                	xor    %edi,%edi
801049ea:	56                   	push   %esi
801049eb:	53                   	push   %ebx
801049ec:	83 ec 18             	sub    $0x18,%esp
801049ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801049f2:	8d 73 04             	lea    0x4(%ebx),%esi
801049f5:	56                   	push   %esi
801049f6:	e8 c5 01 00 00       	call   80104bc0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801049fb:	8b 03                	mov    (%ebx),%eax
801049fd:	83 c4 10             	add    $0x10,%esp
80104a00:	85 c0                	test   %eax,%eax
80104a02:	75 1c                	jne    80104a20 <holdingsleep+0x40>
  release(&lk->lk);
80104a04:	83 ec 0c             	sub    $0xc,%esp
80104a07:	56                   	push   %esi
80104a08:	e8 73 02 00 00       	call   80104c80 <release>
  return r;
}
80104a0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a10:	89 f8                	mov    %edi,%eax
80104a12:	5b                   	pop    %ebx
80104a13:	5e                   	pop    %esi
80104a14:	5f                   	pop    %edi
80104a15:	5d                   	pop    %ebp
80104a16:	c3                   	ret    
80104a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104a20:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a23:	e8 98 f5 ff ff       	call   80103fc0 <myproc>
80104a28:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a2b:	0f 94 c0             	sete   %al
80104a2e:	0f b6 c0             	movzbl %al,%eax
80104a31:	89 c7                	mov    %eax,%edi
80104a33:	eb cf                	jmp    80104a04 <holdingsleep+0x24>
80104a35:	66 90                	xchg   %ax,%ax
80104a37:	66 90                	xchg   %ax,%ax
80104a39:	66 90                	xchg   %ax,%ax
80104a3b:	66 90                	xchg   %ax,%ax
80104a3d:	66 90                	xchg   %ax,%ax
80104a3f:	90                   	nop

80104a40 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a40:	f3 0f 1e fb          	endbr32 
80104a44:	55                   	push   %ebp
80104a45:	89 e5                	mov    %esp,%ebp
80104a47:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a53:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a5d:	5d                   	pop    %ebp
80104a5e:	c3                   	ret    
80104a5f:	90                   	nop

80104a60 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a65:	31 d2                	xor    %edx,%edx
{
80104a67:	89 e5                	mov    %esp,%ebp
80104a69:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104a6a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104a6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104a70:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104a73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a77:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a78:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a7e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a84:	77 1a                	ja     80104aa0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a86:	8b 58 04             	mov    0x4(%eax),%ebx
80104a89:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a8c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a8f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a91:	83 fa 0a             	cmp    $0xa,%edx
80104a94:	75 e2                	jne    80104a78 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104a96:	5b                   	pop    %ebx
80104a97:	5d                   	pop    %ebp
80104a98:	c3                   	ret    
80104a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104aa0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104aa3:	8d 51 28             	lea    0x28(%ecx),%edx
80104aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aad:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104ab0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ab6:	83 c0 04             	add    $0x4,%eax
80104ab9:	39 d0                	cmp    %edx,%eax
80104abb:	75 f3                	jne    80104ab0 <getcallerpcs+0x50>
}
80104abd:	5b                   	pop    %ebx
80104abe:	5d                   	pop    %ebp
80104abf:	c3                   	ret    

80104ac0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ac0:	f3 0f 1e fb          	endbr32 
80104ac4:	55                   	push   %ebp
80104ac5:	89 e5                	mov    %esp,%ebp
80104ac7:	53                   	push   %ebx
80104ac8:	83 ec 04             	sub    $0x4,%esp
80104acb:	9c                   	pushf  
80104acc:	5b                   	pop    %ebx
  asm volatile("cli");
80104acd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104ace:	e8 5d f4 ff ff       	call   80103f30 <mycpu>
80104ad3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ad9:	85 c0                	test   %eax,%eax
80104adb:	74 13                	je     80104af0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104add:	e8 4e f4 ff ff       	call   80103f30 <mycpu>
80104ae2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ae9:	83 c4 04             	add    $0x4,%esp
80104aec:	5b                   	pop    %ebx
80104aed:	5d                   	pop    %ebp
80104aee:	c3                   	ret    
80104aef:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104af0:	e8 3b f4 ff ff       	call   80103f30 <mycpu>
80104af5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104afb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104b01:	eb da                	jmp    80104add <pushcli+0x1d>
80104b03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b10 <popcli>:

void
popcli(void)
{
80104b10:	f3 0f 1e fb          	endbr32 
80104b14:	55                   	push   %ebp
80104b15:	89 e5                	mov    %esp,%ebp
80104b17:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b1a:	9c                   	pushf  
80104b1b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b1c:	f6 c4 02             	test   $0x2,%ah
80104b1f:	75 31                	jne    80104b52 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b21:	e8 0a f4 ff ff       	call   80103f30 <mycpu>
80104b26:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b2d:	78 30                	js     80104b5f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b2f:	e8 fc f3 ff ff       	call   80103f30 <mycpu>
80104b34:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b3a:	85 d2                	test   %edx,%edx
80104b3c:	74 02                	je     80104b40 <popcli+0x30>
    sti();
}
80104b3e:	c9                   	leave  
80104b3f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b40:	e8 eb f3 ff ff       	call   80103f30 <mycpu>
80104b45:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b4b:	85 c0                	test   %eax,%eax
80104b4d:	74 ef                	je     80104b3e <popcli+0x2e>
  asm volatile("sti");
80104b4f:	fb                   	sti    
}
80104b50:	c9                   	leave  
80104b51:	c3                   	ret    
    panic("popcli - interruptible");
80104b52:	83 ec 0c             	sub    $0xc,%esp
80104b55:	68 cf 7d 10 80       	push   $0x80107dcf
80104b5a:	e8 a1 bb ff ff       	call   80100700 <panic>
    panic("popcli");
80104b5f:	83 ec 0c             	sub    $0xc,%esp
80104b62:	68 e6 7d 10 80       	push   $0x80107de6
80104b67:	e8 94 bb ff ff       	call   80100700 <panic>
80104b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b70 <holding>:
{
80104b70:	f3 0f 1e fb          	endbr32 
80104b74:	55                   	push   %ebp
80104b75:	89 e5                	mov    %esp,%ebp
80104b77:	56                   	push   %esi
80104b78:	53                   	push   %ebx
80104b79:	8b 75 08             	mov    0x8(%ebp),%esi
80104b7c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104b7e:	e8 3d ff ff ff       	call   80104ac0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104b83:	8b 06                	mov    (%esi),%eax
80104b85:	85 c0                	test   %eax,%eax
80104b87:	75 0f                	jne    80104b98 <holding+0x28>
  popcli();
80104b89:	e8 82 ff ff ff       	call   80104b10 <popcli>
}
80104b8e:	89 d8                	mov    %ebx,%eax
80104b90:	5b                   	pop    %ebx
80104b91:	5e                   	pop    %esi
80104b92:	5d                   	pop    %ebp
80104b93:	c3                   	ret    
80104b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104b98:	8b 5e 08             	mov    0x8(%esi),%ebx
80104b9b:	e8 90 f3 ff ff       	call   80103f30 <mycpu>
80104ba0:	39 c3                	cmp    %eax,%ebx
80104ba2:	0f 94 c3             	sete   %bl
  popcli();
80104ba5:	e8 66 ff ff ff       	call   80104b10 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104baa:	0f b6 db             	movzbl %bl,%ebx
}
80104bad:	89 d8                	mov    %ebx,%eax
80104baf:	5b                   	pop    %ebx
80104bb0:	5e                   	pop    %esi
80104bb1:	5d                   	pop    %ebp
80104bb2:	c3                   	ret    
80104bb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bc0 <acquire>:
{
80104bc0:	f3 0f 1e fb          	endbr32 
80104bc4:	55                   	push   %ebp
80104bc5:	89 e5                	mov    %esp,%ebp
80104bc7:	56                   	push   %esi
80104bc8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104bc9:	e8 f2 fe ff ff       	call   80104ac0 <pushcli>
  if(holding(lk))
80104bce:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bd1:	83 ec 0c             	sub    $0xc,%esp
80104bd4:	53                   	push   %ebx
80104bd5:	e8 96 ff ff ff       	call   80104b70 <holding>
80104bda:	83 c4 10             	add    $0x10,%esp
80104bdd:	85 c0                	test   %eax,%eax
80104bdf:	0f 85 7f 00 00 00    	jne    80104c64 <acquire+0xa4>
80104be5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104be7:	ba 01 00 00 00       	mov    $0x1,%edx
80104bec:	eb 05                	jmp    80104bf3 <acquire+0x33>
80104bee:	66 90                	xchg   %ax,%ax
80104bf0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bf3:	89 d0                	mov    %edx,%eax
80104bf5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104bf8:	85 c0                	test   %eax,%eax
80104bfa:	75 f4                	jne    80104bf0 <acquire+0x30>
  __sync_synchronize();
80104bfc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104c01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c04:	e8 27 f3 ff ff       	call   80103f30 <mycpu>
80104c09:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104c0c:	89 e8                	mov    %ebp,%eax
80104c0e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c10:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104c16:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104c1c:	77 22                	ja     80104c40 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104c1e:	8b 50 04             	mov    0x4(%eax),%edx
80104c21:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104c25:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104c28:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c2a:	83 fe 0a             	cmp    $0xa,%esi
80104c2d:	75 e1                	jne    80104c10 <acquire+0x50>
}
80104c2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c32:	5b                   	pop    %ebx
80104c33:	5e                   	pop    %esi
80104c34:	5d                   	pop    %ebp
80104c35:	c3                   	ret    
80104c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104c40:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104c44:	83 c3 34             	add    $0x34,%ebx
80104c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c4e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104c50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c56:	83 c0 04             	add    $0x4,%eax
80104c59:	39 d8                	cmp    %ebx,%eax
80104c5b:	75 f3                	jne    80104c50 <acquire+0x90>
}
80104c5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c60:	5b                   	pop    %ebx
80104c61:	5e                   	pop    %esi
80104c62:	5d                   	pop    %ebp
80104c63:	c3                   	ret    
    panic("acquire");
80104c64:	83 ec 0c             	sub    $0xc,%esp
80104c67:	68 ed 7d 10 80       	push   $0x80107ded
80104c6c:	e8 8f ba ff ff       	call   80100700 <panic>
80104c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7f:	90                   	nop

80104c80 <release>:
{
80104c80:	f3 0f 1e fb          	endbr32 
80104c84:	55                   	push   %ebp
80104c85:	89 e5                	mov    %esp,%ebp
80104c87:	53                   	push   %ebx
80104c88:	83 ec 10             	sub    $0x10,%esp
80104c8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104c8e:	53                   	push   %ebx
80104c8f:	e8 dc fe ff ff       	call   80104b70 <holding>
80104c94:	83 c4 10             	add    $0x10,%esp
80104c97:	85 c0                	test   %eax,%eax
80104c99:	74 22                	je     80104cbd <release+0x3d>
  lk->pcs[0] = 0;
80104c9b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104ca2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104ca9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104cae:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104cb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cb7:	c9                   	leave  
  popcli();
80104cb8:	e9 53 fe ff ff       	jmp    80104b10 <popcli>
    panic("release");
80104cbd:	83 ec 0c             	sub    $0xc,%esp
80104cc0:	68 f5 7d 10 80       	push   $0x80107df5
80104cc5:	e8 36 ba ff ff       	call   80100700 <panic>
80104cca:	66 90                	xchg   %ax,%ax
80104ccc:	66 90                	xchg   %ax,%ax
80104cce:	66 90                	xchg   %ax,%ax

80104cd0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104cd0:	f3 0f 1e fb          	endbr32 
80104cd4:	55                   	push   %ebp
80104cd5:	89 e5                	mov    %esp,%ebp
80104cd7:	57                   	push   %edi
80104cd8:	8b 55 08             	mov    0x8(%ebp),%edx
80104cdb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104cde:	53                   	push   %ebx
80104cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104ce2:	89 d7                	mov    %edx,%edi
80104ce4:	09 cf                	or     %ecx,%edi
80104ce6:	83 e7 03             	and    $0x3,%edi
80104ce9:	75 25                	jne    80104d10 <memset+0x40>
    c &= 0xFF;
80104ceb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104cee:	c1 e0 18             	shl    $0x18,%eax
80104cf1:	89 fb                	mov    %edi,%ebx
80104cf3:	c1 e9 02             	shr    $0x2,%ecx
80104cf6:	c1 e3 10             	shl    $0x10,%ebx
80104cf9:	09 d8                	or     %ebx,%eax
80104cfb:	09 f8                	or     %edi,%eax
80104cfd:	c1 e7 08             	shl    $0x8,%edi
80104d00:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104d02:	89 d7                	mov    %edx,%edi
80104d04:	fc                   	cld    
80104d05:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104d07:	5b                   	pop    %ebx
80104d08:	89 d0                	mov    %edx,%eax
80104d0a:	5f                   	pop    %edi
80104d0b:	5d                   	pop    %ebp
80104d0c:	c3                   	ret    
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104d10:	89 d7                	mov    %edx,%edi
80104d12:	fc                   	cld    
80104d13:	f3 aa                	rep stos %al,%es:(%edi)
80104d15:	5b                   	pop    %ebx
80104d16:	89 d0                	mov    %edx,%eax
80104d18:	5f                   	pop    %edi
80104d19:	5d                   	pop    %ebp
80104d1a:	c3                   	ret    
80104d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d1f:	90                   	nop

80104d20 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d20:	f3 0f 1e fb          	endbr32 
80104d24:	55                   	push   %ebp
80104d25:	89 e5                	mov    %esp,%ebp
80104d27:	56                   	push   %esi
80104d28:	8b 75 10             	mov    0x10(%ebp),%esi
80104d2b:	8b 55 08             	mov    0x8(%ebp),%edx
80104d2e:	53                   	push   %ebx
80104d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d32:	85 f6                	test   %esi,%esi
80104d34:	74 2a                	je     80104d60 <memcmp+0x40>
80104d36:	01 c6                	add    %eax,%esi
80104d38:	eb 10                	jmp    80104d4a <memcmp+0x2a>
80104d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104d40:	83 c0 01             	add    $0x1,%eax
80104d43:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104d46:	39 f0                	cmp    %esi,%eax
80104d48:	74 16                	je     80104d60 <memcmp+0x40>
    if(*s1 != *s2)
80104d4a:	0f b6 0a             	movzbl (%edx),%ecx
80104d4d:	0f b6 18             	movzbl (%eax),%ebx
80104d50:	38 d9                	cmp    %bl,%cl
80104d52:	74 ec                	je     80104d40 <memcmp+0x20>
      return *s1 - *s2;
80104d54:	0f b6 c1             	movzbl %cl,%eax
80104d57:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104d59:	5b                   	pop    %ebx
80104d5a:	5e                   	pop    %esi
80104d5b:	5d                   	pop    %ebp
80104d5c:	c3                   	ret    
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi
80104d60:	5b                   	pop    %ebx
  return 0;
80104d61:	31 c0                	xor    %eax,%eax
}
80104d63:	5e                   	pop    %esi
80104d64:	5d                   	pop    %ebp
80104d65:	c3                   	ret    
80104d66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6d:	8d 76 00             	lea    0x0(%esi),%esi

80104d70 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d70:	f3 0f 1e fb          	endbr32 
80104d74:	55                   	push   %ebp
80104d75:	89 e5                	mov    %esp,%ebp
80104d77:	57                   	push   %edi
80104d78:	8b 55 08             	mov    0x8(%ebp),%edx
80104d7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d7e:	56                   	push   %esi
80104d7f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d82:	39 d6                	cmp    %edx,%esi
80104d84:	73 2a                	jae    80104db0 <memmove+0x40>
80104d86:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104d89:	39 fa                	cmp    %edi,%edx
80104d8b:	73 23                	jae    80104db0 <memmove+0x40>
80104d8d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104d90:	85 c9                	test   %ecx,%ecx
80104d92:	74 13                	je     80104da7 <memmove+0x37>
80104d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104d98:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104d9c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104d9f:	83 e8 01             	sub    $0x1,%eax
80104da2:	83 f8 ff             	cmp    $0xffffffff,%eax
80104da5:	75 f1                	jne    80104d98 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104da7:	5e                   	pop    %esi
80104da8:	89 d0                	mov    %edx,%eax
80104daa:	5f                   	pop    %edi
80104dab:	5d                   	pop    %ebp
80104dac:	c3                   	ret    
80104dad:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104db0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104db3:	89 d7                	mov    %edx,%edi
80104db5:	85 c9                	test   %ecx,%ecx
80104db7:	74 ee                	je     80104da7 <memmove+0x37>
80104db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104dc0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104dc1:	39 f0                	cmp    %esi,%eax
80104dc3:	75 fb                	jne    80104dc0 <memmove+0x50>
}
80104dc5:	5e                   	pop    %esi
80104dc6:	89 d0                	mov    %edx,%eax
80104dc8:	5f                   	pop    %edi
80104dc9:	5d                   	pop    %ebp
80104dca:	c3                   	ret    
80104dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dcf:	90                   	nop

80104dd0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104dd0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104dd4:	eb 9a                	jmp    80104d70 <memmove>
80104dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ddd:	8d 76 00             	lea    0x0(%esi),%esi

80104de0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104de0:	f3 0f 1e fb          	endbr32 
80104de4:	55                   	push   %ebp
80104de5:	89 e5                	mov    %esp,%ebp
80104de7:	56                   	push   %esi
80104de8:	8b 75 10             	mov    0x10(%ebp),%esi
80104deb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dee:	53                   	push   %ebx
80104def:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104df2:	85 f6                	test   %esi,%esi
80104df4:	74 32                	je     80104e28 <strncmp+0x48>
80104df6:	01 c6                	add    %eax,%esi
80104df8:	eb 14                	jmp    80104e0e <strncmp+0x2e>
80104dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e00:	38 da                	cmp    %bl,%dl
80104e02:	75 14                	jne    80104e18 <strncmp+0x38>
    n--, p++, q++;
80104e04:	83 c0 01             	add    $0x1,%eax
80104e07:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e0a:	39 f0                	cmp    %esi,%eax
80104e0c:	74 1a                	je     80104e28 <strncmp+0x48>
80104e0e:	0f b6 11             	movzbl (%ecx),%edx
80104e11:	0f b6 18             	movzbl (%eax),%ebx
80104e14:	84 d2                	test   %dl,%dl
80104e16:	75 e8                	jne    80104e00 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104e18:	0f b6 c2             	movzbl %dl,%eax
80104e1b:	29 d8                	sub    %ebx,%eax
}
80104e1d:	5b                   	pop    %ebx
80104e1e:	5e                   	pop    %esi
80104e1f:	5d                   	pop    %ebp
80104e20:	c3                   	ret    
80104e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e28:	5b                   	pop    %ebx
    return 0;
80104e29:	31 c0                	xor    %eax,%eax
}
80104e2b:	5e                   	pop    %esi
80104e2c:	5d                   	pop    %ebp
80104e2d:	c3                   	ret    
80104e2e:	66 90                	xchg   %ax,%ax

80104e30 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e30:	f3 0f 1e fb          	endbr32 
80104e34:	55                   	push   %ebp
80104e35:	89 e5                	mov    %esp,%ebp
80104e37:	57                   	push   %edi
80104e38:	56                   	push   %esi
80104e39:	8b 75 08             	mov    0x8(%ebp),%esi
80104e3c:	53                   	push   %ebx
80104e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e40:	89 f2                	mov    %esi,%edx
80104e42:	eb 1b                	jmp    80104e5f <strncpy+0x2f>
80104e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e48:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104e4c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104e4f:	83 c2 01             	add    $0x1,%edx
80104e52:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104e56:	89 f9                	mov    %edi,%ecx
80104e58:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e5b:	84 c9                	test   %cl,%cl
80104e5d:	74 09                	je     80104e68 <strncpy+0x38>
80104e5f:	89 c3                	mov    %eax,%ebx
80104e61:	83 e8 01             	sub    $0x1,%eax
80104e64:	85 db                	test   %ebx,%ebx
80104e66:	7f e0                	jg     80104e48 <strncpy+0x18>
    ;
  while(n-- > 0)
80104e68:	89 d1                	mov    %edx,%ecx
80104e6a:	85 c0                	test   %eax,%eax
80104e6c:	7e 15                	jle    80104e83 <strncpy+0x53>
80104e6e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104e70:	83 c1 01             	add    $0x1,%ecx
80104e73:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104e77:	89 c8                	mov    %ecx,%eax
80104e79:	f7 d0                	not    %eax
80104e7b:	01 d0                	add    %edx,%eax
80104e7d:	01 d8                	add    %ebx,%eax
80104e7f:	85 c0                	test   %eax,%eax
80104e81:	7f ed                	jg     80104e70 <strncpy+0x40>
  return os;
}
80104e83:	5b                   	pop    %ebx
80104e84:	89 f0                	mov    %esi,%eax
80104e86:	5e                   	pop    %esi
80104e87:	5f                   	pop    %edi
80104e88:	5d                   	pop    %ebp
80104e89:	c3                   	ret    
80104e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e90 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104e90:	f3 0f 1e fb          	endbr32 
80104e94:	55                   	push   %ebp
80104e95:	89 e5                	mov    %esp,%ebp
80104e97:	56                   	push   %esi
80104e98:	8b 55 10             	mov    0x10(%ebp),%edx
80104e9b:	8b 75 08             	mov    0x8(%ebp),%esi
80104e9e:	53                   	push   %ebx
80104e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104ea2:	85 d2                	test   %edx,%edx
80104ea4:	7e 21                	jle    80104ec7 <safestrcpy+0x37>
80104ea6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104eaa:	89 f2                	mov    %esi,%edx
80104eac:	eb 12                	jmp    80104ec0 <safestrcpy+0x30>
80104eae:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104eb0:	0f b6 08             	movzbl (%eax),%ecx
80104eb3:	83 c0 01             	add    $0x1,%eax
80104eb6:	83 c2 01             	add    $0x1,%edx
80104eb9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ebc:	84 c9                	test   %cl,%cl
80104ebe:	74 04                	je     80104ec4 <safestrcpy+0x34>
80104ec0:	39 d8                	cmp    %ebx,%eax
80104ec2:	75 ec                	jne    80104eb0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ec4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104ec7:	89 f0                	mov    %esi,%eax
80104ec9:	5b                   	pop    %ebx
80104eca:	5e                   	pop    %esi
80104ecb:	5d                   	pop    %ebp
80104ecc:	c3                   	ret    
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi

80104ed0 <strlen>:

int
strlen(const char *s)
{
80104ed0:	f3 0f 1e fb          	endbr32 
80104ed4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ed5:	31 c0                	xor    %eax,%eax
{
80104ed7:	89 e5                	mov    %esp,%ebp
80104ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104edc:	80 3a 00             	cmpb   $0x0,(%edx)
80104edf:	74 10                	je     80104ef1 <strlen+0x21>
80104ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ee8:	83 c0 01             	add    $0x1,%eax
80104eeb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104eef:	75 f7                	jne    80104ee8 <strlen+0x18>
    ;
  return n;
}
80104ef1:	5d                   	pop    %ebp
80104ef2:	c3                   	ret    

80104ef3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104ef3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104ef7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104efb:	55                   	push   %ebp
  pushl %ebx
80104efc:	53                   	push   %ebx
  pushl %esi
80104efd:	56                   	push   %esi
  pushl %edi
80104efe:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104eff:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f01:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f03:	5f                   	pop    %edi
  popl %esi
80104f04:	5e                   	pop    %esi
  popl %ebx
80104f05:	5b                   	pop    %ebx
  popl %ebp
80104f06:	5d                   	pop    %ebp
  ret
80104f07:	c3                   	ret    
80104f08:	66 90                	xchg   %ax,%ax
80104f0a:	66 90                	xchg   %ax,%ax
80104f0c:	66 90                	xchg   %ax,%ax
80104f0e:	66 90                	xchg   %ax,%ax

80104f10 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f10:	f3 0f 1e fb          	endbr32 
80104f14:	55                   	push   %ebp
80104f15:	89 e5                	mov    %esp,%ebp
80104f17:	53                   	push   %ebx
80104f18:	83 ec 04             	sub    $0x4,%esp
80104f1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f1e:	e8 9d f0 ff ff       	call   80103fc0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f23:	8b 00                	mov    (%eax),%eax
80104f25:	39 d8                	cmp    %ebx,%eax
80104f27:	76 17                	jbe    80104f40 <fetchint+0x30>
80104f29:	8d 53 04             	lea    0x4(%ebx),%edx
80104f2c:	39 d0                	cmp    %edx,%eax
80104f2e:	72 10                	jb     80104f40 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f30:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f33:	8b 13                	mov    (%ebx),%edx
80104f35:	89 10                	mov    %edx,(%eax)
  return 0;
80104f37:	31 c0                	xor    %eax,%eax
}
80104f39:	83 c4 04             	add    $0x4,%esp
80104f3c:	5b                   	pop    %ebx
80104f3d:	5d                   	pop    %ebp
80104f3e:	c3                   	ret    
80104f3f:	90                   	nop
    return -1;
80104f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f45:	eb f2                	jmp    80104f39 <fetchint+0x29>
80104f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f4e:	66 90                	xchg   %ax,%ax

80104f50 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f50:	f3 0f 1e fb          	endbr32 
80104f54:	55                   	push   %ebp
80104f55:	89 e5                	mov    %esp,%ebp
80104f57:	53                   	push   %ebx
80104f58:	83 ec 04             	sub    $0x4,%esp
80104f5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f5e:	e8 5d f0 ff ff       	call   80103fc0 <myproc>

  if(addr >= curproc->sz)
80104f63:	39 18                	cmp    %ebx,(%eax)
80104f65:	76 31                	jbe    80104f98 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104f67:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f6a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104f6c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104f6e:	39 d3                	cmp    %edx,%ebx
80104f70:	73 26                	jae    80104f98 <fetchstr+0x48>
80104f72:	89 d8                	mov    %ebx,%eax
80104f74:	eb 11                	jmp    80104f87 <fetchstr+0x37>
80104f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f7d:	8d 76 00             	lea    0x0(%esi),%esi
80104f80:	83 c0 01             	add    $0x1,%eax
80104f83:	39 c2                	cmp    %eax,%edx
80104f85:	76 11                	jbe    80104f98 <fetchstr+0x48>
    if(*s == 0)
80104f87:	80 38 00             	cmpb   $0x0,(%eax)
80104f8a:	75 f4                	jne    80104f80 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104f8c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104f8f:	29 d8                	sub    %ebx,%eax
}
80104f91:	5b                   	pop    %ebx
80104f92:	5d                   	pop    %ebp
80104f93:	c3                   	ret    
80104f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f98:	83 c4 04             	add    $0x4,%esp
    return -1;
80104f9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fa0:	5b                   	pop    %ebx
80104fa1:	5d                   	pop    %ebp
80104fa2:	c3                   	ret    
80104fa3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fb0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104fb0:	f3 0f 1e fb          	endbr32 
80104fb4:	55                   	push   %ebp
80104fb5:	89 e5                	mov    %esp,%ebp
80104fb7:	56                   	push   %esi
80104fb8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fb9:	e8 02 f0 ff ff       	call   80103fc0 <myproc>
80104fbe:	8b 55 08             	mov    0x8(%ebp),%edx
80104fc1:	8b 40 18             	mov    0x18(%eax),%eax
80104fc4:	8b 40 44             	mov    0x44(%eax),%eax
80104fc7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104fca:	e8 f1 ef ff ff       	call   80103fc0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fcf:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fd2:	8b 00                	mov    (%eax),%eax
80104fd4:	39 c6                	cmp    %eax,%esi
80104fd6:	73 18                	jae    80104ff0 <argint+0x40>
80104fd8:	8d 53 08             	lea    0x8(%ebx),%edx
80104fdb:	39 d0                	cmp    %edx,%eax
80104fdd:	72 11                	jb     80104ff0 <argint+0x40>
  *ip = *(int*)(addr);
80104fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fe2:	8b 53 04             	mov    0x4(%ebx),%edx
80104fe5:	89 10                	mov    %edx,(%eax)
  return 0;
80104fe7:	31 c0                	xor    %eax,%eax
}
80104fe9:	5b                   	pop    %ebx
80104fea:	5e                   	pop    %esi
80104feb:	5d                   	pop    %ebp
80104fec:	c3                   	ret    
80104fed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ff5:	eb f2                	jmp    80104fe9 <argint+0x39>
80104ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffe:	66 90                	xchg   %ax,%ax

80105000 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105000:	f3 0f 1e fb          	endbr32 
80105004:	55                   	push   %ebp
80105005:	89 e5                	mov    %esp,%ebp
80105007:	56                   	push   %esi
80105008:	53                   	push   %ebx
80105009:	83 ec 10             	sub    $0x10,%esp
8010500c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010500f:	e8 ac ef ff ff       	call   80103fc0 <myproc>
 
  if(argint(n, &i) < 0)
80105014:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105017:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105019:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010501c:	50                   	push   %eax
8010501d:	ff 75 08             	pushl  0x8(%ebp)
80105020:	e8 8b ff ff ff       	call   80104fb0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105025:	83 c4 10             	add    $0x10,%esp
80105028:	85 c0                	test   %eax,%eax
8010502a:	78 24                	js     80105050 <argptr+0x50>
8010502c:	85 db                	test   %ebx,%ebx
8010502e:	78 20                	js     80105050 <argptr+0x50>
80105030:	8b 16                	mov    (%esi),%edx
80105032:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105035:	39 c2                	cmp    %eax,%edx
80105037:	76 17                	jbe    80105050 <argptr+0x50>
80105039:	01 c3                	add    %eax,%ebx
8010503b:	39 da                	cmp    %ebx,%edx
8010503d:	72 11                	jb     80105050 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010503f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105042:	89 02                	mov    %eax,(%edx)
  return 0;
80105044:	31 c0                	xor    %eax,%eax
}
80105046:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105049:	5b                   	pop    %ebx
8010504a:	5e                   	pop    %esi
8010504b:	5d                   	pop    %ebp
8010504c:	c3                   	ret    
8010504d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105055:	eb ef                	jmp    80105046 <argptr+0x46>
80105057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010505e:	66 90                	xchg   %ax,%ax

80105060 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105060:	f3 0f 1e fb          	endbr32 
80105064:	55                   	push   %ebp
80105065:	89 e5                	mov    %esp,%ebp
80105067:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010506a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010506d:	50                   	push   %eax
8010506e:	ff 75 08             	pushl  0x8(%ebp)
80105071:	e8 3a ff ff ff       	call   80104fb0 <argint>
80105076:	83 c4 10             	add    $0x10,%esp
80105079:	85 c0                	test   %eax,%eax
8010507b:	78 13                	js     80105090 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010507d:	83 ec 08             	sub    $0x8,%esp
80105080:	ff 75 0c             	pushl  0xc(%ebp)
80105083:	ff 75 f4             	pushl  -0xc(%ebp)
80105086:	e8 c5 fe ff ff       	call   80104f50 <fetchstr>
8010508b:	83 c4 10             	add    $0x10,%esp
}
8010508e:	c9                   	leave  
8010508f:	c3                   	ret    
80105090:	c9                   	leave  
    return -1;
80105091:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105096:	c3                   	ret    
80105097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509e:	66 90                	xchg   %ax,%ax

801050a0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801050a0:	f3 0f 1e fb          	endbr32 
801050a4:	55                   	push   %ebp
801050a5:	89 e5                	mov    %esp,%ebp
801050a7:	53                   	push   %ebx
801050a8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801050ab:	e8 10 ef ff ff       	call   80103fc0 <myproc>
801050b0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801050b2:	8b 40 18             	mov    0x18(%eax),%eax
801050b5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801050b8:	8d 50 ff             	lea    -0x1(%eax),%edx
801050bb:	83 fa 14             	cmp    $0x14,%edx
801050be:	77 20                	ja     801050e0 <syscall+0x40>
801050c0:	8b 14 85 20 7e 10 80 	mov    -0x7fef81e0(,%eax,4),%edx
801050c7:	85 d2                	test   %edx,%edx
801050c9:	74 15                	je     801050e0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801050cb:	ff d2                	call   *%edx
801050cd:	89 c2                	mov    %eax,%edx
801050cf:	8b 43 18             	mov    0x18(%ebx),%eax
801050d2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801050d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050d8:	c9                   	leave  
801050d9:	c3                   	ret    
801050da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801050e0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801050e1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801050e4:	50                   	push   %eax
801050e5:	ff 73 10             	pushl  0x10(%ebx)
801050e8:	68 fd 7d 10 80       	push   $0x80107dfd
801050ed:	e8 8e b6 ff ff       	call   80100780 <cprintf>
    curproc->tf->eax = -1;
801050f2:	8b 43 18             	mov    0x18(%ebx),%eax
801050f5:	83 c4 10             	add    $0x10,%esp
801050f8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801050ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105102:	c9                   	leave  
80105103:	c3                   	ret    
80105104:	66 90                	xchg   %ax,%ax
80105106:	66 90                	xchg   %ax,%ax
80105108:	66 90                	xchg   %ax,%ax
8010510a:	66 90                	xchg   %ax,%ax
8010510c:	66 90                	xchg   %ax,%ax
8010510e:	66 90                	xchg   %ax,%ax

80105110 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	57                   	push   %edi
80105114:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105115:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105118:	53                   	push   %ebx
80105119:	83 ec 34             	sub    $0x34,%esp
8010511c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010511f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105122:	57                   	push   %edi
80105123:	50                   	push   %eax
{
80105124:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105127:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010512a:	e8 81 d5 ff ff       	call   801026b0 <nameiparent>
8010512f:	83 c4 10             	add    $0x10,%esp
80105132:	85 c0                	test   %eax,%eax
80105134:	0f 84 46 01 00 00    	je     80105280 <create+0x170>
    return 0;
  ilock(dp);
8010513a:	83 ec 0c             	sub    $0xc,%esp
8010513d:	89 c3                	mov    %eax,%ebx
8010513f:	50                   	push   %eax
80105140:	e8 7b cc ff ff       	call   80101dc0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105145:	83 c4 0c             	add    $0xc,%esp
80105148:	6a 00                	push   $0x0
8010514a:	57                   	push   %edi
8010514b:	53                   	push   %ebx
8010514c:	e8 bf d1 ff ff       	call   80102310 <dirlookup>
80105151:	83 c4 10             	add    $0x10,%esp
80105154:	89 c6                	mov    %eax,%esi
80105156:	85 c0                	test   %eax,%eax
80105158:	74 56                	je     801051b0 <create+0xa0>
    iunlockput(dp);
8010515a:	83 ec 0c             	sub    $0xc,%esp
8010515d:	53                   	push   %ebx
8010515e:	e8 fd ce ff ff       	call   80102060 <iunlockput>
    ilock(ip);
80105163:	89 34 24             	mov    %esi,(%esp)
80105166:	e8 55 cc ff ff       	call   80101dc0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010516b:	83 c4 10             	add    $0x10,%esp
8010516e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105173:	75 1b                	jne    80105190 <create+0x80>
80105175:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010517a:	75 14                	jne    80105190 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010517c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010517f:	89 f0                	mov    %esi,%eax
80105181:	5b                   	pop    %ebx
80105182:	5e                   	pop    %esi
80105183:	5f                   	pop    %edi
80105184:	5d                   	pop    %ebp
80105185:	c3                   	ret    
80105186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010518d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105190:	83 ec 0c             	sub    $0xc,%esp
80105193:	56                   	push   %esi
    return 0;
80105194:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105196:	e8 c5 ce ff ff       	call   80102060 <iunlockput>
    return 0;
8010519b:	83 c4 10             	add    $0x10,%esp
}
8010519e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051a1:	89 f0                	mov    %esi,%eax
801051a3:	5b                   	pop    %ebx
801051a4:	5e                   	pop    %esi
801051a5:	5f                   	pop    %edi
801051a6:	5d                   	pop    %ebp
801051a7:	c3                   	ret    
801051a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051af:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801051b0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801051b4:	83 ec 08             	sub    $0x8,%esp
801051b7:	50                   	push   %eax
801051b8:	ff 33                	pushl  (%ebx)
801051ba:	e8 81 ca ff ff       	call   80101c40 <ialloc>
801051bf:	83 c4 10             	add    $0x10,%esp
801051c2:	89 c6                	mov    %eax,%esi
801051c4:	85 c0                	test   %eax,%eax
801051c6:	0f 84 cd 00 00 00    	je     80105299 <create+0x189>
  ilock(ip);
801051cc:	83 ec 0c             	sub    $0xc,%esp
801051cf:	50                   	push   %eax
801051d0:	e8 eb cb ff ff       	call   80101dc0 <ilock>
  ip->major = major;
801051d5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801051d9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801051dd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801051e1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801051e5:	b8 01 00 00 00       	mov    $0x1,%eax
801051ea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801051ee:	89 34 24             	mov    %esi,(%esp)
801051f1:	e8 0a cb ff ff       	call   80101d00 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801051f6:	83 c4 10             	add    $0x10,%esp
801051f9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801051fe:	74 30                	je     80105230 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105200:	83 ec 04             	sub    $0x4,%esp
80105203:	ff 76 04             	pushl  0x4(%esi)
80105206:	57                   	push   %edi
80105207:	53                   	push   %ebx
80105208:	e8 c3 d3 ff ff       	call   801025d0 <dirlink>
8010520d:	83 c4 10             	add    $0x10,%esp
80105210:	85 c0                	test   %eax,%eax
80105212:	78 78                	js     8010528c <create+0x17c>
  iunlockput(dp);
80105214:	83 ec 0c             	sub    $0xc,%esp
80105217:	53                   	push   %ebx
80105218:	e8 43 ce ff ff       	call   80102060 <iunlockput>
  return ip;
8010521d:	83 c4 10             	add    $0x10,%esp
}
80105220:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105223:	89 f0                	mov    %esi,%eax
80105225:	5b                   	pop    %ebx
80105226:	5e                   	pop    %esi
80105227:	5f                   	pop    %edi
80105228:	5d                   	pop    %ebp
80105229:	c3                   	ret    
8010522a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105230:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105233:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105238:	53                   	push   %ebx
80105239:	e8 c2 ca ff ff       	call   80101d00 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010523e:	83 c4 0c             	add    $0xc,%esp
80105241:	ff 76 04             	pushl  0x4(%esi)
80105244:	68 94 7e 10 80       	push   $0x80107e94
80105249:	56                   	push   %esi
8010524a:	e8 81 d3 ff ff       	call   801025d0 <dirlink>
8010524f:	83 c4 10             	add    $0x10,%esp
80105252:	85 c0                	test   %eax,%eax
80105254:	78 18                	js     8010526e <create+0x15e>
80105256:	83 ec 04             	sub    $0x4,%esp
80105259:	ff 73 04             	pushl  0x4(%ebx)
8010525c:	68 93 7e 10 80       	push   $0x80107e93
80105261:	56                   	push   %esi
80105262:	e8 69 d3 ff ff       	call   801025d0 <dirlink>
80105267:	83 c4 10             	add    $0x10,%esp
8010526a:	85 c0                	test   %eax,%eax
8010526c:	79 92                	jns    80105200 <create+0xf0>
      panic("create dots");
8010526e:	83 ec 0c             	sub    $0xc,%esp
80105271:	68 87 7e 10 80       	push   $0x80107e87
80105276:	e8 85 b4 ff ff       	call   80100700 <panic>
8010527b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010527f:	90                   	nop
}
80105280:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105283:	31 f6                	xor    %esi,%esi
}
80105285:	5b                   	pop    %ebx
80105286:	89 f0                	mov    %esi,%eax
80105288:	5e                   	pop    %esi
80105289:	5f                   	pop    %edi
8010528a:	5d                   	pop    %ebp
8010528b:	c3                   	ret    
    panic("create: dirlink");
8010528c:	83 ec 0c             	sub    $0xc,%esp
8010528f:	68 96 7e 10 80       	push   $0x80107e96
80105294:	e8 67 b4 ff ff       	call   80100700 <panic>
    panic("create: ialloc");
80105299:	83 ec 0c             	sub    $0xc,%esp
8010529c:	68 78 7e 10 80       	push   $0x80107e78
801052a1:	e8 5a b4 ff ff       	call   80100700 <panic>
801052a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ad:	8d 76 00             	lea    0x0(%esi),%esi

801052b0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	56                   	push   %esi
801052b4:	89 d6                	mov    %edx,%esi
801052b6:	53                   	push   %ebx
801052b7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801052b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801052bc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052bf:	50                   	push   %eax
801052c0:	6a 00                	push   $0x0
801052c2:	e8 e9 fc ff ff       	call   80104fb0 <argint>
801052c7:	83 c4 10             	add    $0x10,%esp
801052ca:	85 c0                	test   %eax,%eax
801052cc:	78 2a                	js     801052f8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052ce:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052d2:	77 24                	ja     801052f8 <argfd.constprop.0+0x48>
801052d4:	e8 e7 ec ff ff       	call   80103fc0 <myproc>
801052d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052dc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801052e0:	85 c0                	test   %eax,%eax
801052e2:	74 14                	je     801052f8 <argfd.constprop.0+0x48>
  if(pfd)
801052e4:	85 db                	test   %ebx,%ebx
801052e6:	74 02                	je     801052ea <argfd.constprop.0+0x3a>
    *pfd = fd;
801052e8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801052ea:	89 06                	mov    %eax,(%esi)
  return 0;
801052ec:	31 c0                	xor    %eax,%eax
}
801052ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052f1:	5b                   	pop    %ebx
801052f2:	5e                   	pop    %esi
801052f3:	5d                   	pop    %ebp
801052f4:	c3                   	ret    
801052f5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052fd:	eb ef                	jmp    801052ee <argfd.constprop.0+0x3e>
801052ff:	90                   	nop

80105300 <sys_dup>:
{
80105300:	f3 0f 1e fb          	endbr32 
80105304:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105305:	31 c0                	xor    %eax,%eax
{
80105307:	89 e5                	mov    %esp,%ebp
80105309:	56                   	push   %esi
8010530a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010530b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010530e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105311:	e8 9a ff ff ff       	call   801052b0 <argfd.constprop.0>
80105316:	85 c0                	test   %eax,%eax
80105318:	78 1e                	js     80105338 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010531a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010531d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010531f:	e8 9c ec ff ff       	call   80103fc0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105328:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010532c:	85 d2                	test   %edx,%edx
8010532e:	74 20                	je     80105350 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105330:	83 c3 01             	add    $0x1,%ebx
80105333:	83 fb 10             	cmp    $0x10,%ebx
80105336:	75 f0                	jne    80105328 <sys_dup+0x28>
}
80105338:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010533b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105340:	89 d8                	mov    %ebx,%eax
80105342:	5b                   	pop    %ebx
80105343:	5e                   	pop    %esi
80105344:	5d                   	pop    %ebp
80105345:	c3                   	ret    
80105346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010534d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105350:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105354:	83 ec 0c             	sub    $0xc,%esp
80105357:	ff 75 f4             	pushl  -0xc(%ebp)
8010535a:	e8 71 c1 ff ff       	call   801014d0 <filedup>
  return fd;
8010535f:	83 c4 10             	add    $0x10,%esp
}
80105362:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105365:	89 d8                	mov    %ebx,%eax
80105367:	5b                   	pop    %ebx
80105368:	5e                   	pop    %esi
80105369:	5d                   	pop    %ebp
8010536a:	c3                   	ret    
8010536b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010536f:	90                   	nop

80105370 <sys_read>:
{
80105370:	f3 0f 1e fb          	endbr32 
80105374:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105375:	31 c0                	xor    %eax,%eax
{
80105377:	89 e5                	mov    %esp,%ebp
80105379:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010537c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010537f:	e8 2c ff ff ff       	call   801052b0 <argfd.constprop.0>
80105384:	85 c0                	test   %eax,%eax
80105386:	78 48                	js     801053d0 <sys_read+0x60>
80105388:	83 ec 08             	sub    $0x8,%esp
8010538b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010538e:	50                   	push   %eax
8010538f:	6a 02                	push   $0x2
80105391:	e8 1a fc ff ff       	call   80104fb0 <argint>
80105396:	83 c4 10             	add    $0x10,%esp
80105399:	85 c0                	test   %eax,%eax
8010539b:	78 33                	js     801053d0 <sys_read+0x60>
8010539d:	83 ec 04             	sub    $0x4,%esp
801053a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053a3:	ff 75 f0             	pushl  -0x10(%ebp)
801053a6:	50                   	push   %eax
801053a7:	6a 01                	push   $0x1
801053a9:	e8 52 fc ff ff       	call   80105000 <argptr>
801053ae:	83 c4 10             	add    $0x10,%esp
801053b1:	85 c0                	test   %eax,%eax
801053b3:	78 1b                	js     801053d0 <sys_read+0x60>
  return fileread(f, p, n);
801053b5:	83 ec 04             	sub    $0x4,%esp
801053b8:	ff 75 f0             	pushl  -0x10(%ebp)
801053bb:	ff 75 f4             	pushl  -0xc(%ebp)
801053be:	ff 75 ec             	pushl  -0x14(%ebp)
801053c1:	e8 8a c2 ff ff       	call   80101650 <fileread>
801053c6:	83 c4 10             	add    $0x10,%esp
}
801053c9:	c9                   	leave  
801053ca:	c3                   	ret    
801053cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053cf:	90                   	nop
801053d0:	c9                   	leave  
    return -1;
801053d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053d6:	c3                   	ret    
801053d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053de:	66 90                	xchg   %ax,%ax

801053e0 <sys_write>:
{
801053e0:	f3 0f 1e fb          	endbr32 
801053e4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053e5:	31 c0                	xor    %eax,%eax
{
801053e7:	89 e5                	mov    %esp,%ebp
801053e9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053ec:	8d 55 ec             	lea    -0x14(%ebp),%edx
801053ef:	e8 bc fe ff ff       	call   801052b0 <argfd.constprop.0>
801053f4:	85 c0                	test   %eax,%eax
801053f6:	78 48                	js     80105440 <sys_write+0x60>
801053f8:	83 ec 08             	sub    $0x8,%esp
801053fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053fe:	50                   	push   %eax
801053ff:	6a 02                	push   $0x2
80105401:	e8 aa fb ff ff       	call   80104fb0 <argint>
80105406:	83 c4 10             	add    $0x10,%esp
80105409:	85 c0                	test   %eax,%eax
8010540b:	78 33                	js     80105440 <sys_write+0x60>
8010540d:	83 ec 04             	sub    $0x4,%esp
80105410:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105413:	ff 75 f0             	pushl  -0x10(%ebp)
80105416:	50                   	push   %eax
80105417:	6a 01                	push   $0x1
80105419:	e8 e2 fb ff ff       	call   80105000 <argptr>
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	85 c0                	test   %eax,%eax
80105423:	78 1b                	js     80105440 <sys_write+0x60>
  return filewrite(f, p, n);
80105425:	83 ec 04             	sub    $0x4,%esp
80105428:	ff 75 f0             	pushl  -0x10(%ebp)
8010542b:	ff 75 f4             	pushl  -0xc(%ebp)
8010542e:	ff 75 ec             	pushl  -0x14(%ebp)
80105431:	e8 ba c2 ff ff       	call   801016f0 <filewrite>
80105436:	83 c4 10             	add    $0x10,%esp
}
80105439:	c9                   	leave  
8010543a:	c3                   	ret    
8010543b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010543f:	90                   	nop
80105440:	c9                   	leave  
    return -1;
80105441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105446:	c3                   	ret    
80105447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010544e:	66 90                	xchg   %ax,%ax

80105450 <sys_close>:
{
80105450:	f3 0f 1e fb          	endbr32 
80105454:	55                   	push   %ebp
80105455:	89 e5                	mov    %esp,%ebp
80105457:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010545a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010545d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105460:	e8 4b fe ff ff       	call   801052b0 <argfd.constprop.0>
80105465:	85 c0                	test   %eax,%eax
80105467:	78 27                	js     80105490 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105469:	e8 52 eb ff ff       	call   80103fc0 <myproc>
8010546e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105471:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105474:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010547b:	00 
  fileclose(f);
8010547c:	ff 75 f4             	pushl  -0xc(%ebp)
8010547f:	e8 9c c0 ff ff       	call   80101520 <fileclose>
  return 0;
80105484:	83 c4 10             	add    $0x10,%esp
80105487:	31 c0                	xor    %eax,%eax
}
80105489:	c9                   	leave  
8010548a:	c3                   	ret    
8010548b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010548f:	90                   	nop
80105490:	c9                   	leave  
    return -1;
80105491:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105496:	c3                   	ret    
80105497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010549e:	66 90                	xchg   %ax,%ax

801054a0 <sys_fstat>:
{
801054a0:	f3 0f 1e fb          	endbr32 
801054a4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054a5:	31 c0                	xor    %eax,%eax
{
801054a7:	89 e5                	mov    %esp,%ebp
801054a9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054ac:	8d 55 f0             	lea    -0x10(%ebp),%edx
801054af:	e8 fc fd ff ff       	call   801052b0 <argfd.constprop.0>
801054b4:	85 c0                	test   %eax,%eax
801054b6:	78 30                	js     801054e8 <sys_fstat+0x48>
801054b8:	83 ec 04             	sub    $0x4,%esp
801054bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054be:	6a 14                	push   $0x14
801054c0:	50                   	push   %eax
801054c1:	6a 01                	push   $0x1
801054c3:	e8 38 fb ff ff       	call   80105000 <argptr>
801054c8:	83 c4 10             	add    $0x10,%esp
801054cb:	85 c0                	test   %eax,%eax
801054cd:	78 19                	js     801054e8 <sys_fstat+0x48>
  return filestat(f, st);
801054cf:	83 ec 08             	sub    $0x8,%esp
801054d2:	ff 75 f4             	pushl  -0xc(%ebp)
801054d5:	ff 75 f0             	pushl  -0x10(%ebp)
801054d8:	e8 23 c1 ff ff       	call   80101600 <filestat>
801054dd:	83 c4 10             	add    $0x10,%esp
}
801054e0:	c9                   	leave  
801054e1:	c3                   	ret    
801054e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054e8:	c9                   	leave  
    return -1;
801054e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054ee:	c3                   	ret    
801054ef:	90                   	nop

801054f0 <sys_link>:
{
801054f0:	f3 0f 1e fb          	endbr32 
801054f4:	55                   	push   %ebp
801054f5:	89 e5                	mov    %esp,%ebp
801054f7:	57                   	push   %edi
801054f8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801054f9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801054fc:	53                   	push   %ebx
801054fd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105500:	50                   	push   %eax
80105501:	6a 00                	push   $0x0
80105503:	e8 58 fb ff ff       	call   80105060 <argstr>
80105508:	83 c4 10             	add    $0x10,%esp
8010550b:	85 c0                	test   %eax,%eax
8010550d:	0f 88 ff 00 00 00    	js     80105612 <sys_link+0x122>
80105513:	83 ec 08             	sub    $0x8,%esp
80105516:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105519:	50                   	push   %eax
8010551a:	6a 01                	push   $0x1
8010551c:	e8 3f fb ff ff       	call   80105060 <argstr>
80105521:	83 c4 10             	add    $0x10,%esp
80105524:	85 c0                	test   %eax,%eax
80105526:	0f 88 e6 00 00 00    	js     80105612 <sys_link+0x122>
  begin_op();
8010552c:	e8 5f de ff ff       	call   80103390 <begin_op>
  if((ip = namei(old)) == 0){
80105531:	83 ec 0c             	sub    $0xc,%esp
80105534:	ff 75 d4             	pushl  -0x2c(%ebp)
80105537:	e8 54 d1 ff ff       	call   80102690 <namei>
8010553c:	83 c4 10             	add    $0x10,%esp
8010553f:	89 c3                	mov    %eax,%ebx
80105541:	85 c0                	test   %eax,%eax
80105543:	0f 84 e8 00 00 00    	je     80105631 <sys_link+0x141>
  ilock(ip);
80105549:	83 ec 0c             	sub    $0xc,%esp
8010554c:	50                   	push   %eax
8010554d:	e8 6e c8 ff ff       	call   80101dc0 <ilock>
  if(ip->type == T_DIR){
80105552:	83 c4 10             	add    $0x10,%esp
80105555:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010555a:	0f 84 b9 00 00 00    	je     80105619 <sys_link+0x129>
  iupdate(ip);
80105560:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105563:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105568:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010556b:	53                   	push   %ebx
8010556c:	e8 8f c7 ff ff       	call   80101d00 <iupdate>
  iunlock(ip);
80105571:	89 1c 24             	mov    %ebx,(%esp)
80105574:	e8 27 c9 ff ff       	call   80101ea0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105579:	58                   	pop    %eax
8010557a:	5a                   	pop    %edx
8010557b:	57                   	push   %edi
8010557c:	ff 75 d0             	pushl  -0x30(%ebp)
8010557f:	e8 2c d1 ff ff       	call   801026b0 <nameiparent>
80105584:	83 c4 10             	add    $0x10,%esp
80105587:	89 c6                	mov    %eax,%esi
80105589:	85 c0                	test   %eax,%eax
8010558b:	74 5f                	je     801055ec <sys_link+0xfc>
  ilock(dp);
8010558d:	83 ec 0c             	sub    $0xc,%esp
80105590:	50                   	push   %eax
80105591:	e8 2a c8 ff ff       	call   80101dc0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105596:	8b 03                	mov    (%ebx),%eax
80105598:	83 c4 10             	add    $0x10,%esp
8010559b:	39 06                	cmp    %eax,(%esi)
8010559d:	75 41                	jne    801055e0 <sys_link+0xf0>
8010559f:	83 ec 04             	sub    $0x4,%esp
801055a2:	ff 73 04             	pushl  0x4(%ebx)
801055a5:	57                   	push   %edi
801055a6:	56                   	push   %esi
801055a7:	e8 24 d0 ff ff       	call   801025d0 <dirlink>
801055ac:	83 c4 10             	add    $0x10,%esp
801055af:	85 c0                	test   %eax,%eax
801055b1:	78 2d                	js     801055e0 <sys_link+0xf0>
  iunlockput(dp);
801055b3:	83 ec 0c             	sub    $0xc,%esp
801055b6:	56                   	push   %esi
801055b7:	e8 a4 ca ff ff       	call   80102060 <iunlockput>
  iput(ip);
801055bc:	89 1c 24             	mov    %ebx,(%esp)
801055bf:	e8 2c c9 ff ff       	call   80101ef0 <iput>
  end_op();
801055c4:	e8 37 de ff ff       	call   80103400 <end_op>
  return 0;
801055c9:	83 c4 10             	add    $0x10,%esp
801055cc:	31 c0                	xor    %eax,%eax
}
801055ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055d1:	5b                   	pop    %ebx
801055d2:	5e                   	pop    %esi
801055d3:	5f                   	pop    %edi
801055d4:	5d                   	pop    %ebp
801055d5:	c3                   	ret    
801055d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055dd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801055e0:	83 ec 0c             	sub    $0xc,%esp
801055e3:	56                   	push   %esi
801055e4:	e8 77 ca ff ff       	call   80102060 <iunlockput>
    goto bad;
801055e9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801055ec:	83 ec 0c             	sub    $0xc,%esp
801055ef:	53                   	push   %ebx
801055f0:	e8 cb c7 ff ff       	call   80101dc0 <ilock>
  ip->nlink--;
801055f5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055fa:	89 1c 24             	mov    %ebx,(%esp)
801055fd:	e8 fe c6 ff ff       	call   80101d00 <iupdate>
  iunlockput(ip);
80105602:	89 1c 24             	mov    %ebx,(%esp)
80105605:	e8 56 ca ff ff       	call   80102060 <iunlockput>
  end_op();
8010560a:	e8 f1 dd ff ff       	call   80103400 <end_op>
  return -1;
8010560f:	83 c4 10             	add    $0x10,%esp
80105612:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105617:	eb b5                	jmp    801055ce <sys_link+0xde>
    iunlockput(ip);
80105619:	83 ec 0c             	sub    $0xc,%esp
8010561c:	53                   	push   %ebx
8010561d:	e8 3e ca ff ff       	call   80102060 <iunlockput>
    end_op();
80105622:	e8 d9 dd ff ff       	call   80103400 <end_op>
    return -1;
80105627:	83 c4 10             	add    $0x10,%esp
8010562a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010562f:	eb 9d                	jmp    801055ce <sys_link+0xde>
    end_op();
80105631:	e8 ca dd ff ff       	call   80103400 <end_op>
    return -1;
80105636:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010563b:	eb 91                	jmp    801055ce <sys_link+0xde>
8010563d:	8d 76 00             	lea    0x0(%esi),%esi

80105640 <sys_unlink>:
{
80105640:	f3 0f 1e fb          	endbr32 
80105644:	55                   	push   %ebp
80105645:	89 e5                	mov    %esp,%ebp
80105647:	57                   	push   %edi
80105648:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105649:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010564c:	53                   	push   %ebx
8010564d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105650:	50                   	push   %eax
80105651:	6a 00                	push   $0x0
80105653:	e8 08 fa ff ff       	call   80105060 <argstr>
80105658:	83 c4 10             	add    $0x10,%esp
8010565b:	85 c0                	test   %eax,%eax
8010565d:	0f 88 7d 01 00 00    	js     801057e0 <sys_unlink+0x1a0>
  begin_op();
80105663:	e8 28 dd ff ff       	call   80103390 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105668:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010566b:	83 ec 08             	sub    $0x8,%esp
8010566e:	53                   	push   %ebx
8010566f:	ff 75 c0             	pushl  -0x40(%ebp)
80105672:	e8 39 d0 ff ff       	call   801026b0 <nameiparent>
80105677:	83 c4 10             	add    $0x10,%esp
8010567a:	89 c6                	mov    %eax,%esi
8010567c:	85 c0                	test   %eax,%eax
8010567e:	0f 84 66 01 00 00    	je     801057ea <sys_unlink+0x1aa>
  ilock(dp);
80105684:	83 ec 0c             	sub    $0xc,%esp
80105687:	50                   	push   %eax
80105688:	e8 33 c7 ff ff       	call   80101dc0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010568d:	58                   	pop    %eax
8010568e:	5a                   	pop    %edx
8010568f:	68 94 7e 10 80       	push   $0x80107e94
80105694:	53                   	push   %ebx
80105695:	e8 56 cc ff ff       	call   801022f0 <namecmp>
8010569a:	83 c4 10             	add    $0x10,%esp
8010569d:	85 c0                	test   %eax,%eax
8010569f:	0f 84 03 01 00 00    	je     801057a8 <sys_unlink+0x168>
801056a5:	83 ec 08             	sub    $0x8,%esp
801056a8:	68 93 7e 10 80       	push   $0x80107e93
801056ad:	53                   	push   %ebx
801056ae:	e8 3d cc ff ff       	call   801022f0 <namecmp>
801056b3:	83 c4 10             	add    $0x10,%esp
801056b6:	85 c0                	test   %eax,%eax
801056b8:	0f 84 ea 00 00 00    	je     801057a8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801056be:	83 ec 04             	sub    $0x4,%esp
801056c1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801056c4:	50                   	push   %eax
801056c5:	53                   	push   %ebx
801056c6:	56                   	push   %esi
801056c7:	e8 44 cc ff ff       	call   80102310 <dirlookup>
801056cc:	83 c4 10             	add    $0x10,%esp
801056cf:	89 c3                	mov    %eax,%ebx
801056d1:	85 c0                	test   %eax,%eax
801056d3:	0f 84 cf 00 00 00    	je     801057a8 <sys_unlink+0x168>
  ilock(ip);
801056d9:	83 ec 0c             	sub    $0xc,%esp
801056dc:	50                   	push   %eax
801056dd:	e8 de c6 ff ff       	call   80101dc0 <ilock>
  if(ip->nlink < 1)
801056e2:	83 c4 10             	add    $0x10,%esp
801056e5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801056ea:	0f 8e 23 01 00 00    	jle    80105813 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801056f0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056f5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801056f8:	74 66                	je     80105760 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801056fa:	83 ec 04             	sub    $0x4,%esp
801056fd:	6a 10                	push   $0x10
801056ff:	6a 00                	push   $0x0
80105701:	57                   	push   %edi
80105702:	e8 c9 f5 ff ff       	call   80104cd0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105707:	6a 10                	push   $0x10
80105709:	ff 75 c4             	pushl  -0x3c(%ebp)
8010570c:	57                   	push   %edi
8010570d:	56                   	push   %esi
8010570e:	e8 ad ca ff ff       	call   801021c0 <writei>
80105713:	83 c4 20             	add    $0x20,%esp
80105716:	83 f8 10             	cmp    $0x10,%eax
80105719:	0f 85 e7 00 00 00    	jne    80105806 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010571f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105724:	0f 84 96 00 00 00    	je     801057c0 <sys_unlink+0x180>
  iunlockput(dp);
8010572a:	83 ec 0c             	sub    $0xc,%esp
8010572d:	56                   	push   %esi
8010572e:	e8 2d c9 ff ff       	call   80102060 <iunlockput>
  ip->nlink--;
80105733:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105738:	89 1c 24             	mov    %ebx,(%esp)
8010573b:	e8 c0 c5 ff ff       	call   80101d00 <iupdate>
  iunlockput(ip);
80105740:	89 1c 24             	mov    %ebx,(%esp)
80105743:	e8 18 c9 ff ff       	call   80102060 <iunlockput>
  end_op();
80105748:	e8 b3 dc ff ff       	call   80103400 <end_op>
  return 0;
8010574d:	83 c4 10             	add    $0x10,%esp
80105750:	31 c0                	xor    %eax,%eax
}
80105752:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105755:	5b                   	pop    %ebx
80105756:	5e                   	pop    %esi
80105757:	5f                   	pop    %edi
80105758:	5d                   	pop    %ebp
80105759:	c3                   	ret    
8010575a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105760:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105764:	76 94                	jbe    801056fa <sys_unlink+0xba>
80105766:	ba 20 00 00 00       	mov    $0x20,%edx
8010576b:	eb 0b                	jmp    80105778 <sys_unlink+0x138>
8010576d:	8d 76 00             	lea    0x0(%esi),%esi
80105770:	83 c2 10             	add    $0x10,%edx
80105773:	39 53 58             	cmp    %edx,0x58(%ebx)
80105776:	76 82                	jbe    801056fa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105778:	6a 10                	push   $0x10
8010577a:	52                   	push   %edx
8010577b:	57                   	push   %edi
8010577c:	53                   	push   %ebx
8010577d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105780:	e8 3b c9 ff ff       	call   801020c0 <readi>
80105785:	83 c4 10             	add    $0x10,%esp
80105788:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010578b:	83 f8 10             	cmp    $0x10,%eax
8010578e:	75 69                	jne    801057f9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105790:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105795:	74 d9                	je     80105770 <sys_unlink+0x130>
    iunlockput(ip);
80105797:	83 ec 0c             	sub    $0xc,%esp
8010579a:	53                   	push   %ebx
8010579b:	e8 c0 c8 ff ff       	call   80102060 <iunlockput>
    goto bad;
801057a0:	83 c4 10             	add    $0x10,%esp
801057a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057a7:	90                   	nop
  iunlockput(dp);
801057a8:	83 ec 0c             	sub    $0xc,%esp
801057ab:	56                   	push   %esi
801057ac:	e8 af c8 ff ff       	call   80102060 <iunlockput>
  end_op();
801057b1:	e8 4a dc ff ff       	call   80103400 <end_op>
  return -1;
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057be:	eb 92                	jmp    80105752 <sys_unlink+0x112>
    iupdate(dp);
801057c0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801057c3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801057c8:	56                   	push   %esi
801057c9:	e8 32 c5 ff ff       	call   80101d00 <iupdate>
801057ce:	83 c4 10             	add    $0x10,%esp
801057d1:	e9 54 ff ff ff       	jmp    8010572a <sys_unlink+0xea>
801057d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e5:	e9 68 ff ff ff       	jmp    80105752 <sys_unlink+0x112>
    end_op();
801057ea:	e8 11 dc ff ff       	call   80103400 <end_op>
    return -1;
801057ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f4:	e9 59 ff ff ff       	jmp    80105752 <sys_unlink+0x112>
      panic("isdirempty: readi");
801057f9:	83 ec 0c             	sub    $0xc,%esp
801057fc:	68 b8 7e 10 80       	push   $0x80107eb8
80105801:	e8 fa ae ff ff       	call   80100700 <panic>
    panic("unlink: writei");
80105806:	83 ec 0c             	sub    $0xc,%esp
80105809:	68 ca 7e 10 80       	push   $0x80107eca
8010580e:	e8 ed ae ff ff       	call   80100700 <panic>
    panic("unlink: nlink < 1");
80105813:	83 ec 0c             	sub    $0xc,%esp
80105816:	68 a6 7e 10 80       	push   $0x80107ea6
8010581b:	e8 e0 ae ff ff       	call   80100700 <panic>

80105820 <sys_open>:

int
sys_open(void)
{
80105820:	f3 0f 1e fb          	endbr32 
80105824:	55                   	push   %ebp
80105825:	89 e5                	mov    %esp,%ebp
80105827:	57                   	push   %edi
80105828:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105829:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010582c:	53                   	push   %ebx
8010582d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105830:	50                   	push   %eax
80105831:	6a 00                	push   $0x0
80105833:	e8 28 f8 ff ff       	call   80105060 <argstr>
80105838:	83 c4 10             	add    $0x10,%esp
8010583b:	85 c0                	test   %eax,%eax
8010583d:	0f 88 8a 00 00 00    	js     801058cd <sys_open+0xad>
80105843:	83 ec 08             	sub    $0x8,%esp
80105846:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105849:	50                   	push   %eax
8010584a:	6a 01                	push   $0x1
8010584c:	e8 5f f7 ff ff       	call   80104fb0 <argint>
80105851:	83 c4 10             	add    $0x10,%esp
80105854:	85 c0                	test   %eax,%eax
80105856:	78 75                	js     801058cd <sys_open+0xad>
    return -1;

  begin_op();
80105858:	e8 33 db ff ff       	call   80103390 <begin_op>

  if(omode & O_CREATE){
8010585d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105861:	75 75                	jne    801058d8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105863:	83 ec 0c             	sub    $0xc,%esp
80105866:	ff 75 e0             	pushl  -0x20(%ebp)
80105869:	e8 22 ce ff ff       	call   80102690 <namei>
8010586e:	83 c4 10             	add    $0x10,%esp
80105871:	89 c6                	mov    %eax,%esi
80105873:	85 c0                	test   %eax,%eax
80105875:	74 7e                	je     801058f5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105877:	83 ec 0c             	sub    $0xc,%esp
8010587a:	50                   	push   %eax
8010587b:	e8 40 c5 ff ff       	call   80101dc0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105880:	83 c4 10             	add    $0x10,%esp
80105883:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105888:	0f 84 c2 00 00 00    	je     80105950 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010588e:	e8 cd bb ff ff       	call   80101460 <filealloc>
80105893:	89 c7                	mov    %eax,%edi
80105895:	85 c0                	test   %eax,%eax
80105897:	74 23                	je     801058bc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105899:	e8 22 e7 ff ff       	call   80103fc0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010589e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801058a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801058a4:	85 d2                	test   %edx,%edx
801058a6:	74 60                	je     80105908 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801058a8:	83 c3 01             	add    $0x1,%ebx
801058ab:	83 fb 10             	cmp    $0x10,%ebx
801058ae:	75 f0                	jne    801058a0 <sys_open+0x80>
    if(f)
      fileclose(f);
801058b0:	83 ec 0c             	sub    $0xc,%esp
801058b3:	57                   	push   %edi
801058b4:	e8 67 bc ff ff       	call   80101520 <fileclose>
801058b9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801058bc:	83 ec 0c             	sub    $0xc,%esp
801058bf:	56                   	push   %esi
801058c0:	e8 9b c7 ff ff       	call   80102060 <iunlockput>
    end_op();
801058c5:	e8 36 db ff ff       	call   80103400 <end_op>
    return -1;
801058ca:	83 c4 10             	add    $0x10,%esp
801058cd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058d2:	eb 6d                	jmp    80105941 <sys_open+0x121>
801058d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801058d8:	83 ec 0c             	sub    $0xc,%esp
801058db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801058de:	31 c9                	xor    %ecx,%ecx
801058e0:	ba 02 00 00 00       	mov    $0x2,%edx
801058e5:	6a 00                	push   $0x0
801058e7:	e8 24 f8 ff ff       	call   80105110 <create>
    if(ip == 0){
801058ec:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801058ef:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801058f1:	85 c0                	test   %eax,%eax
801058f3:	75 99                	jne    8010588e <sys_open+0x6e>
      end_op();
801058f5:	e8 06 db ff ff       	call   80103400 <end_op>
      return -1;
801058fa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058ff:	eb 40                	jmp    80105941 <sys_open+0x121>
80105901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105908:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010590b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010590f:	56                   	push   %esi
80105910:	e8 8b c5 ff ff       	call   80101ea0 <iunlock>
  end_op();
80105915:	e8 e6 da ff ff       	call   80103400 <end_op>

  f->type = FD_INODE;
8010591a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105920:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105923:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105926:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105929:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010592b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105932:	f7 d0                	not    %eax
80105934:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105937:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010593a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010593d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105941:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105944:	89 d8                	mov    %ebx,%eax
80105946:	5b                   	pop    %ebx
80105947:	5e                   	pop    %esi
80105948:	5f                   	pop    %edi
80105949:	5d                   	pop    %ebp
8010594a:	c3                   	ret    
8010594b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010594f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105950:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105953:	85 c9                	test   %ecx,%ecx
80105955:	0f 84 33 ff ff ff    	je     8010588e <sys_open+0x6e>
8010595b:	e9 5c ff ff ff       	jmp    801058bc <sys_open+0x9c>

80105960 <sys_mkdir>:

int
sys_mkdir(void)
{
80105960:	f3 0f 1e fb          	endbr32 
80105964:	55                   	push   %ebp
80105965:	89 e5                	mov    %esp,%ebp
80105967:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010596a:	e8 21 da ff ff       	call   80103390 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010596f:	83 ec 08             	sub    $0x8,%esp
80105972:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105975:	50                   	push   %eax
80105976:	6a 00                	push   $0x0
80105978:	e8 e3 f6 ff ff       	call   80105060 <argstr>
8010597d:	83 c4 10             	add    $0x10,%esp
80105980:	85 c0                	test   %eax,%eax
80105982:	78 34                	js     801059b8 <sys_mkdir+0x58>
80105984:	83 ec 0c             	sub    $0xc,%esp
80105987:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010598a:	31 c9                	xor    %ecx,%ecx
8010598c:	ba 01 00 00 00       	mov    $0x1,%edx
80105991:	6a 00                	push   $0x0
80105993:	e8 78 f7 ff ff       	call   80105110 <create>
80105998:	83 c4 10             	add    $0x10,%esp
8010599b:	85 c0                	test   %eax,%eax
8010599d:	74 19                	je     801059b8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010599f:	83 ec 0c             	sub    $0xc,%esp
801059a2:	50                   	push   %eax
801059a3:	e8 b8 c6 ff ff       	call   80102060 <iunlockput>
  end_op();
801059a8:	e8 53 da ff ff       	call   80103400 <end_op>
  return 0;
801059ad:	83 c4 10             	add    $0x10,%esp
801059b0:	31 c0                	xor    %eax,%eax
}
801059b2:	c9                   	leave  
801059b3:	c3                   	ret    
801059b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801059b8:	e8 43 da ff ff       	call   80103400 <end_op>
    return -1;
801059bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059c2:	c9                   	leave  
801059c3:	c3                   	ret    
801059c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059cf:	90                   	nop

801059d0 <sys_mknod>:

int
sys_mknod(void)
{
801059d0:	f3 0f 1e fb          	endbr32 
801059d4:	55                   	push   %ebp
801059d5:	89 e5                	mov    %esp,%ebp
801059d7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801059da:	e8 b1 d9 ff ff       	call   80103390 <begin_op>
  if((argstr(0, &path)) < 0 ||
801059df:	83 ec 08             	sub    $0x8,%esp
801059e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059e5:	50                   	push   %eax
801059e6:	6a 00                	push   $0x0
801059e8:	e8 73 f6 ff ff       	call   80105060 <argstr>
801059ed:	83 c4 10             	add    $0x10,%esp
801059f0:	85 c0                	test   %eax,%eax
801059f2:	78 64                	js     80105a58 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801059f4:	83 ec 08             	sub    $0x8,%esp
801059f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059fa:	50                   	push   %eax
801059fb:	6a 01                	push   $0x1
801059fd:	e8 ae f5 ff ff       	call   80104fb0 <argint>
  if((argstr(0, &path)) < 0 ||
80105a02:	83 c4 10             	add    $0x10,%esp
80105a05:	85 c0                	test   %eax,%eax
80105a07:	78 4f                	js     80105a58 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105a09:	83 ec 08             	sub    $0x8,%esp
80105a0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a0f:	50                   	push   %eax
80105a10:	6a 02                	push   $0x2
80105a12:	e8 99 f5 ff ff       	call   80104fb0 <argint>
     argint(1, &major) < 0 ||
80105a17:	83 c4 10             	add    $0x10,%esp
80105a1a:	85 c0                	test   %eax,%eax
80105a1c:	78 3a                	js     80105a58 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a1e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105a22:	83 ec 0c             	sub    $0xc,%esp
80105a25:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105a29:	ba 03 00 00 00       	mov    $0x3,%edx
80105a2e:	50                   	push   %eax
80105a2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a32:	e8 d9 f6 ff ff       	call   80105110 <create>
     argint(2, &minor) < 0 ||
80105a37:	83 c4 10             	add    $0x10,%esp
80105a3a:	85 c0                	test   %eax,%eax
80105a3c:	74 1a                	je     80105a58 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a3e:	83 ec 0c             	sub    $0xc,%esp
80105a41:	50                   	push   %eax
80105a42:	e8 19 c6 ff ff       	call   80102060 <iunlockput>
  end_op();
80105a47:	e8 b4 d9 ff ff       	call   80103400 <end_op>
  return 0;
80105a4c:	83 c4 10             	add    $0x10,%esp
80105a4f:	31 c0                	xor    %eax,%eax
}
80105a51:	c9                   	leave  
80105a52:	c3                   	ret    
80105a53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a57:	90                   	nop
    end_op();
80105a58:	e8 a3 d9 ff ff       	call   80103400 <end_op>
    return -1;
80105a5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a62:	c9                   	leave  
80105a63:	c3                   	ret    
80105a64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a6f:	90                   	nop

80105a70 <sys_chdir>:

int
sys_chdir(void)
{
80105a70:	f3 0f 1e fb          	endbr32 
80105a74:	55                   	push   %ebp
80105a75:	89 e5                	mov    %esp,%ebp
80105a77:	56                   	push   %esi
80105a78:	53                   	push   %ebx
80105a79:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105a7c:	e8 3f e5 ff ff       	call   80103fc0 <myproc>
80105a81:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105a83:	e8 08 d9 ff ff       	call   80103390 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105a88:	83 ec 08             	sub    $0x8,%esp
80105a8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a8e:	50                   	push   %eax
80105a8f:	6a 00                	push   $0x0
80105a91:	e8 ca f5 ff ff       	call   80105060 <argstr>
80105a96:	83 c4 10             	add    $0x10,%esp
80105a99:	85 c0                	test   %eax,%eax
80105a9b:	78 73                	js     80105b10 <sys_chdir+0xa0>
80105a9d:	83 ec 0c             	sub    $0xc,%esp
80105aa0:	ff 75 f4             	pushl  -0xc(%ebp)
80105aa3:	e8 e8 cb ff ff       	call   80102690 <namei>
80105aa8:	83 c4 10             	add    $0x10,%esp
80105aab:	89 c3                	mov    %eax,%ebx
80105aad:	85 c0                	test   %eax,%eax
80105aaf:	74 5f                	je     80105b10 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105ab1:	83 ec 0c             	sub    $0xc,%esp
80105ab4:	50                   	push   %eax
80105ab5:	e8 06 c3 ff ff       	call   80101dc0 <ilock>
  if(ip->type != T_DIR){
80105aba:	83 c4 10             	add    $0x10,%esp
80105abd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ac2:	75 2c                	jne    80105af0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ac4:	83 ec 0c             	sub    $0xc,%esp
80105ac7:	53                   	push   %ebx
80105ac8:	e8 d3 c3 ff ff       	call   80101ea0 <iunlock>
  iput(curproc->cwd);
80105acd:	58                   	pop    %eax
80105ace:	ff 76 68             	pushl  0x68(%esi)
80105ad1:	e8 1a c4 ff ff       	call   80101ef0 <iput>
  end_op();
80105ad6:	e8 25 d9 ff ff       	call   80103400 <end_op>
  curproc->cwd = ip;
80105adb:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105ade:	83 c4 10             	add    $0x10,%esp
80105ae1:	31 c0                	xor    %eax,%eax
}
80105ae3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ae6:	5b                   	pop    %ebx
80105ae7:	5e                   	pop    %esi
80105ae8:	5d                   	pop    %ebp
80105ae9:	c3                   	ret    
80105aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105af0:	83 ec 0c             	sub    $0xc,%esp
80105af3:	53                   	push   %ebx
80105af4:	e8 67 c5 ff ff       	call   80102060 <iunlockput>
    end_op();
80105af9:	e8 02 d9 ff ff       	call   80103400 <end_op>
    return -1;
80105afe:	83 c4 10             	add    $0x10,%esp
80105b01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b06:	eb db                	jmp    80105ae3 <sys_chdir+0x73>
80105b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0f:	90                   	nop
    end_op();
80105b10:	e8 eb d8 ff ff       	call   80103400 <end_op>
    return -1;
80105b15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b1a:	eb c7                	jmp    80105ae3 <sys_chdir+0x73>
80105b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b20 <sys_exec>:

int
sys_exec(void)
{
80105b20:	f3 0f 1e fb          	endbr32 
80105b24:	55                   	push   %ebp
80105b25:	89 e5                	mov    %esp,%ebp
80105b27:	57                   	push   %edi
80105b28:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b29:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b2f:	53                   	push   %ebx
80105b30:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b36:	50                   	push   %eax
80105b37:	6a 00                	push   $0x0
80105b39:	e8 22 f5 ff ff       	call   80105060 <argstr>
80105b3e:	83 c4 10             	add    $0x10,%esp
80105b41:	85 c0                	test   %eax,%eax
80105b43:	0f 88 8b 00 00 00    	js     80105bd4 <sys_exec+0xb4>
80105b49:	83 ec 08             	sub    $0x8,%esp
80105b4c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b52:	50                   	push   %eax
80105b53:	6a 01                	push   $0x1
80105b55:	e8 56 f4 ff ff       	call   80104fb0 <argint>
80105b5a:	83 c4 10             	add    $0x10,%esp
80105b5d:	85 c0                	test   %eax,%eax
80105b5f:	78 73                	js     80105bd4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b61:	83 ec 04             	sub    $0x4,%esp
80105b64:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105b6a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105b6c:	68 80 00 00 00       	push   $0x80
80105b71:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105b77:	6a 00                	push   $0x0
80105b79:	50                   	push   %eax
80105b7a:	e8 51 f1 ff ff       	call   80104cd0 <memset>
80105b7f:	83 c4 10             	add    $0x10,%esp
80105b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105b88:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105b8e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105b95:	83 ec 08             	sub    $0x8,%esp
80105b98:	57                   	push   %edi
80105b99:	01 f0                	add    %esi,%eax
80105b9b:	50                   	push   %eax
80105b9c:	e8 6f f3 ff ff       	call   80104f10 <fetchint>
80105ba1:	83 c4 10             	add    $0x10,%esp
80105ba4:	85 c0                	test   %eax,%eax
80105ba6:	78 2c                	js     80105bd4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105ba8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105bae:	85 c0                	test   %eax,%eax
80105bb0:	74 36                	je     80105be8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105bb2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105bb8:	83 ec 08             	sub    $0x8,%esp
80105bbb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105bbe:	52                   	push   %edx
80105bbf:	50                   	push   %eax
80105bc0:	e8 8b f3 ff ff       	call   80104f50 <fetchstr>
80105bc5:	83 c4 10             	add    $0x10,%esp
80105bc8:	85 c0                	test   %eax,%eax
80105bca:	78 08                	js     80105bd4 <sys_exec+0xb4>
  for(i=0;; i++){
80105bcc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105bcf:	83 fb 20             	cmp    $0x20,%ebx
80105bd2:	75 b4                	jne    80105b88 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105bd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105bd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bdc:	5b                   	pop    %ebx
80105bdd:	5e                   	pop    %esi
80105bde:	5f                   	pop    %edi
80105bdf:	5d                   	pop    %ebp
80105be0:	c3                   	ret    
80105be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105be8:	83 ec 08             	sub    $0x8,%esp
80105beb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105bf1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105bf8:	00 00 00 00 
  return exec(path, argv);
80105bfc:	50                   	push   %eax
80105bfd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c03:	e8 d8 b4 ff ff       	call   801010e0 <exec>
80105c08:	83 c4 10             	add    $0x10,%esp
}
80105c0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c0e:	5b                   	pop    %ebx
80105c0f:	5e                   	pop    %esi
80105c10:	5f                   	pop    %edi
80105c11:	5d                   	pop    %ebp
80105c12:	c3                   	ret    
80105c13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c20 <sys_pipe>:

int
sys_pipe(void)
{
80105c20:	f3 0f 1e fb          	endbr32 
80105c24:	55                   	push   %ebp
80105c25:	89 e5                	mov    %esp,%ebp
80105c27:	57                   	push   %edi
80105c28:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c29:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c2c:	53                   	push   %ebx
80105c2d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c30:	6a 08                	push   $0x8
80105c32:	50                   	push   %eax
80105c33:	6a 00                	push   $0x0
80105c35:	e8 c6 f3 ff ff       	call   80105000 <argptr>
80105c3a:	83 c4 10             	add    $0x10,%esp
80105c3d:	85 c0                	test   %eax,%eax
80105c3f:	78 4e                	js     80105c8f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c41:	83 ec 08             	sub    $0x8,%esp
80105c44:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c47:	50                   	push   %eax
80105c48:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c4b:	50                   	push   %eax
80105c4c:	e8 ff dd ff ff       	call   80103a50 <pipealloc>
80105c51:	83 c4 10             	add    $0x10,%esp
80105c54:	85 c0                	test   %eax,%eax
80105c56:	78 37                	js     80105c8f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c58:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105c5b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105c5d:	e8 5e e3 ff ff       	call   80103fc0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105c68:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105c6c:	85 f6                	test   %esi,%esi
80105c6e:	74 30                	je     80105ca0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105c70:	83 c3 01             	add    $0x1,%ebx
80105c73:	83 fb 10             	cmp    $0x10,%ebx
80105c76:	75 f0                	jne    80105c68 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105c78:	83 ec 0c             	sub    $0xc,%esp
80105c7b:	ff 75 e0             	pushl  -0x20(%ebp)
80105c7e:	e8 9d b8 ff ff       	call   80101520 <fileclose>
    fileclose(wf);
80105c83:	58                   	pop    %eax
80105c84:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c87:	e8 94 b8 ff ff       	call   80101520 <fileclose>
    return -1;
80105c8c:	83 c4 10             	add    $0x10,%esp
80105c8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c94:	eb 5b                	jmp    80105cf1 <sys_pipe+0xd1>
80105c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105ca0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ca3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ca7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105caa:	e8 11 e3 ff ff       	call   80103fc0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105caf:	31 d2                	xor    %edx,%edx
80105cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105cb8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105cbc:	85 c9                	test   %ecx,%ecx
80105cbe:	74 20                	je     80105ce0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105cc0:	83 c2 01             	add    $0x1,%edx
80105cc3:	83 fa 10             	cmp    $0x10,%edx
80105cc6:	75 f0                	jne    80105cb8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105cc8:	e8 f3 e2 ff ff       	call   80103fc0 <myproc>
80105ccd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105cd4:	00 
80105cd5:	eb a1                	jmp    80105c78 <sys_pipe+0x58>
80105cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cde:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105ce0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105ce4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ce7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ce9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105cef:	31 c0                	xor    %eax,%eax
}
80105cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cf4:	5b                   	pop    %ebx
80105cf5:	5e                   	pop    %esi
80105cf6:	5f                   	pop    %edi
80105cf7:	5d                   	pop    %ebp
80105cf8:	c3                   	ret    
80105cf9:	66 90                	xchg   %ax,%ax
80105cfb:	66 90                	xchg   %ax,%ax
80105cfd:	66 90                	xchg   %ax,%ax
80105cff:	90                   	nop

80105d00 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105d00:	f3 0f 1e fb          	endbr32 
  return fork();
80105d04:	e9 67 e4 ff ff       	jmp    80104170 <fork>
80105d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d10 <sys_exit>:
}

int
sys_exit(void)
{
80105d10:	f3 0f 1e fb          	endbr32 
80105d14:	55                   	push   %ebp
80105d15:	89 e5                	mov    %esp,%ebp
80105d17:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d1a:	e8 d1 e6 ff ff       	call   801043f0 <exit>
  return 0;  // not reached
}
80105d1f:	31 c0                	xor    %eax,%eax
80105d21:	c9                   	leave  
80105d22:	c3                   	ret    
80105d23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d30 <sys_wait>:

int
sys_wait(void)
{
80105d30:	f3 0f 1e fb          	endbr32 
  return wait();
80105d34:	e9 07 e9 ff ff       	jmp    80104640 <wait>
80105d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d40 <sys_kill>:
}

int
sys_kill(void)
{
80105d40:	f3 0f 1e fb          	endbr32 
80105d44:	55                   	push   %ebp
80105d45:	89 e5                	mov    %esp,%ebp
80105d47:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d4d:	50                   	push   %eax
80105d4e:	6a 00                	push   $0x0
80105d50:	e8 5b f2 ff ff       	call   80104fb0 <argint>
80105d55:	83 c4 10             	add    $0x10,%esp
80105d58:	85 c0                	test   %eax,%eax
80105d5a:	78 14                	js     80105d70 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d5c:	83 ec 0c             	sub    $0xc,%esp
80105d5f:	ff 75 f4             	pushl  -0xc(%ebp)
80105d62:	e8 39 ea ff ff       	call   801047a0 <kill>
80105d67:	83 c4 10             	add    $0x10,%esp
}
80105d6a:	c9                   	leave  
80105d6b:	c3                   	ret    
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d70:	c9                   	leave  
    return -1;
80105d71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d76:	c3                   	ret    
80105d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d7e:	66 90                	xchg   %ax,%ax

80105d80 <sys_getpid>:

int
sys_getpid(void)
{
80105d80:	f3 0f 1e fb          	endbr32 
80105d84:	55                   	push   %ebp
80105d85:	89 e5                	mov    %esp,%ebp
80105d87:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105d8a:	e8 31 e2 ff ff       	call   80103fc0 <myproc>
80105d8f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d92:	c9                   	leave  
80105d93:	c3                   	ret    
80105d94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d9f:	90                   	nop

80105da0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105da0:	f3 0f 1e fb          	endbr32 
80105da4:	55                   	push   %ebp
80105da5:	89 e5                	mov    %esp,%ebp
80105da7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105da8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105dab:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dae:	50                   	push   %eax
80105daf:	6a 00                	push   $0x0
80105db1:	e8 fa f1 ff ff       	call   80104fb0 <argint>
80105db6:	83 c4 10             	add    $0x10,%esp
80105db9:	85 c0                	test   %eax,%eax
80105dbb:	78 23                	js     80105de0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105dbd:	e8 fe e1 ff ff       	call   80103fc0 <myproc>
  if(growproc(n) < 0)
80105dc2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105dc5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105dc7:	ff 75 f4             	pushl  -0xc(%ebp)
80105dca:	e8 21 e3 ff ff       	call   801040f0 <growproc>
80105dcf:	83 c4 10             	add    $0x10,%esp
80105dd2:	85 c0                	test   %eax,%eax
80105dd4:	78 0a                	js     80105de0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105dd6:	89 d8                	mov    %ebx,%eax
80105dd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ddb:	c9                   	leave  
80105ddc:	c3                   	ret    
80105ddd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105de0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105de5:	eb ef                	jmp    80105dd6 <sys_sbrk+0x36>
80105de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dee:	66 90                	xchg   %ax,%ax

80105df0 <sys_sleep>:

int
sys_sleep(void)
{
80105df0:	f3 0f 1e fb          	endbr32 
80105df4:	55                   	push   %ebp
80105df5:	89 e5                	mov    %esp,%ebp
80105df7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105df8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105dfb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dfe:	50                   	push   %eax
80105dff:	6a 00                	push   $0x0
80105e01:	e8 aa f1 ff ff       	call   80104fb0 <argint>
80105e06:	83 c4 10             	add    $0x10,%esp
80105e09:	85 c0                	test   %eax,%eax
80105e0b:	0f 88 86 00 00 00    	js     80105e97 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e11:	83 ec 0c             	sub    $0xc,%esp
80105e14:	68 40 65 11 80       	push   $0x80116540
80105e19:	e8 a2 ed ff ff       	call   80104bc0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105e21:	8b 1d 80 6d 11 80    	mov    0x80116d80,%ebx
  while(ticks - ticks0 < n){
80105e27:	83 c4 10             	add    $0x10,%esp
80105e2a:	85 d2                	test   %edx,%edx
80105e2c:	75 23                	jne    80105e51 <sys_sleep+0x61>
80105e2e:	eb 50                	jmp    80105e80 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e30:	83 ec 08             	sub    $0x8,%esp
80105e33:	68 40 65 11 80       	push   $0x80116540
80105e38:	68 80 6d 11 80       	push   $0x80116d80
80105e3d:	e8 3e e7 ff ff       	call   80104580 <sleep>
  while(ticks - ticks0 < n){
80105e42:	a1 80 6d 11 80       	mov    0x80116d80,%eax
80105e47:	83 c4 10             	add    $0x10,%esp
80105e4a:	29 d8                	sub    %ebx,%eax
80105e4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e4f:	73 2f                	jae    80105e80 <sys_sleep+0x90>
    if(myproc()->killed){
80105e51:	e8 6a e1 ff ff       	call   80103fc0 <myproc>
80105e56:	8b 40 24             	mov    0x24(%eax),%eax
80105e59:	85 c0                	test   %eax,%eax
80105e5b:	74 d3                	je     80105e30 <sys_sleep+0x40>
      release(&tickslock);
80105e5d:	83 ec 0c             	sub    $0xc,%esp
80105e60:	68 40 65 11 80       	push   $0x80116540
80105e65:	e8 16 ee ff ff       	call   80104c80 <release>
  }
  release(&tickslock);
  return 0;
}
80105e6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105e6d:	83 c4 10             	add    $0x10,%esp
80105e70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e75:	c9                   	leave  
80105e76:	c3                   	ret    
80105e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e7e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105e80:	83 ec 0c             	sub    $0xc,%esp
80105e83:	68 40 65 11 80       	push   $0x80116540
80105e88:	e8 f3 ed ff ff       	call   80104c80 <release>
  return 0;
80105e8d:	83 c4 10             	add    $0x10,%esp
80105e90:	31 c0                	xor    %eax,%eax
}
80105e92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e95:	c9                   	leave  
80105e96:	c3                   	ret    
    return -1;
80105e97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e9c:	eb f4                	jmp    80105e92 <sys_sleep+0xa2>
80105e9e:	66 90                	xchg   %ax,%ax

80105ea0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ea0:	f3 0f 1e fb          	endbr32 
80105ea4:	55                   	push   %ebp
80105ea5:	89 e5                	mov    %esp,%ebp
80105ea7:	53                   	push   %ebx
80105ea8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105eab:	68 40 65 11 80       	push   $0x80116540
80105eb0:	e8 0b ed ff ff       	call   80104bc0 <acquire>
  xticks = ticks;
80105eb5:	8b 1d 80 6d 11 80    	mov    0x80116d80,%ebx
  release(&tickslock);
80105ebb:	c7 04 24 40 65 11 80 	movl   $0x80116540,(%esp)
80105ec2:	e8 b9 ed ff ff       	call   80104c80 <release>
  return xticks;
}
80105ec7:	89 d8                	mov    %ebx,%eax
80105ec9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ecc:	c9                   	leave  
80105ecd:	c3                   	ret    

80105ece <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105ece:	1e                   	push   %ds
  pushl %es
80105ecf:	06                   	push   %es
  pushl %fs
80105ed0:	0f a0                	push   %fs
  pushl %gs
80105ed2:	0f a8                	push   %gs
  pushal
80105ed4:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ed5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ed9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105edb:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105edd:	54                   	push   %esp
  call trap
80105ede:	e8 cd 00 00 00       	call   80105fb0 <trap>
  addl $4, %esp
80105ee3:	83 c4 04             	add    $0x4,%esp

80105ee6 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ee6:	61                   	popa   
  popl %gs
80105ee7:	0f a9                	pop    %gs
  popl %fs
80105ee9:	0f a1                	pop    %fs
  popl %es
80105eeb:	07                   	pop    %es
  popl %ds
80105eec:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105eed:	83 c4 08             	add    $0x8,%esp
  iret
80105ef0:	cf                   	iret   
80105ef1:	66 90                	xchg   %ax,%ax
80105ef3:	66 90                	xchg   %ax,%ax
80105ef5:	66 90                	xchg   %ax,%ax
80105ef7:	66 90                	xchg   %ax,%ax
80105ef9:	66 90                	xchg   %ax,%ax
80105efb:	66 90                	xchg   %ax,%ax
80105efd:	66 90                	xchg   %ax,%ax
80105eff:	90                   	nop

80105f00 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f00:	f3 0f 1e fb          	endbr32 
80105f04:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105f05:	31 c0                	xor    %eax,%eax
{
80105f07:	89 e5                	mov    %esp,%ebp
80105f09:	83 ec 08             	sub    $0x8,%esp
80105f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105f10:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105f17:	c7 04 c5 82 65 11 80 	movl   $0x8e000008,-0x7fee9a7e(,%eax,8)
80105f1e:	08 00 00 8e 
80105f22:	66 89 14 c5 80 65 11 	mov    %dx,-0x7fee9a80(,%eax,8)
80105f29:	80 
80105f2a:	c1 ea 10             	shr    $0x10,%edx
80105f2d:	66 89 14 c5 86 65 11 	mov    %dx,-0x7fee9a7a(,%eax,8)
80105f34:	80 
  for(i = 0; i < 256; i++)
80105f35:	83 c0 01             	add    $0x1,%eax
80105f38:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f3d:	75 d1                	jne    80105f10 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105f3f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f42:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105f47:	c7 05 82 67 11 80 08 	movl   $0xef000008,0x80116782
80105f4e:	00 00 ef 
  initlock(&tickslock, "time");
80105f51:	68 d9 7e 10 80       	push   $0x80107ed9
80105f56:	68 40 65 11 80       	push   $0x80116540
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f5b:	66 a3 80 67 11 80    	mov    %ax,0x80116780
80105f61:	c1 e8 10             	shr    $0x10,%eax
80105f64:	66 a3 86 67 11 80    	mov    %ax,0x80116786
  initlock(&tickslock, "time");
80105f6a:	e8 d1 ea ff ff       	call   80104a40 <initlock>
}
80105f6f:	83 c4 10             	add    $0x10,%esp
80105f72:	c9                   	leave  
80105f73:	c3                   	ret    
80105f74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f7f:	90                   	nop

80105f80 <idtinit>:

void
idtinit(void)
{
80105f80:	f3 0f 1e fb          	endbr32 
80105f84:	55                   	push   %ebp
  pd[0] = size-1;
80105f85:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f8a:	89 e5                	mov    %esp,%ebp
80105f8c:	83 ec 10             	sub    $0x10,%esp
80105f8f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f93:	b8 80 65 11 80       	mov    $0x80116580,%eax
80105f98:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f9c:	c1 e8 10             	shr    $0x10,%eax
80105f9f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105fa3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105fa6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105fa9:	c9                   	leave  
80105faa:	c3                   	ret    
80105fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105faf:	90                   	nop

80105fb0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105fb0:	f3 0f 1e fb          	endbr32 
80105fb4:	55                   	push   %ebp
80105fb5:	89 e5                	mov    %esp,%ebp
80105fb7:	57                   	push   %edi
80105fb8:	56                   	push   %esi
80105fb9:	53                   	push   %ebx
80105fba:	83 ec 1c             	sub    $0x1c,%esp
80105fbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105fc0:	8b 43 30             	mov    0x30(%ebx),%eax
80105fc3:	83 f8 40             	cmp    $0x40,%eax
80105fc6:	0f 84 bc 01 00 00    	je     80106188 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105fcc:	83 e8 20             	sub    $0x20,%eax
80105fcf:	83 f8 1f             	cmp    $0x1f,%eax
80105fd2:	77 08                	ja     80105fdc <trap+0x2c>
80105fd4:	3e ff 24 85 80 7f 10 	notrack jmp *-0x7fef8080(,%eax,4)
80105fdb:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105fdc:	e8 df df ff ff       	call   80103fc0 <myproc>
80105fe1:	8b 7b 38             	mov    0x38(%ebx),%edi
80105fe4:	85 c0                	test   %eax,%eax
80105fe6:	0f 84 eb 01 00 00    	je     801061d7 <trap+0x227>
80105fec:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105ff0:	0f 84 e1 01 00 00    	je     801061d7 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105ff6:	0f 20 d1             	mov    %cr2,%ecx
80105ff9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ffc:	e8 9f df ff ff       	call   80103fa0 <cpuid>
80106001:	8b 73 30             	mov    0x30(%ebx),%esi
80106004:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106007:	8b 43 34             	mov    0x34(%ebx),%eax
8010600a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010600d:	e8 ae df ff ff       	call   80103fc0 <myproc>
80106012:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106015:	e8 a6 df ff ff       	call   80103fc0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010601a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010601d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106020:	51                   	push   %ecx
80106021:	57                   	push   %edi
80106022:	52                   	push   %edx
80106023:	ff 75 e4             	pushl  -0x1c(%ebp)
80106026:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106027:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010602a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010602d:	56                   	push   %esi
8010602e:	ff 70 10             	pushl  0x10(%eax)
80106031:	68 3c 7f 10 80       	push   $0x80107f3c
80106036:	e8 45 a7 ff ff       	call   80100780 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010603b:	83 c4 20             	add    $0x20,%esp
8010603e:	e8 7d df ff ff       	call   80103fc0 <myproc>
80106043:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010604a:	e8 71 df ff ff       	call   80103fc0 <myproc>
8010604f:	85 c0                	test   %eax,%eax
80106051:	74 1d                	je     80106070 <trap+0xc0>
80106053:	e8 68 df ff ff       	call   80103fc0 <myproc>
80106058:	8b 50 24             	mov    0x24(%eax),%edx
8010605b:	85 d2                	test   %edx,%edx
8010605d:	74 11                	je     80106070 <trap+0xc0>
8010605f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106063:	83 e0 03             	and    $0x3,%eax
80106066:	66 83 f8 03          	cmp    $0x3,%ax
8010606a:	0f 84 50 01 00 00    	je     801061c0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106070:	e8 4b df ff ff       	call   80103fc0 <myproc>
80106075:	85 c0                	test   %eax,%eax
80106077:	74 0f                	je     80106088 <trap+0xd8>
80106079:	e8 42 df ff ff       	call   80103fc0 <myproc>
8010607e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106082:	0f 84 e8 00 00 00    	je     80106170 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106088:	e8 33 df ff ff       	call   80103fc0 <myproc>
8010608d:	85 c0                	test   %eax,%eax
8010608f:	74 1d                	je     801060ae <trap+0xfe>
80106091:	e8 2a df ff ff       	call   80103fc0 <myproc>
80106096:	8b 40 24             	mov    0x24(%eax),%eax
80106099:	85 c0                	test   %eax,%eax
8010609b:	74 11                	je     801060ae <trap+0xfe>
8010609d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801060a1:	83 e0 03             	and    $0x3,%eax
801060a4:	66 83 f8 03          	cmp    $0x3,%ax
801060a8:	0f 84 03 01 00 00    	je     801061b1 <trap+0x201>
    exit();
}
801060ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060b1:	5b                   	pop    %ebx
801060b2:	5e                   	pop    %esi
801060b3:	5f                   	pop    %edi
801060b4:	5d                   	pop    %ebp
801060b5:	c3                   	ret    
    ideintr();
801060b6:	e8 85 c7 ff ff       	call   80102840 <ideintr>
    lapiceoi();
801060bb:	e8 60 ce ff ff       	call   80102f20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060c0:	e8 fb de ff ff       	call   80103fc0 <myproc>
801060c5:	85 c0                	test   %eax,%eax
801060c7:	75 8a                	jne    80106053 <trap+0xa3>
801060c9:	eb a5                	jmp    80106070 <trap+0xc0>
    if(cpuid() == 0){
801060cb:	e8 d0 de ff ff       	call   80103fa0 <cpuid>
801060d0:	85 c0                	test   %eax,%eax
801060d2:	75 e7                	jne    801060bb <trap+0x10b>
      acquire(&tickslock);
801060d4:	83 ec 0c             	sub    $0xc,%esp
801060d7:	68 40 65 11 80       	push   $0x80116540
801060dc:	e8 df ea ff ff       	call   80104bc0 <acquire>
      wakeup(&ticks);
801060e1:	c7 04 24 80 6d 11 80 	movl   $0x80116d80,(%esp)
      ticks++;
801060e8:	83 05 80 6d 11 80 01 	addl   $0x1,0x80116d80
      wakeup(&ticks);
801060ef:	e8 4c e6 ff ff       	call   80104740 <wakeup>
      release(&tickslock);
801060f4:	c7 04 24 40 65 11 80 	movl   $0x80116540,(%esp)
801060fb:	e8 80 eb ff ff       	call   80104c80 <release>
80106100:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106103:	eb b6                	jmp    801060bb <trap+0x10b>
    kbdintr();
80106105:	e8 d6 cc ff ff       	call   80102de0 <kbdintr>
    lapiceoi();
8010610a:	e8 11 ce ff ff       	call   80102f20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010610f:	e8 ac de ff ff       	call   80103fc0 <myproc>
80106114:	85 c0                	test   %eax,%eax
80106116:	0f 85 37 ff ff ff    	jne    80106053 <trap+0xa3>
8010611c:	e9 4f ff ff ff       	jmp    80106070 <trap+0xc0>
    uartintr();
80106121:	e8 4a 02 00 00       	call   80106370 <uartintr>
    lapiceoi();
80106126:	e8 f5 cd ff ff       	call   80102f20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010612b:	e8 90 de ff ff       	call   80103fc0 <myproc>
80106130:	85 c0                	test   %eax,%eax
80106132:	0f 85 1b ff ff ff    	jne    80106053 <trap+0xa3>
80106138:	e9 33 ff ff ff       	jmp    80106070 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010613d:	8b 7b 38             	mov    0x38(%ebx),%edi
80106140:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106144:	e8 57 de ff ff       	call   80103fa0 <cpuid>
80106149:	57                   	push   %edi
8010614a:	56                   	push   %esi
8010614b:	50                   	push   %eax
8010614c:	68 e4 7e 10 80       	push   $0x80107ee4
80106151:	e8 2a a6 ff ff       	call   80100780 <cprintf>
    lapiceoi();
80106156:	e8 c5 cd ff ff       	call   80102f20 <lapiceoi>
    break;
8010615b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010615e:	e8 5d de ff ff       	call   80103fc0 <myproc>
80106163:	85 c0                	test   %eax,%eax
80106165:	0f 85 e8 fe ff ff    	jne    80106053 <trap+0xa3>
8010616b:	e9 00 ff ff ff       	jmp    80106070 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80106170:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106174:	0f 85 0e ff ff ff    	jne    80106088 <trap+0xd8>
    yield();
8010617a:	e8 b1 e3 ff ff       	call   80104530 <yield>
8010617f:	e9 04 ff ff ff       	jmp    80106088 <trap+0xd8>
80106184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106188:	e8 33 de ff ff       	call   80103fc0 <myproc>
8010618d:	8b 70 24             	mov    0x24(%eax),%esi
80106190:	85 f6                	test   %esi,%esi
80106192:	75 3c                	jne    801061d0 <trap+0x220>
    myproc()->tf = tf;
80106194:	e8 27 de ff ff       	call   80103fc0 <myproc>
80106199:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010619c:	e8 ff ee ff ff       	call   801050a0 <syscall>
    if(myproc()->killed)
801061a1:	e8 1a de ff ff       	call   80103fc0 <myproc>
801061a6:	8b 48 24             	mov    0x24(%eax),%ecx
801061a9:	85 c9                	test   %ecx,%ecx
801061ab:	0f 84 fd fe ff ff    	je     801060ae <trap+0xfe>
}
801061b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061b4:	5b                   	pop    %ebx
801061b5:	5e                   	pop    %esi
801061b6:	5f                   	pop    %edi
801061b7:	5d                   	pop    %ebp
      exit();
801061b8:	e9 33 e2 ff ff       	jmp    801043f0 <exit>
801061bd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
801061c0:	e8 2b e2 ff ff       	call   801043f0 <exit>
801061c5:	e9 a6 fe ff ff       	jmp    80106070 <trap+0xc0>
801061ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801061d0:	e8 1b e2 ff ff       	call   801043f0 <exit>
801061d5:	eb bd                	jmp    80106194 <trap+0x1e4>
801061d7:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801061da:	e8 c1 dd ff ff       	call   80103fa0 <cpuid>
801061df:	83 ec 0c             	sub    $0xc,%esp
801061e2:	56                   	push   %esi
801061e3:	57                   	push   %edi
801061e4:	50                   	push   %eax
801061e5:	ff 73 30             	pushl  0x30(%ebx)
801061e8:	68 08 7f 10 80       	push   $0x80107f08
801061ed:	e8 8e a5 ff ff       	call   80100780 <cprintf>
      panic("trap");
801061f2:	83 c4 14             	add    $0x14,%esp
801061f5:	68 de 7e 10 80       	push   $0x80107ede
801061fa:	e8 01 a5 ff ff       	call   80100700 <panic>
801061ff:	90                   	nop

80106200 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106200:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106204:	a1 dc b5 10 80       	mov    0x8010b5dc,%eax
80106209:	85 c0                	test   %eax,%eax
8010620b:	74 1b                	je     80106228 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010620d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106212:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106213:	a8 01                	test   $0x1,%al
80106215:	74 11                	je     80106228 <uartgetc+0x28>
80106217:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010621c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010621d:	0f b6 c0             	movzbl %al,%eax
80106220:	c3                   	ret    
80106221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010622d:	c3                   	ret    
8010622e:	66 90                	xchg   %ax,%ax

80106230 <uartputc.part.0>:
uartputc(int c)
80106230:	55                   	push   %ebp
80106231:	89 e5                	mov    %esp,%ebp
80106233:	57                   	push   %edi
80106234:	89 c7                	mov    %eax,%edi
80106236:	56                   	push   %esi
80106237:	be fd 03 00 00       	mov    $0x3fd,%esi
8010623c:	53                   	push   %ebx
8010623d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106242:	83 ec 0c             	sub    $0xc,%esp
80106245:	eb 1b                	jmp    80106262 <uartputc.part.0+0x32>
80106247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010624e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106250:	83 ec 0c             	sub    $0xc,%esp
80106253:	6a 0a                	push   $0xa
80106255:	e8 e6 cc ff ff       	call   80102f40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010625a:	83 c4 10             	add    $0x10,%esp
8010625d:	83 eb 01             	sub    $0x1,%ebx
80106260:	74 07                	je     80106269 <uartputc.part.0+0x39>
80106262:	89 f2                	mov    %esi,%edx
80106264:	ec                   	in     (%dx),%al
80106265:	a8 20                	test   $0x20,%al
80106267:	74 e7                	je     80106250 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106269:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010626e:	89 f8                	mov    %edi,%eax
80106270:	ee                   	out    %al,(%dx)
}
80106271:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106274:	5b                   	pop    %ebx
80106275:	5e                   	pop    %esi
80106276:	5f                   	pop    %edi
80106277:	5d                   	pop    %ebp
80106278:	c3                   	ret    
80106279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106280 <uartinit>:
{
80106280:	f3 0f 1e fb          	endbr32 
80106284:	55                   	push   %ebp
80106285:	31 c9                	xor    %ecx,%ecx
80106287:	89 c8                	mov    %ecx,%eax
80106289:	89 e5                	mov    %esp,%ebp
8010628b:	57                   	push   %edi
8010628c:	56                   	push   %esi
8010628d:	53                   	push   %ebx
8010628e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106293:	89 da                	mov    %ebx,%edx
80106295:	83 ec 0c             	sub    $0xc,%esp
80106298:	ee                   	out    %al,(%dx)
80106299:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010629e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801062a3:	89 fa                	mov    %edi,%edx
801062a5:	ee                   	out    %al,(%dx)
801062a6:	b8 0c 00 00 00       	mov    $0xc,%eax
801062ab:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062b0:	ee                   	out    %al,(%dx)
801062b1:	be f9 03 00 00       	mov    $0x3f9,%esi
801062b6:	89 c8                	mov    %ecx,%eax
801062b8:	89 f2                	mov    %esi,%edx
801062ba:	ee                   	out    %al,(%dx)
801062bb:	b8 03 00 00 00       	mov    $0x3,%eax
801062c0:	89 fa                	mov    %edi,%edx
801062c2:	ee                   	out    %al,(%dx)
801062c3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801062c8:	89 c8                	mov    %ecx,%eax
801062ca:	ee                   	out    %al,(%dx)
801062cb:	b8 01 00 00 00       	mov    $0x1,%eax
801062d0:	89 f2                	mov    %esi,%edx
801062d2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062d3:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062d8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801062d9:	3c ff                	cmp    $0xff,%al
801062db:	74 52                	je     8010632f <uartinit+0xaf>
  uart = 1;
801062dd:	c7 05 dc b5 10 80 01 	movl   $0x1,0x8010b5dc
801062e4:	00 00 00 
801062e7:	89 da                	mov    %ebx,%edx
801062e9:	ec                   	in     (%dx),%al
801062ea:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062ef:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801062f0:	83 ec 08             	sub    $0x8,%esp
801062f3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
801062f8:	bb 00 80 10 80       	mov    $0x80108000,%ebx
  ioapicenable(IRQ_COM1, 0);
801062fd:	6a 00                	push   $0x0
801062ff:	6a 04                	push   $0x4
80106301:	e8 8a c7 ff ff       	call   80102a90 <ioapicenable>
80106306:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106309:	b8 78 00 00 00       	mov    $0x78,%eax
8010630e:	eb 04                	jmp    80106314 <uartinit+0x94>
80106310:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106314:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
8010631a:	85 d2                	test   %edx,%edx
8010631c:	74 08                	je     80106326 <uartinit+0xa6>
    uartputc(*p);
8010631e:	0f be c0             	movsbl %al,%eax
80106321:	e8 0a ff ff ff       	call   80106230 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106326:	89 f0                	mov    %esi,%eax
80106328:	83 c3 01             	add    $0x1,%ebx
8010632b:	84 c0                	test   %al,%al
8010632d:	75 e1                	jne    80106310 <uartinit+0x90>
}
8010632f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106332:	5b                   	pop    %ebx
80106333:	5e                   	pop    %esi
80106334:	5f                   	pop    %edi
80106335:	5d                   	pop    %ebp
80106336:	c3                   	ret    
80106337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010633e:	66 90                	xchg   %ax,%ax

80106340 <uartputc>:
{
80106340:	f3 0f 1e fb          	endbr32 
80106344:	55                   	push   %ebp
  if(!uart)
80106345:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
{
8010634b:	89 e5                	mov    %esp,%ebp
8010634d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106350:	85 d2                	test   %edx,%edx
80106352:	74 0c                	je     80106360 <uartputc+0x20>
}
80106354:	5d                   	pop    %ebp
80106355:	e9 d6 fe ff ff       	jmp    80106230 <uartputc.part.0>
8010635a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106360:	5d                   	pop    %ebp
80106361:	c3                   	ret    
80106362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106370 <uartintr>:

void
uartintr(void)
{
80106370:	f3 0f 1e fb          	endbr32 
80106374:	55                   	push   %ebp
80106375:	89 e5                	mov    %esp,%ebp
80106377:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010637a:	68 00 62 10 80       	push   $0x80106200
8010637f:	e8 8c a7 ff ff       	call   80100b10 <consoleintr>
}
80106384:	83 c4 10             	add    $0x10,%esp
80106387:	c9                   	leave  
80106388:	c3                   	ret    

80106389 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $0
8010638b:	6a 00                	push   $0x0
  jmp alltraps
8010638d:	e9 3c fb ff ff       	jmp    80105ece <alltraps>

80106392 <vector1>:
.globl vector1
vector1:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $1
80106394:	6a 01                	push   $0x1
  jmp alltraps
80106396:	e9 33 fb ff ff       	jmp    80105ece <alltraps>

8010639b <vector2>:
.globl vector2
vector2:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $2
8010639d:	6a 02                	push   $0x2
  jmp alltraps
8010639f:	e9 2a fb ff ff       	jmp    80105ece <alltraps>

801063a4 <vector3>:
.globl vector3
vector3:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $3
801063a6:	6a 03                	push   $0x3
  jmp alltraps
801063a8:	e9 21 fb ff ff       	jmp    80105ece <alltraps>

801063ad <vector4>:
.globl vector4
vector4:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $4
801063af:	6a 04                	push   $0x4
  jmp alltraps
801063b1:	e9 18 fb ff ff       	jmp    80105ece <alltraps>

801063b6 <vector5>:
.globl vector5
vector5:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $5
801063b8:	6a 05                	push   $0x5
  jmp alltraps
801063ba:	e9 0f fb ff ff       	jmp    80105ece <alltraps>

801063bf <vector6>:
.globl vector6
vector6:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $6
801063c1:	6a 06                	push   $0x6
  jmp alltraps
801063c3:	e9 06 fb ff ff       	jmp    80105ece <alltraps>

801063c8 <vector7>:
.globl vector7
vector7:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $7
801063ca:	6a 07                	push   $0x7
  jmp alltraps
801063cc:	e9 fd fa ff ff       	jmp    80105ece <alltraps>

801063d1 <vector8>:
.globl vector8
vector8:
  pushl $8
801063d1:	6a 08                	push   $0x8
  jmp alltraps
801063d3:	e9 f6 fa ff ff       	jmp    80105ece <alltraps>

801063d8 <vector9>:
.globl vector9
vector9:
  pushl $0
801063d8:	6a 00                	push   $0x0
  pushl $9
801063da:	6a 09                	push   $0x9
  jmp alltraps
801063dc:	e9 ed fa ff ff       	jmp    80105ece <alltraps>

801063e1 <vector10>:
.globl vector10
vector10:
  pushl $10
801063e1:	6a 0a                	push   $0xa
  jmp alltraps
801063e3:	e9 e6 fa ff ff       	jmp    80105ece <alltraps>

801063e8 <vector11>:
.globl vector11
vector11:
  pushl $11
801063e8:	6a 0b                	push   $0xb
  jmp alltraps
801063ea:	e9 df fa ff ff       	jmp    80105ece <alltraps>

801063ef <vector12>:
.globl vector12
vector12:
  pushl $12
801063ef:	6a 0c                	push   $0xc
  jmp alltraps
801063f1:	e9 d8 fa ff ff       	jmp    80105ece <alltraps>

801063f6 <vector13>:
.globl vector13
vector13:
  pushl $13
801063f6:	6a 0d                	push   $0xd
  jmp alltraps
801063f8:	e9 d1 fa ff ff       	jmp    80105ece <alltraps>

801063fd <vector14>:
.globl vector14
vector14:
  pushl $14
801063fd:	6a 0e                	push   $0xe
  jmp alltraps
801063ff:	e9 ca fa ff ff       	jmp    80105ece <alltraps>

80106404 <vector15>:
.globl vector15
vector15:
  pushl $0
80106404:	6a 00                	push   $0x0
  pushl $15
80106406:	6a 0f                	push   $0xf
  jmp alltraps
80106408:	e9 c1 fa ff ff       	jmp    80105ece <alltraps>

8010640d <vector16>:
.globl vector16
vector16:
  pushl $0
8010640d:	6a 00                	push   $0x0
  pushl $16
8010640f:	6a 10                	push   $0x10
  jmp alltraps
80106411:	e9 b8 fa ff ff       	jmp    80105ece <alltraps>

80106416 <vector17>:
.globl vector17
vector17:
  pushl $17
80106416:	6a 11                	push   $0x11
  jmp alltraps
80106418:	e9 b1 fa ff ff       	jmp    80105ece <alltraps>

8010641d <vector18>:
.globl vector18
vector18:
  pushl $0
8010641d:	6a 00                	push   $0x0
  pushl $18
8010641f:	6a 12                	push   $0x12
  jmp alltraps
80106421:	e9 a8 fa ff ff       	jmp    80105ece <alltraps>

80106426 <vector19>:
.globl vector19
vector19:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $19
80106428:	6a 13                	push   $0x13
  jmp alltraps
8010642a:	e9 9f fa ff ff       	jmp    80105ece <alltraps>

8010642f <vector20>:
.globl vector20
vector20:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $20
80106431:	6a 14                	push   $0x14
  jmp alltraps
80106433:	e9 96 fa ff ff       	jmp    80105ece <alltraps>

80106438 <vector21>:
.globl vector21
vector21:
  pushl $0
80106438:	6a 00                	push   $0x0
  pushl $21
8010643a:	6a 15                	push   $0x15
  jmp alltraps
8010643c:	e9 8d fa ff ff       	jmp    80105ece <alltraps>

80106441 <vector22>:
.globl vector22
vector22:
  pushl $0
80106441:	6a 00                	push   $0x0
  pushl $22
80106443:	6a 16                	push   $0x16
  jmp alltraps
80106445:	e9 84 fa ff ff       	jmp    80105ece <alltraps>

8010644a <vector23>:
.globl vector23
vector23:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $23
8010644c:	6a 17                	push   $0x17
  jmp alltraps
8010644e:	e9 7b fa ff ff       	jmp    80105ece <alltraps>

80106453 <vector24>:
.globl vector24
vector24:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $24
80106455:	6a 18                	push   $0x18
  jmp alltraps
80106457:	e9 72 fa ff ff       	jmp    80105ece <alltraps>

8010645c <vector25>:
.globl vector25
vector25:
  pushl $0
8010645c:	6a 00                	push   $0x0
  pushl $25
8010645e:	6a 19                	push   $0x19
  jmp alltraps
80106460:	e9 69 fa ff ff       	jmp    80105ece <alltraps>

80106465 <vector26>:
.globl vector26
vector26:
  pushl $0
80106465:	6a 00                	push   $0x0
  pushl $26
80106467:	6a 1a                	push   $0x1a
  jmp alltraps
80106469:	e9 60 fa ff ff       	jmp    80105ece <alltraps>

8010646e <vector27>:
.globl vector27
vector27:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $27
80106470:	6a 1b                	push   $0x1b
  jmp alltraps
80106472:	e9 57 fa ff ff       	jmp    80105ece <alltraps>

80106477 <vector28>:
.globl vector28
vector28:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $28
80106479:	6a 1c                	push   $0x1c
  jmp alltraps
8010647b:	e9 4e fa ff ff       	jmp    80105ece <alltraps>

80106480 <vector29>:
.globl vector29
vector29:
  pushl $0
80106480:	6a 00                	push   $0x0
  pushl $29
80106482:	6a 1d                	push   $0x1d
  jmp alltraps
80106484:	e9 45 fa ff ff       	jmp    80105ece <alltraps>

80106489 <vector30>:
.globl vector30
vector30:
  pushl $0
80106489:	6a 00                	push   $0x0
  pushl $30
8010648b:	6a 1e                	push   $0x1e
  jmp alltraps
8010648d:	e9 3c fa ff ff       	jmp    80105ece <alltraps>

80106492 <vector31>:
.globl vector31
vector31:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $31
80106494:	6a 1f                	push   $0x1f
  jmp alltraps
80106496:	e9 33 fa ff ff       	jmp    80105ece <alltraps>

8010649b <vector32>:
.globl vector32
vector32:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $32
8010649d:	6a 20                	push   $0x20
  jmp alltraps
8010649f:	e9 2a fa ff ff       	jmp    80105ece <alltraps>

801064a4 <vector33>:
.globl vector33
vector33:
  pushl $0
801064a4:	6a 00                	push   $0x0
  pushl $33
801064a6:	6a 21                	push   $0x21
  jmp alltraps
801064a8:	e9 21 fa ff ff       	jmp    80105ece <alltraps>

801064ad <vector34>:
.globl vector34
vector34:
  pushl $0
801064ad:	6a 00                	push   $0x0
  pushl $34
801064af:	6a 22                	push   $0x22
  jmp alltraps
801064b1:	e9 18 fa ff ff       	jmp    80105ece <alltraps>

801064b6 <vector35>:
.globl vector35
vector35:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $35
801064b8:	6a 23                	push   $0x23
  jmp alltraps
801064ba:	e9 0f fa ff ff       	jmp    80105ece <alltraps>

801064bf <vector36>:
.globl vector36
vector36:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $36
801064c1:	6a 24                	push   $0x24
  jmp alltraps
801064c3:	e9 06 fa ff ff       	jmp    80105ece <alltraps>

801064c8 <vector37>:
.globl vector37
vector37:
  pushl $0
801064c8:	6a 00                	push   $0x0
  pushl $37
801064ca:	6a 25                	push   $0x25
  jmp alltraps
801064cc:	e9 fd f9 ff ff       	jmp    80105ece <alltraps>

801064d1 <vector38>:
.globl vector38
vector38:
  pushl $0
801064d1:	6a 00                	push   $0x0
  pushl $38
801064d3:	6a 26                	push   $0x26
  jmp alltraps
801064d5:	e9 f4 f9 ff ff       	jmp    80105ece <alltraps>

801064da <vector39>:
.globl vector39
vector39:
  pushl $0
801064da:	6a 00                	push   $0x0
  pushl $39
801064dc:	6a 27                	push   $0x27
  jmp alltraps
801064de:	e9 eb f9 ff ff       	jmp    80105ece <alltraps>

801064e3 <vector40>:
.globl vector40
vector40:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $40
801064e5:	6a 28                	push   $0x28
  jmp alltraps
801064e7:	e9 e2 f9 ff ff       	jmp    80105ece <alltraps>

801064ec <vector41>:
.globl vector41
vector41:
  pushl $0
801064ec:	6a 00                	push   $0x0
  pushl $41
801064ee:	6a 29                	push   $0x29
  jmp alltraps
801064f0:	e9 d9 f9 ff ff       	jmp    80105ece <alltraps>

801064f5 <vector42>:
.globl vector42
vector42:
  pushl $0
801064f5:	6a 00                	push   $0x0
  pushl $42
801064f7:	6a 2a                	push   $0x2a
  jmp alltraps
801064f9:	e9 d0 f9 ff ff       	jmp    80105ece <alltraps>

801064fe <vector43>:
.globl vector43
vector43:
  pushl $0
801064fe:	6a 00                	push   $0x0
  pushl $43
80106500:	6a 2b                	push   $0x2b
  jmp alltraps
80106502:	e9 c7 f9 ff ff       	jmp    80105ece <alltraps>

80106507 <vector44>:
.globl vector44
vector44:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $44
80106509:	6a 2c                	push   $0x2c
  jmp alltraps
8010650b:	e9 be f9 ff ff       	jmp    80105ece <alltraps>

80106510 <vector45>:
.globl vector45
vector45:
  pushl $0
80106510:	6a 00                	push   $0x0
  pushl $45
80106512:	6a 2d                	push   $0x2d
  jmp alltraps
80106514:	e9 b5 f9 ff ff       	jmp    80105ece <alltraps>

80106519 <vector46>:
.globl vector46
vector46:
  pushl $0
80106519:	6a 00                	push   $0x0
  pushl $46
8010651b:	6a 2e                	push   $0x2e
  jmp alltraps
8010651d:	e9 ac f9 ff ff       	jmp    80105ece <alltraps>

80106522 <vector47>:
.globl vector47
vector47:
  pushl $0
80106522:	6a 00                	push   $0x0
  pushl $47
80106524:	6a 2f                	push   $0x2f
  jmp alltraps
80106526:	e9 a3 f9 ff ff       	jmp    80105ece <alltraps>

8010652b <vector48>:
.globl vector48
vector48:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $48
8010652d:	6a 30                	push   $0x30
  jmp alltraps
8010652f:	e9 9a f9 ff ff       	jmp    80105ece <alltraps>

80106534 <vector49>:
.globl vector49
vector49:
  pushl $0
80106534:	6a 00                	push   $0x0
  pushl $49
80106536:	6a 31                	push   $0x31
  jmp alltraps
80106538:	e9 91 f9 ff ff       	jmp    80105ece <alltraps>

8010653d <vector50>:
.globl vector50
vector50:
  pushl $0
8010653d:	6a 00                	push   $0x0
  pushl $50
8010653f:	6a 32                	push   $0x32
  jmp alltraps
80106541:	e9 88 f9 ff ff       	jmp    80105ece <alltraps>

80106546 <vector51>:
.globl vector51
vector51:
  pushl $0
80106546:	6a 00                	push   $0x0
  pushl $51
80106548:	6a 33                	push   $0x33
  jmp alltraps
8010654a:	e9 7f f9 ff ff       	jmp    80105ece <alltraps>

8010654f <vector52>:
.globl vector52
vector52:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $52
80106551:	6a 34                	push   $0x34
  jmp alltraps
80106553:	e9 76 f9 ff ff       	jmp    80105ece <alltraps>

80106558 <vector53>:
.globl vector53
vector53:
  pushl $0
80106558:	6a 00                	push   $0x0
  pushl $53
8010655a:	6a 35                	push   $0x35
  jmp alltraps
8010655c:	e9 6d f9 ff ff       	jmp    80105ece <alltraps>

80106561 <vector54>:
.globl vector54
vector54:
  pushl $0
80106561:	6a 00                	push   $0x0
  pushl $54
80106563:	6a 36                	push   $0x36
  jmp alltraps
80106565:	e9 64 f9 ff ff       	jmp    80105ece <alltraps>

8010656a <vector55>:
.globl vector55
vector55:
  pushl $0
8010656a:	6a 00                	push   $0x0
  pushl $55
8010656c:	6a 37                	push   $0x37
  jmp alltraps
8010656e:	e9 5b f9 ff ff       	jmp    80105ece <alltraps>

80106573 <vector56>:
.globl vector56
vector56:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $56
80106575:	6a 38                	push   $0x38
  jmp alltraps
80106577:	e9 52 f9 ff ff       	jmp    80105ece <alltraps>

8010657c <vector57>:
.globl vector57
vector57:
  pushl $0
8010657c:	6a 00                	push   $0x0
  pushl $57
8010657e:	6a 39                	push   $0x39
  jmp alltraps
80106580:	e9 49 f9 ff ff       	jmp    80105ece <alltraps>

80106585 <vector58>:
.globl vector58
vector58:
  pushl $0
80106585:	6a 00                	push   $0x0
  pushl $58
80106587:	6a 3a                	push   $0x3a
  jmp alltraps
80106589:	e9 40 f9 ff ff       	jmp    80105ece <alltraps>

8010658e <vector59>:
.globl vector59
vector59:
  pushl $0
8010658e:	6a 00                	push   $0x0
  pushl $59
80106590:	6a 3b                	push   $0x3b
  jmp alltraps
80106592:	e9 37 f9 ff ff       	jmp    80105ece <alltraps>

80106597 <vector60>:
.globl vector60
vector60:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $60
80106599:	6a 3c                	push   $0x3c
  jmp alltraps
8010659b:	e9 2e f9 ff ff       	jmp    80105ece <alltraps>

801065a0 <vector61>:
.globl vector61
vector61:
  pushl $0
801065a0:	6a 00                	push   $0x0
  pushl $61
801065a2:	6a 3d                	push   $0x3d
  jmp alltraps
801065a4:	e9 25 f9 ff ff       	jmp    80105ece <alltraps>

801065a9 <vector62>:
.globl vector62
vector62:
  pushl $0
801065a9:	6a 00                	push   $0x0
  pushl $62
801065ab:	6a 3e                	push   $0x3e
  jmp alltraps
801065ad:	e9 1c f9 ff ff       	jmp    80105ece <alltraps>

801065b2 <vector63>:
.globl vector63
vector63:
  pushl $0
801065b2:	6a 00                	push   $0x0
  pushl $63
801065b4:	6a 3f                	push   $0x3f
  jmp alltraps
801065b6:	e9 13 f9 ff ff       	jmp    80105ece <alltraps>

801065bb <vector64>:
.globl vector64
vector64:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $64
801065bd:	6a 40                	push   $0x40
  jmp alltraps
801065bf:	e9 0a f9 ff ff       	jmp    80105ece <alltraps>

801065c4 <vector65>:
.globl vector65
vector65:
  pushl $0
801065c4:	6a 00                	push   $0x0
  pushl $65
801065c6:	6a 41                	push   $0x41
  jmp alltraps
801065c8:	e9 01 f9 ff ff       	jmp    80105ece <alltraps>

801065cd <vector66>:
.globl vector66
vector66:
  pushl $0
801065cd:	6a 00                	push   $0x0
  pushl $66
801065cf:	6a 42                	push   $0x42
  jmp alltraps
801065d1:	e9 f8 f8 ff ff       	jmp    80105ece <alltraps>

801065d6 <vector67>:
.globl vector67
vector67:
  pushl $0
801065d6:	6a 00                	push   $0x0
  pushl $67
801065d8:	6a 43                	push   $0x43
  jmp alltraps
801065da:	e9 ef f8 ff ff       	jmp    80105ece <alltraps>

801065df <vector68>:
.globl vector68
vector68:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $68
801065e1:	6a 44                	push   $0x44
  jmp alltraps
801065e3:	e9 e6 f8 ff ff       	jmp    80105ece <alltraps>

801065e8 <vector69>:
.globl vector69
vector69:
  pushl $0
801065e8:	6a 00                	push   $0x0
  pushl $69
801065ea:	6a 45                	push   $0x45
  jmp alltraps
801065ec:	e9 dd f8 ff ff       	jmp    80105ece <alltraps>

801065f1 <vector70>:
.globl vector70
vector70:
  pushl $0
801065f1:	6a 00                	push   $0x0
  pushl $70
801065f3:	6a 46                	push   $0x46
  jmp alltraps
801065f5:	e9 d4 f8 ff ff       	jmp    80105ece <alltraps>

801065fa <vector71>:
.globl vector71
vector71:
  pushl $0
801065fa:	6a 00                	push   $0x0
  pushl $71
801065fc:	6a 47                	push   $0x47
  jmp alltraps
801065fe:	e9 cb f8 ff ff       	jmp    80105ece <alltraps>

80106603 <vector72>:
.globl vector72
vector72:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $72
80106605:	6a 48                	push   $0x48
  jmp alltraps
80106607:	e9 c2 f8 ff ff       	jmp    80105ece <alltraps>

8010660c <vector73>:
.globl vector73
vector73:
  pushl $0
8010660c:	6a 00                	push   $0x0
  pushl $73
8010660e:	6a 49                	push   $0x49
  jmp alltraps
80106610:	e9 b9 f8 ff ff       	jmp    80105ece <alltraps>

80106615 <vector74>:
.globl vector74
vector74:
  pushl $0
80106615:	6a 00                	push   $0x0
  pushl $74
80106617:	6a 4a                	push   $0x4a
  jmp alltraps
80106619:	e9 b0 f8 ff ff       	jmp    80105ece <alltraps>

8010661e <vector75>:
.globl vector75
vector75:
  pushl $0
8010661e:	6a 00                	push   $0x0
  pushl $75
80106620:	6a 4b                	push   $0x4b
  jmp alltraps
80106622:	e9 a7 f8 ff ff       	jmp    80105ece <alltraps>

80106627 <vector76>:
.globl vector76
vector76:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $76
80106629:	6a 4c                	push   $0x4c
  jmp alltraps
8010662b:	e9 9e f8 ff ff       	jmp    80105ece <alltraps>

80106630 <vector77>:
.globl vector77
vector77:
  pushl $0
80106630:	6a 00                	push   $0x0
  pushl $77
80106632:	6a 4d                	push   $0x4d
  jmp alltraps
80106634:	e9 95 f8 ff ff       	jmp    80105ece <alltraps>

80106639 <vector78>:
.globl vector78
vector78:
  pushl $0
80106639:	6a 00                	push   $0x0
  pushl $78
8010663b:	6a 4e                	push   $0x4e
  jmp alltraps
8010663d:	e9 8c f8 ff ff       	jmp    80105ece <alltraps>

80106642 <vector79>:
.globl vector79
vector79:
  pushl $0
80106642:	6a 00                	push   $0x0
  pushl $79
80106644:	6a 4f                	push   $0x4f
  jmp alltraps
80106646:	e9 83 f8 ff ff       	jmp    80105ece <alltraps>

8010664b <vector80>:
.globl vector80
vector80:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $80
8010664d:	6a 50                	push   $0x50
  jmp alltraps
8010664f:	e9 7a f8 ff ff       	jmp    80105ece <alltraps>

80106654 <vector81>:
.globl vector81
vector81:
  pushl $0
80106654:	6a 00                	push   $0x0
  pushl $81
80106656:	6a 51                	push   $0x51
  jmp alltraps
80106658:	e9 71 f8 ff ff       	jmp    80105ece <alltraps>

8010665d <vector82>:
.globl vector82
vector82:
  pushl $0
8010665d:	6a 00                	push   $0x0
  pushl $82
8010665f:	6a 52                	push   $0x52
  jmp alltraps
80106661:	e9 68 f8 ff ff       	jmp    80105ece <alltraps>

80106666 <vector83>:
.globl vector83
vector83:
  pushl $0
80106666:	6a 00                	push   $0x0
  pushl $83
80106668:	6a 53                	push   $0x53
  jmp alltraps
8010666a:	e9 5f f8 ff ff       	jmp    80105ece <alltraps>

8010666f <vector84>:
.globl vector84
vector84:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $84
80106671:	6a 54                	push   $0x54
  jmp alltraps
80106673:	e9 56 f8 ff ff       	jmp    80105ece <alltraps>

80106678 <vector85>:
.globl vector85
vector85:
  pushl $0
80106678:	6a 00                	push   $0x0
  pushl $85
8010667a:	6a 55                	push   $0x55
  jmp alltraps
8010667c:	e9 4d f8 ff ff       	jmp    80105ece <alltraps>

80106681 <vector86>:
.globl vector86
vector86:
  pushl $0
80106681:	6a 00                	push   $0x0
  pushl $86
80106683:	6a 56                	push   $0x56
  jmp alltraps
80106685:	e9 44 f8 ff ff       	jmp    80105ece <alltraps>

8010668a <vector87>:
.globl vector87
vector87:
  pushl $0
8010668a:	6a 00                	push   $0x0
  pushl $87
8010668c:	6a 57                	push   $0x57
  jmp alltraps
8010668e:	e9 3b f8 ff ff       	jmp    80105ece <alltraps>

80106693 <vector88>:
.globl vector88
vector88:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $88
80106695:	6a 58                	push   $0x58
  jmp alltraps
80106697:	e9 32 f8 ff ff       	jmp    80105ece <alltraps>

8010669c <vector89>:
.globl vector89
vector89:
  pushl $0
8010669c:	6a 00                	push   $0x0
  pushl $89
8010669e:	6a 59                	push   $0x59
  jmp alltraps
801066a0:	e9 29 f8 ff ff       	jmp    80105ece <alltraps>

801066a5 <vector90>:
.globl vector90
vector90:
  pushl $0
801066a5:	6a 00                	push   $0x0
  pushl $90
801066a7:	6a 5a                	push   $0x5a
  jmp alltraps
801066a9:	e9 20 f8 ff ff       	jmp    80105ece <alltraps>

801066ae <vector91>:
.globl vector91
vector91:
  pushl $0
801066ae:	6a 00                	push   $0x0
  pushl $91
801066b0:	6a 5b                	push   $0x5b
  jmp alltraps
801066b2:	e9 17 f8 ff ff       	jmp    80105ece <alltraps>

801066b7 <vector92>:
.globl vector92
vector92:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $92
801066b9:	6a 5c                	push   $0x5c
  jmp alltraps
801066bb:	e9 0e f8 ff ff       	jmp    80105ece <alltraps>

801066c0 <vector93>:
.globl vector93
vector93:
  pushl $0
801066c0:	6a 00                	push   $0x0
  pushl $93
801066c2:	6a 5d                	push   $0x5d
  jmp alltraps
801066c4:	e9 05 f8 ff ff       	jmp    80105ece <alltraps>

801066c9 <vector94>:
.globl vector94
vector94:
  pushl $0
801066c9:	6a 00                	push   $0x0
  pushl $94
801066cb:	6a 5e                	push   $0x5e
  jmp alltraps
801066cd:	e9 fc f7 ff ff       	jmp    80105ece <alltraps>

801066d2 <vector95>:
.globl vector95
vector95:
  pushl $0
801066d2:	6a 00                	push   $0x0
  pushl $95
801066d4:	6a 5f                	push   $0x5f
  jmp alltraps
801066d6:	e9 f3 f7 ff ff       	jmp    80105ece <alltraps>

801066db <vector96>:
.globl vector96
vector96:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $96
801066dd:	6a 60                	push   $0x60
  jmp alltraps
801066df:	e9 ea f7 ff ff       	jmp    80105ece <alltraps>

801066e4 <vector97>:
.globl vector97
vector97:
  pushl $0
801066e4:	6a 00                	push   $0x0
  pushl $97
801066e6:	6a 61                	push   $0x61
  jmp alltraps
801066e8:	e9 e1 f7 ff ff       	jmp    80105ece <alltraps>

801066ed <vector98>:
.globl vector98
vector98:
  pushl $0
801066ed:	6a 00                	push   $0x0
  pushl $98
801066ef:	6a 62                	push   $0x62
  jmp alltraps
801066f1:	e9 d8 f7 ff ff       	jmp    80105ece <alltraps>

801066f6 <vector99>:
.globl vector99
vector99:
  pushl $0
801066f6:	6a 00                	push   $0x0
  pushl $99
801066f8:	6a 63                	push   $0x63
  jmp alltraps
801066fa:	e9 cf f7 ff ff       	jmp    80105ece <alltraps>

801066ff <vector100>:
.globl vector100
vector100:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $100
80106701:	6a 64                	push   $0x64
  jmp alltraps
80106703:	e9 c6 f7 ff ff       	jmp    80105ece <alltraps>

80106708 <vector101>:
.globl vector101
vector101:
  pushl $0
80106708:	6a 00                	push   $0x0
  pushl $101
8010670a:	6a 65                	push   $0x65
  jmp alltraps
8010670c:	e9 bd f7 ff ff       	jmp    80105ece <alltraps>

80106711 <vector102>:
.globl vector102
vector102:
  pushl $0
80106711:	6a 00                	push   $0x0
  pushl $102
80106713:	6a 66                	push   $0x66
  jmp alltraps
80106715:	e9 b4 f7 ff ff       	jmp    80105ece <alltraps>

8010671a <vector103>:
.globl vector103
vector103:
  pushl $0
8010671a:	6a 00                	push   $0x0
  pushl $103
8010671c:	6a 67                	push   $0x67
  jmp alltraps
8010671e:	e9 ab f7 ff ff       	jmp    80105ece <alltraps>

80106723 <vector104>:
.globl vector104
vector104:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $104
80106725:	6a 68                	push   $0x68
  jmp alltraps
80106727:	e9 a2 f7 ff ff       	jmp    80105ece <alltraps>

8010672c <vector105>:
.globl vector105
vector105:
  pushl $0
8010672c:	6a 00                	push   $0x0
  pushl $105
8010672e:	6a 69                	push   $0x69
  jmp alltraps
80106730:	e9 99 f7 ff ff       	jmp    80105ece <alltraps>

80106735 <vector106>:
.globl vector106
vector106:
  pushl $0
80106735:	6a 00                	push   $0x0
  pushl $106
80106737:	6a 6a                	push   $0x6a
  jmp alltraps
80106739:	e9 90 f7 ff ff       	jmp    80105ece <alltraps>

8010673e <vector107>:
.globl vector107
vector107:
  pushl $0
8010673e:	6a 00                	push   $0x0
  pushl $107
80106740:	6a 6b                	push   $0x6b
  jmp alltraps
80106742:	e9 87 f7 ff ff       	jmp    80105ece <alltraps>

80106747 <vector108>:
.globl vector108
vector108:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $108
80106749:	6a 6c                	push   $0x6c
  jmp alltraps
8010674b:	e9 7e f7 ff ff       	jmp    80105ece <alltraps>

80106750 <vector109>:
.globl vector109
vector109:
  pushl $0
80106750:	6a 00                	push   $0x0
  pushl $109
80106752:	6a 6d                	push   $0x6d
  jmp alltraps
80106754:	e9 75 f7 ff ff       	jmp    80105ece <alltraps>

80106759 <vector110>:
.globl vector110
vector110:
  pushl $0
80106759:	6a 00                	push   $0x0
  pushl $110
8010675b:	6a 6e                	push   $0x6e
  jmp alltraps
8010675d:	e9 6c f7 ff ff       	jmp    80105ece <alltraps>

80106762 <vector111>:
.globl vector111
vector111:
  pushl $0
80106762:	6a 00                	push   $0x0
  pushl $111
80106764:	6a 6f                	push   $0x6f
  jmp alltraps
80106766:	e9 63 f7 ff ff       	jmp    80105ece <alltraps>

8010676b <vector112>:
.globl vector112
vector112:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $112
8010676d:	6a 70                	push   $0x70
  jmp alltraps
8010676f:	e9 5a f7 ff ff       	jmp    80105ece <alltraps>

80106774 <vector113>:
.globl vector113
vector113:
  pushl $0
80106774:	6a 00                	push   $0x0
  pushl $113
80106776:	6a 71                	push   $0x71
  jmp alltraps
80106778:	e9 51 f7 ff ff       	jmp    80105ece <alltraps>

8010677d <vector114>:
.globl vector114
vector114:
  pushl $0
8010677d:	6a 00                	push   $0x0
  pushl $114
8010677f:	6a 72                	push   $0x72
  jmp alltraps
80106781:	e9 48 f7 ff ff       	jmp    80105ece <alltraps>

80106786 <vector115>:
.globl vector115
vector115:
  pushl $0
80106786:	6a 00                	push   $0x0
  pushl $115
80106788:	6a 73                	push   $0x73
  jmp alltraps
8010678a:	e9 3f f7 ff ff       	jmp    80105ece <alltraps>

8010678f <vector116>:
.globl vector116
vector116:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $116
80106791:	6a 74                	push   $0x74
  jmp alltraps
80106793:	e9 36 f7 ff ff       	jmp    80105ece <alltraps>

80106798 <vector117>:
.globl vector117
vector117:
  pushl $0
80106798:	6a 00                	push   $0x0
  pushl $117
8010679a:	6a 75                	push   $0x75
  jmp alltraps
8010679c:	e9 2d f7 ff ff       	jmp    80105ece <alltraps>

801067a1 <vector118>:
.globl vector118
vector118:
  pushl $0
801067a1:	6a 00                	push   $0x0
  pushl $118
801067a3:	6a 76                	push   $0x76
  jmp alltraps
801067a5:	e9 24 f7 ff ff       	jmp    80105ece <alltraps>

801067aa <vector119>:
.globl vector119
vector119:
  pushl $0
801067aa:	6a 00                	push   $0x0
  pushl $119
801067ac:	6a 77                	push   $0x77
  jmp alltraps
801067ae:	e9 1b f7 ff ff       	jmp    80105ece <alltraps>

801067b3 <vector120>:
.globl vector120
vector120:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $120
801067b5:	6a 78                	push   $0x78
  jmp alltraps
801067b7:	e9 12 f7 ff ff       	jmp    80105ece <alltraps>

801067bc <vector121>:
.globl vector121
vector121:
  pushl $0
801067bc:	6a 00                	push   $0x0
  pushl $121
801067be:	6a 79                	push   $0x79
  jmp alltraps
801067c0:	e9 09 f7 ff ff       	jmp    80105ece <alltraps>

801067c5 <vector122>:
.globl vector122
vector122:
  pushl $0
801067c5:	6a 00                	push   $0x0
  pushl $122
801067c7:	6a 7a                	push   $0x7a
  jmp alltraps
801067c9:	e9 00 f7 ff ff       	jmp    80105ece <alltraps>

801067ce <vector123>:
.globl vector123
vector123:
  pushl $0
801067ce:	6a 00                	push   $0x0
  pushl $123
801067d0:	6a 7b                	push   $0x7b
  jmp alltraps
801067d2:	e9 f7 f6 ff ff       	jmp    80105ece <alltraps>

801067d7 <vector124>:
.globl vector124
vector124:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $124
801067d9:	6a 7c                	push   $0x7c
  jmp alltraps
801067db:	e9 ee f6 ff ff       	jmp    80105ece <alltraps>

801067e0 <vector125>:
.globl vector125
vector125:
  pushl $0
801067e0:	6a 00                	push   $0x0
  pushl $125
801067e2:	6a 7d                	push   $0x7d
  jmp alltraps
801067e4:	e9 e5 f6 ff ff       	jmp    80105ece <alltraps>

801067e9 <vector126>:
.globl vector126
vector126:
  pushl $0
801067e9:	6a 00                	push   $0x0
  pushl $126
801067eb:	6a 7e                	push   $0x7e
  jmp alltraps
801067ed:	e9 dc f6 ff ff       	jmp    80105ece <alltraps>

801067f2 <vector127>:
.globl vector127
vector127:
  pushl $0
801067f2:	6a 00                	push   $0x0
  pushl $127
801067f4:	6a 7f                	push   $0x7f
  jmp alltraps
801067f6:	e9 d3 f6 ff ff       	jmp    80105ece <alltraps>

801067fb <vector128>:
.globl vector128
vector128:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $128
801067fd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106802:	e9 c7 f6 ff ff       	jmp    80105ece <alltraps>

80106807 <vector129>:
.globl vector129
vector129:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $129
80106809:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010680e:	e9 bb f6 ff ff       	jmp    80105ece <alltraps>

80106813 <vector130>:
.globl vector130
vector130:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $130
80106815:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010681a:	e9 af f6 ff ff       	jmp    80105ece <alltraps>

8010681f <vector131>:
.globl vector131
vector131:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $131
80106821:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106826:	e9 a3 f6 ff ff       	jmp    80105ece <alltraps>

8010682b <vector132>:
.globl vector132
vector132:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $132
8010682d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106832:	e9 97 f6 ff ff       	jmp    80105ece <alltraps>

80106837 <vector133>:
.globl vector133
vector133:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $133
80106839:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010683e:	e9 8b f6 ff ff       	jmp    80105ece <alltraps>

80106843 <vector134>:
.globl vector134
vector134:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $134
80106845:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010684a:	e9 7f f6 ff ff       	jmp    80105ece <alltraps>

8010684f <vector135>:
.globl vector135
vector135:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $135
80106851:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106856:	e9 73 f6 ff ff       	jmp    80105ece <alltraps>

8010685b <vector136>:
.globl vector136
vector136:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $136
8010685d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106862:	e9 67 f6 ff ff       	jmp    80105ece <alltraps>

80106867 <vector137>:
.globl vector137
vector137:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $137
80106869:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010686e:	e9 5b f6 ff ff       	jmp    80105ece <alltraps>

80106873 <vector138>:
.globl vector138
vector138:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $138
80106875:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010687a:	e9 4f f6 ff ff       	jmp    80105ece <alltraps>

8010687f <vector139>:
.globl vector139
vector139:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $139
80106881:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106886:	e9 43 f6 ff ff       	jmp    80105ece <alltraps>

8010688b <vector140>:
.globl vector140
vector140:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $140
8010688d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106892:	e9 37 f6 ff ff       	jmp    80105ece <alltraps>

80106897 <vector141>:
.globl vector141
vector141:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $141
80106899:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010689e:	e9 2b f6 ff ff       	jmp    80105ece <alltraps>

801068a3 <vector142>:
.globl vector142
vector142:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $142
801068a5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801068aa:	e9 1f f6 ff ff       	jmp    80105ece <alltraps>

801068af <vector143>:
.globl vector143
vector143:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $143
801068b1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801068b6:	e9 13 f6 ff ff       	jmp    80105ece <alltraps>

801068bb <vector144>:
.globl vector144
vector144:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $144
801068bd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801068c2:	e9 07 f6 ff ff       	jmp    80105ece <alltraps>

801068c7 <vector145>:
.globl vector145
vector145:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $145
801068c9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801068ce:	e9 fb f5 ff ff       	jmp    80105ece <alltraps>

801068d3 <vector146>:
.globl vector146
vector146:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $146
801068d5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801068da:	e9 ef f5 ff ff       	jmp    80105ece <alltraps>

801068df <vector147>:
.globl vector147
vector147:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $147
801068e1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801068e6:	e9 e3 f5 ff ff       	jmp    80105ece <alltraps>

801068eb <vector148>:
.globl vector148
vector148:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $148
801068ed:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801068f2:	e9 d7 f5 ff ff       	jmp    80105ece <alltraps>

801068f7 <vector149>:
.globl vector149
vector149:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $149
801068f9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801068fe:	e9 cb f5 ff ff       	jmp    80105ece <alltraps>

80106903 <vector150>:
.globl vector150
vector150:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $150
80106905:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010690a:	e9 bf f5 ff ff       	jmp    80105ece <alltraps>

8010690f <vector151>:
.globl vector151
vector151:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $151
80106911:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106916:	e9 b3 f5 ff ff       	jmp    80105ece <alltraps>

8010691b <vector152>:
.globl vector152
vector152:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $152
8010691d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106922:	e9 a7 f5 ff ff       	jmp    80105ece <alltraps>

80106927 <vector153>:
.globl vector153
vector153:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $153
80106929:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010692e:	e9 9b f5 ff ff       	jmp    80105ece <alltraps>

80106933 <vector154>:
.globl vector154
vector154:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $154
80106935:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010693a:	e9 8f f5 ff ff       	jmp    80105ece <alltraps>

8010693f <vector155>:
.globl vector155
vector155:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $155
80106941:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106946:	e9 83 f5 ff ff       	jmp    80105ece <alltraps>

8010694b <vector156>:
.globl vector156
vector156:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $156
8010694d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106952:	e9 77 f5 ff ff       	jmp    80105ece <alltraps>

80106957 <vector157>:
.globl vector157
vector157:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $157
80106959:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010695e:	e9 6b f5 ff ff       	jmp    80105ece <alltraps>

80106963 <vector158>:
.globl vector158
vector158:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $158
80106965:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010696a:	e9 5f f5 ff ff       	jmp    80105ece <alltraps>

8010696f <vector159>:
.globl vector159
vector159:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $159
80106971:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106976:	e9 53 f5 ff ff       	jmp    80105ece <alltraps>

8010697b <vector160>:
.globl vector160
vector160:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $160
8010697d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106982:	e9 47 f5 ff ff       	jmp    80105ece <alltraps>

80106987 <vector161>:
.globl vector161
vector161:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $161
80106989:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010698e:	e9 3b f5 ff ff       	jmp    80105ece <alltraps>

80106993 <vector162>:
.globl vector162
vector162:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $162
80106995:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010699a:	e9 2f f5 ff ff       	jmp    80105ece <alltraps>

8010699f <vector163>:
.globl vector163
vector163:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $163
801069a1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801069a6:	e9 23 f5 ff ff       	jmp    80105ece <alltraps>

801069ab <vector164>:
.globl vector164
vector164:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $164
801069ad:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801069b2:	e9 17 f5 ff ff       	jmp    80105ece <alltraps>

801069b7 <vector165>:
.globl vector165
vector165:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $165
801069b9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801069be:	e9 0b f5 ff ff       	jmp    80105ece <alltraps>

801069c3 <vector166>:
.globl vector166
vector166:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $166
801069c5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801069ca:	e9 ff f4 ff ff       	jmp    80105ece <alltraps>

801069cf <vector167>:
.globl vector167
vector167:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $167
801069d1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801069d6:	e9 f3 f4 ff ff       	jmp    80105ece <alltraps>

801069db <vector168>:
.globl vector168
vector168:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $168
801069dd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801069e2:	e9 e7 f4 ff ff       	jmp    80105ece <alltraps>

801069e7 <vector169>:
.globl vector169
vector169:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $169
801069e9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801069ee:	e9 db f4 ff ff       	jmp    80105ece <alltraps>

801069f3 <vector170>:
.globl vector170
vector170:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $170
801069f5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801069fa:	e9 cf f4 ff ff       	jmp    80105ece <alltraps>

801069ff <vector171>:
.globl vector171
vector171:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $171
80106a01:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106a06:	e9 c3 f4 ff ff       	jmp    80105ece <alltraps>

80106a0b <vector172>:
.globl vector172
vector172:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $172
80106a0d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106a12:	e9 b7 f4 ff ff       	jmp    80105ece <alltraps>

80106a17 <vector173>:
.globl vector173
vector173:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $173
80106a19:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106a1e:	e9 ab f4 ff ff       	jmp    80105ece <alltraps>

80106a23 <vector174>:
.globl vector174
vector174:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $174
80106a25:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106a2a:	e9 9f f4 ff ff       	jmp    80105ece <alltraps>

80106a2f <vector175>:
.globl vector175
vector175:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $175
80106a31:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106a36:	e9 93 f4 ff ff       	jmp    80105ece <alltraps>

80106a3b <vector176>:
.globl vector176
vector176:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $176
80106a3d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106a42:	e9 87 f4 ff ff       	jmp    80105ece <alltraps>

80106a47 <vector177>:
.globl vector177
vector177:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $177
80106a49:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106a4e:	e9 7b f4 ff ff       	jmp    80105ece <alltraps>

80106a53 <vector178>:
.globl vector178
vector178:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $178
80106a55:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106a5a:	e9 6f f4 ff ff       	jmp    80105ece <alltraps>

80106a5f <vector179>:
.globl vector179
vector179:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $179
80106a61:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106a66:	e9 63 f4 ff ff       	jmp    80105ece <alltraps>

80106a6b <vector180>:
.globl vector180
vector180:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $180
80106a6d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106a72:	e9 57 f4 ff ff       	jmp    80105ece <alltraps>

80106a77 <vector181>:
.globl vector181
vector181:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $181
80106a79:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106a7e:	e9 4b f4 ff ff       	jmp    80105ece <alltraps>

80106a83 <vector182>:
.globl vector182
vector182:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $182
80106a85:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106a8a:	e9 3f f4 ff ff       	jmp    80105ece <alltraps>

80106a8f <vector183>:
.globl vector183
vector183:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $183
80106a91:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106a96:	e9 33 f4 ff ff       	jmp    80105ece <alltraps>

80106a9b <vector184>:
.globl vector184
vector184:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $184
80106a9d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106aa2:	e9 27 f4 ff ff       	jmp    80105ece <alltraps>

80106aa7 <vector185>:
.globl vector185
vector185:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $185
80106aa9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106aae:	e9 1b f4 ff ff       	jmp    80105ece <alltraps>

80106ab3 <vector186>:
.globl vector186
vector186:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $186
80106ab5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106aba:	e9 0f f4 ff ff       	jmp    80105ece <alltraps>

80106abf <vector187>:
.globl vector187
vector187:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $187
80106ac1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ac6:	e9 03 f4 ff ff       	jmp    80105ece <alltraps>

80106acb <vector188>:
.globl vector188
vector188:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $188
80106acd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106ad2:	e9 f7 f3 ff ff       	jmp    80105ece <alltraps>

80106ad7 <vector189>:
.globl vector189
vector189:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $189
80106ad9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106ade:	e9 eb f3 ff ff       	jmp    80105ece <alltraps>

80106ae3 <vector190>:
.globl vector190
vector190:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $190
80106ae5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106aea:	e9 df f3 ff ff       	jmp    80105ece <alltraps>

80106aef <vector191>:
.globl vector191
vector191:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $191
80106af1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106af6:	e9 d3 f3 ff ff       	jmp    80105ece <alltraps>

80106afb <vector192>:
.globl vector192
vector192:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $192
80106afd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b02:	e9 c7 f3 ff ff       	jmp    80105ece <alltraps>

80106b07 <vector193>:
.globl vector193
vector193:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $193
80106b09:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106b0e:	e9 bb f3 ff ff       	jmp    80105ece <alltraps>

80106b13 <vector194>:
.globl vector194
vector194:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $194
80106b15:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106b1a:	e9 af f3 ff ff       	jmp    80105ece <alltraps>

80106b1f <vector195>:
.globl vector195
vector195:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $195
80106b21:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106b26:	e9 a3 f3 ff ff       	jmp    80105ece <alltraps>

80106b2b <vector196>:
.globl vector196
vector196:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $196
80106b2d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106b32:	e9 97 f3 ff ff       	jmp    80105ece <alltraps>

80106b37 <vector197>:
.globl vector197
vector197:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $197
80106b39:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106b3e:	e9 8b f3 ff ff       	jmp    80105ece <alltraps>

80106b43 <vector198>:
.globl vector198
vector198:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $198
80106b45:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106b4a:	e9 7f f3 ff ff       	jmp    80105ece <alltraps>

80106b4f <vector199>:
.globl vector199
vector199:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $199
80106b51:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106b56:	e9 73 f3 ff ff       	jmp    80105ece <alltraps>

80106b5b <vector200>:
.globl vector200
vector200:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $200
80106b5d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106b62:	e9 67 f3 ff ff       	jmp    80105ece <alltraps>

80106b67 <vector201>:
.globl vector201
vector201:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $201
80106b69:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106b6e:	e9 5b f3 ff ff       	jmp    80105ece <alltraps>

80106b73 <vector202>:
.globl vector202
vector202:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $202
80106b75:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106b7a:	e9 4f f3 ff ff       	jmp    80105ece <alltraps>

80106b7f <vector203>:
.globl vector203
vector203:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $203
80106b81:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106b86:	e9 43 f3 ff ff       	jmp    80105ece <alltraps>

80106b8b <vector204>:
.globl vector204
vector204:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $204
80106b8d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106b92:	e9 37 f3 ff ff       	jmp    80105ece <alltraps>

80106b97 <vector205>:
.globl vector205
vector205:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $205
80106b99:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106b9e:	e9 2b f3 ff ff       	jmp    80105ece <alltraps>

80106ba3 <vector206>:
.globl vector206
vector206:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $206
80106ba5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106baa:	e9 1f f3 ff ff       	jmp    80105ece <alltraps>

80106baf <vector207>:
.globl vector207
vector207:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $207
80106bb1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106bb6:	e9 13 f3 ff ff       	jmp    80105ece <alltraps>

80106bbb <vector208>:
.globl vector208
vector208:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $208
80106bbd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106bc2:	e9 07 f3 ff ff       	jmp    80105ece <alltraps>

80106bc7 <vector209>:
.globl vector209
vector209:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $209
80106bc9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106bce:	e9 fb f2 ff ff       	jmp    80105ece <alltraps>

80106bd3 <vector210>:
.globl vector210
vector210:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $210
80106bd5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106bda:	e9 ef f2 ff ff       	jmp    80105ece <alltraps>

80106bdf <vector211>:
.globl vector211
vector211:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $211
80106be1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106be6:	e9 e3 f2 ff ff       	jmp    80105ece <alltraps>

80106beb <vector212>:
.globl vector212
vector212:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $212
80106bed:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106bf2:	e9 d7 f2 ff ff       	jmp    80105ece <alltraps>

80106bf7 <vector213>:
.globl vector213
vector213:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $213
80106bf9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106bfe:	e9 cb f2 ff ff       	jmp    80105ece <alltraps>

80106c03 <vector214>:
.globl vector214
vector214:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $214
80106c05:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106c0a:	e9 bf f2 ff ff       	jmp    80105ece <alltraps>

80106c0f <vector215>:
.globl vector215
vector215:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $215
80106c11:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106c16:	e9 b3 f2 ff ff       	jmp    80105ece <alltraps>

80106c1b <vector216>:
.globl vector216
vector216:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $216
80106c1d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106c22:	e9 a7 f2 ff ff       	jmp    80105ece <alltraps>

80106c27 <vector217>:
.globl vector217
vector217:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $217
80106c29:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106c2e:	e9 9b f2 ff ff       	jmp    80105ece <alltraps>

80106c33 <vector218>:
.globl vector218
vector218:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $218
80106c35:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106c3a:	e9 8f f2 ff ff       	jmp    80105ece <alltraps>

80106c3f <vector219>:
.globl vector219
vector219:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $219
80106c41:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106c46:	e9 83 f2 ff ff       	jmp    80105ece <alltraps>

80106c4b <vector220>:
.globl vector220
vector220:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $220
80106c4d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106c52:	e9 77 f2 ff ff       	jmp    80105ece <alltraps>

80106c57 <vector221>:
.globl vector221
vector221:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $221
80106c59:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106c5e:	e9 6b f2 ff ff       	jmp    80105ece <alltraps>

80106c63 <vector222>:
.globl vector222
vector222:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $222
80106c65:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106c6a:	e9 5f f2 ff ff       	jmp    80105ece <alltraps>

80106c6f <vector223>:
.globl vector223
vector223:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $223
80106c71:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106c76:	e9 53 f2 ff ff       	jmp    80105ece <alltraps>

80106c7b <vector224>:
.globl vector224
vector224:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $224
80106c7d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106c82:	e9 47 f2 ff ff       	jmp    80105ece <alltraps>

80106c87 <vector225>:
.globl vector225
vector225:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $225
80106c89:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106c8e:	e9 3b f2 ff ff       	jmp    80105ece <alltraps>

80106c93 <vector226>:
.globl vector226
vector226:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $226
80106c95:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106c9a:	e9 2f f2 ff ff       	jmp    80105ece <alltraps>

80106c9f <vector227>:
.globl vector227
vector227:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $227
80106ca1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ca6:	e9 23 f2 ff ff       	jmp    80105ece <alltraps>

80106cab <vector228>:
.globl vector228
vector228:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $228
80106cad:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106cb2:	e9 17 f2 ff ff       	jmp    80105ece <alltraps>

80106cb7 <vector229>:
.globl vector229
vector229:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $229
80106cb9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106cbe:	e9 0b f2 ff ff       	jmp    80105ece <alltraps>

80106cc3 <vector230>:
.globl vector230
vector230:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $230
80106cc5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106cca:	e9 ff f1 ff ff       	jmp    80105ece <alltraps>

80106ccf <vector231>:
.globl vector231
vector231:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $231
80106cd1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106cd6:	e9 f3 f1 ff ff       	jmp    80105ece <alltraps>

80106cdb <vector232>:
.globl vector232
vector232:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $232
80106cdd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106ce2:	e9 e7 f1 ff ff       	jmp    80105ece <alltraps>

80106ce7 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $233
80106ce9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106cee:	e9 db f1 ff ff       	jmp    80105ece <alltraps>

80106cf3 <vector234>:
.globl vector234
vector234:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $234
80106cf5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106cfa:	e9 cf f1 ff ff       	jmp    80105ece <alltraps>

80106cff <vector235>:
.globl vector235
vector235:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $235
80106d01:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106d06:	e9 c3 f1 ff ff       	jmp    80105ece <alltraps>

80106d0b <vector236>:
.globl vector236
vector236:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $236
80106d0d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106d12:	e9 b7 f1 ff ff       	jmp    80105ece <alltraps>

80106d17 <vector237>:
.globl vector237
vector237:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $237
80106d19:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106d1e:	e9 ab f1 ff ff       	jmp    80105ece <alltraps>

80106d23 <vector238>:
.globl vector238
vector238:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $238
80106d25:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106d2a:	e9 9f f1 ff ff       	jmp    80105ece <alltraps>

80106d2f <vector239>:
.globl vector239
vector239:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $239
80106d31:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106d36:	e9 93 f1 ff ff       	jmp    80105ece <alltraps>

80106d3b <vector240>:
.globl vector240
vector240:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $240
80106d3d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106d42:	e9 87 f1 ff ff       	jmp    80105ece <alltraps>

80106d47 <vector241>:
.globl vector241
vector241:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $241
80106d49:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106d4e:	e9 7b f1 ff ff       	jmp    80105ece <alltraps>

80106d53 <vector242>:
.globl vector242
vector242:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $242
80106d55:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106d5a:	e9 6f f1 ff ff       	jmp    80105ece <alltraps>

80106d5f <vector243>:
.globl vector243
vector243:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $243
80106d61:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106d66:	e9 63 f1 ff ff       	jmp    80105ece <alltraps>

80106d6b <vector244>:
.globl vector244
vector244:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $244
80106d6d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106d72:	e9 57 f1 ff ff       	jmp    80105ece <alltraps>

80106d77 <vector245>:
.globl vector245
vector245:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $245
80106d79:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106d7e:	e9 4b f1 ff ff       	jmp    80105ece <alltraps>

80106d83 <vector246>:
.globl vector246
vector246:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $246
80106d85:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106d8a:	e9 3f f1 ff ff       	jmp    80105ece <alltraps>

80106d8f <vector247>:
.globl vector247
vector247:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $247
80106d91:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106d96:	e9 33 f1 ff ff       	jmp    80105ece <alltraps>

80106d9b <vector248>:
.globl vector248
vector248:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $248
80106d9d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106da2:	e9 27 f1 ff ff       	jmp    80105ece <alltraps>

80106da7 <vector249>:
.globl vector249
vector249:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $249
80106da9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106dae:	e9 1b f1 ff ff       	jmp    80105ece <alltraps>

80106db3 <vector250>:
.globl vector250
vector250:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $250
80106db5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106dba:	e9 0f f1 ff ff       	jmp    80105ece <alltraps>

80106dbf <vector251>:
.globl vector251
vector251:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $251
80106dc1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106dc6:	e9 03 f1 ff ff       	jmp    80105ece <alltraps>

80106dcb <vector252>:
.globl vector252
vector252:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $252
80106dcd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106dd2:	e9 f7 f0 ff ff       	jmp    80105ece <alltraps>

80106dd7 <vector253>:
.globl vector253
vector253:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $253
80106dd9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106dde:	e9 eb f0 ff ff       	jmp    80105ece <alltraps>

80106de3 <vector254>:
.globl vector254
vector254:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $254
80106de5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106dea:	e9 df f0 ff ff       	jmp    80105ece <alltraps>

80106def <vector255>:
.globl vector255
vector255:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $255
80106df1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106df6:	e9 d3 f0 ff ff       	jmp    80105ece <alltraps>
80106dfb:	66 90                	xchg   %ax,%ax
80106dfd:	66 90                	xchg   %ax,%ax
80106dff:	90                   	nop

80106e00 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	57                   	push   %edi
80106e04:	56                   	push   %esi
80106e05:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106e07:	c1 ea 16             	shr    $0x16,%edx
{
80106e0a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106e0b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106e0e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106e11:	8b 1f                	mov    (%edi),%ebx
80106e13:	f6 c3 01             	test   $0x1,%bl
80106e16:	74 28                	je     80106e40 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e18:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106e1e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106e24:	89 f0                	mov    %esi,%eax
}
80106e26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106e29:	c1 e8 0a             	shr    $0xa,%eax
80106e2c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e31:	01 d8                	add    %ebx,%eax
}
80106e33:	5b                   	pop    %ebx
80106e34:	5e                   	pop    %esi
80106e35:	5f                   	pop    %edi
80106e36:	5d                   	pop    %ebp
80106e37:	c3                   	ret    
80106e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e3f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e40:	85 c9                	test   %ecx,%ecx
80106e42:	74 2c                	je     80106e70 <walkpgdir+0x70>
80106e44:	e8 47 be ff ff       	call   80102c90 <kalloc>
80106e49:	89 c3                	mov    %eax,%ebx
80106e4b:	85 c0                	test   %eax,%eax
80106e4d:	74 21                	je     80106e70 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106e4f:	83 ec 04             	sub    $0x4,%esp
80106e52:	68 00 10 00 00       	push   $0x1000
80106e57:	6a 00                	push   $0x0
80106e59:	50                   	push   %eax
80106e5a:	e8 71 de ff ff       	call   80104cd0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e5f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e65:	83 c4 10             	add    $0x10,%esp
80106e68:	83 c8 07             	or     $0x7,%eax
80106e6b:	89 07                	mov    %eax,(%edi)
80106e6d:	eb b5                	jmp    80106e24 <walkpgdir+0x24>
80106e6f:	90                   	nop
}
80106e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106e73:	31 c0                	xor    %eax,%eax
}
80106e75:	5b                   	pop    %ebx
80106e76:	5e                   	pop    %esi
80106e77:	5f                   	pop    %edi
80106e78:	5d                   	pop    %ebp
80106e79:	c3                   	ret    
80106e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e80 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	57                   	push   %edi
80106e84:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e86:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106e8a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106e90:	89 d6                	mov    %edx,%esi
{
80106e92:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106e93:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106e99:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106e9f:	8b 45 08             	mov    0x8(%ebp),%eax
80106ea2:	29 f0                	sub    %esi,%eax
80106ea4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ea7:	eb 1f                	jmp    80106ec8 <mappages+0x48>
80106ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106eb0:	f6 00 01             	testb  $0x1,(%eax)
80106eb3:	75 45                	jne    80106efa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106eb5:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106eb8:	83 cb 01             	or     $0x1,%ebx
80106ebb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106ebd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106ec0:	74 2e                	je     80106ef0 <mappages+0x70>
      break;
    a += PGSIZE;
80106ec2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106ec8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ecb:	b9 01 00 00 00       	mov    $0x1,%ecx
80106ed0:	89 f2                	mov    %esi,%edx
80106ed2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106ed5:	89 f8                	mov    %edi,%eax
80106ed7:	e8 24 ff ff ff       	call   80106e00 <walkpgdir>
80106edc:	85 c0                	test   %eax,%eax
80106ede:	75 d0                	jne    80106eb0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ee3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ee8:	5b                   	pop    %ebx
80106ee9:	5e                   	pop    %esi
80106eea:	5f                   	pop    %edi
80106eeb:	5d                   	pop    %ebp
80106eec:	c3                   	ret    
80106eed:	8d 76 00             	lea    0x0(%esi),%esi
80106ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ef3:	31 c0                	xor    %eax,%eax
}
80106ef5:	5b                   	pop    %ebx
80106ef6:	5e                   	pop    %esi
80106ef7:	5f                   	pop    %edi
80106ef8:	5d                   	pop    %ebp
80106ef9:	c3                   	ret    
      panic("remap");
80106efa:	83 ec 0c             	sub    $0xc,%esp
80106efd:	68 08 80 10 80       	push   $0x80108008
80106f02:	e8 f9 97 ff ff       	call   80100700 <panic>
80106f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f0e:	66 90                	xchg   %ax,%ax

80106f10 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
80106f14:	56                   	push   %esi
80106f15:	89 c6                	mov    %eax,%esi
80106f17:	53                   	push   %ebx
80106f18:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106f1a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106f20:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f26:	83 ec 1c             	sub    $0x1c,%esp
80106f29:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106f2c:	39 da                	cmp    %ebx,%edx
80106f2e:	73 5b                	jae    80106f8b <deallocuvm.part.0+0x7b>
80106f30:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106f33:	89 d7                	mov    %edx,%edi
80106f35:	eb 14                	jmp    80106f4b <deallocuvm.part.0+0x3b>
80106f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f3e:	66 90                	xchg   %ax,%ax
80106f40:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106f46:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106f49:	76 40                	jbe    80106f8b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106f4b:	31 c9                	xor    %ecx,%ecx
80106f4d:	89 fa                	mov    %edi,%edx
80106f4f:	89 f0                	mov    %esi,%eax
80106f51:	e8 aa fe ff ff       	call   80106e00 <walkpgdir>
80106f56:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106f58:	85 c0                	test   %eax,%eax
80106f5a:	74 44                	je     80106fa0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106f5c:	8b 00                	mov    (%eax),%eax
80106f5e:	a8 01                	test   $0x1,%al
80106f60:	74 de                	je     80106f40 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106f62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f67:	74 47                	je     80106fb0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106f69:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106f6c:	05 00 00 00 80       	add    $0x80000000,%eax
80106f71:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106f77:	50                   	push   %eax
80106f78:	e8 53 bb ff ff       	call   80102ad0 <kfree>
      *pte = 0;
80106f7d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106f83:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106f86:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106f89:	77 c0                	ja     80106f4b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80106f8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f91:	5b                   	pop    %ebx
80106f92:	5e                   	pop    %esi
80106f93:	5f                   	pop    %edi
80106f94:	5d                   	pop    %ebp
80106f95:	c3                   	ret    
80106f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f9d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106fa0:	89 fa                	mov    %edi,%edx
80106fa2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106fa8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80106fae:	eb 96                	jmp    80106f46 <deallocuvm.part.0+0x36>
        panic("kfree");
80106fb0:	83 ec 0c             	sub    $0xc,%esp
80106fb3:	68 ce 79 10 80       	push   $0x801079ce
80106fb8:	e8 43 97 ff ff       	call   80100700 <panic>
80106fbd:	8d 76 00             	lea    0x0(%esi),%esi

80106fc0 <seginit>:
{
80106fc0:	f3 0f 1e fb          	endbr32 
80106fc4:	55                   	push   %ebp
80106fc5:	89 e5                	mov    %esp,%ebp
80106fc7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106fca:	e8 d1 cf ff ff       	call   80103fa0 <cpuid>
  pd[0] = size-1;
80106fcf:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106fd4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106fda:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106fde:	c7 80 d8 40 11 80 ff 	movl   $0xffff,-0x7feebf28(%eax)
80106fe5:	ff 00 00 
80106fe8:	c7 80 dc 40 11 80 00 	movl   $0xcf9a00,-0x7feebf24(%eax)
80106fef:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ff2:	c7 80 e0 40 11 80 ff 	movl   $0xffff,-0x7feebf20(%eax)
80106ff9:	ff 00 00 
80106ffc:	c7 80 e4 40 11 80 00 	movl   $0xcf9200,-0x7feebf1c(%eax)
80107003:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107006:	c7 80 e8 40 11 80 ff 	movl   $0xffff,-0x7feebf18(%eax)
8010700d:	ff 00 00 
80107010:	c7 80 ec 40 11 80 00 	movl   $0xcffa00,-0x7feebf14(%eax)
80107017:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010701a:	c7 80 f0 40 11 80 ff 	movl   $0xffff,-0x7feebf10(%eax)
80107021:	ff 00 00 
80107024:	c7 80 f4 40 11 80 00 	movl   $0xcff200,-0x7feebf0c(%eax)
8010702b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010702e:	05 d0 40 11 80       	add    $0x801140d0,%eax
  pd[1] = (uint)p;
80107033:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107037:	c1 e8 10             	shr    $0x10,%eax
8010703a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010703e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107041:	0f 01 10             	lgdtl  (%eax)
}
80107044:	c9                   	leave  
80107045:	c3                   	ret    
80107046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010704d:	8d 76 00             	lea    0x0(%esi),%esi

80107050 <switchkvm>:
{
80107050:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107054:	a1 84 6d 11 80       	mov    0x80116d84,%eax
80107059:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010705e:	0f 22 d8             	mov    %eax,%cr3
}
80107061:	c3                   	ret    
80107062:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107070 <switchuvm>:
{
80107070:	f3 0f 1e fb          	endbr32 
80107074:	55                   	push   %ebp
80107075:	89 e5                	mov    %esp,%ebp
80107077:	57                   	push   %edi
80107078:	56                   	push   %esi
80107079:	53                   	push   %ebx
8010707a:	83 ec 1c             	sub    $0x1c,%esp
8010707d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107080:	85 f6                	test   %esi,%esi
80107082:	0f 84 cb 00 00 00    	je     80107153 <switchuvm+0xe3>
  if(p->kstack == 0)
80107088:	8b 46 08             	mov    0x8(%esi),%eax
8010708b:	85 c0                	test   %eax,%eax
8010708d:	0f 84 da 00 00 00    	je     8010716d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107093:	8b 46 04             	mov    0x4(%esi),%eax
80107096:	85 c0                	test   %eax,%eax
80107098:	0f 84 c2 00 00 00    	je     80107160 <switchuvm+0xf0>
  pushcli();
8010709e:	e8 1d da ff ff       	call   80104ac0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801070a3:	e8 88 ce ff ff       	call   80103f30 <mycpu>
801070a8:	89 c3                	mov    %eax,%ebx
801070aa:	e8 81 ce ff ff       	call   80103f30 <mycpu>
801070af:	89 c7                	mov    %eax,%edi
801070b1:	e8 7a ce ff ff       	call   80103f30 <mycpu>
801070b6:	83 c7 08             	add    $0x8,%edi
801070b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070bc:	e8 6f ce ff ff       	call   80103f30 <mycpu>
801070c1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801070c4:	ba 67 00 00 00       	mov    $0x67,%edx
801070c9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801070d0:	83 c0 08             	add    $0x8,%eax
801070d3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801070da:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801070df:	83 c1 08             	add    $0x8,%ecx
801070e2:	c1 e8 18             	shr    $0x18,%eax
801070e5:	c1 e9 10             	shr    $0x10,%ecx
801070e8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801070ee:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801070f4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801070f9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107100:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107105:	e8 26 ce ff ff       	call   80103f30 <mycpu>
8010710a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107111:	e8 1a ce ff ff       	call   80103f30 <mycpu>
80107116:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010711a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010711d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107123:	e8 08 ce ff ff       	call   80103f30 <mycpu>
80107128:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010712b:	e8 00 ce ff ff       	call   80103f30 <mycpu>
80107130:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107134:	b8 28 00 00 00       	mov    $0x28,%eax
80107139:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010713c:	8b 46 04             	mov    0x4(%esi),%eax
8010713f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107144:	0f 22 d8             	mov    %eax,%cr3
}
80107147:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010714a:	5b                   	pop    %ebx
8010714b:	5e                   	pop    %esi
8010714c:	5f                   	pop    %edi
8010714d:	5d                   	pop    %ebp
  popcli();
8010714e:	e9 bd d9 ff ff       	jmp    80104b10 <popcli>
    panic("switchuvm: no process");
80107153:	83 ec 0c             	sub    $0xc,%esp
80107156:	68 0e 80 10 80       	push   $0x8010800e
8010715b:	e8 a0 95 ff ff       	call   80100700 <panic>
    panic("switchuvm: no pgdir");
80107160:	83 ec 0c             	sub    $0xc,%esp
80107163:	68 39 80 10 80       	push   $0x80108039
80107168:	e8 93 95 ff ff       	call   80100700 <panic>
    panic("switchuvm: no kstack");
8010716d:	83 ec 0c             	sub    $0xc,%esp
80107170:	68 24 80 10 80       	push   $0x80108024
80107175:	e8 86 95 ff ff       	call   80100700 <panic>
8010717a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107180 <inituvm>:
{
80107180:	f3 0f 1e fb          	endbr32 
80107184:	55                   	push   %ebp
80107185:	89 e5                	mov    %esp,%ebp
80107187:	57                   	push   %edi
80107188:	56                   	push   %esi
80107189:	53                   	push   %ebx
8010718a:	83 ec 1c             	sub    $0x1c,%esp
8010718d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107190:	8b 75 10             	mov    0x10(%ebp),%esi
80107193:	8b 7d 08             	mov    0x8(%ebp),%edi
80107196:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107199:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010719f:	77 4b                	ja     801071ec <inituvm+0x6c>
  mem = kalloc();
801071a1:	e8 ea ba ff ff       	call   80102c90 <kalloc>
  memset(mem, 0, PGSIZE);
801071a6:	83 ec 04             	sub    $0x4,%esp
801071a9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801071ae:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801071b0:	6a 00                	push   $0x0
801071b2:	50                   	push   %eax
801071b3:	e8 18 db ff ff       	call   80104cd0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801071b8:	58                   	pop    %eax
801071b9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071bf:	5a                   	pop    %edx
801071c0:	6a 06                	push   $0x6
801071c2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071c7:	31 d2                	xor    %edx,%edx
801071c9:	50                   	push   %eax
801071ca:	89 f8                	mov    %edi,%eax
801071cc:	e8 af fc ff ff       	call   80106e80 <mappages>
  memmove(mem, init, sz);
801071d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071d4:	89 75 10             	mov    %esi,0x10(%ebp)
801071d7:	83 c4 10             	add    $0x10,%esp
801071da:	89 5d 08             	mov    %ebx,0x8(%ebp)
801071dd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801071e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071e3:	5b                   	pop    %ebx
801071e4:	5e                   	pop    %esi
801071e5:	5f                   	pop    %edi
801071e6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801071e7:	e9 84 db ff ff       	jmp    80104d70 <memmove>
    panic("inituvm: more than a page");
801071ec:	83 ec 0c             	sub    $0xc,%esp
801071ef:	68 4d 80 10 80       	push   $0x8010804d
801071f4:	e8 07 95 ff ff       	call   80100700 <panic>
801071f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107200 <loaduvm>:
{
80107200:	f3 0f 1e fb          	endbr32 
80107204:	55                   	push   %ebp
80107205:	89 e5                	mov    %esp,%ebp
80107207:	57                   	push   %edi
80107208:	56                   	push   %esi
80107209:	53                   	push   %ebx
8010720a:	83 ec 1c             	sub    $0x1c,%esp
8010720d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107210:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107213:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107218:	0f 85 99 00 00 00    	jne    801072b7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010721e:	01 f0                	add    %esi,%eax
80107220:	89 f3                	mov    %esi,%ebx
80107222:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107225:	8b 45 14             	mov    0x14(%ebp),%eax
80107228:	01 f0                	add    %esi,%eax
8010722a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010722d:	85 f6                	test   %esi,%esi
8010722f:	75 15                	jne    80107246 <loaduvm+0x46>
80107231:	eb 6d                	jmp    801072a0 <loaduvm+0xa0>
80107233:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107237:	90                   	nop
80107238:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010723e:	89 f0                	mov    %esi,%eax
80107240:	29 d8                	sub    %ebx,%eax
80107242:	39 c6                	cmp    %eax,%esi
80107244:	76 5a                	jbe    801072a0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107246:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107249:	8b 45 08             	mov    0x8(%ebp),%eax
8010724c:	31 c9                	xor    %ecx,%ecx
8010724e:	29 da                	sub    %ebx,%edx
80107250:	e8 ab fb ff ff       	call   80106e00 <walkpgdir>
80107255:	85 c0                	test   %eax,%eax
80107257:	74 51                	je     801072aa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107259:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010725b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010725e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107263:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107268:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010726e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107271:	29 d9                	sub    %ebx,%ecx
80107273:	05 00 00 00 80       	add    $0x80000000,%eax
80107278:	57                   	push   %edi
80107279:	51                   	push   %ecx
8010727a:	50                   	push   %eax
8010727b:	ff 75 10             	pushl  0x10(%ebp)
8010727e:	e8 3d ae ff ff       	call   801020c0 <readi>
80107283:	83 c4 10             	add    $0x10,%esp
80107286:	39 f8                	cmp    %edi,%eax
80107288:	74 ae                	je     80107238 <loaduvm+0x38>
}
8010728a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010728d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107292:	5b                   	pop    %ebx
80107293:	5e                   	pop    %esi
80107294:	5f                   	pop    %edi
80107295:	5d                   	pop    %ebp
80107296:	c3                   	ret    
80107297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010729e:	66 90                	xchg   %ax,%ax
801072a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801072a3:	31 c0                	xor    %eax,%eax
}
801072a5:	5b                   	pop    %ebx
801072a6:	5e                   	pop    %esi
801072a7:	5f                   	pop    %edi
801072a8:	5d                   	pop    %ebp
801072a9:	c3                   	ret    
      panic("loaduvm: address should exist");
801072aa:	83 ec 0c             	sub    $0xc,%esp
801072ad:	68 67 80 10 80       	push   $0x80108067
801072b2:	e8 49 94 ff ff       	call   80100700 <panic>
    panic("loaduvm: addr must be page aligned");
801072b7:	83 ec 0c             	sub    $0xc,%esp
801072ba:	68 08 81 10 80       	push   $0x80108108
801072bf:	e8 3c 94 ff ff       	call   80100700 <panic>
801072c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072cf:	90                   	nop

801072d0 <allocuvm>:
{
801072d0:	f3 0f 1e fb          	endbr32 
801072d4:	55                   	push   %ebp
801072d5:	89 e5                	mov    %esp,%ebp
801072d7:	57                   	push   %edi
801072d8:	56                   	push   %esi
801072d9:	53                   	push   %ebx
801072da:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801072dd:	8b 45 10             	mov    0x10(%ebp),%eax
{
801072e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801072e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072e6:	85 c0                	test   %eax,%eax
801072e8:	0f 88 b2 00 00 00    	js     801073a0 <allocuvm+0xd0>
  if(newsz < oldsz)
801072ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801072f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801072f4:	0f 82 96 00 00 00    	jb     80107390 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801072fa:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107300:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107306:	39 75 10             	cmp    %esi,0x10(%ebp)
80107309:	77 40                	ja     8010734b <allocuvm+0x7b>
8010730b:	e9 83 00 00 00       	jmp    80107393 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107310:	83 ec 04             	sub    $0x4,%esp
80107313:	68 00 10 00 00       	push   $0x1000
80107318:	6a 00                	push   $0x0
8010731a:	50                   	push   %eax
8010731b:	e8 b0 d9 ff ff       	call   80104cd0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107320:	58                   	pop    %eax
80107321:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107327:	5a                   	pop    %edx
80107328:	6a 06                	push   $0x6
8010732a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010732f:	89 f2                	mov    %esi,%edx
80107331:	50                   	push   %eax
80107332:	89 f8                	mov    %edi,%eax
80107334:	e8 47 fb ff ff       	call   80106e80 <mappages>
80107339:	83 c4 10             	add    $0x10,%esp
8010733c:	85 c0                	test   %eax,%eax
8010733e:	78 78                	js     801073b8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107340:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107346:	39 75 10             	cmp    %esi,0x10(%ebp)
80107349:	76 48                	jbe    80107393 <allocuvm+0xc3>
    mem = kalloc();
8010734b:	e8 40 b9 ff ff       	call   80102c90 <kalloc>
80107350:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107352:	85 c0                	test   %eax,%eax
80107354:	75 ba                	jne    80107310 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107356:	83 ec 0c             	sub    $0xc,%esp
80107359:	68 85 80 10 80       	push   $0x80108085
8010735e:	e8 1d 94 ff ff       	call   80100780 <cprintf>
  if(newsz >= oldsz)
80107363:	8b 45 0c             	mov    0xc(%ebp),%eax
80107366:	83 c4 10             	add    $0x10,%esp
80107369:	39 45 10             	cmp    %eax,0x10(%ebp)
8010736c:	74 32                	je     801073a0 <allocuvm+0xd0>
8010736e:	8b 55 10             	mov    0x10(%ebp),%edx
80107371:	89 c1                	mov    %eax,%ecx
80107373:	89 f8                	mov    %edi,%eax
80107375:	e8 96 fb ff ff       	call   80106f10 <deallocuvm.part.0>
      return 0;
8010737a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107384:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107387:	5b                   	pop    %ebx
80107388:	5e                   	pop    %esi
80107389:	5f                   	pop    %edi
8010738a:	5d                   	pop    %ebp
8010738b:	c3                   	ret    
8010738c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107390:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107393:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107396:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107399:	5b                   	pop    %ebx
8010739a:	5e                   	pop    %esi
8010739b:	5f                   	pop    %edi
8010739c:	5d                   	pop    %ebp
8010739d:	c3                   	ret    
8010739e:	66 90                	xchg   %ax,%ax
    return 0;
801073a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801073a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ad:	5b                   	pop    %ebx
801073ae:	5e                   	pop    %esi
801073af:	5f                   	pop    %edi
801073b0:	5d                   	pop    %ebp
801073b1:	c3                   	ret    
801073b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801073b8:	83 ec 0c             	sub    $0xc,%esp
801073bb:	68 9d 80 10 80       	push   $0x8010809d
801073c0:	e8 bb 93 ff ff       	call   80100780 <cprintf>
  if(newsz >= oldsz)
801073c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801073c8:	83 c4 10             	add    $0x10,%esp
801073cb:	39 45 10             	cmp    %eax,0x10(%ebp)
801073ce:	74 0c                	je     801073dc <allocuvm+0x10c>
801073d0:	8b 55 10             	mov    0x10(%ebp),%edx
801073d3:	89 c1                	mov    %eax,%ecx
801073d5:	89 f8                	mov    %edi,%eax
801073d7:	e8 34 fb ff ff       	call   80106f10 <deallocuvm.part.0>
      kfree(mem);
801073dc:	83 ec 0c             	sub    $0xc,%esp
801073df:	53                   	push   %ebx
801073e0:	e8 eb b6 ff ff       	call   80102ad0 <kfree>
      return 0;
801073e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801073ec:	83 c4 10             	add    $0x10,%esp
}
801073ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073f5:	5b                   	pop    %ebx
801073f6:	5e                   	pop    %esi
801073f7:	5f                   	pop    %edi
801073f8:	5d                   	pop    %ebp
801073f9:	c3                   	ret    
801073fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107400 <deallocuvm>:
{
80107400:	f3 0f 1e fb          	endbr32 
80107404:	55                   	push   %ebp
80107405:	89 e5                	mov    %esp,%ebp
80107407:	8b 55 0c             	mov    0xc(%ebp),%edx
8010740a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010740d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107410:	39 d1                	cmp    %edx,%ecx
80107412:	73 0c                	jae    80107420 <deallocuvm+0x20>
}
80107414:	5d                   	pop    %ebp
80107415:	e9 f6 fa ff ff       	jmp    80106f10 <deallocuvm.part.0>
8010741a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107420:	89 d0                	mov    %edx,%eax
80107422:	5d                   	pop    %ebp
80107423:	c3                   	ret    
80107424:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010742b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010742f:	90                   	nop

80107430 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107430:	f3 0f 1e fb          	endbr32 
80107434:	55                   	push   %ebp
80107435:	89 e5                	mov    %esp,%ebp
80107437:	57                   	push   %edi
80107438:	56                   	push   %esi
80107439:	53                   	push   %ebx
8010743a:	83 ec 0c             	sub    $0xc,%esp
8010743d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107440:	85 f6                	test   %esi,%esi
80107442:	74 55                	je     80107499 <freevm+0x69>
  if(newsz >= oldsz)
80107444:	31 c9                	xor    %ecx,%ecx
80107446:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010744b:	89 f0                	mov    %esi,%eax
8010744d:	89 f3                	mov    %esi,%ebx
8010744f:	e8 bc fa ff ff       	call   80106f10 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107454:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010745a:	eb 0b                	jmp    80107467 <freevm+0x37>
8010745c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107460:	83 c3 04             	add    $0x4,%ebx
80107463:	39 df                	cmp    %ebx,%edi
80107465:	74 23                	je     8010748a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107467:	8b 03                	mov    (%ebx),%eax
80107469:	a8 01                	test   $0x1,%al
8010746b:	74 f3                	je     80107460 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010746d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107472:	83 ec 0c             	sub    $0xc,%esp
80107475:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107478:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010747d:	50                   	push   %eax
8010747e:	e8 4d b6 ff ff       	call   80102ad0 <kfree>
80107483:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107486:	39 df                	cmp    %ebx,%edi
80107488:	75 dd                	jne    80107467 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010748a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010748d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107490:	5b                   	pop    %ebx
80107491:	5e                   	pop    %esi
80107492:	5f                   	pop    %edi
80107493:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107494:	e9 37 b6 ff ff       	jmp    80102ad0 <kfree>
    panic("freevm: no pgdir");
80107499:	83 ec 0c             	sub    $0xc,%esp
8010749c:	68 b9 80 10 80       	push   $0x801080b9
801074a1:	e8 5a 92 ff ff       	call   80100700 <panic>
801074a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ad:	8d 76 00             	lea    0x0(%esi),%esi

801074b0 <setupkvm>:
{
801074b0:	f3 0f 1e fb          	endbr32 
801074b4:	55                   	push   %ebp
801074b5:	89 e5                	mov    %esp,%ebp
801074b7:	56                   	push   %esi
801074b8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801074b9:	e8 d2 b7 ff ff       	call   80102c90 <kalloc>
801074be:	89 c6                	mov    %eax,%esi
801074c0:	85 c0                	test   %eax,%eax
801074c2:	74 42                	je     80107506 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801074c4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801074c7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801074cc:	68 00 10 00 00       	push   $0x1000
801074d1:	6a 00                	push   $0x0
801074d3:	50                   	push   %eax
801074d4:	e8 f7 d7 ff ff       	call   80104cd0 <memset>
801074d9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801074dc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801074df:	83 ec 08             	sub    $0x8,%esp
801074e2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801074e5:	ff 73 0c             	pushl  0xc(%ebx)
801074e8:	8b 13                	mov    (%ebx),%edx
801074ea:	50                   	push   %eax
801074eb:	29 c1                	sub    %eax,%ecx
801074ed:	89 f0                	mov    %esi,%eax
801074ef:	e8 8c f9 ff ff       	call   80106e80 <mappages>
801074f4:	83 c4 10             	add    $0x10,%esp
801074f7:	85 c0                	test   %eax,%eax
801074f9:	78 15                	js     80107510 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801074fb:	83 c3 10             	add    $0x10,%ebx
801074fe:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107504:	75 d6                	jne    801074dc <setupkvm+0x2c>
}
80107506:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107509:	89 f0                	mov    %esi,%eax
8010750b:	5b                   	pop    %ebx
8010750c:	5e                   	pop    %esi
8010750d:	5d                   	pop    %ebp
8010750e:	c3                   	ret    
8010750f:	90                   	nop
      freevm(pgdir);
80107510:	83 ec 0c             	sub    $0xc,%esp
80107513:	56                   	push   %esi
      return 0;
80107514:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107516:	e8 15 ff ff ff       	call   80107430 <freevm>
      return 0;
8010751b:	83 c4 10             	add    $0x10,%esp
}
8010751e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107521:	89 f0                	mov    %esi,%eax
80107523:	5b                   	pop    %ebx
80107524:	5e                   	pop    %esi
80107525:	5d                   	pop    %ebp
80107526:	c3                   	ret    
80107527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010752e:	66 90                	xchg   %ax,%ax

80107530 <kvmalloc>:
{
80107530:	f3 0f 1e fb          	endbr32 
80107534:	55                   	push   %ebp
80107535:	89 e5                	mov    %esp,%ebp
80107537:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010753a:	e8 71 ff ff ff       	call   801074b0 <setupkvm>
8010753f:	a3 84 6d 11 80       	mov    %eax,0x80116d84
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107544:	05 00 00 00 80       	add    $0x80000000,%eax
80107549:	0f 22 d8             	mov    %eax,%cr3
}
8010754c:	c9                   	leave  
8010754d:	c3                   	ret    
8010754e:	66 90                	xchg   %ax,%ax

80107550 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107550:	f3 0f 1e fb          	endbr32 
80107554:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107555:	31 c9                	xor    %ecx,%ecx
{
80107557:	89 e5                	mov    %esp,%ebp
80107559:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010755c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010755f:	8b 45 08             	mov    0x8(%ebp),%eax
80107562:	e8 99 f8 ff ff       	call   80106e00 <walkpgdir>
  if(pte == 0)
80107567:	85 c0                	test   %eax,%eax
80107569:	74 05                	je     80107570 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010756b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010756e:	c9                   	leave  
8010756f:	c3                   	ret    
    panic("clearpteu");
80107570:	83 ec 0c             	sub    $0xc,%esp
80107573:	68 ca 80 10 80       	push   $0x801080ca
80107578:	e8 83 91 ff ff       	call   80100700 <panic>
8010757d:	8d 76 00             	lea    0x0(%esi),%esi

80107580 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107580:	f3 0f 1e fb          	endbr32 
80107584:	55                   	push   %ebp
80107585:	89 e5                	mov    %esp,%ebp
80107587:	57                   	push   %edi
80107588:	56                   	push   %esi
80107589:	53                   	push   %ebx
8010758a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010758d:	e8 1e ff ff ff       	call   801074b0 <setupkvm>
80107592:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107595:	85 c0                	test   %eax,%eax
80107597:	0f 84 9b 00 00 00    	je     80107638 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010759d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801075a0:	85 c9                	test   %ecx,%ecx
801075a2:	0f 84 90 00 00 00    	je     80107638 <copyuvm+0xb8>
801075a8:	31 f6                	xor    %esi,%esi
801075aa:	eb 46                	jmp    801075f2 <copyuvm+0x72>
801075ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801075b0:	83 ec 04             	sub    $0x4,%esp
801075b3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801075b9:	68 00 10 00 00       	push   $0x1000
801075be:	57                   	push   %edi
801075bf:	50                   	push   %eax
801075c0:	e8 ab d7 ff ff       	call   80104d70 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801075c5:	58                   	pop    %eax
801075c6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075cc:	5a                   	pop    %edx
801075cd:	ff 75 e4             	pushl  -0x1c(%ebp)
801075d0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075d5:	89 f2                	mov    %esi,%edx
801075d7:	50                   	push   %eax
801075d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075db:	e8 a0 f8 ff ff       	call   80106e80 <mappages>
801075e0:	83 c4 10             	add    $0x10,%esp
801075e3:	85 c0                	test   %eax,%eax
801075e5:	78 61                	js     80107648 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801075e7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801075ed:	39 75 0c             	cmp    %esi,0xc(%ebp)
801075f0:	76 46                	jbe    80107638 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801075f2:	8b 45 08             	mov    0x8(%ebp),%eax
801075f5:	31 c9                	xor    %ecx,%ecx
801075f7:	89 f2                	mov    %esi,%edx
801075f9:	e8 02 f8 ff ff       	call   80106e00 <walkpgdir>
801075fe:	85 c0                	test   %eax,%eax
80107600:	74 61                	je     80107663 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107602:	8b 00                	mov    (%eax),%eax
80107604:	a8 01                	test   $0x1,%al
80107606:	74 4e                	je     80107656 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107608:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010760a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010760f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107612:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107618:	e8 73 b6 ff ff       	call   80102c90 <kalloc>
8010761d:	89 c3                	mov    %eax,%ebx
8010761f:	85 c0                	test   %eax,%eax
80107621:	75 8d                	jne    801075b0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107623:	83 ec 0c             	sub    $0xc,%esp
80107626:	ff 75 e0             	pushl  -0x20(%ebp)
80107629:	e8 02 fe ff ff       	call   80107430 <freevm>
  return 0;
8010762e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107635:	83 c4 10             	add    $0x10,%esp
}
80107638:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010763b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010763e:	5b                   	pop    %ebx
8010763f:	5e                   	pop    %esi
80107640:	5f                   	pop    %edi
80107641:	5d                   	pop    %ebp
80107642:	c3                   	ret    
80107643:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107647:	90                   	nop
      kfree(mem);
80107648:	83 ec 0c             	sub    $0xc,%esp
8010764b:	53                   	push   %ebx
8010764c:	e8 7f b4 ff ff       	call   80102ad0 <kfree>
      goto bad;
80107651:	83 c4 10             	add    $0x10,%esp
80107654:	eb cd                	jmp    80107623 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107656:	83 ec 0c             	sub    $0xc,%esp
80107659:	68 ee 80 10 80       	push   $0x801080ee
8010765e:	e8 9d 90 ff ff       	call   80100700 <panic>
      panic("copyuvm: pte should exist");
80107663:	83 ec 0c             	sub    $0xc,%esp
80107666:	68 d4 80 10 80       	push   $0x801080d4
8010766b:	e8 90 90 ff ff       	call   80100700 <panic>

80107670 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107670:	f3 0f 1e fb          	endbr32 
80107674:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107675:	31 c9                	xor    %ecx,%ecx
{
80107677:	89 e5                	mov    %esp,%ebp
80107679:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010767c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010767f:	8b 45 08             	mov    0x8(%ebp),%eax
80107682:	e8 79 f7 ff ff       	call   80106e00 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107687:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107689:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010768a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010768c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107691:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107694:	05 00 00 00 80       	add    $0x80000000,%eax
80107699:	83 fa 05             	cmp    $0x5,%edx
8010769c:	ba 00 00 00 00       	mov    $0x0,%edx
801076a1:	0f 45 c2             	cmovne %edx,%eax
}
801076a4:	c3                   	ret    
801076a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801076b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801076b0:	f3 0f 1e fb          	endbr32 
801076b4:	55                   	push   %ebp
801076b5:	89 e5                	mov    %esp,%ebp
801076b7:	57                   	push   %edi
801076b8:	56                   	push   %esi
801076b9:	53                   	push   %ebx
801076ba:	83 ec 0c             	sub    $0xc,%esp
801076bd:	8b 75 14             	mov    0x14(%ebp),%esi
801076c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801076c3:	85 f6                	test   %esi,%esi
801076c5:	75 3c                	jne    80107703 <copyout+0x53>
801076c7:	eb 67                	jmp    80107730 <copyout+0x80>
801076c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801076d0:	8b 55 0c             	mov    0xc(%ebp),%edx
801076d3:	89 fb                	mov    %edi,%ebx
801076d5:	29 d3                	sub    %edx,%ebx
801076d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801076dd:	39 f3                	cmp    %esi,%ebx
801076df:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801076e2:	29 fa                	sub    %edi,%edx
801076e4:	83 ec 04             	sub    $0x4,%esp
801076e7:	01 c2                	add    %eax,%edx
801076e9:	53                   	push   %ebx
801076ea:	ff 75 10             	pushl  0x10(%ebp)
801076ed:	52                   	push   %edx
801076ee:	e8 7d d6 ff ff       	call   80104d70 <memmove>
    len -= n;
    buf += n;
801076f3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801076f6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801076fc:	83 c4 10             	add    $0x10,%esp
801076ff:	29 de                	sub    %ebx,%esi
80107701:	74 2d                	je     80107730 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107703:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107705:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107708:	89 55 0c             	mov    %edx,0xc(%ebp)
8010770b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107711:	57                   	push   %edi
80107712:	ff 75 08             	pushl  0x8(%ebp)
80107715:	e8 56 ff ff ff       	call   80107670 <uva2ka>
    if(pa0 == 0)
8010771a:	83 c4 10             	add    $0x10,%esp
8010771d:	85 c0                	test   %eax,%eax
8010771f:	75 af                	jne    801076d0 <copyout+0x20>
  }
  return 0;
}
80107721:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107729:	5b                   	pop    %ebx
8010772a:	5e                   	pop    %esi
8010772b:	5f                   	pop    %edi
8010772c:	5d                   	pop    %ebp
8010772d:	c3                   	ret    
8010772e:	66 90                	xchg   %ax,%ax
80107730:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107733:	31 c0                	xor    %eax,%eax
}
80107735:	5b                   	pop    %ebx
80107736:	5e                   	pop    %esi
80107737:	5f                   	pop    %edi
80107738:	5d                   	pop    %ebp
80107739:	c3                   	ret    
