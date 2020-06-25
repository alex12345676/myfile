#define BF_PROGRAM_SIZE 1024
#define BF_MEMORY_CELLS 32768
#define BF_MEMORY_SIZE BF_MEMORY_CELLS*4

#define BF_OP_LOOP_START 0
#define BF_OP_LOOP_END   1
#define BF_OP_MOVE_LEFT  2
#define BF_OP_MOVE_RIGHT 3
#define BF_OP_INC        4
#define BF_OP_DEC        5
#define BF_OP_PUTC       6
#define BF_OP_GETC       7
#define BF_OP_EXIT       8

.section .rodata
str_memory_underflow:
        .string "Memory underflow\n"

str_memory_overflow:
        .string "Memory overflow\n"

str_loop_start_not_found:
        .string "No matching '[' found for a ']'\n"

str_loop_end_not_found:
        .string "No matching ']' found for a '['\n"
interpreter_jump_table:
        .quad bf_op_loop_start
        .quad bf_op_loop_end
        .quad bf_op_move_left
        .quad bf_op_move_right
        .quad bf_op_inc
        .quad bf_op_dec
        .quad bf_op_putc
        .quad bf_op_getc
        .quad bf_op_exit
.data
bf_program_ptr:
        .quad 0

bf_program_size:
        .quad 0

/*
 * Программа загружается в память вот так:
 * =============================
 * код_операции, операнд,
 * код_операции, операнд,
 * код_операции, операнд, ...
 * =============================
 * И код_операции, и операнд занимают по 4 байта.
 * Таким образом, одна команда занимает в памяти 8 байт.
 *
 * Для команды [ (начало цикла) операндом является номер команды, 
 * следующий за концом цикла.
 *
 * Для команды ] (конец цикла) операндом является номер команды-начала 
 * цикла ].
 *
 * Для остальных команд (< > + - . ,) операнд задаёт количество 
 * повторений этой команды.  Например, для кода +++++ должен быть 
 * сгенерирован код операции BF_OP_INC с операндом 5, который при 
 * выполнении увеличит текущую ячейку на 5.
 */

.text
.globl main
main:
        pushq %rbp
        movq  %rsp, %rbp

/* ******************************************* */
/* загрузка программы                          */
/* ******************************************* */

        movq  $BF_PROGRAM_SIZE, %rcx
        movq  %rcx, bf_program_size(%rip)
        movq %rcx, %rdi
        call  malloc@plt
        movq  %rax, bf_program_ptr(%rip)

        movq  %rax, %rbx        /* %rbx — указатель на блок памяти, 
                                   содержащий внутреннее представление 
                                   программы                         */
        xorq  %rcx, %rcx        /* %rcx — номер текущей команды      */
        xorq  %rsi, %rsi        /* %rsi — предыдущая команда, символ */

bf_read_loop:
        pushq %rbx
        pushq %rsi
        pushq %rcx
        movq %rcx, %rsi 
        movq stdin(%rip), %rdi
        call  fgetc@plt
    //    addl  $4, %esp
        popq  %rcx
        popq %rsi
        popq %rbx
        cmpq  $-1, %rax
        je    bf_read_end

        cmpq  $'[', %rax         /* команды, которые всегда 
                                   обрабатываются по одной: [ и ]    */
        je    bf_read_loop_start

        cmpq  $']', %rax
        je    bf_read_loop_end

        cmpq  %rsi, %rax        /* текущая команда такая же, как и 
                                   предыдущая?                       */
        jne   not_dupe

        incq  -4(%rbx,%rcx,8)   /* такая же. Но %ecx указывает на 
                                   следующую команду, поэтому 
                                   используем отрицательное смещение -4
                                                                     */
        jmp   bf_read_loop

not_dupe:                       /* другая                            */
        cmpl  $'<', %eax
        je    bf_read_move_left

        cmpl  $'>', %eax
        je    bf_read_move_right

        cmpl  $'+', %eax
        je    bf_read_inc

        cmpl  $'-', %eax
        je    bf_read_dec

        cmpl  $'.', %eax
        je    bf_read_putc

        cmpl  $',', %eax
        je    bf_read_getc

        jmp   bf_read_loop

