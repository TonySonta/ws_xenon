ESX 		= nil
PlayerData 	= {}
ColorOrigineXenom = nil
NeonAvantAchat = {}
ColorNeonAvantAchat = {}

identityXenon = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end) 


function recupcoloropen(ColorOrigine,NeonBackActived)
    ESX.TriggerServerCallback('ws:XenonCheckVehicle', function(ColorOrigine,NeonBackActived,NeonColorOrigine)
        ColorAvantAchat = ColorOrigine
        NeonAvantAchat = NeonBackActived
        ColorNeonAvantAchat = NeonColorOrigine
        CheckNeonBox()
    
        
    end, ColorOrigine,NeonBackActived,NeonColorOrigine)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end


Citizen.CreateThread(function()
    while true do
        local interval = 600
                local pos = GetEntityCoords(GetPlayerPed(-1), false)
                CoordPos = ConfXenom.location
                local distance = Vdist(pos.x, pos.y, pos.z,CoordPos)
                local ped = PlayerPedId()
                local vehicleXenom = GetVehiclePedIsUsing(ped)

            
                if ESX.PlayerData.job and ESX.PlayerData.job.name == "mechanic" then 
                    if distance > 6 then 
                        interval = 2000
                    else 
                        interval = 1
                        
                        
                        if distance < 3 then
                            DrawMarker(27, CoordPos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 15, 141, 246, 255, 0, 1, 2, 0, nil, nil, 0)
                            ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour obtenir un ~b~custom de phare", true, false, true)
                            
                            if IsControlJustPressed(1, 51) then
                            
                                if IsPedInAnyVehicle(ped, true) then
                                    OldStatVeh = ESX.Game.GetVehicleProperties(vehicleXenom)
                                    recupcoloropen(OldStatVeh)
                                    TriggerEvent('ws:chechMenuXenom')
                                    FreezeCustom()
                                else
                                    ESX.ShowNotification('Vous n\'êtes pas dans un véhicule', true, false, 120)
                                end                        
                            end
                        end
                end
            end
        Citizen.Wait(interval)
    end
end)

local CompteSocietyMechanic = nil
local OpenMenuCustomXenom = false
local MenuXenomPrincipal = RageUI.CreateMenu(nil, "~r~M~w~onkey's ~r~C~w~ustom", nil, nil, "root_cause", "xenon_shop")
-- XENON
local MenuCustomXenom = RageUI.CreateSubMenu(MenuXenomPrincipal, nil, "Customisez vos xenon")
local SousMenuPurshase = RageUI.CreateSubMenu(MenuXenomPrincipal, nil, "Confirmation")
local SousMenuBilling = RageUI.CreateSubMenu(MenuXenomPrincipal, nil, "Facturation")
-- NEON
local MenuCustomNeon = RageUI.CreateSubMenu(MenuXenomPrincipal, nil, "Customisez vos néon")
local GroupIndex = 1

MenuXenomPrincipal.Display.Header = true
MenuXenomPrincipal.Closed = function() 
    OpenMenuCustomXenom = false
    local ped = PlayerPedId()
    local vehicleXenom = GetVehiclePedIsUsing(ped)
    Unfreeze()
    ToggleVehicleMod(vehicleXenom, 22, true) -- Xenon
    SetVehicleXenonLightsColour(vehicleXenom, ColorAvantAchat)
end

MenuCustomNeon.Closed = function() 
    local ped = PlayerPedId()
    local vehicleXenom = GetVehiclePedIsUsing(ped)

    -- droite
    if NeonAvantAchat[2] ~= NewAchatDroiteNeon then
        if NeonAvantAchat[2] == 1 then
            SetVehicleNeonLightEnabled(vehicleXenom, 1, true)
        else
            SetVehicleNeonLightEnabled(vehicleXenom, 1, false)
        end
    end
 -- gauche
    if NeonAvantAchat[1] ~= NewAchatGaucheNeon then
        if NeonAvantAchat[1] == 1 then
            SetVehicleNeonLightEnabled(vehicleXenom, 0, true)
        else
            SetVehicleNeonLightEnabled(vehicleXenom, 0, false)
        end
    end
 -- avant
    if NeonAvantAchat[3] ~= NewAchatAvantNeon then
        if NeonAvantAchat[3] == 1 then
            SetVehicleNeonLightEnabled(vehicleXenom, 2, true)
        else
            SetVehicleNeonLightEnabled(vehicleXenom, 2, false)
        end
    end
    
    if NeonAvantAchat[4] ~= NewAchatNeon then
        if NeonAvantAchat[4] == 1 then
            SetVehicleNeonLightEnabled(vehicleXenom, 3, true)
        else
            SetVehicleNeonLightEnabled(vehicleXenom, 3, false)
        end
    end

    if ColorNeonAvantAchat ~= NewColorAchatNeon then
        SetVehicleNeonLightsColour(vehicleXenom, ColorNeonAvantAchat[1], ColorNeonAvantAchat[2], ColorNeonAvantAchat[3])
    end

