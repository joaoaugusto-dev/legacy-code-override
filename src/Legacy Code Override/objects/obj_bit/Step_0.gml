// =========================================================
// 0. SISTEMA DE VIBRAÇÃO (NOVO)
// =========================================================
// Se o timer for maior que 0, diminui. Quando chegar em 0, para de vibrar.
if (vib_timer > 0) {
    vib_timer -= 1;
    if (vib_timer <= 0) {
        gamepad_set_vibration(0, 0, 0); // Desliga os motores (Esq, Dir)
    }
}

// =========================================================
// 1. INPUT (Controles)
// =========================================================

// --- TECLADO ---
var _key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var _key_left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var _key_jump  = keyboard_check_pressed(vk_space); 

// --- CONTROLE (GAMEPAD) ---
if (gamepad_is_connected(0)) {
    var _axis_val = gamepad_axis_value(0, gp_axislh);
    if (_axis_val > 0.2) _key_right = true;
    if (_axis_val < -0.2) _key_left = true;
    if (gamepad_button_check_pressed(0, gp_face1)) _key_jump = true;
}

// =========================================================
// 2. MOVIMENTO E FÍSICA
// =========================================================

// Calcular direção
var _move = _key_right - _key_left;

// Aplicar velocidade horizontal
hspd = _move * walk_spd;

// Aplicar Gravidade
vspd = vspd + grav;

// --- LÓGICA DO PULO DUPLO COM VIBRAÇÃO ---

// Se estiver no chão, recarrega os pulos
if (place_meeting(x, y + 1, obj_chao)) {
    jumps_left = jumps_max;
}

// Se apertar pular E ainda tiver pulos sobrando
if (_key_jump && jumps_left > 0) {
    vspd = -jump_spd; 
    jumps_left -= 1;  
    
    // --- CÓDIGO DA VIBRAÇÃO DO PULO ---
    if (gamepad_is_connected(0)) {
        // Se for o último pulo (Double Jump/Boost), vibra mais forte
        if (jumps_left == 0) {
            gamepad_set_vibration(0, 0.6, 0.6); // Força média
            vib_timer = 15; // Dura 15 frames (1/4 de segundo)
        } 
        // Se for o pulo normal
        else {
            gamepad_set_vibration(0, 0.3, 0.3); // Força fraca
            vib_timer = 10; // Dura 10 frames
        }
    }
}

// =========================================================
// 3. COLISÃO
// =========================================================

// Horizontal
if (place_meeting(x + hspd, y, obj_chao)) {
    while (!place_meeting(x + sign(hspd), y, obj_chao)) {
        x = x + sign(hspd);
    }
    hspd = 0;
}
x = x + hspd;

// Vertical
if (place_meeting(x, y + vspd, obj_chao)) {
    while (!place_meeting(x, y + sign(vspd), obj_chao)) {
        y = y + sign(vspd);
    }
    vspd = 0;
}
y = y + vspd;

// =========================================================
// 4. ANIMAÇÃO
// =========================================================

// Resetar velocidade padrão no início de cada frame
image_speed = 1;

// --- ESTÁ NO AR ---
if (!place_meeting(x, y + 1, obj_chao)) 
{
    // CASO A: Double Jump (Boost)
    if (jumps_left == 0) 
    {
        // TRUQUE PARA NÃO BUGAR:
        // Se o sprite AINDA NÃO ERA o boost, muda e força o frame 0
        if (sprite_index != spr_bit_boost) {
            sprite_index = spr_bit_boost;
            image_index = 0; // <--- O SEGREDO ESTÁ AQUI
        }

        // Se chegou no final da animação, trava no último frame
        if (image_index >= image_number - 1) {
            image_speed = 0;
            image_index = image_number - 1;
        }
    }
    // CASO B: Pulo Normal
    else 
    {
        sprite_index = spr_bit_jump;
    }
    
    // Virar para o lado
    if (hspd != 0) {
        image_xscale = sign(hspd);
    }
}
// --- ESTÁ NO CHÃO ---
else 
{
    if (hspd != 0) {
        sprite_index = spr_bit_walk;
        image_xscale = sign(hspd); 
    } 
    else {
        sprite_index = spr_bit_stand;
    }
}

// =========================================================
// 5. MORTE / REINICIAR (COM DELAY)
// =========================================================

// Se tocar no perigo ou cair E ainda não estiver morto
if ((place_meeting(x, y, obj_kill) || y > room_height) && !morto) {
    
    morto = true; // Trava o personagem
    
    // 1. Vibração máxima de impacto
    if (gamepad_is_connected(0)) {
        gamepad_set_vibration(0, 1.0, 1.0);
    }
    
    // 2. Trava a animação ou muda para sprite de morte (opcional)
    image_speed = 0; 
    hspd = 0;
    vspd = 0;

    // 3. Define um alarme para reiniciar em 0.5 segundos (30 frames)
    alarm[0] = 30; 
}

// Se estiver morto, impede qualquer outro movimento do código acima
if (morto) exit;