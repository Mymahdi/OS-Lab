
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  13:	83 ec 08             	sub    $0x8,%esp
  16:	6a 02                	push   $0x2
  18:	68 48 08 00 00       	push   $0x848
  1d:	e8 a1 03 00 00       	call   3c3 <open>
  22:	83 c4 10             	add    $0x10,%esp
  25:	85 c0                	test   %eax,%eax
  27:	0f 88 cb 00 00 00    	js     f8 <main+0xf8>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  2d:	83 ec 0c             	sub    $0xc,%esp
  30:	6a 00                	push   $0x0
  32:	e8 c4 03 00 00       	call   3fb <dup>
  dup(0);  // stderr
  37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3e:	e8 b8 03 00 00       	call   3fb <dup>
  43:	83 c4 10             	add    $0x10,%esp
  46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  4d:	8d 76 00             	lea    0x0(%esi),%esi

  for(;;){
    printf(1, "init: starting sh\n");
  50:	83 ec 08             	sub    $0x8,%esp
  53:	68 50 08 00 00       	push   $0x850
  58:	6a 01                	push   $0x1
  5a:	e8 81 04 00 00       	call   4e0 <printf>
    printf(1, "Ali Dadashi\n");
  5f:	58                   	pop    %eax
  60:	5a                   	pop    %edx
  61:	68 63 08 00 00       	push   $0x863
  66:	6a 01                	push   $0x1
  68:	e8 73 04 00 00       	call   4e0 <printf>
    printf(1, "Mohammad mahdi Davarzani\n");
  6d:	59                   	pop    %ecx
  6e:	5b                   	pop    %ebx
  6f:	68 70 08 00 00       	push   $0x870
  74:	6a 01                	push   $0x1
  76:	e8 65 04 00 00       	call   4e0 <printf>
    printf(1, "Mohammad mahdi Khesali\n");
  7b:	58                   	pop    %eax
  7c:	5a                   	pop    %edx
  7d:	68 8a 08 00 00       	push   $0x88a
  82:	6a 01                	push   $0x1
  84:	e8 57 04 00 00       	call   4e0 <printf>
    pid = fork();
  89:	e8 ed 02 00 00       	call   37b <fork>
    if(pid < 0){
  8e:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  91:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  93:	85 c0                	test   %eax,%eax
  95:	78 2a                	js     c1 <main+0xc1>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  97:	74 3b                	je     d4 <main+0xd4>
  99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  a0:	e8 e6 02 00 00       	call   38b <wait>
  a5:	85 c0                	test   %eax,%eax
  a7:	78 a7                	js     50 <main+0x50>
  a9:	39 c3                	cmp    %eax,%ebx
  ab:	74 a3                	je     50 <main+0x50>
      printf(1, "zombie!\n");
  ad:	83 ec 08             	sub    $0x8,%esp
  b0:	68 ce 08 00 00       	push   $0x8ce
  b5:	6a 01                	push   $0x1
  b7:	e8 24 04 00 00       	call   4e0 <printf>
  bc:	83 c4 10             	add    $0x10,%esp
  bf:	eb df                	jmp    a0 <main+0xa0>
      printf(1, "init: fork failed\n");
  c1:	53                   	push   %ebx
  c2:	53                   	push   %ebx
  c3:	68 a2 08 00 00       	push   $0x8a2
  c8:	6a 01                	push   $0x1
  ca:	e8 11 04 00 00       	call   4e0 <printf>
      exit();
  cf:	e8 af 02 00 00       	call   383 <exit>
      exec("sh", argv);
  d4:	50                   	push   %eax
  d5:	50                   	push   %eax
  d6:	68 8c 0b 00 00       	push   $0xb8c
  db:	68 b5 08 00 00       	push   $0x8b5
  e0:	e8 d6 02 00 00       	call   3bb <exec>
      printf(1, "init: exec sh failed\n");
  e5:	5a                   	pop    %edx
  e6:	59                   	pop    %ecx
  e7:	68 b8 08 00 00       	push   $0x8b8
  ec:	6a 01                	push   $0x1
  ee:	e8 ed 03 00 00       	call   4e0 <printf>
      exit();
  f3:	e8 8b 02 00 00       	call   383 <exit>
    mknod("console", 1, 1);
  f8:	51                   	push   %ecx
  f9:	6a 01                	push   $0x1
  fb:	6a 01                	push   $0x1
  fd:	68 48 08 00 00       	push   $0x848
 102:	e8 c4 02 00 00       	call   3cb <mknod>
    open("console", O_RDWR);
 107:	5b                   	pop    %ebx
 108:	58                   	pop    %eax
 109:	6a 02                	push   $0x2
 10b:	68 48 08 00 00       	push   $0x848
 110:	e8 ae 02 00 00       	call   3c3 <open>
 115:	83 c4 10             	add    $0x10,%esp
 118:	e9 10 ff ff ff       	jmp    2d <main+0x2d>
 11d:	66 90                	xchg   %ax,%ax
 11f:	90                   	nop

00000120 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 120:	f3 0f 1e fb          	endbr32 
 124:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 125:	31 c0                	xor    %eax,%eax
{
 127:	89 e5                	mov    %esp,%ebp
 129:	53                   	push   %ebx
 12a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 12d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 130:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 134:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 137:	83 c0 01             	add    $0x1,%eax
 13a:	84 d2                	test   %dl,%dl
 13c:	75 f2                	jne    130 <strcpy+0x10>
    ;
  return os;
}
 13e:	89 c8                	mov    %ecx,%eax
 140:	5b                   	pop    %ebx
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    
 143:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 150:	f3 0f 1e fb          	endbr32 
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	53                   	push   %ebx
 158:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 15e:	0f b6 01             	movzbl (%ecx),%eax
 161:	0f b6 1a             	movzbl (%edx),%ebx
 164:	84 c0                	test   %al,%al
 166:	75 19                	jne    181 <strcmp+0x31>
 168:	eb 26                	jmp    190 <strcmp+0x40>
 16a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 170:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 174:	83 c1 01             	add    $0x1,%ecx
 177:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 17a:	0f b6 1a             	movzbl (%edx),%ebx
 17d:	84 c0                	test   %al,%al
 17f:	74 0f                	je     190 <strcmp+0x40>
 181:	38 d8                	cmp    %bl,%al
 183:	74 eb                	je     170 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 185:	29 d8                	sub    %ebx,%eax
}
 187:	5b                   	pop    %ebx
 188:	5d                   	pop    %ebp
 189:	c3                   	ret    
 18a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 190:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 192:	29 d8                	sub    %ebx,%eax
}
 194:	5b                   	pop    %ebx
 195:	5d                   	pop    %ebp
 196:	c3                   	ret    
 197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 19e:	66 90                	xchg   %ax,%ax

