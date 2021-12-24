
section .text
    global _start 
 
_start: 
   
   
 ; Вывод изначального числа
    mov eax, [num]
    mov ebx, 16
    call print_f
    mov eax, [num]
    mov ebx, 2
    call print_f
  
    
    
    ;Начало сортировки
    jmp for11 ; прыжок
    for12:
    mov eax, [i]
    inc eax
    mov [j], eax
    jmp for21
    for22:
    ; Находим с (байт)
    mov eax, 3; кладем в eax 3
    sub eax, [i]; вычетаем из 3 знач i
    sal eax, 3; Умножение eax на 3
    mov edx, [mack]; Кладем в edx маску
    mov ecx, eax
    sal edx, cl; сдвигаем маску, куда надо
    mov eax, edx
    and eax, [num]; Проходим маской по числу
    mov [c], eax; Результат в с
 
    ; Аналогично находим d(байт)
    mov eax, 3
    sub eax, [j]
    sal eax, 3
    mov edx, [mack]
    mov ecx, eax
    sal edx, cl
    mov eax, edx
    and eax, [num]
    mov [d], eax
 
    mov eax, [c]; a = c
    mov [a], eax
    mov eax, [d]; b = d
    mov [b], eax
 
    ; Считаем кол-во единиц
    jmp counter1; Прыг на сounter1 для проверки условия
   
    word1:
    add DWORD[count1], 1
    mov eax, [a]
    sub eax, 1
    and [a], eax
   
    counter1:
    cmp DWORD[a], 0
    jne word1; Если а - не 0, прыг на word1
 
    ; тоже самое с b
    jmp counter2
   
    word2:
    add DWORD[count2], 1
    mov eax, [b]
    sub eax, 1
    and DWORD [b], eax
    
    counter2:
    cmp DWORD[b], 0
    jne word2
 
    ; Сравниваем count1 и count2
    mov eax, [count2]
    cmp eax, [count1]
    jbe else; если count2 < count1, прыгаем на иначе
 
    ; Убираем из NUM два байта
    mov eax, [num]
    sub eax, [d]
    sub eax, [c]
    mov [num], eax
 
    ;Замена между собой
    ; сдвиг с
    mov eax, [j]
    sub eax, [i]
    sal eax, 3
    mov ecx, eax
    shr DWORD [c], cl
 
    ; сдвиг d
    mov eax, [j]
    sub eax, [i]
    sal eax, 3
    mov ecx, eax
    sal DWORD [d], cl
 
    ; добавляем в NUM два байта
    mov edx,[num]
    mov eax,[d]
    add edx, eax
    mov eax, DWORD [c]
    add eax, edx
    mov DWORD [num], eax
   
    else:
    mov DWORD [count1], 0
    mov DWORD [count2], 0
    add DWORD [j], 1
    
    for21:
    cmp DWORD [j], 3
    jle for22; если j <= 3, прыг обратно
    inc DWORD [i]
    
    for11:
    cmp DWORD [i], 2
    jle for12; если i <= 2, прыг обратно
 
 
 
    ;Вывод отсортированного числа
    mov eax, [num]
    mov ebx, 16
    call print_f
    mov eax, [num]
    mov ebx, 2
    call print_f





 ;  вывод числа
    print_f:
    mov eax, eax ; число для вывода
    mov ebx, ebx     ; система счисления
    call print
    ret

    print:
    mov ecx, esp
    sub esp, 36   ; резервируем место в памяти для строки с числами, (esp - указатель на стэк)

    mov edi, 1
    dec ecx
    mov [ecx], byte 10

    print_loop:

    xor edx, edx
    div ebx ; edx:eax by ebx
    cmp dl, 9     ; если остаток > 9 переходим на use_letter
    jg use_letter

    add dl, '0'
    jmp after_use_letter

    use_letter:
    add dl, 'W'   ; буквы от 'a' до ... в ascii code

    after_use_letter:
    dec ecx
    inc edi
    mov [ecx], dl
    test eax, eax
    jnz print_loop

    ; системный вызов вывода, ecx - указатель на строку
    mov eax, 4    ; номер системного вызова (sys_write)
    mov ebx, 1    ; дескриптор вызова (stdout)
    mov edx, edi  ; длина строки
    int 0x80

    add esp, 36   ; освобождаем память, где была строка с числами
    ret
;Конец вывода



section .data ; объявление данных и констант
    num dd 0xdeadbeef
    mack dd 0x000000FF
    count1 dd 0
    count2 dd 0
    e dd 0
    f dd 0
    i dd 0 ; 4
    j dd 0
    
    
section .bss ; объявление не инициализированных переменных
    a resd 1 ; объявление не инициализированного пространства
    b resd 1
    c resd 1
    d resd 1
