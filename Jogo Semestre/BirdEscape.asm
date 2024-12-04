;Membros
;Felipe Skubs Oliveira - 15451742
;Rafael Auada - 15648400
;Cleverson Cristian Oliveira Sousa - 15522410
;Leonardo Gonsalez - 15657074

jmp main                                            ; Salta para a função principal

Letra: var #1                                        ; Variável para armazenar a entrada do jogador

scoreAtual : string "PLACAR: "                        ; Texto inicial do placar
meteor: string "o"                                   ; Representação gráfica do meteoro
player: string "-"                                   ; Representação gráfica do personagem
posPlayer: var #615                                  ; Posição inicial do personagem
pontuacaoPlayer: var #1                              ; Inicializa o placar com 1

Rand : var #30                                       ; Tabela de valores aleatórios entre 1 e 3
	static Rand + #0, #3
	static Rand + #1, #2
	static Rand + #2, #2
	static Rand + #3, #3
	static Rand + #4, #3
	static Rand + #5, #2
	static Rand + #6, #1
	static Rand + #7, #2
	static Rand + #8, #1
	static Rand + #9, #3
	static Rand + #10, #2
	static Rand + #11, #1
	static Rand + #12, #3
	static Rand + #13, #3
	static Rand + #14, #2
	static Rand + #15, #1
	static Rand + #16, #2
	static Rand + #17, #3
	static Rand + #18, #1
	static Rand + #19, #2
	static Rand + #20, #1
	static Rand + #20, #2
	static Rand + #21, #3
	static Rand + #22, #2
	static Rand + #23, #2
	static Rand + #24, #1
	static Rand + #25, #1
	static Rand + #26, #3
	static Rand + #27, #2
	static Rand + #28, #3
	static Rand + #29, #2

IncRand: var #1                                      ; Incrementador para números aleatórios
delay1: var #500                                    ; Variável para controlar o tempo entre meteoros
delay2: var #1000                                    ; Variável para controlar o tempo do salto

;======================================
;				MAIN
;======================================
main:                                                ; Ponto de entrada principal do código
	
	call ApagaTela                                   ; Limpa a tela
	loadn r1, #tela0Linha0                          ; Carrega o endereço da primeira tela inicial
	loadn r2, #2816                                 ; Define a cor
	call ImprimeTela
	
	loadn r1, #tela5Linha0                          ; Carrega o endereço da segunda tela inicial
	loadn r2, #2304                                 ; Define a cor
	call ImprimeTela2
	
	jmp Loop_Inicio                                 ; Salta para o início do loop

Loop_Inicio:
		
		call InputLetra                             ; Aguarda entrada do jogador
		
		loadn r0, #' '                              ; Verifica se a tecla espaço foi pressionada para começar
		load r1, Letra
		cmp r0, r1
		jne Loop_Inicio
	
reset:
		
		push r2                                     ; Salva o valor de r2 na pilha
		loadn r2, #0                                ; Reseta o placar
		store pontuacaoPlayer, r2
		pop r2                                      ; Restaura o valor de r2
		
		loadn r0, #1000                             ; Configura o delay inicial dos meteoros
		store delay1, R0 
		
		loadn r0, #80                               ; Configura o delay inicial do salto
		store delay2, r0
		
;======================================
;		INICIO DO JOGO
;======================================
InicioJogo:                                         ; Define os valores iniciais antes do loop do jogo
		
		call ApagaTela                              ; Limpa a tela para o jogo
		loadn r1, #tela1Linha0                      ; Carrega o endereço da tela de jogo
		loadn r2, #1536                             ; Define a cor
		call ImprimeTela
		
		loadn r1, #tela3Linha0                      ; Carrega o endereço inicial do cenário
		loadn r2, #2816                             ; Define a cor
		call ImprimeTela2                           ; Desenha o cenário na tela
	
		loadn r0, #14                                ; Configuração inicial do placar
		loadn r1, #scoreAtual                       ; Texto do placar
		loadn r2, #0                                ; Inicializa o contador
		call ImprimeStr
		
		loadn r6, #615                              ; Configura a posição inicial do personagem
		loadn r2, #639                              ; Configura a posição inicial do meteoro
		load r4, player                             ; Armazena o desenho do personagem
		load r1, meteor                             ; Armazena o desenho do meteoro
		loadn r5, #0                                ; Define o ciclo do salto (chão, subir ou descer)
		loadn r3, #0 

		jmp GameLoop                                ; Inicia o loop principal do jogo