000001a0 <strlen>:

uint
strlen(const char *s)
{
 1a0:	f3 0f 1e fb          	endbr32 
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1aa:	80 3a 00             	cmpb   $0x0,(%edx)
 1ad:	74 21                	je     1d0 <strlen+0x30>
 1af:	31 c0                	xor    %eax,%eax
 1b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1b8:	83 c0 01             	add    $0x1,%eax
 1bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1bf:	89 c1                	mov    %eax,%ecx
 1c1:	75 f5                	jne    1b8 <strlen+0x18>
    ;
  return n;
}
 1c3:	89 c8                	mov    %ecx,%eax
 1c5:	5d                   	pop    %ebp
 1c6:	c3                   	ret    
 1c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ce:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 1d0:	31 c9                	xor    %ecx,%ecx
}
 1d2:	5d                   	pop    %ebp
 1d3:	89 c8                	mov    %ecx,%eax
 1d5:	c3                   	ret    
 1d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1dd:	8d 76 00             	lea    0x0(%esi),%esi

000001e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e0:	f3 0f 1e fb          	endbr32 
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	57                   	push   %edi
 1e8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f1:	89 d7                	mov    %edx,%edi
 1f3:	fc                   	cld    
 1f4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1f6:	89 d0                	mov    %edx,%eax
 1f8:	5f                   	pop    %edi
 1f9:	5d                   	pop    %ebp
 1fa:	c3                   	ret    
 1fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1ff:	90                   	nop

00000200 <strchr>:

