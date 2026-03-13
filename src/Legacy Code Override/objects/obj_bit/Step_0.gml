// =========================================================
// 0. CONFIGURAÇÕES E ESTADOS INICIAIS
// =========================================================
if (meu_gamepad == -1) {
    for (var i = 0; i < 12; i++) {
        if (gamepad_is_connected(i)) {
            meu_gamepad = i;
            gamepad_set_axis_deadzone(meu_gamepad, 0.25);
            break;
        }
    }
}

if (morto) exit;

// Sistema de vibração
if (vib_timer > 0) {
    vib_timer -= 1;
    if (vib_timer <= 0 && meu_gamepad != -1) {
        gamepad_set_vibration(meu_gamepad, 0, 0);
    }
}

// =========================================================
// 1. INPUT (Teclado e Gamepad)
// =========================================================
var _key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var _key_left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));

// DIFERENCIAÇÃO: Segurar vs Pressionar
var _key_jump_held    = keyboard_check(vk_space);           // Segurar para subir
var _key_jump_pressed = keyboard_check_pressed(vk_space);   // Apertar para pular

if (meu_gamepad != -1) {
    var _axis_val = gamepad_axis_value(meu_gamepad, gp_axislh);
    if (abs(_axis_val) > 0.2) {
        if (_axis_val > 0) _key_right = true;
        if (_axis_val < 0) _key_left = true;
    }
    if (gamepad_button_check(meu_gamepad, gp_padr)) _key_right = true;
    if (gamepad_button_check(meu_gamepad, gp_padl)) _key_left = true;
    
    // Gamepad: Segurar vs Pressionar
    if (gamepad_button_check(meu_gamepad, gp_face1)) _key_jump_held = true;
    if (gamepad_button_check_pressed(meu_gamepad, gp_face1)) _key_jump_pressed = true;
}

// =========================================================
// 2. LÓGICA DE ESCADA (Detecção de 80%)
// =========================================================
var _inst_escada = instance_place(x, y, obj_ladder);
var _pode_subir = false;
subindo = false; // Resetamos o estado a cada frame

if (_inst_escada != noone) {
    // Cálculo de sobreposição horizontal (80% da largura do player)
    var _overlap = min(bbox_right, _inst_escada.bbox_right) - max(bbox_left, _inst_escada.bbox_left);
    if (_overlap >= sprite_width * 0.3) {
        _pode_subir = true;
    }
}

// =========================================================
// 3. FÍSICA E MOVIMENTO
// =========================================================
var _move = _key_right - _key_left;
hspd = _move * walk_spd;

// Verificação de chão
var _no_chao = place_meeting(x, y + 1, obj_chao) || place_meeting(x, y + 1, obj_ponta);
if (_no_chao) jumps_left = jumps_max;

// AÇÃO: Subir na Escada (Prioridade do Espaço)
if (_pode_subir && _key_jump_held) {
    subindo = true;
    vspd = -walk_spd * 0.8; // Sobe com velocidade constante
    jumps_left = jumps_max;  // Reseta pulos enquanto sobe
} 
else {
    // AÇÃO: Pulo Normal (Só se não estiver tentando subir)
    if (_key_jump_pressed && jumps_left > 0 && !_pode_subir) {
        vspd = -jump_spd; 
        jumps_left -= 1;  
        
        if (meu_gamepad != -1) {
            gamepad_set_vibration(meu_gamepad, (jumps_left == 0 ? 0.6 : 0.3), (jumps_left == 0 ? 0.6 : 0.3));
            vib_timer = (jumps_left == 0 ? 15 : 10);
        }
    }
    
    // Se soltou o espaço ou não está na escada: Gravidade (Desce sozinho)
    vspd += grav;
}

// =========================================================
// 4. COLISÕES
// =========================================================
// Horizontal
if (place_meeting(x + hspd, y, obj_chao) || place_meeting(x + hspd, y, obj_ponta)) {
    while (!place_meeting(x + sign(hspd), y, obj_chao) && !place_meeting(x + sign(hspd), y, obj_ponta)) {
        x += sign(hspd);
    }
    hspd = 0;
}
x += hspd;

// Vertical
if (place_meeting(x, y + vspd, obj_chao) || place_meeting(x, y + vspd, obj_ponta)) {
    while (!place_meeting(x, y + sign(vspd), obj_chao) && !place_meeting(x, y + sign(vspd), obj_ponta)) {
        y += sign(vspd);
    }
    vspd = 0;
}
y += vspd;

// =========================================================
// 5. ANIMAÇÃO
// =========================================================
image_speed = 1;

if (subindo) {
    sprite_index = spr_bit_walk; // Use uma sprite de escalada aqui se tiver
    if (hspd != 0) image_xscale = sign(hspd);
} 
else if (!_no_chao) {
    if (jumps_left == 0) {
        if (sprite_index != spr_bit_boost) {
            sprite_index = spr_bit_boost;
            image_index = 0; 
        }
        if (image_index >= image_number - 1) {
            image_speed = 0;
            image_index = image_number - 1;
        }
    } else {
        sprite_index = spr_bit_jump;
    }
    if (hspd != 0) image_xscale = sign(hspd);
} else {
    if (hspd != 0) {
        sprite_index = spr_bit_walk;
        image_xscale = sign(hspd); 
    } else {
        sprite_index = spr_bit_stand;
    }
}

// =========================================================
// 6. MORTE
// =========================================================
if ((place_meeting(x, y, obj_kill) || y > room_height) && !morto) {
    morto = true; 
    if (meu_gamepad != -1) gamepad_set_vibration(meu_gamepad, 1.0, 1.0);
    
    hspd = 0;
    vspd = 0;
    alarm[0] = 10; // Reinicia em apenas 5 frames (quase instantâneo)
}