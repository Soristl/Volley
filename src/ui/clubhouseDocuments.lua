do
(function()
-- Structured text for the existing Clubhouse document frames.
local function documentStrings(key, fr, en, br, pl, ar)
  clubhouse.strings[key] = {fr=fr, en=en, br=br, pl=pl, ar=ar}
end

documentStrings("profile.developer_main", "Développeur (principal)", "Developer (main)", "Desenvolvedor (principal)", "Deweloper (główny)", "مطوّر (رئيسي)")
documentStrings("profile.developer_second", "Développeur (secondaire)", "Developer (secondary)", "Desenvolvedor (secundário)", "Deweloper (drugi)", "مطوّر (ثانوي)")
documentStrings("docs.help.1", "Les premiers échanges", "Your first rally", "Sua primeira troca", "Pierwsza wymiana", "تبادلك الأول")
documentStrings("docs.help.2", "Le lobby et les permissions", "Lobby and permissions", "Lobby e permissões", "Lobby i uprawnienia", "الردهة والصلاحيات")
documentStrings("docs.help.3", "Tes commandes essentielles", "Essential player commands", "Comandos essenciais", "Podstawowe komendy", "أوامر اللاعب الأساسية")
documentStrings("docs.help.4", "Cartes, ballons et couronnes", "Maps, balls and crowns", "Mapas, bolas e coroas", "Mapy, piłki i korony", "الخرائط والكرات والتيجان")
documentStrings("docs.help.5", "Configurer le salon", "Set up the room", "Configure a sala", "Ustawienia pokoju", "إعداد الغرفة")
documentStrings("docs.help.6", "Gérer le temps et le lobby", "Timers and lobby", "Tempo e lobby", "Czas i lobby", "المؤقت والردهة")
documentStrings("docs.help.7", "Terrain, ballon et score", "Court, ball and score", "Quadra, bola e placar", "Boisko, piłka i wynik", "الملعب والكرة والنتيجة")
documentStrings("docs.help.8", "Jouer en équipes", "Team modes", "Modos em equipe", "Tryby drużynowe", "أوضاع الفرق")
documentStrings("docs.help.9", "Personnaliser la partie", "Match options", "Opções da partida", "Opcje meczu", "خيارات المباراة")
documentStrings("docs.help.10", "Force et synchronisation", "Strength and synchronization", "Força e sincronização", "Siła i synchronizacja", "القوة والمزامنة")

documentStrings("docs.objective.title", "Le but du jeu", "The objective", "O objetivo", "Cel gry", "هدف اللعبة")
documentStrings("docs.transform.title", "Espace : renvoyer", "Space: return the ball", "Espaço: devolver", "Spacja: odbij piłkę", "المسافة: أعد الكرة")
documentStrings("docs.join.title", "Rejoindre une équipe", "Join a team", "Entre em uma equipe", "Dołącz do drużyny", "انضم إلى فريق")
documentStrings("docs.shortcuts.title", "P : profil · L : classement", "P: profile · L: ranking", "P: perfil · L: ranking", "P: profil · L: ranking", "P: الملف · L: الترتيب")
documentStrings("docs.creator.title", "Le Room Creator", "The Room Creator", "O Room Creator", "Room Creator", "منشئ الغرفة")
documentStrings("docs.maps.title", "Choisir une carte", "Choose a map", "Escolha um mapa", "Wybierz mapę", "اختر خريطة")
documentStrings("docs.balls.title", "Choisir un ballon", "Choose a ball", "Escolha uma bola", "Wybierz piłkę", "اختر كرة")
documentStrings("docs.permissions.title", "Droits et disponibilité", "Permissions and availability", "Direitos e disponibilidade", "Uprawnienia i dostępność", "الصلاحيات والتوفر")

documentStrings("docs.objective", "Garde le ballon en jeu de ton côté du filet. La victoire dépend du mode et des réglages du salon.", "Keep the ball off the floor on your side. Win conditions depend on the mode and room settings.", "Evite que a bola toque o chão do seu lado. A vitória depende do modo e dos ajustes da sala.", "Nie pozwól piłce dotknąć ziemi po twojej stronie. Zwycięstwo zależy od trybu i ustawień pokoju.", "امنع الكرة من لمس الأرض في جهتك. تتحدد شروط الفوز حسب الوضع وإعدادات الغرفة.")
documentStrings("docs.transform", "Appuie sur Espace pour te transformer et renvoyer le ballon. La transformation est temporaire.", "Press Space to transform and return the ball. Your transformation lasts a short time.", "Pressione Espaço para se transformar e devolver a bola. A transformação é temporária.", "Naciśnij Spację, by się przemienić i odbić piłkę. Przemiana trwa krótko.", "اضغط المسافة للتحول وإعادة الكرة. يستمر التحول وقتًا قصيرًا.")
documentStrings("docs.join", "Dans le lobby, clique sur une place libre. Les places occupées affichent le pseudo du joueur.", "Click an empty lobby slot to join. Occupied slots display the player's name.", "Clique em uma vaga no lobby. As vagas ocupadas mostram o nome do jogador.", "Kliknij wolne miejsce w lobby. Zajęte miejsca wyświetlają nazwę gracza.", "انقر مكانًا فارغًا في الردهة للانضمام. تعرض الأماكن المشغولة أسماء اللاعبين.")
documentStrings("docs.shortcuts", "Ouvre ton profil avec P et le classement avec L. Les statistiques concernent la session actuelle.", "Open your profile with P and the room ranking with L. Stats cover the current session.", "P abre seu perfil; L abre o ranking da sala. As estatísticas são da sessão atual.", "P otwiera profil, a L ranking pokoju. Statystyki dotyczą bieżącej sesji.", "يفتح P ملفك، ويفتح L ترتيب الغرفة. الإحصاءات تخص الجلسة الحالية.")
documentStrings("docs.creator", "Le premier joueur éligible reçoit ce rôle et au moins les droits de niveau 2. Aucun transfert automatique.", "The first eligible player gets this role and at least level 2 rights. It does not transfer automatically.", "O primeiro jogador elegível recebe o cargo e direitos de nível 2 ou mais. Não há transferência automática.", "Pierwszy uprawniony gracz otrzymuje tę rolę i co najmniej poziom 2. Rola nie przechodzi automatycznie.", "يحصل أول لاعب مؤهل على هذا الدور وصلاحيات المستوى 2 على الأقل. لا ينتقل الدور تلقائيًا.")
documentStrings("docs.maps", "Le sélecteur propose Select et Vote. Tu peux aussi consulter !maps et voter avec !votemap [index].", "The map selector offers Select and Vote. Use !maps to browse and !votemap [index] to vote.", "O seletor de mapas oferece Select e Vote. Consulte !maps e vote com !votemap [index].", "Wybór map oferuje Select i Vote. Zobacz !maps i głosuj przez !votemap [index].", "يوفر محدد الخرائط الاختيار والتصويت. استخدم !maps للقائمة و!votemap [index] للتصويت.")
documentStrings("docs.balls", "Les ballons proposent uniquement Select. Consulte !balls pour voir la liste des ballons.", "Balls offer Select only. Use !balls to view the available balls.", "As bolas oferecem apenas Select. Use !balls para ver as bolas disponíveis.", "Piłki mają tylko opcję Select. Użyj !balls, by zobaczyć dostępne piłki.", "الكرات تتيح الاختيار فقط. استخدم !balls لعرض الكرات المتاحة.")
documentStrings("docs.permissions", "Les actions disponibles dépendent de tes droits, du mode et de l'état de la partie.", "Available actions depend on your rights, the mode and the current match state.", "As ações disponíveis dependem dos seus direitos, do modo e do estado da partida.", "Dostępne działania zależą od uprawnień, trybu i stanu meczu.", "تعتمد الإجراءات المتاحة على صلاحياتك والوضع وحالة المباراة.")

documentStrings("docs.real.transform.title", "3 transformations", "3 transformations", "3 transformações", "3 przemiany", "3 تحولات")
documentStrings("docs.real.serve.title", "Le service", "Serving", "O saque", "Zagrywka", "الإرسال")
documentStrings("docs.real.out_no_touch.title", "Sortie sans transformation", "Out: no transformation", "Fora: sem transformação", "Aut bez przemiany", "خروج دون تحول")
documentStrings("docs.real.out_touch.title", "Sortie après transformation", "Out: after transformation", "Fora: após transformação", "Aut po przemianie", "خروج بعد التحول")
documentStrings("docs.real.outside.title", "7 secondes hors du terrain", "7 seconds off the court", "7 segundos fora da quadra", "7 sekund poza boiskiem", "7 ثوانٍ خارج الملعب")
documentStrings("docs.real.force.title", "Touches 1 · 2 · 3 · 4", "Keys 1 · 2 · 3 · 4", "Teclas 1 · 2 · 3 · 4", "Klawisze 1 · 2 · 3 · 4", "المفاتيح 1 · 2 · 3 · 4")
documentStrings("docs.real.transform", "Trois transformations par équipe et par échange ; une seule au service.", "Three transformations per team per rally; only one on serve.", "Três transformações por equipe a cada troca; apenas uma no saque.", "Trzy przemiany na drużynę w wymianie; tylko jedna przy zagrywce.", "ثلاثة تحولات لكل فريق في التبادل، وتحول واحد عند الإرسال.")
documentStrings("docs.real.serve", "Les joueurs servent chacun leur tour.", "Players take turns serving.", "Os jogadores se revezam no saque.", "Gracze zagrywają na zmianę.", "يتناوب اللاعبون على الإرسال.")
documentStrings("docs.real.out_no_touch", "Le ballon sort de ton côté sans transformation de ton équipe : point pour vous.", "The ball goes out on your side with no team transformation: your team scores.", "A bola sai do seu lado sem transformação da sua equipe: ponto para vocês.", "Piłka wychodzi po waszej stronie bez przemiany drużyny: punkt dla was.", "تخرج الكرة من جهتكم دون تحول فريقكم: النقطة لكم.")
documentStrings("docs.real.out_touch", "Ton équipe se transforme, puis le ballon sort de ton côté : point adverse.", "Your team transforms, then the ball goes out on your side: the opponent scores.", "Sua equipe se transforma e a bola sai do seu lado: ponto do adversário.", "Wasza drużyna przemienia się, a piłka wychodzi po waszej stronie: punkt rywala.", "يتحول فريقكم ثم تخرج الكرة من جهتكم: النقطة للخصم.")
documentStrings("docs.real.outside", "Après 7 secondes hors du terrain, ta transformation est bloquée.", "Transformation is blocked after 7 seconds outside the court.", "Após 7 segundos fora da quadra, sua transformação é bloqueada.", "Po 7 sekundach poza boiskiem przemiana zostaje zablokowana.", "يُحظر التحول بعد 7 ثوانٍ خارج الملعب.")
documentStrings("docs.real.force", "Choisis ta force de transformation avec les touches 1, 2, 3 et 4.", "Choose your transformation strength with keys 1, 2, 3 and 4.", "Escolha a força de transformação com as teclas 1, 2, 3 e 4.", "Wybierz siłę przemiany klawiszami 1, 2, 3 i 4.", "اختر قوة التحول بالمفاتيح 1 و2 و3 و4.")
documentStrings("docs.credits.creation", "Création du jeu", "Game creation", "Criação do jogo", "Twórca gry", "إنشاء اللعبة")
documentStrings("docs.credits.development", "Développement", "Development", "Desenvolvimento", "Rozwój gry", "التطوير")
documentStrings("docs.credits.main", "Développeur principal", "Main developer", "Desenvolvedor principal", "Główny deweloper", "المطوّر الرئيسي")
documentStrings("docs.credits.second", "Développeur secondaire", "Secondary developer", "Desenvolvedor secundário", "Drugi deweloper", "المطوّر الثانوي")

documentStrings("docs.credits.thanks", "Remerciements", "Special thanks", "Agradecimentos", "Podziękowania", "شكر خاص")
documentStrings("docs.credits.uploads", "Upload des images", "Image uploads", "Envio das imagens", "Przesyłanie obrazów", "رفع الصور")
documentStrings("docs.credits.host", "Upload des images et hébergement du module", "Image uploads and module hosting", "Envio das imagens e hospedagem do módulo", "Przesyłanie obrazów i hosting modułu", "رفع الصور واستضافة الوحدة")

clubhouse.documentPages = {
  {"docs.objective", "docs.transform", "docs.join", "docs.shortcuts"},
  {"docs.creator", "docs.maps", "docs.balls", "docs.permissions"}
}
for page=3,10 do
  local entries={}
  for index=(page-3)*4+1,(page-2)*4 do entries[#entries+1]="command."..string.format("%02d",index) end
  clubhouse.documentPages[page]=entries
end

-- Command syntax is populated below; descriptions retain all five translations.
documentStrings("docs.alias", "Alias : {aliases}", "Alias: {aliases}", "Atalho: {aliases}", "Skrót: {aliases}", "الاختصار: {aliases}")
documentStrings("docs.aliases", "Alias : {aliases}", "Aliases: {aliases}", "Atalhos: {aliases}", "Skróty: {aliases}", "الاختصارات: {aliases}")
clubhouse.documentAliases = {
  lang={"la"}, join={"j"}, leave={"l"}, profile={"pr"}, maps={"m"}, balls={"b"},
  votemap={"vm"}, crown={"cr"}, settings={"se"}, password={"pw"}, winscore={"w"}, setmaxplayers={"smp"},
  resettimer={"re"}, stoptimer={"stop"}, skiptimer={"s","skip"}, lobby={"lo"},
  setmap={"sm"}, custommap={"cm"}, customball={"cb"}, setscore={"ssc"},
  ["2teamsmode"]={"twm","twoteamsmode"}, ["3teamsmode"]={"thm","threeteamsmode"},
  ["4teamsmode"]={"fom","fourteamsmode"}, realmode={"rm"}, twoballs={"twb"},
  threeballs={"thb"}, consumables={"co"}, setplayerforce={"spf"}, sync={"sy"},
  synctfm={"syt"}, setsync={"ssy"}
}
clubhouse.documentCommands = {
  ["command.01"] = "!lang AR/BR/EN/FR/PL",
  ["command.02"] = "!join",
  ["command.03"] = "!leave",
  ["command.04"] = "!profile [Name#0000]",
  ["command.05"] = "!maps",
  ["command.06"] = "!balls",
  ["command.07"] = "!votemap [index]",
  ["command.08"] = "!crown [true/false]",
  ["command.09"] = "!settings",
  ["command.10"] = "!password [password]",
  ["command.11"] = "!winscore [number]",
  ["command.12"] = "!setmaxplayers [6-20]",
  ["command.13"] = "!resettimer",
  ["command.14"] = "!stoptimer",
  ["command.15"] = "!skiptimer",
  ["command.16"] = "!lobby",
  ["command.17"] = "!setmap [small/large/extra-large]",
  ["command.18"] = "!custommap [true/false] [index]",
  ["command.19"] = "!customball [index]",
  ["command.20"] = "!setscore [Name#0000] [number]",
  ["command.21"] = "!setscore [red/blue] [number]",
  ["command.22"] = "!2teamsmode [true/false]",
  ["command.23"] = "!3teamsmode [true/false]",
  ["command.24"] = "!4teamsmode [true/false]",
  ["command.25"] = "!realmode [true/false]",
  ["command.26"] = "!twoballs [true/false]",
  ["command.27"] = "!threeballs [true/false]",
  ["command.28"] = "!consumables [true/false]",
  ["command.29"] = "!setplayerforce [0-1.05]",
  ["command.30"] = "!sync",
  ["command.31"] = "!synctfm",
  ["command.32"] = "!setsync",
}

function clubhouse.documentText(name, key, id, text, x, y, width, height, size, color, face, align)
  local rtl = clubhouse.language(name) == "ar"
  text = clubhouse.escape(text)
  if rtl then
    text = text:gsub("(![%w_]+)", "\226\128\170%1\226\128\172")
  end
  text = text:gsub("\n", "<br>")
  clubhouse.area(name, key, id,
    "<p align='" .. (align or (rtl and "right" or "left")) .. "'><font face='" ..
    (face or (rtl and "Arial" or "Verdana")) .. "' size='" .. (size or 11) ..
    "' color='" .. (color or "#DDD2BB") .. "'>" .. text .. "</font></p>",
    x, y, width, height)
end

-- Separators sit on the existing artwork; no opaque tiles or inset boxes.
function clubhouse.documentRule(name, key, id, x, y, width)
  clubhouse.area(name, key, id,
    "<p align='center'><font face='Verdana' size='8' color='#82663C'>" ..
    string.rep("─", math.floor(width / 8)) .. "</font></p>",
    x, y - 8, width, 20)
end

function clubhouse.documentCard(name, key, id, title, body, x, y, width, height, command, aliases)
  clubhouse.documentText(name, key, id + 1, title,
    x + 10, y + 4, width - 20, 21, 13, "#E5C991",
    command and "Consolas" or (clubhouse.language(name) == "ar" and "Arial" or "Georgia"),
    command and "left" or nil)
  local bodyY = aliases and 45 or 26
  if aliases then
    clubhouse.documentText(name, key, id + 3, aliases,
      x + 10, y + 25, width - 20, 20, 10, "#9CAEAA")
  end
  clubhouse.documentText(name, key, id + 2, body,
    x + 10, y + bodyY, width - 20, height - bodyY - 2, 11)
end

function clubhouse.helpDocument(name, page)
  local s = clubhouse.screens.help;
  local r = s.regions.body
  local x, y = s.x + r.x, s.y + r.y
  clubhouse.documentText(name, "help", s.base + 40,
    string.format("%02d", page) .. "  /  " .. clubhouse.text(name, "docs.help." .. page),
    x, y, r.width, 25, 15, "#E5C991",
    clubhouse.language(name) == "ar" and "Arial" or "Georgia", "center")
  clubhouse.documentRule(name, "help", s.base + 41, x + 10, y + 26, r.width - 20)
  for index, key in ipairs(clubhouse.documentPages[page]) do
    local column = (index - 1) % 2
    if clubhouse.language(name) == "ar" then
      column = 1 - column
    end
    local command = clubhouse.documentCommands[key]
    local aliases = command and clubhouse.documentAliases[command:match("^!([%w_]+)")]
    if aliases then
      aliases = clubhouse.text(name, #aliases == 1 and "docs.alias" or "docs.aliases",
        { aliases = "!" .. table.concat(aliases, " / !") })
    end
    clubhouse.documentCard(name, "help", s.base + 50 + (index - 1) * 3,
      command or clubhouse.text(name, key .. ".title"), clubhouse.text(name, key),
      x + column * 307, y + 31 + math.floor((index - 1) / 2) * 82,
      295, command and 81 or 74, command ~= nil, aliases)
  end
end

function clubhouse.realDocument(name)
  local s = clubhouse.screens.real_rules;
  local r = s.regions.body
  for index, item in ipairs({ "transform", "serve", "out_no_touch", "out_touch", "outside", "force" }) do
    local column = (index - 1) % 2
    if clubhouse.language(name) == "ar" then
      column = 1 - column
    end
    local key = "docs.real." .. item
    clubhouse.documentCard(name, "real_rules", s.base + 50 + (index - 1) * 3,
      clubhouse.text(name, key .. ".title"), clubhouse.text(name, key),
      s.x + r.x + column * 307, s.y + r.y + math.floor((index - 1) / 2) * 70,
      295, 62, false)
  end
end

function clubhouse.creditsDocument(name)
  local key = "credits";
  local s = clubhouse.screens[key];
  local r = s.regions.body
  local x, y = s.x + r.x, s.y + r.y
  local rtl = clubhouse.language(name) == "ar"
  local left = x + (rtl and 408 or 0);
  local right = x + 204;
  local thanks = x + (rtl and 0 or 408)
  local function panel(id, heading, px, py, height)
    clubhouse.documentRule(name, key, id, px + 10, py + 29, 174)
    clubhouse.documentText(name, key, id + 1, heading,
      px + 10, py + 6, 174, 22, 13, "#E5C991", rtl and "Arial" or "Georgia")
  end
  panel(s.base + 40, clubhouse.text(name, "docs.credits.creation"), left, y, 77)
  clubhouse.documentText(name, key, s.base + 42, "Refletz#6472",
    left + 10, y + 31, 174, 23, 15, "#F2E5CD")
  clubhouse.documentText(name, key, s.base + 43, "Soristl",
    left + 10, y + 55, 174, 20, 10, "#9CAEAA")

  panel(s.base + 50, clubhouse.text(name, "docs.credits.development"), left, y + 72, 130)
  for i, entry in ipairs({
    { "Refletz#6472", "main" },
    { "Myzk#5789", "second" },
    { "Tanarchosl#4785", "second" }
  }) do
    local top = y + 101 + (i - 1) * 32
    clubhouse.documentText(name, key, s.base + 52 + (i - 1) * 2, entry[1],
      left + 10, top, 174, 19, 12, "#F2E5CD")
    clubhouse.documentText(name, key, s.base + 53 + (i - 1) * 2,
      clubhouse.text(name, "docs.credits." .. entry[2]),
      left + 10, top + 16, 174, 18, 10, "#9CAEAA")
  end

  panel(s.base + 60, clubhouse.text(name, "credits.original_translation"), right, y, 202)
  for i, entry in ipairs({
    { "BR / EN", "Refletz#6472 (Soristl)" },
    { "AR", "Ionut_eric_pro#1679" },
    { "FR", "Rowed#4415" },
    { "PL", "Prestige#5656" }
  }) do
    local top = y + 35 + (i - 1) * 40
    clubhouse.documentText(name, key, s.base + 62 + (i - 1) * 2, entry[1],
      right + 10, top, 174, 20, 10, "#E5C991")
    clubhouse.documentText(name, key, s.base + 63 + (i - 1) * 2, entry[2],
      right + 10, top + 18, 174, 21, 12, "#F2E5CD")
  end

  panel(s.base + 70, clubhouse.text(name, "docs.credits.thanks"), thanks, y, 202)
  for i, entry in ipairs({ { "Hufdasr#0000", "uploads" }, { "Mckeydown#0000", "host" } }) do
    local top = y + 35 + (i - 1) * 72
    clubhouse.documentText(name, key, s.base + 72 + (i - 1) * 2, entry[1],
      thanks + 10, top, 174, 22, 12, "#F2E5CD")
    clubhouse.documentText(name, key, s.base + 73 + (i - 1) * 2,
      clubhouse.text(name, "docs.credits." .. entry[2]),
      thanks + 10, top + 23, 174, 43, 10, "#9CAEAA")
  end
end

end)()
end
