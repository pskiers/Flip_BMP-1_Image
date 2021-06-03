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

        mov     eax, [ebp+12]
        ;width in eax

        mov     ebx, eax
        add     ebx, 3
        and     ebx, -4
        ;row lenght with padding in ebx

        mov     esi, [ebp+8]
        add     esi, ebx
        ;address of pixel to swap from lower left part in esi

        mov     edi, [ebp+8]
        inc     edi
        ;address of pixel to swap from upper right part in edi

        mov     edx, 1
        ;processed row number, i=1

two_row_loop:
        cmp     edx, eax
        jae     end_row_loop
        ;if (processed rows > rows) break

        xor     ecx, ecx
        ;prepare iteration counter, j=0

inc_col_loop:
        cmp     ecx, edx
        jae     end_inc_col_loop        ;break
        ;if all pixels in this row were swaped, break

        xchg    byte[esi], [edi]        ;swap pixels
        inc     ecx                     ;j++
        inc     esi                     ;Pix1++
        add     edi, ebx                ;Pix2 += width
        jmp     inc_col_loop

end_inc_col_loop:
        inc     edx                     ;i++
        cmp     edx, eax
        jae     end_row_loop            ;break
        ;if (processed rows > rows) break

        lea     esi, [esi+ebx+1]        ;Pix1 += (width+1)
        lea     edi, [edi+ebx+1]        ;Pix2 += (width+1)

        mov     ecx, edx                ;j=i
dec_col_loop:
        test    ecx, ecx
        jz      end_dec_col_loop        ;break
        ;if all pixels in this row were swaped, break

        xchg    byte[esi], [edi]        ;swap pixels
        dec     ecx                     ;j--
        dec     esi                     ;Pix1--
        sub     edi, ebx                ;Pix2 -= width
        jmp     dec_col_loop

end_dec_col_loop:
        inc     edx                     ;i++
        jmp     two_row_loop

end_row_loop:
        ;epilogue
        pop     edi
        pop     esi
        pop     ebx
        pop     ebp
        ret