bf_read_loop_start:
        movl  $BF_OP_LOOP_START, (%rbx,%rcx,8)
        movl  $0, 4(%rbx,%rcx,8)
        jmp   bf_read_switch_end

bf_read_loop_end:
        movl  $BF_OP_LOOP_END, (%rbx,%rcx,8)
        movq  %rcx, %rdx
bf_read_loop_end_find:
        testq %rdx, %rdx
        jz    bf_read_loop_end_not_found
        decq  %rdx
        cmpl  $0, 4(%rbx,%rdx,8)
        je    bf_read_loop_end_found
        jmp   bf_read_loop_end_find
bf_read_loop_end_not_found:
        jmp   loop_start_not_found
bf_read_loop_end_found:
        leal  1(%rcx), %edi
        movl  %edi, 4(%rbx,%rdx,8)
        movl  %edx, 4(%rbx,%rcx,8)
        jmp   bf_read_switch_end

bf_read_move_left:
        movl  $BF_OP_MOVE_LEFT, (%rbx,%rcx,8)
        jmp   bf_read_switch_end_1

bf_read_move_right:
        movl  $BF_OP_MOVE_RIGHT, (%rbx,%rcx,8)
        jmp   bf_read_switch_end_1

bf_read_inc:
        movl  $BF_OP_INC, (%rbx,%rcx,8)
        jmp   bf_read_switch_end_1

bf_read_dec:
        movl  $BF_OP_DEC, (%rbx,%rcx,8)
        jmp   bf_read_switch_end_1

bf_read_putc:
        movl  $BF_OP_PUTC, (%rbx,%rcx,8)
        jmp   bf_read_switch_end_1

bf_read_getc:
        movl  $BF_OP_GETC, (%rbx,%rcx,8)

bf_read_switch_end_1:
        movl  $1, 4(%rbx,%rcx,8)

bf_read_switch_end:

        mov  %rax, %rsi        /* сохранить текущую команду для 
                                   сравнения                         */

        incq  %rcx

        leal  (,%rcx,8), %edx   /* блок памяти закончился?           */
        cmpq  bf_program_size(%rip), %rdx
        jne   bf_read_loop

        addq  $BF_PROGRAM_SIZE, %rdx  /* увеличить размер блока памяти 
                                                                     */
        movq  %rdx, bf_program_size(%rip)
        pushq %rcx
        pushq %rdx
        pushq %rbx
        pushq %rsi
        pushq %rdi
	movq %rdx, %rsi
        movq %rbx, %rdi
        call  realloc@plt
        /addl  $8, %esp
        popq %rdi
        popq %rsi
        popq %rbx
        popq %rdx
        popq  %rcx
        movq  %rax, bf_program_ptr(%rip)
        movq  %rax, %rbx

        jmp   bf_read_loop

bf_read_end:

        movl  $BF_OP_EXIT, (%rbx,%rcx,8)  /* последней добавить 
                                             команду выхода          */
        movl  $1, 4(%rbx,%rcx,8)

/*
 * Ищем незакрытые '[':
 * Ищем 0 в поле операнда.  Саму команду не проверяем, так как 0 может 
 * быть операндом только у '['.
 */

        xorq  %rdx, %rdx
1:
        cmpl  $0, 4(%rbx,%rcx,8)
        je    loop_end_not_found
        incq  %rcx
        testq %rdx, %rcx
        je    2f
        jmp   1b
2:

/* ******************************************* */
/* выполнение программы                        */
/* ******************************************* */


/*        pushl $BF_MEMORY_SIZE   /* выделить блок памяти для памяти 
                                   программы                         */
        movq $BF_MEMORY_SIZE, %rdi
        call  malloc@plt
        //addl  $4, %esp
        movq  %rax, %rsi

        xorq  %rcx, %rcx        /* %ecx — номер текущей команды      */
        xorq  %rdi, %rdi        /* %edi — номер текущей ячейки памяти 
                                                                     */

