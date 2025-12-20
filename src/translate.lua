local lang = {}
local languages = "[AR/BR/EN/FR/PL]"

local gameVersion = "V2.2.2"

lang.br = {
  welcomeMessage = "<j>Bem vindo ao Volley, jogo criado por Refletz#6472<n>",
  welcomeMessage2 = "<j>Digite !join para entrar na partida<n>",
  msgRedWinner = "O time vermelho venceu!",
  msgBlueWinner = "O time azul venceu!",
  menuOpenText = "<br><br><a href='event:howToPlay'>Como jogar</a><br><a href='event:realmode'>Vôlei Modo Real</a><br><a href='event:ranking'>Ranking</a><br><a href='event:credits'>Creditos</a><br>",
  closeUIText = "<p align='center'><font size='12px'><a href='event:closeWindow'>Fechar",
  helpTitle = "<p align='center'><font size='16px'>Como jogar Volley ("..gameVersion..")",
  helpText = {
    [1] = { text = "<br><br><p align='left'><font size='12px'>O objetivo do vôlei é evitar que a bola caia no chão de sua quadra, e para evitar isso, você pode transformar seu rato em um objeto circular apertando a tecla <j>[ Espaço ]<n>, o rato se destransforma 3 segundos depois. A equipe que fazer 7 pontos primeiro vence!<br>Criar uma sala com admin: <bv><a href='event:roomadmin'>/sala *#volley0SeuNome#0000</a><n><br><br>Comandos (<rose>*<n> = durante a partida | <vp>*<n> = comandos do admin):<br><br><j>!lang<n> <ch>"..languages.."<n> - Para modificar o idioma do minigame<br><j>!join<n> <rose>*<n> - Para entrar na partida <br><j>!leave<n> <rose>*<n> - Para sair da partida e ir para a área de espectador<br><j>!resettimer<n> <vp>*<n> - Resetar o tempo no lobby antes de começar a partida<br><j>!setmap<n> <ch>[small/large/extra-large]<n> <vp>*<n> - Para selecionar um mapa em especifico antes de começar uma partida<br><j>!pw<n> <ch>[senha]<n> <vp>*<n> - Colocar uma senha na sala"},
    [2] = { text = "<p align='left'><font size='12px'><br><br>Comandos (<rose>*<n> = durante a partida | <vp>*<n> = comandos do admin):<br><br><j>!winscore<n> <ch>[número]<n> <rose>*<n> <vp>*<n> - Mudar o numero máximo de pontos para vencer uma partida<br><j>!customMap<n> <ch>[true ou false]<n> <ch>[index do mapa]<n> <vp>*<n> - Selecionar um mapa costumizado<br><j>!maps<n> - Mostra a lista de mapas<br><j>!votemap<n> <ch>[numero]<n> - Votar em um mapa costumizado para a próxima partida<br><j>!setscore<n> <ch>[nome do jogador]<n> <ch>[numero]<n> <rose>*<n> <vp>*<n> - Troca a score do jogador pelo numero<br><j>!setscore<n> <ch>[nome do jogador]<n> <rose>*<n> <vp>*<n> - Adiciona +1 a score do jogador<br><j>!setscore<n> <ch>[red ou blue]<n> <ch>[numero]<n> <rose>*<n> <vp>*<n> - Troca a score do time pelo numero<br><j>!4teamsmode<n> <ch>[true ou false]<n> <vp>*<n> - Seleciona o modo de 4 times do Volley<br>"},
    [3] = { text = "<p align='left'><font size='12px'><br><br>Comandos (<rose>*<n> = durante a partida | <vp>*<n> = comandos do admin):<br><br><j>!setmaxplayers <ch>[6 - 20]<n> <vp>*<n> - Seleciona o máximo de jogadores para entrar na sala<br><j>!balls<n> - Mostra a lista de bolas costumizadas do #Volley<br><j>!customball<n> <ch>[Número]<n> <vp>*<n> - Seleciona uma bola costumizável para a próxima partida<br><j>!lobby<n> <rose>*<n> <vp>*<n> - Encerra uma partida que estava em andamento e retorna para o lobby<br><j>!setplayerforce<n> <ch>[Número: 0 - 1.05]<n> <vp>*<n> - Seleciona a força para o objeto esférico do rato<br><j>!2teamsmode<n> <ch>[true ou false]<n> <vp>*<n> - Seleciona o modo especial de 2 times<br><j>!sync<n> <vp>*<n> - O sistema escolhe o jogador com a menor latência para sincronizar a sala<br><j>!synctfm<n> <vp>*<n> - O sistema do TFM escolhe o jogador com a menor latência para sincronizar"},
    [4] = { text = "<p align='left'><font size='12px'><br><br>Comandos (<rose>*<n> = durante a partida | <vp>*<n> = comandos do admin):<br><br><j>!skiptimer<n> <vp>*<n> - Inicia a partida o mais rápido possível<br><j>!realmode<n> <ch>[true ou false]<n> <vp>*<n> - Seleciona Volley Real Mode<br><j>!twoballs<n> <ch>[true ou false]<n> <vp>*<n> - Ativa duas bolas em jogo<br><j>!consumables<n> <ch>[true ou false]<n> <vp>*<n> - Escolha um consumível com as teclas (7, 8, 9 e 0) e ative eles apertando M no modo normal<br><j>!settings<n> <vp>*<n> - Comando para fazer configurações globais na sala<br><j>!setsync<n> <vp>*<n> - Seleciona a sync para o jogador<br><j>!crown<n> <ch>[true ou false]<n> - Ativa/desativa imagens de coroa" },
    [5] = { text = "<p align='left'><font size='12px'><br><br>Comandos (<rose>*<n> = durante a partida | <vp>*<n> = comandos do admin):<br><br><j>!profile<n> <vp>*<n> - Mostra o seu perfil no Volley, você também pode abrir o seu perfil usando a tecla P<br><j>!profile<n> <ch>[playerName#0000]<n> <vp>*<n> - Mostra o perfil do jogador selecionado no Volley<br><j>!stoptimer<n> <vp>*<n> - Para o temporizador do lobby<br><j>!3teamsmode<n> <ch>[true ou false]<n> <vp>*<n> - ativa o modo 3 teams<br><j>!threeballs<n> <ch>[true ou false]<n> <vp>*<n> - Ativa 3 bolas no modo 3 teams mode" }
  },
  creditsTitle = "<p align='center'><font size='16px'>Créditos (Volley)",
  creditsText = "<br><br><p align='left'><font size='12px'>O jogo foi desenvolvido por <j>Refletz#6472 (Soristl)<n><br><br>Tradução BR/EN: <j>Refletz#6472 (Soristl)<n><br><br>Tradução AR: <j>Ionut_eric_pro#1679<n><br><br>Tradução FR: <j>Rowed#4415<n><br><br>Tradução PL: <j>Prestige#5656<n>",
  messageSetMaxPlayers = "Número máximo de jogadores colocado para",
  newPassword = "Nova senha:",
  passwordRemoved = "<bv>Senha removida<n>",
  messageMaxPlayersAlert = "<bv>O número máximo de jogadores deve ser no mínimo 6 e no máximo 20<n>",
  previousMessage = "<p align='center'>Voltar",
  nextMessage = "<p align='center'>Próximo",
  realModeRules = "<p align='center'><font size='16px'>Volley Real Mode Regras<br><br><p align='left'><font size='12px'><b>- Cada time pode se <b>transformar</b> em um <vi>objeto esférico<n> somente 3x (exceto no <b>saque</b> que é apenas 1x)<br><br>- Se a bola for para a fora do lado do seu time e <b>ninguém</b> do seu time se transformou em um <vi>objeto esférico<n> o ponto é do seu time<br><br>- Se a bola foi para fora e o seu time se <b>transformou no</b> <vi><b>objeto esférico<b><n> o ponto é do adversário<br><br>- Cada jogador irá sacar a bola uma vez conforme o andamento da partida<br><br>- Se o jogador sair da quadra, o jogador poderá realizar uma ação por <j>7 segundos<n>, caso contrário o jogador não poderá usar a <j>tecla de espaço<n><br><br>- As teclas 1, 2, 3 e 4 alteram a força do jogador",
  titleSettings = "<p align='center'><font size='16px'>Configurações da sala</p>",
  textSettings = "<p align='left'><font size='12px'><textformat leading='30'>Selecione o modo de jogo<br>Ativar o comando !randomball</textformat><br><br>Ativar o comando !randommap<br><br><br>Ativar o comando !twoballs</p>",
  textSettings2 = "<p align='left'><font size='12px'><textformat leading='30'>Selecione o tamanho do mapa (!setmap) (modo normal)<br>Ativar o comando !consumables (modo normal)</textformat><br>Ativar o modo de três bolas em três equipes",
  msgAchievements = "<p align='left'><font size='14px'>Conquistas:",
  msgsTrophies = {
    [1] = "Troféu Copa do Mundo de Vôlei",
    [2] = "Futevôlei Ultimate Team Badge",
    [3] = "Copa do mundo de Futebol",
    [4] = "Volley Roulette badge",
    [5] = "Volley Wild Card badge"
  },
  mapSelect = 'Selecionar um mapa',
}

