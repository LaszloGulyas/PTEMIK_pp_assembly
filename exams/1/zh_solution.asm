        segment .data
n:      dq  5
pi:     dq  3.14
rad:    dq  0
radmul: dq  0.5
sur:    dq  0
surmul: dq  4.0
vol:    dq  0
voldiv: dq  3.0
str:    db  "%d spheres with %.4f mm radii: surface: %.4f mm2, volume: %.4f mm3", 10, 0

        segment .text
        global main
        extern printf

main:
        push    rbp
        ; loop init i=2
        mov     r8, 2
  dowhile:
        ; loop body starts
        push    r8
        push    rsp
        call    radii
        call    surface
        call    volume
        ; printf(str, i, rad, sur, vol)
        mov     rdi, str
        mov     rsi, r8
        movlpd  xmm0, [rad]
        movlpd  xmm1, [sur]
        movlpd  xmm2, [vol]
        mov     al, 3
        call    printf
        pop     rsp
        ; loop body ends
        ; loop header begin
        pop     r8
        inc     r8
        cmp     r8, [n]
        jle     dowhile ; while i<5
        ; loop header end

        ; closing main
        xor     rax, rax ; return 0;
        pop     rbp
        ret

radii:
        push    r8
        fild    qword [rsp]
        add     rsp, 8
        fld     qword [radmul]
        fmul    st0, st1
        fstp    qword [rad]
        fstp    st0
        ret

surface:
        fld     qword [rad]
        fmul    st0, st0
        fld     qword [pi]
        fmul    st0, st1
        fld     qword [surmul]
        fmul    st0, st1
        push    r8
        fild    qword [rsp]
        add     rsp, 8
        fmul    st0, st1
        fstp    qword [sur]
        fstp    st0
        fstp    st0
        fstp    st0
        ret

volume:
        fld     qword [rad]
        fld     qword [rad]
        fmul    st0, st0
        fmul    st1, st0
        fstp    st0
        fld     qword [pi]
        fmul    st1, st0
        fstp    st0
        fld     qword [surmul]
        fmul    st1, st0
        fstp    st0
        fld     qword [voldiv]
        fdiv    st1, st0
        fstp    st0
        push    r8
        fild    qword [rsp]
        add     rsp, 8
        fmul    st1, st0
        fstp    st0
        fstp    qword [vol]
        ret