GameLoop:                                           ; Ciclo contínuo do jogo
		
			call Collision                         ; Verifica colisões
			call AtpontuacaoPlayer                ; Atualiza o placar
			call ApagaPersonagem                  ; Limpa a posição anterior do personagem
			call PrintaPersonagem                 ; Desenha o personagem
			call AtPosicaometeor                  ; Atualiza a posição do meteoro
			outchar r1, r2                        ; Desenha o meteoro
		
			call DelayjumpPlayer                  ; Gera um atraso e verifica entrada do jogador
			call AtPlayerPos

			push r3                               ; Verifica se o personagem pode pular
			loadn r3, #0 
			cmp r5, r3
				ceq jumpPlayer                   ; Realiza o salto se necessário
			pop r3
			
			call AtPlayerPos2

			push r1                               ; Verifica se o personagem pode agachar
			loadn r1, #0 
			cmp r3, r1
				ceq agacharPlayer		
			pop r1
		
		jmp GameLoop                              ; Repete o ciclo principal
	
;======================================
;			GAMEOVER
;======================================
GameOver:
	
		call ApagaTela                            ; Limpa a tela para o fim de jogo
		loadn r1, #tela2Linha0                    ; Carrega o endereço da tela de fim de jogo
		loadn r2, #3584                           ; Define a cor
		call ImprimeTela
		
		loadn r1, #tela4Linha0                    ; Carrega a mensagem de fim de jogo
		loadn r2, #2304                           ; Define a cor
		call ImprimeTela2
		
		load r5, pontuacaoPlayer                  ; Mostra a pontuação final
		loadn r6, #865	
		call PrintaNumero
		call InputLetra                           ; Aguardando entrada do jogador para reinício
		
		loadn r0, #'n'                            ; Verifica se o jogador quer sair (tecla 'n')
		load r1, Letra
		cmp r0, r1
		jeq fim_de_jogo
		
		loadn r0, #'s'                            ; Verifica se o jogador quer reiniciar (tecla 's')
		cmp r0, r1
		jne GameOver
		
		call ApagaTela                            ; Limpa a tela antes de reiniciar
		jmp reset
		
fim_de_jogo:
	call ApagaTela                                ; Limpa a tela e finaliza o programa
	halt


;======================================
;			DIGITAR LETRA
;======================================

InputLetra:	; Aguarda a digitação de uma tecla e armazena na variável global "Letra".
	push r0	; Salva r0 na pilha para preservar seu valor.
	push r1	; Salva r1 na pilha para preservar seu valor.
	loadn r1, #255	; Valor padrão caso nenhuma tecla seja pressionada.

InputLetra_Loop:
	inchar r0	; Lê o teclado, retorna 255 se nenhuma tecla for pressionada.
	cmp r0, r1	; Compara r0 com 255.
	jeq InputLetra_Loop	; Continua aguardando até que uma tecla válida seja pressionada.

	store Letra, r0	; Armazena a tecla digitada na variável global "Letra".

	pop r1	; Recupera o valor original de r1.
	pop r0	; Recupera o valor original de r0.
	rts	; Retorna da subrotina.

;======================================
;			APAGA TELA 
;======================================

ApagaTela:
	push r0	; Armazena r0 na pilha para manter seu valor.
	push r1	; Armazena r1 na pilha para manter seu valor.
	
	loadn r0, #1200	; Configura o número total de posições a serem apagadas na tela.
	loadn r1, #' '	; Configura o caractere "espaço" para apagar a tela.

ApagaTela_Loop:
	dec r0	; Decrementa a posição atual.
	outchar r1, r0	; Substitui o caractere atual pelo espaço.
	jnz ApagaTela_Loop	; Continua até apagar todas as posições.

	pop r1	; Restaura o valor original de r1.
	pop r0	; Restaura o valor original de r0.
	rts	; Retorna da subrotina.

