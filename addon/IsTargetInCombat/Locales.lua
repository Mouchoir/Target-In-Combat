local _, ns = ...

-- English is the base table; other locales only override what they translate.
local L = {
    TITLE = "Is Target In Combat",
    LOADED = "loaded. Type /itic for options.",

    OPT_DISPLAY = "Display",
    OPT_NAMEPLATES = "Show on nameplates",
    OPT_NAMEPLATES_TT = "Adds the icon to the right of each nameplate.",
    OPT_TARGET = "Show next to the target portrait",
    OPT_TARGET_TT = "Adds the icon on the top left of the target portrait.",
    OPT_ICON_SIZE = "Icon size",

    OPT_UNITS = "Units",
    OPT_ENEMY_PLAYERS = "Enemy players",
    OPT_ENEMY_NPCS = "Enemy NPCs",
    OPT_FRIENDLY = "Friendly units",
    OPT_OUT_OF_COMBAT = "Also show units out of combat",
    OPT_OUT_OF_COMBAT_TT = "Shows a faded icon on units out of combat instead of nothing.",

    OPT_ROGUE = "Rogue",
    OPT_SAP = "Sap mode",
    OPT_SAP_TT = "On hostile units out of combat, replaces the combat icon with the Sap icon:\n|cff40ff40colored|r: you can Sap it now\n|cff999999grey|r: sappable, but out of range or you are not stealthed\n|cffff4040red|r: cannot be sapped (not humanoid, shapeshifted or immune)",
    OPT_SAP_NOT_ROGUE = "Only used on a rogue who knows Sap.",
}

local locales = {
    frFR = {
        LOADED = "chargé. Tapez /itic pour les options.",

        OPT_DISPLAY = "Affichage",
        OPT_NAMEPLATES = "Afficher sur les barres de nom",
        OPT_NAMEPLATES_TT = "Ajoute l'icône à droite de chaque barre de nom.",
        OPT_TARGET = "Afficher à côté du portrait de la cible",
        OPT_TARGET_TT = "Ajoute l'icône en haut à gauche du portrait de la cible.",
        OPT_ICON_SIZE = "Taille de l'icône",

        OPT_UNITS = "Unités",
        OPT_ENEMY_PLAYERS = "Joueurs ennemis",
        OPT_ENEMY_NPCS = "PNJ ennemis",
        OPT_FRIENDLY = "Unités amicales",
        OPT_OUT_OF_COMBAT = "Afficher aussi les unités hors combat",
        OPT_OUT_OF_COMBAT_TT = "Affiche une icône pâle sur les unités hors combat au lieu de rien.",

        OPT_ROGUE = "Voleur",
        OPT_SAP = "Mode Assommer",
        OPT_SAP_TT = "Sur les unités hostiles hors combat, remplace l'icône de combat par celle d'Assommer :\n|cff40ff40en couleur|r : vous pouvez l'assommer maintenant\n|cff999999grise|r : assommable, mais hors de portée ou vous n'êtes pas camouflé\n|cffff4040rouge|r : impossible à assommer (pas humanoïde, en forme ou insensible)",
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
