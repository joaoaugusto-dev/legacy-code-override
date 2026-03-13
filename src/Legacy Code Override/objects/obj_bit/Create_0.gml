// =========================================================
// VARIÁVEIS DE MOVIMENTO E FÍSICA
// =========================================================
hspd = 0;        // Velocidade Horizontal atual
vspd = 0;        // Velocidade Vertical atual
walk_spd = 4;    // Velocidade de caminhada
jump_spd = 9;    // Força do pulo
subindo = false;
grav = 0.3;

// =========================================================
// CONTROLE DE PULO E ESTADO
// =========================================================
jumps_max = 2;   // Permite pulo duplo
jumps_left = 0;  // Pulos restantes
morto = false;

// =========================================================
// SISTEMA DE GAMEPAD E VIBRAÇÃO
// =========================================================
vib_timer = 0;   // Temporizador da vibração
meu_gamepad = -1; // ID do controle (começa em -1 até detectar um)

// =========================================================
// CONFIGURAÇÃO VISUAL
// =========================================================
image_speed = 1;