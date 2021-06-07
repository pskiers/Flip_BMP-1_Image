        bits    32
        section .text
        global  flipdiagbmp1

flipdiagbmp1:
        ;ebp+8 = *img, ebp+12 = widht
        ;start of prologue
        push    ebp
        mov     ebp, esp
        push    ebx
        push    esi
        push    edi
        ;end of prologue

        mov     ebx, [ebp+12]
        add     ebx, 31
        shr     ebx, 3                  ; zamiast tego czegoś zrobić +31 shr 5
        and     ebx, -4
        ;row lenght with padding in ebx

        mov     esi, [ebp+8]
        add     esi, ebx
        ;address of pixel to swap from upper left part in esi

        mov     edi, [ebp+8]
        ;address of pixel to swap from lower right part in edi

        mov     ax, 0x8040              ;bit mask for Pix1 in ah and Pix2 in al

        mov     edx, 1
        ;processed row number, i=1

two_row_loop:
        xor     ecx, ecx
        ;prepare iteration counter, j=0

inc_col_loop:
        cmp     ecx, edx
        jae     end_inc_col_loop        ;break
        ;if all pixels in this row were swaped, break

        push    ebx                     ;store width with padding
        mov     bh, ah                  ;temp = bit1

        mov     bl, al                  ;temp = bit2
        and     bl, [edi]               ;get Pix1 pix-value

        or      [edi], al
        and     bh, [esi]               ;get Pix1 pix-value
        jnz     pix2

        mov     bh, al
        not     bh
        and     [edi], bh
pix2:
        or      [esi], ah
        test    bl, bl
        jnz     restore
pix2_zero:
        mov     bl, ah
        not     bl
        and     [esi], bl               ;...swaping pixels
restore:
        pop     ebx                     ;restore width with padding

        inc     ecx                     ;j++

        ror     ah, 1
        adc     esi, 0                  ;Pix1 += cf

        add     edi, ebx                ;Pix2 += width
        jmp     inc_col_loop

end_inc_col_loop:
        inc     edx                     ;i++
        cmp     edx, [ebp+12]
        jae     end_row_loop            ;break
        ;if (processed rows > rows) break

        add     esi, ebx                ;Pix1 += width

        ror     al, 1
        adc     edi, 0                  ;Pix2 += cf
        mov     ecx, edx                ;j=i
dec_col_loop:
        test    ecx, ecx
        jz      end_dec_col_loop        ;break
        ;if all pixels in this row were swaped, break

        push    ebx                     ;store width with padding
        mov     bh, ah                  ;temp = bit1

        mov     bl, al                  ;temp = bit2
        and     bl, [edi]               ;get Pix1 pix-value

        or      [edi], al
        and     bh, [esi]               ;get Pix1 pix-value
        jnz     pix22

        mov     bh, al
        not     bh
        and     [edi], bh
pix22:
        or      [esi], ah
        test    bl, bl
        jnz     restore2
pix2_zero2:
        mov     bl, ah
        not     bl
        and     [esi], bl               ;...swaping pixels
restore2:
        pop     ebx                     ;restore width with padding

        dec     ecx                     ;j--

        rol     ah, 1
        cmp     ah, 0x01
        jne     no_dec                                                          ;można zrobić magię i się pozbyć skoku
        dec     esi                     ;Pix1--
no_dec:
        sub     edi, ebx                ;Pix2 -= width
        jmp     dec_col_loop

end_dec_col_loop:
        inc     edx                     ;i++
        add     esi, ebx                ;Pix1 += width
        ror     ah, 1
        cmp     ah, 0x80                                                        ;można zrobić magię i się pozbyć skoku
        jne     no_inc
        inc     esi                     ;Pix1++
no_inc:
        add     edi, ebx                ;Pix2 += width
        ror     al, 1
        cmp     al, 0x80
        jne     no_inc2
        inc     edi                     ;Pix2++
no_inc2:
        cmp     edx, [ebp+12]
        jl      two_row_loop
        ;if (processed rows > rows) break

end_row_loop:
        ;epilogue
        pop     edi
        pop     esi
        pop     ebx
        pop     ebp
        ret