;======================================
;			IMPRIME TELA 1
;======================================

ImprimeTela:	; Subrotina para exibir um cenário na tela inteira. Parâmetros: r1 - endereço do início do cenário, r2 - cor do cenário.
	push r0	; Protege r0 durante a execução.
	push r1	; Protege r1 durante a execução.
	push r2	; Protege r2 durante a execução.
	push r3	; Protege r3 durante a execução.
	push r4	; Protege r4 durante a execução.
	push r5	; Protege r5 durante a execução.

	loadn r0, #0	; Define a posição inicial na tela.
	loadn r3, #40	; Incremento para pular uma linha na tela.
	loadn r4, #41	; Incremento para avançar para a próxima linha na memória.
	loadn r5, #1200	; Limite total da tela.

ImprimeTela_Loop:
	call ImprimeStr	; Exibe uma linha do cenário.
	add r0, r0, r3	; Avança para a próxima linha na tela.
	add r1, r1, r4	; Avança para a próxima linha na memória.
	cmp r0, r5	; Verifica se atingiu o limite da tela.
	jne ImprimeTela_Loop	; Continua se ainda houver linhas para exibir.

	pop r5	; Recupera o valor original de r5.
	pop r4	; Recupera o valor original de r4.
	pop r3	; Recupera o valor original de r3.
	pop r2	; Recupera o valor original de r2.
	pop r1	; Recupera o valor original de r1.
	pop r0	; Recupera o valor original de r0.
	rts	; Retorna da subrotina.

;======================================
;			IMPRIME TELA 2
;======================================

ImprimeTela2:	; Similar ao "ImprimeTela", mas com um cenário adicional.
	push r0	; Protege r0 durante a execução.
	push r1	; Protege r1 durante a execução.
	push r2	; Protege r2 durante a execução.
	push r3	; Protege r3 durante a execução.
	push r4	; Protege r4 durante a execução.
	push r5	; Protege r5 durante a execução.
	push r6	; Protege r6 durante a execução.

	loadn r0, #0	; Configura a posição inicial na tela.
	loadn r3, #40	; Incremento para pular uma linha na tela.
	loadn r4, #41	; Incremento para avançar para a próxima linha na memória.
	loadn r5, #1200	; Limite total da tela.
	loadn r6, #tela0Linha0	; Configura o início do cenário adicional.

ImprimeTela2_Loop:
	call ImprimeStr2	; Exibe a linha do cenário adicional.
	add r0, r0, r3	; Avança para a próxima linha na tela.
	add r1, r1, r4	; Avança para a próxima linha na memória.
	add r6, r6, r4	; Avança para a próxima linha do cenário adicional.
	cmp r0, r5	; Verifica se atingiu o limite da tela.
	jne ImprimeTela2_Loop	; Continua se ainda houver linhas para exibir.

	pop r6	; Recupera o valor original de r6.
	pop r5	; Recupera o valor original de r5.
	pop r4	; Recupera o valor original de r4.
	pop r3	; Recupera o valor original de r3.
	pop r2	; Recupera o valor original de r2.
	pop r1	; Recupera o valor original de r1.
	pop r0	; Recupera o valor original de r0.
	rts	; Retorna da subrotina.
	


;======================================
;			IMPRIME STRING 1
;======================================


ImprimeStr:	; Subrotina para exibir uma mensagem na tela. 
            ; r0 = posição inicial na tela; r1 = endereço do texto; r2 = cor do texto.
            ; A exibição para ao encontrar '\0'.

	push r0	; Armazena r0 na pilha para preservá-lo
	push r1	; Armazena r1 na pilha para preservá-lo
	push r2	; Armazena r2 na pilha para preservá-lo
	push r3	; Salva r3 na pilha para uso local
	push r4	; Salva r4 na pilha para uso local

	loadn r3, #'\0'	; Define o caractere de parada (\0)

ImprimeStr_Loop:
	loadi r4, r1	; Carrega o caractere atual
	cmp r4, r3	; Verifica se é o caractere de parada
	jeq ImprimeStr_Sai
	add r4, r2, r4	; Aplica a cor ao caractere
	outchar r4, r0	; Exibe o caractere na posição atual
	inc r0		; Move para a próxima posição na tela
	inc r1		; Avança para o próximo caractere
	jmp ImprimeStr_Loop

