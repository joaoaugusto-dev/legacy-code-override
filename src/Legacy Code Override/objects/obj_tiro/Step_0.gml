x += hspd;

// Destrói se sair muito da tela (para não pesar a memória do jogo)
if (x < -100 || x > room_width + 100) {
    instance_destroy();
}

// =========================================================
// COLISÕES USANDO CÍRCULO INVISÍVEL (Raio de 6 pixels)
// =========================================================

// Verifica colisão com o Chão/Paredes/Teleporter
var _bateu_parede = collision_circle(x, y, 6, obj_chao, false, true) ||
                    collision_circle(x, y, 6, obj_ponta, false, true) ||
                    collision_circle(x, y, 6, obj_teleporter, false, true);

if (_bateu_parede) {
    instance_destroy();
}

// Verifica colisão com o Bug (Raio aumentado para 15)
var _bug = collision_circle(x, y, 15, obj_bug, false, true);

if (_bug != noone) {
    // Em vez de destruir na hora, dizemos para o bug que ele está morrendo
    if (_bug.state != "DYING") {
        _bug.state = "DYING";
        _bug.death_timer = 0;
    }
    instance_destroy(); // O tiro ainda se destrói ao bater
}