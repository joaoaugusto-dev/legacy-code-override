// =========================================================
// 1. GRAVIDADE E FÍSICA BÁSICA
// =========================================================
vspd += grav;

// =========================================================
// 2. MÁQUINA DE ESTADOS E INTELIGÊNCIA ARTIFICIAL
// =========================================================
var _dist_to_player = distance_to_object(obj_bit);

switch (state) {
    case "IDLE": // Inimigo parado pensando
        hspd = 0;
        timer--;
        if (timer <= 0) {
            state = "WANDER";
            dir = choose(1, -1); // Escolhe uma nova direção
            timer = irandom_range(60, 120); // Anda por 1 a 2 segundos
        }
        
        // Se o player entrar no campo de visão
        if (instance_exists(obj_bit) && _dist_to_player < vision_range) {
            state = "CHASE";
        }
        break;

    case "WANDER": // Inimigo andando aleatoriamente
        hspd = dir * walk_spd;
        timer--;
        if (timer <= 0) {
            state = "IDLE";
            timer = irandom_range(30, 90); // Fica parado por um tempo
        }
        
        // Se o player entrar no campo de visão
        if (instance_exists(obj_bit) && _dist_to_player < vision_range) {
            state = "CHASE";
        }
        break;

    case "CHASE": // Inimigo perseguindo o player
        if (instance_exists(obj_bit)) {
            dir = sign(obj_bit.x - x); // Olha para a direção do player
            if (dir == 0) dir = 1;     // Previne bugar se o X for exatamente igual
            hspd = dir * chase_spd;
        }

        // Se o player fugir para muito longe, ele desiste
        if (_dist_to_player > lose_range) {
            state = "IDLE";
            timer = 60;
        }
        break;
		case "DYING": // Inimigo foi atingido e está sendo deletado
        hspd = 0; 
        death_timer++;
        
        var _progresso = clamp(death_timer / 30, 0, 1);
        
        // Vai ficando verde aos poucos
        image_blend = merge_color(c_white, c_lime, _progresso);
        
        // Tremidinha mais violenta
        x += random_range(-2, 2);
        
        // ===================================================
        // EXPLOSÃO DE FAÍSCAS AO MORRER!
        // ===================================================
        if (death_timer >= 30) {
            
            // Repete o código 15 vezes para soltar 15 faíscas pra todo lado
            repeat (15) {
                var _fx = x + random_range(-15, 15);
                var _fy = y + random_range(-15, 15);
                
                // Cria a faísca verde nativa do GameMaker
                effect_create_above(ef_spark, _fx, _fy, 1, c_lime);
            }
            
            // Cria um "anel" de energia verde de impacto
            effect_create_above(ef_ring, x, y, 0, c_green);
            
            instance_destroy(); // Deleta o inseto
        }
        break;
}

// =========================================================
// 3. DETECÇÃO DE BORDAS ("O CHÃO ACABA") E PAREDES
// =========================================================
// Vê se há uma parede logo à frente
var _parede_frente = place_meeting(x + (dir * 2), y, obj_chao) || 
                     place_meeting(x + (dir * 2), y, obj_ponta) || 
                     place_meeting(x + (dir * 2), y, obj_teleporter);

// Vê se NÃO há chão logo à frente e abaixo (para não cair de quinas)
// Calculamos a borda da caixa de colisão para olhar um pouco à frente
var _bbox_edge = (dir == 1) ? bbox_right : bbox_left;
var _chao_frente = position_meeting(_bbox_edge + (dir * 8), bbox_bottom + 4, obj_chao) ||
                   position_meeting(_bbox_edge + (dir * 8), bbox_bottom + 4, obj_ponta) ||
                   position_meeting(_bbox_edge + (dir * 8), bbox_bottom + 4, obj_teleporter);

// Se bateu na parede OU o chão da frente acabou:
if (_parede_frente || !_chao_frente) {
    hspd = 0; // Para imediatamente
    
    // Se estava apenas patrulhando, vira pro outro lado
    if (state == "WANDER") {
        dir *= -1; 
    }
    // Obs: Se estiver no estado "CHASE", ele apenas vai parar na beirada, 
    // rosnando/olhando para o player sem se jogar no buraco.
}

// =========================================================
// 4. COLISÃO E MOVIMENTO (MESMA LÓGICA DO SEU OBJ_BIT)
// =========================================================
// Horizontal
if (place_meeting(x + hspd, y, obj_chao) || place_meeting(x + hspd, y, obj_ponta) || place_meeting(x + hspd, y, obj_teleporter)) {
    while (!place_meeting(x + sign(hspd), y, obj_chao) && !place_meeting(x + sign(hspd), y, obj_ponta) && !place_meeting(x + sign(hspd), y, obj_teleporter)) {
        x += sign(hspd);
    }
    hspd = 0;
}
x += hspd;

// Vertical
if (place_meeting(x, y + vspd, obj_chao) || place_meeting(x, y + vspd, obj_ponta) || place_meeting(x, y + vspd, obj_teleporter)) {
    while (!place_meeting(x, y + sign(vspd), obj_chao) && !place_meeting(x, y + sign(vspd), obj_ponta) && !place_meeting(x, y + sign(vspd), obj_teleporter)) {
        y += sign(vspd);
    }
    vspd = 0;
}
y += vspd;

// =========================================================
// 5. ANIMAÇÃO (Espelhar Sprite)
// =========================================================
if (hspd != 0) {
    image_xscale = dir; // Vira o inseto para a esquerda ou direita
}