ImprimeStr_Sai:
	pop r4	; Restaura o valor original de r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts


;======================================
;			IMPRIME STRING 2
;======================================

ImprimeStr2:	; Subrotina para exibir uma mensagem na tela com suporte para cor e espaços. 
                ; r0 = posição inicial na tela; r1 = endereço do texto; r2 = cor do texto. 
                ; Exibição para ao encontrar '\0'.

	push r0	; Armazena r0 na pilha para preservar seu valor
	push r1	; Armazena r1 na pilha para preservar seu valor
	push r2	; Armazena r2 na pilha para preservar seu valor
	push r3	; Salva r3 na pilha para uso local
	push r4	; Salva r4 na pilha para uso local
	push r5	; Salva r5 na pilha para uso local
	push r6	; Salva r6 na pilha para uso local

	loadn r3, #'\0'	; Define o caractere de parada (\0)
	loadn r5, #' '	; Define o espaço como referência

ImprimeStr2_Loop:
	loadi r4, r1	; Carrega o caractere atual
	cmp r4, r3	; Verifica se é o caractere de parada
	jeq ImprimeStr2_Sai
	cmp r4, r5	; Verifica se é um espaço
	jeq ImprimeStr2_Skip
	add r4, r2, r4	; Adiciona cor ao caractere
	outchar r4, r0	; Exibe o caractere na tela
	storei r6, r4	; Salva o caractere exibido para referência futura

ImprimeStr2_Skip:
	inc r0		; Move para a próxima posição da tela
	inc r1		; Avança para o próximo caractere na string
	inc r6
	jmp ImprimeStr2_Loop

ImprimeStr2_Sai:
	pop r6	; Recupera o valor original de r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;======================================
;			ATUALIZA PLAYER POS
;======================================
AtPlayerPos2:
	push r0
	loadn r0, #0
	
	loadn r0, #1
	cmp r3, r0
		ceq Desce

	loadn r0, #2
	cmp r3, r0
		ceq Desce

	loadn r0, #3
	cmp r3, r0
		ceq Sobe

	loadn r0, #4
	cmp r3, r0
		ceq Sobe

	loadn r0, #0
	cmp r3, r0
		cne IncrementaCiclo2

	loadn r0, #5
	cmp r3, r0
		ceq ResetaCiclo2

	pop r0
	rts

AtPlayerPos:	; Atualiza a posição do player com base no ciclo do pulo.

	push r0

	; Verifica se o ciclo atual está nos valores 1 a 4 (subida)
	loadn r0, #1
	cmp r5, r0
		ceq Sobe

	loadn r0, #2
	cmp r5, r0
		ceq Sobe

	loadn r0, #3
	cmp r5, r0
		ceq Sobe

	loadn r0, #4
	cmp r5, r0
		ceq Sobe

	; Verifica se o ciclo atual está nos valores 5 a 8 (descida)
	loadn r0, #5
	cmp r5, r0
		ceq Desce

	loadn r0, #6
	cmp r5, r0
		ceq Desce

	loadn r0, #7
	cmp r5, r0
		ceq Desce

	loadn r0, #8
	cmp r5, r0
		ceq Desce

	; Verifica se o player está no chão (ciclo = 0)
	loadn r0, #0
	cmp r5, r0
		cne IncrementaCiclo

	; Reinicia o ciclo quando alcança 9
	loadn r0, #9
	cmp r5, r0
		ceq ResetaCiclo

	pop r0
	rts

;======================================
;			ATUALIZA POS METEOR
;======================================

AtPosicaometeor:	; Atualiza a posição do meteor na tela.

	push r0
	loadn r0, #' '	; Define um espaço para apagar o meteor anterior
	outchar r0, r2	; Exibe o espaço na posição atual
	dec r2		; Move o meteor uma posição para a esquerda

	; Reseta a posição do meteor quando alcança o limite da tela
	loadn r0, #480
	cmp r2, r0
		ceq MeteorReset

	loadn r0, #440
	cmp r2, r0
		ceq MeteorReset

	loadn r0, #400
	cmp r2, r0
		ceq MeteorReset

	pop r0
	rts

