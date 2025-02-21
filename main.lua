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