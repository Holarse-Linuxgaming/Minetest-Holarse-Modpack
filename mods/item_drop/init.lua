    minetest.register_globalstep(function(dtime)
       for _,player in ipairs(minetest.get_connected_players()) do
          if player:get_hp() > 0 or not minetest.setting_getbool("enable_damage") then
             local pos = player:getpos()
             pos.y = pos.y+0.5
             local inv = player:get_inventory()
             local ctrl = player:get_player_control()
             if ctrl.up or ctrl.left or ctrl.right then

                for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 2)) do
                   local en = object:get_luaentity()
                   if not object:is_player() and en and en.name == "__builtin:item" then
                      if inv and
                         inv:room_for_item("main", ItemStack(en.itemstring)) then
                         inv:add_item("main", ItemStack(en.itemstring))
                         if en.itemstring ~= "" then
                            minetest.sound_play("item_drop_pickup", {
                               to_player = player:get_player_name(),
                               gain = 0.4,
                            })
                         end
                         en.itemstring = ""
                         object:remove()
                      end
                   end
                end

             end
          end
       end
    end)