char*
strchr(const char *s, char c)
{
 200:	f3 0f 1e fb          	endbr32 
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 20e:	0f b6 10             	movzbl (%eax),%edx
 211:	84 d2                	test   %dl,%dl
 213:	75 16                	jne    22b <strchr+0x2b>
 215:	eb 21                	jmp    238 <strchr+0x38>
 217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 21e:	66 90                	xchg   %ax,%ax
 220:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 224:	83 c0 01             	add    $0x1,%eax
 227:	84 d2                	test   %dl,%dl
 229:	74 0d                	je     238 <strchr+0x38>
    if(*s == c)
 22b:	38 d1                	cmp    %dl,%cl
 22d:	75 f1                	jne    220 <strchr+0x20>
      return (char*)s;
  return 0;
}
 22f:	5d                   	pop    %ebp
 230:	c3                   	ret    
 231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 238:	31 c0                	xor    %eax,%eax
}
 23a:	5d                   	pop    %ebp
 23b:	c3                   	ret    
 23c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000240 <gets>:

char*
gets(char *buf, int max)
{
 240:	f3 0f 1e fb          	endbr32 
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	57                   	push   %edi
 248:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 249:	31 f6                	xor    %esi,%esi
{
 24b:	53                   	push   %ebx
 24c:	89 f3                	mov    %esi,%ebx
 24e:	83 ec 1c             	sub    $0x1c,%esp
 251:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 254:	eb 33                	jmp    289 <gets+0x49>
 256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 260:	83 ec 04             	sub    $0x4,%esp
 263:	8d 45 e7             	lea    -0x19(%ebp),%eax
 266:	6a 01                	push   $0x1
 268:	50                   	push   %eax
 269:	6a 00                	push   $0x0
 26b:	e8 2b 01 00 00       	call   39b <read>
    if(cc < 1)
 270:	83 c4 10             	add    $0x10,%esp
 273:	85 c0                	test   %eax,%eax
 275:	7e 1c                	jle    293 <gets+0x53>
      break;
    buf[i++] = c;
 277:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 27b:	83 c7 01             	add    $0x1,%edi
 27e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 281:	3c 0a                	cmp    $0xa,%al
 283:	74 23                	je     2a8 <gets+0x68>
 285:	3c 0d                	cmp    $0xd,%al
 287:	74 1f                	je     2a8 <gets+0x68>
  for(i=0; i+1 < max; ){
 289:	83 c3 01             	add    $0x1,%ebx
 28c:	89 fe                	mov    %edi,%esi
 28e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 291:	7c cd                	jl     260 <gets+0x20>
 293:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 295:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 298:	c6 03 00             	movb   $0x0,(%ebx)
}
 29b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 29e:	5b                   	pop    %ebx
 29f:	5e                   	pop    %esi
 2a0:	5f                   	pop    %edi
 2a1:	5d                   	pop    %ebp
 2a2:	c3                   	ret    
 2a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2a7:	90                   	nop
 2a8:	8b 75 08             	mov    0x8(%ebp),%esi
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	01 de                	add    %ebx,%esi
 2b0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 2b2:	c6 03 00             	movb   $0x0,(%ebx)
}
 2b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2b8:	5b                   	pop    %ebx
 2b9:	5e                   	pop    %esi
 2ba:	5f                   	pop    %edi
 2bb:	5d                   	pop    %ebp
 2bc:	c3                   	ret    
 2bd:	8d 76 00             	lea    0x0(%esi),%esi

000002c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c0:	f3 0f 1e fb          	endbr32 
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	56                   	push   %esi
 2c8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c9:	83 ec 08             	sub    $0x8,%esp
 2cc:	6a 00                	push   $0x0
 2ce:	ff 75 08             	pushl  0x8(%ebp)
 2d1:	e8 ed 00 00 00       	call   3c3 <open>
  if(fd < 0)
 2d6:	83 c4 10             	add    $0x10,%esp
 2d9:	85 c0                	test   %eax,%eax
 2db:	78 2b                	js     308 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 2dd:	83 ec 08             	sub    $0x8,%esp
 2e0:	ff 75 0c             	pushl  0xc(%ebp)
 2e3:	89 c3                	mov    %eax,%ebx
 2e5:	50                   	push   %eax
 2e6:	e8 f0 00 00 00       	call   3db <fstat>
  close(fd);
 2eb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2ee:	89 c6                	mov    %eax,%esi
  close(fd);
 2f0:	e8 b6 00 00 00       	call   3ab <close>
  return r;
 2f5:	83 c4 10             	add    $0x10,%esp
}
 2f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2fb:	89 f0                	mov    %esi,%eax
 2fd:	5b                   	pop    %ebx
 2fe:	5e                   	pop    %esi
 2ff:	5d                   	pop    %ebp
 300:	c3                   	ret    
 301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 308:	be ff ff ff ff       	mov    $0xffffffff,%esi
 30d:	eb e9                	jmp    2f8 <stat+0x38>
 30f:	90                   	nop

