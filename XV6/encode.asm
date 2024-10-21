
_encode:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
        }
    }
    output[i] = '\0'; // Null-terminate the output string
}

int main(int argc, char *argv[]) {
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	81 ec 08 02 00 00    	sub    $0x208,%esp
  1b:	8b 01                	mov    (%ecx),%eax
  1d:	8b 51 04             	mov    0x4(%ecx),%edx
    char input[256];    // Buffer for user input
    char output[256];   // Buffer for output

    if (argc < 2) {
  20:	83 f8 01             	cmp    $0x1,%eax
  23:	0f 8e ed 00 00 00    	jle    116 <main+0x116>
        printf(2, "Usage: encode <string>\n");
        exit();
    }

    input[0] = '\0';
  29:	c6 85 e8 fd ff ff 00 	movb   $0x0,-0x218(%ebp)

    // Combine all arguments into the input string
    for (int i = 1; i < argc; i++) {  // Start from index 1 to skip the program name
        if (i > 1) {
  30:	8d 7c 82 fc          	lea    -0x4(%edx,%eax,4),%edi
  34:	8d 5a 04             	lea    0x4(%edx),%ebx
    input[0] = '\0';
  37:	31 c0                	xor    %eax,%eax
  39:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
  3f:	90                   	nop
    while (*dest) {  // Move to the end of dest
  40:	84 c0                	test   %al,%al
            my_strcat(input, " ");  // Add a space between words
        }
        my_strcat(input, argv[i]);
  42:	8b 0b                	mov    (%ebx),%ecx
    while (*dest) {  // Move to the end of dest
  44:	89 f0                	mov    %esi,%eax
  46:	74 20                	je     68 <main+0x68>
  48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  4f:	90                   	nop
        dest++;
  50:	83 c0 01             	add    $0x1,%eax
    while (*dest) {  // Move to the end of dest
  53:	80 38 00             	cmpb   $0x0,(%eax)
  56:	75 f8                	jne    50 <main+0x50>
    while (*src) {  // Copy src to dest
  58:	0f b6 11             	movzbl (%ecx),%edx
  5b:	84 d2                	test   %dl,%dl
  5d:	74 10                	je     6f <main+0x6f>
  5f:	90                   	nop
        *dest++ = *src++;
  60:	88 10                	mov    %dl,(%eax)
  62:	83 c0 01             	add    $0x1,%eax
  65:	83 c1 01             	add    $0x1,%ecx
    while (*src) {  // Copy src to dest
  68:	0f b6 11             	movzbl (%ecx),%edx
  6b:	84 d2                	test   %dl,%dl
  6d:	75 f1                	jne    60 <main+0x60>
    *dest = '\0';  // Null-terminate the concatenated string
  6f:	c6 00 00             	movb   $0x0,(%eax)
    for (int i = 1; i < argc; i++) {  // Start from index 1 to skip the program name
  72:	39 fb                	cmp    %edi,%ebx
  74:	74 32                	je     a8 <main+0xa8>
    while (*dest) {  // Move to the end of dest
  76:	80 bd e8 fd ff ff 00 	cmpb   $0x0,-0x218(%ebp)
  7d:	89 f0                	mov    %esi,%eax
  7f:	74 0f                	je     90 <main+0x90>
  81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        dest++;
  88:	83 c0 01             	add    $0x1,%eax
    while (*dest) {  // Move to the end of dest
  8b:	80 38 00             	cmpb   $0x0,(%eax)
  8e:	75 f8                	jne    88 <main+0x88>
        *dest++ = *src++;
  90:	ba 20 00 00 00       	mov    $0x20,%edx
  95:	83 c3 04             	add    $0x4,%ebx
  98:	66 89 10             	mov    %dx,(%eax)
  9b:	0f b6 85 e8 fd ff ff 	movzbl -0x218(%ebp),%eax
  a2:	eb 9c                	jmp    40 <main+0x40>
  a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }

    // Encrypt the input string
    encrypt(input, output);
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	8d bd e8 fe ff ff    	lea    -0x118(%ebp),%edi
  b1:	57                   	push   %edi
  b2:	56                   	push   %esi
  b3:	e8 d8 00 00 00       	call   190 <encrypt>

    int fd = open("result.txt", O_CREATE | O_WRONLY);
  b8:	5a                   	pop    %edx
  b9:	59                   	pop    %ecx
  ba:	68 01 02 00 00       	push   $0x201
  bf:	68 60 09 00 00       	push   $0x960
  c4:	e8 fa 03 00 00       	call   4c3 <open>
    if (fd < 0) {
  c9:	83 c4 10             	add    $0x10,%esp
    int fd = open("result.txt", O_CREATE | O_WRONLY);
  cc:	89 c3                	mov    %eax,%ebx
    if (fd < 0) {
  ce:	85 c0                	test   %eax,%eax
  d0:	78 31                	js     103 <main+0x103>
        printf(2, "Error opening file for writing.\n");
        exit();
    }

    write(fd, output, strlen(output));
  d2:	83 ec 0c             	sub    $0xc,%esp
  d5:	57                   	push   %edi
  d6:	e8 c5 01 00 00       	call   2a0 <strlen>
  db:	83 c4 0c             	add    $0xc,%esp
  de:	50                   	push   %eax
  df:	57                   	push   %edi
  e0:	53                   	push   %ebx
  e1:	e8 bd 03 00 00       	call   4a3 <write>
    write(fd, "\n", 1);
  e6:	83 c4 0c             	add    $0xc,%esp
  e9:	6a 01                	push   $0x1
  eb:	68 5e 09 00 00       	push   $0x95e
  f0:	53                   	push   %ebx
  f1:	e8 ad 03 00 00       	call   4a3 <write>

    close(fd);
  f6:	89 1c 24             	mov    %ebx,(%esp)
  f9:	e8 ad 03 00 00       	call   4ab <close>

    exit();
  fe:	e8 80 03 00 00       	call   483 <exit>
        printf(2, "Error opening file for writing.\n");
 103:	50                   	push   %eax
 104:	50                   	push   %eax
 105:	68 6c 09 00 00       	push   $0x96c
 10a:	6a 02                	push   $0x2
 10c:	e8 cf 04 00 00       	call   5e0 <printf>
        exit();
 111:	e8 6d 03 00 00       	call   483 <exit>
        printf(2, "Usage: encode <string>\n");
 116:	51                   	push   %ecx
 117:	51                   	push   %ecx
 118:	68 48 09 00 00       	push   $0x948
 11d:	6a 02                	push   $0x2
 11f:	e8 bc 04 00 00       	call   5e0 <printf>
        exit();
 124:	e8 5a 03 00 00       	call   483 <exit>
 129:	66 90                	xchg   %ax,%ax
 12b:	66 90                	xchg   %ax,%ax
 12d:	66 90                	xchg   %ax,%ax
 12f:	90                   	nop

00000130 <my_strcat>:
void my_strcat(char *dest, const char *src) {
 130:	f3 0f 1e fb          	endbr32 
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	8b 45 08             	mov    0x8(%ebp),%eax
 13a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while (*dest) {  // Move to the end of dest
 13d:	80 38 00             	cmpb   $0x0,(%eax)
 140:	74 26                	je     168 <my_strcat+0x38>
 142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        dest++;
 148:	83 c0 01             	add    $0x1,%eax
    while (*dest) {  // Move to the end of dest
 14b:	80 38 00             	cmpb   $0x0,(%eax)
 14e:	75 f8                	jne    148 <my_strcat+0x18>
    while (*src) {  // Copy src to dest
 150:	0f b6 11             	movzbl (%ecx),%edx
 153:	84 d2                	test   %dl,%dl
 155:	74 18                	je     16f <my_strcat+0x3f>
 157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15e:	66 90                	xchg   %ax,%ax
        *dest++ = *src++;
 160:	88 10                	mov    %dl,(%eax)
 162:	83 c0 01             	add    $0x1,%eax
 165:	83 c1 01             	add    $0x1,%ecx
    while (*src) {  // Copy src to dest
 168:	0f b6 11             	movzbl (%ecx),%edx
 16b:	84 d2                	test   %dl,%dl
 16d:	75 f1                	jne    160 <my_strcat+0x30>
    *dest = '\0';  // Null-terminate the concatenated string
 16f:	c6 00 00             	movb   $0x0,(%eax)
}
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    
 174:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 17b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 17f:	90                   	nop

00000180 <calculateKey>:
int calculateKey() {
 180:	f3 0f 1e fb          	endbr32 
}
 184:	b8 03 00 00 00       	mov    $0x3,%eax
 189:	c3                   	ret    
 18a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000190 <encrypt>:
void encrypt(char *input, char *output) {
 190:	f3 0f 1e fb          	endbr32 
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	57                   	push   %edi
 198:	8b 7d 08             	mov    0x8(%ebp),%edi
 19b:	56                   	push   %esi
 19c:	53                   	push   %ebx
 19d:	8b 75 0c             	mov    0xc(%ebp),%esi
    for (i = 0; input[i] != '\0'; i++) {
 1a0:	0f be 0f             	movsbl (%edi),%ecx
 1a3:	84 c9                	test   %cl,%cl
 1a5:	74 5f                	je     206 <encrypt+0x76>
 1a7:	31 db                	xor    %ebx,%ebx
 1a9:	eb 28                	jmp    1d3 <encrypt+0x43>
 1ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1af:	90                   	nop
            output[i] = (input[i] - 'a' + KEY) % MODE + 'a';
 1b0:	83 e9 5e             	sub    $0x5e,%ecx
 1b3:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
 1b8:	f7 e1                	mul    %ecx
 1ba:	c1 ea 03             	shr    $0x3,%edx
 1bd:	6b d2 1a             	imul   $0x1a,%edx,%edx
 1c0:	29 d1                	sub    %edx,%ecx
 1c2:	83 c1 61             	add    $0x61,%ecx
 1c5:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
    for (i = 0; input[i] != '\0'; i++) {
 1c8:	83 c3 01             	add    $0x1,%ebx
 1cb:	0f be 0c 1f          	movsbl (%edi,%ebx,1),%ecx
 1cf:	84 c9                	test   %cl,%cl
 1d1:	74 31                	je     204 <encrypt+0x74>
        if (input[i] >= 'a' && input[i] <= 'z') {
 1d3:	8d 41 9f             	lea    -0x61(%ecx),%eax
 1d6:	3c 19                	cmp    $0x19,%al
 1d8:	76 d6                	jbe    1b0 <encrypt+0x20>
        } else if (input[i] >= 'A' && input[i] <= 'Z') {
 1da:	8d 41 bf             	lea    -0x41(%ecx),%eax
 1dd:	3c 19                	cmp    $0x19,%al
 1df:	77 2f                	ja     210 <encrypt+0x80>
            output[i] = (input[i] - 'A' + KEY) % MODE + 'A';
 1e1:	83 e9 3e             	sub    $0x3e,%ecx
 1e4:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
 1e9:	f7 e1                	mul    %ecx
 1eb:	c1 ea 03             	shr    $0x3,%edx
 1ee:	6b d2 1a             	imul   $0x1a,%edx,%edx
 1f1:	29 d1                	sub    %edx,%ecx
 1f3:	83 c1 41             	add    $0x41,%ecx
 1f6:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
    for (i = 0; input[i] != '\0'; i++) {
 1f9:	83 c3 01             	add    $0x1,%ebx
 1fc:	0f be 0c 1f          	movsbl (%edi,%ebx,1),%ecx
 200:	84 c9                	test   %cl,%cl
 202:	75 cf                	jne    1d3 <encrypt+0x43>
 204:	01 de                	add    %ebx,%esi
    output[i] = '\0'; // Null-terminate the output string
 206:	c6 06 00             	movb   $0x0,(%esi)
}
 209:	5b                   	pop    %ebx
 20a:	5e                   	pop    %esi
 20b:	5f                   	pop    %edi
 20c:	5d                   	pop    %ebp
 20d:	c3                   	ret    
 20e:	66 90                	xchg   %ax,%ax
            output[i] = input[i]; // Non-alphabetic characters remain unchanged
 210:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
 213:	eb b3                	jmp    1c8 <encrypt+0x38>
 215:	66 90                	xchg   %ax,%ax
 217:	66 90                	xchg   %ax,%ax
 219:	66 90                	xchg   %ax,%ax
 21b:	66 90                	xchg   %ax,%ax
 21d:	66 90                	xchg   %ax,%ax
 21f:	90                   	nop

00000220 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 220:	f3 0f 1e fb          	endbr32 
 224:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 225:	31 c0                	xor    %eax,%eax
{
 227:	89 e5                	mov    %esp,%ebp
 229:	53                   	push   %ebx
 22a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 22d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 230:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 234:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 237:	83 c0 01             	add    $0x1,%eax
 23a:	84 d2                	test   %dl,%dl
 23c:	75 f2                	jne    230 <strcpy+0x10>
    ;
  return os;
}
 23e:	89 c8                	mov    %ecx,%eax
 240:	5b                   	pop    %ebx
 241:	5d                   	pop    %ebp
 242:	c3                   	ret    
 243:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000250 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 250:	f3 0f 1e fb          	endbr32 
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	53                   	push   %ebx
 258:	8b 4d 08             	mov    0x8(%ebp),%ecx
 25b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 25e:	0f b6 01             	movzbl (%ecx),%eax
 261:	0f b6 1a             	movzbl (%edx),%ebx
 264:	84 c0                	test   %al,%al
 266:	75 19                	jne    281 <strcmp+0x31>
 268:	eb 26                	jmp    290 <strcmp+0x40>
 26a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 270:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 274:	83 c1 01             	add    $0x1,%ecx
 277:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 27a:	0f b6 1a             	movzbl (%edx),%ebx
 27d:	84 c0                	test   %al,%al
 27f:	74 0f                	je     290 <strcmp+0x40>
 281:	38 d8                	cmp    %bl,%al
 283:	74 eb                	je     270 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 285:	29 d8                	sub    %ebx,%eax
}
 287:	5b                   	pop    %ebx
 288:	5d                   	pop    %ebp
 289:	c3                   	ret    
 28a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 290:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 292:	29 d8                	sub    %ebx,%eax
}
 294:	5b                   	pop    %ebx
 295:	5d                   	pop    %ebp
 296:	c3                   	ret    
 297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29e:	66 90                	xchg   %ax,%ax

000002a0 <strlen>:

uint
strlen(const char *s)
{
 2a0:	f3 0f 1e fb          	endbr32 
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 2aa:	80 3a 00             	cmpb   $0x0,(%edx)
 2ad:	74 21                	je     2d0 <strlen+0x30>
 2af:	31 c0                	xor    %eax,%eax
 2b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2b8:	83 c0 01             	add    $0x1,%eax
 2bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 2bf:	89 c1                	mov    %eax,%ecx
 2c1:	75 f5                	jne    2b8 <strlen+0x18>
    ;
  return n;
}
 2c3:	89 c8                	mov    %ecx,%eax
 2c5:	5d                   	pop    %ebp
 2c6:	c3                   	ret    
 2c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ce:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 2d0:	31 c9                	xor    %ecx,%ecx
}
 2d2:	5d                   	pop    %ebp
 2d3:	89 c8                	mov    %ecx,%eax
 2d5:	c3                   	ret    
 2d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2dd:	8d 76 00             	lea    0x0(%esi),%esi

000002e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e0:	f3 0f 1e fb          	endbr32 
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	57                   	push   %edi
 2e8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f1:	89 d7                	mov    %edx,%edi
 2f3:	fc                   	cld    
 2f4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2f6:	89 d0                	mov    %edx,%eax
 2f8:	5f                   	pop    %edi
 2f9:	5d                   	pop    %ebp
 2fa:	c3                   	ret    
 2fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2ff:	90                   	nop

00000300 <strchr>:

char*
strchr(const char *s, char c)
{
 300:	f3 0f 1e fb          	endbr32 
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	8b 45 08             	mov    0x8(%ebp),%eax
 30a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 30e:	0f b6 10             	movzbl (%eax),%edx
 311:	84 d2                	test   %dl,%dl
 313:	75 16                	jne    32b <strchr+0x2b>
 315:	eb 21                	jmp    338 <strchr+0x38>
 317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 31e:	66 90                	xchg   %ax,%ax
 320:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 324:	83 c0 01             	add    $0x1,%eax
 327:	84 d2                	test   %dl,%dl
 329:	74 0d                	je     338 <strchr+0x38>
    if(*s == c)
 32b:	38 d1                	cmp    %dl,%cl
 32d:	75 f1                	jne    320 <strchr+0x20>
      return (char*)s;
  return 0;
}
 32f:	5d                   	pop    %ebp
 330:	c3                   	ret    
 331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 338:	31 c0                	xor    %eax,%eax
}
 33a:	5d                   	pop    %ebp
 33b:	c3                   	ret    
 33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000340 <gets>:

char*
gets(char *buf, int max)
{
 340:	f3 0f 1e fb          	endbr32 
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	57                   	push   %edi
 348:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 349:	31 f6                	xor    %esi,%esi
{
 34b:	53                   	push   %ebx
 34c:	89 f3                	mov    %esi,%ebx
 34e:	83 ec 1c             	sub    $0x1c,%esp
 351:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 354:	eb 33                	jmp    389 <gets+0x49>
 356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 360:	83 ec 04             	sub    $0x4,%esp
 363:	8d 45 e7             	lea    -0x19(%ebp),%eax
 366:	6a 01                	push   $0x1
 368:	50                   	push   %eax
 369:	6a 00                	push   $0x0
 36b:	e8 2b 01 00 00       	call   49b <read>
    if(cc < 1)
 370:	83 c4 10             	add    $0x10,%esp
 373:	85 c0                	test   %eax,%eax
 375:	7e 1c                	jle    393 <gets+0x53>
      break;
    buf[i++] = c;
 377:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 37b:	83 c7 01             	add    $0x1,%edi
 37e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 381:	3c 0a                	cmp    $0xa,%al
 383:	74 23                	je     3a8 <gets+0x68>
 385:	3c 0d                	cmp    $0xd,%al
 387:	74 1f                	je     3a8 <gets+0x68>
  for(i=0; i+1 < max; ){
 389:	83 c3 01             	add    $0x1,%ebx
 38c:	89 fe                	mov    %edi,%esi
 38e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 391:	7c cd                	jl     360 <gets+0x20>
 393:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 395:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 398:	c6 03 00             	movb   $0x0,(%ebx)
}
 39b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 39e:	5b                   	pop    %ebx
 39f:	5e                   	pop    %esi
 3a0:	5f                   	pop    %edi
 3a1:	5d                   	pop    %ebp
 3a2:	c3                   	ret    
 3a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3a7:	90                   	nop
 3a8:	8b 75 08             	mov    0x8(%ebp),%esi
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	01 de                	add    %ebx,%esi
 3b0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 3b2:	c6 03 00             	movb   $0x0,(%ebx)
}
 3b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3b8:	5b                   	pop    %ebx
 3b9:	5e                   	pop    %esi
 3ba:	5f                   	pop    %edi
 3bb:	5d                   	pop    %ebp
 3bc:	c3                   	ret    
 3bd:	8d 76 00             	lea    0x0(%esi),%esi

000003c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3c0:	f3 0f 1e fb          	endbr32 
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	56                   	push   %esi
 3c8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c9:	83 ec 08             	sub    $0x8,%esp
 3cc:	6a 00                	push   $0x0
 3ce:	ff 75 08             	pushl  0x8(%ebp)
 3d1:	e8 ed 00 00 00       	call   4c3 <open>
  if(fd < 0)
 3d6:	83 c4 10             	add    $0x10,%esp
 3d9:	85 c0                	test   %eax,%eax
 3db:	78 2b                	js     408 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 3dd:	83 ec 08             	sub    $0x8,%esp
 3e0:	ff 75 0c             	pushl  0xc(%ebp)
 3e3:	89 c3                	mov    %eax,%ebx
 3e5:	50                   	push   %eax
 3e6:	e8 f0 00 00 00       	call   4db <fstat>
  close(fd);
 3eb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3ee:	89 c6                	mov    %eax,%esi
  close(fd);
 3f0:	e8 b6 00 00 00       	call   4ab <close>
  return r;
 3f5:	83 c4 10             	add    $0x10,%esp
}
 3f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3fb:	89 f0                	mov    %esi,%eax
 3fd:	5b                   	pop    %ebx
 3fe:	5e                   	pop    %esi
 3ff:	5d                   	pop    %ebp
 400:	c3                   	ret    
 401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 408:	be ff ff ff ff       	mov    $0xffffffff,%esi
 40d:	eb e9                	jmp    3f8 <stat+0x38>
 40f:	90                   	nop

00000410 <atoi>:

int
atoi(const char *s)
{
 410:	f3 0f 1e fb          	endbr32 
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	53                   	push   %ebx
 418:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 41b:	0f be 02             	movsbl (%edx),%eax
 41e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 421:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 424:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 429:	77 1a                	ja     445 <atoi+0x35>
 42b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 42f:	90                   	nop
    n = n*10 + *s++ - '0';
 430:	83 c2 01             	add    $0x1,%edx
 433:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 436:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 43a:	0f be 02             	movsbl (%edx),%eax
 43d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 440:	80 fb 09             	cmp    $0x9,%bl
 443:	76 eb                	jbe    430 <atoi+0x20>
  return n;
}
 445:	89 c8                	mov    %ecx,%eax
 447:	5b                   	pop    %ebx
 448:	5d                   	pop    %ebp
 449:	c3                   	ret    
 44a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000450 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 450:	f3 0f 1e fb          	endbr32 
 454:	55                   	push   %ebp
 455:	89 e5                	mov    %esp,%ebp
 457:	57                   	push   %edi
 458:	8b 45 10             	mov    0x10(%ebp),%eax
 45b:	8b 55 08             	mov    0x8(%ebp),%edx
 45e:	56                   	push   %esi
 45f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 462:	85 c0                	test   %eax,%eax
 464:	7e 0f                	jle    475 <memmove+0x25>
 466:	01 d0                	add    %edx,%eax
  dst = vdst;
 468:	89 d7                	mov    %edx,%edi
 46a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 470:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 471:	39 f8                	cmp    %edi,%eax
 473:	75 fb                	jne    470 <memmove+0x20>
  return vdst;
}
 475:	5e                   	pop    %esi
 476:	89 d0                	mov    %edx,%eax
 478:	5f                   	pop    %edi
 479:	5d                   	pop    %ebp
 47a:	c3                   	ret    

0000047b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 47b:	b8 01 00 00 00       	mov    $0x1,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <exit>:
SYSCALL(exit)
 483:	b8 02 00 00 00       	mov    $0x2,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <wait>:
SYSCALL(wait)
 48b:	b8 03 00 00 00       	mov    $0x3,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <pipe>:
SYSCALL(pipe)
 493:	b8 04 00 00 00       	mov    $0x4,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <read>:
SYSCALL(read)
 49b:	b8 05 00 00 00       	mov    $0x5,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <write>:
SYSCALL(write)
 4a3:	b8 10 00 00 00       	mov    $0x10,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <close>:
SYSCALL(close)
 4ab:	b8 15 00 00 00       	mov    $0x15,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <kill>:
SYSCALL(kill)
 4b3:	b8 06 00 00 00       	mov    $0x6,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <exec>:
SYSCALL(exec)
 4bb:	b8 07 00 00 00       	mov    $0x7,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <open>:
SYSCALL(open)
 4c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <mknod>:
SYSCALL(mknod)
 4cb:	b8 11 00 00 00       	mov    $0x11,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <unlink>:
SYSCALL(unlink)
 4d3:	b8 12 00 00 00       	mov    $0x12,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <fstat>:
SYSCALL(fstat)
 4db:	b8 08 00 00 00       	mov    $0x8,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <link>:
SYSCALL(link)
 4e3:	b8 13 00 00 00       	mov    $0x13,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <mkdir>:
SYSCALL(mkdir)
 4eb:	b8 14 00 00 00       	mov    $0x14,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <chdir>:
SYSCALL(chdir)
 4f3:	b8 09 00 00 00       	mov    $0x9,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <dup>:
SYSCALL(dup)
 4fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <getpid>:
SYSCALL(getpid)
 503:	b8 0b 00 00 00       	mov    $0xb,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <sbrk>:
SYSCALL(sbrk)
 50b:	b8 0c 00 00 00       	mov    $0xc,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <sleep>:
SYSCALL(sleep)
 513:	b8 0d 00 00 00       	mov    $0xd,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <uptime>:
SYSCALL(uptime)
 51b:	b8 0e 00 00 00       	mov    $0xe,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    
 523:	66 90                	xchg   %ax,%ax
 525:	66 90                	xchg   %ax,%ax
 527:	66 90                	xchg   %ax,%ax
 529:	66 90                	xchg   %ax,%ax
 52b:	66 90                	xchg   %ax,%ax
 52d:	66 90                	xchg   %ax,%ax
 52f:	90                   	nop

00000530 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	56                   	push   %esi
 535:	53                   	push   %ebx
 536:	83 ec 3c             	sub    $0x3c,%esp
 539:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 53c:	89 d1                	mov    %edx,%ecx
{
 53e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 541:	85 d2                	test   %edx,%edx
 543:	0f 89 7f 00 00 00    	jns    5c8 <printint+0x98>
 549:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 54d:	74 79                	je     5c8 <printint+0x98>
    neg = 1;
 54f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 556:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 558:	31 db                	xor    %ebx,%ebx
 55a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 55d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 560:	89 c8                	mov    %ecx,%eax
 562:	31 d2                	xor    %edx,%edx
 564:	89 cf                	mov    %ecx,%edi
 566:	f7 75 c4             	divl   -0x3c(%ebp)
 569:	0f b6 92 94 09 00 00 	movzbl 0x994(%edx),%edx
 570:	89 45 c0             	mov    %eax,-0x40(%ebp)
 573:	89 d8                	mov    %ebx,%eax
 575:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 578:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 57b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 57e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 581:	76 dd                	jbe    560 <printint+0x30>
  if(neg)
 583:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 586:	85 c9                	test   %ecx,%ecx
 588:	74 0c                	je     596 <printint+0x66>
    buf[i++] = '-';
 58a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 58f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 591:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 596:	8b 7d b8             	mov    -0x48(%ebp),%edi
 599:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 59d:	eb 07                	jmp    5a6 <printint+0x76>
 59f:	90                   	nop
 5a0:	0f b6 13             	movzbl (%ebx),%edx
 5a3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 5a6:	83 ec 04             	sub    $0x4,%esp
 5a9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 5ac:	6a 01                	push   $0x1
 5ae:	56                   	push   %esi
 5af:	57                   	push   %edi
 5b0:	e8 ee fe ff ff       	call   4a3 <write>
  while(--i >= 0)
 5b5:	83 c4 10             	add    $0x10,%esp
 5b8:	39 de                	cmp    %ebx,%esi
 5ba:	75 e4                	jne    5a0 <printint+0x70>
    putc(fd, buf[i]);
}
 5bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5bf:	5b                   	pop    %ebx
 5c0:	5e                   	pop    %esi
 5c1:	5f                   	pop    %edi
 5c2:	5d                   	pop    %ebp
 5c3:	c3                   	ret    
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5c8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 5cf:	eb 87                	jmp    558 <printint+0x28>
 5d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5df:	90                   	nop

000005e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5e0:	f3 0f 1e fb          	endbr32 
 5e4:	55                   	push   %ebp
 5e5:	89 e5                	mov    %esp,%ebp
 5e7:	57                   	push   %edi
 5e8:	56                   	push   %esi
 5e9:	53                   	push   %ebx
 5ea:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ed:	8b 75 0c             	mov    0xc(%ebp),%esi
 5f0:	0f b6 1e             	movzbl (%esi),%ebx
 5f3:	84 db                	test   %bl,%bl
 5f5:	0f 84 b4 00 00 00    	je     6af <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 5fb:	8d 45 10             	lea    0x10(%ebp),%eax
 5fe:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 601:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 604:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 606:	89 45 d0             	mov    %eax,-0x30(%ebp)
 609:	eb 33                	jmp    63e <printf+0x5e>
 60b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 60f:	90                   	nop
 610:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 613:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 618:	83 f8 25             	cmp    $0x25,%eax
 61b:	74 17                	je     634 <printf+0x54>
  write(fd, &c, 1);
 61d:	83 ec 04             	sub    $0x4,%esp
 620:	88 5d e7             	mov    %bl,-0x19(%ebp)
 623:	6a 01                	push   $0x1
 625:	57                   	push   %edi
 626:	ff 75 08             	pushl  0x8(%ebp)
 629:	e8 75 fe ff ff       	call   4a3 <write>
 62e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 631:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 634:	0f b6 1e             	movzbl (%esi),%ebx
 637:	83 c6 01             	add    $0x1,%esi
 63a:	84 db                	test   %bl,%bl
 63c:	74 71                	je     6af <printf+0xcf>
    c = fmt[i] & 0xff;
 63e:	0f be cb             	movsbl %bl,%ecx
 641:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 644:	85 d2                	test   %edx,%edx
 646:	74 c8                	je     610 <printf+0x30>
      }
    } else if(state == '%'){
 648:	83 fa 25             	cmp    $0x25,%edx
 64b:	75 e7                	jne    634 <printf+0x54>
      if(c == 'd'){
 64d:	83 f8 64             	cmp    $0x64,%eax
 650:	0f 84 9a 00 00 00    	je     6f0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 656:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 65c:	83 f9 70             	cmp    $0x70,%ecx
 65f:	74 5f                	je     6c0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 661:	83 f8 73             	cmp    $0x73,%eax
 664:	0f 84 d6 00 00 00    	je     740 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 66a:	83 f8 63             	cmp    $0x63,%eax
 66d:	0f 84 8d 00 00 00    	je     700 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 673:	83 f8 25             	cmp    $0x25,%eax
 676:	0f 84 b4 00 00 00    	je     730 <printf+0x150>
  write(fd, &c, 1);
 67c:	83 ec 04             	sub    $0x4,%esp
 67f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 683:	6a 01                	push   $0x1
 685:	57                   	push   %edi
 686:	ff 75 08             	pushl  0x8(%ebp)
 689:	e8 15 fe ff ff       	call   4a3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 68e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 691:	83 c4 0c             	add    $0xc,%esp
 694:	6a 01                	push   $0x1
 696:	83 c6 01             	add    $0x1,%esi
 699:	57                   	push   %edi
 69a:	ff 75 08             	pushl  0x8(%ebp)
 69d:	e8 01 fe ff ff       	call   4a3 <write>
  for(i = 0; fmt[i]; i++){
 6a2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 6a6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6a9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 6ab:	84 db                	test   %bl,%bl
 6ad:	75 8f                	jne    63e <printf+0x5e>
    }
  }
}
 6af:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6b2:	5b                   	pop    %ebx
 6b3:	5e                   	pop    %esi
 6b4:	5f                   	pop    %edi
 6b5:	5d                   	pop    %ebp
 6b6:	c3                   	ret    
 6b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6be:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 6c0:	83 ec 0c             	sub    $0xc,%esp
 6c3:	b9 10 00 00 00       	mov    $0x10,%ecx
 6c8:	6a 00                	push   $0x0
 6ca:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6cd:	8b 45 08             	mov    0x8(%ebp),%eax
 6d0:	8b 13                	mov    (%ebx),%edx
 6d2:	e8 59 fe ff ff       	call   530 <printint>
        ap++;
 6d7:	89 d8                	mov    %ebx,%eax
 6d9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6dc:	31 d2                	xor    %edx,%edx
        ap++;
 6de:	83 c0 04             	add    $0x4,%eax
 6e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6e4:	e9 4b ff ff ff       	jmp    634 <printf+0x54>
 6e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 6f0:	83 ec 0c             	sub    $0xc,%esp
 6f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6f8:	6a 01                	push   $0x1
 6fa:	eb ce                	jmp    6ca <printf+0xea>
 6fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 700:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 703:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 706:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 708:	6a 01                	push   $0x1
        ap++;
 70a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 70d:	57                   	push   %edi
 70e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 711:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 714:	e8 8a fd ff ff       	call   4a3 <write>
        ap++;
 719:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 71c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 71f:	31 d2                	xor    %edx,%edx
 721:	e9 0e ff ff ff       	jmp    634 <printf+0x54>
 726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 72d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 730:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 733:	83 ec 04             	sub    $0x4,%esp
 736:	e9 59 ff ff ff       	jmp    694 <printf+0xb4>
 73b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 73f:	90                   	nop
        s = (char*)*ap;
 740:	8b 45 d0             	mov    -0x30(%ebp),%eax
 743:	8b 18                	mov    (%eax),%ebx
        ap++;
 745:	83 c0 04             	add    $0x4,%eax
 748:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 74b:	85 db                	test   %ebx,%ebx
 74d:	74 17                	je     766 <printf+0x186>
        while(*s != 0){
 74f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 752:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 754:	84 c0                	test   %al,%al
 756:	0f 84 d8 fe ff ff    	je     634 <printf+0x54>
 75c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 75f:	89 de                	mov    %ebx,%esi
 761:	8b 5d 08             	mov    0x8(%ebp),%ebx
 764:	eb 1a                	jmp    780 <printf+0x1a0>
          s = "(null)";
 766:	bb 8d 09 00 00       	mov    $0x98d,%ebx
        while(*s != 0){
 76b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 76e:	b8 28 00 00 00       	mov    $0x28,%eax
 773:	89 de                	mov    %ebx,%esi
 775:	8b 5d 08             	mov    0x8(%ebp),%ebx
 778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 77f:	90                   	nop
  write(fd, &c, 1);
 780:	83 ec 04             	sub    $0x4,%esp
          s++;
 783:	83 c6 01             	add    $0x1,%esi
 786:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 789:	6a 01                	push   $0x1
 78b:	57                   	push   %edi
 78c:	53                   	push   %ebx
 78d:	e8 11 fd ff ff       	call   4a3 <write>
        while(*s != 0){
 792:	0f b6 06             	movzbl (%esi),%eax
 795:	83 c4 10             	add    $0x10,%esp
 798:	84 c0                	test   %al,%al
 79a:	75 e4                	jne    780 <printf+0x1a0>
 79c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 79f:	31 d2                	xor    %edx,%edx
 7a1:	e9 8e fe ff ff       	jmp    634 <printf+0x54>
 7a6:	66 90                	xchg   %ax,%ax
 7a8:	66 90                	xchg   %ax,%ax
 7aa:	66 90                	xchg   %ax,%ax
 7ac:	66 90                	xchg   %ax,%ax
 7ae:	66 90                	xchg   %ax,%ax

000007b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b0:	f3 0f 1e fb          	endbr32 
 7b4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b5:	a1 ac 0c 00 00       	mov    0xcac,%eax
{
 7ba:	89 e5                	mov    %esp,%ebp
 7bc:	57                   	push   %edi
 7bd:	56                   	push   %esi
 7be:	53                   	push   %ebx
 7bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7c2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 7c4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c7:	39 c8                	cmp    %ecx,%eax
 7c9:	73 15                	jae    7e0 <free+0x30>
 7cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7cf:	90                   	nop
 7d0:	39 d1                	cmp    %edx,%ecx
 7d2:	72 14                	jb     7e8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d4:	39 d0                	cmp    %edx,%eax
 7d6:	73 10                	jae    7e8 <free+0x38>
{
 7d8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7da:	8b 10                	mov    (%eax),%edx
 7dc:	39 c8                	cmp    %ecx,%eax
 7de:	72 f0                	jb     7d0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e0:	39 d0                	cmp    %edx,%eax
 7e2:	72 f4                	jb     7d8 <free+0x28>
 7e4:	39 d1                	cmp    %edx,%ecx
 7e6:	73 f0                	jae    7d8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7ee:	39 fa                	cmp    %edi,%edx
 7f0:	74 1e                	je     810 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7f2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7f5:	8b 50 04             	mov    0x4(%eax),%edx
 7f8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7fb:	39 f1                	cmp    %esi,%ecx
 7fd:	74 28                	je     827 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7ff:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 801:	5b                   	pop    %ebx
  freep = p;
 802:	a3 ac 0c 00 00       	mov    %eax,0xcac
}
 807:	5e                   	pop    %esi
 808:	5f                   	pop    %edi
 809:	5d                   	pop    %ebp
 80a:	c3                   	ret    
 80b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 80f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 810:	03 72 04             	add    0x4(%edx),%esi
 813:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 816:	8b 10                	mov    (%eax),%edx
 818:	8b 12                	mov    (%edx),%edx
 81a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 81d:	8b 50 04             	mov    0x4(%eax),%edx
 820:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 823:	39 f1                	cmp    %esi,%ecx
 825:	75 d8                	jne    7ff <free+0x4f>
    p->s.size += bp->s.size;
 827:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 82a:	a3 ac 0c 00 00       	mov    %eax,0xcac
    p->s.size += bp->s.size;
 82f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 832:	8b 53 f8             	mov    -0x8(%ebx),%edx
 835:	89 10                	mov    %edx,(%eax)
}
 837:	5b                   	pop    %ebx
 838:	5e                   	pop    %esi
 839:	5f                   	pop    %edi
 83a:	5d                   	pop    %ebp
 83b:	c3                   	ret    
 83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000840 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 840:	f3 0f 1e fb          	endbr32 
 844:	55                   	push   %ebp
 845:	89 e5                	mov    %esp,%ebp
 847:	57                   	push   %edi
 848:	56                   	push   %esi
 849:	53                   	push   %ebx
 84a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 850:	8b 3d ac 0c 00 00    	mov    0xcac,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 856:	8d 70 07             	lea    0x7(%eax),%esi
 859:	c1 ee 03             	shr    $0x3,%esi
 85c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 85f:	85 ff                	test   %edi,%edi
 861:	0f 84 a9 00 00 00    	je     910 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 867:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 869:	8b 48 04             	mov    0x4(%eax),%ecx
 86c:	39 f1                	cmp    %esi,%ecx
 86e:	73 6d                	jae    8dd <malloc+0x9d>
 870:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 876:	bb 00 10 00 00       	mov    $0x1000,%ebx
 87b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 87e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 885:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 888:	eb 17                	jmp    8a1 <malloc+0x61>
 88a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 890:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 892:	8b 4a 04             	mov    0x4(%edx),%ecx
 895:	39 f1                	cmp    %esi,%ecx
 897:	73 4f                	jae    8e8 <malloc+0xa8>
 899:	8b 3d ac 0c 00 00    	mov    0xcac,%edi
 89f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a1:	39 c7                	cmp    %eax,%edi
 8a3:	75 eb                	jne    890 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 8a5:	83 ec 0c             	sub    $0xc,%esp
 8a8:	ff 75 e4             	pushl  -0x1c(%ebp)
 8ab:	e8 5b fc ff ff       	call   50b <sbrk>
  if(p == (char*)-1)
 8b0:	83 c4 10             	add    $0x10,%esp
 8b3:	83 f8 ff             	cmp    $0xffffffff,%eax
 8b6:	74 1b                	je     8d3 <malloc+0x93>
  hp->s.size = nu;
 8b8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8bb:	83 ec 0c             	sub    $0xc,%esp
 8be:	83 c0 08             	add    $0x8,%eax
 8c1:	50                   	push   %eax
 8c2:	e8 e9 fe ff ff       	call   7b0 <free>
  return freep;
 8c7:	a1 ac 0c 00 00       	mov    0xcac,%eax
      if((p = morecore(nunits)) == 0)
 8cc:	83 c4 10             	add    $0x10,%esp
 8cf:	85 c0                	test   %eax,%eax
 8d1:	75 bd                	jne    890 <malloc+0x50>
        return 0;
  }
}
 8d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8d6:	31 c0                	xor    %eax,%eax
}
 8d8:	5b                   	pop    %ebx
 8d9:	5e                   	pop    %esi
 8da:	5f                   	pop    %edi
 8db:	5d                   	pop    %ebp
 8dc:	c3                   	ret    
    if(p->s.size >= nunits){
 8dd:	89 c2                	mov    %eax,%edx
 8df:	89 f8                	mov    %edi,%eax
 8e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 8e8:	39 ce                	cmp    %ecx,%esi
 8ea:	74 54                	je     940 <malloc+0x100>
        p->s.size -= nunits;
 8ec:	29 f1                	sub    %esi,%ecx
 8ee:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 8f1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 8f4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 8f7:	a3 ac 0c 00 00       	mov    %eax,0xcac
}
 8fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8ff:	8d 42 08             	lea    0x8(%edx),%eax
}
 902:	5b                   	pop    %ebx
 903:	5e                   	pop    %esi
 904:	5f                   	pop    %edi
 905:	5d                   	pop    %ebp
 906:	c3                   	ret    
 907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 90e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 910:	c7 05 ac 0c 00 00 b0 	movl   $0xcb0,0xcac
 917:	0c 00 00 
    base.s.size = 0;
 91a:	bf b0 0c 00 00       	mov    $0xcb0,%edi
    base.s.ptr = freep = prevp = &base;
 91f:	c7 05 b0 0c 00 00 b0 	movl   $0xcb0,0xcb0
 926:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 929:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 92b:	c7 05 b4 0c 00 00 00 	movl   $0x0,0xcb4
 932:	00 00 00 
    if(p->s.size >= nunits){
 935:	e9 36 ff ff ff       	jmp    870 <malloc+0x30>
 93a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 940:	8b 0a                	mov    (%edx),%ecx
 942:	89 08                	mov    %ecx,(%eax)
 944:	eb b1                	jmp    8f7 <malloc+0xb7>
