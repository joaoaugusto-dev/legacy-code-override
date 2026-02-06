// Variáveis de Movimento
hspd = 0;       // Velocidade Horizontal atual
vspd = 0;       // Velocidade Vertical atual
walk_spd = 4;   // Velocidade de caminhada (ajuste conforme necessário)
jump_spd = 9;   // Força do pulo
grav = 0.3;     // Gravidade
vib_timer = 0; // Temporizador da vibração

// Controle de Sprite
image_speed = 1; // Garante que a animação rode na velocidade normal
jumps_max = 2;   // O máximo de pulos permitidos (2 = Double Jump)
jumps_left = 0;  // Quantos pulos restam agora
morto = false;