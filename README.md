# 🕹️ Legacy Code: Override

![Versão](https://img.shields.io/badge/vers%C3%A3o-1.0.0-brightgreen)
![Status](https://img.shields.io/badge/status-finalizado-blue)
![Engine](https://img.shields.io/badge/engine-GameMaker%202024.14-lightgrey)

> **Projeto de Iniciação Científica (IC)**
>
> **Tema:** Inteligência Artificial e Engenharia de Prompt na Criação de Jogos Digitais
> **Instituição:** UNIFEOB
> **Status:** ✅ **Finalizado — v1.0.0 (Release Final)**
>
> Esta é a **versão final** do projeto, encerrando a Iniciação Científica.
> Não há novas versões planejadas. Veja o [CHANGELOG](./CHANGELOG.md) para a
> lista completa de mudanças.

---

## 📋 Sobre o Projeto

**Legacy Code: Override** é um jogo de plataforma 2D em Pixel Art que utiliza metáforas de desenvolvimento de software como mecânicas de gameplay. O jogador controla **B.I.T.** (Basic Intelligent Unit), uma unidade básica de inteligência que deve evoluir seu código, corrigir bugs e utilizar "Engenharia de Prompt" para alterar o cenário e superar obstáculos.

O diferencial do projeto reside no fluxo de trabalho híbrido: o design e conceitos foram gerados via **IA Generativa** e posteriormente refinados manualmente (*pixel perfect*) para garantir a coerência visual e técnica.

---

## 🎞️ Diário de Evolução (Development Log)

Abaixo, a cronologia visual do desenvolvimento técnico, documentando a transição da teoria para a prática.

### 📅 Marco 1: Primeiros Passos e Animação (12/Dez)
*Foco: Configuração da State Machine, Input System e correção de bugs visuais.*

| Teste Inicial | Ajuste de Animação | Correção do "Moonwalk" |
| :---: | :---: | :---: |
| [![Teste 1](http://img.youtube.com/vi/BCbxEvdq-us/0.jpg)](http://www.youtube.com/watch?v=BCbxEvdq-us) | [![Teste 2](http://img.youtube.com/vi/xRWuN0B353g/0.jpg)](http://www.youtube.com/watch?v=xRWuN0B353g) | [![Final](http://img.youtube.com/vi/g0fJhRO6CpU/0.jpg)](http://www.youtube.com/watch?v=g0fJhRO6CpU) |
| *Primeira movimentação* | *Refinamento de sprites* | *Correção de deslizamento* |

---

### 📅 Marco 2: Física, Gravidade e Pulo (17/Dez)
*Foco: Implementação de `vspeed`, colisão precisa e lógica de pulo aéreo.*

| Implementação da Gravidade | Pulo Duplo e Colisão |
| :---: | :---: |
| [![Gravidade](http://img.youtube.com/vi/hnItu9_B3IE/0.jpg)](http://www.youtube.com/watch?v=hnItu9_B3IE) | [![Pulo Duplo](http://img.youtube.com/vi/QWQZUU4YE20/0.jpg)](http://www.youtube.com/watch?v=QWQZUU4YE20) |
| *Teste de peso e queda* | *Mecânica de Double Jump* |

---

### 🚀 Marco 3: Build Final — v1.0.0
*Visualização da build com movimentação fluida e assets integrados.*

[![Status Atual](http://img.youtube.com/vi/1DyJ7RwH23s/0.jpg)](http://www.youtube.com/watch?v=1DyJ7RwH23s)  
* (Clique para assistir a demonstração da build)*

---

## ✨ O que está na v1.0.0

* **Movimentação completa** — caminhada, pulo duplo, gravidade e colisão pixel-a-pixel.
* **Escadas** — subida contínua com detecção por sobreposição de 30%.
* **Teleporters** — transição entre salas com carregamento de 2s, efeito roxo e destino configurável por instância.
* **Inimigos (`obj_bug`)** — IA de três estados (parado, patrulha, perseguição), com visão de 150px e detecção de bordas para não cair de plataformas.
* **Combate** — tiro temático "Matrix" (dígitos 0/1 com rastro glitchado) que elimina inimigos com explosão de faíscas.
* **Sistema de vidas** — 3 vidas, invulnerabilidade temporária após dano e Game Over com reinício de sala ou do jogo.
* **HUD** — indicador triplo de vida em estilo terminal, com alerta visual de dano.
* **Suporte a gamepad** — detecção automática e vibração diferenciada por ação (pulo, tiro, dano, teleporte).

---

## 🎮 Controles

| Ação | Teclado | Gamepad |
| :--- | :--- | :--- |
| Mover | `←` `→` ou `A` `D` | Analógico esquerdo / D-Pad |
| Pular / Pulo duplo | `Espaço` | `A` / `X` |
| Subir escada | Segurar `Espaço` | Segurar `A` / `X` |
| Atirar | `Z` ou `Shift` | `X` / `Quadrado` |

---

## 📥 Download

Os executáveis para **Windows** e **Linux** estão disponíveis na
[página de Releases](https://github.com/joaoaugusto-dev/legacy-code-override/releases/tag/v1.0.0).

| Plataforma | Arquivo | Como executar |
| :--- | :--- | :--- |
| Windows | `Legacy-Code-Override-1.0.0-windows.zip` | Extrair e rodar `Legacy Code Override.exe` |
| Linux | `Legacy-Code-Override-1.0.0-linux.zip` | Extrair, `chmod +x` no executável e rodar |

---

## 🔨 Compilando a partir do código-fonte

O projeto é compilado pelo **GameMaker IDE 2024.14.4.222** ou superior.

1. Abrir `src/Legacy Code Override/Legacy Code Override.yyp` no GameMaker IDE.
2. **Windows:** selecionar o target `Windows` (VM ou YYC) e usar
   `Build → Create Executable`, gerando o `.zip` de distribuição.
3. **Linux:** selecionar o target `Ubuntu (Linux)`. Esse target exige uma máquina
   Ubuntu acessível configurada em `Preferences → Platform Settings → Ubuntu`,
   que o IDE usa para empacotar o build.

---

## 🛠️ Tecnologias e Ferramentas

* **Engine:** GameMaker
* **Linguagem:** GML (GameMaker Language)
* **Arte:** IA Generativa + Canva (Tratamento Manual Pixel Perfect)
* **Documentação:** [Pasta Docs](./docs/)

## 📂 Acesso à Documentação Acadêmica

Para detalhes técnicos e teóricos, consulte os relatórios oficiais anexados neste repositório:
* [📄 Relatório Teórico - Parte 1 (PDF)](./docs/relatorios/PARTE%201-%20Leitura%20IC%20-%20PROD.pdf)
* [📄 Relatório Prático - Parte 2 (PDF)](./docs/relatorios/PARTE%202%20IC%20-%20PRÁTICA%20-%20PROD.pdf)
* [📝 Changelog completo](./CHANGELOG.md)
---
*Desenvolvido como requisito de Iniciação Científica — UNIFEOB.*
*Projeto encerrado na versão 1.0.0 (agosto de 2026).*
