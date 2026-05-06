// =========================================================
// ESTADOS E INTELIGÊNCIA ARTIFICIAL
// =========================================================
state = "WANDER"; // Estados possíveis: "IDLE" (parado), "WANDER" (andando), "CHASE" (seguindo)
timer = 60;       // Temporizador para trocar de ações
dir = choose(1, -1); // Direção inicial (1 = direita, -1 = esquerda)
death_timer = 0;

// Distâncias de Visão
vision_range = 150; // Distância para começar a seguir o obj_bit
lose_range = 250;   // Distância para o bug desistir e voltar a patrulhar

// =========================================================
// VARIÁVEIS DE MOVIMENTO E FÍSICA
// =========================================================
hspd = 0;
vspd = 0;
grav = 0.3;         // Mesma gravidade do player
walk_spd = 1.5;     // Velocidade patrulhando (mais lento)
chase_spd = 2.5;    // Velocidade perseguindo o player (mais rápido)