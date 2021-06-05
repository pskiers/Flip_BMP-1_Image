        bits    64
        section .text
        global  flipdiagbmp1

flipdiagbmp1:
        push r12
        push r13

        mov     r11, rsi
        add     r11, 7
        shr     r11, 3
        add     r11, 3
        and     r11, -4
        ;row lenght with padding in r11

        mov     r10, rdi
        add     r10, r11
        ;address of pixel to swap from upper left part in r10

        mov     r9, rdi
        ;address of pixel to swap from lower right part in r9

        mov     r13b, 0x80        ;bit mask for Pix1
        mov     al, 0x80        ;bit mask for Pix2
        ror     al, 1

        mov     r8d, 1
        ;processed row number, i=1

two_row_loop:
        cmp     r8d, esi
        jae     end_row_loop
        ;if (processed rows > rows) break

        xor     ecx, ecx
        ;prepare iteration counter, j=0

inc_col_loop:
        cmp     ecx, r8d
        jae     end_inc_col_loop        ;break
        ;if all pixels in this row were swaped, break

        mov     r12b, r13b              ;temp = bit1
        and     r12b, [r10]             ;get Pix1 pix-value

        mov     dl, al                  ;temp = bit2
        and     dl, [r9]                ;get Pix1 pix-value

        test    r12b, r12b              ;swaping pixels...
        jz      pix1_zero
        or      [r9], al
        jmp     pix2
pix1_zero:
        mov     r12b, al
        not     r12b
        and     [r9], r12b
pix2:
        test    dl, dl
        jz      pix2_zero
        or      [r10], r13b
        jmp     restore
pix2_zero:
        mov     dl, r13b
        not     dl
        and     [r10], dl               ;...swaping pixels
restore:
        inc     ecx                     ;j++

        ror     r13b, 1
        cmp     r13b, 0x80
        jne     not_equal
        inc     r10                     ;Pix1++
not_equal:
        add     r9, r11                ;Pix2 += width
        jmp     inc_col_loop

end_inc_col_loop:
        inc     r8d                     ;i++
        cmp     r8d, esi
        jae     end_row_loop            ;break
        ;if (processed rows > rows) break

        add     r10, r11               ;Pix1 += width

        ror     al, 1
        cmp     al, 0x80
        jne     not_equal2
        inc     r9                      ;Pix2++
not_equal2:
        mov     ecx, r8d                ;j=i
dec_col_loop:
        test    ecx, ecx
        jz      end_dec_col_loop        ;break
        ;if all pixels in this row were swaped, break

        mov     r12b, r13b              ;temp = bit1
        and     r12b, [r10]             ;get Pix1 pix-value

        mov     dl, al                  ;temp = bit2
        and     dl, [r9]                ;get Pix1 pix-value

        test    r12b, r12b              ;swaping pixels...
        jz      pix1_zero2
        or      [r9], al
        jmp     pix22
pix1_zero2:
        mov     r12b, al
        not     r12b
        and     [r9], r12b
pix22:
        test    dl, dl
        jz      pix2_zero2
        or      [r10], r13b
        jmp     restore2
pix2_zero2:
        mov     dl, r13b
        not     dl
        and     [r10], dl               ;...swaping pixels
restore2:
        dec     ecx                     ;j--

        rol     r13b, 1
        cmp     r13b, 0x01
        jne     no_dec
        dec     r10                     ;Pix1--
no_dec:
        sub     r9, r11                ;Pix2 -= width
        jmp     dec_col_loop

end_dec_col_loop:
        inc     r8d                     ;i++
        add     r10, r11               ;Pix1 += width
        ror     r13b, 1
        cmp     r13b, 0x80
        jne      no_inc
        inc     r10                     ;Pix1++
no_inc:
        add     r9, r11                ;Pix2 += width
        ror     al, 1
        cmp     al, 0x80
        jne     no_inc2
        inc     r9                      ;Pix2++
no_inc2:
        jmp     two_row_loop

end_row_loop:
        ;epilogue
        push r13
        push r12
        ret