end


IndexCustom = {IndexMenuNeon = 1}

function OpenMenuXenom() 
    if OpenMenuCustomXenom then 
        OpenMenuCustomXenom = false
        RageUI.Visible(MenuXenomPrincipal, false)
        return
    else
            if ESX.PlayerData.job and ESX.PlayerData.job.name == ConfXenom.JobOnly then

        
                RageUI.Visible(MenuXenomPrincipal, true)
                
                CreateThread(function()
                    local cooldown = false

                    while OpenMenuCustomXenom do 

                        RageUI.IsVisible(MenuXenomPrincipal, function()


                            RefreshSocietXenonCustomMoney()

                            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                                --Unfreeze()
                                RageUI.Button("~r~ Retourner dans votre véhicule !!!", "Vous risquez de freeze votre voiture !", {}, not cooldown, {
                                    onActive = function()
                            
                                    end
                                })

                            else
                                
                                if CompteSocietyMechanic ~= nil then
                                    RageUI.Separator("Argent de la société: ~g~"..CompteSocietyMechanic.."$")
                                end
                            
                    
                                    RageUI.Button("Customisez vos xénons", nil, {RightLabel = "~b~>>~w~"}, true, {
                                        onSelected = function()
                                        end
                                    }, MenuCustomXenom)

                                    RageUI.Button("Customisez vos néon", nil, {RightLabel = "~b~>>~w~"}, true, {
                                        onSelected = function()
                                            CheckFinalBox()
                                        end
                                    }, MenuCustomNeon)
                        


                            end
                            
                            
                    
                        end)

                        --------------- XENON-------------------------------

                        RageUI.IsVisible(MenuCustomXenom, function()

                            RefreshSocietXenonCustomMoney()

                            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                                --Unfreeze()
                                RageUI.Button("~r~ Retourner dans votre véhicule !!!", "Vous risquez de freeze votre voiture !", {}, not cooldown, {
                                    onActive = function()
                            
                                    end
                                })

                            else


                                if CompteSocietyMechanic ~= nil then
                                    RageUI.Separator("Argent de la société: ~g~"..CompteSocietyMechanic.."$")
                                end
    
                                RageUI.Separator("↓ Liste des couleurs ↓")
                            
                               
                                for k,v in pairs(ConfXenom.List) do
                                    RageUI.Button(v.NameCouleur, nil, {RightLabel = "~g~"..v.price.."$"}, not cooldown, {
                                        onActive = function()
                                            local veh = GetVehiclePedIsUsing(PlayerPedId())
                                            ToggleVehicleMod(veh, 22, true) -- Xenon
                                            SetVehicleXenonLightsColour(veh, v.SetNumberColor)
                                            CheckChoiseMenu(v.price, v.NameCouleur, v.SetNumberColor)
                                        end
                                    }, SousMenuPurshase)
                                end


                            end
                            
                            
                    
                        end)

                        RageUI.IsVisible(SousMenuPurshase, function()

                            RefreshSocietXenonCustomMoney()

                            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                                RageUI.Button("~r~ Retourner dans votre véhicule !!!", "Vous risquez de freeze votre voiture !", {}, not cooldown, {
                                    onActive = function()
                            
                                    end
                                })

                            else

                            target = ESX.Game.GetClosestPlayer()
                            
                            if CompteSocietyMechanic ~= nil then
                                RageUI.Separator("Argent de la société: ~g~"..CompteSocietyMechanic.."$")
                            end

                            RageUI.Separator("Confirmez la couleur : "..NameFinal)

                            if CompteSocietyMechanic >= ValeurDuChoix then
                        
                                RageUI.Button("Oui", nil, {RightLabel = "~g~"..ValeurDuChoix.."$"}, not cooldown, {
                                        onSelected = function()
                                        TriggerServerEvent('ws:paiementXenonMechanicJob', ValeurDuChoix)
                                        TriggerEvent('ws:InstalleXenom')
                                        getInformations(target)
                                        ColorAvantAchat = NumChange
                                    end
                                }, SousMenuBilling)
                            else
                                RageUI.Button("Oui", "Pas assez d\'argent dans le compte d\'entreprise", {RightLabel = "~g~"..ValeurDuChoix.."$"}, cooldown, {
                                    onSelected = function()
                                    end
                                })
                            end

                            RageUI.Button("Non", nil, {}, not cooldown, {
                                onSelected = function()
                                    Unfreeze()
                                    RageUI.CloseAll()
                                    OpenMenuCustomXenom = false
                                end
                            })
                        end
                        end)

------- SOUS MENU FACTURATION CLIENT EN COUR 

                        RageUI.IsVisible(SousMenuBilling, function()
                            							
                            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                                RageUI.Button("~r~ Retourner dans votre véhicule !!!", "Vous risquez de freeze votre voiture !", {}, not cooldown, {
                                    onActive = function()
                            
                                    end
                                })

                            else
								
							local ped = GetPlayerPed(ESX.Game.GetClosestPlayer())
							local pos = GetEntityCoords(ped)
							target, distance = ESX.Game.GetClosestPlayer()
                            taxeXenon = ConfXenom.taxeEntreprise
                            resultXenon = ValeurDuChoix + taxeXenon

                            if distance <= 4.0 then
                                getInformations(target)
                            else
                                InfoStat = false
                                proximiterPed = false
                            end
                                
                            if proximiterPed then
                                GetPedProximiter()
                            end

                            if InfoStat and proximiterPed then
                                RageUI.Separator("Souhaitez vous facturez : ~b~"..identityXenon.firstname.." "..identityXenon.lastname)
                                cadenaxenon = true
                            else
                                RageUI.Separator("Personne à proximiter")
                                cadenaxenon = false
                            end

                            RageUI.Separator("Coût entreprise: ~g~"..ValeurDuChoix.."$")
                            RageUI.Separator("Taxe: ~r~"..taxeXenon.."$")
                            RageUI.Separator("Coût Client: ~y~"..resultXenon.."$")

                        
                            RageUI.Button("Oui", nil, {RightLabel = "~g~"..resultXenon.."$"}, cadenaxenon, {
                                onSelected = function()
                                    
									    if distance <= 4.0 then
										    TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(target), 'society_mechanic', ('mechanic'), resultXenon)
										    ESX.ShowNotification('Vous avez bien envoyez la facture.', true, false, 120)
                                            Unfreeze()
                                            RageUI.CloseAll()
                                            OpenMenuCustomXenom = false
									    else
										    ESX.ShowNotification('Personne à proximiter.', true, false, 120)
									    end
								end
                            })

                            RageUI.Button("Non", nil, {}, not cooldown, {
                                onSelected = function()
                                    Unfreeze()
                                    RageUI.CloseAll()
                                    OpenMenuCustomXenom = false
                                end
                            })
                        end
                        end)

                        -------- NEON ----------------------

                        RageUI.IsVisible(MenuCustomNeon, function()

                            RefreshSocietXenonCustomMoney()
                            
                            
                            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                                RageUI.Button("~r~ Retourner dans votre véhicule !!!", "Vous risquez de freeze votre voiture !", {}, not cooldown, {
                                    onActive = function()
                            
                                    end
                                })

                            else
                            
                            if CompteSocietyMechanic ~= nil then
                                RageUI.Separator("Argent de la société: ~g~"..CompteSocietyMechanic.."$")
                            end

                            ----------------- CHECHBOX ----------------------
                            RageUI.Checkbox("Néon Gauche", nil, NeonGaucheFinalBox, {}, {
                                onChecked = function()
                                    local ped = PlayerPedId()
                                    local veh = GetVehiclePedIsIn(ped, true)
                                    SetVehicleNeonLightEnabled(veh, 0, true)
                                    NewAchatGaucheNeon = 1
                                end,
                                onUnChecked = function()
                                    local veh = GetVehiclePedIsUsing(PlayerPedId())
                                    SetVehicleNeonLightEnabled(veh, 0, false)
                                    NewAchatGaucheNeon = false
                                end,
                                onSelected = function(Index)
                                    NeonGaucheFinalBox = Index
                                end
                            })

                            RageUI.Checkbox("Néon Droite", nil, NeonDroiteFinalBox, {}, {
                                onChecked = function()
                                    local ped = PlayerPedId()
                                    local veh = GetVehiclePedIsIn(ped, true)
                                    SetVehicleNeonLightEnabled(veh, 1, true)
                                    NewAchatDroiteNeon = 1
                                end,
                                onUnChecked = function()
                                    local veh = GetVehiclePedIsUsing(PlayerPedId())
                                    SetVehicleNeonLightEnabled(veh, 1, false)
                                    NewAchatDroiteNeon = false
                                end,
                                onSelected = function(Index)
                                    NeonDroiteFinalBox = Index
                                end
                            })
                            ------

                            RageUI.Checkbox("Néon Avant", nil, LightNeonValid, {}, {
                                onChecked = function()
                                    local ped = PlayerPedId()
                                    local veh = GetVehiclePedIsIn(ped, true)
                                    SetVehicleNeonLightEnabled(veh, 2, true)
                                    NewAchatAvantNeon = 1
                                end,
                                onUnChecked = function()
                                    local veh = GetVehiclePedIsUsing(PlayerPedId())
                                    SetVehicleNeonLightEnabled(veh, 2, false)
                                    NewAchatAvantNeon = false
                                end,
                                onSelected = function(Index)
                                    LightNeonValid = Index
                                end
                            })
                            ----


                            RageUI.Checkbox("Néon Arrière", nil, NeonFinalbox, {}, {
                                onChecked = function()
                                    local ped = PlayerPedId()
                                    local veh = GetVehiclePedIsIn(ped, true)
                                    SetVehicleNeonLightEnabled(veh, 3, true)
                                    NewAchatNeon = 1
                                end,
                                onUnChecked = function()
                                    local veh = GetVehiclePedIsUsing(PlayerPedId())
                                    SetVehicleNeonLightEnabled(veh, 3, false)
                                    NewAchatNeon = false
                                end,
                                onSelected = function(Index)
                                    NeonFinalbox = Index
                                end
                            })

                            ----------------- LISTE -----------------------------

                            RageUI.List("Couleur", ConfXenom.Neon, IndexCustom.IndexMenuNeon, nil, {}, true, {
                                onListChange = function(Index, Item)
                                    IndexCustom.IndexMenuNeon = Index
                                end,
                                onSelected = function(Index, Item)
                                    local veh = GetVehiclePedIsUsing(PlayerPedId())
                                    SetVehicleNeonLightsColour(veh, Item.Value.r,Item.Value.g,Item.Value.b)
                                end,
                            })

                            RageUI.Button("Couleur Personnalisée", nil, {RightLabel = "~b~>>~w~"}, not cooldown, {
                                onSelected = function()
                                    local colorR = KeyboardInput("R", '255' , 3)
                                    
                                    local colorG = KeyboardInput("G", '0' , 3)
                                    
                                    local colorG = KeyboardInput("G", '255' , 3)
                                    
                                    local ped = PlayerPedId()
                                    local veh = GetVehiclePedIsIn(ped, true)

                                    SetVehicleNeonLightsColour(veh, colorR, colorG, colorB)
                                end
                            })

                            RageUI.Button("Valider", nil, {}, not cooldown, {
                                onSelected = function()
                                    NeonAvantAchat[4] = NewAchatNeon
                                    ColorNeonAvantAchat = NewColorAchatNeon
                                    TriggerEvent('ws:InstalleXenom')
                                    Unfreeze()
                                    RageUI.CloseAll()
                                    OpenMenuCustomXenom = false
                                end
                            })

                        end
                        end)

                        Citizen.Wait(0)
                    end
                end)
            end
        OpenMenuCustomXenom = true
    end
