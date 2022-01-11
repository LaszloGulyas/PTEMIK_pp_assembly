; A beolvasás csak 1 számjegyu inputra mukodik
        segment .data
n:      dq  0.0
a:      dq  0
b:      dq  0
hyp:    dq  0
stri:   times 21 db 0
strlen:	dq 0
stro:   db  "Triangle %d (a: %.2f mm, b: %.2f mm) hypotenuse: %.2f mm", 10, 0
parama: dq  3.0

        segment .text
        global main
        extern printf

main:
        call    readstr
        call    convert

        push    rbp
        mov     r8, 1
  dowhile:
        push    r8
        push    rsp
        call    calcsidea
        call    calcsideb
        call    calchyp
        ; printf kezdete(str, i, a, b, hyp)
        mov     rdi, stro
        mov     rsi, r8
        movlpd  xmm0, [a]
        movlpd  xmm1, [b]
        movlpd  xmm2, [hyp]
        mov     al, 3
        call    printf
        ; printf vege
        pop     rsp ; rsp-t es r8-ot push/popoljuk hogy a printf ne zavarja be
        pop     r8
        inc     r8
        cmp     r8, 5
        jle     dowhile
        pop     rbp

        xor     rax, rax                    ; return 0;
        ret

readstr:
        mov	    eax, 0
        mov	    rdi, 0
        mov	    rsi, stri  ; beolvassa stringet
        mov	    rdx, 21    ; egyeznie kell a változó mérettel ami deklarálva lett
        syscall
        mov	    [strlen], rax  ; elmenti strlen-be a beirt karakterlanc hosszat +1 (zaro karakter miatt)
        ret

convert:
        mov     rax, 0
        mov     rbx, [strlen]
        dec     rbx
        mov     rdi, stri
        mov     r8, 1
.dowhile:
        ; rsi=char array indexe, rdi=char array erteke, rax=atkonvertalt szam erteke, rbx=hanyszor fusson le a ciklus=char array hossza-1, r8=ciklus szamlalo
        movzx   rsi, byte [rdi]  ; beolvas rdi-bol 1 karaktert
        sub     rsi, 48   ; atkonvertalja szamjeggye az ascii karaktert
        imul    rax, 10   ; szoroz 10-el h novelje a helyi erteket a vegeredmenyben
        add     rax, rsi
        inc     rdi       ; noveli a char array indexet h a kovetkezo karakterre mutasson
        inc     r8        ; ciklus szamlalo ++
        cmp     r8, rbx   ; feltetel
        jle     .dowhile

        ; hozzaadja n-hez a konvertalt szam erteket float formatumban
        push    rax
        fild    qword [rsp]
        add     rsp, 8
        fld     qword [n]
        fadd    st0, st1
        fstp    qword [n]
        fstp    st0
        ret

calcsidea:
        push    r8
        fild    qword [rsp]
        add     rsp, 8
        fld     qword [parama]
        fadd    st0, st1
        fstp    qword [a]
        fstp    st0
        ret

calcsideb:
        push    r8
        fild    qword [rsp]
        add     rsp, 8
        fld     qword [n]
        fdiv    st0, st1
        fstp    qword [b]
        fstp    st0
        ret

calchyp:
        fld     qword [a]
        fmul    st0, st0
        fld     qword [b]
        fmul    st0, st0
        fadd    st0, st1
        fsqrt
        fstp    qword [hyp]
        fstp    st0
        ret