lang.en = {
  welcomeMessage = "<j>Welcome to the Volley, game was created by Refletz#6472<n>",
  welcomeMessage2 = "<j>Type !join to join on the match<n>",
  msgRedWinner = "Team red won!",
  msgBlueWinner = "Team blue won!",
  menuOpenText = "<br><br><a href='event:howToPlay'>How to play</a><br><a href='event:realmode'>Volley Real Mode</a><br><a href='event:ranking'>Ranking</a><br><a href='event:credits'>Credits</a><br>",
  closeUIText = "<p align='center'><font size='12px'><a href='event:closeWindow'>Close",
  helpTitle = "<p align='center'><font size='16px'>How to play Volley ("..gameVersion..")",
  helpText = {
    [1] = { text = "<br><br><p align='left'><font size='12px'>The objective of volleyball is to prevent the ball from falling to the floor of your court, and to avoid this, you can turn your mouse into a circular object by pressing the <j>[ Space ]<n> key, the mouse untransforms 3 seconds later. The team that scores 7 points first wins!<br>Create a room with admin: <bv><a href='event:roomadmin'>/room *#volley0YourName#0000</a><n><br><br>Commands (<rose>*<n> = during the match | <vp>*<n> = admin's commands):<br><br><j>!lang<n> <ch>"..languages.."<n> - To modify the minigame language<br><j>!join<n> <rose>*<n> - To join the match<br><j>!leave<n> <rose>*<n> - To leave the match and go to the spectator area<br><j>!resettimer<n> <vp>*<n> - Reset time in the lobby before starting the match<br><j>!setmap<n> <ch>[small/large/extra-large]<n> <vp>*<n> - To select a specific map before starting a match<br><j>!pw<n> <ch>[password]<n> <vp>*<n> - Put a password in the room"},
    [2] = { text = "<p align='left'><font size='12px'><br><br>Commands (<rose>*<n> = during the match | <vp>*<n> = admin's commands):<br><br><j>!winscore<n> <ch>[number]<n> <rose>*<n> <vp>*<n> - Change the maximum number of points to win a match<br><j>!customMap<n> <ch>[true or false]<n> <ch>[map index]<n> <vp>*<n> - Select a custom map<br><j>!maps<n> - Shows the list of maps<br><j>!votemap<n> <ch>[number]<n> - Vote for a custom map for the next match<br><j>!setscore<n> <ch>[Player name]<n> <ch>[number]<n> <rose>*<n> <vp>*<n> - Swap the player's score by number<br><j>!setscore<n> <ch>[Player name]<n> <rose>*<n> <vp>*<n> - Adds +1 to player's score<br><j>!setscore<n> <ch>[red or blue]<n> <ch>[number]<n> <rose>*<n> <vp>*<n> - Swap the team's score for the number<br><j>!4teamsmode<n> <ch>[true or false]<n> <vp>*<n> - Select 4-team Volley mode"},
    [3] = { text = "<p align='left'><font size='12px'><br><br>Commands (<rose>*<n> = during the match | <vp>*<n> = admin's commands)<br><br><j>!setmaxplayers <ch>[6 - 20]<n> <vp>*<n> - Selects the maximum number of players to enter the room<br><j>!balls<n> - Shows the list of #Volley custom balls<br><j>!customball<n> <ch>[Number]<n> <vp>*<n> - Select a customizable ball for the next match<br><j>!lobby<n> <rose>*<n> <vp>*<n> - End a match that was in progress and return to the lobby<br><j>!setplayerforce<n> <ch>[Number: 0 - 1.05]<n> <vp>*<n> - Selects the strength for the spherical mouse object<br><j>!2teamsmode<n> <ch>[true or false]<n> <vp>*<n> - Selects the special 2-team mode<br><j>!sync<n> <vp>*<n> - The system chooses the player with the lowest latency to synchronize the room<br><j>!synctfm<n> <vp>*<n> - The TFM system chooses the player with the lowest latency to synchronize the room"},
    [4] = { text = "<p align='left'><font size='12px'><br><br>Commands (<rose>*<n> = during the match | <vp>*<n> = admin's commands)<br><br><j>!skiptimer<n> <vp>*<n> - Start the game as quickly as possible<br><j>!realmode<n> <ch>[true or false]<n> <vp>*<n> - Selects Volley Real Mode<br><j>!twoballs<n> <ch>[true or false] <n> <vp>*<n> - Activates two balls in game<br><j>!consumables<n> <ch>[true or false]<n> <vp>*<n> - Choose a consumable with the keys (7, 8, 9 and 0) and activate them by pressing M in normal mode<br><j>!settings<n> <vp>*<n> - Command to make global settings in the room<br><j>!setsync<n> <vp>*<n> - Selects sync for the player<br><j>!crown<n> <ch>[true or false]<n> - Enables/disables crown images"},
    [5] = { text = "<p align='left'><font size='12px'><br><br>Commands (<rose>*<n> = during the match | <vp>*<n> = admin's commands)<br><br><j>!profile<n> <vp>*<n> - Shows your profile on Volley, you can also open your profile using the P key<br><j>!profile<n> <ch>[playerName#0000]<n> <vp>*<n> - Shows the profile of the selected player in Volley<br><j>!stoptimer<n> <vp>*<n> - Stops the lobby timer<br><j>!3teamsmode<n> <ch>[true or false]<n> <vp>*<n> - Activates 3 teams mode<br><j>!threeballs<n> <ch>[true or false]<n> <vp>*<n> - Activates 3 balls in 3 teams mode"}
  },
  creditsTitle = "<p align='center'><font size='16px'>Credits (Volley)",
  creditsText = "<br><br><p align='left'><font size='12px'>The game was developed by <j>Refletz#6472 (Soristl)<n><br><br>BR/EN Translation: <j>Refletz#6472 (Soristl)<n><br><br>AR Translation: <j>Ionut_eric_pro#1679<n><br><br>FR Translation: <j>Rowed#4415<n><br><br>PL Translation: <j>Prestige#5656<n>",
  messageSetMaxPlayers = "Maximum number of players placed for",
  newPassword = "New password:",
  passwordRemoved = "<bv>Password removed<n>",
  messageMaxPlayersAlert = "<bv>The maximum number of players must be a minimum of 6 and a maximum of 20<n>",
  previousMessage = "<p align='center'>Back",
  nextMessage = "<p align='center'>Next",
  realModeRules = "<p align='center'><font size='16px'>Volley Real Mode Rules<br><br><p align='left'><font size='12px'><b>- Each team can join <b>transform</b> into a <vi>spherical object<n> only 3 times (except for the <b>serve</b> which is only 1 time)<br><br>- If the ball goes out on your team's side and <b>no one</b> on your team turned into a <vi>spherical object<n> the point is your team's<br><br>- If the ball went out and someone of your team <b>turned into</b> <vi><b>spherical object<b><n> the point belongs to the opponent<br><br>- Each player will serve the ball once <br><br>- If the player leaves the court, the player will be able to perform an action for <j>7 seconds<n>, otherwise the player will not be able to use the <j>space key<n><br><br>- The 1, 2, 3 and 4 keys change the player's strength",
  titleSettings = "<p align='center'><font size='16px'>Room Settings</p>",
  textSettings = "<p align='left'><font size='12px'><textformat leading='30'>Select game mode<br>Activate the !randomball command</textformat><br><br>Activate the !randommap command<br><br><br>Activate the !twoballs command</p>",
  textSettings2 = "<p align='left'><font size='12px'><textformat leading='30'>Select the map size (!setmap) (Normal mode)<br>Activate the !consumables command (Normal mode)</textformat><br>Enable three balls on 3 teams mode",
  msgAchievements = "<p align='left'><font size='14px'>Achievements:",
  msgsTrophies = {
    [1] = "Volleyball World Cup Trophy",
    [2] = "FootVolley Ultimate Team Badge",
    [3] = "Volley Soccer World Cup",
    [4] = "Volley Roulette badge",
    [5] = "Volley Wild Card"
  },
  mapSelect = 'Select a map'
}