;======================================
;			RESETA METEOR
;======================================

MeteorReset:	; Reseta a posição do meteor para o valor padrão.

	push r0
	push r1
	push r3

	loadn r2, #639	; Define a posição padrão inicial do meteor
	call GeraPosicao	; Gera uma nova posição aleatória para o meteor

	loadn r1, #1	; Ajusta a posição para o caso 1
	cmp r3, r1
	ceq AlteraPos1

	loadn r1, #2	; Ajusta a posição para o caso 2
	cmp r3, r1
	ceq AlteraPos2

	pop r3
	pop r1
	pop r0
	rts


;======================================
;			GERA POS
;======================================

GeraPosicao :
    push r0
    push r1
    
    ; Sorteia número aleatório entre 0 e 7
    loadn r0, #Rand      ; Carrega o endereço da tabela Rand na memória
    load r1, IncRand     ; Carrega o incremento atual da tabela Rand
    add r0, r0, r1       ; Soma o incremento ao início da tabela Rand
                         ; r0 agora aponta para a posição desejada na tabela Rand
    loadi r3, r0         ; Carrega o número aleatório da memória em r3
                         ; r3 contém o valor Rand(IncRand)
                         
    inc r1               ; Incrementa o valor do incremento
    loadn r0, #30
    cmp r1, r0           ; Compara o incremento com o tamanho da tabela
    jne ResetaVetor      ; Se o incremento ainda está dentro do limite, pula a próxima instrução
        loadn r1, #0     ; Reinicia o incremento para 0 se atingir o final da tabela
  ResetaVetor:
    store IncRand, r1    ; Salva o incremento atualizado
    
    pop r1
    pop r0
    rts                  ; Retorna da função

ResetaAleatorio:
    push r2
    loadn r2, #28        ; Define um valor base (28)
    sub r1, r2, r2       ; Reseta r1 com base no valor definido
    pop r2
    rts                  ; Retorna da função


;======================================
;			POS 1 ALTERA
;======================================

AlteraPos1:
    push r1
    loadn r1, #40        ; Define um deslocamento de 40
    sub r2, r2, r1       ; Altera a posição usando o deslocamento
    pop r1
    rts                  ; Retorna da função


;======================================
;			POS 2 ALTERA
;======================================

AlteraPos2:
    push r1
    loadn r1, #80        ; Define um deslocamento de 80
    sub r2, r2, r1       ; Altera a posição usando o deslocamento
    pop r1
    rts                  ; Retorna da função

;======================================
;       	JUMP PLAYER
;======================================	

; Funcao que checa se o jogador pressionou 'space' e, se sim, inicia o ciclo do pulo

jumpPlayer:
	push r7
	push r4
	loadn r7, #' '
	load r4, Letra 			; Caso ' space' tenha sido pressionado	
	cmp r7, r4
		ceq IncrementaCiclo		; Inicia o ciclo do pulo
	pop r4 
	pop r7		
	rts

agacharPlayer:
	push r1
	push r7
	loadn r7, #'a'
	load r1, Letra 			; Caso ' a ' tenha sido pressionado	
	cmp r7, r1
		ceq IncrementaCiclo2	
	pop r1 		
	pop r7
	rts
;======================================
;                 INCREMENTA CICLO PULO
;======================================

; Incrementa o ciclo do pulo

IncrementaCiclo:

	inc r5
	rts

IncrementaCiclo2:

	inc r3
	rts
;======================================
;                 RESETA CILO PULO
;======================================

; Reseta o ciclo do pulo

ResetaCiclo:

	loadn r5, #0
	rts
ResetaCiclo2:

	loadn r3, #0
	rts
;======================================
;                  SOBE
;======================================

; Funcao que sobe o personagem para a linha de cima (-40 em sua posicao)

Sobe:

	push r1
	push r2
	
	call ApagaPersonagem
	
	loadn r1, #40
	sub r6, r6, r1
	
	pop r2
	pop r1
	rts 
	
;======================================
;                  DESCE
;======================================

