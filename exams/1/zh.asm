        segment .data
n:      db  5
pi:     dq  3.14
rad     dq  0
sur:    dq  0
vol:    dq  0
str:    db  "%d spheres with %.4f mm radii: surface: %.4f mm2, volume: %.4f mm3", 10, 0

        segment .text
        global main
        extern printf

main:

        xor         rax, rax                    ; return 0;
        ret

surface:
        ret

volume:
        ret