lang.ar = {
  welcomeMessage = "<j>مرحبًا بكم في لعبة كرة الطائرة، التي تم إنشاؤها من طرف Refletz#6472<n>",
  welcomeMessage2 = "<j>اكتب  !join للانضمام إلى المباراة.<n>",
  msgRedWinner = "فاز الفريق الأحمر!",
  msgBlueWinner = "فاز الفريق الأزرق!",
  menuOpenText = "<br><br><a href='event:howToPlay'>كيفية اللعب</a><br><a href='event:realmode'>وضع الكرة الطائرة الحقيقي</a><br><a href='event:ranking'>التصنيف</a><br><a href='event:credits'>شكر خاص</a><br>",
  closeUIText = "<p align='center'><font size='12px'><a href='event:closeWindow'>إغلاق",
  helpTitle = "<p align='center'><font size='16px'>كيفية لعب الكرة الطائرة ("..gameVersion..")",
  helpText = {
    [1] = { text = "<br><br><p align='right'><font size='12px'>هدف كرة الطائرة هو منع الكرة من السقوط إلى أرضية ملعب فريقك، ولتحقيق هذا، يمكنك تحويل الفأر الخاص بك إلى كائن دائري عن طريق الضغط على <j>[ مسطرة ]<n> مفتاح, ويعود الفأر إلى شكله الأصلي بعد 3 ثوانٍ. الفريق الذي يسجل 7 نقاط أولاً يفوز!<br>إنشاء غرفة بخاصيات المشرف: <bv><a href='event:roomadmin'>/room *#volley0إسمك#0000</a><n><br><br>الأوامر (<rose>*<n> = أثناء المباراة | <vp>*<n> = أوامر المشرف):<br><br><j>!lang<n> <ch>"..languages.."<n> - لتعديل لغة النمط<br><j>!join<n> <rose>*<n> - للإنضمام للمباراة<br><j>!leave<n> <rose>*<n> - لمغادرة المباراة والذهاب إلى منطقة المتفرجين<br><j>!resettimer<n> <vp>*<n> - قم بإعادة ضبط الوقت في الردهة قبل بدء المباراة<br><j>!setmap<n> <ch>[small/large/extra-large]<n> <vp>*<n> - لتحديد خريطة معينة قبل بدء المباراة<br><j>!pw<n> <ch>[password]<n> <vp>*<n> - ضع كلمة مرور في الغرفة"},
    [2] = { text = "<p align='right'><font size='12px'><br><br>الأوامر (<rose>*<n> = أثناء المباراة | <vp>*<n> = أوامر المشرف):<br><br><j>!winscore<n> <ch>[number]<n> <rose>*<n> <vp>*<n> - تغيير الحد الأقصى لعدد النقاط للفوز بالمباراة<br><j>!customMap<n> <ch>[true or false]<n> <ch>[map index]<n> <vp>*<n> - اختر ماب مخصص<br><j>!maps<n> - تظهر قائمة الخرائط<br><j>!votemap<n> <ch>[number]<n> - التصويت للحصول على ماب مخصص للمباراة القادمة<br><j>!setscore<n> <ch>[Player name]<n> <ch>[number]<n> <rose>*<n> <vp>*<n> - قم بتبديل نتيجة اللاعب بالرقم<br><j>!setscore<n> <ch>[Player name]<n> <rose>*<n> <vp>*<n> - يضيف +1 إلى نتيجة اللاعب<br><j>!setscore<n> <ch>[red or blue]<n> <ch>[number]<n> <rose>*<n> <vp>*<n> - قم بتبديل نتيجة الفريق بالرقم<br><j>!4teamsmode<n> <ch>[true or false]<n> <vp>*<n> - حدد وضع الكرة الطائرة المكون من 4 فرق"},
    [3] = { text = "<p align='right'><font size='12px'><br><br>الأوامر (<rose>*<n> = أثناء المباراة | <vp>*<n> = أوامر المشرف)<br><br><j>!setmaxplayers <ch>[6 - 20]<n> <vp>*<n> - يحدد الحد الأقصى لعدد اللاعبين لدخول الغرفة<br><j>!balls<n> - تظهر قائمة الكرات الخاصة بالنمط <br><j>!customball<n> <ch>[Number]<n> <vp>*<n> - حدد كرة خاصة للمباراة القادمة<br><j>!lobby<n> <rose>*<n> <vp>*<n> - إنهاء المباراة الجارية والعودة إلى الردهة<br><j>!setplayerforce<n> <ch>[Number: 0 - 1.05]<n> <vp>*<n> - تحديد قوة شكل الفأر الكروي<br><j>!2teamsmode<n> <ch>[true or false]<n> <vp>*<n> - يختار الوضع الخاص المكون من فريقين<br><j>!sync<n> <vp>*<n> - يختار النظام اللاعب ذو زمن الاستجابة الأقل لمزامنة الغرفة<br><j>!synctfm<n> <vp>*<n> - يقام نظام TFM باختيار اللاعب صاحب أقل زمن استجابة لمزامنة الغرفة."},
    [4] = { text = "<p align='right'><font size='12px'><br><br>الأوامر (<rose>*<n> = أثناء المباراة | <vp>*<n> = أوامر المشرف)<br><br><j>!skiptimer<n> <vp>*<n> - يتخطى وقت الانتظار لبدء اللعبة إلى 5 ثواني <br><j>!realmode<n> <ch>[true or false خطأ]<n> <vp>*<n> - تحديد الوضع الحقيقي للكرة الطائرة<br><j>!twoballs<n> <ch>[true or false] <n> <vp>*<n> - ينشط كرتين في اللعبة<br><j>!consumables<n> <ch>[true or false]<n> <vp>*<n> - اختر عنصرًا مستهلكًا به المفاتيح (7 و 8 و 9 و 0) وتفعيلها بالضغط على M في الوضع العادي<br><j>!settings<n> <vp>*<n> - الأمر بإجراء الإعدادات العامة في الغرفة<br><j>!setsync<n> <vp>*<n> - يحدد المزامنة للمشغل<br><j>!crown<n> <ch>[true or false]<n> - تمكين/تعطيل صور التاج"},
    [5] = { text = "<p align='right'><font size='12px'><br><br>الأوامر (<rose>*<n> = أثناء المباراة | <vp>*<n> = أوامر المشرف)<br><br><j>!profile<n> <vp>*<n> - يعرض ملفك الشخصي على Volley، ويمكنك أيضًا فتح ملفك الشخصي باستخدام مفتاح P<br><j>!profile<n> <ch>[playerName#0000]<n> <vp>*<n> - يعرض الملف الشخصي للاعب المحدد في الكرة الطائرة<br><j>!stoptimer<n> <vp>*<n> - يوقف وقت الانتظار <br><j>!3teamsmode<n> <ch>[true or false]<n> <vp>*<n> - لتفعيل وضع 3 فرق<br><j>!threeballs<n> <ch>[true or false]<n> <vp>*<n> - لتفعيل وضع 3 كرات في وضع 3 فرق"}
  },
  creditsTitle = "<p align='center'><font size='16px'>شكر خاص (الكرة الطائرة)",
  creditsText = "<br><br><p align='right'><font size='12px'>تم تطوير اللعبة من طرف <j>Refletz#6472 (Soristl)<n><br><br>ترجمة BR/EN: <j>Refletz#6472 (Soristl)<n><br><br>ترجمة AR: <j>Ionut_eric_pro#1679<n><br><br>ترجمة FR: <j>Rowed#4415<n><br><br>ترجمة PL: <j>Prestige#5656<n>",
  messageSetMaxPlayers = "الحد الأقصى لعدد اللاعبين الذين تم وضعهم هو",
  newPassword = "كلمة المرور الجديدة:",
  passwordRemoved = "<bv>تمت إزالة كلمة المرور<n>",
  messageMaxPlayersAlert = "<bv>يجب أن يكون الحد الأقصى لعدد اللاعبين 6 لاعبين كحد أدنى و20 كحد أقصى<n>",
  previousMessage = "<p align='center'>الخلف",
  nextMessage = "<p align='center'>التالي",
  realModeRules = "<p align='center'><font size='16px'>قواعد الوضع الحقيقي للكرة الطائرة<br><br><p align='right'><font size='12px'><b>- يمكن لكل فريق الانضمام <b>يتحول</b> إلى <vi>جسم كروي<n> 3 مرات فقط (باستثناء <b>الإرسال</b> الذي يكون مرة واحدة فقط)<br><br>- إذا ذهبت الكرة خرجت إلى جانب فريقك و<b>لم يتحول أي شخص</b> في فريقك إلى <vi>جسم كروي<n> فالنقطة تخص فريقك<br><br>-  إذا خرجت الكرة وشخص ما من فريقك الفريق <b>الذي تحول إلى</b> <vi><b>جسم كروي<b><n> النقطة مملوكة للخصم<br><br>- سيرسل كل لاعب الكرة مرة واحدة  <br><br>-فسيتمكن اللاعب من تنفيذ إجراء لمدة <j>7 ثوانٍ<n>، وإلا فلن يتمكن اللاعب من استخدام <j>مفتاح المسافة<n><br><br>-تعمل المفاتيح 1 و2 و3 و4 على تغيير قوة اللاعب",
  titleSettings = "<p align='center'><font size='16px'>إعدادات الغرفة</p>",
  textSettings = "<p align='left'><font size='12px'><textformat leading='30'>اختر وضع اللعبة<br>تفعيل أمر !randomball</textformat><br><br>تفعيل أمر !randommap<br><br><br>تفعيل أمر !twoballs</p>",
  textSettings2 = "<p align='left'><font size='12px'><textformat leading='30'>حدد حجم الخريطة (!setmap) (الوضع العادي)<br>قم بتنشيط أمر !consumables (الوضع العادي)</textformat><br>تفعيل وضع ثلاث كرات لثلاثة فرق",
  msgAchievements = "<p align='right'><font size='14px'>الإنجازات:",
  msgsTrophies = {
    [1] = "كأس العالم للكرة الطائرة",
    [2] = "شارة فريق FootVolley Ultimate Team",
    [3] = "كأس العالم لكرة القدم الطائرة",
    [4] = "شارة روليت الطائرة",
    [5] = "شارة الكرة الطائرة البرية"
  },
  mapSelect = 'حدد الخريطة'
}

