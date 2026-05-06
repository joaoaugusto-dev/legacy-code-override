// Define a cor do texto para verde Matrix
draw_set_color(c_lime);

// Alinhamento padrão
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Desenha o texto no canto superior esquerdo da tela (X: 20, Y: 20)
draw_text(20, 20, "Vidas: " + string(global.vidas));

// Volta a cor para branco para não bugar outros desenhos
draw_set_color(c_white);