        segment .data
n:      dq  0
a:      dq  0
b:      dq  0
hyp:    dq  0
stri:   times 21 db 0
stro:   db  "Triangle %d (a: %.2f mm, b: %.2f mm) hypotenuse: %.2f mm", 10, 0

        segment .text
        global main
        extern printf

main:

        xor         rax, rax                    ; return 0;
        ret

readstr:
        ret

convert:
        ret

calchyp:
        ret
