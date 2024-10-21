
_decode:     file format elf32-i386


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
  23:	0f 8e a4 00 00 00    	jle    cd <main+0xcd>
        printf(2, "Usage: encode <string>\n");
        exit();
    }

    // Initialize input buffer to an empty string
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
    decrypt(input, output);
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
  b1:	53                   	push   %ebx
  b2:	56                   	push   %esi
  b3:	e8 78 00 00 00       	call   130 <decrypt>
    printf(1, "%s\n", output); // Print the encrypted output
  b8:	83 c4 0c             	add    $0xc,%esp
  bb:	53                   	push   %ebx
  bc:	68 00 09 00 00       	push   $0x900
  c1:	6a 01                	push   $0x1
  c3:	e8 b8 04 00 00       	call   580 <printf>

    exit();
  c8:	e8 56 03 00 00       	call   423 <exit>
        printf(2, "Usage: encode <string>\n");
  cd:	51                   	push   %ecx
  ce:	51                   	push   %ecx
  cf:	68 e8 08 00 00       	push   $0x8e8
  d4:	6a 02                	push   $0x2
  d6:	e8 a5 04 00 00       	call   580 <printf>
        exit();
  db:	e8 43 03 00 00       	call   423 <exit>

000000e0 <my_strcat>:
void my_strcat(char *dest, const char *src) {
  e0:	f3 0f 1e fb          	endbr32 
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
  ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while (*dest) {  // Move to the end of dest
  ed:	80 38 00             	cmpb   $0x0,(%eax)
  f0:	74 26                	je     118 <my_strcat+0x38>
  f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        dest++;
  f8:	83 c0 01             	add    $0x1,%eax
    while (*dest) {  // Move to the end of dest
  fb:	80 38 00             	cmpb   $0x0,(%eax)
  fe:	75 f8                	jne    f8 <my_strcat+0x18>
    while (*src) {  // Copy src to dest
 100:	0f b6 11             	movzbl (%ecx),%edx
 103:	84 d2                	test   %dl,%dl
 105:	74 18                	je     11f <my_strcat+0x3f>
 107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10e:	66 90                	xchg   %ax,%ax
        *dest++ = *src++;
 110:	88 10                	mov    %dl,(%eax)
 112:	83 c0 01             	add    $0x1,%eax
 115:	83 c1 01             	add    $0x1,%ecx
    while (*src) {  // Copy src to dest
 118:	0f b6 11             	movzbl (%ecx),%edx
 11b:	84 d2                	test   %dl,%dl
 11d:	75 f1                	jne    110 <my_strcat+0x30>
    *dest = '\0';  // Null-terminate the concatenated string
 11f:	c6 00 00             	movb   $0x0,(%eax)
}
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    
 124:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 12f:	90                   	nop

00000130 <decrypt>:
void decrypt(char *input, char *output) {
 130:	f3 0f 1e fb          	endbr32 
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	57                   	push   %edi
 138:	8b 7d 08             	mov    0x8(%ebp),%edi
 13b:	56                   	push   %esi
 13c:	53                   	push   %ebx
 13d:	8b 75 0c             	mov    0xc(%ebp),%esi
    for (i = 0; input[i] != '\0'; i++) {
 140:	0f be 0f             	movsbl (%edi),%ecx
 143:	84 c9                	test   %cl,%cl
 145:	74 5f                	je     1a6 <decrypt+0x76>
 147:	31 db                	xor    %ebx,%ebx
 149:	eb 28                	jmp    173 <decrypt+0x43>
 14b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 14f:	90                   	nop
            output[i] = (input[i] - 'a' - KEY + 26) % 26 + 'a'; // Add 26 to handle negative results
 150:	83 e9 5b             	sub    $0x5b,%ecx
 153:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
 158:	f7 e1                	mul    %ecx
 15a:	c1 ea 03             	shr    $0x3,%edx
 15d:	6b d2 1a             	imul   $0x1a,%edx,%edx
 160:	29 d1                	sub    %edx,%ecx
 162:	83 c1 61             	add    $0x61,%ecx
 165:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
    for (i = 0; input[i] != '\0'; i++) {
 168:	83 c3 01             	add    $0x1,%ebx
 16b:	0f be 0c 1f          	movsbl (%edi,%ebx,1),%ecx
 16f:	84 c9                	test   %cl,%cl
 171:	74 31                	je     1a4 <decrypt+0x74>
        if (input[i] >= 'a' && input[i] <= 'z') {
 173:	8d 41 9f             	lea    -0x61(%ecx),%eax
 176:	3c 19                	cmp    $0x19,%al
 178:	76 d6                	jbe    150 <decrypt+0x20>
        } else if (input[i] >= 'A' && input[i] <= 'Z') {
 17a:	8d 41 bf             	lea    -0x41(%ecx),%eax
 17d:	3c 19                	cmp    $0x19,%al
 17f:	77 2f                	ja     1b0 <decrypt+0x80>
            output[i] = (input[i] - 'A' - KEY + 26) % 26 + 'A'; // Add 26 to handle negative results
 181:	83 e9 3b             	sub    $0x3b,%ecx
 184:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
 189:	f7 e1                	mul    %ecx
 18b:	c1 ea 03             	shr    $0x3,%edx
 18e:	6b d2 1a             	imul   $0x1a,%edx,%edx
 191:	29 d1                	sub    %edx,%ecx
 193:	83 c1 41             	add    $0x41,%ecx
 196:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
    for (i = 0; input[i] != '\0'; i++) {
 199:	83 c3 01             	add    $0x1,%ebx
 19c:	0f be 0c 1f          	movsbl (%edi,%ebx,1),%ecx
 1a0:	84 c9                	test   %cl,%cl
 1a2:	75 cf                	jne    173 <decrypt+0x43>
 1a4:	01 de                	add    %ebx,%esi
    output[i] = '\0'; // Null-terminate the output string
 1a6:	c6 06 00             	movb   $0x0,(%esi)
}
 1a9:	5b                   	pop    %ebx
 1aa:	5e                   	pop    %esi
 1ab:	5f                   	pop    %edi
 1ac:	5d                   	pop    %ebp
 1ad:	c3                   	ret    
 1ae:	66 90                	xchg   %ax,%ax
            output[i] = input[i]; // Non-alphabetic characters remain unchanged
 1b0:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
 1b3:	eb b3                	jmp    168 <decrypt+0x38>
 1b5:	66 90                	xchg   %ax,%ax
 1b7:	66 90                	xchg   %ax,%ax
 1b9:	66 90                	xchg   %ax,%ax
 1bb:	66 90                	xchg   %ax,%ax
 1bd:	66 90                	xchg   %ax,%ax
 1bf:	90                   	nop

000001c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1c0:	f3 0f 1e fb          	endbr32 
 1c4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1c5:	31 c0                	xor    %eax,%eax
{
 1c7:	89 e5                	mov    %esp,%ebp
 1c9:	53                   	push   %ebx
 1ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 1d0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1d4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1d7:	83 c0 01             	add    $0x1,%eax
 1da:	84 d2                	test   %dl,%dl
 1dc:	75 f2                	jne    1d0 <strcpy+0x10>
    ;
  return os;
}
 1de:	89 c8                	mov    %ecx,%eax
 1e0:	5b                   	pop    %ebx
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    
 1e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f0:	f3 0f 1e fb          	endbr32 
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	53                   	push   %ebx
 1f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1fe:	0f b6 01             	movzbl (%ecx),%eax
 201:	0f b6 1a             	movzbl (%edx),%ebx
 204:	84 c0                	test   %al,%al
 206:	75 19                	jne    221 <strcmp+0x31>
 208:	eb 26                	jmp    230 <strcmp+0x40>
 20a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 210:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 214:	83 c1 01             	add    $0x1,%ecx
 217:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 21a:	0f b6 1a             	movzbl (%edx),%ebx
 21d:	84 c0                	test   %al,%al
 21f:	74 0f                	je     230 <strcmp+0x40>
 221:	38 d8                	cmp    %bl,%al
 223:	74 eb                	je     210 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 225:	29 d8                	sub    %ebx,%eax
}
 227:	5b                   	pop    %ebx
 228:	5d                   	pop    %ebp
 229:	c3                   	ret    
 22a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 230:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 232:	29 d8                	sub    %ebx,%eax
}
 234:	5b                   	pop    %ebx
 235:	5d                   	pop    %ebp
 236:	c3                   	ret    
 237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23e:	66 90                	xchg   %ax,%ax

00000240 <strlen>:

uint
strlen(const char *s)
{
 240:	f3 0f 1e fb          	endbr32 
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 24a:	80 3a 00             	cmpb   $0x0,(%edx)
 24d:	74 21                	je     270 <strlen+0x30>
 24f:	31 c0                	xor    %eax,%eax
 251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 258:	83 c0 01             	add    $0x1,%eax
 25b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 25f:	89 c1                	mov    %eax,%ecx
 261:	75 f5                	jne    258 <strlen+0x18>
    ;
  return n;
}
 263:	89 c8                	mov    %ecx,%eax
 265:	5d                   	pop    %ebp
 266:	c3                   	ret    
 267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 270:	31 c9                	xor    %ecx,%ecx
}
 272:	5d                   	pop    %ebp
 273:	89 c8                	mov    %ecx,%eax
 275:	c3                   	ret    
 276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27d:	8d 76 00             	lea    0x0(%esi),%esi

00000280 <memset>:

void*
memset(void *dst, int c, uint n)
{
 280:	f3 0f 1e fb          	endbr32 
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	57                   	push   %edi
 288:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 28b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 28e:	8b 45 0c             	mov    0xc(%ebp),%eax
 291:	89 d7                	mov    %edx,%edi
 293:	fc                   	cld    
 294:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 296:	89 d0                	mov    %edx,%eax
 298:	5f                   	pop    %edi
 299:	5d                   	pop    %ebp
 29a:	c3                   	ret    
 29b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 29f:	90                   	nop

000002a0 <strchr>:

char*
strchr(const char *s, char c)
{
 2a0:	f3 0f 1e fb          	endbr32 
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2ae:	0f b6 10             	movzbl (%eax),%edx
 2b1:	84 d2                	test   %dl,%dl
 2b3:	75 16                	jne    2cb <strchr+0x2b>
 2b5:	eb 21                	jmp    2d8 <strchr+0x38>
 2b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2be:	66 90                	xchg   %ax,%ax
 2c0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2c4:	83 c0 01             	add    $0x1,%eax
 2c7:	84 d2                	test   %dl,%dl
 2c9:	74 0d                	je     2d8 <strchr+0x38>
    if(*s == c)
 2cb:	38 d1                	cmp    %dl,%cl
 2cd:	75 f1                	jne    2c0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 2cf:	5d                   	pop    %ebp
 2d0:	c3                   	ret    
 2d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2d8:	31 c0                	xor    %eax,%eax
}
 2da:	5d                   	pop    %ebp
 2db:	c3                   	ret    
 2dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002e0 <gets>:

char*
gets(char *buf, int max)
{
 2e0:	f3 0f 1e fb          	endbr32 
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	57                   	push   %edi
 2e8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e9:	31 f6                	xor    %esi,%esi
{
 2eb:	53                   	push   %ebx
 2ec:	89 f3                	mov    %esi,%ebx
 2ee:	83 ec 1c             	sub    $0x1c,%esp
 2f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 2f4:	eb 33                	jmp    329 <gets+0x49>
 2f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fd:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 300:	83 ec 04             	sub    $0x4,%esp
 303:	8d 45 e7             	lea    -0x19(%ebp),%eax
 306:	6a 01                	push   $0x1
 308:	50                   	push   %eax
 309:	6a 00                	push   $0x0
 30b:	e8 2b 01 00 00       	call   43b <read>
    if(cc < 1)
 310:	83 c4 10             	add    $0x10,%esp
 313:	85 c0                	test   %eax,%eax
 315:	7e 1c                	jle    333 <gets+0x53>
      break;
    buf[i++] = c;
 317:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 31b:	83 c7 01             	add    $0x1,%edi
 31e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 321:	3c 0a                	cmp    $0xa,%al
 323:	74 23                	je     348 <gets+0x68>
 325:	3c 0d                	cmp    $0xd,%al
 327:	74 1f                	je     348 <gets+0x68>
  for(i=0; i+1 < max; ){
 329:	83 c3 01             	add    $0x1,%ebx
 32c:	89 fe                	mov    %edi,%esi
 32e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 331:	7c cd                	jl     300 <gets+0x20>
 333:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 335:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 338:	c6 03 00             	movb   $0x0,(%ebx)
}
 33b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 33e:	5b                   	pop    %ebx
 33f:	5e                   	pop    %esi
 340:	5f                   	pop    %edi
 341:	5d                   	pop    %ebp
 342:	c3                   	ret    
 343:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 347:	90                   	nop
 348:	8b 75 08             	mov    0x8(%ebp),%esi
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
 34e:	01 de                	add    %ebx,%esi
 350:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 352:	c6 03 00             	movb   $0x0,(%ebx)
}
 355:	8d 65 f4             	lea    -0xc(%ebp),%esp
 358:	5b                   	pop    %ebx
 359:	5e                   	pop    %esi
 35a:	5f                   	pop    %edi
 35b:	5d                   	pop    %ebp
 35c:	c3                   	ret    
 35d:	8d 76 00             	lea    0x0(%esi),%esi

00000360 <stat>:

int
stat(const char *n, struct stat *st)
{
 360:	f3 0f 1e fb          	endbr32 
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	56                   	push   %esi
 368:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 369:	83 ec 08             	sub    $0x8,%esp
 36c:	6a 00                	push   $0x0
 36e:	ff 75 08             	pushl  0x8(%ebp)
 371:	e8 ed 00 00 00       	call   463 <open>
  if(fd < 0)
 376:	83 c4 10             	add    $0x10,%esp
 379:	85 c0                	test   %eax,%eax
 37b:	78 2b                	js     3a8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 37d:	83 ec 08             	sub    $0x8,%esp
 380:	ff 75 0c             	pushl  0xc(%ebp)
 383:	89 c3                	mov    %eax,%ebx
 385:	50                   	push   %eax
 386:	e8 f0 00 00 00       	call   47b <fstat>
  close(fd);
 38b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 38e:	89 c6                	mov    %eax,%esi
  close(fd);
 390:	e8 b6 00 00 00       	call   44b <close>
  return r;
 395:	83 c4 10             	add    $0x10,%esp
}
 398:	8d 65 f8             	lea    -0x8(%ebp),%esp
 39b:	89 f0                	mov    %esi,%eax
 39d:	5b                   	pop    %ebx
 39e:	5e                   	pop    %esi
 39f:	5d                   	pop    %ebp
 3a0:	c3                   	ret    
 3a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 3a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3ad:	eb e9                	jmp    398 <stat+0x38>
 3af:	90                   	nop

000003b0 <atoi>:

int
atoi(const char *s)
{
 3b0:	f3 0f 1e fb          	endbr32 
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	53                   	push   %ebx
 3b8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3bb:	0f be 02             	movsbl (%edx),%eax
 3be:	8d 48 d0             	lea    -0x30(%eax),%ecx
 3c1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3c9:	77 1a                	ja     3e5 <atoi+0x35>
 3cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3cf:	90                   	nop
    n = n*10 + *s++ - '0';
 3d0:	83 c2 01             	add    $0x1,%edx
 3d3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3d6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3da:	0f be 02             	movsbl (%edx),%eax
 3dd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3e0:	80 fb 09             	cmp    $0x9,%bl
 3e3:	76 eb                	jbe    3d0 <atoi+0x20>
  return n;
}
 3e5:	89 c8                	mov    %ecx,%eax
 3e7:	5b                   	pop    %ebx
 3e8:	5d                   	pop    %ebp
 3e9:	c3                   	ret    
 3ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3f0:	f3 0f 1e fb          	endbr32 
 3f4:	55                   	push   %ebp
 3f5:	89 e5                	mov    %esp,%ebp
 3f7:	57                   	push   %edi
 3f8:	8b 45 10             	mov    0x10(%ebp),%eax
 3fb:	8b 55 08             	mov    0x8(%ebp),%edx
 3fe:	56                   	push   %esi
 3ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 402:	85 c0                	test   %eax,%eax
 404:	7e 0f                	jle    415 <memmove+0x25>
 406:	01 d0                	add    %edx,%eax
  dst = vdst;
 408:	89 d7                	mov    %edx,%edi
 40a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 410:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 411:	39 f8                	cmp    %edi,%eax
 413:	75 fb                	jne    410 <memmove+0x20>
  return vdst;
}
 415:	5e                   	pop    %esi
 416:	89 d0                	mov    %edx,%eax
 418:	5f                   	pop    %edi
 419:	5d                   	pop    %ebp
 41a:	c3                   	ret    

0000041b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 41b:	b8 01 00 00 00       	mov    $0x1,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <exit>:
SYSCALL(exit)
 423:	b8 02 00 00 00       	mov    $0x2,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <wait>:
SYSCALL(wait)
 42b:	b8 03 00 00 00       	mov    $0x3,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <pipe>:
SYSCALL(pipe)
 433:	b8 04 00 00 00       	mov    $0x4,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <read>:
SYSCALL(read)
 43b:	b8 05 00 00 00       	mov    $0x5,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <write>:
SYSCALL(write)
 443:	b8 10 00 00 00       	mov    $0x10,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <close>:
SYSCALL(close)
 44b:	b8 15 00 00 00       	mov    $0x15,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <kill>:
SYSCALL(kill)
 453:	b8 06 00 00 00       	mov    $0x6,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <exec>:
SYSCALL(exec)
 45b:	b8 07 00 00 00       	mov    $0x7,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <open>:
SYSCALL(open)
 463:	b8 0f 00 00 00       	mov    $0xf,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <mknod>:
SYSCALL(mknod)
 46b:	b8 11 00 00 00       	mov    $0x11,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <unlink>:
SYSCALL(unlink)
 473:	b8 12 00 00 00       	mov    $0x12,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <fstat>:
SYSCALL(fstat)
 47b:	b8 08 00 00 00       	mov    $0x8,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <link>:
SYSCALL(link)
 483:	b8 13 00 00 00       	mov    $0x13,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <mkdir>:
SYSCALL(mkdir)
 48b:	b8 14 00 00 00       	mov    $0x14,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <chdir>:
SYSCALL(chdir)
 493:	b8 09 00 00 00       	mov    $0x9,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <dup>:
SYSCALL(dup)
 49b:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <getpid>:
SYSCALL(getpid)
 4a3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <sbrk>:
SYSCALL(sbrk)
 4ab:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <sleep>:
SYSCALL(sleep)
 4b3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <uptime>:
SYSCALL(uptime)
 4bb:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    
 4c3:	66 90                	xchg   %ax,%ax
 4c5:	66 90                	xchg   %ax,%ax
 4c7:	66 90                	xchg   %ax,%ax
 4c9:	66 90                	xchg   %ax,%ax
 4cb:	66 90                	xchg   %ax,%ax
 4cd:	66 90                	xchg   %ax,%ax
 4cf:	90                   	nop

000004d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	57                   	push   %edi
 4d4:	56                   	push   %esi
 4d5:	53                   	push   %ebx
 4d6:	83 ec 3c             	sub    $0x3c,%esp
 4d9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4dc:	89 d1                	mov    %edx,%ecx
{
 4de:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 4e1:	85 d2                	test   %edx,%edx
 4e3:	0f 89 7f 00 00 00    	jns    568 <printint+0x98>
 4e9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4ed:	74 79                	je     568 <printint+0x98>
    neg = 1;
 4ef:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 4f6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 4f8:	31 db                	xor    %ebx,%ebx
 4fa:	8d 75 d7             	lea    -0x29(%ebp),%esi
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 500:	89 c8                	mov    %ecx,%eax
 502:	31 d2                	xor    %edx,%edx
 504:	89 cf                	mov    %ecx,%edi
 506:	f7 75 c4             	divl   -0x3c(%ebp)
 509:	0f b6 92 0c 09 00 00 	movzbl 0x90c(%edx),%edx
 510:	89 45 c0             	mov    %eax,-0x40(%ebp)
 513:	89 d8                	mov    %ebx,%eax
 515:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 518:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 51b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 51e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 521:	76 dd                	jbe    500 <printint+0x30>
  if(neg)
 523:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 526:	85 c9                	test   %ecx,%ecx
 528:	74 0c                	je     536 <printint+0x66>
    buf[i++] = '-';
 52a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 52f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 531:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 536:	8b 7d b8             	mov    -0x48(%ebp),%edi
 539:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 53d:	eb 07                	jmp    546 <printint+0x76>
 53f:	90                   	nop
 540:	0f b6 13             	movzbl (%ebx),%edx
 543:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 546:	83 ec 04             	sub    $0x4,%esp
 549:	88 55 d7             	mov    %dl,-0x29(%ebp)
 54c:	6a 01                	push   $0x1
 54e:	56                   	push   %esi
 54f:	57                   	push   %edi
 550:	e8 ee fe ff ff       	call   443 <write>
  while(--i >= 0)
 555:	83 c4 10             	add    $0x10,%esp
 558:	39 de                	cmp    %ebx,%esi
 55a:	75 e4                	jne    540 <printint+0x70>
    putc(fd, buf[i]);
}
 55c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 55f:	5b                   	pop    %ebx
 560:	5e                   	pop    %esi
 561:	5f                   	pop    %edi
 562:	5d                   	pop    %ebp
 563:	c3                   	ret    
 564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 568:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 56f:	eb 87                	jmp    4f8 <printint+0x28>
 571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 578:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57f:	90                   	nop

00000580 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 580:	f3 0f 1e fb          	endbr32 
 584:	55                   	push   %ebp
 585:	89 e5                	mov    %esp,%ebp
 587:	57                   	push   %edi
 588:	56                   	push   %esi
 589:	53                   	push   %ebx
 58a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 58d:	8b 75 0c             	mov    0xc(%ebp),%esi
 590:	0f b6 1e             	movzbl (%esi),%ebx
 593:	84 db                	test   %bl,%bl
 595:	0f 84 b4 00 00 00    	je     64f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 59b:	8d 45 10             	lea    0x10(%ebp),%eax
 59e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 5a1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 5a4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 5a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5a9:	eb 33                	jmp    5de <printf+0x5e>
 5ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5af:	90                   	nop
 5b0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5b3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 5b8:	83 f8 25             	cmp    $0x25,%eax
 5bb:	74 17                	je     5d4 <printf+0x54>
  write(fd, &c, 1);
 5bd:	83 ec 04             	sub    $0x4,%esp
 5c0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5c3:	6a 01                	push   $0x1
 5c5:	57                   	push   %edi
 5c6:	ff 75 08             	pushl  0x8(%ebp)
 5c9:	e8 75 fe ff ff       	call   443 <write>
 5ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 5d1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5d4:	0f b6 1e             	movzbl (%esi),%ebx
 5d7:	83 c6 01             	add    $0x1,%esi
 5da:	84 db                	test   %bl,%bl
 5dc:	74 71                	je     64f <printf+0xcf>
    c = fmt[i] & 0xff;
 5de:	0f be cb             	movsbl %bl,%ecx
 5e1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5e4:	85 d2                	test   %edx,%edx
 5e6:	74 c8                	je     5b0 <printf+0x30>
      }
    } else if(state == '%'){
 5e8:	83 fa 25             	cmp    $0x25,%edx
 5eb:	75 e7                	jne    5d4 <printf+0x54>
      if(c == 'd'){
 5ed:	83 f8 64             	cmp    $0x64,%eax
 5f0:	0f 84 9a 00 00 00    	je     690 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5f6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 5fc:	83 f9 70             	cmp    $0x70,%ecx
 5ff:	74 5f                	je     660 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 601:	83 f8 73             	cmp    $0x73,%eax
 604:	0f 84 d6 00 00 00    	je     6e0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 60a:	83 f8 63             	cmp    $0x63,%eax
 60d:	0f 84 8d 00 00 00    	je     6a0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 613:	83 f8 25             	cmp    $0x25,%eax
 616:	0f 84 b4 00 00 00    	je     6d0 <printf+0x150>
  write(fd, &c, 1);
 61c:	83 ec 04             	sub    $0x4,%esp
 61f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 623:	6a 01                	push   $0x1
 625:	57                   	push   %edi
 626:	ff 75 08             	pushl  0x8(%ebp)
 629:	e8 15 fe ff ff       	call   443 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 62e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 631:	83 c4 0c             	add    $0xc,%esp
 634:	6a 01                	push   $0x1
 636:	83 c6 01             	add    $0x1,%esi
 639:	57                   	push   %edi
 63a:	ff 75 08             	pushl  0x8(%ebp)
 63d:	e8 01 fe ff ff       	call   443 <write>
  for(i = 0; fmt[i]; i++){
 642:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 646:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 649:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 64b:	84 db                	test   %bl,%bl
 64d:	75 8f                	jne    5de <printf+0x5e>
    }
  }
}
 64f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 652:	5b                   	pop    %ebx
 653:	5e                   	pop    %esi
 654:	5f                   	pop    %edi
 655:	5d                   	pop    %ebp
 656:	c3                   	ret    
 657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 65e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 660:	83 ec 0c             	sub    $0xc,%esp
 663:	b9 10 00 00 00       	mov    $0x10,%ecx
 668:	6a 00                	push   $0x0
 66a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 66d:	8b 45 08             	mov    0x8(%ebp),%eax
 670:	8b 13                	mov    (%ebx),%edx
 672:	e8 59 fe ff ff       	call   4d0 <printint>
        ap++;
 677:	89 d8                	mov    %ebx,%eax
 679:	83 c4 10             	add    $0x10,%esp
      state = 0;
 67c:	31 d2                	xor    %edx,%edx
        ap++;
 67e:	83 c0 04             	add    $0x4,%eax
 681:	89 45 d0             	mov    %eax,-0x30(%ebp)
 684:	e9 4b ff ff ff       	jmp    5d4 <printf+0x54>
 689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 690:	83 ec 0c             	sub    $0xc,%esp
 693:	b9 0a 00 00 00       	mov    $0xa,%ecx
 698:	6a 01                	push   $0x1
 69a:	eb ce                	jmp    66a <printf+0xea>
 69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 6a0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 6a3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6a6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 6a8:	6a 01                	push   $0x1
        ap++;
 6aa:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 6ad:	57                   	push   %edi
 6ae:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 6b1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6b4:	e8 8a fd ff ff       	call   443 <write>
        ap++;
 6b9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6bc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6bf:	31 d2                	xor    %edx,%edx
 6c1:	e9 0e ff ff ff       	jmp    5d4 <printf+0x54>
 6c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6cd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 6d0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6d3:	83 ec 04             	sub    $0x4,%esp
 6d6:	e9 59 ff ff ff       	jmp    634 <printf+0xb4>
 6db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6df:	90                   	nop
        s = (char*)*ap;
 6e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6e3:	8b 18                	mov    (%eax),%ebx
        ap++;
 6e5:	83 c0 04             	add    $0x4,%eax
 6e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 6eb:	85 db                	test   %ebx,%ebx
 6ed:	74 17                	je     706 <printf+0x186>
        while(*s != 0){
 6ef:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 6f2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 6f4:	84 c0                	test   %al,%al
 6f6:	0f 84 d8 fe ff ff    	je     5d4 <printf+0x54>
 6fc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6ff:	89 de                	mov    %ebx,%esi
 701:	8b 5d 08             	mov    0x8(%ebp),%ebx
 704:	eb 1a                	jmp    720 <printf+0x1a0>
          s = "(null)";
 706:	bb 04 09 00 00       	mov    $0x904,%ebx
        while(*s != 0){
 70b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 70e:	b8 28 00 00 00       	mov    $0x28,%eax
 713:	89 de                	mov    %ebx,%esi
 715:	8b 5d 08             	mov    0x8(%ebp),%ebx
 718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 71f:	90                   	nop
  write(fd, &c, 1);
 720:	83 ec 04             	sub    $0x4,%esp
          s++;
 723:	83 c6 01             	add    $0x1,%esi
 726:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 729:	6a 01                	push   $0x1
 72b:	57                   	push   %edi
 72c:	53                   	push   %ebx
 72d:	e8 11 fd ff ff       	call   443 <write>
        while(*s != 0){
 732:	0f b6 06             	movzbl (%esi),%eax
 735:	83 c4 10             	add    $0x10,%esp
 738:	84 c0                	test   %al,%al
 73a:	75 e4                	jne    720 <printf+0x1a0>
 73c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 73f:	31 d2                	xor    %edx,%edx
 741:	e9 8e fe ff ff       	jmp    5d4 <printf+0x54>
 746:	66 90                	xchg   %ax,%ax
 748:	66 90                	xchg   %ax,%ax
 74a:	66 90                	xchg   %ax,%ax
 74c:	66 90                	xchg   %ax,%ax
 74e:	66 90                	xchg   %ax,%ax

00000750 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 750:	f3 0f 1e fb          	endbr32 
 754:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 755:	a1 10 0c 00 00       	mov    0xc10,%eax
{
 75a:	89 e5                	mov    %esp,%ebp
 75c:	57                   	push   %edi
 75d:	56                   	push   %esi
 75e:	53                   	push   %ebx
 75f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 762:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 764:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 767:	39 c8                	cmp    %ecx,%eax
 769:	73 15                	jae    780 <free+0x30>
 76b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 76f:	90                   	nop
 770:	39 d1                	cmp    %edx,%ecx
 772:	72 14                	jb     788 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 774:	39 d0                	cmp    %edx,%eax
 776:	73 10                	jae    788 <free+0x38>
{
 778:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77a:	8b 10                	mov    (%eax),%edx
 77c:	39 c8                	cmp    %ecx,%eax
 77e:	72 f0                	jb     770 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 780:	39 d0                	cmp    %edx,%eax
 782:	72 f4                	jb     778 <free+0x28>
 784:	39 d1                	cmp    %edx,%ecx
 786:	73 f0                	jae    778 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 788:	8b 73 fc             	mov    -0x4(%ebx),%esi
 78b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 78e:	39 fa                	cmp    %edi,%edx
 790:	74 1e                	je     7b0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 792:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 795:	8b 50 04             	mov    0x4(%eax),%edx
 798:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 79b:	39 f1                	cmp    %esi,%ecx
 79d:	74 28                	je     7c7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 79f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 7a1:	5b                   	pop    %ebx
  freep = p;
 7a2:	a3 10 0c 00 00       	mov    %eax,0xc10
}
 7a7:	5e                   	pop    %esi
 7a8:	5f                   	pop    %edi
 7a9:	5d                   	pop    %ebp
 7aa:	c3                   	ret    
 7ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7af:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 7b0:	03 72 04             	add    0x4(%edx),%esi
 7b3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b6:	8b 10                	mov    (%eax),%edx
 7b8:	8b 12                	mov    (%edx),%edx
 7ba:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7bd:	8b 50 04             	mov    0x4(%eax),%edx
 7c0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7c3:	39 f1                	cmp    %esi,%ecx
 7c5:	75 d8                	jne    79f <free+0x4f>
    p->s.size += bp->s.size;
 7c7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 7ca:	a3 10 0c 00 00       	mov    %eax,0xc10
    p->s.size += bp->s.size;
 7cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7d5:	89 10                	mov    %edx,(%eax)
}
 7d7:	5b                   	pop    %ebx
 7d8:	5e                   	pop    %esi
 7d9:	5f                   	pop    %edi
 7da:	5d                   	pop    %ebp
 7db:	c3                   	ret    
 7dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e0:	f3 0f 1e fb          	endbr32 
 7e4:	55                   	push   %ebp
 7e5:	89 e5                	mov    %esp,%ebp
 7e7:	57                   	push   %edi
 7e8:	56                   	push   %esi
 7e9:	53                   	push   %ebx
 7ea:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ed:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7f0:	8b 3d 10 0c 00 00    	mov    0xc10,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f6:	8d 70 07             	lea    0x7(%eax),%esi
 7f9:	c1 ee 03             	shr    $0x3,%esi
 7fc:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 7ff:	85 ff                	test   %edi,%edi
 801:	0f 84 a9 00 00 00    	je     8b0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 807:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 809:	8b 48 04             	mov    0x4(%eax),%ecx
 80c:	39 f1                	cmp    %esi,%ecx
 80e:	73 6d                	jae    87d <malloc+0x9d>
 810:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 816:	bb 00 10 00 00       	mov    $0x1000,%ebx
 81b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 81e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 825:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 828:	eb 17                	jmp    841 <malloc+0x61>
 82a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 830:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 832:	8b 4a 04             	mov    0x4(%edx),%ecx
 835:	39 f1                	cmp    %esi,%ecx
 837:	73 4f                	jae    888 <malloc+0xa8>
 839:	8b 3d 10 0c 00 00    	mov    0xc10,%edi
 83f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 841:	39 c7                	cmp    %eax,%edi
 843:	75 eb                	jne    830 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 845:	83 ec 0c             	sub    $0xc,%esp
 848:	ff 75 e4             	pushl  -0x1c(%ebp)
 84b:	e8 5b fc ff ff       	call   4ab <sbrk>
  if(p == (char*)-1)
 850:	83 c4 10             	add    $0x10,%esp
 853:	83 f8 ff             	cmp    $0xffffffff,%eax
 856:	74 1b                	je     873 <malloc+0x93>
  hp->s.size = nu;
 858:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 85b:	83 ec 0c             	sub    $0xc,%esp
 85e:	83 c0 08             	add    $0x8,%eax
 861:	50                   	push   %eax
 862:	e8 e9 fe ff ff       	call   750 <free>
  return freep;
 867:	a1 10 0c 00 00       	mov    0xc10,%eax
      if((p = morecore(nunits)) == 0)
 86c:	83 c4 10             	add    $0x10,%esp
 86f:	85 c0                	test   %eax,%eax
 871:	75 bd                	jne    830 <malloc+0x50>
        return 0;
  }
}
 873:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 876:	31 c0                	xor    %eax,%eax
}
 878:	5b                   	pop    %ebx
 879:	5e                   	pop    %esi
 87a:	5f                   	pop    %edi
 87b:	5d                   	pop    %ebp
 87c:	c3                   	ret    
    if(p->s.size >= nunits){
 87d:	89 c2                	mov    %eax,%edx
 87f:	89 f8                	mov    %edi,%eax
 881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 888:	39 ce                	cmp    %ecx,%esi
 88a:	74 54                	je     8e0 <malloc+0x100>
        p->s.size -= nunits;
 88c:	29 f1                	sub    %esi,%ecx
 88e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 891:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 894:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 897:	a3 10 0c 00 00       	mov    %eax,0xc10
}
 89c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 89f:	8d 42 08             	lea    0x8(%edx),%eax
}
 8a2:	5b                   	pop    %ebx
 8a3:	5e                   	pop    %esi
 8a4:	5f                   	pop    %edi
 8a5:	5d                   	pop    %ebp
 8a6:	c3                   	ret    
 8a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ae:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 8b0:	c7 05 10 0c 00 00 14 	movl   $0xc14,0xc10
 8b7:	0c 00 00 
    base.s.size = 0;
 8ba:	bf 14 0c 00 00       	mov    $0xc14,%edi
    base.s.ptr = freep = prevp = &base;
 8bf:	c7 05 14 0c 00 00 14 	movl   $0xc14,0xc14
 8c6:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c9:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 8cb:	c7 05 18 0c 00 00 00 	movl   $0x0,0xc18
 8d2:	00 00 00 
    if(p->s.size >= nunits){
 8d5:	e9 36 ff ff ff       	jmp    810 <malloc+0x30>
 8da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 8e0:	8b 0a                	mov    (%edx),%ecx
 8e2:	89 08                	mov    %ecx,(%eax)
 8e4:	eb b1                	jmp    897 <malloc+0xb7>