00000310 <atoi>:

int
atoi(const char *s)
{
 310:	f3 0f 1e fb          	endbr32 
 314:	55                   	push   %ebp
 315:	89 e5                	mov    %esp,%ebp
 317:	53                   	push   %ebx
 318:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31b:	0f be 02             	movsbl (%edx),%eax
 31e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 321:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 324:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 329:	77 1a                	ja     345 <atoi+0x35>
 32b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 32f:	90                   	nop
    n = n*10 + *s++ - '0';
 330:	83 c2 01             	add    $0x1,%edx
 333:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 336:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 33a:	0f be 02             	movsbl (%edx),%eax
 33d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 340:	80 fb 09             	cmp    $0x9,%bl
 343:	76 eb                	jbe    330 <atoi+0x20>
  return n;
}
 345:	89 c8                	mov    %ecx,%eax
 347:	5b                   	pop    %ebx
 348:	5d                   	pop    %ebp
 349:	c3                   	ret    
 34a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000350 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 350:	f3 0f 1e fb          	endbr32 
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	57                   	push   %edi
 358:	8b 45 10             	mov    0x10(%ebp),%eax
 35b:	8b 55 08             	mov    0x8(%ebp),%edx
 35e:	56                   	push   %esi
 35f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 362:	85 c0                	test   %eax,%eax
 364:	7e 0f                	jle    375 <memmove+0x25>
 366:	01 d0                	add    %edx,%eax
  dst = vdst;
 368:	89 d7                	mov    %edx,%edi
 36a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 370:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 371:	39 f8                	cmp    %edi,%eax
 373:	75 fb                	jne    370 <memmove+0x20>
  return vdst;
}
 375:	5e                   	pop    %esi
 376:	89 d0                	mov    %edx,%eax
 378:	5f                   	pop    %edi
 379:	5d                   	pop    %ebp
 37a:	c3                   	ret    

0000037b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 37b:	b8 01 00 00 00       	mov    $0x1,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <exit>:
SYSCALL(exit)
 383:	b8 02 00 00 00       	mov    $0x2,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <wait>:
SYSCALL(wait)
 38b:	b8 03 00 00 00       	mov    $0x3,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <pipe>:
SYSCALL(pipe)
 393:	b8 04 00 00 00       	mov    $0x4,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <read>:
SYSCALL(read)
 39b:	b8 05 00 00 00       	mov    $0x5,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <write>:
SYSCALL(write)
 3a3:	b8 10 00 00 00       	mov    $0x10,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <close>:
SYSCALL(close)
 3ab:	b8 15 00 00 00       	mov    $0x15,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <kill>:
SYSCALL(kill)
 3b3:	b8 06 00 00 00       	mov    $0x6,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <exec>:
SYSCALL(exec)
 3bb:	b8 07 00 00 00       	mov    $0x7,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <open>:
SYSCALL(open)
 3c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <mknod>:
SYSCALL(mknod)
 3cb:	b8 11 00 00 00       	mov    $0x11,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <unlink>:
SYSCALL(unlink)
 3d3:	b8 12 00 00 00       	mov    $0x12,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <fstat>:
SYSCALL(fstat)
 3db:	b8 08 00 00 00       	mov    $0x8,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <link>:
SYSCALL(link)
 3e3:	b8 13 00 00 00       	mov    $0x13,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <mkdir>:
SYSCALL(mkdir)
 3eb:	b8 14 00 00 00       	mov    $0x14,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <chdir>:
SYSCALL(chdir)
 3f3:	b8 09 00 00 00       	mov    $0x9,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <dup>:
SYSCALL(dup)
 3fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <getpid>:
SYSCALL(getpid)
 403:	b8 0b 00 00 00       	mov    $0xb,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <sbrk>:
SYSCALL(sbrk)
 40b:	b8 0c 00 00 00       	mov    $0xc,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <sleep>:
SYSCALL(sleep)
 413:	b8 0d 00 00 00       	mov    $0xd,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <uptime>:
