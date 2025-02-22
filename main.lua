SMODS.Atlas{
    key = 'Jokers',
    path = 'Jokers.png',
    px = 71,
    py = 95
}

SMODS.Joker{



    key = 'firejoker',
    loc_txt = {

        name = 'Blazing Joker',
        text = {
            'When{C:attention} Blind{} is selected, destroy Joker',
            'to the right and add {X:mult,C:white}X0.1{} Mult',
            'per {C:money}$1 {}of its sell value',
            '{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive}; loses{} {X:mult,C:white}X0.5{} {C:inactive}Mult{}',
            '{C:inactive}per round played){}',
        

        }
    },
    atlas = 'Jokers',
    pos = {x= 0, y = 0},

    config = { extra = {
        Xmult = 3
    }
    },

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult}}
    end,

    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,

    calculate = function(self,card,context)
        
        if context.setting_blind then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end

            if my_pos and G.jokers.cards[my_pos+1] and not card.getting_sliced and not G.jokers.cards[my_pos+1].ability.eternal and not G.jokers.cards[my_pos+1].getting_sliced then 
                -- I copied the code from Ceremonial Dagger
                local sliced_card = G.jokers.cards[my_pos+1]
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    card.ability.extra.Xmult = card.ability.extra.Xmult + (sliced_card.sell_cost * 0.1)
                    card:juice_up(0.8, 0.8)
                    sliced_card:start_dissolve({HEX("f77205")}, nil, 1.6)
                    play_sound('slice1', 0.96+math.random()*0.08)
                return true end }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.Xmult+ (sliced_card.sell_cost * 0.1)}}, colour = G.C.RED, no_juice = true})
            end
        end

        
        if context.joker_main then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult .. ' Mult',
                colour = G.C.MULT,
            }
        end

        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            card.ability.extra.Xmult = card.ability.extra.Xmult - 0.5

            if card.ability.extra.Xmult <= 1 then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				return {
					message = 'Extinguished!'
				}
			else
				return {
					message = '-0.5X Mult',
                    colour = G.C.MULT,
				}
				
			end
        end 
    end


}

SMODS.Joker{

    key = 'icejoker',
    loc_txt = {

        name = 'Frozen Joker',
        text = {
            'Freezes the state',
            'of the {C:attention}Joker{} to the right'

        }
    },
    atlas = 'Jokers',
    pos = {x= 1, y = 0}
}