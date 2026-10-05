local _, ns = ...

-- English is the base table; other locales only override what they translate.
local L = {
    TITLE = "Target In Combat",
    LOADED = "loaded. Type /tic for options.",

    OPT_DISPLAY = "Display",
    OPT_NAMEPLATES = "Show on nameplates",
    OPT_NAMEPLATES_TT = "Adds the icon to the left of each nameplate.",
    OPT_TARGET = "Show next to the target portrait",
    OPT_TARGET_TT = "Adds the icon on the ring of the target portrait.",
    OPT_SELF = "Show when targeting yourself",
    OPT_SELF_TT = "Target yourself to see the icon on the target portrait while you set its size and position: red swords in combat, Zzz out of combat.",
    OPT_ICON_SIZE = "Icon size",
    OPT_TARGET_ANGLE = "Position around the target portrait",
    OPT_TARGET_ANGLE_TT = "Moves the icon around the round portrait. 0 is the top, 90 the right, 180 the bottom, 270 the left.",

    OPT_ROUND_TARGET = "Rounded corners on the target portrait icon",
    OPT_ROUND_PLATES = "Rounded corners on nameplate icons",
    OPT_ROUND_TT = "Rounds the corners of the Sap icon and its timer, like the aura icons on nameplates.",

    OPT_UNITS = "Units",
    OPT_ENEMY_PLAYERS = "Enemy players",
    OPT_ENEMY_NPCS = "Enemy NPCs",
    OPT_FRIENDLY = "Friendly units",
    OPT_OUT_OF_COMBAT = "Also show units out of combat",
    OPT_OUT_OF_COMBAT_TT = "Shows a Zzz icon on units out of combat instead of nothing.",

    OPT_ROGUE = "Rogue",
    OPT_SAP = "Sap mode",
    OPT_SAP_TT = "On hostile units out of combat, replaces the combat icon with the Sap icon:\n|cff40ff40colored|r: you can Sap it now\n|cff999999grey|r: sappable, but out of range or you are not stealthed\n|cffff4040red X|r: cannot be sapped (not humanoid, shapeshifted or immune)",
    OPT_SAP_NOT_ROGUE = "Only used on a rogue who knows Sap.",
}

local locales = {
    frFR = {
        LOADED = "chargé. Tapez /tic pour les options.",

        OPT_DISPLAY = "Affichage",
        OPT_NAMEPLATES = "Afficher sur les barres de nom",
        OPT_NAMEPLATES_TT = "Ajoute l'icône à gauche de chaque barre de nom.",
        OPT_TARGET = "Afficher à côté du portrait de la cible",
        OPT_TARGET_TT = "Ajoute l'icône sur le contour du portrait de la cible.",
        OPT_SELF = "Afficher quand vous vous ciblez",
        OPT_SELF_TT = "Ciblez-vous pour voir l'icône sur le portrait de la cible pendant que vous réglez sa taille et sa position : épées rouges en combat, Zzz hors combat.",
        OPT_ICON_SIZE = "Taille de l'icône",
        OPT_TARGET_ANGLE = "Position autour du portrait de la cible",
        OPT_TARGET_ANGLE_TT = "Fait tourner l'icône autour du portrait rond. 0 en haut, 90 à droite, 180 en bas, 270 à gauche.",

        OPT_ROUND_TARGET = "Coins arrondis sur l'icône du portrait de la cible",
        OPT_ROUND_PLATES = "Coins arrondis sur les icônes des barres de nom",
        OPT_ROUND_TT = "Arrondit les coins de l'icône d'Assommer et de son minuteur, comme les icônes d'auras des barres de nom.",

        OPT_UNITS = "Unités",
        OPT_ENEMY_PLAYERS = "Joueurs ennemis",
        OPT_ENEMY_NPCS = "PNJ ennemis",
        OPT_FRIENDLY = "Unités amicales",
        OPT_OUT_OF_COMBAT = "Afficher aussi les unités hors combat",
        OPT_OUT_OF_COMBAT_TT = "Affiche une icône Zzz sur les unités hors combat au lieu de rien.",

        OPT_ROGUE = "Voleur",
        OPT_SAP = "Mode Assommer",
        OPT_SAP_TT = "Sur les unités hostiles hors combat, remplace l'icône de combat par celle d'Assommer :\n|cff40ff40en couleur|r : vous pouvez l'assommer maintenant\n|cff999999grise|r : assommable, mais hors de portée ou vous n'êtes pas camouflé\n|cffff4040X rouge|r : impossible à assommer (pas humanoïde, en forme ou insensible)",
        OPT_SAP_NOT_ROGUE = "Ne sert qu'à un voleur qui connaît Assommer.",
    },
}

local override = locales[GetLocale()]
if override then
    for key, text in pairs(override) do
        L[key] = text
    end
end

ns.L = L