SYSCALL(uptime)
 41b:	b8 0e 00 00 00       	mov    $0xe,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    
 423:	66 90                	xchg   %ax,%ax
 425:	66 90                	xchg   %ax,%ax
 427:	66 90                	xchg   %ax,%ax
 429:	66 90                	xchg   %ax,%ax
 42b:	66 90                	xchg   %ax,%ax
 42d:	66 90                	xchg   %ax,%ax
 42f:	90                   	nop

00000430 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	53                   	push   %ebx
 436:	83 ec 3c             	sub    $0x3c,%esp
 439:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 43c:	89 d1                	mov    %edx,%ecx
{
 43e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 441:	85 d2                	test   %edx,%edx
 443:	0f 89 7f 00 00 00    	jns    4c8 <printint+0x98>
 449:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 44d:	74 79                	je     4c8 <printint+0x98>
    neg = 1;
 44f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 456:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 458:	31 db                	xor    %ebx,%ebx
 45a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 45d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 460:	89 c8                	mov    %ecx,%eax
 462:	31 d2                	xor    %edx,%edx
 464:	89 cf                	mov    %ecx,%edi
 466:	f7 75 c4             	divl   -0x3c(%ebp)
 469:	0f b6 92 e0 08 00 00 	movzbl 0x8e0(%edx),%edx
 470:	89 45 c0             	mov    %eax,-0x40(%ebp)
 473:	89 d8                	mov    %ebx,%eax
 475:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 478:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 47b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 47e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 481:	76 dd                	jbe    460 <printint+0x30>
  if(neg)
 483:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 486:	85 c9                	test   %ecx,%ecx
 488:	74 0c                	je     496 <printint+0x66>
    buf[i++] = '-';
 48a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 48f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 491:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 496:	8b 7d b8             	mov    -0x48(%ebp),%edi
 499:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 49d:	eb 07                	jmp    4a6 <printint+0x76>
 49f:	90                   	nop
 4a0:	0f b6 13             	movzbl (%ebx),%edx
 4a3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 4a6:	83 ec 04             	sub    $0x4,%esp
 4a9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 4ac:	6a 01                	push   $0x1
 4ae:	56                   	push   %esi
 4af:	57                   	push   %edi
 4b0:	e8 ee fe ff ff       	call   3a3 <write>
  while(--i >= 0)
 4b5:	83 c4 10             	add    $0x10,%esp
 4b8:	39 de                	cmp    %ebx,%esi
 4ba:	75 e4                	jne    4a0 <printint+0x70>
    putc(fd, buf[i]);
}
 4bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4bf:	5b                   	pop    %ebx
 4c0:	5e                   	pop    %esi
 4c1:	5f                   	pop    %edi
 4c2:	5d                   	pop    %ebp
 4c3:	c3                   	ret    
 4c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4c8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 4cf:	eb 87                	jmp    458 <printint+0x28>
 4d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4df:	90                   	nop

