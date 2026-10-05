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

    OPT_CORNER_TARGET = "Corner rounding, target portrait",
    OPT_CORNER_PLATES = "Corner rounding, nameplates",
    OPT_CORNER_TT = "Rounds the corners of the Sap icon and its timer. 0% is square, 100% is a circle.",

    OPT_UNITS = "Units",
    OPT_ENEMY_PLAYERS = "Enemy players",
    OPT_ENEMY_NPCS = "Enemy NPCs",
    OPT_FRIENDLY = "Friendly units",
    OPT_OUT_OF_COMBAT = "Out of combat icon",
    OPT_OUT_OF_COMBAT_TT = "What units out of combat show. Nothing keeps the display light: no icon then means out of combat.",
    OOC_NONE = "Nothing",
    OOC_ZZZ = "Zzz",
    OOC_SWORDS = "Grey swords",

    OPT_ROGUE = "Rogue",
    OPT_SAP = "Sap mode",
    OPT_SAP_TT = "On hostile units out of combat, replaces the combat icon with the Sap icon:\n|cff40ff40colored|r: you can Sap it now\n|cff999999grey|r: sappable, but out of range or you are not stealthed\n|cffff4040red X|r: cannot be sapped (not humanoid, shapeshifted or immune)",
    OPT_SAP_NOT_ROGUE = "Only used on a rogue who knows Sap.",

    OPT_SIM = "Simulation",
    OPT_SIM_ENABLE = "Simulate on my current target",
    OPT_SIM_ENABLE_TT = "Shows the chosen look on your current target only, on its nameplate and its portrait, to preview every icon while you set the addon up. Target yourself (with \"Show when targeting yourself\") or any unit. Turned off again at each /reload.",
    OPT_SIM_COMBAT = "Combat",
    OPT_SIM_COMBAT_TT = "In combat always wins: the Sap choice only applies out of combat.",
    SIM_OUT_OF_COMBAT = "Out of combat",
    SIM_IN_COMBAT = "In combat",
    OPT_SIM_SAP = "Sap",
    OPT_SIM_SAP_TT = "Sapped runs a 10 second timer that starts over forever.",
    SIM_SAP_NONE = "No Sap icon",
    SIM_SAP_NO = "Not sappable",
    SIM_SAP_READY = "Sappable",
    SIM_SAP_SAPPED = "Sapped",
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

        OPT_CORNER_TARGET = "Arrondi des coins, portrait de la cible",
        OPT_CORNER_PLATES = "Arrondi des coins, barres de nom",
        OPT_CORNER_TT = "Arrondit les coins de l'icône d'Assommer et de son minuteur. 0 % = carré, 100 % = cercle.",

        OPT_UNITS = "Unités",
        OPT_ENEMY_PLAYERS = "Joueurs ennemis",
        OPT_ENEMY_NPCS = "PNJ ennemis",
        OPT_FRIENDLY = "Unités amicales",
        OPT_OUT_OF_COMBAT = "Icône hors combat",
        OPT_OUT_OF_COMBAT_TT = "Ce qu'affichent les unités hors combat. Rien garde l'affichage léger : pas d'icône veut alors dire hors combat.",
        OOC_NONE = "Rien",
        OOC_ZZZ = "Zzz",
        OOC_SWORDS = "Épées grises",

        OPT_ROGUE = "Voleur",
        OPT_SAP = "Mode Assommer",
        OPT_SAP_TT = "Sur les unités hostiles hors combat, remplace l'icône de combat par celle d'Assommer :\n|cff40ff40en couleur|r : vous pouvez l'assommer maintenant\n|cff999999grise|r : assommable, mais hors de portée ou vous n'êtes pas camouflé\n|cffff4040X rouge|r : impossible à assommer (pas humanoïde, en forme ou insensible)",
        OPT_SAP_NOT_ROGUE = "Ne sert qu'à un voleur qui connaît Assommer.",

        OPT_SIM = "Simulation",
        OPT_SIM_ENABLE = "Simuler sur ma cible actuelle",
        OPT_SIM_ENABLE_TT = "Affiche l'apparence choisie sur votre cible actuelle uniquement, sur sa barre de nom et son portrait, pour voir chaque icône pendant les réglages. Ciblez-vous (avec « Afficher quand vous vous ciblez ») ou n'importe quelle unité. Désactivé à chaque /reload.",
        OPT_SIM_COMBAT = "Combat",
        OPT_SIM_COMBAT_TT = "En combat l'emporte toujours : le choix d'Assommer ne s'applique que hors combat.",
        SIM_OUT_OF_COMBAT = "Hors combat",
        SIM_IN_COMBAT = "En combat",
        OPT_SIM_SAP = "Assommer",
        OPT_SIM_SAP_TT = "Assommé lance un minuteur de 10 secondes qui recommence à l'infini.",
        SIM_SAP_NONE = "Pas d'icône d'Assommer",
        SIM_SAP_NO = "Pas assommable",
        SIM_SAP_READY = "Assommable",
        SIM_SAP_SAPPED = "Assommé",
    },
}

local override = locales[GetLocale()]
if override then
    for key, text in pairs(override) do
        L[key] = text
    end
end

ns.L = L
