draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Sorteia o número principal todo frame para dar efeito Glitch!
var _char_principal = choose("0", "1");

// =========================================================
// RASTRO CAÓTICO (Ficando menor e trocando de número)
// =========================================================
var _tamanho_rastro = 8;   
var _espacamento = 14;     

for (var i = 1; i <= _tamanho_rastro; i++) {
    var _char_rastro = choose("0", "1"); // Sorteia o rastro a cada frame!
    var _alpha = 1 - (i / _tamanho_rastro);
    var _xx = x - (sign(hspd) * i * _espacamento * escala);
    
    // Pequena tremulação no eixo Y para o rastro parecer instável
    var _yy = y + random_range(-3, 3);
    
    // Desenha o rastro em Verde Escuro
    draw_text_transformed_color(_xx, _yy, _char_rastro, escala * 0.8, escala * 0.8, 0, c_green, c_green, c_teal, c_teal, _alpha * 0.8);
}

// =========================================================
// NÚMERO PRINCIPAL COM ALTO CONTRASTE
// =========================================================
// 1. Sombra preta grossa no fundo para separar do cenário
draw_text_transformed_color(x + 3, y + 3, _char_principal, escala, escala, 0, c_black, c_black, c_black, c_black, 1.0);

// 2. Brilho Lime (Verde Claro) difuso atrás
draw_text_transformed_color(x, y, _char_principal, escala * 1.3, escala * 1.3, 0, c_lime, c_lime, c_green, c_green, 0.7);

// 3. Núcleo Branco Puro na frente (Chama muita atenção)
draw_text_transformed_color(x, y, _char_principal, escala, escala, 0, c_lime, c_lime, c_lime, c_lime, 1.0);

// Reseta o alinhamento
draw_set_halign(fa_left);
draw_set_valign(fa_top);