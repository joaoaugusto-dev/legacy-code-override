// =========================================================
// HUD: INDICADOR TRIPLO DE VIDA (Draw GUI Event)
// =========================================================

var _gui_x = 20;
var _gui_y = 20;
var _max_vidas = 3; 

// Alinhamento padrão
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// 1. Texto Maior
draw_set_color(c_lime);
// Usamos draw_text_transformed para aumentar a escala do texto em 1.5x (50% maior)
draw_text_transformed(_gui_x, _gui_y, "> STATUS: VIDAS_", 1.5, 1.5, 0); 

// 2. Configurações dos Blocos de Dados (TAMANHOS AUMENTADOS)
var _block_w = 50;      // Largura do bloco (era 35)
var _block_h = 22;      // Altura do bloco (era 15)
var _espacamento = 12;  // Espaço entre um bloco e outro (era 8)

// 3. Loop para desenhar os 3 blocos
for (var i = 0; i < _max_vidas; i++) {
    // Calcula a posição X de cada bloco
    var _px = _gui_x + (i * (_block_w + _espacamento));
    var _py = _gui_y + 35; // Ajustado para ficar abaixo do texto maior

    if (i < global.vidas) {
        // --- ESTADO: CHEIO (Vida Ativa) ---
        draw_set_color(c_lime);
        draw_rectangle(_px, _py, _px + _block_w, _py + _block_h, false);
        
        draw_set_color(c_white);
        draw_rectangle(_px, _py, _px + _block_w, _py + _block_h, true);
        
    } else {
        // --- ESTADO: VAZIO (Vida Perdida) ---
        draw_set_color(c_dkgray); 
        draw_rectangle(_px, _py, _px + _block_w, _py + _block_h, false); 
        
        draw_set_color(c_red);
        draw_rectangle(_px, _py, _px + _block_w, _py + _block_h, true);
    }
}

// 4. Efeito Visual de Alerta (Texto um pouco maior também)
if (invulneravel > 0) {
    if ((invulneravel div 10) % 2 == 0) {
        draw_set_color(c_red);
        // Escala aumentada em 1.2x (20% maior) e posição Y ajustada para não encavalar
        draw_text_transformed(_gui_x, _gui_y + 70, "[ ALERTA: DANO DETECTADO ]", 1.2, 1.2, 0);
    }
}

// Retorna para a cor branca
draw_set_color(c_white);