        bits    64
        section .text
        global  flipdiagbmp1

flipdiagbmp1:
        push rbx
        push r12
        push r13
        ;end of prologue

        mov     r13, rsi
        add     r13, 31
        shr     r13, 3
        and     r13, -4
        ;row lenght with padding in r13

        mov     r12, rdi
        add     r12, r13
        ;address of pixel to swap from upper left part in r12
        ;address of pixel to swap from lower right part in rdi

        mov     al, 0x40              ;bit mask for Pix2 in al
        mov     r8b, 0x80               ;bit mask for Pix1 in al

        mov     r10, 1
        ;processed row number, i=1

two_row_loop:
        xor     r11, r11
        ;prepare iteration counter, j=0

inc_col_loop:
        cmp     r11, r10
        jae     end_inc_col_loop        ;break
        ;if all pixels in this row were swaped, break
        mov     r9b, r8b                  ;temp = bit1

        mov     bl, al                  ;temp = bit2
        and     bl, [rdi]               ;get Pix1 pix-value

        or      [rdi], al
        and     r9b, [r12]               ;get Pix1 pix-value
        jnz     pix2

        mov     r9b, al
        not     r9b
        and     [rdi], r9b
pix2:
        or      [r12], r8b
        test    bl, bl
        jnz     restore
pix2_zero:
        mov     bl, r8b
        not     bl
        and     [r12], bl               ;...swaping pixels
restore:
        inc     r11                     ;j++

        ror     r8b, 1
        adc     r12, 0                  ;Pix1 += cf

        add     rdi, r13                ;Pix2 += width
        jmp     inc_col_loop

end_inc_col_loop:
        inc     r10                     ;i++
        cmp     r10, rsi
        jae     end_row_loop            ;break
        ;if (processed rows > rows) break

        add     r12, r13                ;Pix1 += width

        ror     al, 1
        adc     rdi, 0                  ;Pix2 += cf
        mov     r11, r10                ;j=i
dec_col_loop:
        test    r11, r11
        jz      end_dec_col_loop        ;break
        ;if all pixels in this row were swaped, break

        mov     r9b, r8b                  ;temp = bit1

        mov     bl, al                  ;temp = bit2
        and     bl, [rdi]               ;get Pix1 pix-value

        or      [rdi], al
        and     r9b, [r12]               ;get Pix1 pix-value
        jnz     pix22

        mov     r9b, al
        not     r9b
        and     [rdi], r9b
pix22:
        or      [r12], r8b
        test    bl, bl
        jnz     restore2
pix2_zero2:
        mov     bl, r8b
        not     bl
        and     [r12], bl               ;...swaping pixels
restore2:
        dec     r11                     ;j--

        rol     r8b, 1
        cmp     r8b, 0x01
        jne     no_dec                                                          ;można zrobić magię i się pozbyć skoku
        dec     r12                     ;Pix1--
no_dec:
        sub     rdi, r13                ;Pix2 -= width
        jmp     dec_col_loop

end_dec_col_loop:
        inc     r10                     ;i++
        add     r12, r13                ;Pix1 += width
        ror     r8b, 1
        cmp     r8b, 0x80                                                        ;można zrobić magię i się pozbyć skoku
        jne     no_inc
        inc     r12                     ;Pix1++
no_inc:
        add     rdi, r13                ;Pix2 += width
        ror     al, 1
        cmp     al, 0x80
        jne     no_inc2
        inc     rdi                     ;Pix2++
no_inc2:
        cmp     r10, rsi
        jl      two_row_loop
        ;if (processed rows > rows) break

end_row_loop:
        ;epilogue
        pop     rbx
        pop     r12
        pop     r13
        ret

