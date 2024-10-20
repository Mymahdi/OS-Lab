// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"

#define KEY_UP          0xE2
#define KEY_DN          0xE3
#define KEY_LF          0xE4
#define KEY_RT          0xE5

#define MAX_COMMAND_LENGTH          (128)  
#define MAX_HISTORY                 (16)  

char commandHistory[MAX_HISTORY][MAX_COMMAND_LENGTH];
int commandHistoryCounter = 0;
int currentCommandId = 0;

static void consputc(int);

static int panicked = 0;

static struct {
  struct spinlock lock;
  int locking;
} cons;

void addHistory(char *command){
if(command[0]!='\0')
{
    int length = strlen(command) <= MAX_COMMAND_LENGTH ? strlen(command) : MAX_COMMAND_LENGTH-1;
    int i;

    if(commandHistoryCounter < MAX_HISTORY){
      commandHistoryCounter++;
    }else{
      for(i = 0; i < MAX_HISTORY - 1; i++){
        memmove(commandHistory[i], commandHistory[i+1], sizeof(char)* MAX_COMMAND_LENGTH);
      }   
    }

    memmove(commandHistory[commandHistoryCounter-1], command, sizeof(char)* length);
    commandHistory[commandHistoryCounter-1][length] = '\0';

    currentCommandId = commandHistoryCounter - 1;
  }
}

static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
    consputc(buf[i]);
}
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
      break;
    }
  }

  if(locking)
    release(&cons.lock);
}

void
panic(char *s)
{
  int i;
  uint pcs[10];
  
  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  //cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for(;;)
    ;
}

int back_counter = 0;

#define INPUT_BUF 128
struct {
  struct spinlock lock;
  char buf[INPUT_BUF];
  uint r;  // Read index
  uint w;  // Write index
  uint e;  // Edit index
  uint pos; // current pos, real cursor pos = row * 80 + pos 
} input;

//PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
  int pos;
  
  outb(CRTPORT, 14);                  //read line number？ 1280 ... 256 per line？？
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);                  //read column? 2
  pos |= inb(CRTPORT+1);    

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }
  
  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
}


void vga_move_back_cursor(){
  int pos;
  
  outb(CRTPORT, 14);                  
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);    

  pos--;

  outb(CRTPORT, 15);
  outb(CRTPORT+1, (unsigned char)(pos&0xFF));
  outb(CRTPORT, 14);
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
  //crt[pos] = ' ' | 0x0700;
}

void vga_move_forward_cursor(){
  int pos;
  
  outb(CRTPORT, 14);                  
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);    

  pos++;

  outb(CRTPORT, 15);
  outb(CRTPORT+1, (unsigned char)(pos&0xFF));
  outb(CRTPORT, 14);
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
  //crt[pos] = ' ' | 0x0700;
}

void vga_insert_char(int c, int back_counter){
  int pos;

  outb(CRTPORT, 14);                  
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  for(int i = pos + back_counter; i >= pos; i--){
    crt[i+1] = crt[i];
  }
  crt[pos] = (c&0xff) | 0x0700;  

  pos += 1;

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos+back_counter] = ' ' | 0x0700;
}

void vga_remove_char(){
  int pos;
  
  outb(CRTPORT, 14);                  
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);    

  pos--;

  outb(CRTPORT, 15);
  outb(CRTPORT+1, (unsigned char)(pos&0xFF));
  outb(CRTPORT, 14);
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
  if(panicked){
    cli();
    for(;;)
      ;
  }

  // write to serial port
  if(c == BACKSPACE){
    uartputc('\b'); 
    uartputc(' '); 
    uartputc('\b');
  } else
    uartputc(c);

  // write to screen
  cgaputc(c);
}

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  int c;
  char buffer[MAX_COMMAND_LENGTH];

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case KEY_LF:
      if(input.pos > input.r){  
        input.pos --;
        back_counter += 1;
        vga_move_back_cursor();
      }
      break;
    case KEY_RT:
      if(input.pos < input.e){   
        input.pos ++;
        back_counter -= 1;
        vga_move_forward_cursor();
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){

        uartputc('-');
        uartputc(c); 

        c = (c == '\r') ? '\n' : c;
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){

          input.buf[input.e++ % INPUT_BUF] = c;
          consputc(c);

          back_counter = 0;

          for(int i=input.w, k=0; i < input.e-1; i++, k++){
            buffer[k] = input.buf[i % INPUT_BUF];
          }
          buffer[(input.e-1-input.w) % INPUT_BUF] = '\0';

          addHistory(buffer);
          input.w = input.e;
          input.pos = input.e;
          wakeup(&input.r);

        }else{
          
          if(back_counter == 0){

            input.buf[input.e++ % INPUT_BUF] = c;
            input.pos ++;

            consputc(c);
          
          }else{

            for(int k=input.e; k >= input.pos; k--){
              input.buf[(k + 1) % INPUT_BUF] = input.buf[k % INPUT_BUF];
            }

            input.buf[input.pos % INPUT_BUF] = c;

            input.e++;
            input.pos++;

            vga_insert_char(c, back_counter);
          }
        }
      }
      break;
    }
  }
  release(&cons.lock);
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  ilock(ip);

  return n;
}

void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
}