end



RegisterNetEvent('ws:chechMenuXenom')
AddEventHandler('ws:chechMenuXenom', function()
    OpenMenuXenom()
end)

RegisterNetEvent('ws:InstalleXenom')
AddEventHandler('ws:InstalleXenom', function()
    local vehicleXenom = GetVehiclePedIsIn(PlayerPedId(), false)
	VehicleIdentifier = ESX.Game.GetVehicleProperties(vehicleXenom)
    TriggerServerEvent('ws:validechangexenom', VehicleIdentifier)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if OpenMenuCustomXenom then
			DisableControlAction(2, 288, true)
			DisableControlAction(2, 289, true)
			DisableControlAction(2, 170, true)
			DisableControlAction(2, 167, true)
			DisableControlAction(2, 168, true)
			DisableControlAction(2, 23, true)
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

function RefreshSocietXenonCustomMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name ~= nil then
       NameOfSocietyMechanic = "society_mechanic"
        ESX.TriggerServerCallback('ws:getSocietyMoney', function(money)
            CompteSocietyMechanic = money
        end, NameOfSocietyMechanic)
    end
end
function recupcoloropen(ColorOrigine,NeonBackActived)
    ESX.TriggerServerCallback('ws:XenonCheckVehicle', function(ColorOrigine,NeonBackActived,NeonColorOrigine)
        ColorAvantAchat = ColorOrigine
        NeonAvantAchat = NeonBackActived
        ColorNeonAvantAchat = NeonColorOrigine
        CheckNeonBox()
        
    end, ColorOrigine,NeonBackActived,NeonColorOrigine)

           

end


function CheckChoiseMenu(priceChoise, nameChoise, valuechoise)
    ValeurDuChoix = priceChoise
    NameFinal = nameChoise
    NumChange = valuechoise
end


function CheckNeonBox()
    

    if NeonAvantAchat[4] == 1 then 
        NeonBox = true
    else 
        NeonBox = false
    end

    if NeonAvantAchat[3] == 1 then 
        FrontLightNeon = true
    else 
        FrontLightNeon = false
    end

    if NeonAvantAchat[2] == 1 then 
        NeonDroiteBox = true
    else 
        NeonDroiteBox = false
    end

    if NeonAvantAchat[1] == 1 then 
        NeonGaucheBox = true
    else 
        NeonGaucheBox = false
    end

end

function CheckFinalBox()
    if NeonBox then 
        NeonFinalbox = true
    else
        NeonFinalbox = false
    end

    if FrontLightNeon then
        LightNeonValid = true
    else
        LightNeonValid = false
    end

    if NeonGaucheBox then
        NeonGaucheFinalBox = true
    else
        NeonGaucheFinalBox = false
    end

    if NeonDroiteBox then
        NeonDroiteFinalBox = true
    else
        NeonDroiteFinalBox = false
    end

end


function Unfreeze()
    local ped = PlayerPedId()
    local vehicleXenom = GetVehiclePedIsUsing(ped)
    FreezeEntityPosition(vehicleXenom, false)
    SetVehicleDoorShut(vehicleXenom, 4, true)
end

function FreezeCustom()
    local ped = PlayerPedId()
    local vehicleXenom = GetVehiclePedIsUsing(ped)
    FreezeEntityPosition(vehicleXenom, true)
    SetVehicleDoorOpen(vehicleXenom, 4, false, true)
end

function GetPedProximiter()
	local ped = GetPlayerPed(ESX.Game.GetClosestPlayer())
	local pos = GetEntityCoords(ped)
	local target, distance = ESX.Game.GetClosestPlayer()
	if distance <= 4.0 then
	DrawMarker(22, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, 0, 1, 2, 1, nil, nil, 0)
	end
end

function getInformations(player)
    local target, distance = ESX.Game.GetClosestPlayer()
    if distance <=4.0 then 
    ESX.TriggerServerCallback('xenon:getOtherPlayerData', function(data)
        identityXenon = data

        if identityXenon ~= nil then 
            InfoStat = true
            proximiterPed = true
        else
            infoStat = false
        end


    end, GetPlayerServerId(player))
    end
end

RegisterNetEvent('ws:testCheckRien')
AddEventHandler('ws:testCheckRien', function()
    proximiterPed = false
end)


