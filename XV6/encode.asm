
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
    encrypt(input, output);
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
  b1:	53                   	push   %ebx
  b2:	56                   	push   %esi
  b3:	e8 78 00 00 00       	call   130 <encrypt>
    printf(1, "%s\n", output); // Print the encrypted output
  b8:	83 c4 0c             	add    $0xc,%esp
  bb:	53                   	push   %ebx
  bc:	68 90 09 00 00       	push   $0x990
  c1:	6a 01                	push   $0x1
  c3:	e8 48 05 00 00       	call   610 <printf>

    exit();
  c8:	e8 e6 03 00 00       	call   4b3 <exit>
        printf(2, "Usage: encode <string>\n");
  cd:	51                   	push   %ecx
  ce:	51                   	push   %ecx
  cf:	68 78 09 00 00       	push   $0x978
  d4:	6a 02                	push   $0x2
  d6:	e8 35 05 00 00       	call   610 <printf>
        exit();
  db:	e8 d3 03 00 00       	call   4b3 <exit>

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

00000130 <encrypt>:
void encrypt(char *input, char *output) {
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
 145:	74 5f                	je     1a6 <encrypt+0x76>
 147:	31 db                	xor    %ebx,%ebx
 149:	eb 28                	jmp    173 <encrypt+0x43>
 14b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 14f:	90                   	nop
            output[i] = (input[i] - 'a' + KEY) % 26 + 'a';
 150:	83 e9 4d             	sub    $0x4d,%ecx
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
 171:	74 31                	je     1a4 <encrypt+0x74>
        if (input[i] >= 'a' && input[i] <= 'z') {
 173:	8d 41 9f             	lea    -0x61(%ecx),%eax
 176:	3c 19                	cmp    $0x19,%al
 178:	76 d6                	jbe    150 <encrypt+0x20>
        } else if (input[i] >= 'A' && input[i] <= 'Z') {
 17a:	8d 41 bf             	lea    -0x41(%ecx),%eax
 17d:	3c 19                	cmp    $0x19,%al
 17f:	77 2f                	ja     1b0 <encrypt+0x80>
            output[i] = (input[i] - 'A' + KEY) % 26 + 'A';
 181:	83 e9 2d             	sub    $0x2d,%ecx
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
 1a2:	75 cf                	jne    173 <encrypt+0x43>
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
 1b3:	eb b3                	jmp    168 <encrypt+0x38>
 1b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001c0 <decrypt>:
void decrypt(char *input, char *output) {
 1c0:	f3 0f 1e fb          	endbr32 
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	57                   	push   %edi
 1c8:	8b 7d 08             	mov    0x8(%ebp),%edi
 1cb:	56                   	push   %esi
 1cc:	53                   	push   %ebx
 1cd:	8b 75 0c             	mov    0xc(%ebp),%esi
    for (i = 0; input[i] != '\0'; i++) {
 1d0:	0f be 0f             	movsbl (%edi),%ecx
 1d3:	84 c9                	test   %cl,%cl
 1d5:	74 5f                	je     236 <decrypt+0x76>
 1d7:	31 db                	xor    %ebx,%ebx
 1d9:	eb 28                	jmp    203 <decrypt+0x43>
 1db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1df:	90                   	nop
            output[i] = (input[i] - 'a' - KEY + 26) % 26 + 'a'; // Add 26 to handle negative results
 1e0:	83 e9 5b             	sub    $0x5b,%ecx
 1e3:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
 1e8:	f7 e1                	mul    %ecx
 1ea:	c1 ea 03             	shr    $0x3,%edx
 1ed:	6b d2 1a             	imul   $0x1a,%edx,%edx
 1f0:	29 d1                	sub    %edx,%ecx
 1f2:	83 c1 61             	add    $0x61,%ecx
 1f5:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
    for (i = 0; input[i] != '\0'; i++) {
 1f8:	83 c3 01             	add    $0x1,%ebx
 1fb:	0f be 0c 1f          	movsbl (%edi,%ebx,1),%ecx
 1ff:	84 c9                	test   %cl,%cl
 201:	74 31                	je     234 <decrypt+0x74>
        if (input[i] >= 'a' && input[i] <= 'z') {
 203:	8d 41 9f             	lea    -0x61(%ecx),%eax
 206:	3c 19                	cmp    $0x19,%al
 208:	76 d6                	jbe    1e0 <decrypt+0x20>
        } else if (input[i] >= 'A' && input[i] <= 'Z') {
 20a:	8d 41 bf             	lea    -0x41(%ecx),%eax
 20d:	3c 19                	cmp    $0x19,%al
 20f:	77 2f                	ja     240 <decrypt+0x80>
            output[i] = (input[i] - 'A' - KEY + 26) % 26 + 'A'; // Add 26 to handle negative results
 211:	83 e9 3b             	sub    $0x3b,%ecx
 214:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
 219:	f7 e1                	mul    %ecx
 21b:	c1 ea 03             	shr    $0x3,%edx
 21e:	6b d2 1a             	imul   $0x1a,%edx,%edx
 221:	29 d1                	sub    %edx,%ecx
 223:	83 c1 41             	add    $0x41,%ecx
 226:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
    for (i = 0; input[i] != '\0'; i++) {
 229:	83 c3 01             	add    $0x1,%ebx
 22c:	0f be 0c 1f          	movsbl (%edi,%ebx,1),%ecx
 230:	84 c9                	test   %cl,%cl
 232:	75 cf                	jne    203 <decrypt+0x43>
 234:	01 de                	add    %ebx,%esi
    output[i] = '\0'; // Null-terminate the output string
 236:	c6 06 00             	movb   $0x0,(%esi)
}
 239:	5b                   	pop    %ebx
 23a:	5e                   	pop    %esi
 23b:	5f                   	pop    %edi
 23c:	5d                   	pop    %ebp
 23d:	c3                   	ret    
 23e:	66 90                	xchg   %ax,%ax
            output[i] = input[i]; // Non-alphabetic characters remain unchanged
 240:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
 243:	eb b3                	jmp    1f8 <decrypt+0x38>
 245:	66 90                	xchg   %ax,%ax
 247:	66 90                	xchg   %ax,%ax
 249:	66 90                	xchg   %ax,%ax
 24b:	66 90                	xchg   %ax,%ax
 24d:	66 90                	xchg   %ax,%ax
 24f:	90                   	nop

00000250 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 250:	f3 0f 1e fb          	endbr32 
 254:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 255:	31 c0                	xor    %eax,%eax
{
 257:	89 e5                	mov    %esp,%ebp
 259:	53                   	push   %ebx
 25a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 25d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 260:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 264:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 267:	83 c0 01             	add    $0x1,%eax
 26a:	84 d2                	test   %dl,%dl
 26c:	75 f2                	jne    260 <strcpy+0x10>
    ;
  return os;
}
 26e:	89 c8                	mov    %ecx,%eax
 270:	5b                   	pop    %ebx
 271:	5d                   	pop    %ebp
 272:	c3                   	ret    
 273:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000280 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 280:	f3 0f 1e fb          	endbr32 
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	53                   	push   %ebx
 288:	8b 4d 08             	mov    0x8(%ebp),%ecx
 28b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 28e:	0f b6 01             	movzbl (%ecx),%eax
 291:	0f b6 1a             	movzbl (%edx),%ebx
 294:	84 c0                	test   %al,%al
 296:	75 19                	jne    2b1 <strcmp+0x31>
 298:	eb 26                	jmp    2c0 <strcmp+0x40>
 29a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2a0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 2a4:	83 c1 01             	add    $0x1,%ecx
 2a7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2aa:	0f b6 1a             	movzbl (%edx),%ebx
 2ad:	84 c0                	test   %al,%al
 2af:	74 0f                	je     2c0 <strcmp+0x40>
 2b1:	38 d8                	cmp    %bl,%al
 2b3:	74 eb                	je     2a0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 2b5:	29 d8                	sub    %ebx,%eax
}
 2b7:	5b                   	pop    %ebx
 2b8:	5d                   	pop    %ebp
 2b9:	c3                   	ret    
 2ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2c0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 2c2:	29 d8                	sub    %ebx,%eax
}
 2c4:	5b                   	pop    %ebx
 2c5:	5d                   	pop    %ebp
 2c6:	c3                   	ret    
 2c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ce:	66 90                	xchg   %ax,%ax

000002d0 <strlen>:

uint
strlen(const char *s)
{
 2d0:	f3 0f 1e fb          	endbr32 
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 2da:	80 3a 00             	cmpb   $0x0,(%edx)
 2dd:	74 21                	je     300 <strlen+0x30>
 2df:	31 c0                	xor    %eax,%eax
 2e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2e8:	83 c0 01             	add    $0x1,%eax
 2eb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 2ef:	89 c1                	mov    %eax,%ecx
 2f1:	75 f5                	jne    2e8 <strlen+0x18>
    ;
  return n;
}
 2f3:	89 c8                	mov    %ecx,%eax
 2f5:	5d                   	pop    %ebp
 2f6:	c3                   	ret    
 2f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fe:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 300:	31 c9                	xor    %ecx,%ecx
}
 302:	5d                   	pop    %ebp
 303:	89 c8                	mov    %ecx,%eax
 305:	c3                   	ret    
 306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30d:	8d 76 00             	lea    0x0(%esi),%esi

00000310 <memset>:

void*
memset(void *dst, int c, uint n)
{
 310:	f3 0f 1e fb          	endbr32 
 314:	55                   	push   %ebp
 315:	89 e5                	mov    %esp,%ebp
 317:	57                   	push   %edi
 318:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 31b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 31e:	8b 45 0c             	mov    0xc(%ebp),%eax
 321:	89 d7                	mov    %edx,%edi
 323:	fc                   	cld    
 324:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 326:	89 d0                	mov    %edx,%eax
 328:	5f                   	pop    %edi
 329:	5d                   	pop    %ebp
 32a:	c3                   	ret    
 32b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 32f:	90                   	nop

00000330 <strchr>:

char*
strchr(const char *s, char c)
{
 330:	f3 0f 1e fb          	endbr32 
 334:	55                   	push   %ebp
 335:	89 e5                	mov    %esp,%ebp
 337:	8b 45 08             	mov    0x8(%ebp),%eax
 33a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 33e:	0f b6 10             	movzbl (%eax),%edx
 341:	84 d2                	test   %dl,%dl
 343:	75 16                	jne    35b <strchr+0x2b>
 345:	eb 21                	jmp    368 <strchr+0x38>
 347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 34e:	66 90                	xchg   %ax,%ax
 350:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 354:	83 c0 01             	add    $0x1,%eax
 357:	84 d2                	test   %dl,%dl
 359:	74 0d                	je     368 <strchr+0x38>
    if(*s == c)
 35b:	38 d1                	cmp    %dl,%cl
 35d:	75 f1                	jne    350 <strchr+0x20>
      return (char*)s;
  return 0;
}
 35f:	5d                   	pop    %ebp
 360:	c3                   	ret    
 361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 368:	31 c0                	xor    %eax,%eax
}
 36a:	5d                   	pop    %ebp
 36b:	c3                   	ret    
 36c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000370 <gets>:

char*
gets(char *buf, int max)
{
 370:	f3 0f 1e fb          	endbr32 
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	57                   	push   %edi
 378:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 379:	31 f6                	xor    %esi,%esi
{
 37b:	53                   	push   %ebx
 37c:	89 f3                	mov    %esi,%ebx
 37e:	83 ec 1c             	sub    $0x1c,%esp
 381:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 384:	eb 33                	jmp    3b9 <gets+0x49>
 386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 38d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 390:	83 ec 04             	sub    $0x4,%esp
 393:	8d 45 e7             	lea    -0x19(%ebp),%eax
 396:	6a 01                	push   $0x1
 398:	50                   	push   %eax
 399:	6a 00                	push   $0x0
 39b:	e8 2b 01 00 00       	call   4cb <read>
    if(cc < 1)
 3a0:	83 c4 10             	add    $0x10,%esp
 3a3:	85 c0                	test   %eax,%eax
 3a5:	7e 1c                	jle    3c3 <gets+0x53>
      break;
    buf[i++] = c;
 3a7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3ab:	83 c7 01             	add    $0x1,%edi
 3ae:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 3b1:	3c 0a                	cmp    $0xa,%al
 3b3:	74 23                	je     3d8 <gets+0x68>
 3b5:	3c 0d                	cmp    $0xd,%al
 3b7:	74 1f                	je     3d8 <gets+0x68>
  for(i=0; i+1 < max; ){
 3b9:	83 c3 01             	add    $0x1,%ebx
 3bc:	89 fe                	mov    %edi,%esi
 3be:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3c1:	7c cd                	jl     390 <gets+0x20>
 3c3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 3c5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 3c8:	c6 03 00             	movb   $0x0,(%ebx)
}
 3cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ce:	5b                   	pop    %ebx
 3cf:	5e                   	pop    %esi
 3d0:	5f                   	pop    %edi
 3d1:	5d                   	pop    %ebp
 3d2:	c3                   	ret    
 3d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3d7:	90                   	nop
 3d8:	8b 75 08             	mov    0x8(%ebp),%esi
 3db:	8b 45 08             	mov    0x8(%ebp),%eax
 3de:	01 de                	add    %ebx,%esi
 3e0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 3e2:	c6 03 00             	movb   $0x0,(%ebx)
}
 3e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3e8:	5b                   	pop    %ebx
 3e9:	5e                   	pop    %esi
 3ea:	5f                   	pop    %edi
 3eb:	5d                   	pop    %ebp
 3ec:	c3                   	ret    
 3ed:	8d 76 00             	lea    0x0(%esi),%esi

000003f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f0:	f3 0f 1e fb          	endbr32 
 3f4:	55                   	push   %ebp
 3f5:	89 e5                	mov    %esp,%ebp
 3f7:	56                   	push   %esi
 3f8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f9:	83 ec 08             	sub    $0x8,%esp
 3fc:	6a 00                	push   $0x0
 3fe:	ff 75 08             	pushl  0x8(%ebp)
 401:	e8 ed 00 00 00       	call   4f3 <open>
  if(fd < 0)
 406:	83 c4 10             	add    $0x10,%esp
 409:	85 c0                	test   %eax,%eax
 40b:	78 2b                	js     438 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 40d:	83 ec 08             	sub    $0x8,%esp
 410:	ff 75 0c             	pushl  0xc(%ebp)
 413:	89 c3                	mov    %eax,%ebx
 415:	50                   	push   %eax
 416:	e8 f0 00 00 00       	call   50b <fstat>
  close(fd);
 41b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 41e:	89 c6                	mov    %eax,%esi
  close(fd);
 420:	e8 b6 00 00 00       	call   4db <close>
  return r;
 425:	83 c4 10             	add    $0x10,%esp
}
 428:	8d 65 f8             	lea    -0x8(%ebp),%esp
 42b:	89 f0                	mov    %esi,%eax
 42d:	5b                   	pop    %ebx
 42e:	5e                   	pop    %esi
 42f:	5d                   	pop    %ebp
 430:	c3                   	ret    
 431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 438:	be ff ff ff ff       	mov    $0xffffffff,%esi
 43d:	eb e9                	jmp    428 <stat+0x38>
 43f:	90                   	nop

00000440 <atoi>:

int
atoi(const char *s)
{
 440:	f3 0f 1e fb          	endbr32 
 444:	55                   	push   %ebp
 445:	89 e5                	mov    %esp,%ebp
 447:	53                   	push   %ebx
 448:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 44b:	0f be 02             	movsbl (%edx),%eax
 44e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 451:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 454:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 459:	77 1a                	ja     475 <atoi+0x35>
 45b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 45f:	90                   	nop
    n = n*10 + *s++ - '0';
 460:	83 c2 01             	add    $0x1,%edx
 463:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 466:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 46a:	0f be 02             	movsbl (%edx),%eax
 46d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 470:	80 fb 09             	cmp    $0x9,%bl
 473:	76 eb                	jbe    460 <atoi+0x20>
  return n;
}
 475:	89 c8                	mov    %ecx,%eax
 477:	5b                   	pop    %ebx
 478:	5d                   	pop    %ebp
 479:	c3                   	ret    
 47a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000480 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 480:	f3 0f 1e fb          	endbr32 
 484:	55                   	push   %ebp
 485:	89 e5                	mov    %esp,%ebp
 487:	57                   	push   %edi
 488:	8b 45 10             	mov    0x10(%ebp),%eax
 48b:	8b 55 08             	mov    0x8(%ebp),%edx
 48e:	56                   	push   %esi
 48f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 492:	85 c0                	test   %eax,%eax
 494:	7e 0f                	jle    4a5 <memmove+0x25>
 496:	01 d0                	add    %edx,%eax
  dst = vdst;
 498:	89 d7                	mov    %edx,%edi
 49a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 4a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4a1:	39 f8                	cmp    %edi,%eax
 4a3:	75 fb                	jne    4a0 <memmove+0x20>
  return vdst;
}
 4a5:	5e                   	pop    %esi
 4a6:	89 d0                	mov    %edx,%eax
 4a8:	5f                   	pop    %edi
 4a9:	5d                   	pop    %ebp
 4aa:	c3                   	ret    

000004ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ab:	b8 01 00 00 00       	mov    $0x1,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <exit>:
SYSCALL(exit)
 4b3:	b8 02 00 00 00       	mov    $0x2,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <wait>:
SYSCALL(wait)
 4bb:	b8 03 00 00 00       	mov    $0x3,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <pipe>:
SYSCALL(pipe)
 4c3:	b8 04 00 00 00       	mov    $0x4,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <read>:
SYSCALL(read)
 4cb:	b8 05 00 00 00       	mov    $0x5,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <write>:
SYSCALL(write)
 4d3:	b8 10 00 00 00       	mov    $0x10,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <close>:
SYSCALL(close)
 4db:	b8 15 00 00 00       	mov    $0x15,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <kill>:
SYSCALL(kill)
 4e3:	b8 06 00 00 00       	mov    $0x6,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <exec>:
SYSCALL(exec)
 4eb:	b8 07 00 00 00       	mov    $0x7,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <open>:
SYSCALL(open)
 4f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <mknod>:
SYSCALL(mknod)
 4fb:	b8 11 00 00 00       	mov    $0x11,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <unlink>:
SYSCALL(unlink)
 503:	b8 12 00 00 00       	mov    $0x12,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <fstat>:
SYSCALL(fstat)
 50b:	b8 08 00 00 00       	mov    $0x8,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <link>:
SYSCALL(link)
 513:	b8 13 00 00 00       	mov    $0x13,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <mkdir>:
SYSCALL(mkdir)
 51b:	b8 14 00 00 00       	mov    $0x14,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <chdir>:
SYSCALL(chdir)
 523:	b8 09 00 00 00       	mov    $0x9,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <dup>:
SYSCALL(dup)
 52b:	b8 0a 00 00 00       	mov    $0xa,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <getpid>:
SYSCALL(getpid)
 533:	b8 0b 00 00 00       	mov    $0xb,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <sbrk>:
SYSCALL(sbrk)
 53b:	b8 0c 00 00 00       	mov    $0xc,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <sleep>:
SYSCALL(sleep)
 543:	b8 0d 00 00 00       	mov    $0xd,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <uptime>:
SYSCALL(uptime)
 54b:	b8 0e 00 00 00       	mov    $0xe,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    
 553:	66 90                	xchg   %ax,%ax
 555:	66 90                	xchg   %ax,%ax
 557:	66 90                	xchg   %ax,%ax
 559:	66 90                	xchg   %ax,%ax
 55b:	66 90                	xchg   %ax,%ax
 55d:	66 90                	xchg   %ax,%ax
 55f:	90                   	nop

00000560 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	57                   	push   %edi
 564:	56                   	push   %esi
 565:	53                   	push   %ebx
 566:	83 ec 3c             	sub    $0x3c,%esp
 569:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 56c:	89 d1                	mov    %edx,%ecx
{
 56e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 571:	85 d2                	test   %edx,%edx
 573:	0f 89 7f 00 00 00    	jns    5f8 <printint+0x98>
 579:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 57d:	74 79                	je     5f8 <printint+0x98>
    neg = 1;
 57f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 586:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 588:	31 db                	xor    %ebx,%ebx
 58a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 58d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 590:	89 c8                	mov    %ecx,%eax
 592:	31 d2                	xor    %edx,%edx
 594:	89 cf                	mov    %ecx,%edi
 596:	f7 75 c4             	divl   -0x3c(%ebp)
 599:	0f b6 92 9c 09 00 00 	movzbl 0x99c(%edx),%edx
 5a0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 5a3:	89 d8                	mov    %ebx,%eax
 5a5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 5a8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 5ab:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 5ae:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 5b1:	76 dd                	jbe    590 <printint+0x30>
  if(neg)
 5b3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 5b6:	85 c9                	test   %ecx,%ecx
 5b8:	74 0c                	je     5c6 <printint+0x66>
    buf[i++] = '-';
 5ba:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 5bf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 5c1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 5c6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 5c9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 5cd:	eb 07                	jmp    5d6 <printint+0x76>
 5cf:	90                   	nop
 5d0:	0f b6 13             	movzbl (%ebx),%edx
 5d3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 5d6:	83 ec 04             	sub    $0x4,%esp
 5d9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 5dc:	6a 01                	push   $0x1
 5de:	56                   	push   %esi
 5df:	57                   	push   %edi
 5e0:	e8 ee fe ff ff       	call   4d3 <write>
  while(--i >= 0)
 5e5:	83 c4 10             	add    $0x10,%esp
 5e8:	39 de                	cmp    %ebx,%esi
 5ea:	75 e4                	jne    5d0 <printint+0x70>
    putc(fd, buf[i]);
}
 5ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ef:	5b                   	pop    %ebx
 5f0:	5e                   	pop    %esi
 5f1:	5f                   	pop    %edi
 5f2:	5d                   	pop    %ebp
 5f3:	c3                   	ret    
 5f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5f8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 5ff:	eb 87                	jmp    588 <printint+0x28>
 601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60f:	90                   	nop

00000610 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 610:	f3 0f 1e fb          	endbr32 
 614:	55                   	push   %ebp
 615:	89 e5                	mov    %esp,%ebp
 617:	57                   	push   %edi
 618:	56                   	push   %esi
 619:	53                   	push   %ebx
 61a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 61d:	8b 75 0c             	mov    0xc(%ebp),%esi
 620:	0f b6 1e             	movzbl (%esi),%ebx
 623:	84 db                	test   %bl,%bl
 625:	0f 84 b4 00 00 00    	je     6df <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 62b:	8d 45 10             	lea    0x10(%ebp),%eax
 62e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 631:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 634:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 636:	89 45 d0             	mov    %eax,-0x30(%ebp)
 639:	eb 33                	jmp    66e <printf+0x5e>
 63b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 63f:	90                   	nop
 640:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 643:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 648:	83 f8 25             	cmp    $0x25,%eax
 64b:	74 17                	je     664 <printf+0x54>
  write(fd, &c, 1);
 64d:	83 ec 04             	sub    $0x4,%esp
 650:	88 5d e7             	mov    %bl,-0x19(%ebp)
 653:	6a 01                	push   $0x1
 655:	57                   	push   %edi
 656:	ff 75 08             	pushl  0x8(%ebp)
 659:	e8 75 fe ff ff       	call   4d3 <write>
 65e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 661:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 664:	0f b6 1e             	movzbl (%esi),%ebx
 667:	83 c6 01             	add    $0x1,%esi
 66a:	84 db                	test   %bl,%bl
 66c:	74 71                	je     6df <printf+0xcf>
    c = fmt[i] & 0xff;
 66e:	0f be cb             	movsbl %bl,%ecx
 671:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 674:	85 d2                	test   %edx,%edx
 676:	74 c8                	je     640 <printf+0x30>
      }
    } else if(state == '%'){
 678:	83 fa 25             	cmp    $0x25,%edx
 67b:	75 e7                	jne    664 <printf+0x54>
      if(c == 'd'){
 67d:	83 f8 64             	cmp    $0x64,%eax
 680:	0f 84 9a 00 00 00    	je     720 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 686:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 68c:	83 f9 70             	cmp    $0x70,%ecx
 68f:	74 5f                	je     6f0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 691:	83 f8 73             	cmp    $0x73,%eax
 694:	0f 84 d6 00 00 00    	je     770 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 69a:	83 f8 63             	cmp    $0x63,%eax
 69d:	0f 84 8d 00 00 00    	je     730 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6a3:	83 f8 25             	cmp    $0x25,%eax
 6a6:	0f 84 b4 00 00 00    	je     760 <printf+0x150>
  write(fd, &c, 1);
 6ac:	83 ec 04             	sub    $0x4,%esp
 6af:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6b3:	6a 01                	push   $0x1
 6b5:	57                   	push   %edi
 6b6:	ff 75 08             	pushl  0x8(%ebp)
 6b9:	e8 15 fe ff ff       	call   4d3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 6be:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6c1:	83 c4 0c             	add    $0xc,%esp
 6c4:	6a 01                	push   $0x1
 6c6:	83 c6 01             	add    $0x1,%esi
 6c9:	57                   	push   %edi
 6ca:	ff 75 08             	pushl  0x8(%ebp)
 6cd:	e8 01 fe ff ff       	call   4d3 <write>
  for(i = 0; fmt[i]; i++){
 6d2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 6d6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6d9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 6db:	84 db                	test   %bl,%bl
 6dd:	75 8f                	jne    66e <printf+0x5e>
    }
  }
}
 6df:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6e2:	5b                   	pop    %ebx
 6e3:	5e                   	pop    %esi
 6e4:	5f                   	pop    %edi
 6e5:	5d                   	pop    %ebp
 6e6:	c3                   	ret    
 6e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ee:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 6f0:	83 ec 0c             	sub    $0xc,%esp
 6f3:	b9 10 00 00 00       	mov    $0x10,%ecx
 6f8:	6a 00                	push   $0x0
 6fa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6fd:	8b 45 08             	mov    0x8(%ebp),%eax
 700:	8b 13                	mov    (%ebx),%edx
 702:	e8 59 fe ff ff       	call   560 <printint>
        ap++;
 707:	89 d8                	mov    %ebx,%eax
 709:	83 c4 10             	add    $0x10,%esp
      state = 0;
 70c:	31 d2                	xor    %edx,%edx
        ap++;
 70e:	83 c0 04             	add    $0x4,%eax
 711:	89 45 d0             	mov    %eax,-0x30(%ebp)
 714:	e9 4b ff ff ff       	jmp    664 <printf+0x54>
 719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 720:	83 ec 0c             	sub    $0xc,%esp
 723:	b9 0a 00 00 00       	mov    $0xa,%ecx
 728:	6a 01                	push   $0x1
 72a:	eb ce                	jmp    6fa <printf+0xea>
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 730:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 733:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 736:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 738:	6a 01                	push   $0x1
        ap++;
 73a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 73d:	57                   	push   %edi
 73e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 741:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 744:	e8 8a fd ff ff       	call   4d3 <write>
        ap++;
 749:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 74c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 74f:	31 d2                	xor    %edx,%edx
 751:	e9 0e ff ff ff       	jmp    664 <printf+0x54>
 756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 760:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 763:	83 ec 04             	sub    $0x4,%esp
 766:	e9 59 ff ff ff       	jmp    6c4 <printf+0xb4>
 76b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 76f:	90                   	nop
        s = (char*)*ap;
 770:	8b 45 d0             	mov    -0x30(%ebp),%eax
 773:	8b 18                	mov    (%eax),%ebx
        ap++;
 775:	83 c0 04             	add    $0x4,%eax
 778:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 77b:	85 db                	test   %ebx,%ebx
 77d:	74 17                	je     796 <printf+0x186>
        while(*s != 0){
 77f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 782:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 784:	84 c0                	test   %al,%al
 786:	0f 84 d8 fe ff ff    	je     664 <printf+0x54>
 78c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 78f:	89 de                	mov    %ebx,%esi
 791:	8b 5d 08             	mov    0x8(%ebp),%ebx
 794:	eb 1a                	jmp    7b0 <printf+0x1a0>
          s = "(null)";
 796:	bb 94 09 00 00       	mov    $0x994,%ebx
        while(*s != 0){
 79b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 79e:	b8 28 00 00 00       	mov    $0x28,%eax
 7a3:	89 de                	mov    %ebx,%esi
 7a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7af:	90                   	nop
  write(fd, &c, 1);
 7b0:	83 ec 04             	sub    $0x4,%esp
          s++;
 7b3:	83 c6 01             	add    $0x1,%esi
 7b6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7b9:	6a 01                	push   $0x1
 7bb:	57                   	push   %edi
 7bc:	53                   	push   %ebx
 7bd:	e8 11 fd ff ff       	call   4d3 <write>
        while(*s != 0){
 7c2:	0f b6 06             	movzbl (%esi),%eax
 7c5:	83 c4 10             	add    $0x10,%esp
 7c8:	84 c0                	test   %al,%al
 7ca:	75 e4                	jne    7b0 <printf+0x1a0>
 7cc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 7cf:	31 d2                	xor    %edx,%edx
 7d1:	e9 8e fe ff ff       	jmp    664 <printf+0x54>
 7d6:	66 90                	xchg   %ax,%ax
 7d8:	66 90                	xchg   %ax,%ax
 7da:	66 90                	xchg   %ax,%ax
 7dc:	66 90                	xchg   %ax,%ax
 7de:	66 90                	xchg   %ax,%ax

000007e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e0:	f3 0f 1e fb          	endbr32 
 7e4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e5:	a1 d0 0c 00 00       	mov    0xcd0,%eax
{
 7ea:	89 e5                	mov    %esp,%ebp
 7ec:	57                   	push   %edi
 7ed:	56                   	push   %esi
 7ee:	53                   	push   %ebx
 7ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7f2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 7f4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f7:	39 c8                	cmp    %ecx,%eax
 7f9:	73 15                	jae    810 <free+0x30>
 7fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7ff:	90                   	nop
 800:	39 d1                	cmp    %edx,%ecx
 802:	72 14                	jb     818 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 804:	39 d0                	cmp    %edx,%eax
 806:	73 10                	jae    818 <free+0x38>
{
 808:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80a:	8b 10                	mov    (%eax),%edx
 80c:	39 c8                	cmp    %ecx,%eax
 80e:	72 f0                	jb     800 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 810:	39 d0                	cmp    %edx,%eax
 812:	72 f4                	jb     808 <free+0x28>
 814:	39 d1                	cmp    %edx,%ecx
 816:	73 f0                	jae    808 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 818:	8b 73 fc             	mov    -0x4(%ebx),%esi
 81b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 81e:	39 fa                	cmp    %edi,%edx
 820:	74 1e                	je     840 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 822:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 825:	8b 50 04             	mov    0x4(%eax),%edx
 828:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 82b:	39 f1                	cmp    %esi,%ecx
 82d:	74 28                	je     857 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 82f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 831:	5b                   	pop    %ebx
  freep = p;
 832:	a3 d0 0c 00 00       	mov    %eax,0xcd0
}
 837:	5e                   	pop    %esi
 838:	5f                   	pop    %edi
 839:	5d                   	pop    %ebp
 83a:	c3                   	ret    
 83b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 83f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 840:	03 72 04             	add    0x4(%edx),%esi
 843:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 846:	8b 10                	mov    (%eax),%edx
 848:	8b 12                	mov    (%edx),%edx
 84a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 84d:	8b 50 04             	mov    0x4(%eax),%edx
 850:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 853:	39 f1                	cmp    %esi,%ecx
 855:	75 d8                	jne    82f <free+0x4f>
    p->s.size += bp->s.size;
 857:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 85a:	a3 d0 0c 00 00       	mov    %eax,0xcd0
    p->s.size += bp->s.size;
 85f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 862:	8b 53 f8             	mov    -0x8(%ebx),%edx
 865:	89 10                	mov    %edx,(%eax)
}
 867:	5b                   	pop    %ebx
 868:	5e                   	pop    %esi
 869:	5f                   	pop    %edi
 86a:	5d                   	pop    %ebp
 86b:	c3                   	ret    
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000870 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 870:	f3 0f 1e fb          	endbr32 
 874:	55                   	push   %ebp
 875:	89 e5                	mov    %esp,%ebp
 877:	57                   	push   %edi
 878:	56                   	push   %esi
 879:	53                   	push   %ebx
 87a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 880:	8b 3d d0 0c 00 00    	mov    0xcd0,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 886:	8d 70 07             	lea    0x7(%eax),%esi
 889:	c1 ee 03             	shr    $0x3,%esi
 88c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 88f:	85 ff                	test   %edi,%edi
 891:	0f 84 a9 00 00 00    	je     940 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 897:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 899:	8b 48 04             	mov    0x4(%eax),%ecx
 89c:	39 f1                	cmp    %esi,%ecx
 89e:	73 6d                	jae    90d <malloc+0x9d>
 8a0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 8a6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8ab:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 8ae:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 8b5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 8b8:	eb 17                	jmp    8d1 <malloc+0x61>
 8ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 8c2:	8b 4a 04             	mov    0x4(%edx),%ecx
 8c5:	39 f1                	cmp    %esi,%ecx
 8c7:	73 4f                	jae    918 <malloc+0xa8>
 8c9:	8b 3d d0 0c 00 00    	mov    0xcd0,%edi
 8cf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d1:	39 c7                	cmp    %eax,%edi
 8d3:	75 eb                	jne    8c0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 8d5:	83 ec 0c             	sub    $0xc,%esp
 8d8:	ff 75 e4             	pushl  -0x1c(%ebp)
 8db:	e8 5b fc ff ff       	call   53b <sbrk>
  if(p == (char*)-1)
 8e0:	83 c4 10             	add    $0x10,%esp
 8e3:	83 f8 ff             	cmp    $0xffffffff,%eax
 8e6:	74 1b                	je     903 <malloc+0x93>
  hp->s.size = nu;
 8e8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8eb:	83 ec 0c             	sub    $0xc,%esp
 8ee:	83 c0 08             	add    $0x8,%eax
 8f1:	50                   	push   %eax
 8f2:	e8 e9 fe ff ff       	call   7e0 <free>
  return freep;
 8f7:	a1 d0 0c 00 00       	mov    0xcd0,%eax
      if((p = morecore(nunits)) == 0)
 8fc:	83 c4 10             	add    $0x10,%esp
 8ff:	85 c0                	test   %eax,%eax
 901:	75 bd                	jne    8c0 <malloc+0x50>
        return 0;
  }
}
 903:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 906:	31 c0                	xor    %eax,%eax
}
 908:	5b                   	pop    %ebx
 909:	5e                   	pop    %esi
 90a:	5f                   	pop    %edi
 90b:	5d                   	pop    %ebp
 90c:	c3                   	ret    
    if(p->s.size >= nunits){
 90d:	89 c2                	mov    %eax,%edx
 90f:	89 f8                	mov    %edi,%eax
 911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 918:	39 ce                	cmp    %ecx,%esi
 91a:	74 54                	je     970 <malloc+0x100>
        p->s.size -= nunits;
 91c:	29 f1                	sub    %esi,%ecx
 91e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 921:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 924:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 927:	a3 d0 0c 00 00       	mov    %eax,0xcd0
}
 92c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 92f:	8d 42 08             	lea    0x8(%edx),%eax
}
 932:	5b                   	pop    %ebx
 933:	5e                   	pop    %esi
 934:	5f                   	pop    %edi
 935:	5d                   	pop    %ebp
 936:	c3                   	ret    
 937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 93e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 940:	c7 05 d0 0c 00 00 d4 	movl   $0xcd4,0xcd0
 947:	0c 00 00 
    base.s.size = 0;
 94a:	bf d4 0c 00 00       	mov    $0xcd4,%edi
    base.s.ptr = freep = prevp = &base;
 94f:	c7 05 d4 0c 00 00 d4 	movl   $0xcd4,0xcd4
 956:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 959:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 95b:	c7 05 d8 0c 00 00 00 	movl   $0x0,0xcd8
 962:	00 00 00 
    if(p->s.size >= nunits){
 965:	e9 36 ff ff ff       	jmp    8a0 <malloc+0x30>
 96a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 970:	8b 0a                	mov    (%edx),%ecx
 972:	89 08                	mov    %ecx,(%eax)
 974:	eb b1                	jmp    927 <malloc+0xb7>
