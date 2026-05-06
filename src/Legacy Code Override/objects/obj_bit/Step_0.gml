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
var _key_left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));

// DIFERENCIAÇÃO: Segurar vs Pressionar
var _key_jump_held    = keyboard_check(vk_space);           // Segurar para subir
var _key_jump_pressed = keyboard_check_pressed(vk_space);   // Apertar para pular

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

// Verificação de chão (inclui o teleporter para resetar o pulo)
var _no_chao = place_meeting(x, y + 1, obj_chao) || place_meeting(x, y + 1, obj_ponta) || place_meeting(x, y + 1, obj_teleporter);
if (_no_chao) jumps_left = jumps_max;

// AÇÃO: Subir na Escada (Prioridade do Espaço)
if (_pode_subir && _key_jump_held) {
    subindo = true;
    vspd = -walk_spd * 0.8; // Sobe com velocidade constante
    jumps_left = jumps_max;  // Reseta pulos enquanto sobe
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

// Horizontal (OBJ_TELEPORTER DE VOLTA PARA SER PAREDE SÓLIDA)
if (place_meeting(x + hspd, y, obj_chao) || place_meeting(x + hspd, y, obj_ponta) || place_meeting(x + hspd, y, obj_teleporter)) {
    while (!place_meeting(x + sign(hspd), y, obj_chao) && !place_meeting(x + sign(hspd), y, obj_ponta) && !place_meeting(x + sign(hspd), y, obj_teleporter)) {
        x += sign(hspd);
    }
    hspd = 0;
}
x += hspd;

// Vertical (OBJ_TELEPORTER DE VOLTA PARA SER CHÃO SÓLIDO)
if (place_meeting(x, y + vspd, obj_chao) || place_meeting(x, y + vspd, obj_ponta) || place_meeting(x, y + vspd, obj_teleporter)) {
    while (!place_meeting(x, y + sign(vspd), obj_chao) && !place_meeting(x, y + sign(vspd), obj_ponta) && !place_meeting(x, y + sign(vspd), obj_teleporter)) {
        y += sign(vspd);
    }
    vspd = 0;
}
y += vspd;

// =========================================================
// 4. LÓGICA DO TELEPORTER (Efeito Roxo e Destino Específico)
// =========================================================
// Pega a ID do teleporter em vez de apenas true/false
var _inst_teleporter = instance_place(x, y + 1, obj_teleporter);
if (_inst_teleporter == noone) _inst_teleporter = instance_place(x + 1, y, obj_teleporter);
if (_inst_teleporter == noone) _inst_teleporter = instance_place(x - 1, y, obj_teleporter);

if (_inst_teleporter != noone && !morto) {
    is_teleporting = true;
    teleport_timer += 1;

    var _progress = clamp(teleport_timer / teleport_duration, 0, 1);

    // Efeito Visual: Vai da cor normal para o roxo
    image_blend = merge_color(c_white, c_white, _progress);
    
    // Faz ele tremer levemente conforme carrega
    if (_progress > 0.5) {
        x += random_range(-1, 1);
    }

    if (meu_gamepad != -1) {
        var _vib = _progress * 0.5; 
        gamepad_set_vibration(meu_gamepad, _vib, _vib);
        vib_timer = 2;
    }

    // Quando atingir os 5 segundos
    if (teleport_timer >= teleport_duration) {
        if (meu_gamepad != -1) gamepad_set_vibration(meu_gamepad, 0, 0); 
        
        // Verifica se aquele teleporter específico tem um destino configurado
        if (variable_instance_exists(_inst_teleporter, "destino")) {
            room_goto(_inst_teleporter.destino);
        } else {
            // Se você esquecer de configurar o destino, ele vai para a próxima sala por padrão
            room_goto_next(); 
        }
    }
} else {
    is_teleporting = false;
    teleport_timer = 0;
    if (!morto) image_blend = c_white; 
}

// =========================================================
// 5. ANIMAÇÃO
// =========================================================
image_speed = 1;

if (subindo) {
    sprite_index = spr_bit_walk; 
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
    alarm[0] = 10; // Reinicia em apenas 10 frames
}

// =========================================================
// SISTEMA DE TIRO (MATRIX)
// =========================================================
if (cooldown_tiro > 0) cooldown_tiro -= 1;

// Define o botão de tiro (Teclado: Z ou Shift | Gamepad: Botão X / Quadrado)
var _key_shoot = keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_shift);

if (meu_gamepad != -1) {
    if (gamepad_button_check_pressed(meu_gamepad, gp_face3)) _key_shoot = true; 
}

if (_key_shoot && cooldown_tiro <= 0) {
    var _tiro = instance_create_depth(x, y, depth, obj_tiro);
    
    var _dir = sign(image_xscale);
    if (_dir == 0) _dir = 1; 
    
    _tiro.hspd = _dir * 8; 
    cooldown_tiro = 15; 
    
    // ==========================================
    // NOVA VIBRAÇÃO RÁPIDA DO TIRO
    // ==========================================
    if (meu_gamepad != -1) {
        gamepad_set_vibration(meu_gamepad, 0.4, 0.4); // Força média
        vib_timer = 8; // Vibra por uma fração de segundo (8 frames)
    }
}