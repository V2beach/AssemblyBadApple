data segment
file db 'oh\0001.txt',0;文件名
buf db 2000 dup(?);缓存区
fh dw ?
error_msg db 0dh,0ah,'error!','$' 
success_msg db 0dh,0ah,'done!','$'
data ends

stack segment stack
dw 20h dup(?)
top label word;堆栈
stack ends

code segment
    assume ds:data,cs:code,ss:stack
main proc far;主过程

start:
    mov ax,data
    mov ds,ax

    mov ax,stack
    mov ss,ax
    lea sp,top

	;mov dl,file[3]     ;字符存入寄存器
    ;mov ah,02h     ;调用2号功能输出单个字符
    ;int 21h        ;int 21h调用功能
	
	;mov file[3], 32H
	
	mov bx, 1;bx, bp, si, di四位数，一共7777
	mov bp, 1
	mov si, 1
	mov di, 1
	mov al, 0;ascii
	
	;把屏幕搞干净clear
	mov  ah, 0fh
	int  10h
	mov  ah, 0
	int  10h
	;clear准备，这仨参数不会变，直接覆盖清屏
	mov bh, 0
	mov dh, 0
	mov dl, 0
	L1:;主体就是这个四层循环，分别对应四位数bx, bp, si, di四位数，一共7777
		mov ax, di;di->ah, ascii
		add al, 30H;ascii number
		mov byte ptr file[6], al;写入文件名，通过改变文件名来达到模拟动画逐帧播放效果
		
		;mov dl,al;字符存入寄存器
		;mov ah,02h;调用2号功能输出单个字符
		;int 21h;int 21h调用功能
		
		;invoke Sleep,1000让他停一会
		mov cx, 65535
		subLoop:
			dec cx
			jnz subLoop
		
		call near ptr print;显示
		;clear
		mov dl, 0
		mov ah, 02h
		int 10h
		;mov al, 0
		;mov ah, 06h
		;int 10h
		
		add di, 1;每次加5
		cmp di, 0ah;进位
		jb L1;cf of?
		
	L2:
		mov di, 0
		mov ax, si
		add al, 30H
		mov byte ptr file[5], al
		
		inc si
		cmp si, 0ah
		jb L1
	L3:
		mov si, 0
		mov ax, bp
		add al, 30H
		mov byte ptr file[4], al
		
		inc bp
		cmp bp, 0ah
		jb L1
	L4:
		mov bp, 0
		mov ax, bx
		add al, 30H
		mov byte ptr file[3], al
		
		inc bx;最大就7777
		cmp bx, 7
		jle L1
		
exit:
	;把屏幕搞干净clear
	mov  ah, 0fh
	int  10h
	mov  ah, 0
	int  10h
    mov ah,4ch
    int 21h

    main endp

print proc near;读取文件并打印出来
	;打印文件名，bug了，我在找bug
	;	mov dx, offset file;将串的段内地址装入DX
	;	mov ah, 09h;调用DOS的09H号功能，传入参数DS:DX=串地址，'$'结束字符串
	;	int 21h
	
	push bx
	push bp
	push si
	push di
	
	;open file
    lea dx,file
    mov al,0
    mov ah,3dh
    int 21h
    jc error
    mov fh,ax
    ;read file
    lea dx,buf  
    mov cx,2000
    mov bx,fh

    mov ah,3fh  
    int 21h
    jc error

    mov cx,ax
    lea si,buf

LS:mov dl,[si]
    inc si
    mov ah,02h
    int 21h
    loop LS

    jmp exitsub    

error:
    lea dx,error_msg
    mov ah,09h
    int 21h
	
	;打印文件名，bug了，我在找bug
		mov dx, offset file;将串的段内地址装入DX
		mov ah, 09h;调用DOS的09H号功能，传入参数DS:DX=串地址，'$'结束字符串
		int 21h
	jmp exit
	
exitsub:
	mov bx, fh;句柄
	mov ah, 3eh;关闭文件
	int 21h;不关闭只能读取16个，很怪
	
	pop di
	pop si
	pop bp
	pop bx
	ret
	
	print endp
code ends 
    end start