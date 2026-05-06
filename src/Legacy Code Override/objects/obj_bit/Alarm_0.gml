// Desliga a vibração do controle
if (meu_gamepad != -1) gamepad_set_vibration(meu_gamepad, 0, 0);

if (global.vidas > 0) {
    // Se ainda tem vidas, reinicia só a sala atual
    room_restart();
} else {
    // GAME OVER! 
    // Aqui você poderia mandar para uma tela de Game Over (room_goto(rm_gameover)).
    // Por enquanto, vamos resetar as vidas e reiniciar o jogo todo.
    global.vidas = 3;
    game_restart(); 
}