interpreter_loop:
        movl  (%rbx,%rcx,8), %eax     /* %eax — команда              */
        movl  4(%rbx,%rcx,8), %edx    /* %edx — операнд              */

        jmp   *interpreter_jump_table(,%eax,8)


bf_op_loop_start:
        cmpl  $0, (%rsi,%rdi,4)
        je    bf_op_loop_start_jump
        incq  %rcx
        jmp   interpreter_loop
bf_op_loop_start_jump:
        movq  %rdx, %rcx
        jmp   interpreter_loop

bf_op_loop_end:
        movq  %rdx, %rcx
        jmp   interpreter_loop

bf_op_move_left:
        movq  %rdi, %rax
        subl  %edx, %eax        /* если номер новой ячейки 
                                   памяти < 0 ...                    */
        js    memory_underflow
        movq  %rax, %rdi
        incq  %rcx
        jmp   interpreter_loop

bf_op_move_right:
        movq  %rdi, %rax
        addl  %edx, %eax        /* если номер новой ячейки памяти 
                                   больше допустимого...             */
        cmpl  $BF_MEMORY_CELLS, %eax
        jae   memory_overflow
        movq  %rax, %rdi
        incq  %rcx
        jmp   interpreter_loop

bf_op_inc:
        addl  %edx, (%rsi,%rdi,4)
        incq  %rcx
        jmp   interpreter_loop

bf_op_dec:
        subl  %edx, (%rsi,%rdi,4)
        inc  %rcx
        jmp   interpreter_loop

bf_op_putc:
        xorq  %rax, %rax
        movb  (%rsi,%rdi,4), %al
        pushq %rcx
        pushq %rdi
        movq  %rdx, %rdi
        

bf_op_putc_loop:
        pushq %rdi
        movq %rax, %rdi
        pushq %rsi
        movq stdout(%rip), %rsi

        pushq %rdx
        pushq %rax
        call  fputc@plt
        popq %rax
        popq %rdx
        popq %rsi
        popq %rdi
        decq  %rdi
        testl %edi, %edi
        jne   bf_op_putc_loop
        //addl  $4, %esp
    //    push  %rdi
        push %rsi
        push  %rdx
        movq stdout(%rip), %rdi
        call  fflush@plt
        //addl  $4, %esp
        popq %rdx
        popq %rsi
        popq  %rdi
        popq  %rcx
        incq  %rcx
        jmp   interpreter_loop

bf_op_getc:
        push %rcx
        push %rdi
        movq  %rdx, %rdi
        //pushl stdin
bf_op_getc_loop:
        push %rsi
        push %rdi
        mov stdin(%rip), %rdi
        call  getc@plt
        pop %rdi
        pop %rsi
        decl  %edi
        testl %edi, %edi
        jne   bf_op_getc_loop
        //addl  $4, %esp
        
        movl  %eax, (%rsi,%rdi,4)
        popq  %rdi
        pop  %rcx
        inc  %rcx
        jmp   interpreter_loop

bf_op_exit:
        xorq  %rax, %rax
        jmp   interpreter_exit

/* ******************************************* */
/* обработчики ошибок                          */
/* ******************************************* */

memory_underflow:
        leaq str_memory_underflow(%rip), %rdi /*pushl $str_memory_underflow*/
        xorq %rax, %rax
        call  printf
        movl  $1, %eax
        jmp   interpreter_exit

memory_overflow:
        leaq str_memory_overflow(%rip), %rdi /*pushl $str_memory_overflow*/
        xorq %rax, %rax
        call  printf@plt
        movl  $1, %eax
        jmp   interpreter_exit

loop_start_not_found:
        leaq str_loop_start_not_found(%rip), %rdi  /*pushl $str_loop_start_not_found*/
        xorq %rax, %rax 
        call  printf@plt
        movq  $1, %rax
        jmp   interpreter_exit

loop_end_not_found:

        leaq str_loop_end_not_found(%rip), %rdi        /*pushl $str_loop_end_not_found */
        xorq %rax, %rax
        call  printf@plt
        movq  $1, %rax

interpreter_exit:
        movq  %rbp, %rsp

        popq  %rbp
        ret
        .size main, .-main