; Funcao que desce o personagem para a linha de cima (+40 em sua posicao)
	
Desce:

	push r1
	push r2
	
	call ApagaPersonagem
	"                                        "
	loadn r1, #40
	add r6, r6, r1
	
	pop r2
	pop r1
	rts

;=========================================
;            INCREMENTA PONTUAÇÃO PLAYER
;=========================================

; Funcao que  incrementa os pontuacaoPlayer do jogador

IncpontuacaoPlayer:

	push r1
	push r2
	
	load r2, pontuacaoPlayer
	
	inc r2
	
	load r1, delay1
	dec r1

	store delay1, r1
	
	load r1, delay2
	dec r1
	dec r1

	store delay2, r1
	
	store pontuacaoPlayer, r2
	
	pop r2
	pop r1
	rts

;======================================
;             ATUALIZA PONTUAÇÃO PLAYER
;======================================

AtpontuacaoPlayer:

	push r1
	push r5
	push r6
	
	loadn r1, #615		; Caso o meteor tenha passado pela posicao do jogador, incrementa a pontuacao
	cmp r2, r1
		ceq IncpontuacaoPlayer
	
	loadn r1, #575		; caso do meteor estar em  outra linha
	cmp r2, r1
		ceq IncpontuacaoPlayer
		
	loadn r1, #535		; caso do meteor estar em  outra linha
	cmp r2, r1
		ceq IncpontuacaoPlayer
		
	load r5, pontuacaoPlayer
	
	loadn r6, #22 ; Posição da pontuação na tela
	
	call PrintaNumero	; Imprime a pontuacao na tela
	
	pop r6
	pop r5
	pop r1
	rts	
	
;======================================
;             DELAY JUMP PLAYER
;======================================
 
; Funcao que da' o delay de um ciclo do jogo e tambem le uma tecla do teclado

DelayjumpPlayer:
	push r0
	push r1
	push r2
	push r3
	
	load r0, delay1
	loadn r3, #255
	store Letra, r3		; Guarda 255 na Letra pro caso de nao apertar nenhuma tecla
	
	loop_delay_1:
		load r1, delay2

; Bloco de ler o Teclado no meio do DelayjumpPlayer!!		
			loop_delay_2:
				inchar r2
				cmp r2, r3 
				jeq loop_skip
				store Letra, r2		; Se apertar uma tecla, guarda na variavel Letra
			
	loop_skip:			
		dec r1
		jnz loop_delay_2
		dec r0
		jnz loop_delay_1
		jmp sai_dalay
	
	sai_dalay:
		pop r3
		pop r2
		pop r1
		pop r0
	rts

;======================================
;                PRINTA NUMERO
;======================================

; Imprime um numero de 2 digitos na tela

PrintaNumero:	; R5 contem um numero de ate' 2 digitos e R6 a posicao onde vai imprimir na tela

	push r0
	push r1
	push r2
	push r3
	
	loadn r0, #10
	loadn r2, #48
	
	div r1, r5, r0	; Divide o numero por 10 para imprimir a dezena
	
	add r3, r1, r2	; Soma 48 ao numero pra dar o Cod.  ASCII do numero
	outchar r3, r6
	
	inc r6			; Incrementa a posicao na tela
	
	mul r1, r1, r0	; Multiplica a dezena por 10
	sub r1, r5, r1	; Pra subtrair do numero e pegar o resto
	
	add r1, r1, r2	; Soma 48 ao numero pra dar o Cod.  ASCII do numero
	outchar r1, r6
	
	pop r3
	pop r2
	pop r1
	pop r0

	rts

;======================================
;               PRINTA PERSONAGEM
;======================================

; Desenha o personagem na tela

PrintaPersonagem:
	push r0
	
	outchar r4, r6 ; Printa o corpo do boneco	
	dec r4
	loadn r0, #40
	sub r6, r6, r0
	outchar r4, r6 ; Printa a cabeca  do boneco
	add r6, r6, r0
	inc r4
	
	pop r0			
	rts
	
;======================================
;               APAGA PERSONAGEM
;======================================

; Apaga o personagem da tela