lang.fr = {
  welcomeMessage = "<j>Bienvenue au Volley, un jeu créé par Refletz#6472<n>",
  welcomeMessage2 = "<j>Tapez !join pour rejoindre la partie<n>",
  msgRedWinner = "L'équipe rouge a gagné!",
  msgBlueWinner = "L'équipe bleue a gagné!",
  menuOpenText = "<br><br><a href='event:howToPlay'>Comment jouer</a><br><a href='event:realmode'>Mode Réel de Volley</a><br><a href='event:ranking'>Ranking</a><br><a href='event:credits'>Crédits</a><br>",
  closeUIText = "<p align='center'><font size='12px'><a href='event:closeWindow'>Fermer",
  helpTitle = "<p align='center'><font size='16px'>Comment jouer au Volley ("..gameVersion..")",
  helpText = {
    [1] = { text = "<br><br><p align='left'><font size='12px'>L'objectif du volley est d'éviter que la balle ne tombe sur le sol de votre côté du terrain, et pour éviter cela, vous pouvez transformer votre souris en un objet circulaire en pressant la touche <j><br>[ Espace ]<n>, la souris reprend sa forme originale 3 secondes plus tard. L'équipe qui marque 7 points en première gagne!<br>Créer un salon avec admin: <bv><a href='event:roomadmin'>/salon *#volley0VotreNom#0000</a><n><br><br>Commandes (<rose>*<n> = durant la partie | <vp>*<n> = commandes admin):<br><br><j>!lang<n> <ch>"..languages.."<n> - Pour modifier la langue du mini-jeu<br><j>!join<n> <rose>*<n> - Pour rejoindre la partie<br><j>!leave<n> <rose>*<n> - Pour quitter la partie et aller dans la zone des spectateurs<br><j>!resettimer<n> <vp>*<n> - Réinitialise le temps dans le lobby avant de commencer la partie<br><j>!setmap<n> <ch>[small/large/extra-large]<n> <vp>*<n> - Pour sélectionner une carte spécifique avant de commencer la partie"},
    [2] = { text = "<p align='left'><font size='12px'><br><br>Commandes (<rose>*<n> = durant la partie | <vp>*<n> = commandes admin):<br><br><j>!pw<n> <ch>[password]<n> <vp>*<n> - Mettre un mot de passe dans le salon<br><j>!winscore<n> <ch>[nombre]<n> <rose>*<n> <vp>*<n> - Change le score à atteindre pour gagner la partie<br><j>!customMap<n> <ch>[true ou false]<n> <ch>[index de la carte]<n> <vp>*<n> - Sélectionne une carte customisée<br><j>!maps<n> - Affiche la liste de cartes<br><j>!votemap<n> <ch>[nombre]<n> - Vote pour une carte customisée pour la prochaine partie<br><j>!setscore<n> <ch>[Nom du joueur]<n> <ch>[nombre]<n> <rose>*<n> <vp>*<n> - Change le score du joueur par le nombre<br><j>!setscore<n> <ch>[Nom du joueur]<n> <rose>*<n> <vp>*<n> - Ajoute +1 au score du joueur<br><j>!setscore<n> <ch>[red ou blue]<n> <ch>[nombre]<n> <rose>*<n> <vp>*<n> - Change le score de l'équipe par le nombre<br><j>!4teamsmode<n> <ch>[true ou false]<n> <vp>*<n> - Sélectionne le mode de 4 équipes au Volley"},
    [3] = { text = "<p align='left'><font size='12px'><br><br>Commandes (<rose>*<n> = durant la partie | <vp>*<n> = commandes admin)<br><br><j>!setmaxplayers <ch>[6 - 20]<n> <vp>*<n> - Sélectionne le nombre maximum de joueurs pouvant entrer dans le salon<br><j>!balls<n> - Affiche la liste des balles customisées du #Volley<br><j>!customball<n> <ch>[Nombre]<n> <vp>*<n> - Sélectionne une balle customisée pour la prochaine partie<br><j>!lobby<n> <rose>*<n> <vp>*<n> - Termine un match en cours et retourne au lobby<br><j>!setplayerforce<n> <ch>[Nombre: 0 - 1.05]<n> <vp>*<n> - Sélectionne la force pour l'objet sphérique de la souris<br><j>!2teamsmode<n> <ch>[true ou false]<n> <vp>*<n> - Sélectionne le mode de jeu spécial à 2 équipes<br><j>!sync<n> <vp>*<n> - Le système choisit le joueur avec la latence la plus faible pour synchroniser le salon<br><j>!synctfm<n> <vp>*<n> - Le système TFM choisit le joueur avec la latence la plus faible pour synchroniser le salon"},
    [4] = { text = "<p align='left'><font size='12px'><br><br>Commandes (<rose>*<n> = durant la partie | <vp>*<n> = commandes amdin)<br><br><j>!skiptimer<n> <vp>*<n> - Commence la partie le plus vite possible<br><j>!realmode<n> <ch>[true ou false]<n> <vp>*<n> - Sélectionne le mode réel de volée<br><j>!twoballs<n> <ch>[true ou false] <n> <vp>*<n> - Active deux balles dans le jeu<br><j>!consumables<n> <ch>[true ou false]<n> <vp>*<n> - Choisissez un consommable avec les touches (7, 8, 9 et 0) et activez-les en appuyant sur M en mode normal<br><j>!settings<n> <vp>*<n> - Commande pour effectuer les réglages globaux dans la pièce<br><j>!setsync<n> <vp>*<n> - Sélectionne la synchronisation pour le lecteur<br><j>!crown<n> <ch>[true ou false]<n> - Activer/désactiver les images de couronne"},
    [5] = { text = "<p align='left'><font size='12px'><br><br>Commandes (<rose>*<n> = durant la partie | <vp>*<n> = commandes amdin)<br><br><j>!profile<n> <vp>*<n> - Affiche votre profil sur Volley, vous pouvez également ouvrir votre profil en utilisant la touche P<br><j>!profile<n> <ch>[playerName#0000]<n> <vp>*<n> - Affiche le profil du joueur sélectionné dans Volley<br><j>!stoptimer<n> <vp>*<n> - Arrête le temps du lobby<br><j>!3teamsmode<n> <ch>[true ou false]<n> <vp>*<n> - Active le mode à 3 équipes<br><j>!threeballs<n> <ch>[true ou false]<n> <vp>*<n> - Active le mode à 3 balles en mode 3 équipes"}
  },
  creditsTitle = "<p align='center'><font size='16px'>Crédits (Volley)",
  creditsText = "<br><br><p align='left'><font size='12px'>Le jeu a été développé par <j>Refletz#6472 (Soristl)<n><br><br>BR/EN Translation: <j>Refletz#6472 (Soristl)<n><br><br>AR Translation: <j>Ionut_eric_pro#1679<n><br><br>FR Translation: <j>Rowed#4415<n><br><br>PL Translation: <j>Prestige#5656<n>",
  messageSetMaxPlayers = "Nombre de joueurs maximum mis à",
  newPassword = "Nouveau mot de passe:",
  passwordRemoved = "<bv>Mot de passe retiré<n>",
  messageMaxPlayersAlert = "<bv>Le maximum de joueurs doit être au minimum de 6 et au maximum de 20<n>",
  previousMessage = "<p align='center'>Précédent",
  nextMessage = "<p align='center'>Suivant",
  realModeRules = "<p align='center'><font size='16px'>Règles du Volley Real Mode<br><br><p align='left'><font size='12px'><b>- Chaque équipe peut se <b>transformer</b> en un <vi>objet sphérique<n> seulement 3 fois (sauf pour le <b>service</b> où ce n'est qu'UNE fois)<br><br>- Si la balle va dehors de votre côté du terrain et que <b>personne</b> de votre équipe ne s'est transformé en un <vi>objet sphérique<n> le point est pour votre équipe<br><br>- Si la balle va dehors et que quelqu'un de votre équipe <b>s'est transformé</b> en un <vi><b>objet sphérique<b><n> le point revient à l'adversaire<br><br>- Chaque joueur servira la balle une fois <br><br>- Si le joueur quitte le terrain, le joueur pourra effectuer une action pendant <j>7 secondes<n>, autrement le joueur ne sera pas capable d'utiliser la <j>touche espace<n><br><br>- Les touches 1, 2, 3 et 4 changent la force du joueur.",
  titleSettings = "<p align='center'><font size='16px'>Paramètres de la salle</p>",
  textSettings = "<p align='left'><font size='12px'><textformat leading='30'>Sélectionner le mode de jeu<br>Activer la commande !randomball</textformat><br><br>Activer la commande !randommap<br><br><br>Activer la commande !twoballs</p>",
  textSettings2 = "<p align='left'><font size='12px'><textformat leading='30'>Sélectionnez la taille de la carte (!setmap) (mode normal)<br>Activez la commande !consumables (mode normal)</textformat><br>Activez le mode à trois balles pour trois équipes.",
  msgAchievements = "<p align='left'><font size='14px'>Réalisations:",
  msgsTrophies = {
    [1] = "Trophée de la Coupe du Monde de Volleyball",
    [2] = "FootVolley Ultimate Team Badge",
    [3] = "Coupe de monde de soccer volley",
    [4] = "Volley Roulette badge",
    [5] = "Volley Wild Card badge"
  },
  mapSelect = 'Sélectionner une carte'
}

