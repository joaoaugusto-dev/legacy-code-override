// =========================================================
// DESENHO DO PERSONAGEM E EFEITO DE DANO
// =========================================================
if (invulneravel > 0) {
    // A mágica do piscar: A cada 8 frames, ele passa 4 vermelho e 4 normal
    if (invulneravel % 8 < 4) {
        gpu_set_fog(true, c_red, 0, 0); // Pinta ele totalmente de vermelho
        draw_self();
        gpu_set_fog(false, c_red, 0, 0); // Tira o efeito
    } else {
        draw_self(); // Desenha normal
    }
} else {
    draw_self(); // Desenha normal quando não está machucado
}

// =========================================================
// EFEITO DO TELEPORTE (O que você já tinha)
// =========================================================
if (is_teleporting) {
    gpu_set_fog(true, c_white, 0, 0);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_purple, teleport_timer/teleport_duration);
    gpu_set_fog(false, c_white, 0, 0);
}