ApagaPersonagem:
	
	push r4
	push r0

	loadn r4, #' '	; Printa um espaco no lugar do personagem, apagando-o
	outchar r4, r6 	
	
	loadn r0, #40
	sub r6, r6, r0
	outchar r4, r6 
	add r6, r6, r0
	
	pop r0
	pop r4
	rts
	
;======================================
;                COLLISION
;======================================
Collision:
	push r0
	 
	;;compara posicao inferior do personagem com a do meteor, se igual finaliza o jogo
	cmp r2, r6 
	jeq GameOver
	
	loadn r0,#40
	sub r6,r6,r0
	
	;;compara posicao superior do personagem com a do meteor, se igual finaliza o jogo
	cmp r2, r6
	jeq GameOver
	
	add r6,r6,r0
	
	pop r0
	rts

													   
;======================================
; TELA INICIAL
;======================================

tela0Linha0  : string "                                        "
tela0Linha1  : string "                                        "
tela0Linha2  : string "                                        "
tela0Linha3  : string "                                        "
tela0Linha4  : string "                                        "
tela0Linha5  : string "                                        "
tela0Linha6  : string "                                        "
tela0Linha7  : string "                                        "
tela0Linha8  : string "          B I R D   E S C A P E         "  
tela0Linha9  : string "                                        "                   
tela0Linha10 : string "                                        "               
tela0Linha11 : string "                 ^^^^^                  "               
tela0Linha12 : string "                ^^^  ^^                 "            
tela0Linha13 : string "                ^^^^^^^                 "                   
tela0Linha14 : string "                ^^^^^                   "                  
tela0Linha15 : string "                 ^^^^^^                 "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "           ESPACO PARA JOGAR            "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "

;======================================
; TELA DE JOGO 1
;======================================
;Cenario
tela1Linha0  : string "      *                            *    "
tela1Linha1  : string "                     *                  "
tela1Linha2  : string "      *****       *             *       "
tela1Linha3  : string "     ***                                "
tela1Linha4  : string "    ***       *           *             "
tela1Linha5  : string "     ***                                "
tela1Linha6  : string "      *****            *            *   "
tela1Linha7  : string "                                        "
tela1Linha8  : string "    *                                   "
tela1Linha9  : string "          *               *             "
tela1Linha10 : string "                                        "
tela1Linha11 : string "                                        "
tela1Linha12 : string "                                        "
tela1Linha13 : string "                                        "
tela1Linha14 : string "                                        "
tela1Linha15 : string "                                        "
tela1Linha16 : string "                                        "
tela1Linha17 : string "                                        "
tela1Linha18 : string "                                        "
tela1Linha19 : string "                                        "
tela1Linha20 : string "                                        "
tela1Linha21 : string "                                        "
tela1Linha22 : string "                                        "
tela1Linha23 : string "										   "
tela1Linha24 : string "                                        "
tela1Linha25 : string "                                        "
tela1Linha26 : string "                                        "
tela1Linha27 : string "                                        "
tela1Linha28 : string "                                        "
tela1Linha29 : string "                                        "

;======================================
; GAME OVER
;======================================

tela2Linha0  : string "                                        "
tela2Linha1  : string "                                        "
tela2Linha2  : string "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
tela2Linha3  : string "                                        "
tela2Linha4  : string "                                        "
tela2Linha5  : string "                                        "
tela2Linha6  : string "                                        "
tela2Linha7  : string "                                        "
tela2Linha8  : string "                                        "
tela2Linha9  : string "                                        "
tela2Linha10 : string "            JOGAR NOVAMENTE             "
tela2Linha11 : string "                                        "
tela2Linha12 : string "                                        "
tela2Linha13 : string "                                        "
tela2Linha14 : string "                                        "
tela2Linha15 : string "                                        "
tela2Linha16 : string "                                        "
tela2Linha17 : string "                                        "
tela2Linha18 : string "                                        "
tela2Linha19 : string "                                        "                                   
tela2Linha20 : string "                                        "
tela2Linha21 : string "              PLACAR:                   "
tela2Linha22 : string "                                        "
tela2Linha23 : string "                                        "
tela2Linha24 : string "                                        "
tela2Linha25 : string "                                        "
tela2Linha26 : string "                                        "
tela2Linha27 : string "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
tela2Linha28 : string "                                        "
tela2Linha29 : string "                                        "