000004e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4e0:	f3 0f 1e fb          	endbr32 
 4e4:	55                   	push   %ebp
 4e5:	89 e5                	mov    %esp,%ebp
 4e7:	57                   	push   %edi
 4e8:	56                   	push   %esi
 4e9:	53                   	push   %ebx
 4ea:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4ed:	8b 75 0c             	mov    0xc(%ebp),%esi
 4f0:	0f b6 1e             	movzbl (%esi),%ebx
 4f3:	84 db                	test   %bl,%bl
 4f5:	0f 84 b4 00 00 00    	je     5af <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 4fb:	8d 45 10             	lea    0x10(%ebp),%eax
 4fe:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 501:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 504:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 506:	89 45 d0             	mov    %eax,-0x30(%ebp)
 509:	eb 33                	jmp    53e <printf+0x5e>
 50b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 50f:	90                   	nop
 510:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 513:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 518:	83 f8 25             	cmp    $0x25,%eax
 51b:	74 17                	je     534 <printf+0x54>
  write(fd, &c, 1);
 51d:	83 ec 04             	sub    $0x4,%esp
 520:	88 5d e7             	mov    %bl,-0x19(%ebp)
 523:	6a 01                	push   $0x1
 525:	57                   	push   %edi
 526:	ff 75 08             	pushl  0x8(%ebp)
 529:	e8 75 fe ff ff       	call   3a3 <write>
 52e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 531:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 534:	0f b6 1e             	movzbl (%esi),%ebx
 537:	83 c6 01             	add    $0x1,%esi
 53a:	84 db                	test   %bl,%bl
 53c:	74 71                	je     5af <printf+0xcf>
    c = fmt[i] & 0xff;
 53e:	0f be cb             	movsbl %bl,%ecx
 541:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 544:	85 d2                	test   %edx,%edx
 546:	74 c8                	je     510 <printf+0x30>
      }
    } else if(state == '%'){
 548:	83 fa 25             	cmp    $0x25,%edx
 54b:	75 e7                	jne    534 <printf+0x54>
      if(c == 'd'){
 54d:	83 f8 64             	cmp    $0x64,%eax
 550:	0f 84 9a 00 00 00    	je     5f0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 556:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 55c:	83 f9 70             	cmp    $0x70,%ecx
 55f:	74 5f                	je     5c0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 561:	83 f8 73             	cmp    $0x73,%eax
 564:	0f 84 d6 00 00 00    	je     640 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 56a:	83 f8 63             	cmp    $0x63,%eax
 56d:	0f 84 8d 00 00 00    	je     600 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 573:	83 f8 25             	cmp    $0x25,%eax
 576:	0f 84 b4 00 00 00    	je     630 <printf+0x150>
  write(fd, &c, 1);
 57c:	83 ec 04             	sub    $0x4,%esp
 57f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 583:	6a 01                	push   $0x1
 585:	57                   	push   %edi
 586:	ff 75 08             	pushl  0x8(%ebp)
 589:	e8 15 fe ff ff       	call   3a3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 58e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 591:	83 c4 0c             	add    $0xc,%esp
 594:	6a 01                	push   $0x1
 596:	83 c6 01             	add    $0x1,%esi
 599:	57                   	push   %edi
 59a:	ff 75 08             	pushl  0x8(%ebp)
 59d:	e8 01 fe ff ff       	call   3a3 <write>
  for(i = 0; fmt[i]; i++){
 5a2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 5a6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5a9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 5ab:	84 db                	test   %bl,%bl
 5ad:	75 8f                	jne    53e <printf+0x5e>
    }
  }
}
 5af:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5b2:	5b                   	pop    %ebx
 5b3:	5e                   	pop    %esi
 5b4:	5f                   	pop    %edi
 5b5:	5d                   	pop    %ebp
 5b6:	c3                   	ret    
 5b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5be:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 5c0:	83 ec 0c             	sub    $0xc,%esp
 5c3:	b9 10 00 00 00       	mov    $0x10,%ecx
 5c8:	6a 00                	push   $0x0
 5ca:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5cd:	8b 45 08             	mov    0x8(%ebp),%eax
 5d0:	8b 13                	mov    (%ebx),%edx
 5d2:	e8 59 fe ff ff       	call   430 <printint>
        ap++;
 5d7:	89 d8                	mov    %ebx,%eax
 5d9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5dc:	31 d2                	xor    %edx,%edx
        ap++;
 5de:	83 c0 04             	add    $0x4,%eax
 5e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5e4:	e9 4b ff ff ff       	jmp    534 <printf+0x54>
 5e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 5f0:	83 ec 0c             	sub    $0xc,%esp
 5f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5f8:	6a 01                	push   $0x1
 5fa:	eb ce                	jmp    5ca <printf+0xea>
 5fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 600:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 603:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 606:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 608:	6a 01                	push   $0x1
        ap++;
 60a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 60d:	57                   	push   %edi
 60e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 611:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 614:	e8 8a fd ff ff       	call   3a3 <write>
        ap++;
 619:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 61c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 61f:	31 d2                	xor    %edx,%edx
 621:	e9 0e ff ff ff       	jmp    534 <printf+0x54>
 626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 62d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 630:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 633:	83 ec 04             	sub    $0x4,%esp
 636:	e9 59 ff ff ff       	jmp    594 <printf+0xb4>
 63b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 63f:	90                   	nop
        s = (char*)*ap;
 640:	8b 45 d0             	mov    -0x30(%ebp),%eax
 643:	8b 18                	mov    (%eax),%ebx
        ap++;
 645:	83 c0 04             	add    $0x4,%eax
 648:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 64b:	85 db                	test   %ebx,%ebx
 64d:	74 17                	je     666 <printf+0x186>
        while(*s != 0){
 64f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 652:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 654:	84 c0                	test   %al,%al
 656:	0f 84 d8 fe ff ff    	je     534 <printf+0x54>
 65c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 65f:	89 de                	mov    %ebx,%esi
 661:	8b 5d 08             	mov    0x8(%ebp),%ebx
 664:	eb 1a                	jmp    680 <printf+0x1a0>
          s = "(null)";
 666:	bb d7 08 00 00       	mov    $0x8d7,%ebx
        while(*s != 0){
 66b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 66e:	b8 28 00 00 00       	mov    $0x28,%eax
 673:	89 de                	mov    %ebx,%esi
 675:	8b 5d 08             	mov    0x8(%ebp),%ebx
 678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 67f:	90                   	nop
  write(fd, &c, 1);
 680:	83 ec 04             	sub    $0x4,%esp
          s++;
 683:	83 c6 01             	add    $0x1,%esi
 686:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 689:	6a 01                	push   $0x1
 68b:	57                   	push   %edi
 68c:	53                   	push   %ebx
 68d:	e8 11 fd ff ff       	call   3a3 <write>
        while(*s != 0){
 692:	0f b6 06             	movzbl (%esi),%eax
 695:	83 c4 10             	add    $0x10,%esp
 698:	84 c0                	test   %al,%al
 69a:	75 e4                	jne    680 <printf+0x1a0>
 69c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 69f:	31 d2                	xor    %edx,%edx
 6a1:	e9 8e fe ff ff       	jmp    534 <printf+0x54>
 6a6:	66 90                	xchg   %ax,%ax
 6a8:	66 90                	xchg   %ax,%ax
 6aa:	66 90                	xchg   %ax,%ax
 6ac:	66 90                	xchg   %ax,%ax
 6ae:	66 90                	xchg   %ax,%ax

000006b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b0:	f3 0f 1e fb          	endbr32 
 6b4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b5:	a1 94 0b 00 00       	mov    0xb94,%eax
{
 6ba:	89 e5                	mov    %esp,%ebp
 6bc:	57                   	push   %edi
 6bd:	56                   	push   %esi
 6be:	53                   	push   %ebx
 6bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6c2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 6c4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c7:	39 c8                	cmp    %ecx,%eax
 6c9:	73 15                	jae    6e0 <free+0x30>
 6cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6cf:	90                   	nop
 6d0:	39 d1                	cmp    %edx,%ecx
 6d2:	72 14                	jb     6e8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d4:	39 d0                	cmp    %edx,%eax
 6d6:	73 10                	jae    6e8 <free+0x38>
{
 6d8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6da:	8b 10                	mov    (%eax),%edx
 6dc:	39 c8                	cmp    %ecx,%eax
 6de:	72 f0                	jb     6d0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e0:	39 d0                	cmp    %edx,%eax
 6e2:	72 f4                	jb     6d8 <free+0x28>
 6e4:	39 d1                	cmp    %edx,%ecx
 6e6:	73 f0                	jae    6d8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ee:	39 fa                	cmp    %edi,%edx
 6f0:	74 1e                	je     710 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6f2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6f5:	8b 50 04             	mov    0x4(%eax),%edx
 6f8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6fb:	39 f1                	cmp    %esi,%ecx
 6fd:	74 28                	je     727 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6ff:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 701:	5b                   	pop    %ebx
  freep = p;
 702:	a3 94 0b 00 00       	mov    %eax,0xb94
}
 707:	5e                   	pop    %esi
 708:	5f                   	pop    %edi
 709:	5d                   	pop    %ebp
 70a:	c3                   	ret    
 70b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 70f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 710:	03 72 04             	add    0x4(%edx),%esi
 713:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 716:	8b 10                	mov    (%eax),%edx
 718:	8b 12                	mov    (%edx),%edx
 71a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 71d:	8b 50 04             	mov    0x4(%eax),%edx
 720:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 723:	39 f1                	cmp    %esi,%ecx
 725:	75 d8                	jne    6ff <free+0x4f>
    p->s.size += bp->s.size;
 727:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 72a:	a3 94 0b 00 00       	mov    %eax,0xb94
    p->s.size += bp->s.size;
 72f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 732:	8b 53 f8             	mov    -0x8(%ebx),%edx
 735:	89 10                	mov    %edx,(%eax)
}
 737:	5b                   	pop    %ebx
 738:	5e                   	pop    %esi
 739:	5f                   	pop    %edi
 73a:	5d                   	pop    %ebp
 73b:	c3                   	ret    
 73c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000740 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 740:	f3 0f 1e fb          	endbr32 
 744:	55                   	push   %ebp
 745:	89 e5                	mov    %esp,%ebp
 747:	57                   	push   %edi
 748:	56                   	push   %esi
 749:	53                   	push   %ebx
 74a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 750:	8b 3d 94 0b 00 00    	mov    0xb94,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 756:	8d 70 07             	lea    0x7(%eax),%esi
 759:	c1 ee 03             	shr    $0x3,%esi
 75c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 75f:	85 ff                	test   %edi,%edi
 761:	0f 84 a9 00 00 00    	je     810 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 767:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 769:	8b 48 04             	mov    0x4(%eax),%ecx
 76c:	39 f1                	cmp    %esi,%ecx
 76e:	73 6d                	jae    7dd <malloc+0x9d>
 770:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 776:	bb 00 10 00 00       	mov    $0x1000,%ebx
 77b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 77e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 785:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 788:	eb 17                	jmp    7a1 <malloc+0x61>
 78a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 790:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 792:	8b 4a 04             	mov    0x4(%edx),%ecx
 795:	39 f1                	cmp    %esi,%ecx
 797:	73 4f                	jae    7e8 <malloc+0xa8>
 799:	8b 3d 94 0b 00 00    	mov    0xb94,%edi
 79f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a1:	39 c7                	cmp    %eax,%edi
 7a3:	75 eb                	jne    790 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 7a5:	83 ec 0c             	sub    $0xc,%esp
 7a8:	ff 75 e4             	pushl  -0x1c(%ebp)
 7ab:	e8 5b fc ff ff       	call   40b <sbrk>
  if(p == (char*)-1)
 7b0:	83 c4 10             	add    $0x10,%esp
 7b3:	83 f8 ff             	cmp    $0xffffffff,%eax
 7b6:	74 1b                	je     7d3 <malloc+0x93>
  hp->s.size = nu;
 7b8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7bb:	83 ec 0c             	sub    $0xc,%esp
 7be:	83 c0 08             	add    $0x8,%eax
 7c1:	50                   	push   %eax
 7c2:	e8 e9 fe ff ff       	call   6b0 <free>
  return freep;
 7c7:	a1 94 0b 00 00       	mov    0xb94,%eax
      if((p = morecore(nunits)) == 0)
 7cc:	83 c4 10             	add    $0x10,%esp
 7cf:	85 c0                	test   %eax,%eax
 7d1:	75 bd                	jne    790 <malloc+0x50>
        return 0;
  }
}
 7d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7d6:	31 c0                	xor    %eax,%eax
}
 7d8:	5b                   	pop    %ebx
 7d9:	5e                   	pop    %esi
 7da:	5f                   	pop    %edi
 7db:	5d                   	pop    %ebp
 7dc:	c3                   	ret    
    if(p->s.size >= nunits){
 7dd:	89 c2                	mov    %eax,%edx
 7df:	89 f8                	mov    %edi,%eax
 7e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 7e8:	39 ce                	cmp    %ecx,%esi
 7ea:	74 54                	je     840 <malloc+0x100>
        p->s.size -= nunits;
 7ec:	29 f1                	sub    %esi,%ecx
 7ee:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 7f1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 7f4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 7f7:	a3 94 0b 00 00       	mov    %eax,0xb94
}
 7fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7ff:	8d 42 08             	lea    0x8(%edx),%eax
}
 802:	5b                   	pop    %ebx
 803:	5e                   	pop    %esi
 804:	5f                   	pop    %edi
 805:	5d                   	pop    %ebp
 806:	c3                   	ret    
 807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 80e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 810:	c7 05 94 0b 00 00 98 	movl   $0xb98,0xb94
 817:	0b 00 00 
    base.s.size = 0;
 81a:	bf 98 0b 00 00       	mov    $0xb98,%edi
    base.s.ptr = freep = prevp = &base;
 81f:	c7 05 98 0b 00 00 98 	movl   $0xb98,0xb98
 826:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 829:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 82b:	c7 05 9c 0b 00 00 00 	movl   $0x0,0xb9c
 832:	00 00 00 
    if(p->s.size >= nunits){
 835:	e9 36 ff ff ff       	jmp    770 <malloc+0x30>
 83a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 840:	8b 0a                	mov    (%edx),%ecx
 842:	89 08                	mov    %ecx,(%eax)
 844:	eb b1                	jmp    7f7 <malloc+0xb7>
