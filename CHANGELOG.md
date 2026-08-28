# Changelog — Legacy Code: Override

Todas as mudanças relevantes do projeto estão documentadas neste arquivo.

O formato segue [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/)
e o versionamento segue [Semantic Versioning](https://semver.org/lang/pt-BR/).

---

## [1.0.0] — 2026-08-28 — **Release Final**

> Versão final do jogo. Encerra a Iniciação Científica *"Inteligência Artificial e
> Engenharia de Prompt na Criação de Jogos Digitais"* (UNIFEOB). Não há novas
> versões planejadas.

### Adicionado

**Combate e inimigos**
- `obj_bug` — inimigo com máquina de estados de três fases (`IDLE`, `WANDER`, `CHASE`),
  campo de visão de 150px para engajar e 250px para desistir da perseguição.
- Detecção de bordas e paredes: o inimigo vira ao patrulhar e trava na quina em vez
  de se jogar em buracos durante a perseguição.
- Estado `DYING` com dissolução em verde, tremor e explosão de 15 faíscas (`ef_spark`)
  mais um anel de impacto (`ef_ring`).
- `obj_tiro` — projétil temático "Matrix": dígitos 0/1 sorteados por frame, rastro
  caótico de 8 caracteres com alpha decrescente e núcleo branco de alto contraste.
- Colisão do tiro por `collision_circle` (raio 6 para cenário, 15 para inimigos),
  com autodestruição fora da sala para não vazar memória.
- Disparo em `Z` / `Shift` (teclado) e botão X/Quadrado (gamepad), cooldown de 15 frames.

**Sistema de vidas**
- `global.vidas` com 3 vidas, persistente entre salas.
- Dano por contato com `obj_bug`: recuo vertical, 2,5 segundos de invulnerabilidade
  e piscar vermelho via `gpu_set_fog`.
- Morte instantânea ao tocar `obj_kill` ou cair abaixo da sala.
- Game Over encadeado por `alarm[0]`: reinicia a sala se restam vidas, ou reinicia
  o jogo quando zeram.

**HUD**
- Indicador triplo de vida no `Draw GUI`, em blocos preenchidos (verde) e vazios
  (cinza com borda vermelha), no visual de terminal do jogo.
- Alerta piscante `[ ALERTA: DANO DETECTADO ]` durante a invulnerabilidade.

**Navegação**
- `obj_teleporter` — transição entre salas com carregamento de 2 segundos, efeito
  roxo progressivo, tremor crescente e vibração proporcional ao progresso.
- Destino configurável por instância (`destino`), com fallback para `room_goto_next()`.
- O teleporter também funciona como plataforma sólida e reseta os pulos.

### Alterado
- Colisões de `obj_bit` unificadas para tratar `obj_chao`, `obj_ponta` e
  `obj_teleporter` como sólidos, tanto no eixo horizontal quanto no vertical.
- Escada (`obj_ladder`) passou a exigir 30% de sobreposição horizontal para engajar
  a subida, evitando ativação acidental ao passar raspando.
- Vibração de gamepad diferenciada por ação: pulo simples, pulo duplo, tiro, dano
  e teleporte usam intensidades e durações distintas.

### Corrigido
- O tiro não marca mais inimigos já em estado `DYING`, evitando dupla contagem.
- O jogador não toma dano de inimigos em `DYING`.
- Direção do tiro protegida contra `image_xscale == 0`.
- Direção da perseguição protegida contra `sign()` retornando 0 quando os X coincidem.

---

## [0.x] — 2025-12 a 2026-04 — Desenvolvimento

- **Marco 1 (12/dez/2025)** — State machine de animação, sistema de input e correção
  do deslizamento ("moonwalk") das sprites.
- **Marco 2 (17/dez/2025)** — Gravidade, `vspeed`, colisão pixel-a-pixel e pulo duplo.
- **13/mar/2026** — Ajustes gerais de cenário e assets.
- **10/abr/2026** — Primeira versão do teleporter.

[1.0.0]: https://github.com/joaoaugusto-dev/legacy-code-override/releases/tag/v1.0.0