lang.pl = {
  welcomeMessage = "<j>Witaj w Volley, gra została stworzona przez Refletz#6472<n>",
  welcomeMessage2 = "<j>Wpisz !join, by dołączyć do meczu<n>",
  msgRedWinner = "Drużyna czerwonych wygrała!",
  msgBlueWinner = "Drużyna niebieskich wygrała!",
  menuOpenText = "<br><br><a href='event:howToPlay'>Jak grać</a><br><a href='event:realmode'>Volley Real Mode</a><br><a href='event:ranking'>Ranking</a><br><a href='event:credits'>Credits</a><br>",
  closeUIText = "<p align='center'><font size='12px'><a href='event:closeWindow'>Close",
  helpTitle = "<p align='center'><font size='16px'>Jak grać w Volley ("..gameVersion..")",
  helpText = {
    [1] = { text = "<br><br><p align='left'><font size='12px'>Celem siatkówki jest zapobieganie upadkowi piłki na podłogę twojego boiska, a aby to osiągnąć, możesz zamienić myszkę w okrągły obiekt, naciskając przycisk <j>[ Space ]<n> Mysz wraca do pierwotnego kształtu po 3 sekundach. Drużyna, która pierwsza zdobędzie 7 punktów, wygrywa!<br>Stwórz swój pokój: <bv><a href='event:roomadmin'>/room *#volley0YourName#0000</a><n><br><br>Komendy (<rose>*<n> = podczas meczu | <vp>*<n> = komendy administratora):<br><br><j>!lang<n> <ch>"..languages.."<n> - Aby zmodyfikować język minigry<br><j>!join<n> <rose>*<n> - Aby dołączyć do meczu<br><j>!leave<n> <rose>*<n> - Aby opuścić mecz i przejść do strefy oglądających<br><j>!resettimer<n> <vp>*<n> - Resetuje czas w lobby przed rozpoczęciem się meczu<br><j>!setmap<n> <ch>[small/large/extra-large]<n> <vp>*<n> - Aby wybrać określoną mapę przed rozpoczęciem meczu<br><j>!pw<n> <ch>[hasło]<n> <vp>*<n> - Ustaw hasło w pokoju"},
    [2] = { text = "<p align='left'><font size='12px'><br><br>Komendy (<rose>*<n> = podczas meczu | <vp>*<n> = komendy administratora):<br><br><j>!winscore<n> <ch>[liczba]<n> <rose>*<n> <vp>*<n> - Zmień maksymalną ilość punktów by wygrać mecz<br><j>!customMap<n> <ch>[true or false]<n> <ch>[map index]<n> <vp>*<n> - Wybierz niestandardową mapę<br><j>!maps<n> - Pokazuje listę map<br><j>!votemap<n> <ch>[liczba]<n> - Głosowanie za niestadardową mapę w następnym meczu<br><j>!setscore<n> <ch>[nazwa gracza]<n> <ch>[liczba]<n> <rose>*<n> <vp>*<n> - Zmień wynik gracza na liczbę<br><j>!setscore<n> <ch>[nazwa gracza]<n> <rose>*<n> <vp>*<n> - Dodaje +1 do wyniku gracza<br><j>!setscore<n> <ch>[red or blue]<n> <ch>[liczba]<n> <rose>*<n> <vp>*<n> - Zmień wynik drużyny<br><j>!4teamsmode<n> <ch>[true or false]<n> <vp>*<n> - Wybierz 4-drużynowy Volley mode"},
    [3] = { text = "<p align='left'><font size='12px'><br><br>Komendy (<rose>*<n> = podczas meczu | <vp>*<n> = komendy administratora)<br><br><j>!setmaxplayers <ch>[6 - 20]<n> <vp>*<n> - Wybierz maksymalną ilość graczy, którzy mogą dołączyć do pokoju<br><j>!balls<n> - Pokazuje listę niestandardowych piłek #Volley<br><j>!customball<n> <ch>[liczba]<n> <vp>*<n> - Wybierz niestandardową piłkę na następny mecz<br><j>!lobby<n> <rose>*<n> <vp>*<n> - Zakończ mecz, który był w trakcie i wróć do lobby<br><j>!setplayerforce<n> <ch>[Number: 0 - 1.05]<n> <vp>*<n> - Wybierz siłę dla okrągłego obiektu myszy<br><j>!2teamsmode<n> <ch>[true or false]<n> <vp>*<n> - Wybierz tryb specjalny dwóch drużyn<br><j>!sync<n> <vp>*<n> - System wybiera gracza z najniższym opóźnieniem, aby zsynchronizować pokój<br><j>!synctfm<n> <vp>*<n> - System TFM wybiera gracza z najniższym opóźnieniem, aby zsynchronizować pokój"},
    [4] = { text = "<p align='left'><font size='12px'><br><br>Komendy (<rose>*<n> = podczas meczu | <vp>*<n> = komendy administratora)<br><br><j>!skiptimer<n> <vp>*<n> - Uruchom grę tak szybko, jak to możliwe<br><j>!realmode<n> <ch>[true or false]<n> <vp>*<n> - Wybiera tryb prawdziwej siatkówki<br><j>!twoballs<n> <ch>[true or false] <n> <vp>*<n> - Aktywuje dwie kule w grze<br><j>!consumables<n> <ch>[true or false]<n> <vp>*<n> - Wybierz materiał eksploatacyjny za pomocą klawiszy (7, 8, 9 i 0) i aktywuj je naciskając M w trybie normalnym<br><j>!settings<n> <vp>*<n> - Polecenie wykonania globalnych ustawień w pomieszczeniu<br><j>!setsync<n> <vp>*<n> - Wybiera synchronizację odtwarzacza<br><j>!crown<n> <ch>[true or false]<n> - Włącz/wyłącz obrazy korony"},
    [5] = { text = "<p align='left'><font size='12px'><br><br>Komendy (<rose>*<n> = podczas meczu | <vp>*<n> = komendy administratora)<br><br><j>!profile<n> <vp>*<n> - Pokazuje Twój profil na Volley, możesz także otworzyć swój profil za pomocą klawisza P<br><j>!profile<n> <ch>[playerName#0000]<n> <vp>*<n> - Pokazuje profil wybranego zawodnika w grze Volley<br><j>!stoptimer<n> <vp>*<n> - Zatrzymuje czas w poczekalni<br><j>!3teamsmode<n> <ch>[true lub false]<n> <vp>*<n> - Aktywuje tryb 3 drużyn<br><j>!threeballs<n> <ch>[true lub false]<n> <vp>*<n> - Aktywuje tryb 3 piłek w trybie 3 drużyn"}
  },
  creditsTitle = "<p align='center'><font size='16px'>Credits (Volley)",
  creditsText = "<br><br><p align='left'><font size='12px'>Gra została stworzona przez <j>Refletz#6472 (Soristl)<n><br><br>BR/EN Tłumaczenie: <j>Refletz#6472 (Soristl)<n><br><br>AR Tłumaczenie: <j>Ionut_eric_pro#1679<n><br><br>FR Tłumaczenie: <j>Rowed#4415<n><br><br>PL Tłumaczenie: <j>Prestige#5656<n>",
  messageSetMaxPlayers = "Z maksymalną liczbą graczy umieszczoną dla",
  newPassword = "Nowe hasło:",
  passwordRemoved = "<bv>Hasło usunięte<n>",
  messageMaxPlayersAlert = "<bv>Maksymalna liczba graczy musi wynosić minimum 6, a maksimum 20<n>",
  previousMessage = "<p align='center'>Powrót",
  nextMessage = "<p align='center'>Następny",
  realModeRules = "<p align='center'><font size='16px'>Zasady trybu Volley Real Mode<br><br><p align='left'><font size='12px'><b>- Każda drużyna może się zmienić <b>transform</b> w <vi>okrągły obiekt<n> tylko 3 razy (nielicząc <b>serwa</b> który jest tylko raz)<br><br>- Jeśli piłka wyląduje poza boiskiem po stronie twojego zespołu i <b>nikt</b> z twojej drużyny nie przekształcił się w <vi>okrągły obiekt<n> wtedy punkt jest zdobyty przez twoją drużynę<br><br>- Jeśli piłka wylądowała poza boiskiem i ktoś z twojej drużyny <b>zmienił się w</b> <vi><b>okrągły obiekt<b><n> wtedy punkt należy do drużyny przeciwnej<br><br>- Każdy z graczy serwuje raz <br><br>- Jeśli zawodnik opuści boisko, będzie mógł wykonać akcję przez <j>7 sekund<n>, w przeciwnym razie zawodnik nie będzie mógł użyć <j>klawiszu spacji<n><br><br>- Klawisze 1, 2, 3 i 4 zmieniają siłę gracza",
  titleSettings = "<p align='center'><font size='16px'>Ustawienia pokoju</p>",
  textSettings = "<p align='left'><font size='12px'><textformat leading='30'>Wybierz tryb gry<br>Aktywuj polecenie !randomball</textformat><br><br>Aktywuj polecenie !randommap<br><br><br>Aktywuj polecenie !twoballs</p>",
  textSettings2 = "<p align='left'><font size='12px'><textformat leading='30'>Wybierz rozmiar mapy (!setmap) (tryb normalny)<br>Aktywuj polecenie !consumables (tryb normalny)</textformat><br>Aktywuj tryb gry z trzema piłkami dla trzech drużyn.",
  msgAchievements = "<p align='left'><font size='14px'>Osiągnięcia:",
  msgsTrophies = {
    [1] = "Trofeum Pucharu Świata w siatkówce",
    [2] = "FootVolley Ultimate Team Badge",
    [3] = "Puchar Świata w piłce siatkowej",
    [4] = "Volley Roulette badge",
    [5] = "Volley Wild Card badge"
  },
  mapSelect = 'Wybierz mapę'
}