; Declara e preenche tela linha por linha (40 caracteres): 

; TELA CENARIO 2
tela3Linha0  : string "                                        "
tela3Linha1  : string "                                        "
tela3Linha2  : string "                                        "
tela3Linha3  : string "                                        "
tela3Linha4  : string "                                        "
tela3Linha5  : string "                                        "
tela3Linha6  : string "                                        "
tela3Linha7  : string "                                        "
tela3Linha8  : string "                                        "
tela3Linha9  : string "                                        "
tela3Linha10 : string "                                        "
tela3Linha11 : string "                                        "
tela3Linha12 : string "                                        "
tela3Linha13 : string "                                        "
tela3Linha14 : string "                                        "
tela3Linha15 : string "                                        "
tela3Linha16 : string "                                        "
tela3Linha17 : string "                                        "
tela3Linha18 : string "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
tela3Linha19 : string "     . OOOOOOO            .      .      "
tela3Linha20 : string "      OOOOOOOOO                         "
tela3Linha21 : string "        OOOOOO            OOOOOOO       "
tela3Linha22 : string "         ~~              OOOOOOOOO     O"
tela3Linha23 : string "     .   ~~               OOOOOOO     OO"
tela3Linha24 : string "         ~~   .             ~~         O"
tela3Linha25 : string "         ~~        .        ~~          "
tela3Linha26 : string "OO                          ~~          "
tela3Linha27 : string "OOO  .                      ~~          "
tela3Linha28 : string "OO                 .                    "
tela3Linha29 : string "~          .                    .       "

tela4Linha0  : string "                                        "
tela4Linha1  : string "                                        "
tela4Linha2  : string "                                        "
tela4Linha3  : string "                                        "
tela4Linha4  : string "                                        "
tela4Linha5  : string "               GAME OVER                "
tela4Linha6  : string "                                        "
tela4Linha7  : string "                                        "
tela4Linha8  : string "                                        "
tela4Linha9  : string "                                        "
tela4Linha10 : string "                                        "
tela4Linha11 : string "                                        "
tela4Linha12 : string "                                        "
tela4Linha13 : string "                 S / N                  "
tela4Linha14 : string "                                        "
tela4Linha15 : string "                                        "
tela4Linha16 : string "                                        "
tela4Linha17 : string "                                        "
tela4Linha18 : string "                                        "
tela4Linha19 : string "                                        "
tela4Linha20 : string "                                        "
tela4Linha21 : string "                                        "
tela4Linha22 : string "                                        "
tela4Linha23 : string "                                        "
tela4Linha24 : string "                                        "
tela4Linha25 : string "                                        "
tela4Linha26 : string "                                        "
tela4Linha27 : string "                                        "
tela4Linha28 : string "                                        "
tela4Linha29 : string "                                        "

tela5Linha0  : string "                                        "
tela5Linha1  : string "                                        "
tela5Linha2  : string "                                        "
tela5Linha3  : string "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
tela5Linha4  : string "                                        "
tela5Linha5  : string "                                        "
tela5Linha6  : string "                                        "
tela5Linha7  : string "                                        "
tela5Linha8  : string "                                        "                               "
tela5Linha9  : string "                                        "                   
tela5Linha10 : string "                                        "               
tela5Linha11 : string "                                        "               
tela5Linha12 : string "                                        "            
tela5Linha13 : string "                                        "                   
tela5Linha14 : string "                                        "                  
tela5Linha15 : string "                                        "
tela5Linha16 : string "                                        "
tela5Linha17 : string "                                        "
tela5Linha18 : string "                                        "
tela5Linha19 : string "                                        "
tela5Linha20 : string "                                        "
tela5Linha21 : string "                                        "
tela5Linha22 : string "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
tela5Linha23 : string "                                        "
tela5Linha24 : string "                                        "
tela5Linha25 : string "                                        "
tela5Linha26 : string "                                        "
tela5Linha27 : string "                                        "
tela5Linha28 : string "                                        "
tela5Linha29 : string "                                        "