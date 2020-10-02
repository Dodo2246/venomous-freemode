--[[
            vf_phone
            Copyright (C) 2018-2020  FiveM-Scripts

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program in the file "LICENSE".  If not, see <http://www.gnu.org/licenses/>.
]]

local SelectedItem = 4

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if Phone.Visible and not Phone.InApp then
            for i = 0, 8 do
                BeginScaleformMovieMethod(Phone.Scaleform, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(1)
                ScaleformMovieMethodAddParamInt(i)
                if Apps[i + 1] and Apps[i + 1].Icon then
                    ScaleformMovieMethodAddParamInt(Apps[i + 1].Icon)
                else
                    ScaleformMovieMethodAddParamInt(3)
                end
                EndScaleformMovieMethod()
            end

            BeginScaleformMovieMethod(Phone.Scaleform, "DISPLAY_VIEW")
            ScaleformMovieMethodAddParamInt(1)
            ScaleformMovieMethodAddParamInt(SelectedItem)
            EndScaleformMovieMethod()

            BeginScaleformMovieMethod(Phone.Scaleform, "SET_HEADER")
            if Apps[SelectedItem + 1] and Apps[SelectedItem + 1].Name then
                BeginTextCommandScaleformString("STRING")
                AddTextComponentString(Apps[SelectedItem + 1].Name)
                EndTextCommandScaleformString()
            else
                BeginTextCommandScaleformString("STRING")
                AddTextComponentString("")
                EndTextCommandScaleformString()
            end
            EndScaleformMovieMethod()

            local navigated = true
            if IsControlJustPressed(3, 172) then -- INPUT_CELLPHONE_UP (arrow up)
                SelectedItem = SelectedItem - 3
                if SelectedItem < 0 then
                    SelectedItem = 9 + SelectedItem
                end
            elseif IsControlJustPressed(3, 173) then -- INPUT_CELLPHONE_DOWN (arrow down)
                SelectedItem = SelectedItem + 3
                if SelectedItem > 8 then
                    SelectedItem = SelectedItem - 9
                end
            elseif IsControlJustPressed(3, 175) then -- INPUT_CELLPHONE_RIGHT (arrow right)
                SelectedItem = SelectedItem + 1
                if SelectedItem > 8 then
                    SelectedItem = 0
                end
            elseif IsControlJustPressed(3, 174) then -- INPUT_CELLPHONE_LEFT (arrow left)
                SelectedItem = SelectedItem - 1
                if SelectedItem < 0 then
                    SelectedItem = 8
                end
            else
                if IsControlJustPressed(3, 176) then -- INPUT_CELLPHONE_SELECT (enter / lmb)
                    Wait(0) -- Workaround to next app from registering enter press too
                    Apps.Start(SelectedItem + 1)
                elseif IsControlJustPressed(3, 177) then -- INPUT_CELLPHONE_CANCEL (backspace / esc / rmb)
                    Phone.Kill()
                end
                navigated = false
            end
            if navigated then
                PlaySoundFrontend(-1, "Menu_Navigate", "Phone_SoundSet_Michael")
            end
        end
    end
end)