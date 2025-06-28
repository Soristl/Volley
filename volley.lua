-- from https://www.lua.org/pil/11.4.html
local List = {}
function List.new ()
  return {first = 0, last = -1}
end

function List.pushleft (list, value)
  local first = list.first - 1
  list.first = first
  list[first] = value
end

function List.pushright (list, value)
  local last = list.last + 1
  list.last = last
  list[last] = value
end

function List.popleft (list)
  local first = list.first
  if first > list.last then
    return nil
  end
  local value = list[first]
  list[first] = nil        -- to allow garbage collection
  list.first = first + 1
  return value
end

function List.popright (list)
  local last = list.last
  if list.first > last then
    return nil
  end
  local value = list[last]
  list[last] = nil         -- to allow garbage collection
  list.last = last - 1
  return value
end

-- the lib
local timerList = {}
local timersPool = List.new()

function addTimer(callback, ms, loops, label, ...)
  local id = List.popleft(timersPool)
  if id then
    local timer = timerList[id]
    timer.callback = callback
    timer.label = label
    timer.arguments = {...}
    timer.time = ms
    timer.currentTime = 0
    timer.currentLoop = 0
    timer.loops = loops or 1
    timer.isComplete = false
    timer.isPaused = false
    timer.isEnabled = true
  else
    id = #timerList+1
    timerList[id] = {
      callback = callback,
      label = label,
      arguments = {...},
      time = ms,
      currentTime = 0,
      currentLoop = 0,
      loops = loops or 1,
      isComplete = false,
      isPaused = false,
      isEnabled = true,
    }
  end
  return id
end

function getTimerId(label)
  local found
  for id = 1, #timerList do
    local timer = timerList[id]
    if timer.label == label then
      found = id
      break
    end
  end
  return found
end

function pauseTimer(id)
  if type(id) == 'string' then
    id = getTimerId(id)
  end

  if timerList[id] and timerList[id].isEnabled then
    timerList[id].isPaused = true
    return true
  end
  return false
end

function resumeTimer(id)
  if type(id) == 'string' then
    id = getTimerId(id)
  end

  if timerList[id] and timerList[id].isPaused then
    timerList[id].isPaused = false
    return true
  end
  return false
end

function removeTimer(id)
  if type(id) == 'string' then
    id = getTimerId(id)
  end

  if timerList[id] and timerList[id].isEnabled then
    timerList[id].isEnabled = false
    List.pushright(timersPool, id)
    return true
  end
  return false
end

function clearTimers()
  local timer
  repeat
    timer = List.popleft(timersPool)
    if timer then
      table.remove(timerList, timer)
    end
  until timer == nil
end

function timersLoop()
  for id = 1, #timerList do
    local timer = timerList[id]
    if timer.isEnabled and timer.isPaused == false then
      if not timer.isComplete then
        timer.currentTime = timer.currentTime + 500
        if timer.currentTime >= timer.time then
          timer.currentTime = 0
          timer.currentLoop = timer.currentLoop + 1
          if timer.loops > 0 then
            if timer.currentLoop >= timer.loops then
              timer.isComplete = true
              if eventTimerComplete ~= nil then
                eventTimerComplete(id, timer.label)
              end
              removeTimer(id)
            end
          end
          if timer.callback ~= nil then
            timer.callback(timer.currentLoop, table.unpack(timer.arguments))
          end
        end
      end
    end
  end
end

local admins = {
  ["Refletz#6472"] = true,
  ["Soristl1#0000"] = true,
  ["+Mimounaaa#0000"] = true,
  ["Axeldoton#0000"] = true,
  ["Nagi#6356"] = true,
  ["Wreft#5240"] = true,
  ["Lylastyla#0000"] = true,
  ["Ppoppohaejuseyo#2315"] = true,
  ["Rowed#4415"] = true
}

local permanentAdmins = {
  "Refletz#6472",
  "Soristl1#0000",
  "+Mimounaaa#0000",
  "Axeldoton#0000",
  "Nagi#6356",
  "Wreft#5240",
  "Lylastyla#0000",
  "Ppoppohaejuseyo#2315",
  "Rowed#4415"
}

local gameVersion = "V2.2.1"

local trad = ""
local lang = {}
local languages = "[AR/BR/EN/FR/PL]"
lang.br = {
  welcomeMessage = "<j>Bem vindo ao Volley, jogo criado por Refletz#6472<n>",
  welcomeMessage2 = "<j>Digite !join para entrar na partida<n>",
  msgRedWinner = "O time vermelho venceu!",
  msgBlueWinner = "O time azul venceu!",
  menuOpenText = "<br><br><a href='event:howToPlay'>Como jogar</a><br><a href='event:realmode'>Vôlei Modo Real</a><br><a href='event:ranking'>Ranking</a><br><a href='event:credits'>Creditos</a><br>",
  closeUIText = "<p align='center'><font size='12px'><a href='event:closeWindow'>Fechar",
  helpTitle = "<p align='center'><font size='15px'>Como jogar Volley ("..gameVersion..")",
  helpText = {
    [1] = { text = "<br><br><p align='left'><font size='12px'>O objetivo do vôlei é evitar que a bola caia no chão de sua quadra, e para evitar isso, você pode transformar seu rato em um objeto circular apertando a tecla <j>[ Espaço ]<n>, o rato se destransforma 3 segundos depois. A equipe que fazer 7 pontos primeiro vence!<br>Criar uma sala com admin: <bv><a href='event:roomadmin'>/sala *#volley0SeuNome#0000</a><n><br><br>Comandos (<rose>*<n> = durante a partida | <vp>*<n> = comandos do admin):<br><br><j>!lang<n> <ch>"..languages.."<n> - Para modificar o idioma do minigame<br><j>!join<n> <rose>*<n> - Para entrar na partida <br><j>!leave<n> <rose>*<n> - Para sair da partida e ir para a área de espectador<br><j>!resettimer<n> <vp>*<n> - Resetar o tempo no lobby antes de começar a partida<br><j>!setmap<n> <ch>[small/large/extra-large]<n> <vp>*<n> - Para selecionar um mapa em especifico antes de começar uma partida<br><j>!pw<n> <ch>[senha]<n> <vp>*<n> - Colocar uma senha na sala"},
    [2] = { text = "<p align='left'><font size='12px'><br><br>Comandos (<rose>*<n> = durante a partida | <vp>*<n> = comandos do admin):<br><br><j>!winscore<n> <ch>[número]<n> <rose>*<n> <vp>*<n> - Mudar o numero máximo de pontos para vencer uma partida<br><j>!customMap<n> <ch>[true ou false]<n> <ch>[index do mapa]<n> <vp>*<n> - Selecionar um mapa costumizado<br><j>!maps<n> - Mostra a lista de mapas<br><j>!votemap<n> <ch>[numero]<n> - Votar em um mapa costumizado para a próxima partida<br><j>!setscore<n> <ch>[nome do jogador]<n> <ch>[numero]<n> <rose>*<n> <vp>*<n> - Troca a score do jogador pelo numero<br><j>!setscore<n> <ch>[nome do jogador]<n> <rose>*<n> <vp>*<n> - Adiciona +1 a score do jogador<br><j>!setscore<n> <ch>[red ou blue]<n> <ch>[numero]<n> <rose>*<n> <vp>*<n> - Troca a score do time pelo numero<br><j>!4teamsmode<n> <ch>[true ou false]<n> <vp>*<n> - Seleciona o modo de 4 times do Volley<br>"},
    [3] = { text = "<p align='left'><font size='12px'><br><br>Comandos (<rose>*<n> = durante a partida | <vp>*<n> = comandos do admin):<br><br><j>!setmaxplayers <ch>[6 - 20]<n> <vp>*<n> - Seleciona o máximo de jogadores para entrar na sala<br><j>!balls<n> - Mostra a lista de bolas costumizadas do #Volley<br><j>!customball<n> <ch>[Número]<n> <vp>*<n> - Seleciona uma bola costumizável para a próxima partida<br><j>!lobby<n> <rose>*<n> <vp>*<n> - Encerra uma partida que estava em andamento e retorna para o lobby<br><j>!setplayerforce<n> <ch>[Número: 0 - 1.05]<n> <vp>*<n> - Seleciona a força para o objeto esférico do rato<br><j>!2teamsmode<n> <ch>[true ou false]<n> <vp>*<n> - Seleciona o modo especial de 2 times<br><j>!sync<n> <vp>*<n> - O sistema escolhe o jogador com a menor latência para sincronizar a sala<br><j>!synctfm<n> <vp>*<n> - O sistema do TFM escolhe o jogador com a menor latência para sincronizar"},
    [4] = { text = "<p align='left'><font size='12px'><br><br>Comandos (<rose>*<n> = durante a partida | <vp>*<n> = comandos do admin):<br><br><j>!skiptimer<n> <vp>*<n> - Inicia a partida o mais rápido possível<br><j>!afksystem<n> <ch>[true ou false]<n> <vp>*<n> - Ativa ou desativa o sistema de AFK<n><br><j>!settimeafk<n> <ch>[segundos]<n> <vp>*<n> - Seleciona o tempo de afk em segundos<br><j>!realmode<n> <ch>[true ou false]<n> <vp>*<n> - Seleciona Volley Real Mode<br><j>!twoballs<n> <ch>[true ou false]<n> <vp>*<n> - Ativa duas bolas em jogo<br><j>!consumables<n> <ch>[true ou false]<n> <vp>*<n> - Escolha um consumível com as teclas (7, 8, 9 e 0) e ative eles apertando M no modo normal<br><j>!settings<n> <vp>*<n> - Comando para fazer configurações globais na sala<br><j>!setsync<n> <vp>*<n> - Seleciona a sync para o jogador<br><j>!crown<n> <ch>[true ou false]<n> - Ativa/desativa imagens de coroa" },
    [5] = { text = "<p align='left'><font size='12px'><br><br>Comandos (<rose>*<n> = durante a partida | <vp>*<n> = comandos do admin):<br><br><j>!profile<n> <vp>*<n> - Mostra o seu perfil no Volley, você também pode abrir o seu perfil usando a tecla P<br><j>!profile<n> <ch>[playerName#0000]<n> <vp>*<n> - Mostra o perfil do jogador selecionado no Volley" }
  },
  creditsTitle = "<p align='center'><font size='15px'>Créditos (Volley)",
  creditsText = "<br><br><p align='left'><font size='12px'>O jogo foi desenvolvido por <j>Refletz#6472 (Soristl)<n><br><br>Tradução BR/EN: <j>Refletz#6472 (Soristl)<n><br><br>Tradução AR: <j>Ionut_eric_pro#1679<n><br><br>Tradução FR: <j>Rowed#4415<n><br><br>Tradução PL: <j>Prestige#5656<n>",
  messageSetMaxPlayers = "Número máximo de jogadores colocado para",
  newPassword = "Nova senha:",
  passwordRemoved = "<bv>Senha removida<n>",
  messageMaxPlayersAlert = "<bv>O número máximo de jogadores deve ser no mínimo 6 e no máximo 20<n>",
  previousMessage = "<p align='center'>Voltar",
  nextMessage = "<p align='center'>Próximo",
  realModeRules = "<p align='center'><font size='15px'>Volley Real Mode Regras<br><br><p align='left'><font size='12px'><b>- Cada time pode se <b>transformar</b> em um <vi>objeto esférico<n> somente 3x (exceto no <b>saque</b> que é apenas 1x)<br><br>- Se a bola for para a fora do lado do seu time e <b>ninguém</b> do seu time se transformou em um <vi>objeto esférico<n> o ponto é do seu time<br><br>- Se a bola foi para fora e o seu time se <b>transformou no</b> <vi><b>objeto esférico<b><n> o ponto é do adversário<br><br>- Cada jogador irá sacar a bola uma vez conforme o andamento da partida<br><br>- Se o jogador sair da quadra, o jogador poderá realizar uma ação por <j>7 segundos<n>, caso contrário o jogador não poderá usar a <j>tecla de espaço<n><br><br>- As teclas 1, 2, 3 e 4 alteram a força do jogador",
  titleSettings = "<p align='center'><font size='15px'>Configurações da sala</p>",
  textSettings = "<p align='left'><font size='12px'>Selecionar modo de jogo<br><br><br><br><br><br><br><br><br><br>Ativar o comando !twoballs</p>",
  msgAchievements = "<p align='left'><font size='14px'>Conquistas:",
  msgsTrophies = {
    [1] = "Troféu Copa do Mundo de Vôlei",
    [2] = "FootVolley Ultimate Team Badge"
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
  helpTitle = "<p align='center'><font size='15px'>How to play Volley ("..gameVersion..")",
  helpText = {
    [1] = { text = "<br><br><p align='left'><font size='12px'>The objective of volleyball is to prevent the ball from falling to the floor of your court, and to avoid this, you can turn your mouse into a circular object by pressing the <j>[ Space ]<n> key, the mouse untransforms 3 seconds later. The team that scores 7 points first wins!<br>Create a room with admin: <bv><a href='event:roomadmin'>/room *#volley0YourName#0000</a><n><br><br>Commands (<rose>*<n> = during the match | <vp>*<n> = admin's commands):<br><br><j>!lang<n> <ch>"..languages.."<n> - To modify the minigame language<br><j>!join<n> <rose>*<n> - To join the match<br><j>!leave<n> <rose>*<n> - To leave the match and go to the spectator area<br><j>!resettimer<n> <vp>*<n> - Reset time in the lobby before starting the match<br><j>!setmap<n> <ch>[small/large/extra-large]<n> <vp>*<n> - To select a specific map before starting a match<br><j>!pw<n> <ch>[password]<n> <vp>*<n> - Put a password in the room"},
    [2] = { text = "<p align='left'><font size='12px'><br><br>Commands (<rose>*<n> = during the match | <vp>*<n> = admin's commands):<br><br><j>!winscore<n> <ch>[number]<n> <rose>*<n> <vp>*<n> - Change the maximum number of points to win a match<br><j>!customMap<n> <ch>[true or false]<n> <ch>[map index]<n> <vp>*<n> - Select a custom map<br><j>!maps<n> - Shows the list of maps<br><j>!votemap<n> <ch>[number]<n> - Vote for a custom map for the next match<br><j>!setscore<n> <ch>[Player name]<n> <ch>[number]<n> <rose>*<n> <vp>*<n> - Swap the player's score by number<br><j>!setscore<n> <ch>[Player name]<n> <rose>*<n> <vp>*<n> - Adds +1 to player's score<br><j>!setscore<n> <ch>[red or blue]<n> <ch>[number]<n> <rose>*<n> <vp>*<n> - Swap the team's score for the number<br><j>!4teamsmode<n> <ch>[true or false]<n> <vp>*<n> - Select 4-team Volley mode"},
    [3] = { text = "<p align='left'><font size='12px'><br><br>Commands (<rose>*<n> = during the match | <vp>*<n> = admin's commands)<br><br><j>!setmaxplayers <ch>[6 - 20]<n> <vp>*<n> - Selects the maximum number of players to enter the room<br><j>!balls<n> - Shows the list of #Volley custom balls<br><j>!customball<n> <ch>[Number]<n> <vp>*<n> - Select a customizable ball for the next match<br><j>!lobby<n> <rose>*<n> <vp>*<n> - End a match that was in progress and return to the lobby<br><j>!setplayerforce<n> <ch>[Number: 0 - 1.05]<n> <vp>*<n> - Selects the strength for the spherical mouse object<br><j>!2teamsmode<n> <ch>[true or false]<n> <vp>*<n> - Selects the special 2-team mode<br><j>!sync<n> <vp>*<n> - The system chooses the player with the lowest latency to synchronize the room<br><j>!synctfm<n> <vp>*<n> - The TFM system chooses the player with the lowest latency to synchronize the room"},
    [4] = { text = "<p align='left'><font size='12px'><br><br>Commands (<rose>*<n> = during the match | <vp>*<n> = admin's commands)<br><br><j>!skiptimer<n> <vp>*<n> - Start the game as quickly as possible<br><j>!afksystem<n> <ch>[true or false]<n> <vp>*<n> - Enables or disables the AFK system<n><br><j>!settimeafk<n> <ch>[seconds]<n> <vp>*<n> - Select the afk time in seconds<br><j>!realmode<n> <ch>[true or false]<n> <vp>*<n> - Selects Volley Real Mode<br><j>!twoballs<n> <ch>[true or false] <n> <vp>*<n> - Activates two balls in game<br><j>!consumables<n> <ch>[true or false]<n> <vp>*<n> - Choose a consumable with the keys (7, 8, 9 and 0) and activate them by pressing M in normal mode<br><j>!settings<n> <vp>*<n> - Command to make global settings in the room<br><j>!setsync<n> <vp>*<n> - Selects sync for the player<br><j>!crown<n> <ch>[true or false]<n> - Enables/disables crown images"},
    [5] = { text = "<p align='left'><font size='12px'><br><br>Commands (<rose>*<n> = during the match | <vp>*<n> = admin's commands)<br><br><j>!profile<n> <vp>*<n> - Shows your profile on Volley, you can also open your profile using the P key<br><j>!profile<n> <ch>[playerName#0000]<n> <vp>*<n> - Shows the profile of the selected player in Volley"}
  },
  creditsTitle = "<p align='center'><font size='15px'>Credits (Volley)",
  creditsText = "<br><br><p align='left'><font size='12px'>The game was developed by <j>Refletz#6472 (Soristl)<n><br><br>BR/EN Translation: <j>Refletz#6472 (Soristl)<n><br><br>AR Translation: <j>Ionut_eric_pro#1679<n><br><br>FR Translation: <j>Rowed#4415<n><br><br>PL Translation: <j>Prestige#5656<n>",
  messageSetMaxPlayers = "Maximum number of players placed for",
  newPassword = "New password:",
  passwordRemoved = "<bv>Password removed<n>",
  messageMaxPlayersAlert = "<bv>The maximum number of players must be a minimum of 6 and a maximum of 20<n>",
  previousMessage = "<p align='center'>Back",
  nextMessage = "<p align='center'>Next",
  realModeRules = "<p align='center'><font size='15px'>Volley Real Mode Rules<br><br><p align='left'><font size='12px'><b>- Each team can join <b>transform</b> into a <vi>spherical object<n> only 3 times (except for the <b>serve</b> which is only 1 time)<br><br>- If the ball goes out on your team's side and <b>no one</b> on your team turned into a <vi>spherical object<n> the point is your team's<br><br>- If the ball went out and someone of your team <b>turned into</b> <vi><b>spherical object<b><n> the point belongs to the opponent<br><br>- Each player will serve the ball once <br><br>- If the player leaves the court, the player will be able to perform an action for <j>7 seconds<n>, otherwise the player will not be able to use the <j>space key<n><br><br>- The 1, 2, 3 and 4 keys change the player's strength",
  titleSettings = "<p align='center'><font size='15px'>Room Settings</p>",
  textSettings = "<p align='left'><font size='12px'>Select game mode<br><br><br><br><br><br><br><br><br><br>Activate the !twoballs command</p>",
  msgAchievements = "<p align='left'><font size='14px'>Achievements:",
  msgsTrophies = {
    [1] = "Volleyball World Cup Trophy",
    [2] = "FootVolley Ultimate Team Badge"
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
  helpTitle = "<p align='center'><font size='15px'>كيفية لعب الكرة الطائرة ("..gameVersion..")",
  helpText = {
    [1] = { text = "<br><br><p align='right'><font size='12px'>هدف كرة الطائرة هو منع الكرة من السقوط إلى أرضية ملعب فريقك، ولتحقيق هذا، يمكنك تحويل الفأر الخاص بك إلى كائن دائري عن طريق الضغط على <j>[ مسطرة ]<n> مفتاح, ويعود الفأر إلى شكله الأصلي بعد 3 ثوانٍ. الفريق الذي يسجل 7 نقاط أولاً يفوز!<br>إنشاء غرفة بخاصيات المشرف: <bv><a href='event:roomadmin'>/room *#volley0إسمك#0000</a><n><br><br>الأوامر (<rose>*<n> = أثناء المباراة | <vp>*<n> = أوامر المشرف):<br><br><j>!lang<n> <ch>"..languages.."<n> - لتعديل لغة النمط<br><j>!join<n> <rose>*<n> - للإنضمام للمباراة<br><j>!leave<n> <rose>*<n> - لمغادرة المباراة والذهاب إلى منطقة المتفرجين<br><j>!resettimer<n> <vp>*<n> - قم بإعادة ضبط الوقت في الردهة قبل بدء المباراة<br><j>!setmap<n> <ch>[small/large/extra-large]<n> <vp>*<n> - لتحديد خريطة معينة قبل بدء المباراة<br><j>!pw<n> <ch>[password]<n> <vp>*<n> - ضع كلمة مرور في الغرفة"},
    [2] = { text = "<p align='right'><font size='12px'><br><br>الأوامر (<rose>*<n> = أثناء المباراة | <vp>*<n> = أوامر المشرف):<br><br><j>!winscore<n> <ch>[number]<n> <rose>*<n> <vp>*<n> - تغيير الحد الأقصى لعدد النقاط للفوز بالمباراة<br><j>!customMap<n> <ch>[true or false]<n> <ch>[map index]<n> <vp>*<n> - اختر ماب مخصص<br><j>!maps<n> - تظهر قائمة الخرائط<br><j>!votemap<n> <ch>[number]<n> - التصويت للحصول على ماب مخصص للمباراة القادمة<br><j>!setscore<n> <ch>[Player name]<n> <ch>[number]<n> <rose>*<n> <vp>*<n> - قم بتبديل نتيجة اللاعب بالرقم<br><j>!setscore<n> <ch>[Player name]<n> <rose>*<n> <vp>*<n> - يضيف +1 إلى نتيجة اللاعب<br><j>!setscore<n> <ch>[red or blue]<n> <ch>[number]<n> <rose>*<n> <vp>*<n> - قم بتبديل نتيجة الفريق بالرقم<br><j>!4teamsmode<n> <ch>[true or false]<n> <vp>*<n> - حدد وضع الكرة الطائرة المكون من 4 فرق"},
    [3] = { text = "<p align='right'><font size='12px'><br><br>الأوامر (<rose>*<n> = أثناء المباراة | <vp>*<n> = أوامر المشرف)<br><br><j>!setmaxplayers <ch>[6 - 20]<n> <vp>*<n> - يحدد الحد الأقصى لعدد اللاعبين لدخول الغرفة<br><j>!balls<n> - تظهر قائمة الكرات الخاصة بالنمط <br><j>!customball<n> <ch>[Number]<n> <vp>*<n> - حدد كرة خاصة للمباراة القادمة<br><j>!lobby<n> <rose>*<n> <vp>*<n> - إنهاء المباراة الجارية والعودة إلى الردهة<br><j>!setplayerforce<n> <ch>[Number: 0 - 1.05]<n> <vp>*<n> - تحديد قوة شكل الفأر الكروي<br><j>!2teamsmode<n> <ch>[true or false]<n> <vp>*<n> - يختار الوضع الخاص المكون من فريقين<br><j>!sync<n> <vp>*<n> - يختار النظام اللاعب ذو زمن الاستجابة الأقل لمزامنة الغرفة<br><j>!synctfm<n> <vp>*<n> - يقام نظام TFM باختيار اللاعب صاحب أقل زمن استجابة لمزامنة الغرفة."},
    [4] = { text = "<p align='right'><font size='12px'><br><br>الأوامر (<rose>*<n> = أثناء المباراة | <vp>*<n> = أوامر المشرف)<br><br><j>!skiptimer<n> <vp>*<n> - يتخطى وقت الانتظار لبدء اللعبة إلى 5 ثواني <br><j>!afksystem<n> <ch>[true or false]<n> <vp>*<n> - تمكين أو تعطيل نظام AFK<n><br><j>!settimeafk<n> <ch>[true or false]<n> <vp>*<n> - حدد الوقت AFK بالثواني <br><j>!realmode<n> <ch>[true or false خطأ]<n> <vp>*<n> - تحديد الوضع الحقيقي للكرة الطائرة<br><j>!twoballs<n> <ch>[true or false] <n> <vp>*<n> - ينشط كرتين في اللعبة<br><j>!consumables<n> <ch>[true or false]<n> <vp>*<n> - اختر عنصرًا مستهلكًا به المفاتيح (7 و 8 و 9 و 0) وتفعيلها بالضغط على M في الوضع العادي<br><j>!settings<n> <vp>*<n> - الأمر بإجراء الإعدادات العامة في الغرفة<br><j>!setsync<n> <vp>*<n> - يحدد المزامنة للمشغل<br><j>!crown<n> <ch>[true or false]<n> - تمكين/تعطيل صور التاج"},
    [5] = { text = "<p align='right'><font size='12px'><br><br>الأوامر (<rose>*<n> = أثناء المباراة | <vp>*<n> = أوامر المشرف)<br><br><j>!profile<n> <vp>*<n> - يعرض ملفك الشخصي على Volley، ويمكنك أيضًا فتح ملفك الشخصي باستخدام مفتاح P<br><j>!profile<n> <ch>[playerName#0000]<n> <vp>*<n> - يعرض الملف الشخصي للاعب المحدد في الكرة الطائرة"}
  },
  creditsTitle = "<p align='center'><font size='15px'>شكر خاص (الكرة الطائرة)",
  creditsText = "<br><br><p align='right'><font size='12px'>تم تطوير اللعبة من طرف <j>Refletz#6472 (Soristl)<n><br><br>ترجمة BR/EN: <j>Refletz#6472 (Soristl)<n><br><br>ترجمة AR: <j>Ionut_eric_pro#1679<n><br><br>ترجمة FR: <j>Rowed#4415<n><br><br>ترجمة PL: <j>Prestige#5656<n>",
  messageSetMaxPlayers = "الحد الأقصى لعدد اللاعبين الذين تم وضعهم هو",
  newPassword = "كلمة المرور الجديدة:",
  passwordRemoved = "<bv>تمت إزالة كلمة المرور<n>",
  messageMaxPlayersAlert = "<bv>يجب أن يكون الحد الأقصى لعدد اللاعبين 6 لاعبين كحد أدنى و20 كحد أقصى<n>",
  previousMessage = "<p align='center'>الخلف",
  nextMessage = "<p align='center'>التالي",
  realModeRules = "<p align='center'><font size='15px'>قواعد الوضع الحقيقي للكرة الطائرة<br><br><p align='right'><font size='12px'><b>- يمكن لكل فريق الانضمام <b>يتحول</b> إلى <vi>جسم كروي<n> 3 مرات فقط (باستثناء <b>الإرسال</b> الذي يكون مرة واحدة فقط)<br><br>- إذا ذهبت الكرة خرجت إلى جانب فريقك و<b>لم يتحول أي شخص</b> في فريقك إلى <vi>جسم كروي<n> فالنقطة تخص فريقك<br><br>-  إذا خرجت الكرة وشخص ما من فريقك الفريق <b>الذي تحول إلى</b> <vi><b>جسم كروي<b><n> النقطة مملوكة للخصم<br><br>- سيرسل كل لاعب الكرة مرة واحدة  <br><br>-فسيتمكن اللاعب من تنفيذ إجراء لمدة <j>7 ثوانٍ<n>، وإلا فلن يتمكن اللاعب من استخدام <j>مفتاح المسافة<n><br><br>-تعمل المفاتيح 1 و2 و3 و4 على تغيير قوة اللاعب",
  titleSettings = "<p align='center'><font size='15px'>إعدادات الغرفة</p>",
  textSettings = "<p align='right'><font size='12px'>اختر وضع اللعبة<br><br><br><br><br><br><br><br><br><br> قم بتنشيط !twoballs الأمر </p>",
  msgAchievements = "<p align='right'><font size='14px'>الإنجازات:",
  msgsTrophies = {
    [1] = "كأس العالم للكرة الطائرة",
    [2] = "شارة فريق FootVolley Ultimate Team"
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
  helpTitle = "<p align='center'><font size='15px'>Comment jouer au Volley ("..gameVersion..")",
  helpText = {
    [1] = { text = "<br><br><p align='left'><font size='12px'>L'objectif du volley est d'éviter que la balle ne tombe sur le sol de votre côté du terrain, et pour éviter cela, vous pouvez transformer votre souris en un objet circulaire en pressant la touche <j><br>[ Espace ]<n>, la souris reprend sa forme originale 3 secondes plus tard. L'équipe qui marque 7 points en première gagne!<br>Créer un salon avec admin: <bv><a href='event:roomadmin'>/salon *#volley0VotreNom#0000</a><n><br><br>Commandes (<rose>*<n> = durant la partie | <vp>*<n> = commandes admin):<br><br><j>!lang<n> <ch>"..languages.."<n> - Pour modifier la langue du mini-jeu<br><j>!join<n> <rose>*<n> - Pour rejoindre la partie<br><j>!leave<n> <rose>*<n> - Pour quitter la partie et aller dans la zone des spectateurs<br><j>!resettimer<n> <vp>*<n> - Réinitialise le temps dans le lobby avant de commencer la partie<br><j>!setmap<n> <ch>[small/large/extra-large]<n> <vp>*<n> - Pour sélectionner une carte spécifique avant de commencer la partie"},
    [2] = { text = "<p align='left'><font size='12px'><br><br>Commandes (<rose>*<n> = durant la partie | <vp>*<n> = commandes admin):<br><br><j>!pw<n> <ch>[password]<n> <vp>*<n> - Mettre un mot de passe dans le salon<br><j>!winscore<n> <ch>[nombre]<n> <rose>*<n> <vp>*<n> - Change le score à atteindre pour gagner la partie<br><j>!customMap<n> <ch>[true ou false]<n> <ch>[index de la carte]<n> <vp>*<n> - Sélectionne une carte customisée<br><j>!maps<n> - Affiche la liste de cartes<br><j>!votemap<n> <ch>[nombre]<n> - Vote pour une carte customisée pour la prochaine partie<br><j>!setscore<n> <ch>[Nom du joueur]<n> <ch>[nombre]<n> <rose>*<n> <vp>*<n> - Change le score du joueur par le nombre<br><j>!setscore<n> <ch>[Nom du joueur]<n> <rose>*<n> <vp>*<n> - Ajoute +1 au score du joueur<br><j>!setscore<n> <ch>[red ou blue]<n> <ch>[nombre]<n> <rose>*<n> <vp>*<n> - Change le score de l'équipe par le nombre<br><j>!4teamsmode<n> <ch>[true ou false]<n> <vp>*<n> - Sélectionne le mode de 4 équipes au Volley"},
    [3] = { text = "<p align='left'><font size='12px'><br><br>Commandes (<rose>*<n> = durant la partie | <vp>*<n> = commandes admin)<br><br><j>!setmaxplayers <ch>[6 - 20]<n> <vp>*<n> - Sélectionne le nombre maximum de joueurs pouvant entrer dans le salon<br><j>!balls<n> - Affiche la liste des balles customisées du #Volley<br><j>!customball<n> <ch>[Nombre]<n> <vp>*<n> - Sélectionne une balle customisée pour la prochaine partie<br><j>!lobby<n> <rose>*<n> <vp>*<n> - Termine un match en cours et retourne au lobby<br><j>!setplayerforce<n> <ch>[Nombre: 0 - 1.05]<n> <vp>*<n> - Sélectionne la force pour l'objet sphérique de la souris<br><j>!2teamsmode<n> <ch>[true ou false]<n> <vp>*<n> - Sélectionne le mode de jeu spécial à 2 équipes<br><j>!sync<n> <vp>*<n> - Le système choisit le joueur avec la latence la plus faible pour synchroniser le salon<br><j>!synctfm<n> <vp>*<n> - Le système TFM choisit le joueur avec la latence la plus faible pour synchroniser le salon"},
    [4] = { text = "<p align='left'><font size='12px'><br><br>Commandes (<rose>*<n> = durant la partie | <vp>*<n> = commandes amdin)<br><br><j>!skiptimer<n> <vp>*<n> - Commence la partie le plus vite possible<br><j>!afksystem<n> <ch>[true ou false]<n> <vp>*<n> - Active ou désactive le système AFK<n><br><j>!settimeafk<n> <ch>[secondes]<n> <vp>*<n> - Sélectionne le temps d'afk en secondes<br><j>!realmode<n> <ch>[true ou false]<n> <vp>*<n> - Sélectionne le mode réel de volée<br><j>!twoballs<n> <ch>[true ou false] <n> <vp>*<n> - Active deux balles dans le jeu<br><j>!consumables<n> <ch>[true ou false]<n> <vp>*<n> - Choisissez un consommable avec les touches (7, 8, 9 et 0) et activez-les en appuyant sur M en mode normal<br><j>!settings<n> <vp>*<n> - Commande pour effectuer les réglages globaux dans la pièce<br><j>!setsync<n> <vp>*<n> - Sélectionne la synchronisation pour le lecteur<br><j>!crown<n> <ch>[true ou false]<n> - Activer/désactiver les images de couronne"},
    [5] = { text = "<p align='left'><font size='12px'><br><br>Commandes (<rose>*<n> = durant la partie | <vp>*<n> = commandes amdin)<br><br><j>!profile<n> <vp>*<n> - Affiche votre profil sur Volley, vous pouvez également ouvrir votre profil en utilisant la touche P<br><j>!profile<n> <ch>[playerName#0000]<n> <vp>*<n> - Affiche le profil du joueur sélectionné dans Volley"}
  },
  creditsTitle = "<p align='center'><font size='15px'>Crédits (Volley)",
  creditsText = "<br><br><p align='left'><font size='12px'>Le jeu a été développé par <j>Refletz#6472 (Soristl)<n><br><br>BR/EN Translation: <j>Refletz#6472 (Soristl)<n><br><br>AR Translation: <j>Ionut_eric_pro#1679<n><br><br>FR Translation: <j>Rowed#4415<n><br><br>PL Translation: <j>Prestige#5656<n>",
  messageSetMaxPlayers = "Nombre de joueurs maximum mis à",
  newPassword = "Nouveau mot de passe:",
  passwordRemoved = "<bv>Mot de passe retiré<n>",
  messageMaxPlayersAlert = "<bv>Le maximum de joueurs doit être au minimum de 6 et au maximum de 20<n>",
  previousMessage = "<p align='center'>Précédent",
  nextMessage = "<p align='center'>Suivant",
  realModeRules = "<p align='center'><font size='15px'>Règles du Volley Real Mode<br><br><p align='left'><font size='12px'><b>- Chaque équipe peut se <b>transformer</b> en un <vi>objet sphérique<n> seulement 3 fois (sauf pour le <b>service</b> où ce n'est qu'UNE fois)<br><br>- Si la balle va dehors de votre côté du terrain et que <b>personne</b> de votre équipe ne s'est transformé en un <vi>objet sphérique<n> le point est pour votre équipe<br><br>- Si la balle va dehors et que quelqu'un de votre équipe <b>s'est transformé</b> en un <vi><b>objet sphérique<b><n> le point revient à l'adversaire<br><br>- Chaque joueur servira la balle une fois <br><br>- Si le joueur quitte le terrain, le joueur pourra effectuer une action pendant <j>7 secondes<n>, autrement le joueur ne sera pas capable d'utiliser la <j>touche espace<n><br><br>- Les touches 1, 2, 3 et 4 changent la force du joueur.",
  titleSettings = "<p align='center'><font size='15px'>Paramètres de la salle</p>",
  textSettings = "<p align='left'><font size='12px'>Sélectionner le mode de jeu<br><br><br><br><br><br><br><br><br><br>Activer les !twoballs commande</p>",
  msgAchievements = "<p align='left'><font size='14px'>Réalisations:",
  msgsTrophies = {
    [1] = "Trophée de la Coupe du Monde de Volleyball",
    [2] = "FootVolley Ultimate Team Badge"
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
  helpTitle = "<p align='center'><font size='15px'>Jak grać w Volley ("..gameVersion..")",
  helpText = {
    [1] = { text = "<br><br><p align='left'><font size='12px'>Celem siatkówki jest zapobieganie upadkowi piłki na podłogę twojego boiska, a aby to osiągnąć, możesz zamienić myszkę w okrągły obiekt, naciskając przycisk <j>[ Space ]<n> Mysz wraca do pierwotnego kształtu po 3 sekundach. Drużyna, która pierwsza zdobędzie 7 punktów, wygrywa!<br>Stwórz swój pokój: <bv><a href='event:roomadmin'>/room *#volley0YourName#0000</a><n><br><br>Komendy (<rose>*<n> = podczas meczu | <vp>*<n> = komendy administratora):<br><br><j>!lang<n> <ch>"..languages.."<n> - Aby zmodyfikować język minigry<br><j>!join<n> <rose>*<n> - Aby dołączyć do meczu<br><j>!leave<n> <rose>*<n> - Aby opuścić mecz i przejść do strefy oglądających<br><j>!resettimer<n> <vp>*<n> - Resetuje czas w lobby przed rozpoczęciem się meczu<br><j>!setmap<n> <ch>[small/large/extra-large]<n> <vp>*<n> - Aby wybrać określoną mapę przed rozpoczęciem meczu<br><j>!pw<n> <ch>[hasło]<n> <vp>*<n> - Ustaw hasło w pokoju"},
    [2] = { text = "<p align='left'><font size='12px'><br><br>Komendy (<rose>*<n> = podczas meczu | <vp>*<n> = komendy administratora):<br><br><j>!winscore<n> <ch>[liczba]<n> <rose>*<n> <vp>*<n> - Zmień maksymalną ilość punktów by wygrać mecz<br><j>!customMap<n> <ch>[true or false]<n> <ch>[map index]<n> <vp>*<n> - Wybierz niestandardową mapę<br><j>!maps<n> - Pokazuje listę map<br><j>!votemap<n> <ch>[liczba]<n> - Głosowanie za niestadardową mapę w następnym meczu<br><j>!setscore<n> <ch>[nazwa gracza]<n> <ch>[liczba]<n> <rose>*<n> <vp>*<n> - Zmień wynik gracza na liczbę<br><j>!setscore<n> <ch>[nazwa gracza]<n> <rose>*<n> <vp>*<n> - Dodaje +1 do wyniku gracza<br><j>!setscore<n> <ch>[red or blue]<n> <ch>[liczba]<n> <rose>*<n> <vp>*<n> - Zmień wynik drużyny<br><j>!4teamsmode<n> <ch>[true or false]<n> <vp>*<n> - Wybierz 4-drużynowy Volley mode"},
    [3] = { text = "<p align='left'><font size='12px'><br><br>Komendy (<rose>*<n> = podczas meczu | <vp>*<n> = komendy administratora)<br><br><j>!setmaxplayers <ch>[6 - 20]<n> <vp>*<n> - Wybierz maksymalną ilość graczy, którzy mogą dołączyć do pokoju<br><j>!balls<n> - Pokazuje listę niestandardowych piłek #Volley<br><j>!customball<n> <ch>[liczba]<n> <vp>*<n> - Wybierz niestandardową piłkę na następny mecz<br><j>!lobby<n> <rose>*<n> <vp>*<n> - Zakończ mecz, który był w trakcie i wróć do lobby<br><j>!setplayerforce<n> <ch>[Number: 0 - 1.05]<n> <vp>*<n> - Wybierz siłę dla okrągłego obiektu myszy<br><j>!2teamsmode<n> <ch>[true or false]<n> <vp>*<n> - Wybierz tryb specjalny dwóch drużyn<br><j>!sync<n> <vp>*<n> - System wybiera gracza z najniższym opóźnieniem, aby zsynchronizować pokój<br><j>!synctfm<n> <vp>*<n> - System TFM wybiera gracza z najniższym opóźnieniem, aby zsynchronizować pokój"},
    [4] = { text = "<p align='left'><font size='12px'><br><br>Komendy (<rose>*<n> = podczas meczu | <vp>*<n> = komendy administratora)<br><br><j>!skiptimer<n> <vp>*<n> - Uruchom grę tak szybko, jak to możliwe<br><j>!afksystem<n> <ch>[true or false]<n> <vp>*<n> - Włącza lub wyłącza system AFK<n><br><j>!settimeafk<n> <ch>[seconds]<n> <vp>*<n> - Wybierz czas AFK w sekundach<br><j>!realmode<n> <ch>[true or false]<n> <vp>*<n> - Wybiera tryb prawdziwej siatkówki<br><j>!twoballs<n> <ch>[true or false] <n> <vp>*<n> - Aktywuje dwie kule w grze<br><j>!consumables<n> <ch>[true or false]<n> <vp>*<n> - Wybierz materiał eksploatacyjny za pomocą klawiszy (7, 8, 9 i 0) i aktywuj je naciskając M w trybie normalnym<br><j>!settings<n> <vp>*<n> - Polecenie wykonania globalnych ustawień w pomieszczeniu<br><j>!setsync<n> <vp>*<n> - Wybiera synchronizację odtwarzacza<br><j>!crown<n> <ch>[true or false]<n> - Włącz/wyłącz obrazy korony"},
    [5] = { text = "<p align='left'><font size='12px'><br><br>Komendy (<rose>*<n> = podczas meczu | <vp>*<n> = komendy administratora)<br><br><j>!profile<n> <vp>*<n> - Pokazuje Twój profil na Volley, możesz także otworzyć swój profil za pomocą klawisza P<br><j>!profile<n> <ch>[playerName#0000]<n> <vp>*<n> - Pokazuje profil wybranego zawodnika w grze Volley"}
  },
  creditsTitle = "<p align='center'><font size='15px'>Credits (Volley)",
  creditsText = "<br><br><p align='left'><font size='12px'>Gra została stworzona przez <j>Refletz#6472 (Soristl)<n><br><br>BR/EN Tłumaczenie: <j>Refletz#6472 (Soristl)<n><br><br>AR Tłumaczenie: <j>Ionut_eric_pro#1679<n><br><br>FR Tłumaczenie: <j>Rowed#4415<n><br><br>PL Tłumaczenie: <j>Prestige#5656<n>",
  messageSetMaxPlayers = "Z maksymalną liczbą graczy umieszczoną dla",
  newPassword = "Nowe hasło:",
  passwordRemoved = "<bv>Hasło usunięte<n>",
  messageMaxPlayersAlert = "<bv>Maksymalna liczba graczy musi wynosić minimum 6, a maksimum 20<n>",
  previousMessage = "<p align='center'>Powrót",
  nextMessage = "<p align='center'>Następny",
  realModeRules = "<p align='center'><font size='15px'>Zasady trybu Volley Real Mode<br><br><p align='left'><font size='12px'><b>- Każda drużyna może się zmienić <b>transform</b> w <vi>okrągły obiekt<n> tylko 3 razy (nielicząc <b>serwa</b> który jest tylko raz)<br><br>- Jeśli piłka wyląduje poza boiskiem po stronie twojego zespołu i <b>nikt</b> z twojej drużyny nie przekształcił się w <vi>okrągły obiekt<n> wtedy punkt jest zdobyty przez twoją drużynę<br><br>- Jeśli piłka wylądowała poza boiskiem i ktoś z twojej drużyny <b>zmienił się w</b> <vi><b>okrągły obiekt<b><n> wtedy punkt należy do drużyny przeciwnej<br><br>- Każdy z graczy serwuje raz <br><br>- Jeśli zawodnik opuści boisko, będzie mógł wykonać akcję przez <j>7 sekund<n>, w przeciwnym razie zawodnik nie będzie mógł użyć <j>klawiszu spacji<n><br><br>- Klawisze 1, 2, 3 i 4 zmieniają siłę gracza",
  titleSettings = "<p align='center'><font size='15px'>Ustawienia pokoju</p>",
  textSettings = "<p align='left'><font size='12px'>Wybierz tryb gry<br><br><br><br><br><br><br><br><br><br>Aktywuj !twoballs dowodzenie</p>",
  msgAchievements = "<p align='left'><font size='14px'>Osiągnięcia:",
  msgsTrophies = {
    [1] = "Trofeum Pucharu Świata w siatkówce",
    [2] = "FootVolley Ultimate Team Badge"
  },
  mapSelect = 'Wybierz mapę'
}

if tfm.get.room.language == "br" then
  trad = lang.br
elseif tfm.get.room.language == "en" then
  trad = lang.en
elseif tfm.get.room.language == "ar" then
  trad = lang.ar
elseif tfm.get.room.language == "fr" then
  trad = lang.fr
elseif tfm.get.room.language == "pl" then
  trad = lang.pl
else
  trad = lang.en
end

local regex = "#volley%d+([%+_]*[%w_#]+)"
local getRoomAdmin = string.match(tfm.get.room.name, regex)

if getRoomAdmin ~= nil then
  admins[getRoomAdmin] = true
else
  getRoomAdmin = ""
end

tfm.exec.disableAutoShaman(true)
tfm.exec.disableAutoNewGame(true)
tfm.exec.disableAutoScore (true)
tfm.exec.disableAutoTimeLeft (true)
tfm.exec.disablePhysicalConsumables (true)
tfm.exec.disableAfkDeath (true)
tfm.exec.setRoomMaxPlayers(16)
system.disableChatCommandDisplay (nil, true)
tfm.exec.disableMortCommand(true)

local playerCanTransform = {}
local playerForce = {}
local playerBan = {}
local playerBanHistory = {}
local playersAfk = {}
local playerInGame = {}
local countId = 1
local playerPhysicId = {}
local playerLanguage = {}
local killSpecPermanent = false

local customMaps = {
  [1] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="9" X="382" Y="190" L="15" H="102" P="0,0,0,0,0,0,0,0"/><S T="9" X="418" Y="190" L="15" H="102" P="0,0,0,0,0,0,0,0"/><S T="9" X="458" Y="190" L="15" H="102" P="0,0,0,0,0,0,0,0"/><S T="9" X="342" Y="190" L="15" H="102" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="9" X="582" Y="192" L="15" H="102" P="0,0,0,0,0,0,0,0"/><S T="9" X="618" Y="192" L="15" H="102" P="0,0,0,0,0,0,0,0"/><S T="9" X="658" Y="192" L="15" H="102" P="0,0,0,0,0,0,0,0"/><S T="9" X="542" Y="192" L="15" H="102" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Water barrier',
    [4] = 'Refletz#6472',
    [6] = '19554042aaf.png'
  },
  [2] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="100" Y="140" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="150" Y="180" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="650" Y="180" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="700" Y="140" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="150" Y="140" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="200" Y="180" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="1050" Y="140" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="1000" Y="180" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Circle grounds on the sky',
    [4] = 'Refletz#6472',
    [6] = '1955400e807.png'
  },
  [3] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="2" X="25" Y="330" L="60" H="10" P="0,0,0,1,45,0,0,0"/><S T="2" X="20" Y="115" L="60" H="10" P="0,0,0,1,-45,0,0,0"/><S T="2" X="775" Y="330" L="60" H="10" P="0,0,0,1,-45,0,0,0"/><S T="2" X="780" Y="115" L="60" H="10" P="0,0,0,1,45,0,0,0"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="2" X="13" Y="103" L="10" H="30" P="0,0,0,1.2,45,0,0,0"/><S T="2" X="3" Y="93" L="20" H="10" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="787" Y="103" L="10" H="30" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="797" Y="93" L="20" H="10" P="0,0,0,1.2,45,0,0,0"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="2" X="25" Y="330" L="60" H="10" P="0,0,0,1.2,45,0,0,0"/><S T="2" X="20" Y="115" L="60" H="10" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="1175" Y="330" L="60" H="10" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="1170" Y="115" L="60" H="10" P="0,0,0,1.2,45,0,0,0"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="2" X="13" Y="103" L="10" H="30" P="0,0,0,1.2,45,0,0,0"/><S T="2" X="3" Y="93" L="20" H="10" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="1187" Y="103" L="10" H="30" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="1197" Y="93" L="20" H="10" P="0,0,0,1.2,45,0,0,0"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Trampoline on the edges',
    [4] = 'Refletz#6472',
    [6] = '19554039e06.png'
  },
  [4] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="12" X="100" Y="150" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="300" Y="150" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="100" Y="250" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="300" Y="250" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="700" Y="150" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="500" Y="150" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="700" Y="250" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="500" Y="250" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="100" Y="150" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="500" Y="150" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="300" Y="150" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="100" Y="250" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="300" Y="250" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="500" Y="250" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1100" Y="150" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="900" Y="150" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="700" Y="150" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="700" Y="250" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="900" Y="250" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1100" Y="250" L="144" H="50" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Invisible rectangles',
    [4] = 'Refletz#6472',
    [6] = '19554020158.png'
  },
  [5] = {
    [1] = '<C><P F="3" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="390" Y="-763" L="3000" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="1" X="-80" Y="235" L="125" H="10" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="1" X="-30" Y="160" L="30" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-75" Y="195" L="120" H="70" P="0,0,0,0,0,0,0,0"/><S T="1" X="-50" Y="-236" L="10" H="800" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="-120" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="-84" Y="-704" L="300" H="11" P="0,0,0,0.1,-20,0,0,0"/><S T="9" X="-90" Y="-194" L="80" H="760" P="0,0,0,0,0,0,0,0"/><S T="12" X="-5" Y="1730" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="-232" L="10" H="790" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="-21" Y="-632" L="46" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-129" Y="-693" L="190" H="127" P="0,0,0,0,0,0,0,0"/><S T="12" X="805" Y="1730" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="880" Y="235" L="125" H="10" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="9" X="875" Y="195" L="120" H="70" P="0,0,0,0,0,0,0,0"/><S T="9" X="880" Y="-194" L="80" H="760" P="0,0,0,0,0,0,0,0"/><S T="12" X="920" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="830" Y="160" L="30" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="850" Y="-236" L="10" H="800" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="805" Y="-232" L="10" H="790" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="844" Y="-704" L="300" H="11" P="0,0,0,0.1,20,0,0,0"/><S T="9" X="929" Y="-693" L="190" H="127" P="0,0,0,0,0,0,0,0"/><S T="1" X="821" Y="-632" L="46" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-92" Y="-602" L="80" H="35" P="0,0,0,0,0,0,0,0"/><S T="9" X="892" Y="-602" L="80" H="35" P="0,0,0,0,0,0,0,0"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="1205" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-763" L="3000" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="-80" Y="235" L="125" H="10" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="1" X="-30" Y="160" L="30" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-75" Y="195" L="120" H="70" P="0,0,0,0,0,0,0,0"/><S T="1" X="-50" Y="-236" L="10" H="800" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="-120" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="-84" Y="-704" L="300" H="11" P="0,0,0,0.1,-20,0,0,0"/><S T="9" X="-90" Y="-194" L="80" H="760" P="0,0,0,0,0,0,0,0"/><S T="12" X="-5" Y="1730" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="-232" L="10" H="790" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="-21" Y="-632" L="46" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-129" Y="-693" L="190" H="127" P="0,0,0,0,0,0,0,0"/><S T="9" X="1275" Y="195" L="120" H="70" P="0,0,0,0,0,0,0,0"/><S T="1" X="1280" Y="235" L="125" H="10" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="-5" Y="1730" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1205" Y="1730" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1205" Y="-232" L="10" H="790" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="1230" Y="160" L="30" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="1250" Y="-236" L="10" H="800" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="1320" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="9" X="1290" Y="-194" L="80" H="760" P="0,0,0,0,0,0,0,0"/><S T="1" X="1221" Y="-632" L="46" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="1329" Y="-693" L="190" H="127" P="0,0,0,0,0,0,0,0"/><S T="1" X="1284" Y="-704" L="300" H="11" P="0,0,0,0.1,20,0,0,0"/><S T="9" X="-92" Y="-602" L="80" H="35" P="0,0,0,0,0,0,0,0"/><S T="9" X="1292" Y="-602" L="80" H="35" P="0,0,0,0,0,0,0,0"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Water cannon',
    [4] = 'Refletz#6472',
    [6] = '19554044221.png'
  },
  [6] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Default',
    [4] = 'Refletz#6472',
    [6] = '19539e5756b.png'
  },
  [7] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="14,1;;;;-0;0:::1-"/><Z><S><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="1" X="400" Y="137" L="80" H="10" P="1,0,0,0.2,0,0,0,0"/><S T="1" X="400" Y="400" L="800" H="100" P="0,0,0,0.2,0,0,0,0" c="3" N=""/></S><D><P X="0" Y="0" T="138" P="0,0"/><P X="102" Y="357" T="258" P="1,0"/><P X="699" Y="357" T="258" P="1,0"/><DS X="360" Y="-151"/></D><O><O X="400" Y="137" C="12" P="0"/></O><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="14,1;;;;-0;0:::1-"/><Z><S><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="600" Y="400" L="1200" H="100" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="1" X="600" Y="137" L="80" H="10" P="1,0,0,0.2,0,0,0,0"/></S><D><P X="299" Y="365" T="258" P="1,0"/><P X="899" Y="365" T="258" P="1,0"/><P X="0" Y="0" T="138" P="0,0"/><P X="1200" Y="0" T="138" P="0,1"/><DS X="365" Y="-141"/></D><O><O X="600" Y="137" C="12" P="0"/></O><L/></Z></C>',
    [3] = 'Ice barrier',
    [4] = '+Mimounaaa#0000',
    [6] = '1955401d276.png'
  },
  [8] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="14,1;;;;-0;0:::1-"/><Z><S><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="4" X="400" Y="400" L="800" H="100" P="0,0,9999,0.2,0,0,0,0" c="3" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="14,1;;;;-0;0:::1-"/><Z><S><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="4" X="600" Y="400" L="1200" H="100" P="0,0,9999,0.2,0,0,0,0" c="3" N=""/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'The floor is chocolate',
    [4] = 'Refletz#6472',
    [6] = '1955402f9ee.png'
  },
  [9] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="16,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="401" Y="310" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="16,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="310" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'No jump',
    [4] = 'Deteraprio#4457',
    [6] = '19539e5756b.png'
  },
  [10] = {
    [1] = '<C><P F="0" G="0,4" C="" MEDATA="14,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="1" X="400" Y="173" L="10" H="150" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="1" X="400" Y="173" L="10" H="150" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="1" X="400" Y="180" L="10" H="160" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="1" X="0" Y="220" L="10" H="305" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="1" X="800" Y="220" L="10" H="305" P="0,0,0,0,0,0,0,0" c="3" m=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" C="" MEDATA="16,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="1" X="600" Y="180" L="10" H="160" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="1" X="0" Y="220" L="10" H="305" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="1" X="1200" Y="242" L="10" H="305" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="3" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Collision',
    [4] = 'Deteraprio#4457',
    [6] = '19539e5756b.png'
  },
  [11] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="16,1;;;;-0;0::0,1,2,3,4,5,6,7,0,0,0,0:1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="8" X="400" Y="225" L="720" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="8" X="400" Y="150" L="720" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3"/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="0" X="400" Y="180" L="10" H="150" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="8" X="755" Y="186" L="10" H="67" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="8" X="45" Y="186" L="10" H="67" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="8" X="0" Y="230" L="10" H="260" P="1,0,1.5,0,90,0,0,0" c="3" m="" tint="FF0000"/><S T="8" X="800" Y="230" L="10" H="260" P="1,0,1.5,0,90,0,0,0" c="3" m="" tint="FF0000"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L><JD c="ffffff,4,0.9,1" P1="0,301.42" P2="-5,308.07"/><JD c="ffffff,4,0.9,1" P1="0.44,281.48" P2="-5,288.13"/><JD c="ffffff,4,0.9,1" P1="0,301.74" P2="4.75,308.39"/><JD c="ffffff,4,0.9,1" P1="800,302" P2="805,308"/><JD c="ffffff,4,0.9,1" P1="800,281" P2="805,288"/><JD c="ffffff,4,0.9,1" P1="800,281" P2="795,288"/><JD c="ffffff,4,0.9,1" P1="800,301" P2="795,308"/><JD c="ffffff,4,0.9,1" P1="0,281.49" P2="5,288"/><JP M1="27" AXIS="-1,0" MV="Infinity,13.333333333333334"/><JP M1="27" AXIS="0,1"/><JP M1="28" AXIS="-1,0" MV="Infinity,13.333333333333334"/><JP M1="28" AXIS="0,1"/></L></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="16,1;;;;-0;0::0,1,2,3,4,5,6,7,0,0,0,0:1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="8" X="600" Y="225" L="1120" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="8" X="600" Y="150" L="1120" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="8" X="1155" Y="186" L="10" H="67" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="8" X="0" Y="230" L="10" H="260" P="1,0,1.5,0,90,0,0,0" c="3" m="" tint="FF0000"/><S T="8" X="1200" Y="230" L="10" H="260" P="1,0,1.5,0,90,0,0,0" c="3" m="" tint="FF0000"/><S T="8" X="45" Y="186" L="10" H="67" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="180" L="10" H="150" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L><JD c="ffffff,4,0.9,1" P1="0,281" P2="5,288"/><JD c="ffffff,4,0.9,1" P1="0,281" P2="-5,288"/><JD c="ffffff,4,0.9,1" P1="0,301" P2="-5,308"/><JD c="ffffff,4,0.9,1" P1="1200,301" P2="1205,308"/><JD c="ffffff,4,0.9,1" P1="1200,301" P2="1195,308"/><JD c="ffffff,4,0.9,1" P1="0,301" P2="5,308"/><JD c="ffffff,4,0.9,1" P1="1200,281" P2="1195,288"/><JD c="ffffff,4,0.9,1" P1="1200,281" P2="1205,288"/><JP M1="25" AXIS="-1,0" MV="Infinity,13.333333333333334"/><JP M1="25" AXIS="0,1"/><JP M1="26" AXIS="-1,0" MV="Infinity,13.333333333333334"/><JP M1="26" AXIS="0,1"/></L></Z></C>',
    [3] = 'Top player',
    [4] = 'Deteraprio#4457',
    [6] = '195540357b1.png'
  },
  [12] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="0,1;;;;-0;0:::1-"/><Z><S><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="7" X="400" Y="420" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="7" X="140" Y="369" L="500" H="146" P="0,0,0.5,0.2,17,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="7" X="660" Y="369" L="500" H="146" P="0,0,0.5,0.2,-17,0,0,0" c="3" N=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="400" Y="185" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="220" L="10" H="70" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="12" X="874" Y="329" L="148" H="162" P="0,0,0.3,0.2,0,0,0,0" o="6A7495" c="4" N=""/><S T="12" X="911" Y="281" L="148" H="162" P="0,0,0.3,0.2,-30,0,0,0" o="6A7495" c="4" N=""/><S T="12" X="-74" Y="329" L="148" H="162" P="0,0,0.3,0.2,0,0,0,0" o="6A7495" c="4" N=""/><S T="12" X="-110" Y="281" L="148" H="162" P="0,0,0.3,0.2,30,0,0,0" o="6A7495" c="4" N=""/><S T="7" X="400" Y="385" L="19" H="30" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/></S><D><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="0,1;;;;-0;0:::1-"/><Z><S><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1205" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" N=""/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="7" X="600" Y="420" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="7" X="985" Y="364" L="750" H="146" P="0,0,0.5,0.2,-12,0,0,0" c="3" N=""/><S T="7" X="215" Y="364" L="750" H="146" P="0,0,0.5,0.2,12,0,0,0" c="3" N=""/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="185" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="220" L="10" H="70" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="-90" Y="326" L="179" H="167" P="0,0,0.3,0.2,0,0,0,0" o="6A7495" c="4" N=""/><S T="12" X="-122" Y="269" L="179" H="167" P="0,0,0.3,0.2,30,0,0,0" o="6A7495" c="4" N=""/><S T="12" X="1289" Y="326" L="179" H="168" P="0,0,0.3,0.2,0,0,0,0" o="6A7495" c="4" N=""/><S T="12" X="1323" Y="271" L="179" H="168" P="0,0,0.3,0.2,-30,0,0,0" o="6A7495" c="4" N=""/><S T="7" X="600" Y="385" L="19" H="30" P="0,0,0.1,0.2,0,0,0,0" c="2" N=""/></S><D><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'inclined',
    [4] = 'Deteraprio#4457',
    [6] = '1955401e9e8.png'
  },
  [13] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="18,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="2" X="400" Y="102" L="370" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="2" X="710" Y="102" L="190" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="2" X="90" Y="102" L="190" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="0" X="180" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="220" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="200" Y="-65" L="10" H="50" P="0,0,0.3,0.2,90,0,0,0" c="2" m=""/><S T="0" X="580" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="620" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="600" Y="-65" L="10" H="50" P="0,0,0.3,0.2,90,0,0,0" c="2" m=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="17,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="2" X="190" Y="102" L="390" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="2" X="1005" Y="102" L="380" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="2" X="600" Y="102" L="370" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="0" X="380" Y="20" L="10" H="160" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="780" Y="20" L="10" H="160" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="420" Y="20" L="10" H="160" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="820" Y="20" L="10" H="160" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="400" Y="-65" L="50" H="10" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="800" Y="-65" L="50" H="10" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Trambolines in the sky',
    [4] = 'Kralizmox#0000',
    [6] = '19554036f23.png'
  },
  [14] = {
    [1] = '<C><P F="2" G="0,4" MEDATA="15,1;;;;-0;0::0,0,0,0:1-"/><Z><S><S T="1" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="2" X="30" Y="225" L="10" H="80" P="1,987654,0,1.2,45,0,0,0"/><S T="2" X="770" Y="225" L="10" H="80" P="1,987654,0,1.2,-45,0,0,0"/><S T="2" X="370" Y="330" L="10" H="50" P="1,987654,0,1.2,-45,0,0,0" c="2"/><S T="2" X="430" Y="330" L="10" H="50" P="1,987654,0,1.2,45,0,0,0" c="2"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L><JR M2="23" MV="Infinity,6.283185307179586"/><JR M2="24" MV="Infinity,-6.283185307179586"/><JR M2="25" MV="Infinity,6.283185307179586"/><JR M2="26" MV="Infinity,-6.283185307179586"/></L></Z></C>',
    [2] = '<C><P L="1200" F="2" G="0,4" MEDATA="15,1;;;;-0;0::0,0,0,0:1-"/><Z><S><S T="1" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="2" X="570" Y="330" L="10" H="50" P="1,987654,0,1.2,-45,0,0,0" c="2"/><S T="2" X="630" Y="330" L="10" H="50" P="1,987654,0,1.2,45,0,0,0" c="2"/><S T="2" X="30" Y="225" L="10" H="80" P="1,987654,0,1.2,45,0,0,0"/><S T="2" X="1170" Y="225" L="10" H="80" P="1,987654,0,1.2,-45,0,0,0"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L><JR M2="23" MV="Infinity,6.283185307179586"/><JR M2="24" MV="Infinity,-6.283185307179586"/><JR M2="25" MV="Infinity,6.283185307179586"/><JR M2="26" MV="Infinity,-6.283185307179586"/></L></Z></C>',
    [3] = 'Rotating trampolines',
    [4] = 'Artgir#0000',
    [6] = '19554029c25.png'
  },
  [15] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="9" X="400" Y="150" L="30" H="150" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="600" Y="150" L="30" H="150" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Black water',
    [4] = 'Asdfghjkkk#8564',
    [6] = '1955400b924.png'
  },
  [16] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="12,1;;;;-0;0::0:1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="399" Y="225" L="675" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="399" Y="695" L="675" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="393" Y="464" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="390" Y="-763" L="3000" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="1" X="-80" Y="235" L="125" H="10" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="1" X="-30" Y="160" L="30" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-75" Y="195" L="120" H="70" P="0,0,0,0,0,0,0,0"/><S T="1" X="-50" Y="-236" L="10" H="800" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="-120" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="-84" Y="-704" L="300" H="11" P="0,0,0,0.1,-20,0,0,0"/><S T="9" X="-90" Y="-194" L="80" H="760" P="0,0,0,0,0,0,0,0"/><S T="12" X="-5" Y="1732" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="-232" L="10" H="790" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="-21" Y="-632" L="46" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-129" Y="-693" L="190" H="127" P="0,0,0,0,0,0,0,0"/><S T="12" X="805" Y="1730" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="880" Y="235" L="125" H="10" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="9" X="875" Y="195" L="120" H="70" P="0,0,0,0,0,0,0,0"/><S T="12" X="920" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="830" Y="160" L="30" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="850" Y="-236" L="10" H="800" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="805" Y="-232" L="10" H="790" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="844" Y="-704" L="300" H="11" P="0,0,0,0.1,20,0,0,0"/><S T="9" X="929" Y="-693" L="190" H="127" P="0,0,0,0,0,0,0,0"/><S T="9" X="880" Y="-194" L="80" H="760" P="0,0,0,0,0,0,0,0"/><S T="1" X="821" Y="-632" L="46" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-92" Y="-602" L="80" H="35" P="0,0,0,0,0,0,0,0"/><S T="9" X="892" Y="-602" L="80" H="35" P="0,0,0,0,0,0,0,0"/><S T="1" X="401" Y="137" L="10" H="85" P="1,987654,0,0.2,0,0,0,0"/><S T="2" X="28" Y="320" L="10" H="72" P="0,0,0,1.2,-40,0,0,0"/><S T="2" X="773" Y="320" L="10" H="72" P="0,0,0,1.2,40,0,0,0"/><S T="8" X="399" Y="163" L="669" H="11" P="0,0,0.3,0.2,0,0,0,0" c="3"/><S T="0" X="66" Y="192" L="10" H="69" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="737" Y="191" L="10" H="69" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="13" X="139" Y="219" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="101" Y="176" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="703" Y="176" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="665" Y="220" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="12" X="262" Y="250" L="160" H="60" P="0,0,0.3,0.2,0,0,0,0" o="50546F" c="4" N=""/><S T="12" X="539" Y="250" L="160" H="60" P="0,0,0.3,0.2,0,0,0,0" o="50546F" c="4" N=""/><S T="8" X="490" Y="131" L="10" H="76" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="4" X="304" Y="380" L="193" H="63" P="0,0,20,0.2,0,0,0,0" c="3" N=""/><S T="8" X="314" Y="129" L="10" H="76" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="4" X="495" Y="380" L="193" H="63" P="0,0,20,0.2,0,0,0,0" c="3" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="396" Y="77"/></D><O/><L><JR M2="42" MV="Infinity,0.5235987755982988"/></L></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="14,1;;;;-0;0::0:1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="12" X="-9" Y="2" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1205" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="599" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="0" X="603" Y="225" L="1048" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="885" L="1048" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-763" L="3000" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="1" X="-80" Y="235" L="125" H="10" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="1" X="-30" Y="160" L="30" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-76" Y="195" L="120" H="70" P="0,0,0,0,0,0,0,0"/><S T="1" X="-50" Y="-236" L="10" H="800" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="-120" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="-84" Y="-704" L="300" H="11" P="0,0,0,0.1,-20,0,0,0"/><S T="9" X="-90" Y="-194" L="80" H="760" P="0,0,0,0,0,0,0,0"/><S T="12" X="-5" Y="1730" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="-232" L="10" H="790" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="-21" Y="-632" L="46" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-129" Y="-693" L="190" H="127" P="0,0,0,0,0,0,0,0"/><S T="9" X="1275" Y="195" L="120" H="70" P="0,0,0,0,0,0,0,0"/><S T="1" X="1280" Y="235" L="125" H="10" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="1204" Y="1729" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="1730" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1205" Y="-232" L="10" H="790" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="1230" Y="160" L="30" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="1250" Y="-236" L="10" H="800" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="1320" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="9" X="1290" Y="-194" L="80" H="760" P="0,0,0,0,0,0,0,0"/><S T="1" X="1221" Y="-632" L="46" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="1329" Y="-693" L="190" H="127" P="0,0,0,0,0,0,0,0"/><S T="1" X="1284" Y="-704" L="300" H="11" P="0,0,0,0.1,20,0,0,0"/><S T="8" X="603" Y="168" L="1037" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3"/><S T="0" X="85" Y="194" L="10" H="62" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="9" X="-92" Y="-602" L="80" H="35" P="0,0,0,0,0,0,0,0"/><S T="9" X="1292" Y="-602" L="80" H="35" P="0,0,0,0,0,0,0,0"/><S T="2" X="29" Y="316" L="10" H="84" P="0,0,0,1.2,-40,0,0,0"/><S T="13" X="198" Y="221" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="2" X="1170" Y="316" L="10" H="84" P="0,0,0,1.2,-140,0,0,0"/><S T="4" X="600" Y="379" L="587" H="58" P="0,0,20,0.2,0,0,0,0" c="3" N=""/><S T="0" X="1121" Y="196" L="10" H="62" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="13" X="162" Y="176" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="162" Y="176" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="1043" Y="175" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="1007" Y="219" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="1" X="600" Y="137" L="10" H="85" P="1,987654,0,0.2,0,0,0,0"/><S T="12" X="759" Y="252" L="188" H="53" P="0,0,0.3,0.2,0,0,0,0" o="50546F" c="4" N=""/><S T="8" X="685" Y="129" L="10" H="74" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="8" X="513" Y="130" L="10" H="74" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="12" X="438" Y="252" L="188" H="53" P="0,0,0.3,0.2,0,0,0,0" o="50546F" c="4" N=""/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="604" Y="70"/></D><O/><L><JR M2="55" MV="Infinity,0.5235987755982988"/></L></Z></C>',
    [3] = 'Chaos',
    [4] = 'Raf02#4942',
    [6] = '1955400d095.png'
  },
  [17] = {
    [1] = '<C><P F="4" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="399" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="15" X="521" Y="300" L="12" H="99" P="0,0,0,0,0,0,0,0"/><S T="15" X="120" Y="300" L="12" H="99" P="0,0,0,0,0,0,0,0"/><S T="15" X="680" Y="300" L="12" H="99" P="0,0,0,0,0,0,0,0"/><S T="15" X="279" Y="300" L="12" H="99" P="0,0,0,0,0,0,0,0"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><P X="694" Y="74" T="111" P="0,0"/><P X="503" Y="154" T="179" P="0,0"/><DS X="360" Y="-151"/></D><O><O X="1255" Y="455" C="12" P="0"/><O X="1147" Y="501" C="12" P="0"/></O><L/></Z></C>',
    [2] = '<C><P L="1200" F="4" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="15" X="486" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="1087" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="116" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="717" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="299" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="900" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><P X="707" Y="159" T="179" P="0,0"/><P X="308" Y="4" T="107" P="0,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Cowebs',
    [4] = 'Hxejss#7104',
    [6] = '1955400ff78.png'
  },
  [18] = {
    [1] = '<C><P G="0,4" mc="" MEDATA="14,1;;;;-0;0::0,1,2,3,4,5,6:1-"/><Z><S><S T="3" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="400" Y="200" L="800" H="400" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="3" X="200" Y="495" L="30" H="30" P="1,0,0,1,0,1,0,0" c="2" nosync=""/><S T="3" X="600" Y="495" L="30" H="30" P="1,0,0,1,0,1,0,0" c="2" nosync=""/><S T="3" X="200" Y="495" L="30" H="30" P="1,0,0,1,45,1,0,0" c="2" nosync=""/><S T="3" X="600" Y="495" L="30" H="30" P="1,0,0,1,45,1,0,0" c="2" nosync=""/><S T="12" X="400" Y="640" L="40" H="40" P="1,100000,0.3,0.2,0,1,0,0" o="324650" c="4" m=""/><S T="12" X="400" Y="935" L="10" H="10" P="1,999999,0.3,0.2,0,0,0,0" o="324650" c="4" m="" nosync=""/></S><D><P X="99" Y="440" T="44" P="1,0"/><P X="699" Y="440" T="44" P="1,0"/><DS X="360" Y="-151"/></D><O><O X="400" Y="750" C="11" P="0"/><O X="200" Y="495" C="22" P="0"/><O X="600" Y="495" C="22" P="0"/></O><L><JR M1="22" M2="26"/><JR M1="23" M2="26"/><JR M1="24" M2="26"/><JR M1="25" M2="26"/><JP M1="26" AXIS="0,1"/><JR M1="27" P1="400,750" MV="Infinity,-0.5"/><JD M1="26" M2="27"/></L></Z></C>',
    [2] = '<C><P L="1200" G="0,4" mc="" MEDATA="14,1;;;;-0;0::0,1,2,3,4,5,6:1-"/><Z><S><S T="3" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="600" Y="198" L="1200" H="400" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="470" L="3000" H="140" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="3" X="300" Y="505" L="45" H="45" P="1,0,0,1,0,1,0,0" c="2" grav="2.5" nosync=""/><S T="3" X="900" Y="505" L="45" H="45" P="1,0,0,1,0,1,0,0" c="2" grav="2.5" nosync=""/><S T="3" X="300" Y="505" L="45" H="45" P="1,0,0,1,45,1,0,0" c="2" grav="2.5" nosync=""/><S T="3" X="900" Y="505" L="45" H="45" P="1,0,0,1,45,1,0,0" c="2" grav="2.5" nosync=""/><S T="12" X="600" Y="640" L="40" H="40" P="1,100000,0.3,0.2,0,1,0,0" o="324650" c="4" grav="2.5" m="" nosync=""/><S T="12" X="600" Y="935" L="10" H="10" P="1,999999,0.3,0.2,0,0,0,0" o="324650" c="4" grav="2.5" m="" nosync=""/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="899" Y="440" T="44" P="1,0"/><P X="299" Y="440" T="44" P="1,0"/><DS X="365" Y="-141"/></D><O><O X="600" Y="750" C="11" P="0"/><O X="300" Y="505" C="22" P="0"/><O X="900" Y="505" C="22" P="0"/></O><L><JR M1="22" M2="26"/><JR M1="23" M2="26"/><JR M1="24" M2="26"/><JR M1="25" M2="26"/><JP M1="26" AXIS="0,1"/><JR M1="27" P1="600,750" MV="Infinity,-0.5"/><JD M1="26" M2="27"/></L></Z></C>',
    [3] = 'The floor is lava',
    [4] = 'Kralizmox#0000',
    [6] = '195540328d1.png'
  },
  [19] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="14,1;;;;-0;0:::1-"/><Z><S><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="9" X="400" Y="150" L="30" H="150" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/><S T="4" X="400" Y="400" L="800" H="100" P="0,0,370,0,0,0,0,0" c="3" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="14,1;;;;-0;0:::1-"/><Z><S><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="600" Y="150" L="30" H="150" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/><S T="4" X="600" Y="400" L="1200" H="100" P="0,0,370,0,0,0,0,0" c="3" N=""/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Black water with chocolate floor',
    [4] = 'Asdfghjkkk#8564',
    [6] = '1955400a1b1.png'
  },
  [20] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="2" X="111" Y="137" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="696" Y="137" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="401" Y="95" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="401" Y="174" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="2" X="601" Y="95" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="601" Y="174" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="200" Y="137" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="1000" Y="137" L="19" H="19" P="0,0,0,1.2,45,0,0,0"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Trampoline rhombuses',
    [4] = 'Ppoppohaejuseyo#2315',
    [6] = '19554038694.png'
  },
  [21] = {
    [1] = '<C><P F="2" G="0,4" MEDATA="25,1;;;;-0;0:::1-"/><Z><S><S T="20" X="400" Y="400" L="800" H="100" P="0,0,100,0.2,0,0,0,0" c="3" N="" friction="100,20"/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0.01,0.2,0,0,0,0"/><S T="1" X="759" Y="228" L="73" H="32" P="0,0,0.01,0.2,50,0,0,0"/><S T="1" X="793" Y="101" L="73" H="32" P="0,0,0,0.2,-60,0,0,0"/><S T="0" X="400" Y="144" L="801" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="1" X="7" Y="101" L="73" H="32" P="0,0,0,0.2,60,0,0,0"/><S T="1" X="41" Y="228" L="73" H="32" P="0,0,0.01,0.2,-50,0,0,0"/><S T="1" X="71" Y="172" L="75" H="32" P="0,0,0.01,0.2,-80,0,0,0"/><S T="1" X="-5" Y="234" L="97" H="245" P="0,0,0.01,0.2,20,0,0,0"/><S T="1" X="729" Y="172" L="75" H="32" P="0,0,0.01,0.2,80,0,0,0"/><S T="1" X="805" Y="234" L="97" H="245" P="0,0,0.01,0.2,-20,0,0,0"/><S T="1" X="292" Y="305" L="10" H="135" P="0,0,0.01,0.2,-15,0,0,0"/><S T="1" X="509" Y="305" L="10" H="135" P="0,0,0.01,0.2,15,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-50" Y="0" L="102" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="852" Y="2" L="106" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="400" Y="200" L="10" H="109" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/></S><D><P X="663" Y="91" T="287" P="0,0"/><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="2" G="0,4" MEDATA="25,1;;;;-0;0:::1-"/><Z><S><S T="20" X="600" Y="400" L="1200" H="100" P="0,0,500,0.2,0,0,0,0" c="3" N="" friction="100,20"/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="1203" Y="107" L="79" H="35" P="0,0,0,0.2,-50,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0.01,0.2,0,0,0,0"/><S T="1" X="413" Y="323" L="10" H="209" P="0,0,0.01,0.2,-20,0,0,0"/><S T="1" X="788" Y="323" L="10" H="209" P="0,0,0.01,0.2,20,0,0,0"/><S T="1" X="1203" Y="227" L="103" H="223" P="0,0,0.01,0.2,-20,0,0,0"/><S T="1" X="59" Y="176" L="79" H="35" P="0,0,0.01,0.2,-80,0,0,0"/><S T="1" X="1145" Y="176" L="79" H="35" P="0,0,0.01,0.2,80,0,0,0"/><S T="1" X="1" Y="107" L="79" H="35" P="0,0,0,0.2,50,0,0,0"/><S T="1" X="31" Y="232" L="79" H="35" P="0,0,0.01,0.2,-50,0,0,0"/><S T="1" X="1173" Y="232" L="79" H="35" P="0,0,0.01,0.2,50,0,0,0"/><S T="1" X="-8" Y="227" L="103" H="223" P="0,0,0.01,0.2,20,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-68" Y="0" L="137" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1265" Y="0" L="132" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="136" L="1202" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="199" L="10" H="111" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><P X="886" Y="8" T="288" P="0,0"/><P X="690" Y="92" T="287" P="0,0"/><P X="192" Y="-23" T="220" P="0,0"/><P X="1022" Y="35" T="221" P="0,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Honeymoon',
    [4] = 'Wnawn#0000',
    [6] = '19554018c22.png'
  },
  [22] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="9" X="400" Y="194" L="30" H="60" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="600" Y="194" L="30" H="60" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Black water (small)',
    [4] = 'Asdfghjkkk#8564',
    [6] = '19554008a40.png'
  },
  [23] = {
    [1] = '<C><P F="3" MEDATA="24,1;;;;-0;0:::1-" G="0,4" /><Z><S><S L="800" H="10" X="400" Y="449" T="9" P="0,0,0,0,0,0,0,0" /><S L="10" H="100" X="400" Y="305" T="1" P="0,0,0,0.2,0,0,0,0" /><S L="800" o="6a7495" H="10" X="400" Y="455" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S L="10" o="6a7495" H="3000" X="-5" N="" Y="0" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S L="10" o="6a7495" H="3000" X="805" N="" Y="0" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S H="10" L="10" o="202B4D" X="100" c="3" Y="359" T="13" P="0,0,0.3,0.2,0,0,0,0" /><S H="10" L="10" o="16143C" X="700" c="3" Y="359" T="13" P="0,0,0.3,0.2,0,0,0,0" /><S c="4" L="100" o="324650" H="105" X="50" Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="800" H="10" X="400" N="" Y="0" T="1" P="0,0,0,0.2,0,0,0,0" /><S c="3" L="800" H="10" X="400" N="" Y="95" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="10" H="100" X="105" Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="10" H="100" X="699" N="" Y="50" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="800" H="10" X="401" Y="225" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="10" H="35" X="400" Y="237" T="0" m="" P="0,0,0,0,0,0,0,0" /><S L="839" H="10" X="400" Y="772" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" /><S c="3" L="20" o="6a7495" H="200" X="316" Y="-129" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S c="3" L="20" o="6a7495" H="200" X="407" Y="-133" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S c="3" L="20" o="6a7495" H="100" X="363" Y="-92" T="12" P="0,0,0.2,0.2,90,0,0,0" /><S c="3" L="20" o="6a7495" H="100" X="360" Y="-206" T="12" P="0,0,0.2,0.2,90,0,0,0" /><S c="4" L="3000" o="6a7495" H="196" X="418" N="" Y="496" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S c="4" L="3000" o="6a7495" H="120" X="870" N="" Y="174" T="12" P="0,0,0.3,0.2,90,0,0,0" /><S c="4" L="3000" o="6a7495" H="120" X="-66" N="" Y="299" T="12" P="0,0,0.3,0.2,90,0,0,0" /><S c="4" L="100" o="324650" H="105" X="750" Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S L="800" H="10" X="400" N="" Y="-800" T="1" P="0,0,0,0.2,0,0,0,0" /><S c="3" L="809" H="50" X="400" N="" Y="376" T="8" P="0,0,0.3,0.2,0,0,0,0" /><S L="10" H="85" X="369" Y="121" T="2" P="0,0,0,1.2,50,0,0,0" /><S L="10" H="85" X="429" Y="121" T="2" P="0,0,0,1.2,130,0,0,0" /><S L="10" H="71" X="10" Y="197" T="2" P="0,0,0,1.2,-20,0,0,0" /><S L="10" H="71" X="790" Y="195" T="2" P="0,0,0,1.2,20,0,0,0" /><S L="10" H="46" X="5" Y="148" T="2" P="0,0,0,1.2,20,0,0,0" /><S L="10" H="46" X="794" Y="146" T="2" P="0,0,0,1.2,-20,0,0,0" /></S><D><P P="1,0" Y="362" T="222" X="101" /><P P="1,1" Y="362" T="222" X="699" /><P P="0,0" Y="351" T="162" X="57" /><P P="0,0" Y="357" T="163" X="280" /><P P="0,0" Y="351" T="163" X="327" /><P P="0,0" Y="355" T="163" X="107" /><P P="0,2" Y="360" T="162" X="743" /><P P="0,1" Y="353" T="163" X="689" /><P P="0,1" Y="356" T="163" X="483" /><P P="0,1" Y="352" T="163" X="529" /><DS Y="-151" X="360" /></D><O /><L /></Z></C>',
    [2] = '<C><P F="3" MEDATA="19,1;;;;-0;0:::1-" L="1200" G="0,4" /><Z><S><S L="1200" H="10" X="600" Y="452" T="9" P="0,0,0,0,0,0,0,0" /><S L="10" H="99" X="600" Y="303" T="1" P="0,0,0,0.2,0,0,0,0" /><S L="800" o="6a7495" H="10" X="400" Y="455" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S L="10" o="6a7495" H="3000" X="-5" N="" Y="0" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S L="10" o="6a7495" H="3000" X="1205" N="" Y="-2" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S H="10" L="10" o="222C47" X="300" c="3" Y="359" T="13" P="0,0,0.3,0.2,0,0,0,0" /><S H="10" L="10" o="151847" X="900" c="3" Y="359" T="13" P="0,0,0.3,0.2,0,0,0,0" /><S c="4" L="100" o="324650" H="105" X="250" Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="1200" H="10" X="600" Y="0" T="1" P="0,0,0,0.2,0,0,0,0" /><S c="3" L="1200" H="10" X="600" Y="95" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="10" H="100" X="305" Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="10" H="100" X="900" Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="1200" H="10" X="601" Y="225" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="10" H="167" X="600" Y="171" T="0" m="" P="0,0,0,0,0,0,0,0" /><S L="841" H="10" X="600" Y="770" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" /><S c="3" L="20" o="6a7495" H="200" X="316" Y="-129" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S c="3" L="20" o="6a7495" H="200" X="407" Y="-133" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S c="3" L="20" o="6a7495" H="100" X="363" Y="-92" T="12" P="0,0,0.2,0.2,90,0,0,0" /><S c="3" L="20" o="6a7495" H="100" X="360" Y="-206" T="12" P="0,0,0.2,0.2,90,0,0,0" /><S c="4" L="3000" o="6a7495" H="202" X="400" N="" Y="503" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S c="4" L="1984" o="6a7495" H="202" X="-103" N="" Y="985" T="12" P="0,0,0.3,0.2,90,0,0,0" /><S c="4" L="1984" o="6a7495" H="202" X="1302" N="" Y="987" T="12" P="0,0,0.3,0.2,90,0,0,0" /><S c="4" L="100" o="324650" H="105" X="950" Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S L="1200" H="10" X="600" Y="-800" T="1" P="0,0,0,0.2,0,0,0,0" /><S c="3" L="1210" H="52" X="595" Y="376" T="8" P="0,0,0.3,0.2,0,0,0,0" /><S L="10" H="85" X="571" Y="121" T="2" P="0,0,0,1.2,50,0,0,0" /><S L="10" H="85" X="630" Y="121" T="2" P="0,0,0,1.2,130,0,0,0" /><S L="10" H="71" X="10" Y="197" T="2" P="0,0,0,1.2,-20,0,0,0" /><S L="10" H="71" X="1192" Y="193" T="2" P="0,0,0,1.2,20,0,0,0" /><S L="10" H="46" X="5" Y="148" T="2" P="0,0,0,1.2,20,0,0,0" /><S L="10" H="46" X="1193" Y="147" T="2" P="0,0,0,1.2,-20,0,0,0" /></S><D><P P="1,0" Y="362" T="222" X="300" /><P P="1,1" Y="361" T="222" X="899" /><P P="0,0" Y="352" T="162" X="64" /><P P="0,0" Y="360" T="162" X="110" /><P P="0,0" Y="351" T="162" X="530" /><P P="0,0" Y="357" T="163" X="477" /><P P="0,0" Y="351" T="163" X="422" /><P P="0,1" Y="357" T="162" X="1139" /><P P="0,1" Y="352" T="163" X="1064" /><P P="0,1" Y="352" T="163" X="669" /><P P="0,0" Y="359" T="163" X="702" /><P P="0,1" Y="351" T="162" X="759" /><P P="0,0" Y="362" T="163" X="1094" /><P P="0,0" Y="351" T="163" X="149" /><DS Y="-141" X="365" /></D><O /><L /></Z></C>',
    [3] = 'Kst small',
    [4] = 'Aeselia#9926',
    [6] = '195540218e1.png'
  },
  [24] = {
    [1] = '<C><P F="6" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="18" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="351" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="51" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="1" X="430" Y="141" L="10" H="61" P="0,0,0,0.2,-60,0,0,0"/><S T="1" X="375" Y="141" L="10" H="61" P="0,0,0,0.2,60,0,0,0"/><S T="2" X="-5" Y="164" L="80" H="80" P="0,0,0,1.8,-50,0,0,0"/><S T="2" X="805" Y="164" L="80" H="80" P="0,0,0,1.8,-40,0,0,0"/><S T="12" X="-43" Y="152" L="86" H="201" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="842" Y="149" L="84" H="213" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/></S><D><P X="99" Y="387" T="72" P="0,0"/><P X="699" Y="387" T="72" P="0,0"/><P X="400" Y="251" T="66" P="1,0"/><P X="47" Y="158" T="65" C="000000,FF70B3" P="1,1"/><P X="752" Y="158" T="65" C="000000,FF70B3" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="6" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="18" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="401" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="402" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="1" X="630" Y="141" L="10" H="61" P="0,0,0,0.2,-60,0,0,0"/><S T="1" X="575" Y="141" L="10" H="61" P="0,0,0,0.2,60,0,0,0"/><S T="2" X="-4" Y="164" L="80" H="80" P="0,0,0,1.8,-50,0,0,0"/><S T="2" X="1204" Y="164" L="80" H="80" P="0,0,0,1.8,-40,0,0,0"/><S T="12" X="-42" Y="152" L="86" H="201" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1241" Y="149" L="84" H="213" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/></S><D><P X="600" Y="251" T="66" P="1,0"/><P X="48" Y="158" T="65" C="000000,FF70B3" P="1,1"/><P X="1151" Y="158" T="65" C="000000,FF70B3" P="1,0"/><P X="298" Y="387" T="72" P="0,0"/><P X="898" Y="387" T="72" P="0,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Date',
    [4] = 'Ppoppohaejuseyo#2315',
    [6] = '19554012e5d.png'
  },
  [25] = {
    [1] = '<C><P F="5" G="0,4" MEDATA="25,1;;;;-0;0:::1-"/><Z><S><S T="11" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="11" X="7" Y="350" L="159" H="116" P="0,0,0.05,0.1,50,0,0,0" c="3"/><S T="11" X="793" Y="349" L="159" H="116" P="0,0,0.05,0.1,-50,0,0,0" c="3"/><S T="11" X="161" Y="369" L="202" H="56" P="0,0,0.05,0.1,-40,0,0,0" c="3"/><S T="11" X="639" Y="368" L="202" H="56" P="0,0,0.05,0.1,40,0,0,0" c="3"/><S T="11" X="301" Y="391" L="225" H="146" P="0,0,0.3,0.2,20,0,0,0" c="3"/><S T="12" X="856" Y="0" L="112" H="3000" P="0,0,0,0.2,0,0,0,0" o="6a7495"/><S T="11" X="499" Y="390" L="225" H="146" P="0,0,0.3,0.2,-20,0,0,0" c="3"/><S T="11" X="354" Y="357" L="155" H="86" P="0,0,0.05,0.1,-30,0,0,0" c="3"/><S T="11" X="446" Y="356" L="155" H="86" P="0,0,0.05,0.1,30,0,0,0" c="3"/><S T="11" X="337" Y="439" L="136" H="112" P="0,0,0.05,0.1,20,0,0,0" c="3"/><S T="11" X="463" Y="438" L="136" H="112" P="0,0,0.05,0.1,-20,0,0,0" c="3"/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="12" X="-50" Y="0" L="102" H="3000" P="0,0,0,0.2,0,0,0,0" o="6a7495"/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="399" Y="148" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="198" L="10" H="112" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="8" X="43" Y="136" L="10" H="10" P="0,0,0.3,0.2,30,0,0,0" tint="76D7F7"/><S T="8" X="747" Y="136" L="10" H="10" P="0,0,0.3,0.2,-30,0,0,0" tint="76D7F7"/><S T="8" X="149" Y="185" L="10" H="10" P="0,0,0.3,0.2,-10,0,0,0" tint="76D7F7"/><S T="8" X="641" Y="185" L="10" H="10" P="0,0,0.3,0.2,10,0,0,0" tint="76D7F7"/><S T="8" X="558" Y="100" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76D7F7"/><S T="8" X="224" Y="100" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76D7F7"/><S T="8" X="462" Y="195" L="10" H="10" P="0,0,0.3,0.2,-60,0,0,0" tint="76D7F7"/><S T="8" X="328" Y="195" L="10" H="10" P="0,0,0.3,0.2,60,0,0,0" tint="76D7F7"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="0,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="5" G="0,4" MEDATA="28,1;;;;-0;0:::1-"/><Z><S><S T="11" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="11" X="107" Y="343" L="102" H="97" P="0,0,0.05,0.1,-60,0,0,0" c="3"/><S T="11" X="1095" Y="343" L="102" H="97" P="0,0,0.05,0.1,60,0,0,0" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="11" X="13" Y="333" L="208" H="97" P="0,0,0.05,0.1,50,0,0,0" c="3"/><S T="11" X="1189" Y="333" L="208" H="97" P="0,0,0.05,0.1,-50,0,0,0" c="3"/><S T="11" X="176" Y="358" L="208" H="97" P="0,0,0.05,0.1,20,0,0,0" c="3"/><S T="12" X="1247" Y="0" L="108" H="3000" P="0,0,0,0.2,0,0,0,0" o="6a7495"/><S T="11" X="600" Y="280" L="19" H="20" P="0,0,0.05,0.1,0,0,0,0"/><S T="11" X="1026" Y="358" L="208" H="97" P="0,0,0.05,0.1,-20,0,0,0" c="3"/><S T="11" X="358" Y="371" L="208" H="97" P="0,0,0.05,0.1,-50,0,0,0" c="3"/><S T="11" X="844" Y="371" L="208" H="97" P="0,0,0.05,0.1,50,0,0,0" c="3"/><S T="11" X="468" Y="343" L="208" H="97" P="0,0,0.05,0.1,20,0,0,0" c="3"/><S T="11" X="734" Y="343" L="208" H="97" P="0,0,0.05,0.1,-20,0,0,0" c="3"/><S T="11" X="527" Y="362" L="208" H="97" P="0,0,0.05,0.1,-30,0,0,0" c="3"/><S T="11" X="675" Y="362" L="208" H="97" P="0,0,0.05,0.1,30,0,0,0" c="3"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="12" X="-51" Y="0" L="103" H="3000" P="0,0,0,0.2,0,0,0,0" o="6a7495"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="135" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="195" L="10" H="119" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="8" X="123" Y="209" L="10" H="10" P="0,0,0.3,0.2,-20,0,0,0" tint="76d7f7"/><S T="8" X="1079" Y="209" L="10" H="10" P="0,0,0.3,0.2,740,0,0,0" tint="76d7f7"/><S T="8" X="241" Y="163" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76d7f7"/><S T="8" X="961" Y="163" L="10" H="10" P="0,0,0.3,0.2,720,0,0,0" tint="76d7f7"/><S T="8" X="346" Y="214" L="10" H="10" P="0,0,0.3,0.2,50,0,0,0" tint="76d7f7"/><S T="8" X="856" Y="214" L="10" H="10" P="0,0,0.3,0.2,670,0,0,0" tint="76d7f7"/><S T="8" X="470" Y="166" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76d7f7"/><S T="8" X="732" Y="166" L="10" H="10" P="0,0,0.3,0.2,720,0,0,0" tint="76d7f7"/><S T="8" X="547" Y="210" L="10" H="10" P="0,0,0.3,0.2,10,0,0,0" tint="76d7f7"/><S T="8" X="655" Y="213" L="10" H="10" P="0,0,0.3,0.2,710,0,0,0" tint="76d7f7"/><S T="8" X="30" Y="136" L="10" H="10" P="0,0,0.3,0.2,10,0,0,0"/><S T="8" X="1172" Y="136" L="10" H="10" P="0,0,0.3,0.2,710,0,0,0"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Snowy Mountains',
    [4] = 'Hxejss#7104',
    [6] = '1955402cb0a.png'
  },
  [26] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="16,1;;;;-0;0::0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,0,0:1-"/><Z><S><S T="12" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" o="FF0000" c="3" N="" tint="FF0000"/><S T="12" X="400" Y="401" L="796" H="100" P="0,0,0.1,0.2,0,0,0,0" o="000000" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="400" Y="-12" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N="" tint="FF0000"/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="51" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="51" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="4"/><S T="12" X="51" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="4"/><S T="12" X="751" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="9" X="400" Y="374" L="801" H="49" P="0,0,0,0,0,0,0,0" tint="E60101" archAcc="-5"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="1" X="401" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" m=""/><S T="12" X="400" Y="300" L="12" H="102" P="0,0,0,0.2,0,0,0,0" o="9A0505" c="4" N=""/><S T="12" X="400" Y="300" L="10" H="101" P="0,0,0,0.2,0,0,0,0" o="000000" c="4" N=""/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="99" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="699" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="98" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="698" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="401" Y="70" L="62" P="1,0,0.3,0.2,-90,0,0,0" o="324650" c="2" N="" m=""/></S><D><DS X="360" Y="-151"/></D><O/><L><JD c="000000,250,1," P1="125.32,189.24" P2="674.68,176.58"/><JD c="000000,250,1," P1="127.85,132.28" P2="681.01,123.42"/><JD c="000000,250,1," P1="673.42,281.17" P2="122.78,283.7"/><JD c="000000,23,1," P1="8.86,350" P2="6.33,5.7"/><JD c="000000,23,1," P1="6.33,5.7" P2="788.61,4.43"/><JD c="000000,23,1," P1="789.87,5.7" P2="788.61,348.73"/><JD c="A80000,114,1,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="660000,119,0.8,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="660000,124,0.5,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="660000,119,0.2,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="B02525,109,1,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="D43737,104,1,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="AD2828,99,1,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="812626,94,0.9,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="5C1414,89,0.9,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="501313,84,0.9,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="2A0D0D,79,0.9,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="330000,114,0.4,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="000000,74,0.8,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JP M1="46" AXIS="-1,0" MV="Infinity,5"/><JP M1="46" AXIS="0,1"/></L></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="14,1;;;;-0;0::0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,0,0,0,0,0,0,0,0,0,0:1-"/><Z><S><S T="12" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" o="FF0000" c="3" N="" tint="FF0000"/><S T="12" X="601" Y="401" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" o="000000" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="600" Y="-7" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3" tint="FF0000"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="903" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="1" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="13" X="600" Y="74" L="62" P="1,0,0.3,0.2,-90,0,0,0" o="324650" N="" m=""/><S T="13" X="51" Y="173" L="37" P="1,0,0.3,0.2,0,0,0,0" o="9B0505"/><S T="13" X="53" Y="173" L="35" P="1,0,0.3,0.2,0,0,0,0" o="000000"/><S T="13" X="1147" Y="173" L="37" P="1,0,0.3,0.2,180,0,0,0" o="9B0505"/><S T="13" X="1145" Y="173" L="35" P="1,0,0.3,0.2,180,0,0,0" o="000000"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="4"/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="4"/><S T="12" X="251" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="12" X="951" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="9" X="601" Y="376" L="1201" H="52" P="0,0,0,0,0,0,0,0" tint="9A0505" archAcc="-5" archMax="0"/><S T="13" X="299" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="899" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="600" Y="300" L="12" H="102" P="0,0,0,0.2,0,0,0,0" o="9A0505" c="4" N=""/><S T="12" X="600" Y="300" L="10" H="101" P="0,0,0,0.2,0,0,0,0" o="000000" c="4" N=""/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" m=""/></S><D><DS X="365" Y="-141"/></D><O/><L><JD c="A80000,114,1,1" M1="4" M2="4" P1="600,73" P2="600,74"/><JD c="660000,119,0.8,1" M1="4" M2="4" P1="600,73" P2="600,74"/><JD c="660000,124,0.5,1" M1="4" M2="4" P1="600,73" P2="600,74"/><JD c="660000,119,0.2,1" M1="4" M2="4" P1="600,73" P2="600,74"/><JD c="B02525,109,1,1" M1="4" M2="4" P1="600,73" P2="600,74"/><JD c="D43737,104,1,1" M1="4" M2="4" P1="600,73" P2="600,74"/><JD c="AD2828,99,1,1" M1="4" M2="4" P1="600,73" P2="600,74"/><JD c="812626,94,0.9,1" M1="4" M2="4" P1="600,73" P2="600,74"/><JD c="5C1414,89,0.9,1" M1="4" M2="4" P1="600,73" P2="600,74"/><JD c="501313,84,0.9,1" M1="4" M2="4" P1="600,73" P2="600,74"/><JD c="2A0D0D,79,0.9,1" M1="4" M2="4" P1="600,73" P2="600,74"/><JD c="330000,114,0.4,1" M1="4" M2="4" P1="600,73" P2="600,74"/><JD c="000000,74,0.8,1" M1="4" M2="4" P1="600,73" P2="600,74"/><JD c="000000,250,1," P1="1070.89,231.01" P2="124.05,246.2"/><JD c="000000,250,1," P1="1059.89,119.01" P2="192.05,134.2"/><JD c="000000,37,1," P1="16.46,35.13" P2="18.99,349.05"/><JD c="000000,37,1," P1="29.11,349.05" P2="1177.85,345.89"/><JD c="000000,37,1," P1="1183.54,343.35" P2="1182.91,18.04"/><JD c="000000,37,1," P1="1176.58,17.41" P2="18.35,15.51"/><JD c="000000,37,1," P1="17.09,27.53" P2="16.46,15.51"/><JD c="000000,37,1," P1="31.65,38.92" P2="50,38.92"/><JD c="000000,37,1," P1="1163.29,33.86" P2="1163.29,34.86"/><JD c="000000,37,1," P1="1161.39,323.73" P2="1161.39,324.73"/><JD c="000000,37,1," P1="48,113.5" P2="82,126.5"/><JD c="000000,37,1," P1="42,83.5" P2="87,97.5"/><JD c="000000,37,1," P1="40,63.5" P2="99,78.5"/><JD c="000000,37,1," P1="59,48.5" P2="124,50.5"/><JD c="000000,37,1," P1="41,58.5" P2="182,93.5"/><JD c="000000,30,1," P1="29,129.5" P2="92,141.5"/><JP M1="21" AXIS="-1,0" MV="Infinity,3.3333333333333335"/><JP M1="21" AXIS="0,1"/><JP M1="22" AXIS="-1,0" MV="Infinity,8.333333333333334"/><JP M1="22" AXIS="0,1"/><JP M1="23" AXIS="-1,0" MV="Infinity,8.333333333333334"/><JP M1="23" AXIS="0,1"/><JP M1="24" AXIS="-1,0" MV="Infinity,8.333333333333334"/><JP M1="24" AXIS="0,1"/><JP M1="25" AXIS="-1,0" MV="Infinity,8.333333333333334"/><JP M1="25" AXIS="0,1"/></L></Z></C>',
    [3] = 'Eclipse',
    [4] = 'Lacoste#8972',
    [6] = '195540145dc.png'
  },
  [27] = {
    [1] = '<C><P F="7" G="0,4" MEDATA="37,1;;;;-0;0:::1-"/><Z><S><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="19" X="835" Y="30" L="10" H="100" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="12" X="400" Y="240" L="10" H="300" P="0,0,0,0.2,0,0,0,0" o="070707" c="3" friction="-100,-20"/><S T="12" X="400" Y="85" L="900" H="10" P="0,0,0.3,0.2,0,0,0,0" o="ff0000" c="3"/><S T="12" X="845" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-45" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" m=""/><S T="19" X="-35" Y="30" L="10" H="100" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="12" X="400" Y="300" L="1400" H="800" P="0,0,0.3,0.2,0,0,0,0" o="222222" c="4"/><S T="12" X="213" Y="207" L="368" H="96" P="0,0,0.3,0.2,185,0,0,0" o="2B272D" c="4"/><S T="12" X="588" Y="207" L="368" H="96" P="0,0,0.3,0.2,-185,0,0,0" o="2B272D" c="4"/><S T="12" X="346" Y="137" L="100" H="100" P="0,0,0.3,0.2,20,0,0,0" o="0a0a0a" c="4"/><S T="12" X="457" Y="137" L="100" H="100" P="0,0,0.3,0.2,-20,0,0,0" o="0a0a0a" c="4"/><S T="12" X="353" Y="153" L="100" H="100" P="0,0,0.3,0.2,20,0,0,0" o="525252" c="4"/><S T="12" X="450" Y="153" L="100" H="100" P="0,0,0.3,0.2,-20,0,0,0" o="525252" c="4"/><S T="12" X="223" Y="211" L="368" H="149" P="0,0,0.3,0.2,215,0,0,0" o="2B272D" c="4"/><S T="12" X="578" Y="211" L="368" H="149" P="0,0,0.3,0.2,-215,0,0,0" o="2B272D" c="4"/><S T="13" X="283" Y="319" L="71" P="0,0,0,0.2,0,0,0,0" o="222222" c="4"/><S T="13" X="518" Y="319" L="71" P="0,0,0,0.2,0,0,0,0" o="222222" c="4"/><S T="13" X="172" Y="299" L="59" P="0,0,0,0.2,0,0,0,0" o="222222" c="4"/><S T="13" X="629" Y="299" L="59" P="0,0,0,0.2,0,0,0,0" o="222222" c="4"/><S T="13" X="92" Y="282" L="59" P="0,0,0,0.2,0,0,0,0" o="222222" c="4"/><S T="13" X="709" Y="282" L="59" P="0,0,0,0.2,0,0,0,0" o="222222" c="4"/><S T="13" X="11" Y="222" L="59" P="0,0,0,0.2,0,0,0,0" o="222222" c="4"/><S T="13" X="790" Y="222" L="59" P="0,0,0,0.2,0,0,0,0" o="222222" c="4"/><S T="13" X="401" Y="242" L="140" P="0,0,0,0.2,0,0,0,0" o="0a0a0a" c="4"/><S T="12" X="203" Y="97" L="221" H="15" P="0,0,0.3,0.2,215,0,0,0" o="0a0a0a" c="4"/><S T="12" X="598" Y="97" L="221" H="15" P="0,0,0.3,0.2,-215,0,0,0" o="0a0a0a" c="4"/><S T="13" X="466" Y="210" L="30" P="0,0,0,0.2,0,0,0,0" o="242424" c="4"/><S T="13" X="341" Y="210" L="30" P="0,0,0,0.2,0,0,0,0" o="242424" c="4"/><S T="12" X="401" Y="350" L="10" H="200" P="0,0,0.3,0.2,0,0,0,0" o="525252"/><S T="12" X="400" Y="450" L="1200" H="200" P="0,0,0.3,0.2,0,0,0,0" o="525252" c="3" N=""/><S T="12" X="400" Y="734" L="685" H="10" P="0,0,0.3,0.2,90,0,0,0" o="161616"/><S T="12" X="454" Y="304" L="10" H="40" P="0,0,0.2,0.1,30,0,0,0" o="242424" c="4"/><S T="12" X="70" Y="106" L="15" H="181" P="0,0,0.3,0.2,35,0,0,0" o="0a0a0a" c="4"/><S T="12" X="731" Y="106" L="15" H="181" P="0,0,0.3,0.2,-35,0,0,0" o="0a0a0a" c="4"/><S T="12" X="98" Y="137" L="10" H="190" P="0,0,0.3,0.2,15,0,0,0" o="0a0a0a" c="4"/><S T="12" X="703" Y="137" L="10" H="190" P="0,0,0.3,0.2,-15,0,0,0" o="0a0a0a" c="4"/><S T="12" X="134" Y="155" L="10" H="210" P="0,0,0.3,0.2,-5,0,0,0" o="0a0a0a" c="4"/><S T="12" X="667" Y="155" L="10" H="210" P="0,0,0.3,0.2,5,0,0,0" o="0a0a0a" c="4"/><S T="12" X="180" Y="166" L="10" H="255" P="0,0,0.3,0.2,-25,0,0,0" o="0a0a0a" c="4"/><S T="12" X="621" Y="166" L="10" H="255" P="0,0,0.3,0.2,25,0,0,0" o="0a0a0a" c="4"/><S T="12" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" o="161616" c="3" N=""/><S T="12" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" o="324650" N=""/><S T="12" X="350" Y="304" L="10" H="40" P="0,0,0.2,0.1,330,0,0,0" o="242424" c="4"/><S T="13" X="22" Y="180" L="21" P="0,0,0,0.5,0,0,0,0" o="720000" c="2"/><S T="13" X="779" Y="180" L="21" P="0,0,0,0.5,0,0,0,0" o="0060ad" c="2"/><S T="13" X="73" Y="228" L="10" P="0,0,0.3,1,0,0,0,0" o="720000" c="2"/><S T="13" X="728" Y="228" L="10" P="0,0,0.3,1,0,0,0,0" o="0060ad" c="2"/><S T="13" X="230" Y="278" L="10" P="0,0,0.3,0.7,0,0,0,0" o="720000" c="2"/><S T="13" X="571" Y="278" L="10" P="0,0,0.3,0.7,0,0,0,0" o="0060ad" c="2"/><S T="13" X="145" Y="259" L="15" P="0,0,0,1.2,0,0,0,0" o="720000" c="2"/><S T="13" X="656" Y="259" L="15" P="0,0,0,1.2,0,0,0,0" o="0060ad" c="2"/><S T="13" X="341" Y="210" L="20" P="0,0,0,0.2,0,0,0,0" o="525252" c="4"/><S T="13" X="466" Y="210" L="20" P="0,0,0,0.2,0,0,0,0" o="525252" c="4"/></S><D><P X="699" Y="358" T="100" C="0094ff" P="1,0"/><P X="99" Y="360" T="100" C="ff0000" P="1,0"/><P X="317" Y="216" T="173" P="0,0"/><P X="318" Y="211" T="173" P="0,0"/><P X="490" Y="213" T="173" P="0,0"/><P X="779" Y="349" T="173" P="0,0"/><P X="27" Y="349" T="173" P="0,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="7" G="0,4" MEDATA="3,1;;;;-0;0:::1-"/><Z><S><S T="12" X="-105" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="1b1b1b"/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="12" X="600" Y="240" L="10" H="300" P="0,0,0,0.2,0,0,0,0" o="070707" c="3"/><S T="12" X="600" Y="725" L="713" H="10" P="0,0,0.3,0.2,90,0,0,0" o="161616"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="600" Y="455" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="00FF08" c="3"/><S T="19" X="305" Y="48" L="10" H="100" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="19" X="890" Y="48" L="10" H="100" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="600" Y="0" L="1400" H="20" P="0,0,0,0.2,0,0,0,0" o="222222" c="3"/><S T="12" X="600" Y="200" L="1600" H="410" P="0,0,0.3,0.2,0,0,0,0" o="1b1b1b" c="4"/><S T="12" X="689" Y="118" L="150" H="150" P="0,0,0.3,0.2,-10,0,0,0" o="0a0a0a" c="4"/><S T="12" X="125" Y="104" L="267" H="126" P="0,0,0.3,0.2,0,0,0,0" o="2B272D" c="4"/><S T="12" X="1075" Y="104" L="267" H="126" P="0,0,0.3,0.2,0,0,0,0" o="2B272D" c="4"/><S T="12" X="511" Y="118" L="150" H="150" P="0,0,0.3,0.2,10,0,0,0" o="0a0a0a" c="4"/><S T="12" X="286" Y="220" L="220" H="410" P="0,0,0.3,0.2,125,0,0,0" o="2B272D" c="4"/><S T="12" X="914" Y="220" L="220" H="410" P="0,0,0.3,0.2,-125,0,0,0" o="2B272D" c="4"/><S T="12" X="324" Y="96" L="45" H="253" P="0,0,0.3,0.2,125,0,0,0" o="0a0a0a" c="4"/><S T="13" X="353" Y="339" L="94" P="0,0,0.3,0.2,0,0,0,0" o="1b1b1b" c="4"/><S T="13" X="847" Y="339" L="94" P="0,0,0.3,0.2,0,0,0,0" o="1b1b1b" c="4"/><S T="12" X="677" Y="143" L="150" H="150" P="0,0,0.3,0.2,-10,0,0,0" o="525252" c="4"/><S T="12" X="876" Y="96" L="45" H="253" P="0,0,0.3,0.2,-125,0,0,0" o="0a0a0a" c="4"/><S T="12" X="523" Y="143" L="150" H="150" P="0,0,0.3,0.2,10,0,0,0" o="525252" c="4"/><S T="13" X="600" Y="250" L="200" P="0,0,0,0.2,0,0,0,0" o="0a0a0a" c="4"/><S T="13" X="-10" Y="116" L="73" P="0,0,0.3,0.2,0,0,0,0" o="1b1b1b" c="4"/><S T="13" X="1210" Y="116" L="73" P="0,0,0.3,0.2,0,0,0,0" o="1b1b1b" c="4"/><S T="13" X="57" Y="232" L="73" P="0,0,0.3,0.2,0,0,0,0" o="1b1b1b" c="4"/><S T="13" X="1143" Y="232" L="73" P="0,0,0.3,0.2,0,0,0,0" o="1b1b1b" c="4"/><S T="13" X="214" Y="294" L="79" P="0,0,0.3,0.2,0,0,0,0" o="1b1b1b" c="4"/><S T="13" X="986" Y="294" L="79" P="0,0,0.3,0.2,0,0,0,0" o="1b1b1b" c="4"/><S T="12" X="600" Y="350" L="10" H="200" P="0,0,0.3,0.2,0,0,0,0" o="525252"/><S T="12" X="600" Y="506" L="1600" H="300" P="0,0,0.3,0.2,0,0,0,0" o="525252" c="3" N=""/><S T="12" X="1304" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="1b1b1b"/><S T="12" X="138" Y="106" L="20" H="202" P="0,0,0.3,0.2,55,0,0,0" o="0a0a0a" c="4"/><S T="12" X="1062" Y="106" L="20" H="202" P="0,0,0.3,0.2,-55,0,0,0" o="0a0a0a" c="4"/><S T="12" X="180" Y="156" L="20" H="227" P="0,0,0.3,0.2,25,0,0,0" o="0a0a0a" c="4"/><S T="12" X="1020" Y="156" L="20" H="227" P="0,0,0.3,0.2,-25,0,0,0" o="0a0a0a" c="4"/><S T="13" X="678" Y="195" L="30" P="0,0,0,0.2,0,0,0,0" o="181818" c="4"/><S T="13" X="518" Y="195" L="30" P="0,0,0,0.2,0,0,0,0" o="181818" c="4"/><S T="12" X="110" Y="25" L="245" H="40" P="0,0,0.3,0.2,0,0,0,0" o="0a0a0a" c="4"/><S T="12" X="1090" Y="25" L="245" H="40" P="0,0,0.3,0.2,0,0,0,0" o="0a0a0a" c="4"/><S T="12" X="266" Y="162" L="20" H="215" P="0,0,0.3,0.2,-15,0,0,0" o="0a0a0a" c="4"/><S T="12" X="932" Y="164" L="20" H="215" P="0,0,0.3,0.2,15,0,0,0" o="0a0a0a" c="4"/><S T="13" X="55" Y="163" L="20" P="0,0,0.3,1.2,20,0,0,0" o="720000" c="2"/><S T="13" X="1145" Y="163" L="20" P="0,0,0.3,1.2,-20,0,0,0" o="0060ad" c="2"/><S T="13" X="0" Y="25" L="30" P="0,0,0.3,1.2,0,0,0,0" o="720000" c="2"/><S T="13" X="1200" Y="25" L="30" P="0,0,0.3,1.2,0,0,0,0" o="0060ad" c="2"/><S T="13" X="133" Y="257" L="15" P="0,0,0.3,1.3,0,0,0,0" o="720000" c="2"/><S T="13" X="1067" Y="257" L="15" P="0,0,0.3,1.3,0,0,0,0" o="0060ad" c="2"/><S T="13" X="293" Y="260" L="20" P="0,0,0.3,1.2,0,0,0,0" o="720000" c="2"/><S T="13" X="907" Y="260" L="20" P="0,0,0.3,1.2,0,0,0,0" o="0060ad" c="2"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="12" X="522" Y="308" L="10" H="38" P="0,0,0.3,0.2,-10,0,0,0" o="282828" c="4"/><S T="12" X="674" Y="308" L="10" H="38" P="0,0,0.3,0.2,10,0,0,0" o="282828" c="4"/><S T="13" X="518" Y="195" L="20" P="0,0,0,0.2,0,0,0,0" o="525252" c="4"/><S T="13" X="678" Y="195" L="20" P="0,0,0,0.2,0,0,0,0" o="525252" c="4"/></S><D><P X="899" Y="360" T="100" C="0094ff" P="1,0"/><P X="515" Y="216" T="173" P="0,0"/><P X="299" Y="360" T="100" C="ff0000" P="1,0"/><P X="516" Y="211" T="173" P="0,0"/><P X="688" Y="213" T="173" P="0,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [3] = 'Small bat',
    [4] = 'Tanatosl#0000',
    [6] = '1955402b39a.png'
  },
  [28] = {
    [1] = '<C><P F="0" G="0,4" C="" MEDATA="13,1;;;;-0;0:::1-"/><Z><S><S T="1" X="400" Y="440" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-5" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="93" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="500" L="3000" H="200" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" C="" MEDATA="18,1;;;;-0;0:::1-"/><Z><S><S T="1" X="600" Y="440" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1205" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-5" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="93" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="600" Y="500" L="3000" H="200" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Very small ice barrier and mice collision',
    [4] = 'Kralizmox#0000',
    [6] = '1955403fbce.png'
  },
  [29] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="5,1;;;;-0;0:::1-"/><Z><S><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="400" Y="172" L="10" H="150" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="19" X="700" Y="48" L="10" H="100" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="19" X="105" Y="48" L="10" H="100" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="400" Y="400" L="1600" H="1200" P="0,0,0.3,0.2,0,0,0,0" o="0b0211" c="4"/><S T="13" X="400" Y="-374" L="453" P="0,0,0.3,0.2,0,0,0,0" o="e0c400" c="4"/><S T="13" X="55" Y="112" L="13" P="0,0,2,0.2,0,0,0,0" o="adadad" c="2" N=""/><S T="13" X="55" Y="112" L="10" P="0,0,0.3,0.2,0,0,0,0" o="808080" c="2" N=""/><S T="13" X="403" Y="462" L="138" P="0,0,4,0.2,0,0,0,0" o="83783e" c="2" N=""/><S T="13" X="403" Y="-396" L="453" P="0,0,0.3,0.2,0,0,0,0" o="f5d600" c="4"/><S T="13" X="210" Y="354" L="23" P="0,0,2,1,0,0,0,0" o="00547e" c="2" N=""/><S T="13" X="401" Y="462" L="134" P="0,0,0.3,0.2,0,0,0,0" o="9f924c" c="2" N=""/><S T="13" X="363" Y="367" L="29" P="0,0,0.3,0.2,0,0,0,0" o="f89151" c="2" N=""/><S T="12" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" o="00ab86" N=""/><S T="13" X="210" Y="354" L="20" P="0,0,0.3,0.2,0,0,0,0" o="0091da" c="2" N=""/><S T="12" X="212" Y="349" L="15" H="21" P="0,0,0.3,0.2,-30,0,0,0" o="006a0d" c="4" N=""/><S T="13" X="363" Y="361" L="21" P="0,0,0.3,0.2,0,0,0,0" o="fa792a" c="2" N=""/><S T="13" X="735" Y="353" L="31" P="0,0,1,1.4,0,0,0,0" o="0000ee" c="2" N=""/><S T="13" X="735" Y="353" L="27" P="0,0,0.3,0.2,0,0,0,0" o="0000bf" c="2" N=""/><S T="12" X="400" Y="396" L="1600" H="100" P="0,0,0,0.2,0,0,0,0" o="00ab86" c="4" N=""/><S T="13" X="400" Y="-427" L="453" P="0,0,0.3,0.2,0,0,0,0" o="f2ff00" c="4"/><S T="12" X="400" Y="400" L="1600" H="100" P="0,0,0,0.2,0,0,0,0" o="009575" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="00ab86" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="00ab86" c="3"/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="1600" H="120" P="0,0,0.3,0.2,0,0,0,0" o="0b0211" c="4" N=""/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="8" X="-5" Y="0" L="10" H="3000" P="0,0,0.3,0.2,0,0,0,0" c="1" N=""/><S T="13" X="57" Y="330" L="18" P="0,0,0.3,1.2,0,0,0,0" o="8e4700" c="2"/><S T="8" X="805" Y="0" L="10" H="3000" P="0,0,0.3,0.2,0,0,0,0" c="1" N=""/><S T="13" X="255" Y="100" L="28" P="0,0,1,0.2,0,0,0,0" o="a30000" c="2" N=""/><S T="13" X="57" Y="330" L="15" P="0,0,0.3,0.2,0,0,0,0" o="562b00" c="2"/><S T="13" X="255" Y="100" L="25" P="0,0,0.3,0.2,0,0,0,0" o="760000" c="2" N=""/><S T="13" X="605" Y="135" L="44" P="0,0,0.7,0.5,0,0,0,0" o="fff5c1" c="2" N=""/><S T="13" X="605" Y="135" L="40" P="0,0,2,0,0,0,0,0" o="ffec88" c="2" N=""/><S T="13" X="581" Y="334" L="13" P="0,0,0,1.1,0,0,0,0" o="8d8d8d" c="2" N=""/><S T="8" X="606" Y="134" L="150" H="10" P="0,0,0.3,0.2,100,0,0,0"/><S T="13" X="581" Y="334" L="10" P="0,0,0.3,0.2,0,0,0,0" o="666666" c="2" N=""/></S><D><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="7" G="0,4" MEDATA="0,1;;;;-0;0:::1-"/><Z><S><S T="12" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" o="4d4d4d" m=""/><S T="12" X="600" Y="0" L="1800" H="10" P="0,0,0,0.2,0,0,0,0" o="0b0211" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="19" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="12" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3" m=""/><S T="12" X="600" Y="175" L="10" H="149" P="0,0,0,0,0,0,0,0" o="324650" c="3" m=""/><S T="19" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="12" X="600" Y="200" L="1800" H="400" P="0,0,0.3,0.2,0,0,0,0" o="0b0211" c="4"/><S T="13" X="600" Y="-339" L="453" P="0,0,0.3,1.1,0,0,0,0" o="e0c400" c="4"/><S T="13" X="600" Y="-371" L="453" P="0,0,0.3,1.1,0,0,0,0" o="F5D600" c="4"/><S T="13" X="600" Y="-403" L="453" P="0,0,0.3,1.1,0,0,0,0" o="f2ff00" c="4"/><S T="13" X="601" Y="467" L="138" P="0,0,0.3,0.2,0,0,0,0" o="83783e" c="2" N=""/><S T="13" X="600" Y="467" L="134" P="0,0,0.3,1.1,0,0,0,0" o="9F924C" c="2" N=""/><S T="12" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" o="4d4d4d"/><S T="13" X="1103" Y="353" L="31" P="0,0,0.3,1.3,0,0,0,0" o="0000ee" c="2" N=""/><S T="13" X="900" Y="360" L="10" P="0,0,0.3,0.2,0,0,0,0" o="4d4d4d" c="4"/><S T="13" X="1103" Y="353" L="27" P="0,0,0.3,1.3,0,0,0,0" o="0000BF" c="2" N=""/><S T="13" X="300" Y="360" L="10" P="0,0,0.3,0.2,0,0,0,0" o="4d4d4d" c="4"/><S T="13" X="632" Y="370" L="29" P="0,0,0.3,0.2,0,0,0,0" o="F89151" c="4" N=""/><S T="13" X="632" Y="366" L="21" P="0,0,0.3,0.2,0,0,0,0" o="FA792A" c="4" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="12" X="600" Y="560" L="1800" H="400" P="0,0,0.1,0.2,0,0,0,0" o="4D4D4D" c="3" N=""/><S T="13" X="823" Y="317" L="44" P="0,0,0,1.1,0,0,0,0" o="515e71" c="2" N="" tint="FFEF9A"/><S T="8" X="-5" Y="205" L="10" H="3000" P="0,0,0.3,0.2,0,0,0,0" c="1" N=""/><S T="12" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" o="324650"/><S T="13" X="1132" Y="78" L="13" P="0,0,0.3,0.7,0,0,0,0" o="7b7b7b" c="2" N=""/><S T="13" X="970" Y="183" L="36" P="0,0,0.3,1.1,0,0,0,0" o="00a48a" c="2" N=""/><S T="13" X="823" Y="317" L="40" P="0,0,0,1.1,0,0,0,0" o="3b4452" c="2" N="" tint="FFEF9A"/><S T="13" X="970" Y="183" L="32" P="0,0,0.3,1.1,0,0,0,0" o="00C1A2" c="2" N=""/><S T="13" X="158" Y="146" L="18" P="0,0,1,0.9,0,0,0,0" o="8e4700" c="2" N=""/><S T="13" X="68" Y="307" L="13" P="0,0,0.3,1.2,0,0,0,0" o="9a9a9a" c="2" N=""/><S T="13" X="269" Y="309" L="13" P="0,0,0.3,1,0,0,0,0" o="adadad" c="2" N=""/><S T="13" X="158" Y="146" L="15" P="0,0,1,0.9,0,0,0,0" o="562B00" c="2" N=""/><S T="13" X="313" Y="307" L="23" P="0,0,0.3,1,0,0,0,0" o="00547e" c="2" N=""/><S T="13" X="372" Y="146" L="28" P="0,0,0.3,1,0,0,0,0" o="a30000" c="2" N=""/><S T="13" X="313" Y="307" L="20" P="0,0,0.3,1,0,0,0,0" o="0091DA" c="2" N=""/><S T="13" X="372" Y="146" L="25" P="0,0,0.3,1,0,0,0,0" o="760000" c="2" N=""/><S T="12" X="313" Y="313" L="19" H="18" P="0,0,0.3,0.2,-20,0,0,0" o="006A0D" c="4" N=""/><S T="12" X="319" Y="304" L="10" H="18" P="0,0,0.3,0.2,-20,0,0,0" o="006A0D" c="4" N=""/><S T="13" X="269" Y="309" L="10" P="0,0,0.3,1,0,0,0,0" o="ffffff" c="2" N=""/><S T="12" X="824" Y="318" L="154" H="10" P="0,0,0.3,0.2,-10,0,0,0" o="6c6c6c" c="4" N=""/><S T="13" X="1132" Y="78" L="10" P="0,0,0.3,0.7,0,0,0,0" o="8d8d8d" c="2" N=""/><S T="13" X="68" Y="307" L="10" P="0,0,0.3,1.2,0,0,0,0" o="808080" c="2" N=""/><S T="8" X="1205" Y="0" L="10" H="3000" P="0,0,0.3,0.2,0,0,0,0" c="1"/></S><D><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Uranus is huge',
    [4] = 'Tanatosl#0000',
    [6] = '1955403e45c.png'
  },
  [30] = {
    [1] = '<C><P F="1" G="0,4" MEDATA="10,1;;;;-0;0:::1-"/><Z><S><S T="19" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="19" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="12" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3"/><S T="12" X="400" Y="174" L="10" H="151" P="0,0,0,0,0,0,0,0" o="ff0000" c="3" m=""/><S T="12" X="400" Y="0" L="1600" H="10" P="0,0,0,0.2,0,0,0,0" o="001435" c="3" N=""/><S T="12" X="400" Y="300" L="1600" H="800" P="0,0,0.3,0.2,0,0,0,0" o="001435" c="4"/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="ff0000" c="4"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="009aff" c="4"/><S T="12" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" o="324650" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="001435" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="001435" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="001435" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="001435" c="3"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="13" X="67" Y="173" L="11" P="1,0,0.3,0.2,0,0,0,0" o="ff0000"/><S T="12" X="573" Y="110" L="118" H="79" P="1,0,0.3,0.2,10,1,0,0" o="004906" c="4"/><S T="12" X="278" Y="113" L="153" H="90" P="1,0,0.3,0.2,-10,0,0,0" o="004906" c="4"/><S T="12" X="435" Y="100" L="183" H="98" P="1,0,0.3,0.2,0,0,0,0" o="004906" c="4"/><S T="12" X="645" Y="132" L="40" H="71" P="1,0,0.3,0.2,20,0,0,0" o="004906" c="4"/><S T="13" X="119" Y="163" L="11" P="1,0,0.3,0.2,0,0,0,0" o="ff0000"/><S T="12" X="705" Y="165" L="40" H="52" P="1,0,0.3,0.2,20,0,0,0" o="004906" c="4"/><S T="12" X="124" Y="136" L="170" H="55" P="1,0,0.3,0.2,-10,1,0,0" o="004906" c="4"/><S T="13" X="160" Y="177" L="11" P="1,0,0.3,1.2,0,0,0,0" o="ff0000"/><S T="13" X="100" Y="210" L="11" P="1,0,0,1.3,-10,0,0,0" o="ff0000"/><S T="12" X="663" Y="136" L="50" H="50" P="0,0,0.3,0.2,20,0,0,0" o="004906" c="4"/><S T="12" X="675" Y="148" L="40" H="62" P="1,0,0.3,0.2,20,0,0,0" o="004906" c="4"/><S T="12" X="147" Y="195" L="160" H="20" P="1,0,0.1,1.3,-30,0,0,0" o="feff65" c="3"/><S T="13" X="175" Y="81" L="28" P="0,0,0.3,0.2,0,0,0,0" o="004906" c="4"/><S T="13" X="215" Y="81" L="28" P="0,0,0.3,0.2,0,0,0,0" o="00810B" c="4"/><S T="13" X="55" Y="122" L="19" P="0,0,0.3,0.2,-10,0,0,0" o="004906" c="4"/><S T="13" X="216" Y="81" L="22" P="0,0,0.3,0.2,0,0,0,0" o="00970c" c="4"/><S T="12" X="266" Y="171" L="35" H="50" P="1,0,1,1,10,0,0,0" o="004906" c="4"/><S T="12" X="217" Y="82" L="10" H="35" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="12" X="744" Y="195" L="80" H="30" P="1,0,0.3,1.2,30,0,0,0" o="0058ff"/><S T="12" X="471" Y="162" L="35" H="50" P="1,0,0.3,1,10,0,0,0" o="004906" c="4"/><S T="12" X="531" Y="162" L="35" H="50" P="1,0,0.3,1,-10,0,0,0" o="004906" c="4"/><S T="12" X="505" Y="113" L="100" H="70" P="0,0,0.3,0.2,0,0,0,0" o="004906" c="4"/><S T="12" X="326" Y="168" L="35" H="50" P="1,0,0.3,0.2,-10,0,0,0" o="004906" c="4"/><S T="12" X="320" Y="120" L="150" H="70" P="0,0,0.3,0.2,-10,0,0,0" o="004906" c="4"/><S T="13" X="690" Y="162" L="10" P="1,0,0.3,0.2,0,0,0,0" o="004906" c="4"/><S T="13" X="720" Y="179" L="10" P="1,0,0.3,0.2,0,0,0,0" o="ff00cc" c="4"/><S T="13" X="659" Y="145" L="10" P="1,0,0.3,0.2,0,0,0,0" o="004906" c="4"/><S T="7" X="400" Y="350" L="10" H="200" P="0,0,0.1,0.2,0,0,0,0"/><S T="13" X="338" Y="61" L="25" P="0,0,0.3,0.2,0,0,0,0" o="004906" c="4"/><S T="13" X="396" Y="61" L="25" P="0,0,0.3,0.2,0,0,0,0" o="004906" c="4"/><S T="13" X="456" Y="59" L="25" P="0,0,0.3,0.2,0,0,0,0" o="004906" c="4"/><S T="13" X="514" Y="64" L="25" P="0,0,0.3,0.2,0,0,0,0" o="004906" c="4"/><S T="13" X="277" Y="68" L="25" P="0,0,0.3,0.2,0,0,0,0" o="004906" c="4"/><S T="13" X="568" Y="72" L="25" P="0,0,0.3,0.2,0,0,0,0" o="004906" c="4"/><S T="13" X="629" Y="119" L="10" P="1,0,0.3,0.2,0,0,0,0" o="004906" c="4"/><S T="7" X="400" Y="475" L="1400" H="240" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="13" X="204" Y="136" L="25" P="0,0,0.3,0.2,0,0,0,0" o="004906" c="4"/><S T="8" X="805" Y="0" L="10" H="3000" P="0,0,0.3,0.2,0,0,0,0" c="1"/><S T="8" X="-5" Y="0" L="10" H="3000" P="0,0,0.3,0.2,0,0,0,0" c="1"/></S><D><DS X="360" Y="-151"/></D><O><O X="659" Y="145" C="14" P="0"/><O X="720" Y="179" C="22" P="0"/><O X="527" Y="95" C="11" P="0"/><O X="346" Y="96" C="11" P="0"/><O X="102" Y="214" C="22" P="0"/><O X="196" Y="124" C="11" P="0"/><O X="275" Y="151" C="22" P="0"/><O X="525" Y="138" C="22" P="0"/><O X="474" Y="142" C="22" P="0"/><O X="322" Y="149" C="22" P="0"/><O X="689" Y="162" C="22" P="0"/><O X="161" Y="179" C="22" P="0"/><O X="629" Y="119" C="11" P="0"/><O X="67" Y="173" C="22" P="0"/><O X="118" Y="162" C="22" P="0"/><O X="208" Y="151" C="22" P="0"/></O><L/></Z></C>',
    [2] = '<C><P L="1200" F="7" G="0,4" MEDATA="17,1;;;;-0;0:::1-"/><Z><S><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="600" Y="0" L="1600" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" c="3"/><S T="12" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="600" Y="174" L="10" H="151" P="0,0,0,0.2,360,0,0,0" o="ff0000" c="3" m="" friction="-100,-20"/><S T="12" X="900" Y="49" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3"/><S T="12" X="600" Y="300" L="1800" H="800" P="0,0,0.3,0.2,0,0,0,0" o="001435" c="4"/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="12" X="600" Y="455" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="808" Y="150" L="40" H="100" P="1,0,0.3,0.2,-380,1,0,0" o="004906" c="4"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="ff0000" c="4"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="009aff" c="4"/><S T="12" X="742" Y="150" L="40" H="100" P="1,0,0.3,0.2,-380,1,0,0" o="004906" c="4"/><S T="12" X="917" Y="103" L="60" H="80" P="1,0,0.3,0.2,370,1,0,0" o="004906" c="4"/><S T="12" X="956" Y="115" L="60" H="70" P="0,0,0.3,0.2,10,0,0,0" o="004906" c="4"/><S T="12" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" o="324650" m=""/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="13" X="123" Y="154" L="11" P="1,0,5,0.2,360,0,0,0" o="ff0000"/><S T="12" X="845" Y="91" L="110" H="100" P="0,0,0.3,0.2,360,0,0,0" o="004906" c="4"/><S T="12" X="390" Y="150" L="40" H="100" P="1,0,0.3,0.2,380,1,0,0" o="004906" c="4"/><S T="12" X="340" Y="95" L="155" H="100" P="1,0,0.3,0.2,350,0,0,0" o="004906" c="4"/><S T="12" X="602" Y="83" L="410" H="100" P="1,0,0.3,0.2,360,0,0,0" o="004906" c="4"/><S T="12" X="455" Y="150" L="40" H="100" P="1,0,0.3,0.2,380,1,0,0" o="004906" c="4"/><S T="12" X="600" Y="91" L="460" H="100" P="0,0,0.3,0.2,360,0,0,0" o="004906" c="4"/><S T="13" X="175" Y="144" L="11" P="1,0,5,1.3,360,0,0,0" o="ff0000"/><S T="12" X="1075" Y="189" L="120" H="30" P="1,0,0.1,1.5,30,0,0,0" o="0058ff"/><S T="12" X="180" Y="117" L="200" H="55" P="1,0,0.3,0.2,350,1,0,0" o="004906" c="4"/><S T="13" X="218" Y="167" L="11" P="1,0,3,1.3,360,0,0,0" o="ff0000"/><S T="13" X="158" Y="200" L="11" P="1,0,5,1.3,350,0,0,0" o="ff0000"/><S T="12" X="984" Y="136" L="100" H="50" P="1,0,0.3,0.2,20,0,0,0" o="004906" c="4"/><S T="12" X="204" Y="187" L="190" H="30" P="1,0,10,0.1,330,0,0,0" o="feff65" c="3"/><S T="13" X="231" Y="62" L="28" P="0,0,0.3,0.2,360,0,0,0" o="004906" c="4"/><S T="13" X="271" Y="62" L="28" P="0,0,0.3,0.2,360,0,0,0" o="00810B" c="4"/><S T="13" X="96" Y="103" L="19" P="0,0,0.3,0.2,350,0,0,0" o="004906" c="4"/><S T="13" X="272" Y="62" L="22" P="0,0,0.3,0.2,360,0,0,0" o="00970c" c="4"/><S T="12" X="273" Y="63" L="10" H="35" P="0,0,0.3,0.2,360,0,0,0" o="000000" c="4"/><S T="13" X="1025" Y="164" L="10" P="1,0,0.3,0.2,360,0,0,0" o="FF0078" c="4"/><S T="7" X="600" Y="350" L="10" H="200" P="0,0,0.1,0.2,0,0,0,0" friction="-100,-20"/><S T="13" X="943" Y="118" L="10" P="1,0,0.3,0.2,0,0,0,0" o="FF0078" c="4"/><S T="7" X="600" Y="505" L="1800" H="300" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="13" X="272" Y="116" L="25" P="0,0,0.3,0.2,360,0,0,0" o="004906" c="4"/><S T="8" X="1200" Y="0" L="10" H="3000" P="0,0,0.3,0.2,0,0,0,0" c="1"/><S T="8" X="-5" Y="0" L="10" H="3000" P="0,0,0.3,0.2,0,0,0,0" c="1"/><S T="13" X="359" Y="47" L="28" P="0,0,0.3,0.2,360,0,0,0" o="004906" c="4"/><S T="13" X="427" Y="40" L="28" P="0,0,0.3,0.2,360,0,0,0" o="004906" c="4"/><S T="13" X="497" Y="38" L="28" P="0,0,0.3,0.2,360,0,0,0" o="004906" c="4"/><S T="13" X="567" Y="35" L="28" P="0,0,0.3,0.2,360,0,0,0" o="004906" c="4"/><S T="13" X="636" Y="35" L="28" P="0,0,0.3,0.2,360,0,0,0" o="004906" c="4"/><S T="13" X="705" Y="35" L="28" P="0,0,0.3,0.2,360,0,0,0" o="004906" c="4"/><S T="13" X="773" Y="36" L="28" P="0,0,0.3,0.2,360,0,0,0" o="004906" c="4"/><S T="13" X="829" Y="40" L="28" P="0,0,0.3,0.2,360,0,0,0" o="004906" c="4"/><S T="13" X="889" Y="56" L="28" P="0,0,0.3,0.2,360,0,0,0" o="004906" c="4"/></S><D><DS X="365" Y="-151"/></D><O><O X="892" Y="98" C="11" P="0"/><O X="158" Y="201" C="22" P="0"/><O X="264" Y="104" C="11" P="0"/><O X="218" Y="167" C="22" P="0"/><O X="123" Y="154" C="22" P="0"/><O X="174" Y="143" C="22" P="0"/><O X="797" Y="90" C="11" P="0"/><O X="401" Y="74" C="11" P="0"/><O X="274" Y="132" C="22" P="0"/><O X="943" Y="118" C="14" P="0"/><O X="396" Y="134" C="14" P="0"/><O X="461" Y="129" C="14" P="0"/><O X="731" Y="131" C="14" P="0"/><O X="799" Y="127" C="14" P="0"/><O X="1025" Y="164" C="14" P="0"/></O><L/></Z></C>',
    [3] = 'Lacoste',
    [4] = 'Tanatosl#0000 and Milkavegeta#6450',
    [6] = '195540255d2.png'
  },
  [31] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0::0,0,0,0,0,0:1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="400" Y="350" L="20" H="200" P="1,0,9999,0.2,270,0,0,0" o="89A7F5"/><S T="12" X="10" Y="270" L="20" H="340" P="1,0,9999,0.2,270,0,0,0" o="89A7F5"/><S T="12" X="790" Y="270" L="20" H="340" P="1,0,9999,0.2,270,0,0,0" o="89A7F5"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="400" Y="175" L="20" H="150" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="12" X="400" Y="300" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="10" Y="230" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="790" Y="230" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="400" Y="305" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5" c="4"/><S T="12" X="10" Y="235" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5" c="4"/><S T="12" X="790" Y="235" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5" c="4"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-150"/></D><O/><L><JP M1="1" A="-3.141592653589793" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="1" A="-3.141592653589793" AXIS="0,1"/><JP M1="2" A="-3.141592653589793" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="2" A="-3.141592653589793" AXIS="0,1"/><JP M1="3" A="-3.141592653589793" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="3" A="-3.141592653589793" AXIS="0,1"/></L></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="13,1;;;;-0;0::0,0,0,0,0,0,0,0,0,0:1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1205" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="175" L="20" H="150" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="10" Y="275" L="20" H="350" P="1,0,9999,0.2,90,0,0,0" o="89A7F5"/><S T="12" X="200" Y="350" L="20" H="200" P="1,0,9999,0.2,90,0,0,0" o="89A7F5"/><S T="12" X="600" Y="350" L="20" H="200" P="1,0,9999,0.2,90,0,0,0" o="89A7F5"/><S T="12" X="1000" Y="350" L="20" H="200" P="1,0,9999,0.2,90,0,0,0" o="89A7F5"/><S T="12" X="1190" Y="275" L="20" H="350" P="1,0,9999,0.2,90,0,0,0" o="89A7F5"/><S T="12" X="10" Y="230" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="1190" Y="230" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="1000" Y="300" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="600" Y="300" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="200" Y="300" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="10" Y="235" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5"/><S T="12" X="1190" Y="235" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5"/><S T="12" X="1000" Y="305" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5"/><S T="12" X="600" Y="305" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5"/><S T="12" X="200" Y="305" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-140"/></D><O/><L><JP M1="20" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="20" AXIS="0,1"/><JP M1="21" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="21" AXIS="0,1"/><JP M1="22" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="22" AXIS="0,1"/><JP M1="23" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="23" AXIS="0,1"/><JP M1="24" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="24" AXIS="0,1"/></L></Z></C>',
    [3] = 'Ice barrier booster',
    [4] = 'Kralizmox#0000',
    [6] = '1955401bb06.png'
  },
  [32] = {
    [1] = '<C><P G="0,4" MEDATA="13,1;;;;-0;0::0,1,2,3,4,5,6,7:1-"/><Z><S><S T="4" X="400" Y="550" L="10" H="10" P="1,-1,20,0.2,0,0,0,0" m=""/><S T="12" X="400" Y="200" L="800" H="400" P="0,0,0.3,0.2,0,0,0,0" o="808080" c="4"/><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="12" X="200" Y="355" L="40" H="20" P="1,999999,0.3,0,0,1,9999,0" o="ffffff" c="3"/><S T="12" X="600" Y="355" L="40" H="20" P="1,999999,0.3,0,0,1,9999,0" o="FFFFFF" c="3"/><S T="12" X="200" Y="225" L="405" H="255" P="1,1,0.3,0.2,0,1,0,0" o="000000" c="4" N=""/><S T="12" X="600" Y="225" L="405" H="255" P="1,1,0.3,0.2,0,1,0,0" o="000000" c="4" N=""/><S T="12" X="875" Y="0" L="150" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" N=""/><S T="12" X="-75" Y="0" L="150" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" N=""/><S T="12" X="-190" Y="185" L="10" H="10" P="1,999999,0.3,0,0,1,0,0" o="324650" m=""/><S T="12" X="990" Y="185" L="10" H="10" P="1,999999,0.3,0,0,1,0,0" o="324650" m=""/><S T="12" X="990" Y="-500" L="50" H="10" P="0,0,0.3,0,0,0,0,0" o="324650" m=""/><S T="12" X="-190" Y="-500" L="50" H="10" P="0,0,0.3,0,0,0,0,0" o="324650" m=""/><S T="13" X="200" Y="160" L="20" P="0,0,0.3,0.2,0,0,0,0" o="fff1a7" c="4"/><S T="12" X="200" Y="185" L="40" H="10" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="200" Y="205" L="10" H="30" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="600" Y="185" L="40" H="10" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="600" Y="205" L="10" H="30" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="13" X="600" Y="160" L="20" P="0,0,0.3,0.2,0,0,0,0" o="fff1a7" c="4"/></S><D><DS X="350" Y="-150"/></D><O/><L><JR M1="21"/><JR M1="21" M2="23"/><JR M1="23" M2="27"/><JP M1="27" AXIS="0,1" MV="Infinity,10"/><JR M1="22"/><JR M1="22" M2="24"/><JR M1="24" M2="28"/><JP M1="28" AXIS="0,1" MV="Infinity,10"/></L></Z></C>',
    [2] = '<C><P L="1200" G="0,4" MEDATA="14,1;;;0,2:1,2:2,2:3,2:4,2:5,2:6,2:7,2;-0;0::0,1,2,3,4,5,6,7:1-"/><Z><S><S T="4" X="600" Y="550" L="10" H="10" P="1,-1,20,0.2,0,0,0,0" c="4" m=""/><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="600" Y="200" L="1200" H="400" P="0,0,0.3,0.2,0,0,0,0" o="808080" c="4"/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="300" Y="205" L="10" H="30" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="900" Y="205" L="10" H="30" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="300" Y="185" L="40" H="10" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="900" Y="185" L="40" H="10" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="13" X="300" Y="160" L="20" P="0,0,0.3,0.2,0,0,0,0" o="FFF1A7" c="4"/><S T="13" X="900" Y="160" L="20" P="0,0,0.3,0.2,0,0,0,0" o="FFF1A7" c="4"/><S T="12" X="300" Y="355" L="60" H="20" P="1,999999,0.3,0,0,1,9999,0" o="FFFFFF" c="3"/><S T="12" X="900" Y="355" L="60" H="20" P="1,999999,0.3,0,0,1,9999,0" o="FFFFFF" c="3"/><S T="12" X="300" Y="225" L="605" H="255" P="1,1,0.3,0.2,0,1,0,0" o="000000" c="4" N=""/><S T="12" X="900" Y="225" L="605" H="255" P="1,1,0.3,0.2,0,1,0,0" o="000000" c="4" N=""/><S T="12" X="-75" Y="0" L="150" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" N=""/><S T="12" X="-250" Y="185" L="10" H="10" P="1,999999,0.3,0,0,1,0,0" o="324650" c="2" m=""/><S T="12" X="1275" Y="0" L="150" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" N=""/><S T="12" X="-180" Y="185" L="10" H="10" P="1,999999,0.3,0,0,1,0,0" o="324650" c="2" m=""/><S T="12" X="-240" Y="-500" L="50" H="10" P="0,0,0.3,0,0,0,0,0" o="324650" c="2" m=""/><S T="12" X="-180" Y="-500" L="50" H="10" P="0,0,0.3,0,0,0,0,0" o="324650" c="2" m=""/></S><D><DS X="365" Y="-140"/></D><O/><L><JR M1="27"/><JR M1="27" M2="29"/><JR M1="29" M2="34"/><JP M1="34" AXIS="0,1" MV="Infinity,10"/><JR M1="28"/><JR M1="28" M2="30"/><JR M1="30" M2="32"/><JP M1="32" AXIS="0,1" MV="Infinity,10"/></L></Z></C>',
    [3] = 'Lightness and Darkness',
    [4] = 'Kralizmox#0000',
    [6] = '19554026d42.png'
  },
  [33] = {
    [1] = '<C><P F="1" G="0,4" MEDATA="57,1;;;;-0;0:::1-"/><Z><S><S T="12" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="19" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="19" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="12" X="399" Y="200" L="1400" H="600" P="0,0,0,0.2,0,0,0,0" o="000000" c="4"/><S T="12" X="400" Y="175" L="15" H="149" P="0,0,0,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="13" X="400" Y="346" L="290" P="0,0,0.3,0.2,0,0,0,0" o="290A1D" c="4"/><S T="12" X="690" Y="230" L="10" H="325" P="0,0,0.3,0.2,0,0,0,0" o="242424" c="4"/><S T="12" X="723" Y="79" L="45" H="41" P="0,0,0.3,0.2,-45,0,0,0" o="ffc3ff" c="4"/><S T="12" X="710" Y="230" L="35" H="300" P="0,0,0.3,0.2,0,0,0,0" o="fffc8e" c="4"/><S T="12" X="760" Y="208" L="55" H="325" P="0,0,0.3,0.2,0,0,0,0" o="1B1B1B" c="4"/><S T="12" X="730" Y="205" L="10" H="325" P="0,0,0.3,0.2,0,0,0,0" o="242424" c="4"/><S T="12" X="790" Y="205" L="10" H="325" P="0,0,0.3,0.2,0,0,0,0" o="242424" c="4"/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="000000" c="3"/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="000000" c="3"/><S T="12" X="77" Y="79" L="45" H="41" P="0,0,0.3,0.2,45,0,0,0" o="ffc3ff" c="4"/><S T="12" X="89" Y="230" L="35" H="300" P="0,0,0.3,0.2,0,0,0,0" o="fffc8e" c="4"/><S T="12" X="110" Y="230" L="10" H="325" P="0,0,0.3,0.2,0,0,0,0" o="242424" c="4"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="000000" c="3"/><S T="12" X="40" Y="208" L="55" H="325" P="0,0,0.3,0.2,0,0,0,0" o="1B1B1B" c="4"/><S T="12" X="10" Y="205" L="10" H="325" P="0,0,0.3,0.2,0,0,0,0" o="242424" c="4"/><S T="12" X="70" Y="205" L="10" H="325" P="0,0,0.3,0.2,0,0,0,0" o="242424" c="4"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="000000" c="3"/><S T="13" X="400" Y="347" L="240" P="0,0,0.3,0.2,20,0,0,0" o="ffc3ff" c="4"/><S T="13" X="760" Y="150" L="10" P="0,0,0.3,1,0,0,0,0" o="00CFFF"/><S T="13" X="400" Y="347" L="225" P="0,0,0.3,0.2,0,0,0,0" o="fffc8e" c="4"/><S T="13" X="400" Y="347" L="210" P="0,0,0.3,0.2,0,0,0,0" o="FFFC3E" c="4"/><S T="13" X="760" Y="260" L="10" P="0,0,0.3,1.3,0,0,0,0" o="00CFFF"/><S T="13" X="760" Y="205" L="10" P="0,0,0.3,1.3,0,0,0,0" o="00CFFF"/><S T="12" X="399" Y="245" L="415" H="20" P="0,0,0.3,0.2,0,0,0,0" o="ffc3ff" c="3"/><S T="13" X="760" Y="315" L="10" P="0,0,0.3,1.5,0,0,0,0" o="00CFFF"/><S T="12" X="400" Y="350" L="15" H="200" P="0,0,0,0.2,0,0,0,0" o="242424" N=""/><S T="12" X="389" Y="351" L="10" H="220" P="0,0,0,0.2,0,0,0,0" o="FF75C8" c="4" N=""/><S T="13" X="700" Y="363" L="10" P="0,0,0.3,0.2,0,0,0,0" o="FF75C8" c="4"/><S T="12" X="410" Y="351" L="10" H="220" P="0,0,0,0.2,0,0,0,0" o="FF75C8" c="4" N=""/><S T="13" X="40" Y="150" L="10" P="0,0,0.3,1,0,0,0,0" o="FF0000"/><S T="13" X="40" Y="260" L="10" P="0,0,0.3,1.3,0,0,0,0" o="FF0000"/><S T="13" X="40" Y="205" L="10" P="0,0,0.3,1.3,0,0,0,0" o="FF0000"/><S T="13" X="100" Y="363" L="10" P="0,0,0.3,0.2,0,0,0,0" o="FF75C8" c="4"/><S T="13" X="40" Y="315" L="10" P="0,0,0.3,1.5,0,0,0,0" o="FF0000"/><S T="8" X="805" Y="0" L="10" H="3000" P="0,0,0.3,0.2,0,0,0,0" c="1"/><S T="12" X="400" Y="560" L="1400" H="400" P="0,0,0.1,0.2,0,0,0,0" o="1B1B1B" c="3" N=""/><S T="8" X="-5" Y="201" L="10" H="3000" P="0,0,0.3,0.2,0,0,0,0" c="1" N=""/><S T="12" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" o="324650"/><S T="12" X="400" Y="474" L="1400" H="10" P="0,0,0.3,0.2,180,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="400" Y="600" L="1400" H="10" P="0,0,0.3,0.2,180,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="400" Y="364" L="1400" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF75C8" c="3" N=""/><S T="12" X="-130" Y="495" L="10" H="530" P="0,0,0.3,0.2,60,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="930" Y="495" L="10" H="530" P="0,0,0.3,0.2,-60,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="-212" Y="426" L="10" H="250" P="0,0,0.3,0.2,60,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="1012" Y="426" L="10" H="250" P="0,0,0.3,0.2,-60,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="80" Y="564" L="10" H="570" P="0,0,0.3,0.2,45,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="720" Y="564" L="10" H="570" P="0,0,0.3,0.2,-45,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="400" Y="170" L="300" H="14" P="0,0,0.3,0.2,0,0,0,0" o="FFC3FF" c="3"/><S T="12" X="275" Y="585" L="10" H="510" P="0,0,0.3,0.2,30,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="525" Y="585" L="10" H="510" P="0,0,0.3,0.2,-30,0,0,0" o="FF75C8" c="4" N=""/><S T="0" X="400" Y="706" L="15" H="705" P="0,0,0.3,0.2,0,0,0,0" m=""/></S><D><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="7" G="0,4" MEDATA="58,1;;;;-0;0:::1-"/><Z><S><S T="12" X="600" Y="0" L="1800" H="10" P="0,0,0,0.2,0,0,0,0" o="0b0211" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="13" X="600" Y="288" L="240" P="0,0,0.3,0.2,0,0,0,0" o="FF2CAB" c="4"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="19" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="12" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3" m=""/><S T="12" X="600" Y="175" L="40" H="149" P="0,0,0,0.2,0,0,0,0" o="324650" c="3" m=""/><S T="19" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="12" X="600" Y="200" L="1800" H="600" P="0,0,0,0,0,0,0,0" o="000000" c="4"/><S T="13" X="900" Y="360" L="10" P="0,0,0.3,0.2,0,0,0,0" o="00EFFF" c="4"/><S T="13" X="600" Y="351" L="257" P="0,0,0.3,0.2,20,0,0,0" o="FF8BFF" c="4"/><S T="13" X="300" Y="360" L="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="4"/><S T="13" X="600" Y="351" L="225" P="0,0,0.3,0.2,0,0,0,0" o="FFC3FF" c="4"/><S T="13" X="600" Y="351" L="214" P="0,0,0.3,0.2,0,0,0,0" o="FFFC3E" c="4"/><S T="12" X="1052" Y="78" L="50" H="41" P="0,0,0.3,0.2,-45,0,0,0" o="FFFCCB" c="4"/><S T="12" X="600" Y="307" L="435" H="14" P="0,0,0.3,0.2,0,0,0,0" o="FFC3FF" c="3"/><S T="12" X="1016" Y="230" L="10" H="325" P="0,0,0,0.2,0,0,0,0" o="242424" c="4"/><S T="12" X="600" Y="350" L="30" H="200" P="0,0,0,0.2,0,0,0,0" o="242424" N=""/><S T="12" X="583" Y="351" L="10" H="220" P="0,0,0,0.2,0,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="1053" Y="230" L="65" H="300" P="0,0,0.3,0.2,0,0,0,0" o="FFFCCB" c="4"/><S T="8" X="1205" Y="0" L="10" H="3000" P="0,0,0.3,0.2,0,0,0,0" c="1"/><S T="12" X="150" Y="78" L="50" H="41" P="0,0,0.3,0.2,45,0,0,0" o="FFFCCB" c="4"/><S T="12" X="617" Y="351" L="10" H="220" P="0,0,0,0.2,0,0,0,0" o="FF75C8" c="4" N=""/><S T="8" X="-5" Y="205" L="10" H="3000" P="0,0,0.3,0.2,0,0,0,0" c="1" N=""/><S T="12" X="184" Y="230" L="10" H="325" P="0,0,0.3,0.2,0,0,0,0" o="242424" c="4"/><S T="12" X="147" Y="230" L="65" H="300" P="0,0,0.3,0.2,0,0,0,0" o="FFFCCB" c="4"/><S T="12" X="103" Y="208" L="95" H="325" P="0,0,0.3,0.2,0,0,0,0" o="1B1B1B" c="4"/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="12" X="52" Y="205" L="10" H="325" P="0,0,0.3,0.2,0,0,0,0" o="242424" c="4"/><S T="12" X="600" Y="560" L="1800" H="400" P="0,0,0.1,0.2,0,0,0,0" o="1B1B1B" c="3" N=""/><S T="12" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" o="324650"/><S T="12" X="148" Y="205" L="10" H="325" P="0,0,0.3,0.2,0,0,0,0" o="242424" c="4"/><S T="12" X="1101" Y="208" L="95" H="325" P="0,0,0.3,0.2,0,0,0,0" o="1B1B1B" c="4"/><S T="12" X="1148" Y="205" L="10" H="325" P="0,0,0.3,0.2,0,0,0,0" o="242424" c="4"/><S T="12" X="1052" Y="205" L="10" H="325" P="0,0,0.3,0.2,0,0,0,0" o="242424" c="4"/><S T="12" X="600" Y="475" L="1800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="600" Y="364" L="1800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF75C8" c="3" N=""/><S T="12" X="90" Y="565" L="10" H="530" P="0,0,0.3,0.2,40,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="1110" Y="565" L="10" H="530" P="0,0,0.3,0.2,-40,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="-100" Y="565" L="10" H="530" P="0,0,0.3,0.2,40,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="1300" Y="565" L="10" H="530" P="0,0,0.3,0.2,-40,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="-265" Y="555" L="10" H="500" P="0,0,0.3,0.2,40,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="1465" Y="555" L="10" H="500" P="0,0,0.3,0.2,-40,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="275" Y="565" L="10" H="520" P="0,0,0.3,0.2,40,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="925" Y="565" L="10" H="520" P="0,0,0.3,0.2,-40,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="475" Y="585" L="10" H="510" P="0,0,0.3,0.2,30,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="725" Y="585" L="10" H="510" P="0,0,0.3,0.2,-30,0,0,0" o="FF75C8" c="4" N=""/><S T="12" X="599" Y="229" L="365" H="14" P="0,0,0.3,0.2,0,0,0,0" o="FFC3FF" c="3"/><S T="12" X="600" Y="159" L="215" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFC3FF" c="3"/><S T="13" X="600" Y="295" L="10" P="0,0,0.3,0.2,0,0,0,0" o="ff75c8" N=""/><S T="13" X="97" Y="105" L="20" P="0,0,0.3,1,0,0,0,0" o="FF0000"/><S T="13" X="1103" Y="105" L="20" P="0,0,0.3,1.1,0,0,0,0" o="00EFFF"/><S T="13" X="97" Y="205" L="20" P="0,0,0.3,1.3,0,0,0,0" o="FF0000"/><S T="13" X="1103" Y="205" L="20" P="0,0,0.3,1.3,0,0,0,0" o="00EFFF"/><S T="13" X="98" Y="302" L="20" P="0,0,0.3,1.5,0,0,0,0" o="FF0000"/><S T="13" X="1102" Y="302" L="20" P="0,0,0.3,1.5,0,0,0,0" o="00EFFF"/><S T="0" X="600" Y="706" L="15" H="728" P="0,0,0.3,0.2,0,0,0,0" m=""/></S><D><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Cyberpink',
    [4] = 'Tanatosl#0000',
    [6] = '195540116ec.png'
  },
  [34] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="13" X="200" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="600" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><P X="185" Y="110" T="131" C="555D77" P="0,0"/><P X="215" Y="110" T="131" C="555D77" P="0,0"/><P X="400" Y="50" T="131" C="555D77" P="0,0"/><P X="585" Y="110" T="131" C="555D77" P="0,0"/><P X="615" Y="110" T="131" C="555D77" P="0,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="13" X="400" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="800" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><P X="385" Y="110" T="131" C="555D77" P="0,0"/><P X="415" Y="110" T="131" C="555D77" P="0,0"/><P X="600" Y="50" T="131" C="555D77" P="0,0"/><P X="785" Y="110" T="131" C="555D77" P="0,0"/><P X="815" Y="110" T="131" C="555D77" P="0,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Volley 2.0',
    [4] = 'Refletz#6472',
    [6] = '1955404133e.png'
  },
  [35] = {
    [1] = '<C><P F="0" G="0,4" MEDATA="39,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="370" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N="" m=""/><S T="9" X="400" Y="370" L="800" H="100" P="0,0,0,0,0,0,0,0" m="" archAcc="0.5" archMax="1.3"/><S T="9" X="400" Y="-10" L="800" H="100" P="0,0,0,0,0,0,0,0" m="" archAcc="0.5" archMax="-1.5"/><S T="9" X="-56" Y="283" L="108" H="229" P="0,0,0,0,0,0,0,0" m="" archAcc="-1"/><S T="9" X="857" Y="283" L="106" H="229" P="0,0,0,0,0,0,0,0" m="" archAcc="-1"/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="-1340" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="-1340" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="12" X="400" Y="245" L="800" H="305" P="0,0,0.3,0.2,0,0,0,0" o="064e3b" c="4"/><S T="13" X="400" Y="252" L="124" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="4"/><S T="13" X="400" Y="252" L="102" P="0,0,0.3,0.2,0,0,0,0" o="064e3b" c="4"/><S T="12" X="400" Y="246" L="26" H="307" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="4"/><S T="12" X="-115" Y="310" L="10" H="300" P="0,0,999999,0,0,0,0,0" o="FFFFFF"/><S T="12" X="915" Y="310" L="10" H="300" P="0,0,999999,0,0,0,0,0" o="FFFFFF"/><S T="12" X="-56" Y="165" L="110" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF"/><S T="12" X="857" Y="165" L="112" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF"/><S T="12" X="-2" Y="285" L="10" H="230" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3" m=""/><S T="12" X="802" Y="285" L="10" H="230" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3" m=""/><S T="15" X="-57" Y="285" L="112" H="230" P="0,0,0,0,0,0,0,0" archAcc="0" archCheeseMax="25"/><S T="15" X="857" Y="285" L="112" H="230" P="0,0,0,0,0,0,0,0" archAcc="0" archCheeseMax="25"/><S T="0" X="-94" Y="595" L="193" H="10" P="0,0,0.3,0.2,0,0,0,0" m=""/><S T="0" X="894" Y="595" L="193" H="10" P="0,0,0.3,0.2,0,0,0,0" m=""/><S T="12" X="-6" Y="168" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF"/><S T="12" X="806" Y="168" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF"/><S T="12" X="-115" Y="498" L="10" H="192" P="0,0,0.3,0.2,0,0,0,0" o="324650" m=""/><S T="12" X="915" Y="498" L="10" H="192" P="0,0,0.3,0.2,0,0,0,0" o="324650" m=""/><S T="12" X="-8" Y="495" L="10" H="194" P="0,0,0.3,0.2,0,0,0,0" o="324650" m=""/><S T="12" X="808" Y="495" L="10" H="194" P="0,0,0.3,0.2,0,0,0,0" o="324650" m=""/><S T="12" X="400" Y="365" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" m=""/><S T="12" X="400" Y="400" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" m=""/><S T="0" X="-26" Y="581" L="10" H="421" P="0,0,0.3,0.2,-25,0,0,0" N="" m=""/><S T="0" X="889" Y="591" L="10" H="421" P="0,0,0.3,0.2,-25,0,0,0" N="" m=""/><S T="0" X="-71" Y="601" L="10" H="421" P="0,0,0.3,0.2,20,0,0,0" N="" m=""/><S T="0" X="841" Y="581" L="10" H="421" P="0,0,0.3,0.2,20,0,0,0" N="" m=""/><S T="9" X="-48" Y="496" L="60" H="33" P="0,0,0,0,0,0,0,0" m=""/><S T="9" X="858" Y="496" L="60" H="33" P="0,0,0,0,0,0,0,0" m=""/><S T="9" X="-46" Y="450" L="123" H="20" P="0,0,0,0,0,0,0,0" m="" archAcc="-1"/><S T="9" X="846" Y="450" L="123" H="20" P="0,0,0,0,0,0,0,0" m="" archAcc="-1"/></S><D><P X="400" Y="110" T="131" C="555D77" P="0,0"/><P X="400" Y="110" T="131" C="555D77" P="0,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="1,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="370" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N="" m=""/><S T="9" X="600" Y="370" L="1200" H="100" P="0,0,0,0,0,0,0,0" m="" archAcc="0.5" archMax="1.2"/><S T="9" X="600" Y="-10" L="1200" H="100" P="0,0,0,0,0,0,0,0" m="" archAcc="0.5" archMax="-1.5"/><S T="9" X="-56" Y="283" L="108" H="229" P="0,0,0,0,0,0,0,0" m="" archAcc="-1"/><S T="9" X="1257" Y="283" L="106" H="229" P="0,0,0,0,0,0,0,0" m="" archAcc="-1"/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="-1340" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1205" Y="-1340" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="12" X="600" Y="245" L="1200" H="305" P="0,0,0.3,0.2,0,0,0,0" o="064e3b" c="4"/><S T="13" X="600" Y="252" L="124" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="4"/><S T="13" X="600" Y="252" L="102" P="0,0,0.3,0.2,0,0,0,0" o="064e3b" c="4"/><S T="12" X="600" Y="246" L="26" H="307" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="4"/><S T="12" X="-115" Y="310" L="10" H="300" P="0,0,999999,0,0,0,0,0" o="FFFFFF"/><S T="12" X="1315" Y="310" L="10" H="300" P="0,0,999999,0,0,0,0,0" o="FFFFFF"/><S T="12" X="-56" Y="165" L="110" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF"/><S T="12" X="1257" Y="165" L="112" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF"/><S T="12" X="-2" Y="285" L="10" H="230" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3" m=""/><S T="12" X="1202" Y="285" L="10" H="230" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3" m=""/><S T="15" X="-57" Y="285" L="112" H="230" P="0,0,0,0,0,0,0,0" archAcc="0" archCheeseMax="25"/><S T="15" X="1257" Y="285" L="112" H="230" P="0,0,0,0,0,0,0,0" archAcc="0" archCheeseMax="25"/><S T="0" X="-94" Y="595" L="193" H="10" P="0,0,0.3,0.2,0,0,0,0" m=""/><S T="0" X="1294" Y="595" L="193" H="10" P="0,0,0.3,0.2,0,0,0,0" m=""/><S T="12" X="-6" Y="168" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF"/><S T="12" X="1206" Y="168" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF"/><S T="12" X="-115" Y="498" L="10" H="192" P="0,0,0.3,0.2,0,0,0,0" o="324650" m=""/><S T="12" X="1315" Y="498" L="10" H="192" P="0,0,0.3,0.2,0,0,0,0" o="324650" m=""/><S T="12" X="-8" Y="495" L="10" H="194" P="0,0,0.3,0.2,0,0,0,0" o="324650" m=""/><S T="12" X="1208" Y="495" L="10" H="194" P="0,0,0.3,0.2,0,0,0,0" o="324650" m=""/><S T="12" X="400" Y="365" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" m=""/><S T="12" X="400" Y="400" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" m=""/><S T="0" X="-26" Y="581" L="10" H="421" P="0,0,0.3,0.2,-25,0,0,0" N="" m=""/><S T="0" X="1289" Y="591" L="10" H="421" P="0,0,0.3,0.2,-25,0,0,0" N="" m=""/><S T="0" X="-71" Y="601" L="10" H="421" P="0,0,0.3,0.2,20,0,0,0" N="" m=""/><S T="0" X="1241" Y="581" L="10" H="421" P="0,0,0.3,0.2,20,0,0,0" N="" m=""/><S T="9" X="-48" Y="496" L="60" H="33" P="0,0,0,0,0,0,0,0" m=""/><S T="9" X="1258" Y="496" L="60" H="33" P="0,0,0,0,0,0,0,0" m=""/><S T="9" X="-46" Y="450" L="123" H="20" P="0,0,0,0,0,0,0,0" m="" archAcc="-1"/><S T="9" X="1246" Y="450" L="123" H="20" P="0,0,0,0,0,0,0,0" m="" archAcc="-1"/></S><D><P X="600" Y="110" T="131" C="555D77" P="0,0"/><P X="600" Y="110" T="131" C="555D77" P="0,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Soccer',
    [4] = 'Refletz#6472',
    [6] = '1955402e27a.png'
  },
  [36] = {
    [1] = '<C><P G="0,4" MEDATA=";33,1;;;-0;0:::1-" F="3" /><Z><S><S Y="400" T="18" P="0,0,0.1,0.2,0,0,0,0" c="3" L="800" X="400" H="100" N="" /><S Y="430" T="9" P="0,0,0,0,0,0,0,0" L="800" X="400" H="10" /><S Y="350" T="1" P="0,0,0,0.2,0,0,0,0" L="10" X="400" H="200" /><S Y="455" T="12" P="0,0,0.3,0.2,0,0,0,0" L="800" o="6a7495" X="400" H="10" /><S Y="0" T="12" P="0,0,0.2,0.2,0,0,0,0" L="10" o="6a7495" X="-5" H="3000" /><S Y="0" T="12" P="0,0,0.2,0.2,0,0,0,0" L="10" o="6a7495" X="805" H="3000" /><S Y="359" T="13" P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="100" c="3" /><S Y="359" T="13" P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="700" c="3" /><S Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="50" H="105" /><S Y="0" T="1" P="0,0,0,0.2,0,0,0,0" c="3" L="800" X="400" H="10" N="" /><S Y="95" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" c="3" L="800" X="400" H="10" N="" /><S Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" X="105" H="100" /><S Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" X="700" H="100" N="" /><S Y="225" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" c="3" L="800" X="401" H="10" /><S Y="239" T="0" m="" P="0,0,0,0,0,0,0,0" c="3" L="10" X="400" H="30" /><S Y="791" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" X="400" H="10" /><S Y="-129" T="12" P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="316" H="200" /><S Y="-133" T="12" P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="407" H="200" /><S Y="-92" T="12" P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="363" H="100" /><S Y="-206" T="12" P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="360" H="100" /><S Y="460" T="12" P="0,0,0.3,0.2,0,0,0,0" c="4" L="3000" o="6a7495" X="400" H="120" N="" /><S Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="750" H="105" /><S Y="-800" T="1" P="0,0,0,0.2,0,0,0,0" L="800" X="400" H="10" N="" /><S Y="239" T="0" m="" P="0,0,0,0,0,0,0,0" c="3" L="10" X="400" H="30" /><S Y="239" T="0" m="" P="0,0,0,0,0,0,0,0" c="3" L="10" X="400" H="30" /><S Y="134" T="2" P="0,0,0,1.2,-110,0,0,0" L="10" X="383" H="41" /><S Y="133" T="2" P="0,0,0,1.2,-70,0,0,0" L="10" X="420" H="41" /><S Y="146" T="2" P="0,0,0,1.2,-50,0,0,0" L="10" X="447" H="22" /><S Y="146" T="2" P="0,0,0,1.2,50,0,0,0" L="10" X="359" H="22" /></S><D><P Y="365" T="10" X="699" P="1,0" /><P Y="365" T="10" X="99" P="1,0" /><P Y="247" T="66" X="400" P="1,0" /><P Y="251" T="65" P="1,0" X="400" C="FFFFFF,F48DCA" /><P Y="473" T="148" X="39" P="0,0" /><P Y="476" T="148" X="103" P="0,0" /><P Y="474" T="148" X="183" P="0,0" /><P Y="474" T="148" X="242" P="0,0" /><P Y="476" T="148" X="310" P="0,0" /><P Y="478" T="148" X="385" P="0,0" /><P Y="476" T="148" X="456" P="0,0" /><P Y="480" T="148" X="527" P="0,0" /><P Y="481" T="148" X="600" P="0,0" /><P Y="478" T="148" X="678" P="0,0" /><P Y="478" T="148" X="746" P="0,0" /><P Y="440" T="148" X="766" P="0,0" /><P Y="452" T="148" X="673" P="0,0" /><P Y="454" T="148" X="572" P="0,0" /><P Y="434" T="148" X="482" P="0,0" /><P Y="456" T="148" X="400" P="0,0" /><P Y="432" T="148" X="304" P="0,0" /><P Y="448" T="148" X="205" P="0,0" /><P Y="424" T="148" X="130" P="0,0" /><P Y="447" T="148" X="76" P="0,0" /><P Y="431" T="148" X="19" P="0,0" /><P Y="438" T="148" X="402" P="0,0" /><P Y="431" T="148" X="620" P="0,0" /><P Y="438" T="148" X="716" P="0,0" /><P Y="496" T="148" X="293" P="0,0" /><P Y="504" T="148" X="129" P="0,0" /><P Y="501" T="148" X="54" P="0,0" /><P Y="513" T="148" X="476" P="0,0" /><P Y="512" T="148" X="597" P="0,0" /><P Y="500" T="148" X="727" P="0,0" /><DS Y="-151" X="360" /></D><O /><L /></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA=";59,1;;;-0;0:::1-"/><Z><S><S T="18" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" c="3" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="2" X="583" Y="134" L="10" H="41" P="0,0,0,1.2,-110,0,0,0"/><S T="2" X="620" Y="133" L="10" H="41" P="0,0,0,1.2,-70,0,0,0"/><S T="2" X="647" Y="146" L="10" H="22" P="0,0,0,1.2,-50,0,0,0"/><S T="2" X="559" Y="146" L="10" H="22" P="0,0,0,1.2,50,0,0,0"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><P X="600" Y="247" T="66" P="1,0"/><P X="600" Y="251" T="65" C="FFFFFF,F48DCA" P="1,0"/><P X="38" Y="465" T="148" P="0,0"/><P X="103" Y="464" T="148" P="0,0"/><P X="177" Y="465" T="148" P="0,0"/><P X="244" Y="468" T="148" P="0,0"/><P X="313" Y="464" T="148" P="0,0"/><P X="391" Y="468" T="148" P="0,0"/><P X="490" Y="468" T="148" P="0,0"/><P X="567" Y="465" T="148" P="0,0"/><P X="651" Y="463" T="148" P="0,0"/><P X="722" Y="464" T="148" P="0,0"/><P X="779" Y="461" T="148" P="0,0"/><P X="833" Y="464" T="148" P="0,0"/><P X="913" Y="461" T="148" P="0,0"/><P X="994" Y="455" T="148" P="0,0"/><P X="1063" Y="458" T="148" P="0,0"/><P X="1143" Y="452" T="148" P="0,0"/><P X="1157" Y="453" T="148" P="0,0"/><P X="428" Y="448" T="148" P="0,0"/><P X="330" Y="449" T="148" P="0,0"/><P X="205" Y="448" T="148" P="0,0"/><P X="136" Y="448" T="148" P="0,0"/><P X="55" Y="446" T="148" P="0,0"/><P X="530" Y="448" T="148" P="0,0"/><P X="619" Y="451" T="148" P="0,0"/><P X="713" Y="444" T="148" P="0,0"/><P X="828" Y="429" T="148" P="0,0"/><P X="920" Y="442" T="148" P="0,0"/><P X="1019" Y="415" T="148" P="0,0"/><P X="1087" Y="441" T="148" P="0,0"/><P X="1150" Y="431" T="148" P="0,0"/><P X="368" Y="444" T="148" P="0,0"/><P X="206" Y="435" T="148" P="0,0"/><P X="98" Y="446" T="148" P="0,0"/><P X="60" Y="483" T="148" P="0,0"/><P X="178" Y="482" T="148" P="0,0"/><P X="328" Y="487" T="148" P="0,0"/><P X="299" Y="438" T="148" P="0,0"/><P X="473" Y="435" T="148" P="0,0"/><P X="409" Y="486" T="148" P="0,0"/><P X="590" Y="478" T="148" P="0,0"/><P X="622" Y="427" T="148" P="0,0"/><P X="533" Y="436" T="148" P="0,0"/><P X="763" Y="428" T="148" P="0,0"/><P X="791" Y="481" T="148" P="0,0"/><P X="906" Y="482" T="148" P="0,0"/><P X="926" Y="415" T="148" P="0,0"/><P X="1021" Y="464" T="148" P="0,0"/><P X="1078" Y="499" T="148" P="0,0"/><P X="287" Y="403" T="148" P="0,0"/><P X="63" Y="410" T="148" P="0,0"/><P X="106" Y="468" T="148" P="0,0"/><P X="445" Y="413" T="148" P="0,0"/><P X="357" Y="488" T="148" P="0,0"/><P X="276" Y="476" T="148" P="0,0"/><P X="464" Y="483" T="148" P="0,0"/><P X="811" Y="415" T="148" P="0,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Pink date',
    [4] = 'Ppoppohaejuseyo#2315',
    [6] = '195540284b2.png'
  },
  [37] = {
    [1] = '<C><P MEDATA=";;;;-0;0:::1-" F="10" G="0,4" /><Z><S><S P="0,0,0.2,500,0,0,0,0" L="800" X="400" c="3" N="" Y="400" T="3" H="100" /><S L="800" X="400" H="10" Y="430" T="9" P="0,0,0,0,0,0,0,0" /><S P="0,0,0,0.2,0,0,0,0" L="10" o="A3401F" X="400" Y="350" T="12" H="200" /><S P="0,0,0.3,0.2,0,0,0,0" L="800" o="6a7495" X="400" Y="455" T="12" H="10" /><S P="0,0,0,0.2,0,0,0,0" L="10" o="6a7495" X="-5" c="3" Y="0" T="12" H="3000" /><S P="0,0,0,0.2,0,0,0,0" L="10" o="6a7495" X="805" c="3" Y="0" T="12" H="3000" /><S P="0,0,0.3,0.2,0,0,0,0" L="100" o="324650" X="50" c="4" Y="45" T="12" H="105" /><S P="0,0,0,0.2,0,0,0,0" L="800" X="400" c="3" N="" Y="0" T="1" H="10" /><S P="0,0,0.3,0.2,0,0,0,0" L="800" X="400" c="3" N="" Y="95" T="0" m="" H="10" /><S P="0,0,0.3,0.2,0,0,0,0" L="10" X="105" c="3" Y="48" T="0" m="" H="100" /><S P="0,0,0.3,0.2,0,0,0,0" L="10" X="700" c="3" N="" Y="48" T="0" m="" H="100" /><S P="0,0,0.2,500,0,0,0,0" L="810" X="404" c="3" Y="102" T="3" H="10" /><S P="0,0,0,0,0,0,0,0" L="10" X="400" c="3" Y="172" T="0" m="" H="158" /><S P="0,0,0.3,0.2,90,0,0,0" L="800" X="400" c="3" Y="791" T="0" m="" H="10" /><S P="0,0,0.2,0.2,0,0,0,0" L="20" o="6a7495" X="316" c="3" Y="-129" T="12" H="200" /><S P="0,0,0.2,0.2,0,0,0,0" L="20" o="6a7495" X="407" c="3" Y="-133" T="12" H="200" /><S P="0,0,0.2,0.2,90,0,0,0" L="20" o="6a7495" X="363" c="3" Y="-92" T="12" H="100" /><S P="0,0,0.2,0.2,90,0,0,0" L="20" o="6a7495" X="360" c="3" Y="-206" T="12" H="100" /><S P="0,0,0.3,0.2,0,0,0,0" L="3000" o="6a7495" X="400" c="4" N="" Y="460" T="12" H="120" /><S P="0,0,0.3,0.2,0,0,0,0" L="100" o="324650" X="750" c="4" Y="45" T="12" H="105" /><S P="0,0,0,0.2,0,0,0,0" L="800" X="400" N="" Y="-800" T="1" H="10" /><S H="3000" L="10" o="6a7495" X="-5" c="2" Y="1" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S P="0,0,0.2,0.2,0,0,0,0" L="10" o="6a7495" X="806" c="2" Y="34" T="12" H="3000" /></S><D><P X="321" Y="350" T="294" P="0,1" /><P X="319" Y="284" T="132" P="0,1" /><P X="324" Y="433" T="44" P="0,0" /><P X="302" Y="433" T="44" P="0,0" /><P X="307" Y="435" T="44" P="0,0" /><P X="326" Y="436" T="44" P="0,0" /><P X="341" Y="436" T="44" P="0,0" /><P X="348" Y="436" T="44" P="0,0" /><P X="304" Y="434" T="44" P="0,0" /><DS Y="-151" X="360" /></D><O /><L /></Z></C>',
    [2] = '<C><P MEDATA=";;;;-0;0:::1-" F="10" L="1200" G="0,4" /><Z><S><S c="3" L="1200" H="100" X="600" N="" Y="400" T="3" P="0,0,0.2,500,0,0,0,0" /><S L="1200" H="10" X="600" Y="430" T="9" P="0,0,0,0,0,0,0,0" /><S L="10" o="B34716" H="200" X="600" Y="350" T="12" P="0,0,0,0.2,0,0,0,0" /><S L="800" o="6a7495" H="10" X="400" Y="455" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="10" o="6a7495" H="3000" X="-7" Y="5" T="12" P="0,0,0,0.2,0,0,0,0" /><S c="2" L="10" o="6a7495" H="3000" X="-7" Y="11" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S c="3" L="10" o="6a7495" H="3000" X="1200" Y="0" T="12" P="0,0,0,0.2,0,0,0,0" /><S c="2" L="10" o="6a7495" H="3000" X="1200" Y="0" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S c="4" L="100" o="324650" H="105" X="250" Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="1200" H="10" X="600" Y="0" T="1" P="0,0,0,0.2,0,0,0,0" /><S c="3" L="1200" H="10" X="600" Y="95" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="10" H="100" X="305" Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="10" H="100" X="900" Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="1200" H="10" X="601" Y="101" T="3" P="0,0,0.2,500,0,0,0,0" /><S c="3" L="10" H="158" X="600" Y="176" T="0" m="" P="0,0,0,0,0,0,0,0" /><S c="3" L="800" H="10" X="600" Y="791" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" /><S c="3" L="20" o="6a7495" H="200" X="316" Y="-129" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S c="3" L="20" o="6a7495" H="200" X="407" Y="-133" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S c="3" L="20" o="6a7495" H="100" X="363" Y="-92" T="12" P="0,0,0.2,0.2,90,0,0,0" /><S c="3" L="20" o="6a7495" H="100" X="360" Y="-206" T="12" P="0,0,0.2,0.2,90,0,0,0" /><S c="4" L="3000" o="6a7495" H="120" X="400" N="" Y="460" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S c="4" L="100" o="324650" H="105" X="950" Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S L="1200" H="10" X="600" Y="-800" T="1" P="0,0,0,0.2,0,0,0,0" /></S><D><DS Y="-141" X="365" /></D><O /><L /></Z></C>',
    [3] = 'The floor is kralizmox',
    [4] = 'Sfjoud#8638',
    [6] = '1955403115e.png'
  },
  [38] = {
    [1] = '<C><P G="0,4" MEDATA=";;;;-0;0::0,1,2,3,4,5,6,7,8,9,10,11:1-" /><Z><S><S P="0,0,0,0.2,0,0,0,0" L="10" X="400" H="200" Y="350" T="1" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="50" H="105" Y="45" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="800" m="" X="400" H="10" N="" Y="95" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" m="" X="105" H="100" Y="48" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" m="" X="700" H="100" N="" Y="48" T="0" /><S P="0,0,0,0,0,0,0,0" c="3" L="10" m="" X="400" H="150" Y="175" T="0" /><S P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" m="" X="400" H="10" Y="791" T="0" /><S P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="316" H="200" Y="-129" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="407" H="200" Y="-133" T="12" /><S P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="363" H="100" Y="-92" T="12" /><S P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="360" H="100" Y="-206" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="ee0f0f" X="200" c="3" N="" Y="500" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="ee0f0f" X="600" c="3" N="" Y="500" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="eea10f" X="200" c="3" N="" Y="510" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="eea10f" X="600" c="3" N="" Y="510" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="f7ff00" X="200" c="3" N="" Y="520" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="f7ff00" X="600" c="3" N="" Y="520" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00ff21" X="200" c="3" N="" Y="530" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00ff21" X="600" c="3" N="" Y="530" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00e8ff" X="200" c="3" N="" Y="540" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00e8ff" X="600" c="3" N="" Y="540" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="0028ff" X="200" c="3" N="" Y="550" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="0028ff" X="600" c="3" N="" Y="550" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="6d00ff" X="200" c="3" N="" Y="560" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="6d00ff" X="600" c="3" N="" Y="560" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="69cdff" X="200" c="3" N="" Y="570" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="69cdff" X="600" c="3" N="" Y="570" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="3000" o="6a7495" X="400" H="400" N="" Y="600" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="750" H="105" Y="45" T="12" /><S P="0,0,0,0.2,0,0,0,0" c="3" L="800" X="400" H="10" Y="-5" T="1" /><S P="0,0,0,0.2,0,0,0,0" L="800" X="400" H="10" N="" Y="-800" T="1" /><S P="0,0,0.2,0.2,0,0,0,0" L="200" o="6a7495" X="-95" H="3000" Y="0" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" L="200" o="6a7495" X="895" H="3000" Y="0" T="12" /></S><D><DS Y="-151" X="360" /></D><O /><L><JD c="69cdff,200,1," P1="0,299" P2="800,299" /><JD c="69cdff,200,1," P1="0,100" P2="800,100" /><JD c="ffffff,50,1," P1="200,180" P2="200,181" /><JD c="ffffff,50,1," P1="600,180" P2="600,181" /><JD c="ffffff,50,1," P1="160,180" P2="160,181" /><JD c="ffffff,50,1," P1="560,180" P2="560,181" /><JD c="ffffff,50,1," P1="180,160" P2="180,161" /><JD c="ffffff,50,1," P1="580,160" P2="580,161" /><JD c="ffffff,50,1," P1="220,160" P2="220,161" /><JD c="ffffff,50,1," P1="620,160" P2="620,161" /><JD c="ffffff,50,1," P1="240,180" P2="240,181" /><JD c="ffffff,50,1," P1="640,180" P2="640,181" /></L></Z></C>',
    [2] = '<C><P G="0,4" MEDATA=";;;;-0;0::0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21:1-" L="1200" /><Z><S><S P="0,0,0,0.2,0,0,0,0" L="10" X="600" H="200" Y="350" T="1" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="250" H="105" Y="45" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="950" H="105" Y="45" T="12" /><S P="0,0,0,0.2,0,0,0,0" c="3" L="1200" X="600" H="10" Y="-5" T="1" /><S P="0,0,0.2,0.2,0,0,0,0" L="200" o="6a7495" X="-95" H="3000" Y="0" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" L="200" o="6a7495" X="1295" H="3000" Y="0" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="1200" m="" X="600" H="10" Y="95" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" m="" X="305" H="100" Y="48" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" m="" X="900" H="100" Y="48" T="0" /><S P="0,0,0,0,0,0,0,0" c="3" L="10" m="" X="600" H="150" Y="175" T="0" /><S P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" m="" X="600" H="10" Y="791" T="0" /><S P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="316" H="200" Y="-129" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="407" H="200" Y="-133" T="12" /><S P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="363" H="100" Y="-92" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="ee0f0f" X="160" c="3" N="" Y="440" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="ee0f0f" X="760" c="3" N="" Y="440" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="ee0f0f" X="440" c="3" N="" Y="440" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="ee0f0f" X="1040" c="3" N="" Y="440" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="eea10f" X="160" c="3" N="" Y="450" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="eea10f" X="760" c="3" N="" Y="450" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="eea10f" X="440" c="3" N="" Y="450" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="eea10f" X="1040" c="3" N="" Y="450" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="f7ff00" X="160" c="3" N="" Y="460" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="f7ff00" X="760" c="3" N="" Y="460" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="f7ff00" X="440" c="3" N="" Y="460" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="f7ff00" X="1040" c="3" N="" Y="460" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="00ff21" X="160" c="3" N="" Y="470" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="00ff21" X="760" c="3" N="" Y="470" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="00ff21" X="440" c="3" N="" Y="470" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="00ff21" X="1040" c="3" N="" Y="470" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="00e8ff" X="160" c="3" N="" Y="480" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="00e8ff" X="760" c="3" N="" Y="480" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="00e8ff" X="440" c="3" N="" Y="480" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="00e8ff" X="1040" c="3" N="" Y="480" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="0028ff" X="160" c="3" N="" Y="490" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="0028ff" X="760" c="3" N="" Y="490" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="0028ff" X="440" c="3" N="" Y="490" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="0028ff" X="1040" c="3" N="" Y="490" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="6d00ff" X="160" c="3" N="" Y="500" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="6d00ff" X="760" c="3" N="" Y="500" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="6d00ff" X="440" c="3" N="" Y="500" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="6d00ff" X="1040" c="3" N="" Y="500" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="69cdff" X="160" c="3" N="" Y="510" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="69cdff" X="760" c="3" N="" Y="510" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="69cdff" X="440" c="3" N="" Y="510" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="140" o="69cdff" X="1040" c="3" N="" Y="510" T="13" /><S P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="360" H="100" Y="-206" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="3000" o="6a7495" X="400" H="400" N="" Y="600" T="12" /><S P="0,0,0,0.2,0,0,0,0" L="1200" X="600" H="10" Y="-800" T="1" /></S><D><DS Y="-141" X="365" /></D><O /><L><JD c="69cdff,200,1," P1="0,300" P2="1200,300" /><JD c="69cdff,200,1," P1="0,100" P2="1200,100" /><JD c="ffffff,50,1," P1="160,180" P2="160,181" /><JD c="ffffff,50,1," P1="760,180" P2="760,181" /><JD c="ffffff,50,1," P1="440,180" P2="440,181" /><JD c="ffffff,50,1," P1="1040,180" P2="1040,181" /><JD c="ffffff,50,1," P1="120,180" P2="120,181" /><JD c="ffffff,50,1," P1="720,180" P2="720,181" /><JD c="ffffff,50,1," P1="400,180" P2="400,181" /><JD c="ffffff,50,1," P1="1000,180" P2="1000,181" /><JD c="ffffff,50,1," P1="140,160" P2="140,161" /><JD c="ffffff,50,1," P1="740,160" P2="740,161" /><JD c="ffffff,50,1," P1="420,160" P2="420,161" /><JD c="ffffff,50,1," P1="1020,160" P2="1020,161" /><JD c="ffffff,50,1," P1="180,160" P2="180,161" /><JD c="ffffff,50,1," P1="780,160" P2="780,161" /><JD c="ffffff,50,1," P1="460,160" P2="460,161" /><JD c="ffffff,50,1," P1="1060,160" P2="1060,161" /><JD c="ffffff,50,1," P1="200,180" P2="200,181" /><JD c="ffffff,50,1," P1="800,180" P2="800,181" /><JD c="ffffff,50,1," P1="480,180" P2="480,181" /><JD c="ffffff,50,1," P1="1080,180" P2="1080,181" /></L></Z></C>',
    [3] = 'The Rainbow',
    [4] = 'Kralizmox#0000',
    [6] = '19554034040.png'
  },
  [39] = {
    [1] = '<C><P F="7" G="0,4" MEDATA=";1,1;;;-0;0:::1-"/><Z><S><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="400" Y="175" L="10" H="158" P="0,0,0.2,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="10" X="342" Y="264" L="108" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="458" Y="264" L="108" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="326" Y="214" L="68" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="474" Y="214" L="68" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="355" Y="184" L="10" H="66" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="445" Y="184" L="10" H="66" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="51" Y="207" L="10" H="66" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="751" Y="207" L="10" H="66" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="377" Y="156" L="48" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="423" Y="156" L="48" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="25" Y="179" L="48" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="775" Y="179" L="48" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="293" Y="238" L="10" H="59" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="507" Y="238" L="10" H="59" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="190" Y="378" L="139" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="610" Y="378" L="139" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="190" Y="328" L="139" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="611" Y="328" L="139" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="126" Y="352" L="10" H="59" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="546" Y="352" L="10" H="59" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="255" Y="354" L="10" H="57" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="676" Y="354" L="10" H="57" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="50" Y="300" L="100" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="750" Y="300" L="100" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="73" Y="240" L="55" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="727" Y="240" L="55" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="96" Y="270" L="10" H="68" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="704" Y="270" L="10" H="68" P="0,0,0.1,0.2,0,0,0,0" c="3"/></S><D><T X="335" Y="251" spawn="2"/><T X="465" Y="251" spawn="2"/><T X="190" Y="366" spawn="1"/><T X="610" Y="366" spawn="1"/><T X="41" Y="281" spawn="3"/><T X="761" Y="281" spawn="3"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="7" G="0,4" MEDATA=";3,1;;;-0;0:::1-"/><Z><S><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="178" L="10" H="152" P="0,0,0.2,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="10" X="526" Y="264" L="144" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="674" Y="264" L="144" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="459" Y="238" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="741" Y="238" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="508" Y="214" L="104" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="692" Y="214" L="104" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="555" Y="184" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="645" Y="184" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="577" Y="156" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="623" Y="156" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="298" Y="328" L="308" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="902" Y="328" L="308" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="298" Y="378" L="308" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="902" Y="378" L="308" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="149" Y="352" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="753" Y="352" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="447" Y="352" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1051" Y="352" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="69" Y="300" L="138" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1131" Y="300" L="138" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="133" Y="270" L="10" H="68" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1067" Y="270" L="10" H="68" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="92" Y="240" L="92" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1108" Y="240" L="92" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="51" Y="207" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1149" Y="207" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="24" Y="179" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1176" Y="179" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/></S><D><P X="360" Y="35" T="131" C="555D77" P="0,0"/><P X="840" Y="35" T="131" C="555D77" P="0,0"/><T X="535" Y="251" spawn="2"/><T X="665" Y="251" spawn="2"/><T X="300" Y="366" spawn="1"/><T X="900" Y="366" spawn="1"/><T X="41" Y="281" spawn="3"/><T X="1159" Y="281" spawn="3"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Platforms',
    [4] = 'Refletz#6472',
    [6] = '196599446e1.png'
  },
  [40] =
  {
    [1] = '<C><P G="0,4" L="800"/><Z><S><S T="12" X="400" Y="500" L="1600" H="300" P="0,0,0.1,0.2,0,0,0,0" o="6A7495" c="4" N=""/><S T="12" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" m=""/><S T="12" X="400" Y="175" L="800" H="350" P="0,0,0,0,0,0,0,0" o="121212" c="4"/><S T="12" X="400" Y="-400" L="830" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="400" Y="180" L="10" H="160" P="0,0,0,0,0,0,0,0" o="272727" c="3" friction="-100,-20"/><S T="12" X="400" Y="-50" L="800" H="100" P="0,0,0,0.2,0,0,0,0" o="0d0906" c="3"/><S T="12" X="400" Y="345" L="10" H="200" P="0,0,0,0.2,0,0,0,0" o="FFFFFF" N=""/><S T="12" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" o="0D0906" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0" m=""/><S T="12" X="400" Y="795" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="-5" Y="400" L="10" H="1600" P="0,0,0.2,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="805" Y="400" L="10" H="1600" P="0,0,0.2,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="80" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="720" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="318" Y="-204" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-210" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-169" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="50" L="10" H="100" P="0,0,0,0,0,0,0,0" o="272727" c="4" friction="-100,-20"/><S T="12" X="360" Y="-283" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="13" X="208" Y="314" L="37" P="0,0,0,0,0,0,0,0" o="181818" c="4"/><S T="13" X="583" Y="52" L="37" P="0,0,0,0,180,0,0,0" o="181818" c="4"/><S T="13" X="588" Y="140" L="37" P="0,0,0,0,180,0,0,0" o="181818" c="4"/><S T="12" X="237" Y="159" L="15" H="320" P="0,0,0,0,0,0,0,0" o="181818" c="4"/><S T="12" X="554" Y="207" L="15" H="320" P="0,0,0,0,180,0,0,0" o="181818" c="4"/><S T="12" X="400" Y="270" L="700" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3"/><S T="12" X="400" Y="185" L="700" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3"/><S T="12" X="400" Y="95" L="700" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3"/></S><D><T X="321" Y="161" spawn="2"/><T X="441" Y="161" spawn="2"/><T X="321" Y="246" spawn="1"/><T X="441" Y="246" spawn="1"/><T X="321" Y="346" spawn="3"/><T X="442" Y="346" spawn="3"/><DS X="365" Y="-200"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" G="0,4" /><Z><S><S T="12" X="600" Y="500" L="2000" H="300" P="0,0,0.1,0.2,0,0,0,0" o="6A7495" c="4" N=""/><S T="12" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" m=""/><S T="12" X="600" Y="175" L="1200" H="350" P="0,0,0.1,0.2,0,0,0,0" o="121212" c="4"/><S T="13" X="1000" Y="314" L="37" P="0,0,0,0,0,0,0,0" o="181818" c="4"/><S T="12" X="600" Y="-790" L="1220" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="600" Y="160" L="10" H="130" P="0,0,0,0,0,0,0,0" o="272727" c="3" friction="-100,-20"/><S T="12" X="1028" Y="159" L="15" H="320" P="0,0,0,0,0,0,0,0" o="181818" c="4"/><S T="12" X="1085" Y="52" L="150" H="15" P="0,0,0,0,-140,0,0,0" o="181818" c="4"/><S T="12" X="600" Y="-50" L="1200" H="100" P="0,0,0,0.2,0,0,0,0" o="0d0906" c="3"/><S T="12" X="600" Y="330" L="10" H="220" P="0,0,0,0.2,0,0,0,0" o="FFFFFF" N=""/><S T="12" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" o="0D0906" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0" m=""/><S T="12" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="-5" Y="200" L="10" H="2000" P="0,0,0.2,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="1205" Y="200" L="10" H="2000" P="0,0,0.2,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="80" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="1120" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="600" Y="455" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="318" Y="-204" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-210" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-169" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-283" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="13" X="208" Y="314" L="37" P="0,0,0,0,0,0,0,0" o="181818" c="4"/><S T="13" X="384" Y="314" L="37" P="0,0,0,0,0,0,0,0" o="181818" c="4"/><S T="13" X="780" Y="52" L="37" P="0,0,0,0,180,0,0,0" o="181818" c="4"/><S T="13" X="785" Y="140" L="37" P="0,0,0,0,180,0,0,0" o="181818" c="4"/><S T="12" X="600" Y="50" L="10" H="100" P="0,0,0,0,0,0,0,0" o="272727" c="4" friction="-100,-20"/><S T="12" X="237" Y="159" L="15" H="320" P="0,0,0,0,0,0,0,0" o="181818" c="4"/><S T="12" X="413" Y="159" L="15" H="320" P="0,0,0,0,0,0,0,0" o="181818" c="4"/><S T="12" X="751" Y="207" L="15" H="320" P="0,0,0,0,180,0,0,0" o="181818" c="4"/><S T="12" X="600" Y="270" L="1100" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3"/><S T="12" X="600" Y="185" L="1100" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3"/><S T="12" X="600" Y="95" L="1100" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3"/></S><D><T X="540" Y="160" spawn="2"/><T X="660" Y="160" spawn="2"/><T X="140" Y="160" spawn="6"/><T X="1060" Y="160" spawn="6"/><T X="140" Y="246" spawn="4"/><T X="1060" Y="246" spawn="4"/><T X="140" Y="345" spawn="5"/><T X="1060" Y="345" spawn="5"/><T X="540" Y="245" spawn="1"/><T X="660" Y="245" spawn="1"/><T X="540" Y="345" spawn="3"/><T X="661" Y="345" spawn="3"/><DS X="365" Y="-200"/></D><O/><L/></Z></C>',
    [3] = 'Some chords',
    [4] = 'Tanarchosl#4785 and Tanatosl#0000',
    [6] = '19539e5756b.png'
  },
  [41] =
  {
    [1] = '<C><P F="8" G="0,4" /><Z><S><S T="12" X="-10" Y="25" L="20" H="270" P="0,0,0,0,0,0,0,0" o="FF0000" m=""/><S T="12" X="810" Y="25" L="20" H="270" P="0,0,0,0,0,0,0,0" o="FF0000" m=""/><S T="12" X="400" Y="430" L="1600" H="200" P="0,0,0.1,0.1,0,0,0,0" o="6A7495" c="3" N=""/><S T="12" X="-5" Y="255" L="10" H="200" P="0,0,1,0.2,0,0,0,0" o="AFAFAF" c="3"/><S T="12" X="805" Y="255" L="10" H="200" P="0,0,1,0.2,0,0,0,0" o="AFAFAF" c="3"/><S T="12" X="-60" Y="505" L="120" H="10" P="0,0,20,0.2,0,0,0,0" o="FF0000" c="2" m=""/><S T="12" X="860" Y="505" L="120" H="10" P="0,0,20,0.2,0,0,0,0" o="FF0000" c="2" m=""/><S T="12" X="-5" Y="425" L="10" H="170" P="0,0,9,0,0,0,0,0" o="ff0000" c="3" m=""/><S T="12" X="805" Y="425" L="10" H="170" P="0,0,9,0,0,0,0,0" o="ff0000" c="3" m=""/><S T="12" X="50" Y="210" L="10" H="270" P="0,0,0.3,0.2,0,0,0,0" o="1c1c1c" c="4"/><S T="2" X="50" Y="50" L="90" H="90" P="0,0,0,0.8,1,0,0,0"/><S T="12" X="750" Y="210" L="10" H="270" P="0,0,0.3,0.2,0,0,0,0" o="1c1c1c" c="4"/><S T="12" X="50" Y="50" L="80" H="80" P="0,0,0,0.2,0,0,0,0" o="1f1f1f" c="3" friction="-100,-20"/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="2" X="750" Y="50" L="90" H="90" P="0,0,0,0.8,-1,0,0,0"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="750" Y="50" L="80" H="80" P="0,0,0,0.2,0,0,0,0" o="1F1F1F" c="3" friction="-100,-20"/><S T="12" X="400" Y="-100" L="820" H="20" P="0,0,0,0,0,0,0,0" o="FF0000" N="" m=""/><S T="12" X="-60" Y="155" L="120" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF"/><S T="12" X="860" Y="155" L="120" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF"/><S T="12" X="-5" Y="158" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF"/><S T="12" X="805" Y="158" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF"/><S T="12" X="-115" Y="330" L="20" H="360" P="1,1e-9,20,0,0,1,0,0" o="FFFFFF"/><S T="12" X="-135" Y="330" L="20" H="360" P="0,0,20,0,0,0,0,0" o="FF0000" m=""/><S T="12" X="915" Y="330" L="20" H="360" P="1,1e-9,20,0,0,1,0,0" o="FFFFFF"/><S T="12" X="935" Y="330" L="20" H="360" P="1,1e-9,20,0,0,1,0,0" o="FF0000" m=""/><S T="9" X="-65" Y="470" L="110" H="20" P="0,0,0,0,0,0,0,0" m="" archAcc="-20"/><S T="9" X="865" Y="470" L="110" H="20" P="0,0,0,0,0,0,0,0" m="" archAcc="-20"/><S T="3" X="802" Y="155" L="10" H="15" P="0,0,0,11,0,0,0,0" c="3"/><S T="3" X="-2" Y="155" L="10" H="15" P="0,0,0,11,0,0,0,0" c="3"/><S T="12" X="400" Y="-5" L="810" H="10" P="0,0,0,0.5,0,0,0,0" o="FF0000" c="3" m=""/><S T="17" X="400" Y="430" L="1200" H="200" P="0,0,0.1,0.1,0,0,0,0" c="3" N=""/><S T="12" X="399" Y="98" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="400" Y="335" L="30" H="10" P="0,0,0,0.2,0,0,0,0" o="FFFFFF" c="4" N=""/><S T="15" X="-60" Y="245" L="100" H="170" P="0,0,0,0,0,0,0,0" archAcc="-20" archCheeseMax="0" archMax="2"/><S T="15" X="860" Y="245" L="100" H="170" P="0,0,0,0,0,0,0,0" archAcc="-20" archCheeseMax="0" archMax="2"/><S T="12" X="400" Y="350" L="800" H="30" P="1,0,0,1,90,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="-115" Y="330" L="20" H="360" P="1,1e-9,20,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-115" Y="330" L="20" H="360" P="1,1e-9,20,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-115" Y="330" L="20" H="360" P="1,1e-9,20,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-115" Y="330" L="20" H="360" P="1,1e-9,20,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="915" Y="330" L="20" H="360" P="1,1e-9,20,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="915" Y="330" L="20" H="360" P="1,1e-9,20,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="915" Y="330" L="20" H="360" P="1,1e-9,20,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="915" Y="330" L="20" H="360" P="1,1e-9,20,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="935" Y="330" L="20" H="360" P="1,1e-9,20,0,0,1,0,0" o="FF0000" m=""/><S T="12" X="935" Y="330" L="20" H="360" P="1,1e-9,20,0,0,1,0,0" o="FF0000" m=""/><S T="12" X="935" Y="330" L="20" H="360" P="1,1e-9,20,0,0,1,0,0" o="FF0000" m=""/><S T="12" X="935" Y="330" L="20" H="360" P="1,1e-9,20,0,0,1,0,0" o="FF0000" m=""/></S><D><P X="400" Y="93" T="131" C="7f7f7f" P="0,0"/><P X="-82" Y="170" T="41" P="1,0"/><P X="-38" Y="171" T="41" P="0,1"/><P X="418" Y="93" T="43" P="0,0"/><P X="387" Y="234" T="45" P="0,0"/><P X="400" Y="332" T="134" P="0,0"/><P X="29" Y="327" T="47" P="0,0"/><P X="407" Y="328" T="47" P="0,0"/><P X="200" Y="330" T="134" P="0,0"/><P X="50" Y="330" T="134" P="0,0"/><P X="268" Y="328" T="47" P="0,0"/><P X="600" Y="327" T="42" P="0,0"/><P X="547" Y="328" T="47" P="0,0"/><P X="686" Y="328" T="47" P="0,0"/><P X="827" Y="328" T="47" P="0,0"/><P X="168" Y="328" T="47" P="0,0"/><P X="836" Y="331" T="98" C="6f4a30,ffffff" P="1,0"/><P X="-77" Y="332" T="118" P="1,0"/><P X="50" Y="331" T="0" P="0,0"/><P X="750" Y="330" T="0" P="0,0"/><P X="-28" Y="150" T="92" C="75ff00,849319,ff0006,ff8a00" P="1,1"/><P X="828" Y="150" T="92" C="bb00ff,189390,3c23ee,000000" P="1,0"/><DS X="365" Y="-141"/></D><O/><L><JP M1="38" AXIS="-1,0" MV="Infinity,0.1"/><JP M1="38" AXIS="0,1"/><JR M1="24"/><JR M1="39"/><JR M1="40"/><JR M1="41"/><JR M1="42"/><JR M1="26"/><JR M1="43"/><JR M1="44"/><JR M1="45"/><JR M1="46"/><JR M1="27"/><JR M1="47"/><JR M1="48"/><JR M1="49"/><JR M1="50"/></L></Z></C>',
    [2] = '<C><P L="1200" F="8" G="0,4" playerForce="1.03" /><Z><S><S T="12" X="-5" Y="255" L="10" H="200" P="0,0,1,0.2,0,0,0,0" o="afafaf" c="3"/><S T="12" X="1205" Y="255" L="10" H="200" P="0,0,1,0.2,0,0,0,0" o="afafaf" c="3"/><S T="12" X="-5" Y="425" L="10" H="170" P="0,0,9,0,0,0,0,0" o="ff0000" c="3" m=""/><S T="12" X="1205" Y="425" L="10" H="170" P="0,0,9,0,0,0,0,0" o="ff0000" c="3" m=""/><S T="12" X="-10" Y="10" L="20" H="300" P="0,0,0,0,0,0,0,0" o="ff0000" m=""/><S T="12" X="1210" Y="10" L="20" H="300" P="0,0,0,0,0,0,0,0" o="ff0000" m=""/><S T="12" X="250" Y="210" L="10" H="270" P="0,0,0.3,0.2,0,0,0,0" o="1c1c1c" c="4"/><S T="2" X="250" Y="50" L="90" H="90" P="0,0,0,1,1,0,0,0"/><S T="12" X="950" Y="210" L="10" H="270" P="0,0,0.3,0.2,0,0,0,0" o="1c1c1c" c="4"/><S T="12" X="600" Y="-5" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" c="3" N="" m=""/><S T="12" X="600" Y="-140" L="1240" H="20" P="0,0,0,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="250" Y="50" L="80" H="80" P="0,0,0,0.2,0,0,0,0" o="1f1f1f" c="3" friction="-100,-20"/><S T="12" X="316" Y="-263" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="2" X="950" Y="50" L="90" H="90" P="0,0,0,1,-1,0,0,0"/><S T="12" X="407" Y="-267" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-232" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-340" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="950" Y="50" L="80" H="80" P="0,0,0,0.2,0,0,0,0" o="1F1F1F" c="3" friction="-100,-20"/><S T="12" X="-60" Y="155" L="120" H="10" P="0,0,10,0.2,0,0,0,0" o="FFFFFF"/><S T="12" X="1260" Y="155" L="120" H="10" P="0,0,10,0.2,0,0,0,0" o="FFFFFF"/><S T="12" X="-5" Y="158" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF"/><S T="12" X="1200" Y="158" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF"/><S T="12" X="-115" Y="330" L="20" H="360" P="0,0,20,0.2,0,0,0,0" o="FFFFFF" friction="-100,-20"/><S T="12" X="-135" Y="330" L="20" H="360" P="0,0,0,0,0,0,0,0" o="FF0000" c="2" m=""/><S T="12" X="1315" Y="330" L="20" H="360" P="0,0,20,0.2,0,0,0,0" o="FFFFFF" friction="-100,-20"/><S T="12" X="1335" Y="330" L="20" H="360" P="0,0,0,0,0,0,0,0" o="FF0000" c="2" m=""/><S T="12" X="-60" Y="505" L="100" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="1260" Y="505" L="100" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" m=""/><S T="9" X="-60" Y="450" L="100" H="20" P="0,0,0,0,0,0,0,0" m="" archAcc="-20"/><S T="9" X="1260" Y="450" L="100" H="20" P="0,0,0,0,0,0,0,0" m="" archAcc="-20"/><S T="3" X="1198" Y="155" L="10" H="15" P="0,0,0,20,0,0,0,0" c="3"/><S T="12" X="600" Y="430" L="2000" H="200" P="0,0,0.2,0.1,0,0,0,0" o="6A7495" c="3" N=""/><S T="17" X="600" Y="430" L="1600" H="200" P="0,0,0.2,0.1,0,0,0,0" c="3" N=""/><S T="3" X="-2" Y="155" L="10" H="15" P="0,0,0,20,0,0,0,0" c="3"/><S T="12" X="600" Y="98" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="600" Y="335" L="30" H="10" P="0,0,0,0.2,0,0,0,0" o="FFFFFF" c="4" N=""/><S T="15" X="-60" Y="245" L="100" H="170" P="0,0,0,0,0,0,0,0" archAcc="-20" archCheeseMax="0" archMax="2"/><S T="15" X="1260" Y="245" L="100" H="170" P="0,0,0,0,0,0,0,0" archAcc="-20" archCheeseMax="0" archMax="2"/><S T="12" X="600" Y="350" L="1200" H="30" P="1,0,0,1,90,0,0,0" o="FF0000" c="2" N="" m=""/></S><D><P X="600" Y="93" T="131" C="7f7f7f" P="0,0"/><P X="-82" Y="170" T="41" P="1,0"/><P X="-38" Y="171" T="41" P="0,1"/><P X="618" Y="93" T="43" P="0,0"/><P X="387" Y="234" T="45" P="0,0"/><P X="813" Y="234" T="45" P="0,1"/><P X="400" Y="335" T="134" P="0,0"/><P X="1110" Y="332" T="134" P="0,0"/><P X="955" Y="332" T="134" P="0,0"/><P X="60" Y="330" T="134" P="0,0"/><P X="800" Y="332" T="134" P="0,0"/><P X="29" Y="327" T="47" P="0,0"/><P X="407" Y="328" T="47" P="0,0"/><P X="235" Y="335" T="134" P="0,0"/><P X="268" Y="328" T="47" P="0,0"/><P X="600" Y="327" T="42" P="0,0"/><P X="547" Y="328" T="47" P="0,0"/><P X="687" Y="328" T="47" P="0,0"/><P X="827" Y="328" T="47" P="0,0"/><P X="967" Y="328" T="47" P="0,0"/><P X="1106" Y="328" T="47" P="0,0"/><P X="1247" Y="328" T="47" P="0,0"/><P X="168" Y="328" T="47" P="0,0"/><P X="1231" Y="331" T="98" C="6f4a30,ffffff" P="1,0"/><P X="-77" Y="332" T="118" P="1,0"/><P X="250" Y="330" T="0" P="0,0"/><P X="950" Y="331" T="0" P="0,0"/><P X="-28" Y="150" T="92" C="75ff00,849319,ff0006,ff8a00" P="1,1"/><P X="1228" Y="150" T="92" C="bb00ff,189390,3c23ee,FF0000" P="1,0"/><DS X="365" Y="-275"/></D><O/><L><JP M1="38" AXIS="-1,0" MV="Infinity,0.1"/><JP M1="38" AXIS="0,1"/></L></Z></C>',
    [3] = 'Revamped soccer',
    [4] = 'Tanarchosl#4785 and Tanatosl#0000',
    [6] = '19539e5756b.png'
  },
  [42] =
  {
    [1] = '<C><P F="10" G="0,4" /><Z><S><S T="15" X="865" Y="205" L="125" H="190" P="0,0,0,0,0,0,0,0" archAcc="-20" archCheeseMax="0" archMax="2"/><S T="21" X="400" Y="40" L="800" H="20" P="0,0,0,0.8,-180,0,0,0" N="" tint="D84801" name="top" target="down" outputSpeedBonus="-1" invertOutputPoint="1"/><S T="12" X="-200" Y="180" L="400" H="450" P="0,0,0.3,0.2,0,0,0,0" o="0C0000" c="4"/><S T="12" X="1000" Y="180" L="400" H="450" P="0,0,0.3,0.2,0,0,0,0" o="0C0000" c="4"/><S T="12" X="785" Y="65" L="70" H="20" P="0,0,0,1.2,-125,0,0,0" o="490E00" c="2"/><S T="12" X="-5" Y="405" L="10" H="205" P="0,0,10,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="-5" Y="60" L="10" H="100" P="0,0,10,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="805" Y="60" L="10" H="100" P="0,0,10,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="805" Y="405" L="10" H="205" P="0,0,10,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="-105" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="-125" Y="305" L="20" H="400" P="0,0,0,0,0,0,0,0" o="FFF200" c="2" m=""/><S T="12" X="905" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="925" Y="300" L="20" H="400" P="0,0,0,0,0,0,0,0" o="FFF200" m=""/><S T="12" X="316" Y="-253" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-257" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-222" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-330" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="-60" Y="500" L="100" H="10" P="0,0,20,0,0,0,0,0" o="FF0000" c="2" m=""/><S T="12" X="860" Y="500" L="100" H="10" P="0,0,20,0,0,0,0,0" o="FF0000" c="2" m=""/><S T="12" X="-105" Y="200" L="20" H="200" P="0,0,0,0,0,0,0,0" o="FFFFFF" c="4"/><S T="12" X="905" Y="210" L="20" H="200" P="0,0,0,0,0,0,0,0" o="FFFFFF" c="4"/><S T="12" X="15" Y="340" L="70" H="20" P="0,0,0,1.5,-305,0,0,0" o="490E00" c="2"/><S T="9" X="-60" Y="445" L="100" H="20" P="0,0,0,0,0,0,0,0" m="" archAcc="-20"/><S T="9" X="860" Y="445" L="100" H="20" P="0,0,0,0,0,0,0,0" m="" archAcc="-20"/><S T="12" X="-70" Y="305" L="140" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" N=""/><S T="21" X="805" Y="165" L="420" H="20" P="0,0,0,0.5,-90,0,0,0" c="3" tint="D84801" name="right" target="left" outputSpeedBonus="10" addInputGroundSpeed="1"/><S T="12" X="15" Y="65" L="70" H="20" P="0,0,0,1.2,125,0,0,0" o="490E00" c="2"/><S T="12" X="785" Y="340" L="70" H="20" P="0,0,0,1,305,0,0,0" o="490E00" c="2"/><S T="12" X="-70" Y="105" L="140" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" N=""/><S T="12" X="870" Y="105" L="140" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" N=""/><S T="12" X="400" Y="475" L="1600" H="200" P="0,0,0,0.2,0,0,0,0" o="0C0000" c="4" N=""/><S T="21" X="400" Y="370" L="800" H="20" P="0,0,0.1,0,0,0,0,0" c="3" N="" tint="D84801" name="down" target="top" inputSpeedBonus="-2" outputSpeedBonus="-1" invertOutputPoint="1"/><S T="12" X="400" Y="475" L="820" H="200" P="0,0,0,1.05,0,0,0,0" o="240000" c="2" N=""/><S T="12" X="400" Y="-5" L="800" H="80" P="0,0,0,0,0,0,0,0" o="1D0000" c="4"/><S T="12" X="400" Y="-40" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="3c0b0b" c="3"/><S T="12" X="400" Y="25" L="800" H="10" P="0,0,0.3,0,0,0,0,0" o="3c0b0b" c="3"/><S T="15" X="-65" Y="205" L="125" H="190" P="0,0,0,0,0,0,0,0" archAcc="-20" archCheeseMax="0" archMax="2"/><S T="12" X="870" Y="305" L="140" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" N=""/><S T="12" X="400" Y="400" L="820" H="20" P="1,0,0,1,90,0,0,0" o="C16000" c="2" N=""/><S T="21" X="-5" Y="165" L="420" H="20" P="0,0,0,0.5,90,0,0,0" c="3" tint="D84801" name="left" target="right" outputSpeedBonus="10" addInputGroundSpeed="1"/><S T="12" X="-105" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="-105" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="-105" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="-105" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="905" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="905" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="905" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="905" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/></S><D><P X="400" Y="170" T="131" C="1D0000" P="0,0"/><DC X="365" Y="-260"/><T X="400" Y="15" lobby="0"/><DS X="364" Y="-255"/></D><O/><L><JP M1="38" AXIS="-1,0" MV="Infinity,0.23333333333333334"/><JP M1="38" AXIS="0,1"/><JR M1="9"/><JR M1="40"/><JR M1="41"/><JR M1="42"/><JR M1="43"/><JR M1="11"/><JR M1="44"/><JR M1="45"/><JR M1="46"/><JR M1="47"/></L></Z></C>',
    [2] = '<C><P L="1200" F="10" G="0,4"/><Z><S><S T="12" X="-200" Y="190" L="400" H="450" P="0,0,0.3,0.2,0,0,0,0" o="0c0000" c="4"/><S T="21" X="-5" Y="175" L="420" H="20" P="0,0,0,0.5,90,0,0,0" c="3" tint="D84801" name="left" target="right" outputSpeedBonus="10" addInputGroundSpeed="1"/><S T="12" X="1400" Y="190" L="400" H="450" P="0,0,0.3,0.2,0,0,0,0" o="0c0000" c="4"/><S T="12" X="1185" Y="65" L="70" H="20" P="0,0,0.5,1.2,-125,0,0,0" o="591600" c="2"/><S T="12" X="-5" Y="405" L="10" H="205" P="0,0,10,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="-5" Y="70" L="10" H="80" P="0,0,10,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="1205" Y="70" L="10" H="80" P="0,0,10,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="1205" Y="405" L="10" H="205" P="0,0,10,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="-105" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="-125" Y="305" L="20" H="400" P="0,0,0,0,0,0,0,0" o="FFF200" c="2" m=""/><S T="12" X="1325" Y="305" L="20" H="400" P="0,0,0,0,0,0,0,0" o="FFF200" c="2" m=""/><S T="12" X="1305" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="21" X="600" Y="40" L="1200" H="20" P="0,0,0,0.8,-180,0,0,0" N="" tint="D84801" name="top" target="down" outputSpeedBonus="-1" invertOutputPoint="1"/><S T="12" X="316" Y="-253" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-257" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-222" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-330" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="-60" Y="500" L="100" H="10" P="0,0,20,0,0,0,0,0" o="FF0000" c="2" m=""/><S T="12" X="1260" Y="500" L="100" H="10" P="0,0,20,0,0,0,0,0" o="FF0000" c="2" m=""/><S T="12" X="-105" Y="200" L="20" H="200" P="0,0,0,0,0,0,0,0" o="FFFFFF" c="4"/><S T="12" X="1305" Y="200" L="20" H="200" P="0,0,0,0,0,0,0,0" o="FFFFFF" c="4"/><S T="12" X="15" Y="340" L="70" H="20" P="0,0,0.5,1.2,-305,0,0,0" o="591600" c="2"/><S T="9" X="-60" Y="445" L="100" H="20" P="0,0,0,0,0,0,0,0" m="" archAcc="-20"/><S T="9" X="1260" Y="445" L="100" H="20" P="0,0,0,0,0,0,0,0" m="" archAcc="-20"/><S T="12" X="-70" Y="305" L="140" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" N=""/><S T="21" X="1205" Y="175" L="420" H="20" P="0,0,0,0.5,-90,0,0,0" c="3" tint="D84801" name="right" target="left" outputSpeedBonus="10" addInputGroundSpeed="1"/><S T="12" X="15" Y="65" L="70" H="20" P="0,0,0.5,1.2,125,0,0,0" o="591600" c="2"/><S T="12" X="1185" Y="340" L="70" H="20" P="0,0,0.5,1.2,305,0,0,0" o="591600" c="2"/><S T="12" X="-70" Y="105" L="140" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" N=""/><S T="12" X="1270" Y="105" L="140" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" N=""/><S T="12" X="600" Y="477" L="2000" H="200" P="0,0,0,0.2,0,0,0,0" o="0c0000" c="4" N=""/><S T="21" X="600" Y="370" L="1200" H="20" P="0,0,0.1,0,0,0,0,0" c="3" N="" tint="D84801" name="down" target="top" inputSpeedBonus="-2" outputSpeedBonus="-1" invertOutputPoint="1"/><S T="12" X="600" Y="475" L="1230" H="200" P="0,0,0,1.05,0,0,0,0" o="240000" c="2" N=""/><S T="12" X="600" Y="5" L="1200" H="60" P="0,0,0,0,0,0,0,0" o="0c0000" c="4"/><S T="12" X="600" Y="-30" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="3c0b0b" c="3"/><S T="12" X="600" Y="25" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="3c0b0b" c="3"/><S T="15" X="-75" Y="205" L="125" H="190" P="0,0,0,0,0,0,0,0" archAcc="-20" archCheeseMax="0" archMax="2"/><S T="15" X="1275" Y="205" L="125" H="190" P="0,0,0,0,0,0,0,0" archAcc="-20" archCheeseMax="0" archMax="2"/><S T="12" X="1270" Y="305" L="140" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" N=""/><S T="12" X="600" Y="390" L="1200" H="20" P="1,0,0,1,90,0,0,0" o="c16000" c="2" N="" m=""/><S T="12" X="-105" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="-105" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="-105" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="-105" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="1305" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="1305" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="1305" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/><S T="12" X="1305" Y="305" L="20" H="400" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" m=""/></S><D><P X="600" Y="172" T="131" C="1D0000" P="0,0"/><DC X="365" Y="-260"/><T X="600" Y="10" lobby="0"/><DS X="364" Y="-255"/></D><O/><L><JP M1="39" AXIS="-1,0" MV="Infinity,0.16666666666666666"/><JP M1="39" AXIS="0,1"/><JR M1="8"/><JR M1="40"/><JR M1="41"/><JR M1="42"/><JR M1="43"/><JR M1="11"/><JR M1="44"/><JR M1="45"/><JR M1="46"/><JR M1="47"/></L></Z></C>',
    [3] = 'Brazhell soccer',
    [4] = 'Tanarchosl#5748, Tanatosl#0000, Emperor#6297 and Basker#2338',
    [6] = '19539e5756b.png'
  },
  [43] =
  {
    [1] = '<C><P G="0,4" /><Z><S><S T="12" X="400" Y="65" L="800" H="600" P="0,0,0.1,0.2,0,0,0,0" o="050505" c="4"/><S T="12" X="400" Y="160" L="120" H="370" P="0,0,0,0,0,0,0,0" o="111111" c="3"/><S T="12" X="400" Y="-20" L="800" H="10" P="0,0,0,0.2,0,0,0,0" o="111111" c="3"/><S T="12" X="400" Y="100" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="111111" c="3"/><S T="12" X="400" Y="267" L="800" H="10" P="0,0,0,0.3,0,0,0,0" o="111111" c="3"/><S T="12" X="170" Y="150" L="330" H="10" P="0,0,0,0,0,0,0,0" o="111111" c="3"/><S T="12" X="630" Y="150" L="330" H="10" P="0,0,0,0,0,0,0,0" o="111111" c="3"/><S T="12" X="450" Y="150" L="60" H="60" P="0,0,0,0,45,0,0,0" o="131313" c="3"/><S T="12" X="400" Y="-20" L="60" H="60" P="0,0,0,0,45,0,0,0" o="131313" c="3"/><S T="12" X="450" Y="-20" L="60" H="60" P="0,0,0,0,35,0,0,0" o="131313" c="3"/><S T="12" X="350" Y="-20" L="60" H="60" P="0,0,0,0,55,0,0,0" o="131313" c="3"/><S T="12" X="400" Y="460" L="1600" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="350" Y="150" L="60" H="60" P="0,0,0,0,45,0,0,0" o="131313" c="3"/><S T="12" X="0" Y="125" L="60" H="60" P="0,0,0,0,0,0,0,0" o="131313" c="3"/><S T="12" X="800" Y="125" L="60" H="60" P="0,0,0,0,0,0,0,0" o="131313" c="3"/><S T="12" X="0" Y="297" L="60" H="60" P="0,0,0,0,0,0,0,0" o="131313" c="3"/><S T="12" X="800" Y="292" L="60" H="60" P="0,0,0,0,0,0,0,0" o="131313" c="3"/><S T="12" X="400" Y="240" L="10" H="90" P="1,0,0,1.2,45,0,0,0" o="111111" c="4"/><S T="13" X="430" Y="210" L="10" P="1,0,50,1.2,0,0,0,0" o="c1ffff" c="2"/><S T="13" X="370" Y="270" L="15" P="1,0,50,1.2,0,0,0,0" o="c1ffff" c="2"/><S T="12" X="350" Y="150" L="30" H="30" P="0,0,0,0.8,45,0,0,0" o="c1ffff" c="2"/><S T="12" X="400" Y="-20" L="30" H="30" P="0,0,0,0.8,45,0,0,0" o="c1ffff" c="2"/><S T="12" X="450" Y="-20" L="30" H="30" P="0,0,0,0.8,35,0,0,0" o="c1ffff" c="2"/><S T="12" X="350" Y="-20" L="30" H="30" P="0,0,0,0.8,55,0,0,0" o="c1ffff" c="2"/><S T="12" X="0" Y="125" L="30" H="30" P="0,0,0,1,45,0,0,0" o="c1ffff" c="2"/><S T="12" X="800" Y="125" L="30" H="30" P="0,0,0,1,45,0,0,0" o="c1ffff" c="2"/><S T="12" X="0" Y="297" L="30" H="30" P="0,0,0,1,45,0,0,0" o="c1ffff" c="2"/><S T="12" X="800" Y="292" L="30" H="30" P="0,0,0,1,45,0,0,0" o="c1ffff" c="2"/><S T="12" X="450" Y="150" L="30" H="30" P="0,0,0,0.8,45,0,0,0" o="c1ffff" c="2"/><S T="12" X="400" Y="362" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" o="111111" c="3" N=""/><S T="9" X="400" Y="420" L="800" H="10" P="0,0,0,0,0,0,0,0" m="" archAcc="-2" archCheeseMax="0" archMax="1"/><S T="12" X="400" Y="450" L="820" H="20" P="1,1e-9,0,0,0,1,0,0" o="FF0000" m=""/><S T="12" X="-35" Y="110" L="70" H="700" P="0,0,0.2,0.2,0,0,0,0" o="6A7495" N=""/><S T="12" X="836" Y="110" L="70" H="700" P="0,0,0.2,0.2,0,0,0,0" o="6A7495" N=""/><S T="12" X="400" Y="-225" L="800" H="20" P="0,0,0,0,0,0,0,0" o="FF0000" c="2" m=""/><S T="12" X="116" Y="-140" L="20" H="150" P="0,0,0.2,0.2,0,0,0,0" o="050505" c="3"/><S T="12" X="207" Y="-140" L="20" H="150" P="0,0,0.2,0.2,0,0,0,0" o="050505" c="3"/><S T="12" X="163" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="050505" c="3"/><S T="12" X="160" Y="-196" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="050505" c="3"/><S T="9" X="400" Y="240" L="30" H="50" P="0,0,0,0,0,0,0,0" tint="FF0000" archAcc="-1" archCheeseMax="0" archMax="1"/><S T="9" X="400" Y="70" L="30" H="50" P="0,0,0,0,0,0,0,0" tint="00FF18" archAcc="1" archCheeseMax="0" archMax="1"/><S T="21" X="40" Y="292" L="40" H="25" P="0,0,0,0,90,0,0,0" c="3" tint="FF0000" name="a" target="b"/><S T="21" X="760" Y="292" L="40" H="25" P="0,0,0,0,-90,0,0,0" c="3" tint="FF0000" name="c" target="d"/><S T="21" X="40" Y="125" L="40" H="25" P="0,0,0,0,90,0,0,0" c="3" tint="FF0000" name="b" target="a"/><S T="21" X="760" Y="125" L="40" H="25" P="0,0,0,0,-90,0,0,0" c="3" tint="FF0000" name="d" target="c"/><S T="12" X="400" Y="390" L="20" H="140" P="0,0,0,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="350" Y="315" L="60" H="60" P="0,0,0,0,45,0,0,0" o="131313" c="3" N=""/><S T="12" X="350" Y="315" L="30" H="30" P="0,0,0,0.8,45,0,0,0" o="c1ffff" c="2" N=""/><S T="12" X="450" Y="315" L="60" H="60" P="0,0,0,0,45,0,0,0" o="131313" c="3" N=""/><S T="12" X="450" Y="315" L="30" H="30" P="0,0,0,0.8,45,0,0,0" o="c1ffff" c="2" N=""/><S T="12" X="400" Y="316" L="100" H="10" P="0,0,0,0.8,0,0,0,0" o="c1ffff" c="2" N=""/></S><D><T X="250" Y="305" spawn="1"/><T X="550" Y="305" spawn="1"/><T X="100" Y="305" spawn="3"/><T X="700" Y="305" spawn="3"/><T X="200" Y="140" spawn="2"/><T X="600" Y="140" spawn="2"/><DS X="165" Y="-141"/></D><O><O X="370" Y="270" C="22" P="0"/><O X="430" Y="210" C="22" P="0"/><O X="400" Y="240" C="12" nosync="" P="0"/></O><L><JR M1="31"/></L></Z></C>',
    [2] = '<C><P L="1200" G="0,4"/><Z><S><S T="12" X="600" Y="65" L="1200" H="600" P="0,0,0.1,0.2,0,0,0,0" o="050505" c="4"/><S T="12" X="600" Y="160" L="120" H="370" P="0,0,0,0,0,0,0,0" o="111111" c="3"/><S T="12" X="600" Y="-20" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" o="111111" c="3"/><S T="12" X="600" Y="150" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="111111" c="3"/><S T="12" X="600" Y="267" L="1200" H="10" P="0,0,0,0.3,0,0,0,0" o="111111" c="3"/><S T="12" X="600" Y="150" L="1200" H="10" P="0,0,0,0,0,0,0,0" o="111111" c="3"/><S T="12" X="600" Y="100" L="1200" H="10" P="0,0,0,0,0,0,0,0" o="111111" c="3"/><S T="12" X="650" Y="150" L="60" H="60" P="0,0,0,0,45,0,0,0" o="131313" c="3"/><S T="12" X="650" Y="-20" L="60" H="60" P="0,0,0,0,35,0,0,0" o="131313" c="3"/><S T="12" X="600" Y="-20" L="60" H="60" P="0,0,0,0,45,0,0,0" o="131313" c="3"/><S T="12" X="600" Y="460" L="2000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="550" Y="150" L="60" H="60" P="0,0,0,0,45,0,0,0" o="131313" c="3"/><S T="12" X="550" Y="-20" L="60" H="60" P="0,0,0,0,55,0,0,0" o="131313" c="3"/><S T="12" X="0" Y="125" L="60" H="60" P="0,0,0,0,0,0,0,0" o="131313" c="3"/><S T="12" X="1200" Y="125" L="60" H="60" P="0,0,0,0,0,0,0,0" o="131313" c="3"/><S T="12" X="0" Y="292" L="60" H="60" P="0,0,0,0,0,0,0,0" o="131313" c="3"/><S T="12" X="1200" Y="292" L="60" H="60" P="0,0,0,0,0,0,0,0" o="131313" c="3"/><S T="12" X="600" Y="240" L="90" H="10" P="1,0,0,1.2,45,0,0,0" o="111111" c="4"/><S T="13" X="630" Y="270" L="15" P="1,0,50,1.2,0,0,0,0" o="c1ffff" c="2"/><S T="13" X="570" Y="208" L="10" P="1,0,50,1.2,0,0,0,0" o="c1ffff" c="2"/><S T="12" X="550" Y="140" L="30" H="30" P="0,0,0,1,45,0,0,0" o="c1ffff" c="2"/><S T="12" X="550" Y="-20" L="30" H="30" P="0,0,0,1,55,0,0,0" o="c1ffff" c="2"/><S T="12" X="650" Y="-20" L="30" H="30" P="0,0,0,1,35,0,0,0" o="c1ffff" c="2"/><S T="12" X="600" Y="-20" L="30" H="30" P="0,0,0,1,45,0,0,0" o="c1ffff" c="2"/><S T="12" X="0" Y="130" L="30" H="30" P="0,0,0,1.2,45,0,0,0" o="c1ffff" c="2"/><S T="12" X="1200" Y="130" L="30" H="30" P="0,0,0,1.2,45,0,0,0" o="c1ffff" c="2"/><S T="12" X="0" Y="292" L="30" H="30" P="0,0,0,1.2,45,0,0,0" o="c1ffff" c="2"/><S T="12" X="1200" Y="292" L="30" H="30" P="0,0,0,1.2,45,0,0,0" o="c1ffff" c="2"/><S T="12" X="650" Y="140" L="30" H="30" P="0,0,0,1,45,0,0,0" o="c1ffff" c="2"/><S T="12" X="600" Y="362" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" o="111111" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0" m="" archAcc="-10" archCheeseMax="0" archMax="1"/><S T="12" X="550" Y="315" L="60" H="60" P="0,0,0,0,45,0,0,0" o="131313" c="3" N=""/><S T="12" X="650" Y="315" L="60" H="60" P="0,0,0,0,45,0,0,0" o="131313" c="3" N=""/><S T="12" X="600" Y="460" L="1220" H="20" P="1,1e-9,0,0,0,1,0,0" o="FF0000" m=""/><S T="12" X="-35" Y="120" L="70" H="710" P="0,0,0.2,0.2,0,0,0,0" o="6A7495" N=""/><S T="12" X="1235" Y="120" L="70" H="710" P="0,0,0.2,0.2,0,0,0,0" o="6A7495" N=""/><S T="12" X="600" Y="-225" L="1200" H="20" P="0,0,0,0,0,0,0,0" o="FF0000" c="2" m=""/><S T="12" X="316" Y="-140" L="20" H="150" P="0,0,0.2,0.2,0,0,0,0" o="050505" c="3"/><S T="12" X="407" Y="-140" L="20" H="150" P="0,0,0.2,0.2,0,0,0,0" o="050505" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="050505" c="3"/><S T="12" X="360" Y="-196" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="050505" c="3"/><S T="9" X="600" Y="70" L="30" H="50" P="0,0,0,0,0,0,0,0" tint="00FF18" archAcc="-5" archCheeseMax="0" archMax="1"/><S T="9" X="600" Y="240" L="30" H="50" P="0,0,0,0,0,0,0,0" tint="FF0000" archAcc="-5" archCheeseMax="10" archMax="1"/><S T="21" X="40" Y="292" L="40" H="25" P="0,0,0,0,90,0,0,0" c="3" tint="FF0000" name="a" target="b"/><S T="21" X="1160" Y="292" L="40" H="25" P="0,0,0,0,-90,0,0,0" c="3" tint="FF0000" name="c" target="d"/><S T="21" X="40" Y="125" L="40" H="25" P="0,0,0,0,90,0,0,0" c="3" tint="FF0000" name="b" target="a"/><S T="21" X="1160" Y="125" L="40" H="25" P="0,0,0,0,-90,0,0,0" c="3" tint="FF0000" name="d" target="c"/><S T="12" X="600" Y="390" L="20" H="140" P="0,0,0,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="550" Y="315" L="30" H="30" P="0,0,0,1,45,0,0,0" o="c1ffff" c="2" N=""/><S T="12" X="650" Y="315" L="30" H="30" P="0,0,0,1,45,0,0,0" o="c1ffff" c="2" N=""/><S T="12" X="600" Y="315" L="100" H="10" P="0,0,0,1,0,0,0,0" o="c1ffff" c="2" N=""/></S><D><T X="400" Y="310" spawn="1"/><T X="800" Y="310" spawn="1"/><T X="400" Y="141" spawn="4"/><T X="800" Y="141" spawn="4"/><T X="100" Y="310" spawn="3"/><T X="1100" Y="310" spawn="3"/><T X="100" Y="141" spawn="6"/><T X="1100" Y="141" spawn="6"/><T X="250" Y="310" spawn="2"/><T X="950" Y="310" spawn="2"/><T X="250" Y="141" spawn="5"/><T X="950" Y="141" spawn="5"/><DS X="365" Y="-141"/></D><O><O X="570" Y="210" C="22" P="0"/><O X="630" Y="270" C="22" P="0"/><O X="600" Y="240" C="13" nosync="" P="0"/></O><L><JR M1="33"/></L></Z></C>',
    [3] = 'No jump tower',
    [4] = 'Tanarchosl#5748 and Maferyjhonat#0000',
    [6] = '19539e5756b.png'
  },
  [44] = {
    [1] = '<C><P F="0" G="0,4"/><Z><S><S T="12" X="-60" Y="133" L="120" H="560" P="0,0,0,0,0,0,0,0" o="000000" c="4"/><S T="12" X="860" Y="133" L="120" H="560" P="0,0,0,0,0,0,0,0" o="000000" c="4"/><S T="12" X="860" Y="133" L="120" H="560" P="0,0,0,0,0,0,0,0" c="4" tint="23003E"/><S T="9" X="-85" Y="120" L="50" H="460" P="0,0,0,0,0,0,0,0" tint="260042" archAcc="0.5" archCheeseMax="1" archMax="2"/><S T="9" X="885" Y="120" L="50" H="460" P="0,0,0,0,0,0,0,0" tint="260042" archAcc="0.5" archCheeseMax="1" archMax="2"/><S T="9" X="-40" Y="320" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="FF0000" archAcc="0.75" archCheeseMax="1" archMax="1"/><S T="9" X="840" Y="320" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="FF0000" archAcc="0.75" archCheeseMax="1" archMax="1"/><S T="10" X="400" Y="-230" L="750" H="100" P="0,0,0,0.2,0,0,0,0" tint="1D0034" friction="20,4"/><S T="12" X="400" Y="-5" L="800" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="400" Y="-80" L="800" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="10" X="400" Y="115" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m="" tint="1D0034"/><S T="10" X="400" Y="235" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" tint="1D0034"/><S T="1" X="400" Y="180" L="10" H="140" P="0,0,0,0.2,0,0,0,0" c="3" m="" friction="-100,-20"/><S T="1" X="400" Y="340" L="10" H="200" P="0,0,0,0,0,0,0,0" tint="1D0034"/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0" m=""/><S T="12" X="-5" Y="20" L="10" H="200" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3" m=""/><S T="12" X="805" Y="20" L="10" H="200" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3" m=""/><S T="12" X="-60" Y="165" L="120" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="860" Y="165" L="120" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="10" X="-30" Y="20" L="60" H="60" P="0,0,0.3,0.2,3,0,0,0" tint="1D0034"/><S T="10" X="830" Y="20" L="60" H="60" P="0,0,0.3,0.2,-3,0,0,0" tint="1D0034"/><S T="10" X="-30" Y="260" L="60" H="60" P="0,0,0.3,0.2,3,0,0,0" tint="1D0034"/><S T="10" X="830" Y="260" L="60" H="60" P="0,0,0.3,0.2,-3,0,0,0" tint="1D0034"/><S T="10" X="-30" Y="140" L="60" H="60" P="0,0,0.3,0.2,3,0,0,0" tint="1D0034"/><S T="10" X="830" Y="140" L="60" H="60" P="0,0,0.3,0.2,-3,0,0,0" tint="1D0034"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3" m=""/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3" m=""/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3" m=""/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3" m=""/><S T="10" X="-33" Y="355" L="65" H="10" P="0,0,0,0.2,0,0,0,0" N="" tint="5C1B56"/><S T="10" X="833" Y="355" L="65" H="10" P="0,0,0,0.2,0,0,0,0" N="" tint="5C1B56"/><S T="9" X="-40" Y="200" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="00FF40" archAcc="0.5" archCheeseMax="1" archMax="1"/><S T="9" X="840" Y="200" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="00FF40" archAcc="0.5" archCheeseMax="1" archMax="1"/><S T="9" X="-40" Y="80" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="0008FF" archAcc="0.25" archCheeseMax="1" archMax="1"/><S T="9" X="840" Y="80" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="0008FF" archAcc="0.25" archCheeseMax="1" archMax="1"/><S T="9" X="-40" Y="-80" L="80" H="140" P="0,0,0,0,0,0,0,0" tint="260042" archAcc="0.5" archCheeseMax="1" archMax="1"/><S T="9" X="840" Y="-80" L="80" H="140" P="0,0,0,0,0,0,0,0" tint="260042" archAcc="0.5" archCheeseMax="1" archMax="1"/><S T="10" X="-115" Y="500" L="10" H="1200" P="0,0,0,0,0,0,0,0" tint="1D0034"/><S T="10" X="915" Y="500" L="10" H="1200" P="0,0,0,0,0,0,0,0" tint="1D0034"/><S T="12" X="400" Y="550" L="1600" H="400" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3" N=""/><S T="10" X="400" Y="400" L="1200" H="100" P="0,0,0.2,0,0,0,0,0" c="3" N="" tint="1D0034"/><S T="10" X="-40" Y="-180" L="220" H="100" P="0,0,0,0,-30,0,0,0" tint="1D0034"/><S T="10" X="840" Y="-180" L="100" H="220" P="0,0,0.3,0.2,-60,0,0,0" tint="1D0034"/><S T="12" X="400" Y="700" L="10" H="700" P="0,0,0,0,0,0,0,0" o="FF0000" c="3" N="" m=""/></S><D><P X="835" Y="345" T="307" P="0,1"/><P X="835" Y="110" T="306" P="0,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="7" G="0,4" playerForce="1.1"/><Z><S><S T="12" X="-60" Y="133" L="120" H="560" P="0,0,0,0,0,0,0,0" o="000000" c="4"/><S T="12" X="1260" Y="133" L="120" H="560" P="0,0,0,0,0,0,0,0" o="000000" c="4"/><S T="12" X="1260" Y="133" L="120" H="560" P="0,0,0,0,0,0,0,0" c="4" tint="1d0034"/><S T="9" X="-85" Y="138" L="50" H="425" P="0,0,0,0,0,0,0,0" tint="260042" archAcc="0.5" archCheeseMax="1" archMax="2"/><S T="9" X="1287" Y="138" L="50" H="425" P="0,0,0,0,0,0,0,0" tint="260042" archAcc="0.5" archCheeseMax="1" archMax="2"/><S T="9" X="-40" Y="320" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="FF0000" archAcc="0.75" archCheeseMax="1" archMax="1"/><S T="9" X="1240" Y="320" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="FF0000" archAcc="0.75" archCheeseMax="1" archMax="1"/><S T="10" X="600" Y="-280" L="850" H="100" P="0,0,0,0.2,0,0,0,0" tint="1d0034" friction="20,4"/><S T="12" X="600" Y="-5" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="600" Y="-80" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="10" X="600" Y="115" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m="" tint="1d0034"/><S T="10" X="600" Y="235" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" tint="1d0034"/><S T="1" X="600" Y="180" L="10" H="140" P="0,0,0,0.2,0,0,0,0" c="3" m="" friction="-100,-20"/><S T="1" X="600" Y="340" L="10" H="200" P="0,0,0,0,0,0,0,0" tint="1d0034"/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0" m=""/><S T="12" X="-5" Y="20" L="10" H="200" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3" m=""/><S T="12" X="1205" Y="20" L="10" H="200" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3" m=""/><S T="12" X="-60" Y="165" L="120" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="1260" Y="165" L="120" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="10" X="-30" Y="20" L="60" H="60" P="0,0,0.3,0.2,-3,0,0,0" tint="1d0034"/><S T="10" X="1230" Y="20" L="60" H="60" P="0,0,0.3,0.2,3,0,0,0" tint="1d0034"/><S T="10" X="-30" Y="260" L="60" H="60" P="0,0,0.3,0.2,-3,0,0,0" tint="1d0034"/><S T="10" X="1230" Y="260" L="60" H="60" P="0,0,0.3,0.2,3,0,0,0" tint="1d0034"/><S T="10" X="-30" Y="140" L="60" H="60" P="0,0,0.3,0.2,-3,0,0,0" tint="1d0034"/><S T="10" X="1230" Y="140" L="60" H="60" P="0,0,0.3,0.2,3,0,0,0" tint="1d0034"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="316" Y="-189" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3" m=""/><S T="12" X="407" Y="-193" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3" m=""/><S T="12" X="363" Y="-100" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3" m=""/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3" m=""/><S T="10" X="-33" Y="355" L="65" H="10" P="0,0,0,0.2,0,0,0,0" N="" tint="5C1B56"/><S T="10" X="1233" Y="355" L="65" H="10" P="0,0,0,0.2,0,0,0,0" N="" tint="5C1B56"/><S T="9" X="-40" Y="200" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="00FF40" archAcc="0.5" archCheeseMax="1" archMax="1"/><S T="9" X="1240" Y="200" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="00FF40" archAcc="0.5" archCheeseMax="1" archMax="1"/><S T="9" X="-40" Y="80" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="0008FF" archAcc="0.25" archCheeseMax="1" archMax="1"/><S T="9" X="1240" Y="80" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="0008FF" archAcc="0.25" archCheeseMax="1" archMax="1"/><S T="9" X="-40" Y="-80" L="80" H="140" P="0,0,0,0,0,0,0,0" tint="260042" archAcc="0.5" archCheeseMax="1" archMax="2"/><S T="9" X="1240" Y="-80" L="80" H="140" P="0,0,0,0,0,0,0,0" tint="260042" archAcc="0.5" archCheeseMax="1" archMax="2"/><S T="10" X="-115" Y="500" L="10" H="1200" P="0,0,0,0,0,0,0,0" tint="1d0034"/><S T="10" X="1315" Y="500" L="10" H="1200" P="0,0,0,0,0,0,0,0" tint="1d0034"/><S T="12" X="600" Y="550" L="2000" H="400" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3" N=""/><S T="10" X="600" Y="400" L="1600" H="100" P="0,0,0.2,0,0,0,0,0" c="3" N="" tint="1d0034"/><S T="10" X="30" Y="-180" L="400" H="100" P="0,0,0.3,0.2,-30,0,0,0" tint="1d0034"/><S T="10" X="1170" Y="-180" L="400" H="100" P="0,0,0.3,0.2,30,0,0,0" tint="1d0034"/><S T="12" X="600" Y="700" L="10" H="700" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" N="" m=""/></S><D><P X="1235" Y="345" T="307" P="0,1"/><P X="1235" Y="110" T="306" P="0,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Quad water cannon',
    [4] = 'Tanarchosl#4785 and K1ng#7286',
    [6] = '19539e5756b.png'
  },
  [45] = {
    [1] = '<C><P F="8" playerForce="1.1" G="0,4" /><Z><S><S H="170" L="140" Y="210" archAcc="-20" archCheeseMax="0" X="-70" P="0,0,0,0,0,0,0,0" T="15" archMax="2" /><S H="60" L="800" Y="0" c="4" X="400" P="0,0,0.3,0.2,0,0,0,0" o="001a28" T="12" /><S H="200" L="10" Y="395" m="" c="2" X="-5" P="0,0,0,1,0,0,0,0" N="" o="FF0000" T="12" /><S H="200" L="10" Y="395" m="" c="2" X="805" P="0,0,0,1,0,0,0,0" N="" o="FF0000" T="12" /><S H="36" L="36" Y="350" X="0" P="0,0,0.5,1.2,45,0,0,0" o="001e2e" T="12" /><S H="36" L="36" Y="350" X="800" P="0,0,0.5,1.2,-45,0,0,0" o="001e2e" T="12" /><S H="150" L="20" Y="50" m="" c="2" X="-10" P="0,0,0,1,0,0,0,0" N="" o="FF0000" T="12" /><S H="150" L="20" Y="50" m="" c="2" X="810" P="0,0,0,1,0,0,0,0" N="" o="FF0000" T="12" /><S H="400" L="400" Y="160" c="4" X="-200" P="0,0,0.3,0.2,0,0,0,0" o="001A28" T="12" /><S H="400" L="400" Y="160" c="4" X="1000" P="0,0,0.3,0.2,0,0,0,0" o="001A28" T="12" /><S H="360" L="20" Y="305" m="" X="-110" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="370" L="20" Y="305" m="" c="2" X="-130" P="0,0,0,0,0,0,0,0" o="FFF200" T="12" /><S H="370" L="20" Y="305" m="" c="2" X="930" P="0,0,0,0,0,0,0,0" o="FFF200" T="12" /><S H="360" L="20" Y="305" m="" X="910" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="200" L="20" Y="-263" c="3" X="316" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" T="12" /><S H="200" L="20" Y="-267" c="3" X="407" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" T="12" /><S H="100" L="20" Y="-232" c="3" X="363" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" T="12" /><S H="100" L="20" Y="-340" c="3" X="360" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" T="12" /><S H="10" L="120" Y="485" m="" c="2" X="-60" P="0,0,20,0,0,0,0,0" o="FF0000" T="12" /><S H="10" L="120" Y="485" m="" c="2" X="860" P="0,0,20,0,0,0,0,0" o="FF0000" T="12" /><S H="180" L="20" Y="210" c="4" X="-110" P="0,0,0,0,0,0,0,0" friction="-100,-20" o="FFFFFF" T="12" /><S H="180" L="20" Y="210" c="4" X="910" P="0,0,0,0,0,0,0,0" friction="-100,-20" o="FFFFFF" T="12" /><S H="20" L="85" Y="450" archAcc="-20" m="" X="-60" P="0,0,0,0,0,0,0,0" T="9" /><S H="20" L="85" Y="450" archAcc="-20" m="" X="860" P="0,0,0,0,0,0,0,0" T="9" /><S H="200" L="820" Y="455" c="4" X="400" P="0,0,0,1.1,0,0,0,0" N="" o="003755" T="12" /><S H="300" L="1600" Y="505" tint="002e46" X="400" P="0,0,0,1,0,0,0,0" N="" c="4" T="1" /><S H="10" L="800" Y="29" c="3" X="400" P="0,0,0.3,0.2,0,0,0,0" o="001a28" T="12" /><S H="40" L="20" Y="130" tint="0000ff" X="450" P="0,0,0,0,0,0,0,0" T="9" /><S H="50" L="20" Y="160" tint="0000ff" X="220" P="0,0,0,0,0,0,0,0" T="9" /><S H="50" L="20" Y="160" tint="0000ff" X="580" P="0,0,0,0,0,0,0,0" T="9" /><S H="40" L="20" Y="130" tint="0000ff" X="350" P="0,0,0,0,0,0,0,0" T="9" /><S H="400" L="20" Y="160" tint="002e46" X="-10" P="0,0,0.2,0.5,0,0,0,0" c="3" T="1" /><S H="20" L="800" Y="360" tint="001623" X="400" P="0,0,0,0.1,0,0,0,0" c="3" T="1" /><S H="10" L="140" Y="120" X="-70" P="0,0,50,0.2,0,0,0,0" N="" o="FFFFFF" T="12" /><S H="10" L="140" Y="120" X="870" P="0,0,50,0.2,0,0,0,0" N="" o="FFFFFF" T="12" /><S H="10" L="140" Y="300" c="3" X="-70" P="0,0,0.3,0.2,0,0,0,0" N="" o="FFFFFF" T="12" /><S H="10" L="140" Y="300" c="3" X="870" P="0,0,0.3,0.2,0,0,0,0" N="" o="FFFFFF" T="12" /><S H="170" L="140" Y="210" archAcc="-20" archCheeseMax="0" X="870" P="0,0,0,0,0,0,0,0" T="15" archMax="2" /><S H="400" L="20" Y="160" tint="002e46" X="810" P="0,0,0.2,0.5,0,0,0,0" c="3" T="1" /><S H="20" L="840" Y="-30" tint="002e46" X="400" P="0,0,0,0,0,0,0,0" T="1" /><S H="20" L="800" Y="365" tint="FFFFFF" X="400" P="1,0,0,1.1,90,0,0,0" N="" c="2" T="1" /><S H="360" L="20" Y="305" m="" X="-110" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="-110" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="-110" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="-110" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="-110" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="-110" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="-110" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="-110" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="-110" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="910" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="910" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="910" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="910" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="910" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="910" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="910" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="910" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="910" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /></S><D><P X="400" P="0,0" Y="240" T="264" /><DC X="365" Y="-270" /><P C="555D77" X="400" P="0,0" Y="163" T="131" /><P X="400" P="0,0" Y="92" T="154" /><P X="140" P="0,1" Y="112" T="154" /><P X="660" P="0,1" Y="99" T="154" /><T lobby="0" X="400" Y="20" /><DS X="364" Y="-265" /></D><O /><L><JP M1="40" MV="Infinity,0.3333333333333333" AXIS="-1,0" /><JP M1="40" AXIS="0,1" /><JR M1="10" /><JR M1="41" /><JR M1="42" /><JR M1="43" /><JR M1="44" /><JR M1="45" /><JR M1="46" /><JR M1="47" /><JR M1="48" /><JR M1="49" /><JR M1="13" /><JR M1="50" /><JR M1="51" /><JR M1="52" /><JR M1="53" /><JR M1="54" /><JR M1="55" /><JR M1="56" /><JR M1="57" /><JR M1="58" /></L></Z></C>',
    [2] = '<C><P F="8" L="1200" playerForce="1.1" G="0,4"/><Z><S><S H="300" L="1200" Y="505" tint="002e46" c="4" X="600" P="0,0,0,1,0,0,0,0" o="324650" T="12" /><S H="170" L="140" Y="210" archAcc="-20" archCheeseMax="0" X="-70" P="0,0,0,0,0,0,0,0" T="15" archMax="2" /><S H="170" L="140" Y="210" archAcc="-20" archCheeseMax="0" X="1270" P="0,0,0,0,0,0,0,0" T="15" archMax="2" /><S H="60" L="1200" Y="0" c="4" X="600" P="0,0,0.3,0.2,0,0,0,0" o="001a28" T="12" /><S H="36" L="36" Y="350" X="1200" P="0,0,0.5,1.5,45,0,0,0" o="001e2e" T="12" /><S H="36" L="36" Y="350" X="2" P="0,0,0.5,1.5,45,0,0,0" o="001e2e" T="12" /><S H="500" L="400" Y="210" c="4" X="1400" P="0,0,0,0.2,0,0,0,0" o="001a28" T="12" /><S H="500" L="400" Y="210" c="4" X="-200" P="0,0,0,0.2,0,0,0,0" o="001a28" T="12" /><S H="200" L="20" Y="395" m="" c="2" X="-10" P="0,0,0,1,0,0,0,0" N="" o="FF0000" T="12" /><S H="200" L="20" Y="395" m="" c="2" X="1210" P="0,0,0,1,0,0,0,0" N="" o="FF0000" T="12" /><S H="150" L="20" Y="50" m="" c="2" X="-10" P="0,0,0,1,0,0,0,0" N="" o="FF0000" T="12" /><S H="150" L="20" Y="50" m="" c="2" X="1210" P="0,0,0,1,0,0,0,0" N="" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="-110" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="370" L="20" Y="305" m="" X="-130" P="0,0,0,0,0,0,0,0" o="FFF200" T="12" /><S H="370" L="20" Y="305" m="" X="1330" P="0,0,0,0,0,0,0,0" o="FFF200" T="12" /><S H="360" L="20" Y="305" m="" X="1310" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="200" L="20" Y="-263" c="3" X="316" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" T="12" /><S H="200" L="20" Y="-267" c="3" X="407" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" T="12" /><S H="100" L="20" Y="-232" c="3" X="363" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" T="12" /><S H="100" L="20" Y="-340" c="3" X="360" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" T="12" /><S H="10" L="120" Y="485" m="" c="2" X="-65" P="0,0,20,0.2,0,0,0,0" o="FF0000" T="12" /><S H="10" L="120" Y="485" m="" c="2" X="1265" P="0,0,20,0.2,0,0,0,0" o="FF0000" T="12" /><S H="180" L="20" Y="210" c="4" X="-110" P="0,0,50,0.2,0,0,0,0" friction="-100,-20" o="FFFFFF" T="12" /><S H="180" L="20" Y="210" c="4" X="1310" P="0,0,50,0.2,0,0,0,0" friction="-100,-20" o="FFFFFF" T="12" /><S H="20" L="120" Y="450" archAcc="-20" m="" archCheeseMax="0" X="-60" P="0,0,0,0,0,0,0,0" T="9" /><S H="20" L="120" Y="450" archAcc="-20" m="" archCheeseMax="0" X="1260" P="0,0,0,0,0,0,0,0" T="9" /><S H="10" L="1200" Y="29" c="3" X="599" P="0,0,0.3,0.2,0,0,0,0" o="001a28" T="12" /><S H="20" L="20" Y="120" tint="0000ff" X="255" P="0,0,0,0,0,0,0,0" T="9" /><S H="20" L="20" Y="200" tint="0000ff" X="375" P="0,0,0,0,0,0,0,0" T="9" /><S H="40" L="20" Y="130" tint="0000ff" X="515" P="0,0,0,0,0,0,0,0" T="9" /><S H="20" L="20" Y="120" tint="0000ff" X="955" P="0,0,0,0,0,0,0,0" T="9" /><S H="40" L="20" Y="130" tint="0000ff" X="665" P="0,0,0,0,0,0,0,0" T="9" /><S H="20" L="20" Y="200" tint="0000ff" X="825" P="0,0,0,0,0,0,0,0" T="9" /><S H="20" L="20" Y="200" tint="0000ff" X="175" P="0,0,0,0,0,0,0,0" T="9" /><S H="20" L="20" Y="200" tint="0000ff" X="1065" P="0,0,0,0,0,0,0,0" T="9" /><S H="400" L="20" Y="160" tint="002e46" X="-10" P="0,0,0.2,0.5,0,0,0,0" c="3" T="1" /><S H="400" L="20" Y="160" tint="002e46" X="1210" P="0,0,0.2,0.5,0,0,0,0" c="3" T="1" /><S H="20" L="1200" Y="360" tint="002e46" X="600" P="0,0,0.1,0.1,0,0,0,0" c="3" T="1" /><S H="10" L="140" Y="120" X="-70" P="0,0,50,0.2,0,0,0,0" N="" o="FFFFFF" T="12" /><S H="10" L="140" Y="120" X="1270" P="0,0,50,0.2,0,0,0,0" N="" o="FFFFFF" T="12" /><S H="10" L="140" Y="300" c="3" X="-70" P="0,0,0.3,0.2,0,0,0,0" N="" o="FFFFFF" T="12" /><S H="10" L="140" Y="300" c="3" X="1270" P="0,0,0.3,0.2,0,0,0,0" N="" o="FFFFFF" T="12" /><S H="300" L="2000" Y="505" tint="002e46" X="600" P="0,0,0,1,0,0,0,0" N="" c="4" T="1" /><S H="20" L="1200" Y="365" tint="FFFFFF" X="600" P="1,0,0,1,90,0,0,0" N="" c="2" T="1" /><S H="20" L="1240" Y="-30" tint="002e46" X="600" P="0,0,0,0,0,0,0,0" T="1" /><S H="360" L="20" Y="305" m="" X="-110" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /><S H="360" L="20" Y="305" m="" X="1310" P="1,1e-9,20,0.2,0,1,0,0" o="FF0000" T="12" /></S><D><DC X="365" Y="-270" /><P C="555D77" X="600" P="0,0" Y="163" T="131" /><P X="250" P="0,0" Y="93" T="156" /><P X="171" P="0,0" Y="174" T="156" /><P X="369" P="0,1" Y="168" T="156" /><P X="950" P="0,1" Y="88" T="156" /><P X="584" P="0,0" Y="92" T="154" /><P X="819" P="0,0" Y="170" T="156" /><P X="1098" P="0,0" Y="160" T="155" /><P X="838" P="0,1" Y="240" T="264" /><P X="400" P="0,0" Y="243" T="264" /><T lobby="0" X="600" Y="10" /><DS X="364" Y="-265" /></D><O /><L><JP M1="43" MV="Infinity,0.3333333333333333" AXIS="-1,0" /><JP M1="43" AXIS="0,1" /><JR M1="12" /><JR M1="45" /><JR M1="15" /><JR M1="46" /></L></Z></C>',
    [3] = 'Frozen desert soccer',
    [4] = 'Tanarchosl#4785 and Ramasevosaff#0000',
    [6] = '19539e5756b.png'
  },
  [46] = {
    [1] = '<C><P G="0,4"/><Z><S><S T="12" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="ff0000" c="3" N="" m=""/><S T="12" X="400" Y="200" L="1600" H="800" P="0,0,0.3,0.2,0,0,0,0" o="0f0f0f" c="4"/><S T="13" X="695" Y="33" L="60" P="0,0,0.3,1,0,0,0,0" o="f8ffaa" c="4"/><S T="12" X="400" Y="175" L="10" H="151" P="0,0,0,0.2,0,0,0,0" o="ff0000" c="3" m=""/><S T="13" X="713" Y="14" L="60" P="0,0,0,0,0,0,0,0" o="0f0f0f" c="4"/><S T="12" X="400" Y="460" L="1600" H="180" P="0,0,0.3,0.2,0,0,0,0" o="262626" c="4" N=""/><S T="12" X="400" Y="115" L="450" H="30" P="1,0,0.3,0.2,0,1,0,0" o="141414" c="4"/><S T="12" X="320" Y="245" L="40" H="235" P="0,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="12" X="480" Y="245" L="40" H="235" P="0,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="12" X="400" Y="231" L="40" H="250" P="0,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="12" X="400" Y="475" L="800" H="240" P="0,0,0.1,0.2,0,0,0,0" o="262626" c="3" N=""/><S T="12" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" o="ffffff"/><S T="13" X="98" Y="34" L="29" P="0,0,0.3,0.2,0,0,0,0" o="0c0c0c" c="4"/><S T="12" X="-50" Y="200" L="100" H="800" P="0,0,0.2,0.2,0,0,0,0" o="262626"/><S T="12" X="850" Y="200" L="100" H="800" P="0,0,0.2,0.2,0,0,0,0" o="262626"/><S T="12" X="400" Y="5" L="800" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" c="3" N="" m=""/><S T="12" X="400" Y="430" L="10" H="160" P="0,0,0,0,0,0,0,0" o="ff0000" c="2" N="" m=""/><S T="12" X="316" Y="-109" L="20" H="160" P="0,0,0.2,0.2,0,0,0,0" o="0f0f0f" c="3"/><S T="12" X="407" Y="-113" L="20" H="160" P="0,0,0.2,0.2,0,0,0,0" o="0f0f0f" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="0f0f0f" c="3"/><S T="12" X="360" Y="-186" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="0f0f0f" c="3"/><S T="12" X="172" Y="225" L="10" H="145" P="1,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="12" X="186" Y="135" L="10" H="50" P="1,0,0.3,0.2,35,0,0,0" o="141414" c="4"/><S T="13" X="200" Y="114" L="15" P="1,0,0.3,0.2,0,0,0,50" o="141414" c="4" m=""/><S T="13" X="172" Y="154" L="15" P="1,0,0.3,0.2,0,0,0,0" o="141414" c="4" m=""/><S T="12" X="172" Y="285" L="10" H="30" P="1,0,0.3,1,360,0,0,0" o="670000" c="3"/><S T="12" X="204" Y="295" L="68" H="10" P="1,0,0.3,1,0,0,0,5" o="670000"/><S T="13" X="172" Y="294" L="15" P="1,0,0.3,0.2,0,0,0,0" o="141414" c="3"/><S T="12" X="235" Y="279" L="10" H="40" P="1,0,0.3,0.2,360,0,0,0" o="141414" c="3"/><S T="12" X="614" Y="135" L="10" H="50" P="1,0,0.3,0.2,325,0,0,0" o="141414" c="4"/><S T="13" X="600" Y="114" L="15" P="1,0,0.3,0.2,0,0,0,50" o="141414" c="4" m=""/><S T="12" X="628" Y="225" L="10" H="145" P="1,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="13" X="628" Y="154" L="15" P="1,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="12" X="596" Y="295" L="68" H="10" P="1,0,0.3,1,0,0,0,5" o="005276"/><S T="12" X="628" Y="285" L="10" H="30" P="1,0,0.3,1,360,0,0,0" o="005276" c="3"/><S T="13" X="628" Y="294" L="15" P="1,0,0.3,0.2,0,0,0,0" o="141414" c="3"/><S T="12" X="565" Y="279" L="10" H="40" P="1,0,0.3,0.2,360,0,0,0" o="141414" c="3"/><S T="13" X="235" Y="295" L="15" P="1,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="13" X="565" Y="295" L="15" P="1,0,0.3,0.2,0,0,0,0" o="141414" c="3"/><S T="12" X="400" Y="80" L="70" H="45" P="0,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="12" X="30" Y="325" L="60" H="60" P="0,0,0,0,0,0,0,0" o="0c0c0c" c="4"/><S T="13" X="135" Y="22" L="29" P="0,0,0.3,0.5,0,0,0,0" o="0c0c0c" c="4"/><S T="13" X="34" Y="31" L="29" P="0,0,0.3,0.2,0,0,0,0" o="0c0c0c" c="4"/><S T="13" X="75" Y="14" L="29" P="0,0,0.3,0.2,0,0,0,0" o="0c0c0c" c="4"/><S T="12" X="770" Y="325" L="60" H="60" P="0,0,0,0,0,0,0,0" o="0c0c0c" c="4"/><S T="12" X="403" Y="-195" L="800" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="400" Y="510" L="800" H="20" P="1,1e-9,0,0,0,1,0,0" o="FF0000" N="" m=""/><S T="19" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="19" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="9" X="400" Y="460" L="800" H="10" P="0,0,0,0,0,0,0,0" archAcc="-1"/></S><D><DS X="360" Y="-151"/></D><O><O X="400" Y="115" C="11" P="0"/><O X="172" Y="295" C="22" P="0"/><O X="200" Y="115" C="16" P="0"/><O X="172" Y="154" C="14" P="0"/><O X="235" Y="295" C="22" P="0"/><O X="628" Y="154" C="14" P="0"/><O X="628" Y="295" C="22" P="0"/><O X="565" Y="295" C="22" P="0"/><O X="600" Y="115" C="15" P="0"/></O><L><JR M1="46"/></L></Z></C>',
    [2] = '<C><P L="1200" F="7" G="0,4"/><Z><S><S T="12" X="600" Y="200" L="2000" H="800" P="0,0,0.3,0.2,0,0,0,0" o="0f0f0f" c="4"/><S T="12" X="600" Y="-195" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" c="2" m=""/><S T="12" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="ff0000" c="3" N="" m=""/><S T="12" X="600" Y="175" L="10" H="151" P="0,0,0,0.2,0,0,0,0" o="ff0000" c="3" m=""/><S T="19" X="100" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="19" X="1100" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="12" X="600" Y="460" L="2000" H="200" P="0,0,0.3,0.2,0,0,0,0" o="262626" c="4" N=""/><S T="12" X="600" Y="115" L="450" H="30" P="1,0,0.3,0.2,0,1,0,0" o="141414" c="4"/><S T="12" X="520" Y="245" L="40" H="235" P="0,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="13" X="1150" Y="26" L="60" P="0,0,0,0,0,0,0,0" o="f8ffaa" c="4"/><S T="12" X="680" Y="245" L="40" H="235" P="0,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="12" X="600" Y="231" L="40" H="250" P="0,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="12" X="600" Y="475" L="1200" H="240" P="0,0,0.1,0.2,0,0,0,0" o="262626" c="3" N=""/><S T="12" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" o="ffffff"/><S T="13" X="1178" Y="6" L="60" P="0,0,0,0,0,0,0,0" o="0f0f0f" c="4"/><S T="13" X="176" Y="63" L="29" P="0,0,0.3,0.8,0,0,0,0" o="181818" c="2"/><S T="12" X="-50" Y="200" L="100" H="800" P="0,0,0.2,0.2,0,0,0,0" o="262626"/><S T="12" X="1250" Y="200" L="100" H="800" P="0,0,0.2,0.2,0,0,0,0" o="262626"/><S T="12" X="555" Y="-100" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="0f0f0f" c="3"/><S T="12" X="646" Y="-100" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="0f0f0f" c="3"/><S T="12" X="602" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="0f0f0f" c="3"/><S T="12" X="600" Y="-190" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="0f0f0f" c="3"/><S T="12" X="372" Y="225" L="10" H="145" P="1,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="12" X="386" Y="135" L="10" H="50" P="1,0,0.3,0.2,35,0,0,0" o="141414" c="4"/><S T="13" X="400" Y="114" L="15" P="1,0,0.3,0.2,0,0,0,50" o="141414" c="4"/><S T="13" X="372" Y="154" L="15" P="1,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="12" X="372" Y="285" L="10" H="30" P="1,0,0.3,1,360,0,0,0" o="670000"/><S T="12" X="404" Y="295" L="68" H="10" P="1,0,0.3,1,0,0,0,5" o="670000"/><S T="13" X="372" Y="294" L="15" P="1,0,0.3,0.2,0,0,0,0" o="141414" c="3"/><S T="12" X="435" Y="279" L="10" H="40" P="1,0,0.3,0.2,360,0,0,0" o="141414" c="3"/><S T="12" X="814" Y="135" L="10" H="50" P="1,0,0.3,0.2,325,0,0,0" o="141414" c="4"/><S T="13" X="800" Y="114" L="15" P="1,0,0.3,0.2,0,0,0,50" o="141414" c="4"/><S T="12" X="828" Y="225" L="10" H="145" P="1,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="13" X="828" Y="154" L="15" P="1,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="12" X="796" Y="295" L="68" H="10" P="1,0,0.3,1,0,0,0,5" o="005276"/><S T="12" X="828" Y="284" L="10" H="30" P="1,0,0.3,1,360,0,0,0" o="005276"/><S T="13" X="828" Y="294" L="15" P="1,0,0.3,0.2,0,0,0,0" o="141414" c="3"/><S T="12" X="765" Y="279" L="10" H="40" P="1,0,0.3,0.2,360,0,0,0" o="141414" c="3"/><S T="13" X="435" Y="295" L="15" P="1,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="13" X="765" Y="295" L="15" P="1,0,0.3,0.2,0,0,0,0" o="141414" c="3"/><S T="12" X="600" Y="78" L="70" H="45" P="0,0,0.3,0.2,0,0,0,0" o="141414" c="4"/><S T="12" X="96" Y="336" L="40" H="40" P="0,0,0.3,1,0,0,0,0" o="141414" c="3"/><S T="13" X="204" Y="340" L="15" P="0,0,0.3,1,0,0,0,0" o="383838" c="3"/><S T="13" X="83" Y="44" L="29" P="0,0,0.3,0.8,0,0,0,0" o="181818" c="2"/><S T="13" X="112" Y="60" L="29" P="0,0,0.3,0.8,0,0,0,0" o="181818" c="2"/><S T="13" X="153" Y="43" L="29" P="0,0,0.3,0.8,0,0,0,0" o="181818" c="2"/><S T="12" X="1079" Y="332" L="30" H="50" P="0,0,0.3,1,0,0,0,0" o="222412" c="3"/><S T="13" X="982" Y="340" L="15" P="0,0,0.3,1,0,0,0,0" o="23241B" c="3"/><S T="12" X="600" Y="5" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="600" Y="510" L="1200" H="20" P="1,1e-9,0,0,0,1,0,0" o="FF0000" N="" m=""/><S T="12" X="600" Y="430" L="10" H="160" P="0,0,0,0,0,0,0,0" o="ff0000" c="2" N="" m=""/><S T="9" X="600" Y="450" L="1200" H="10" P="0,0,0,0,0,0,0,0" m="" archAcc="-1"/></S><D><DS X="600" Y="-141"/></D><O><O X="600" Y="115" C="11" P="0"/><O X="372" Y="295" C="22" P="0"/><O X="400" Y="115" C="16" P="0"/><O X="372" Y="154" C="14" P="0"/><O X="435" Y="295" C="22" P="0"/><O X="828" Y="154" C="14" P="0"/><O X="828" Y="295" C="22" P="0"/><O X="765" Y="295" C="22" P="0"/><O X="800" Y="115" C="15" P="0"/></O><L><JR M1="49"/></L></Z></C>',
    [3] = 'Der Lifter',
    [4] = 'Tanatosl#0000 and Tanarchosl#4785',
    [6] = '19539e5756b.png'
  },
  [47] = {
    [1] = '<C><P F="7" G="0,4" playerForce="1.02"/><Z><S><S T="15" X="-60" Y="180" L="100" H="230" P="0,0,0,0,0,0,0,0" archAcc="-10" archCheeseMax="0" archMax="2"/><S T="12" X="-70" Y="380" L="120" H="150" P="0,0,0.3,0.2,0,0,0,0" o="091624" c="4" N=""/><S T="15" X="860" Y="180" L="100" H="230" P="0,0,0,0,0,0,0,0" archAcc="-10" archCheeseMax="0" archMax="2"/><S T="12" X="400" Y="150" L="1100" H="480" P="0,0,0.3,0.2,0,0,0,0" o="091624" c="4"/><S T="12" X="10" Y="355" L="10" H="50" P="0,0,0.3,1,140,0,0,0" o="959595"/><S T="12" X="790" Y="355" L="10" H="50" P="0,0,0.3,1,-140,0,0,0" o="959595"/><S T="12" X="10" Y="5" L="10" H="50" P="0,0,0.3,1,40,0,0,0" o="959595"/><S T="12" X="790" Y="5" L="10" H="50" P="0,0,0.3,1,-40,0,0,0" o="959595"/><S T="12" X="-5" Y="150" L="10" H="480" P="0,0,0.3,0,180,0,0,0" o="959595" c="3" N=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF"/><S T="12" X="-135" Y="255" L="30" H="400" P="0,0,1,0,0,0,0,0" o="FF0000" m=""/><S T="12" X="935" Y="255" L="30" H="400" P="0,0,1,0,0,0,0,0" o="FF0000" m=""/><S T="12" X="905" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF"/><S T="12" X="400" Y="180" L="10" H="400" P="0,0,0,0,0,0,0,0" o="959595" c="4"/><S T="13" X="400" Y="180" L="80" P="0,0,0.3,0.2,0,0,0,0" o="959595" c="4"/><S T="13" X="400" Y="180" L="70" P="0,0,0.3,0.2,0,0,0,0" o="091624" c="4"/><S T="13" X="400" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="ffffff" c="4"/><S T="13" X="400" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="959595" c="4"/><S T="12" X="400" Y="375" L="820" H="10" P="0,0,0,0.3,0,0,0,0" o="959595" c="3"/><S T="12" X="75" Y="180" L="150" H="270" P="0,0,0.3,0.2,0,0,0,0" o="802A00" c="4"/><S T="12" X="725" Y="180" L="150" H="270" P="0,0,0.3,0.2,0,0,0,0" o="802A00" c="4"/><S T="12" X="400" Y="-15" L="820" H="10" P="0,0,0,1,0,0,0,0" o="959595"/><S T="9" X="-45" Y="420" L="70" H="10" P="0,0,0,0,0,0,0,0" archAcc="-10" archCheeseMax="0" archMax="2"/><S T="9" X="845" Y="420" L="70" H="10" P="0,0,0,0,0,0,0,0" archAcc="-10" archCheeseMax="0" archMax="2"/><S T="12" X="400" Y="-85" L="820" H="10" P="0,0,0,0,0,0,0,0" o="959595"/><S T="13" X="100" Y="180" L="10" P="0,0,0,0,0,0,0,0" o="959595" c="4"/><S T="13" X="700" Y="180" L="10" P="0,0,0,0,0,0,0,0" o="ffffff" c="4"/><S T="13" X="700" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="959595" c="4"/><S T="12" X="-45" Y="450" L="90" H="10" P="0,0,0,0,0,0,0,0" o="FF0000" c="2" m="" friction="20,4"/><S T="12" X="845" Y="450" L="90" H="10" P="0,0,0,0,0,0,0,0" o="FF0000" c="2" m="" friction="20,4"/><S T="12" X="870" Y="380" L="120" H="150" P="0,0,0.3,0.2,0,0,0,0" o="091624" c="4" N=""/><S T="12" X="75" Y="320" L="160" H="10" P="0,0,0,0,0,0,0,0" o="959595" c="3"/><S T="12" X="725" Y="320" L="160" H="10" P="0,0,0,0,0,0,0,0" o="959595" c="3"/><S T="12" X="75" Y="40" L="160" H="10" P="0,0,0,0.2,0,0,0,0" o="959595" c="3"/><S T="12" X="725" Y="40" L="160" H="10" P="0,0,0,0.2,0,0,0,0" o="959595" c="3"/><S T="12" X="150" Y="180" L="10" H="290" P="0,0,0,0.2,0,0,0,0" o="959595" c="3"/><S T="12" X="650" Y="180" L="10" H="290" P="0,0,0,0.2,0,0,0,0" o="959595" c="3"/><S T="12" X="-5" Y="20" L="10" H="90" P="0,0,0,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="-5" Y="375" L="10" H="160" P="0,0,10,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="-60" Y="300" L="120" H="10" P="0,0,0.3,0.5,0,0,0,0" o="FFFFFF" c="4" N=""/><S T="12" X="-60" Y="60" L="120" H="10" P="0,0,0,1,0,0,0,0" o="FFFFFF" c="2" N=""/><S T="12" X="805" Y="150" L="10" H="480" P="0,0,0.3,0,0,0,0,0" o="959595" c="3" N=""/><S T="12" X="805" Y="375" L="10" H="160" P="0,0,10,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="805" Y="20" L="10" H="90" P="0,0,0,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="860" Y="60" L="120" H="10" P="0,0,0,1,0,0,0,0" o="FFFFFF" c="2" N=""/><S T="12" X="860" Y="300" L="120" H="10" P="0,0,0.3,0.5,0,0,0,0" o="FFFFFF" c="4" N=""/><S T="12" X="400" Y="455" L="1600" H="150" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="400" Y="385" L="800" H="20" P="1,0,0,1,90,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="905" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="905" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="905" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="905" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="905" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="905" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="905" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="905" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="905" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/></S><D><T X="100" Y="190" spawn="2"/><T X="700" Y="190" spawn="2"/><T X="700" Y="190" spawn="2"/><T X="250" Y="190" spawn="1"/><T X="550" Y="190" spawn="1"/><T X="350" Y="190" spawn="3"/><T X="450" Y="190" spawn="3"/><P X="400" Y="150" T="131" C="555D77" P="0,0"/><T X="400" Y="-30" lobby="0"/><DS X="452" Y="-179"/></D><O/><L><JP M1="47" AXIS="-1,0" MV="Infinity,0.16666666666666666"/><JP M1="47" AXIS="0,1"/><JR M1="9"/><JR M1="48"/><JR M1="49"/><JR M1="50"/><JR M1="51"/><JR M1="52"/><JR M1="53"/><JR M1="54"/><JR M1="55"/><JR M1="56"/><JR M1="12"/><JR M1="57"/><JR M1="58"/><JR M1="59"/><JR M1="60"/><JR M1="61"/><JR M1="62"/><JR M1="63"/><JR M1="64"/><JR M1="65"/></L></Z></C>',
    [2] = '<C><P L="1200" F="7" G="0,4" playerForce="1.02"/><Z><S><S T="15" X="-60" Y="180" L="100" H="230" P="0,0,0,0,0,0,0,0" archAcc="-10" archCheeseMax="0" archMax="2"/><S T="12" X="600" Y="150" L="1490" H="480" P="0,0,0.3,0.2,0,0,0,0" o="091624" c="4"/><S T="12" X="1190" Y="360" L="10" H="51" P="0,0,0.3,1,-140,0,0,0" o="959595"/><S T="12" X="1190" Y="5" L="10" H="50" P="0,0,0.3,1,-40,0,0,0" o="959595"/><S T="12" X="10" Y="355" L="10" H="50" P="0,0,0.3,1,140,0,0,0" o="959595"/><S T="15" X="1260" Y="180" L="100" H="230" P="0,0,0,0,0,0,0,0" archAcc="-10" archCheeseMax="0" archMax="2"/><S T="12" X="10" Y="5" L="10" H="50" P="0,0,0.3,1,40,0,0,0" o="959595"/><S T="12" X="-5" Y="375" L="10" H="160" P="0,0,10,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="1205" Y="375" L="10" H="160" P="0,0,10,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="-5" Y="150" L="10" H="480" P="0,0,0.3,0,0,0,0,0" o="959595" c="3"/><S T="12" X="1205" Y="150" L="10" H="480" P="0,0,0.3,0,0,0,0,0" o="959595" c="3"/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF"/><S T="12" X="-130" Y="255" L="20" H="400" P="0,0,1,0,0,0,0,0" o="FF0000" m=""/><S T="12" X="1330" Y="255" L="20" H="400" P="0,0,1,0,0,0,0,0" o="FF0000" m=""/><S T="12" X="1305" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF"/><S T="12" X="600" Y="180" L="10" H="400" P="0,0,0,0,0,0,0,0" o="959595" c="4"/><S T="13" X="600" Y="180" L="80" P="0,0,0.3,0.2,0,0,0,0" o="959595" c="4"/><S T="13" X="600" Y="180" L="70" P="0,0,0.3,0.2,0,0,0,0" o="091624" c="4"/><S T="13" X="600" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="959595" c="4"/><S T="12" X="600" Y="375" L="1200" H="10" P="0,0,0,0.3,0,0,0,0" o="959595" c="3"/><S T="12" X="1021" Y="180" L="200" H="200" P="0,0,0.3,0.2,45,0,0,0" o="802A00" c="4"/><S T="12" X="95" Y="180" L="190" H="270" P="0,0,0.3,0.2,0,0,0,0" o="802A00" c="4"/><S T="12" X="1105" Y="180" L="190" H="270" P="0,0,0.3,0.2,0,0,0,0" o="802A00" c="4"/><S T="12" X="600" Y="-15" L="1200" H="10" P="0,0,0,1,0,0,0,0" o="959595"/><S T="12" X="181" Y="180" L="200" H="200" P="0,0,0.3,0.2,45,0,0,0" o="802A00" c="4"/><S T="12" X="256" Y="249" L="205" H="11" P="0,0,0,0,-45,0,0,0" o="959595" c="3"/><S T="12" X="944" Y="249" L="205" H="11" P="0,0,0,0,45,0,0,0" o="959595" c="3"/><S T="12" X="256" Y="111" L="205" H="11" P="0,0,0.3,0.2,45,0,0,0" o="959595" c="3"/><S T="12" X="944" Y="111" L="205" H="11" P="0,0,0.3,0.2,-45,0,0,0" o="959595" c="3"/><S T="9" X="-45" Y="420" L="70" H="10" P="0,0,0,0,0,0,0,0" archAcc="-10" archCheeseMax="0" archMax="2"/><S T="9" X="1245" Y="420" L="70" H="10" P="0,0,0,0,0,0,0,0" archAcc="-10" archCheeseMax="0" archMax="2"/><S T="12" X="600" Y="-85" L="1220" H="10" P="0,0,0.3,0.2,0,0,0,0" o="959595"/><S T="13" X="180" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="959595" c="4"/><S T="13" X="1020" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="ffffff" c="4"/><S T="12" X="-45" Y="450" L="90" H="10" P="0,0,0,0,0,0,0,0" o="FF0000" c="2" m="" friction="20,4"/><S T="12" X="1245" Y="450" L="90" H="10" P="0,0,0,0,0,0,0,0" o="FF0000" c="2" m="" friction="20,4"/><S T="12" X="1270" Y="380" L="120" H="150" P="0,0,0.3,0.2,0,0,0,0" o="091624" c="4" N=""/><S T="12" X="-70" Y="380" L="120" H="150" P="0,0,0.3,0.2,0,0,0,0" o="091624" c="4" N=""/><S T="12" X="93" Y="320" L="190" H="10" P="0,0,0,0,0,0,0,0" o="959595" c="3"/><S T="12" X="93" Y="40" L="190" H="10" P="0,0,0,0.2,0,0,0,0" o="959595" c="3"/><S T="13" X="1020" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="959595" c="4"/><S T="12" X="1105" Y="40" L="190" H="11" P="0,0,0,0,0,0,0,0" o="959595" c="3"/><S T="12" X="1105" Y="320" L="190" H="11" P="0,0,0,0,0,0,0,0" o="959595" c="3"/><S T="12" X="-5" Y="20" L="10" H="90" P="0,0,0,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="1205" Y="20" L="10" H="90" P="0,0,0,0,0,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="600" Y="455" L="2000" H="150" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="600" Y="384" L="1220" H="20" P="1,0,0,1.2,90,0,0,0" o="FF0000" c="2" N="" m=""/><S T="12" X="1260" Y="300" L="120" H="10" P="0,0,0.3,0.5,0,0,0,0" o="FAFAFA" c="4" N=""/><S T="12" X="1260" Y="60" L="120" H="10" P="0,0,0,1,0,0,0,0" o="FAFAFA" c="2" N=""/><S T="12" X="-60" Y="60" L="120" H="10" P="0,0,0,1,0,0,0,0" o="FAFAFA" c="2" N=""/><S T="12" X="-60" Y="300" L="120" H="10" P="0,0,0.3,0.5,0,0,0,0" o="FAFAFA" c="4" N=""/><S T="12" X="450" Y="-130" L="90" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6A7495"/><S T="12" X="450" Y="-200" L="90" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6A7495"/><S T="12" X="480" Y="-160" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="6A7495"/><S T="12" X="420" Y="-160" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="6A7495"/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="-105" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="1305" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="1305" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="1305" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="1305" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="1305" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="1305" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="1305" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="1305" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/><S T="12" X="1305" Y="260" L="30" H="400" P="1,1e-9,1,0,0,1,0,0" o="FFFFFF" m=""/></S><D><T X="100" Y="190" spawn="2"/><T X="1100" Y="190" spawn="2"/><T X="370" Y="190" spawn="1"/><T X="830" Y="190" spawn="1"/><T X="470" Y="190" spawn="3"/><T X="730" Y="190" spawn="3"/><T X="102" Y="24" spawn="4"/><T X="1098" Y="24" spawn="4"/><T X="600" Y="-35" spawn="4"/><T X="107" Y="374" spawn="5"/><T X="1093" Y="374" spawn="5"/><T X="560" Y="190" spawn="6"/><T X="640" Y="190" spawn="6"/><P X="600" Y="150" T="131" C="555D77" P="0,0"/><DS X="452" Y="-159"/></D><O/><L><JP M1="46" AXIS="-1,0" MV="Infinity,0.23333333333333334"/><JP M1="46" AXIS="0,1"/><JR M1="11"/><JR M1="55"/><JR M1="56"/><JR M1="57"/><JR M1="58"/><JR M1="59"/><JR M1="60"/><JR M1="61"/><JR M1="62"/><JR M1="63"/><JR M1="14"/><JR M1="64"/><JR M1="65"/><JR M1="66"/><JR M1="67"/><JR M1="68"/><JR M1="69"/><JR M1="70"/><JR M1="71"/><JR M1="72"/></L></Z></C>',
    [3] = 'Handball',
    [4] = 'Tanarchosl#4785 and Tanatosl#0000',
    [6] = '19539e5756b.png'
  },
-- [99] = {
--   [1] = 'small map',
--   [2] = 'large map',
--   [3] = 'map name',
--   [4] = 'author name',
--   [6] = '19539e5756b.png'
-- },
}

local customMapsFourTeamsMode = {
  [1] = {
    [1] = '<C><P L="1600" F="3" G="0,4" MEDATA="13,1;;;;-0;0:::1-"/><Z><S><S T="7" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="1605" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="1" X="900" Y="-763" L="3000" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="-80" Y="235" L="125" H="10" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="1" X="-30" Y="160" L="30" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-75" Y="195" L="120" H="70" P="0,0,0,0,0,0,0,0"/><S T="1" X="-50" Y="-236" L="10" H="800" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="-120" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="-84" Y="-704" L="300" H="11" P="0,0,0,0.1,-20,0,0,0"/><S T="9" X="-90" Y="-194" L="80" H="760" P="0,0,0,0,0,0,0,0"/><S T="12" X="-5" Y="1730" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="-232" L="10" H="790" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="-21" Y="-632" L="46" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-129" Y="-693" L="190" H="127" P="0,0,0,0,0,0,0,0"/><S T="9" X="1675" Y="195" L="120" H="70" P="0,0,0,0,0,0,0,0"/><S T="1" X="1680" Y="235" L="125" H="10" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="-5" Y="1730" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1605" Y="1730" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1605" Y="-232" L="10" H="790" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="1630" Y="160" L="30" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="1650" Y="-236" L="10" H="800" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="1720" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="9" X="1690" Y="-194" L="80" H="760" P="0,0,0,0,0,0,0,0"/><S T="1" X="1621" Y="-632" L="46" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="1729" Y="-693" L="190" H="127" P="0,0,0,0,0,0,0,0"/><S T="1" X="1684" Y="-704" L="300" H="11" P="0,0,0,0.1,20,0,0,0"/><S T="9" X="-92" Y="-602" L="80" H="35" P="0,0,0,0,0,0,0,0"/><S T="9" X="1692" Y="-602" L="80" H="35" P="0,0,0,0,0,0,0,0"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA="20,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="1205" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-763" L="3000" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="-80" Y="235" L="125" H="10" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="1" X="-30" Y="160" L="30" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-75" Y="195" L="120" H="70" P="0,0,0,0,0,0,0,0"/><S T="1" X="-50" Y="-236" L="10" H="800" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="-120" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="-84" Y="-704" L="300" H="11" P="0,0,0,0.1,-20,0,0,0"/><S T="9" X="-90" Y="-194" L="80" H="760" P="0,0,0,0,0,0,0,0"/><S T="12" X="-5" Y="1730" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="-232" L="10" H="790" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="-21" Y="-632" L="46" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-129" Y="-693" L="190" H="127" P="0,0,0,0,0,0,0,0"/><S T="9" X="1275" Y="195" L="120" H="70" P="0,0,0,0,0,0,0,0"/><S T="1" X="1280" Y="235" L="125" H="10" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="-5" Y="1730" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1205" Y="1730" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1205" Y="-232" L="10" H="790" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="1230" Y="160" L="30" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="1250" Y="-236" L="10" H="800" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="1320" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="9" X="1290" Y="-194" L="80" H="760" P="0,0,0,0,0,0,0,0"/><S T="1" X="1221" Y="-632" L="46" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="1329" Y="-693" L="190" H="127" P="0,0,0,0,0,0,0,0"/><S T="1" X="1284" Y="-704" L="300" H="11" P="0,0,0,0.1,20,0,0,0"/><S T="9" X="-92" Y="-602" L="80" H="35" P="0,0,0,0,0,0,0,0"/><S T="9" X="1292" Y="-602" L="80" H="35" P="0,0,0,0,0,0,0,0"/></S><D><P X="1100" Y="365" T="10" P="1,0"/><P X="100" Y="365" T="10" P="1,0"/><P X="600" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Water cannon',
    [4] = 'Refletz#6472',
    [5] = '<C><P F="3" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="390" Y="-763" L="3000" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="1" X="-80" Y="235" L="125" H="10" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="1" X="-30" Y="160" L="30" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-75" Y="195" L="120" H="70" P="0,0,0,0,0,0,0,0"/><S T="1" X="-50" Y="-236" L="10" H="800" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="-120" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="-84" Y="-704" L="300" H="11" P="0,0,0,0.1,-20,0,0,0"/><S T="9" X="-90" Y="-194" L="80" H="760" P="0,0,0,0,0,0,0,0"/><S T="12" X="-5" Y="1730" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="-232" L="10" H="790" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="-21" Y="-632" L="46" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-129" Y="-693" L="190" H="127" P="0,0,0,0,0,0,0,0"/><S T="12" X="805" Y="1730" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="880" Y="235" L="125" H="10" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="9" X="875" Y="195" L="120" H="70" P="0,0,0,0,0,0,0,0"/><S T="9" X="880" Y="-194" L="80" H="760" P="0,0,0,0,0,0,0,0"/><S T="12" X="920" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="830" Y="160" L="30" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="850" Y="-236" L="10" H="800" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="805" Y="-232" L="10" H="790" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="844" Y="-704" L="300" H="11" P="0,0,0,0.1,20,0,0,0"/><S T="9" X="929" Y="-693" L="190" H="127" P="0,0,0,0,0,0,0,0"/><S T="1" X="821" Y="-632" L="46" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="9" X="-92" Y="-602" L="80" H="35" P="0,0,0,0,0,0,0,0"/><S T="9" X="892" Y="-602" L="80" H="35" P="0,0,0,0,0,0,0,0"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '19554044221.png'
  },
  [2] = {
    [1] = '<C><P L="1600" F="3" G="0,4" MEDATA="29,1;;;;-0;0:::1-"/><Z><S><S T="1" X="805" Y="400" L="1610" H="100" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="400" Y="137" L="80" H="10" P="1,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="137" L="80" H="10" P="1,0,0,0.2,0,0,0,0"/><S T="1" X="1200" Y="137" L="80" H="10" P="1,0,0,0.2,0,0,0,0"/></S><D><P X="0" Y="0" T="138" P="0,0"/><P X="800" Y="0" T="138" P="0,0"/><P X="102" Y="357" T="258" P="1,0"/><P X="599" Y="357" T="258" P="1,0"/><P X="999" Y="357" T="258" P="1,0"/><P X="1499" Y="357" T="258" P="1,0"/><DS X="365" Y="-141"/></D><O><O X="400" Y="137" C="12" P="0"/><O X="800" Y="137" C="12" P="0"/><O X="1200" Y="137" C="12" P="0"/></O><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="19,1;;;;-0;0:::1-"/><Z><S><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="600" Y="400" L="1200" H="100" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="1" X="400" Y="137" L="80" H="10" P="1,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="137" L="80" H="10" P="1,0,0,0.2,0,0,0,0"/></S><D><P X="100" Y="365" T="258" P="1,0"/><P X="1100" Y="365" T="258" P="1,0"/><P X="600" Y="365" T="258" P="1,0"/><P X="0" Y="0" T="138" P="0,0"/><P X="1200" Y="0" T="138" P="0,1"/><DS X="365" Y="-141"/></D><O><O X="400" Y="137" C="12" P="0"/><O X="800" Y="137" C="12" P="0"/></O><L/></Z></C>',
    [3] = 'Ice barrier',
    [4] = '+Mimounaaa#0000',
    [5] = '<C><P F="0" G="0,4" MEDATA="14,1;;;;-0;0:::1-"/><Z><S><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="1" X="400" Y="137" L="80" H="10" P="1,0,0,0.2,0,0,0,0"/><S T="1" X="400" Y="400" L="800" H="100" P="0,0,0,0.2,0,0,0,0" c="3" N=""/></S><D><P X="0" Y="0" T="138" P="0,0"/><P X="102" Y="357" T="258" P="1,0"/><P X="699" Y="357" T="258" P="1,0"/><DS X="360" Y="-151"/></D><O><O X="400" Y="137" C="12" P="0"/></O><L/></Z></C>',
    [6] = '1955401d276.png'
  },
  [3] = {
    [1] = '<C><P L="1600" F="3" G="0,4" MEDATA="29,1;;;;-0;0:::1-"/><Z><S><S T="7" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="400" Y="137" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="50" Y="137" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="800" Y="137" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="1200" Y="137" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="1550" Y="137" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="400" Y="137" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="800" Y="137" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="1150" Y="137" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="50" Y="137" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Circle grounds on the sky',
    [4] = 'Refletz#6472',
    [5] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="100" Y="140" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="150" Y="180" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="650" Y="180" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="700" Y="140" L="15" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '1955400e807.png'
  },
  [4] = {
    [1] = '<C><P L="1600" F="3" G="0,4" MEDATA="26,1;;;;-0;0:::1-"/><Z><S><S T="7" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="2" X="90" Y="102" L="190" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="2" X="1510" Y="102" L="190" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="2" X="400" Y="102" L="370" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="2" X="800" Y="102" L="370" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="2" X="1200" Y="102" L="370" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="0" X="180" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="580" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="980" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="1380" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="220" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="620" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="1020" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="1420" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="200" Y="-65" L="50" H="10" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="600" Y="-65" L="50" H="10" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="1000" Y="-65" L="50" H="10" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="1400" Y="-65" L="50" H="10" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA="17,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="2" X="90" Y="102" L="190" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="2" X="1110" Y="102" L="190" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="2" X="400" Y="102" L="370" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="2" X="800" Y="102" L="370" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="0" X="180" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="580" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="980" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="220" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="620" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="1020" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="200" Y="-65" L="10" H="50" P="0,0,0.3,0.2,90,0,0,0" c="2" m=""/><S T="0" X="600" Y="-65" L="10" H="50" P="0,0,0.3,0.2,90,0,0,0" c="2" m=""/><S T="0" X="1000" Y="-65" L="10" H="50" P="0,0,0.3,0.2,90,0,0,0" c="2" m=""/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Trambolines in the sky',
    [4] = 'Kralizmox#0000',
    [5] = '<C><P F="0" G="0,4" MEDATA="18,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="2" X="400" Y="102" L="370" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="2" X="710" Y="102" L="190" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="2" X="90" Y="102" L="190" H="10" P="0,0,0,1,0,0,0,0" c="2"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="0" X="180" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="220" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="200" Y="-65" L="10" H="50" P="0,0,0.3,0.2,90,0,0,0" c="2" m=""/><S T="0" X="580" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="620" Y="15" L="10" H="170" P="0,0,0.3,0.2,0,0,0,0" c="2" m=""/><S T="0" X="600" Y="-65" L="10" H="50" P="0,0,0.3,0.2,90,0,0,0" c="2" m=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '19554036f23.png'
  },
  [5] = {
    [1] = '<C><P L="1600" F="3" G="0,4" MEDATA="29,1;;;;-0;0:::1-"/><Z><S><S T="7" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="352" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="2" X="401" Y="95" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="400" Y="171" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="800" Y="95" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="800" Y="171" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="1201" Y="170" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="1201" Y="94" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="359" Y="-105"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="2" X="400" Y="95" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/><S T="0" X="600" Y="181" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="2" X="400" Y="174" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="800" Y="174" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="800" Y="94" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Trampoline rhombuses',
    [4] = 'Ppoppohaejuseyo#2315',
    [5] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="2" X="401" Y="95" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/><S T="2" X="401" Y="174" L="19" H="19" P="0,0,0,1.2,-45,0,0,0"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '19554038694.png'
  },
  [6] = {
    [1] = '<C><P L="1600" F="3" G="0,4" MEDATA="29,1;;;;-0;0:::1-"/><Z><S><S T="7" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="9" X="400" Y="150" L="30" H="150" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/><S T="9" X="800" Y="150" L="30" H="150" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/><S T="9" X="1200" Y="150" L="30" H="150" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="9" X="400" Y="150" L="30" H="150" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/><S T="9" X="800" Y="150" L="30" H="150" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Black water',
    [4] = 'Asdfghjkkk#8564',
    [5] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="9" X="400" Y="150" L="30" H="150" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '1955400b924.png'
  },
  [7] = {
    [1] = '<C><P L="1600" G="0,4" MEDATA="37,1;;;;-0;0::0,1,2,3,4,5,6,7,8,9,10,11,0,0,0,0,0,0:1-"/><Z><S><S T="7" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="401" Y="225" L="706" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="225" L="705" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="175" L="10" H="158" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="-2" Y="243" L="10" H="305" P="1,0,1.5,0,90,0,0,0" c="3" m=""/><S T="0" X="1599" Y="246" L="10" H="305" P="1,0,1.5,0,90,0,0,0" c="3" m=""/><S T="0" X="800" Y="245" L="18" H="305" P="1,0,1.5,0,90,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="386" Y="461" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="174" L="10" H="161" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="854" Y="183" L="10" H="85" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1547" Y="183" L="10" H="85" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="748" Y="184" L="10" H="85" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="53" Y="183" L="10" H="85" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="174" L="10" H="160" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="8" X="223" Y="143" L="350" H="10" P="0,0,0.3,0.2,360,0,0,0" c="3"/><S T="8" X="1379" Y="143" L="346" H="10" P="0,0,0.3,0.2,360,0,0,0" c="3"/><S T="8" X="579" Y="143" L="348" H="10" P="0,0,0.3,0.2,360,0,0,0" c="3"/><S T="8" X="1024" Y="143" L="349" H="10" P="0,0,0.3,0.2,360,0,0,0" c="3"/><S T="8" X="1201" Y="143" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3"/><S T="8" X="400" Y="143" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L><JD c="ffffff,5,0.9,1" P1="-2,290.5" P2="-7,301.5"/><JD c="ffffff,5,0.9,1" P1="799,250.5" P2="794,261.5"/><JD c="ffffff,5,0.9,1" P1="799,290.5" P2="794,301.5"/><JD c="ffffff,5,0.9,1" P1="1599.76,294.29" P2="1596.03,305.29"/><JD c="ffffff,5,0.9,1" P1="1599.25,249.99" P2="1595.52,260.99"/><JD c="ffffff,5,0.9,1" P1="-1,249.5" P2="-6,260.5"/><JD c="ffffff,5,0.9,1" P1="0,289.5" P2="7,301.5"/><JD c="ffffff,5,0.9,1" P1="800,250.5" P2="808,261.5"/><JD c="ffffff,5,0.9,1" P1="801,289.5" P2="808,301.5"/><JD c="ffffff,5,0.9,1" P1="1601.76,293.29" P2="1608.76,305.29"/><JD c="ffffff,5,0.9,1" P1="1601.25,248.99" P2="1608.25,260.99"/><JD c="ffffff,5,0.9,1" P1="1,248.5" P2="8,260.5"/><JP M1="16" AXIS="-1,0" MV="Infinity,13.333333333333334"/><JP M1="16" AXIS="0,1"/><JP M1="17" AXIS="-1,0" MV="Infinity,13.333333333333334"/><JP M1="17" AXIS="0,1"/><JP M1="18" AXIS="-1,0" MV="Infinity,13.333333333333334"/><JP M1="18" AXIS="0,1"/></L></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA="20,1;;;;-0;0::0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,0,0,0,0,0,0,0,0:1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="307" Y="225" L="519" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="889" Y="225" L="511" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="176" L="10" H="159" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="573" Y="195" L="10" H="109" P="1,0,1.5,0,90,0,0,0" c="3" m=""/><S T="0" X="626" Y="195" L="10" H="109" P="1,0,1.5,0,90,0,0,0" c="3" m=""/><S T="0" X="-1" Y="245" L="10" H="305" P="1,0,1.5,0,90,0,0,0" c="3" m=""/><S T="0" X="1200" Y="250" L="10" H="305" P="1,0,1.5,0,90,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="175" L="10" H="158" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="53" Y="186" L="10" H="84" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1140" Y="184" L="10" H="84" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="8" X="221" Y="144" L="347" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3"/><S T="8" X="977" Y="145" L="335" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3"/><S T="8" X="488" Y="144" L="175" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3"/><S T="8" X="570" Y="196" L="109" H="10" P="0,0,0.3,0.2,-90,0,0,0" c="3"/><S T="8" X="628" Y="196" L="109" H="10" P="0,0,0.3,0.2,-90,0,0,0" c="3"/><S T="8" X="711" Y="145" L="175" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3"/><S T="8" X="399" Y="144" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3"/><S T="8" X="803" Y="145" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L><JD c="ffffff,5,0.9," P1="77,364.5" P2="77,365.5"/><JD c="ffffff,5,0.9,1" P1="-3,293.5" P2="-9,307.5"/><JD c="ffffff,5,0.9,1" P1="1199,292.5" P2="1193,306.5"/><JD c="ffffff,5,0.9,1" P1="570,201.5" P2="564,215.5"/><JD c="ffffff,5,0.9,1" P1="626,200.5" P2="620,214.5"/><JD c="ffffff,5,0.9,1" P1="-1,244.5" P2="-7,258.5"/><JD c="ffffff,5,0.9,1" P1="1201,243.5" P2="1195,257.5"/><JD c="ffffff,5,0.9,1" P1="572,152.5" P2="566,166.5"/><JD c="ffffff,5,0.9,1" P1="628,151.5" P2="622,165.5"/><JD c="ffffff,5,0.9,1" P1="-3,294.5" P2="4,307.5"/><JD c="ffffff,5,0.9,1" P1="1199,293.5" P2="1206,306.5"/><JD c="ffffff,5,0.9,1" P1="570,202.5" P2="577,215.5"/><JD c="ffffff,5,0.9,1" P1="626,201.5" P2="633,214.5"/><JD c="ffffff,5,0.9,1" P1="-1,245.5" P2="6,258.5"/><JD c="ffffff,5,0.9,1" P1="1201,244.5" P2="1208,257.5"/><JD c="ffffff,5,0.9,1" P1="572,153.5" P2="579,166.5"/><JD c="ffffff,5,0.9,1" P1="628,152.5" P2="635,165.5"/><JP M1="16" AXIS="-1,0" MV="Infinity,13.333333333333334"/><JP M1="16" AXIS="0,1"/><JP M1="17" AXIS="-1,0" MV="Infinity,13.333333333333334"/><JP M1="17" AXIS="0,1"/><JP M1="18" AXIS="-1,0" MV="Infinity,13.333333333333334"/><JP M1="18" AXIS="0,1"/><JP M1="19" AXIS="-1,0" MV="Infinity,13.333333333333334"/><JP M1="19" AXIS="0,1"/></L></Z></C>',
    [3] = 'Top player',
    [4] = 'Hxejss#7104',
    [5] = '<C><P F="0" G="0,4" MEDATA="16,1;;;;-0;0::0,1,2,3,4,5,6,7,0,0,0,0:1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="8" X="400" Y="225" L="720" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="8" X="400" Y="150" L="720" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3"/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="0" X="400" Y="180" L="10" H="150" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="8" X="755" Y="186" L="10" H="67" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="8" X="45" Y="186" L="10" H="67" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="8" X="0" Y="230" L="10" H="260" P="1,0,1.5,0,90,0,0,0" c="3" m="" tint="FF0000"/><S T="8" X="800" Y="230" L="10" H="260" P="1,0,1.5,0,90,0,0,0" c="3" m="" tint="FF0000"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L><JD c="ffffff,4,0.9,1" P1="0,301.42" P2="-5,308.07"/><JD c="ffffff,4,0.9,1" P1="0.44,281.48" P2="-5,288.13"/><JD c="ffffff,4,0.9,1" P1="0,301.74" P2="4.75,308.39"/><JD c="ffffff,4,0.9,1" P1="800,302" P2="805,308"/><JD c="ffffff,4,0.9,1" P1="800,281" P2="805,288"/><JD c="ffffff,4,0.9,1" P1="800,281" P2="795,288"/><JD c="ffffff,4,0.9,1" P1="800,301" P2="795,308"/><JD c="ffffff,4,0.9,1" P1="0,281.49" P2="5,288"/><JP M1="27" AXIS="-1,0" MV="Infinity,13.333333333333334"/><JP M1="27" AXIS="0,1"/><JP M1="28" AXIS="-1,0" MV="Infinity,13.333333333333334"/><JP M1="28" AXIS="0,1"/></L></Z></C>',
    [6] = '195540357b1.png'
  },
  [8] = {
    [1] = '<C><P L="1600" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="9" X="384" Y="192" L="14" H="95" P="0,0,0,0,0,0,0,0"/><S T="9" X="783" Y="193" L="14" H="95" P="0,0,0,0,0,0,0,0"/><S T="9" X="1183" Y="193" L="14" H="95" P="0,0,0,0,0,0,0,0"/><S T="9" X="450" Y="192" L="14" H="95" P="0,0,0,0,0,0,0,0"/><S T="9" X="849" Y="193" L="14" H="95" P="0,0,0,0,0,0,0,0"/><S T="9" X="1249" Y="193" L="14" H="95" P="0,0,0,0,0,0,0,0"/><S T="9" X="351" Y="192" L="14" H="95" P="0,0,0,0,0,0,0,0"/><S T="9" X="750" Y="193" L="14" H="95" P="0,0,0,0,0,0,0,0"/><S T="9" X="1150" Y="193" L="14" H="95" P="0,0,0,0,0,0,0,0"/><S T="9" X="417" Y="192" L="14" H="95" P="0,0,0,0,0,0,0,0"/><S T="9" X="816" Y="193" L="14" H="95" P="0,0,0,0,0,0,0,0"/><S T="9" X="1216" Y="193" L="14" H="95" P="0,0,0,0,0,0,0,0"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" G="0,4" MEDATA="16,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="798" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="394" Y="455" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="9" X="382" Y="193" L="15" H="97" P="0,0,0,0,0,0,0,0"/><S T="9" X="780" Y="193" L="15" H="97" P="0,0,0,0,0,0,0,0"/><S T="9" X="450" Y="193" L="15" H="97" P="0,0,0,0,0,0,0,0"/><S T="9" X="848" Y="193" L="15" H="97" P="0,0,0,0,0,0,0,0"/><S T="9" X="350" Y="193" L="15" H="97" P="0,0,0,0,0,0,0,0"/><S T="9" X="748" Y="193" L="15" H="97" P="0,0,0,0,0,0,0,0"/><S T="9" X="418" Y="193" L="15" H="97" P="0,0,0,0,0,0,0,0"/><S T="9" X="816" Y="193" L="15" H="97" P="0,0,0,0,0,0,0,0"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Water barrier',
    [4] = 'Hxejss#7104',
    [5] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="9" X="382" Y="190" L="15" H="102" P="0,0,0,0,0,0,0,0"/><S T="9" X="418" Y="190" L="15" H="102" P="0,0,0,0,0,0,0,0"/><S T="9" X="458" Y="190" L="15" H="102" P="0,0,0,0,0,0,0,0"/><S T="9" X="342" Y="190" L="15" H="102" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '19554042aaf.png'
  },
  [9] = {
    [1] = '<C><P L="1600" F="3" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="15" X="80" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="500" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="900" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="1321" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="280" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="700" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="1100" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="1521" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="15" X="281" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="1081" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="700" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="80" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="880" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/><S T="15" X="499" Y="300" L="10" H="100" P="0,0,0,0,0,0,0,0"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Cowebs',
    [4] = 'Ndisondoiasn#0148',
    [5] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="15" X="120" Y="300" L="10" H="99" P="0,0,0,0,0,0,0,0"/><S T="15" X="279" Y="300" L="10" H="99" P="0,0,0,0,0,0,0,0"/><S T="15" X="521" Y="300" L="10" H="99" P="0,0,0,0,0,0,0,0"/><S T="15" X="680" Y="300" L="10" H="99" P="0,0,0,0,0,0,0,0"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '1955400ff78.png'
  },
  [10] = {
    [1] = '<C><P L="1600" F="3" G="0,4" MEDATA="29,1;;;;-0;0:::1-"/><Z><S><S T="1" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="347" Y="162" L="10" H="68" P="0,0,0,0.2,-40,0,0,0"/><S T="1" X="452" Y="162" L="10" H="68" P="0,0,0,0.2,40,0,0,0"/><S T="1" X="745" Y="162" L="10" H="68" P="0,0,0,0.2,-40,0,0,0"/><S T="1" X="850" Y="162" L="10" H="68" P="0,0,0,0.2,40,0,0,0"/><S T="1" X="1147" Y="162" L="10" H="68" P="0,0,0,0.2,-40,0,0,0"/><S T="1" X="1252" Y="162" L="10" H="68" P="0,0,0,0.2,40,0,0,0"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><P X="1000" Y="372" T="143" P="1,0"/><P X="1500" Y="372" T="143" P="1,0"/><P X="600" Y="372" T="143" P="1,0"/><P X="100" Y="372" T="143" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="1" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="347" Y="162" L="10" H="68" P="0,0,0,0.2,-40,0,0,0"/><S T="1" X="452" Y="162" L="10" H="68" P="0,0,0,0.2,40,0,0,0"/><S T="1" X="745" Y="162" L="10" H="68" P="0,0,0,0.2,-40,0,0,0"/><S T="1" X="850" Y="162" L="10" H="68" P="0,0,0,0.2,40,0,0,0"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><P X="100" Y="372" T="143" P="1,0"/><P X="600" Y="372" T="143" P="1,0"/><P X="1100" Y="372" T="143" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Ice Angle',
    [4] = 'Ppoppohaejuseyo#2315',
    [5] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="1" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="1" X="347" Y="162" L="10" H="68" P="0,0,0,0.2,-40,0,0,0"/><S T="1" X="452" Y="162" L="10" H="68" P="0,0,0,0.2,40,0,0,0"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><P X="100" Y="372" T="143" P="1,0"/><P X="700" Y="372" T="143" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '1955401a394.png'
  },
  [11] = {
    [1] = '<C><P L="1600" F="2" G="0,4" MEDATA="15,1;;;;-0;0::0,0,0,0,0,0,0,0:1-"/><Z><S><S T="1" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="2" X="30" Y="225" L="10" H="80" P="1,987654,0,1.2,45,0,0,0"/><S T="2" X="1570" Y="225" L="10" H="80" P="1,987654,0,1.2,-45,0,0,0"/><S T="2" X="370" Y="330" L="10" H="50" P="1,987654,0,1.2,-45,0,0,0" c="2"/><S T="2" X="430" Y="330" L="10" H="50" P="1,987654,0,1.2,45,0,0,0" c="2"/><S T="2" X="770" Y="330" L="10" H="50" P="1,987654,0,1.2,-45,0,0,0" c="2"/><S T="2" X="830" Y="330" L="10" H="50" P="1,987654,0,1.2,45,0,0,0" c="2"/><S T="2" X="1170" Y="330" L="10" H="50" P="1,987654,0,1.2,-45,0,0,0" c="2"/><S T="2" X="1230" Y="330" L="10" H="50" P="1,987654,0,1.2,45,0,0,0" c="2"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L><JR M2="33" MV="Infinity,6.283185307179586"/><JR M2="34" MV="Infinity,-6.283185307179586"/><JR M2="35" MV="Infinity,6.283185307179586"/><JR M2="36" MV="Infinity,-6.283185307179586"/><JR M2="37" MV="Infinity,6.283185307179586"/><JR M2="38" MV="Infinity,-6.283185307179586"/><JR M2="39" MV="Infinity,6.283185307179586"/><JR M2="40" MV="Infinity,-6.283185307179586"/></L></Z></C>',
    [2] = '<C><P L="1200" F="2" G="0,4" MEDATA="15,1;;;;-0;0::0,0,0,0,0,0:1-"/><Z><S><S T="1" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="2" X="30" Y="225" L="10" H="80" P="1,987654,0,1.2,45,0,0,0"/><S T="2" X="370" Y="330" L="10" H="50" P="1,987654,0,1.2,-45,0,0,0" c="2"/><S T="2" X="430" Y="330" L="10" H="50" P="1,987654,0,1.2,45,0,0,0" c="2"/><S T="2" X="770" Y="330" L="10" H="50" P="1,987654,0,1.2,-45,0,0,0" c="2"/><S T="2" X="830" Y="330" L="10" H="50" P="1,987654,0,1.2,45,0,0,0" c="2"/><S T="2" X="1170" Y="225" L="10" H="80" P="1,987654,0,1.2,-45,0,0,0"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L><JR M2="28" MV="Infinity,6.283185307179586"/><JR M2="29" MV="Infinity,6.283185307179586"/><JR M2="30" MV="Infinity,-6.283185307179586"/><JR M2="31" MV="Infinity,6.283185307179586"/><JR M2="32" MV="Infinity,-6.283185307179586"/><JR M2="33" MV="Infinity,-6.283185307179586"/></L></Z></C>',
    [3] = 'Rotating trampolines',
    [4] = 'Artgir#0000',
    [5] = '<C><P F="2" G="0,4" MEDATA="15,1;;;;-0;0::0,0,0,0:1-"/><Z><S><S T="1" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="2" X="30" Y="225" L="10" H="80" P="1,987654,0,1.2,45,0,0,0"/><S T="2" X="770" Y="225" L="10" H="80" P="1,987654,0,1.2,-45,0,0,0"/><S T="2" X="370" Y="330" L="10" H="50" P="1,987654,0,1.2,-45,0,0,0" c="2"/><S T="2" X="430" Y="330" L="10" H="50" P="1,987654,0,1.2,45,0,0,0" c="2"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L><JR M2="23" MV="Infinity,6.283185307179586"/><JR M2="24" MV="Infinity,-6.283185307179586"/><JR M2="25" MV="Infinity,6.283185307179586"/><JR M2="26" MV="Infinity,-6.283185307179586"/></L></Z></C>',
    [6] = '19554029c25.png'
  },
  [12] = {
    [1] = '<C><P L="1600" G="0,4" mc="" MEDATA="29,1;;;0,2:1,2:2,2:3,2:4,2:5,2:6,2:7,2:8,2:9,2:10,2;-0;0::0,1,2,3,4,5,6,7,8,9,10:1-"/><Z><S><S T="3" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="800" Y="200" L="1600" H="400" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="800" Y="-800" L="1600" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="3" X="200" Y="495" L="30" H="30" P="1,0,0,1,0,1,0,0" c="2" grav="2.5" nosync=""/><S T="3" X="600" Y="494" L="30" H="30" P="1,0,0,1,0,1,0,0" c="2" grav="2.5" nosync=""/><S T="3" X="999" Y="494" L="30" H="30" P="1,0,0,1,0,1,0,0" c="2" grav="2.5" nosync=""/><S T="3" X="1400" Y="495" L="30" H="30" P="1,0,0,1,0,1,0,0" c="2" grav="2.5" nosync=""/><S T="3" X="200" Y="495" L="30" H="30" P="1,0,0,1,45,1,0,0" c="2" grav="2.5" nosync=""/><S T="3" X="600" Y="495" L="30" H="30" P="1,0,0,1,45,1,0,0" c="2" grav="2.5" nosync=""/><S T="3" X="1000" Y="495" L="30" H="30" P="1,0,0,1,45,1,0,0" c="2" grav="2.5" nosync=""/><S T="3" X="1400" Y="495" L="30" H="30" P="1,0,0,1,45,1,0,0" c="2" grav="2.5" nosync=""/><S T="12" X="800" Y="640" L="40" H="40" P="1,100000,0.3,0.2,0,1,0,0" o="324650" c="4" grav="2.5" m="" nosync=""/><S T="12" X="800" Y="935" L="10" H="10" P="1,999999,0.3,0.2,0,0,0,0" o="324650" c="4" grav="2.5" m="" nosync=""/></S><D><P X="98" Y="440" T="44" P="1,0"/><P X="599" Y="440" T="44" P="1,0"/><P X="999" Y="440" T="44" P="1,0"/><P X="1499" Y="440" T="44" P="1,0"/><DS X="365" Y="-141"/></D><O><O X="200" Y="495" C="22" P="0"/><O X="600" Y="495" C="22" P="0"/><O X="1000" Y="495" C="22" P="0"/><O X="1400" Y="495" C="22" P="0"/><O X="800" Y="750" C="11" P="0"/></O><L><JR M1="33" M2="41"/><JR M1="34" M2="41"/><JR M1="35" M2="41"/><JR M1="36" M2="41"/><JR M1="37" M2="41"/><JR M1="38" M2="41"/><JR M1="39" M2="41"/><JR M1="40" M2="41"/><JP M1="41" AXIS="0,1"/><JR M1="42" P1="800,750" MV="Infinity,-0.5"/><JD M1="42" M2="41"/></L></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" mc="" MEDATA="24,1;;;;-0;0::0,1,2,3,4,5,6,7,8:1-"/><Z><S><S T="3" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="600" Y="200" L="1200" H="400" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="3" X="200" Y="495" L="30" H="30" P="1,0,0,1,0,1,0,0" c="2" grav="2.5" nosync=""/><S T="3" X="600" Y="495" L="30" H="30" P="1,0,0,1,0,1,0,0" c="2" grav="2.5" nosync=""/><S T="3" X="1000" Y="495" L="30" H="30" P="1,0,0,1,0,1,0,0" c="2" grav="2.5" nosync=""/><S T="3" X="200" Y="495" L="30" H="30" P="1,0,0,1,45,1,0,0" c="2" grav="2.5" nosync=""/><S T="3" X="600" Y="495" L="30" H="30" P="1,0,0,1,45,1,0,0" c="2" grav="2.5" nosync=""/><S T="3" X="1000" Y="495" L="30" H="30" P="1,0,0,1,45,1,0,0" c="2" grav="2.5" nosync=""/><S T="12" X="599" Y="640" L="40" H="40" P="1,100000,0.3,0.2,0,1,0,0" o="324650" c="4" grav="2.5" m="" nosync=""/><S T="12" X="600" Y="935" L="10" H="10" P="1,999999,0.3,0.2,0,0,0,0" o="324650" c="4" grav="2.5" m="" nosync=""/></S><D><P X="99" Y="440" T="44" P="1,0"/><P X="599" Y="440" T="44" P="1,0"/><P X="999" Y="440" T="44" P="1,0"/><DS X="365" Y="-141"/></D><O><O X="200" Y="495" C="22" P="0"/><O X="600" Y="495" C="22" P="0"/><O X="1000" Y="495" C="22" P="0"/><O X="600" Y="750" C="11" P="0"/></O><L><JR M1="27" M2="33"/><JR M1="28" M2="33"/><JR M1="29" M2="33"/><JR M1="30" M2="33"/><JR M1="31" M2="33"/><JR M1="32" M2="33"/><JP M1="33" AXIS="0,1"/><JR M1="34" P1="600,750" MV="Infinity,-0.5"/><JD M1="34" M2="33"/></L></Z></C>',
    [3] = 'The floor is lava',
    [4] = 'Kralizmox#0000',
    [5] = '<C><P G="0,4" mc="" MEDATA="14,1;;;;-0;0::0,1,2,3,4,5,6:1-"/><Z><S><S T="3" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="400" Y="200" L="800" H="400" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="3" X="200" Y="495" L="30" H="30" P="1,0,0,1,0,1,0,0" c="2" nosync=""/><S T="3" X="600" Y="495" L="30" H="30" P="1,0,0,1,0,1,0,0" c="2" nosync=""/><S T="3" X="200" Y="495" L="30" H="30" P="1,0,0,1,45,1,0,0" c="2" nosync=""/><S T="3" X="600" Y="495" L="30" H="30" P="1,0,0,1,45,1,0,0" c="2" nosync=""/><S T="12" X="400" Y="640" L="40" H="40" P="1,100000,0.3,0.2,0,1,0,0" o="324650" c="4" m=""/><S T="12" X="400" Y="935" L="10" H="10" P="1,999999,0.3,0.2,0,0,0,0" o="324650" c="4" m="" nosync=""/></S><D><P X="99" Y="440" T="44" P="1,0"/><P X="699" Y="440" T="44" P="1,0"/><DS X="360" Y="-151"/></D><O><O X="400" Y="750" C="11" P="0"/><O X="200" Y="495" C="22" P="0"/><O X="600" Y="495" C="22" P="0"/></O><L><JR M1="22" M2="26"/><JR M1="23" M2="26"/><JR M1="24" M2="26"/><JR M1="25" M2="26"/><JP M1="26" AXIS="0,1"/><JR M1="27" P1="400,750" MV="Infinity,-0.5"/><JD M1="26" M2="27"/></L></Z></C>',
    [6] = '195540328d1.png'
  },
  [13] = {
    [1] = '<C><P L="1600" F="3" G="0,4" MEDATA="28,1;;;;-0;0:::1-"/><Z><S><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="9" X="400" Y="150" L="30" H="150" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/><S T="9" X="800" Y="150" L="30" H="150" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/><S T="9" X="1200" Y="150" L="30" H="150" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/><S T="4" X="805" Y="400" L="1610" H="100" P="0,0,370,0,0,0,0,0" c="3" N=""/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA="24,1;;;;-0;0:::1-"/><Z><S><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="9" X="400" Y="150" L="30" H="150" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/><S T="9" X="800" Y="150" L="30" H="150" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/><S T="4" X="600" Y="400" L="1200" H="100" P="0,0,370,0,0,0,0,0" c="3" N=""/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Black water with chocolate floor',
    [4] = 'Asdfghjkkk#8564',
    [5] = '<C><P F="0" G="0,4" MEDATA="14,1;;;;-0;0:::1-"/><Z><S><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="9" X="400" Y="150" L="30" H="150" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/><S T="4" X="400" Y="400" L="800" H="100" P="0,0,370,0,0,0,0,0" c="3" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '1955400a1b1.png'
  },
  [14] = {
    [1] = '<C><P G="0,4" mc="" F="3" MEDATA=";;;;-0;0::0,1,2,3:1-" L="1600" /><Z><S><S P="0,0,0.1,0.2,0,0,0,0" H="100" L="1610" X="805" c="3" N="" Y="400" T="7" /><S P="0,0,0,0.2,0,0,0,0" L="10" X="400" H="200" Y="350" T="1" /><S P="0,0,0,0.2,0,0,0,0" L="10" X="800" H="200" Y="350" T="1" /><S P="0,0,0,0.2,0,0,0,0" L="10" X="1200" H="200" Y="350" T="1" /><S P="1,0,0,1,45,1,0,0" c="3" L="80" nosync="" grav="2.5" X="1600" H="80" Y="350" T="2" /><S P="1,0,0,1,45,1,0,0" c="3" L="80" nosync="" grav="2.5" X="0" H="80" Y="350" T="2" /><S nosync="" P="1,0,0,0,45,1,0,0" c="3" L="60" o="10193F" grav="2.5" X="1600" H="60" Y="350" T="12" /><S nosync="" P="1,0,0,0,45,1,0,0" c="3" L="60" o="10193F" grav="2.5" X="0" H="60" Y="350" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" L="100" o="6a7495" X="-50" H="3000" Y="-1000" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" L="100" o="6a7495" X="1645" H="3000" Y="-1000" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="100" c="3" Y="359" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="600" c="3" Y="359" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="105" L="100" o="324650" X="250" c="4" Y="45" T="12" /><S P="0,0,0,0.2,0,0,0,0" H="10" L="1620" X="790" c="3" Y="0" T="1" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="1620" m="" X="790" c="3" Y="95" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" H="100" L="10" m="" X="305" c="3" Y="48" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" H="100" L="10" m="" X="1300" c="3" Y="48" T="0" /><S P="0,0,0,0,0,0,0,0" H="150" L="10" m="" X="400" c="3" Y="175" T="0" /><S P="0,0,0.3,0.2,90,0,0,0" H="10" L="800" m="" X="400" c="3" Y="791" T="0" /><S P="0,0,0.2,0.2,0,0,0,0" H="200" L="20" o="6a7495" X="316" c="3" Y="-129" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" H="200" L="20" o="6a7495" X="407" c="3" Y="-133" T="12" /><S P="0,0,0.2,0.2,90,0,0,0" H="100" L="20" o="6a7495" X="363" c="3" Y="-92" T="12" /><S P="0,0,0.2,0.2,90,0,0,0" H="100" L="20" o="6a7495" X="360" c="3" Y="-206" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" H="120" L="3000" o="6a7495" X="400" c="4" N="" Y="460" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" H="105" L="100" o="324650" X="1350" c="4" Y="45" T="12" /><S P="0,0,0,0.2,0,0,0,0" L="1600" X="800" H="10" Y="-800" T="1" /><S P="0,0,0.3,0.2,90,0,0,0" H="10" L="800" m="" X="800" c="3" Y="790" T="0" /><S P="0,0,0,0,0,0,0,0" H="150" L="10" m="" X="800" c="3" Y="175" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="1000" c="3" Y="359" T="13" /><S P="0,0,0,0,0,0,0,0" H="150" L="10" m="" X="1200" c="3" Y="175" T="0" /><S P="0,0,0.3,0.2,90,0,0,0" H="10" L="800" m="" X="1200" c="3" Y="790" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" H="105" L="100" o="324650" X="600" c="4" Y="45" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" H="105" L="100" o="324650" X="1000" c="4" Y="45" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="1500" c="3" Y="359" T="13" /><S P="0,0,0,0,0,0,0,0" c="2" L="1620" o="89A7F5" m="" X="800" H="10" Y="600" T="12" /><S P="0,0,0,0,0,0,0,0" c="2" L="1620" o="89A7F5" m="" X="800" H="10" Y="700" T="12" /><S P="0,0,0.3,1,0,0,0,0" c="2" L="10" o="6D4E94" m="" X="-15" H="20" Y="595" T="12" /><S P="0,0,0.3,1,0,0,0,0" c="2" L="10" o="6D4E94" m="" X="-15" H="20" Y="695" T="12" /><S nosync="" P="1,999999,0.3,0,0,1,0,0" c="2" L="20" o="324650" grav="2.5" m="" X="0" H="20" Y="585" T="12" /><S nosync="" P="1,999999,0.3,0,0,1,0,0" c="2" L="20" o="324650" grav="2.5" m="" X="1600" H="20" Y="685" T="12" /><S P="0,0,0.3,1,0,0,0,0" c="2" L="10" o="6D4E94" m="" X="1615" H="20" Y="595" T="12" /><S P="0,0,0.3,1,0,0,0,0" c="2" L="10" o="6D4E94" m="" X="1615" H="20" Y="695" T="12" /><S P="1,999999,0,10,45,1,0,0" c="2" L="10" nosync="" grav="2.5" m="" X="-11" H="10" Y="565" T="2" /><S P="1,999999,0,10,45,1,0,0" c="2" L="10" nosync="" grav="2.5" m="" X="1611" H="10" Y="665" T="2" /></S><D><P X="599" P="1,0" Y="363" T="10" /><P X="99" P="1,0" Y="363" T="10" /><P X="999" P="1,0" Y="363" T="10" /><P X="1499" P="1,0" Y="363" T="10" /><DS Y="-141" X="365" /></D><O><O P="0" C="22" X="0" Y="350" /><O P="0" C="22" X="1600" Y="350" /></O><L><JR M2="39" M1="4" /><JR M2="38" M1="5" /><JR M2="39" M1="6" /><JR M2="38" M1="7" /></L></Z></C>',
    [2] = '<C><P G="0,4" mc="" F="3" MEDATA=";;;;-0;0::0,1,2,3:1-" L="1200" /><Z><S><S P="0,0,0.1,0.2,0,0,0,0" c="3" L="1200" X="600" H="100" N="" Y="400" T="7" /><S P="0,0,0,0.2,0,0,0,0" L="10" X="400" H="200" Y="350" T="1" /><S P="0,0,0,0.2,0,0,0,0" L="10" X="800" H="200" Y="350" T="1" /><S P="1,0,0,1,45,1,0,0" c="3" L="80" grav="2" X="1200" H="80" Y="350" T="2" /><S P="1,0,0,1,45,1,0,0" c="3" L="80" nosync="" grav="2.5" X="0" H="80" Y="350" T="2" /><S nosync="" P="1,0,0,0,45,1,0,0" c="3" L="60" o="10193F" grav="2.5" X="1200" H="60" Y="350" T="12" /><S nosync="" P="1,0,0,0,45,1,0,0" c="3" L="60" o="10193F" grav="2.5" X="0" H="60" Y="350" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" L="100" o="6a7495" X="1245" H="3000" Y="-1000" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="100" c="3" Y="359" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="600" c="3" Y="359" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="250" H="105" Y="45" T="12" /><S P="0,0,0,0.2,0,0,0,0" c="3" L="1200" X="600" H="10" Y="0" T="1" /><S P="0,0,0.2,0.2,0,0,0,0" L="100" o="6a7495" X="-50" H="3000" Y="-1000" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="1200" m="" X="600" H="10" Y="95" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" m="" X="305" H="100" Y="48" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" m="" X="900" H="100" Y="48" T="0" /><S P="0,0,0,0,0,0,0,0" c="3" L="10" m="" X="400" H="150" Y="175" T="0" /><S P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" m="" X="400" H="10" Y="791" T="0" /><S P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="316" H="200" Y="-129" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="407" H="200" Y="-133" T="12" /><S P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="363" H="100" Y="-92" T="12" /><S P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="360" H="100" Y="-206" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="3000" o="6a7495" X="400" H="120" N="" Y="460" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="950" H="105" Y="45" T="12" /><S P="0,0,0,0.2,0,0,0,0" L="1200" X="600" H="10" Y="-800" T="1" /><S P="0,0,0,0,0,0,0,0" c="3" L="10" m="" X="800" H="150" Y="175" T="0" /><S P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" m="" X="800" H="10" Y="791" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="1100" c="3" Y="359" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="600" H="105" Y="45" T="12" /><S P="0,0,0.3,1,0,0,0,0" c="2" L="10" o="6D4E94" m="" X="-15" H="20" Y="595" T="12" /><S P="0,0,0.3,1,0,0,0,0" c="2" L="10" o="6D4E94" m="" X="-15" H="20" Y="695" T="12" /><S P="0,0,0.3,1,0,0,0,0" c="2" L="10" o="6D4E94" m="" X="1215" H="20" Y="594" T="12" /><S P="0,0,0.3,1,0,0,0,0" c="2" L="10" o="6D4E94" m="" X="1215" H="20" Y="694" T="12" /><S P="0,0,0,0,0,0,0,0" L="1220" o="89A7F5" m="" X="600" H="10" Y="600" T="12" /><S P="0,0,0,0,0,0,0,0" L="1220" o="89A7F5" m="" X="600" H="10" Y="700" T="12" /><S P="1,999999,0,7.5,45,1,0,0" c="2" L="10" nosync="" grav="2.5" m="" X="-11" H="10" Y="565" T="2" /><S nosync="" P="1,999999,0.3,0.2,0,1,0,0" c="2" L="20" o="324650" grav="2.5" m="" X="0" H="20" Y="585" T="12" /><S nosync="" P="1,999999,0.3,0.2,0,1,0,0" c="2" L="20" o="324650" grav="2.5" m="" X="1200" H="20" Y="685" T="12" /><S P="1,999999,0,7.5,45,1,0,0" c="2" L="10" nosync="" grav="2.5" m="" X="1211" H="10" Y="665" T="2" /></S><D><P X="599" P="1,0" Y="363" T="10" /><P X="99" P="1,0" Y="363" T="10" /><P X="1099" P="1,0" Y="363" T="10" /><DS Y="-141" X="365" /></D><O><O P="0" X="0" C="22" Y="350" /><O P="0" X="1200" C="22" Y="350" /></O><L><JR M2="37" M1="3" /><JR M2="36" M1="4" /><JR M2="37" M1="5" /><JR M2="36" M1="6" /></L></Z></C>',
    [3] = 'Two trambolines at bottom',
    [4] = 'Kralizmox#0000',
    [5] = '<C><P G="0,4" mc="" F="0" MEDATA=";;;;-0;0::0,1,2,3:1-" /><Z><S><S P="0,0,0.1,0.2,0,0,0,0" c="3" L="800" X="400" H="100" N="" Y="400" T="7" /><S P="0,0,0,0.2,0,0,0,0" L="10" X="400" H="200" Y="350" T="1" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="100" c="3" Y="359" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="700" c="3" Y="359" T="13" /><S P="1,0,0,1,45,1,0,0" c="3" L="80" nosync="" grav="2.5" X="800" H="80" Y="350" T="2" /><S P="1,0,0,1,45,1,0,0" c="3" L="80" nosync="" grav="2.5" X="-1" H="80" Y="350" T="2" /><S nosync="" P="1,0,0,0,45,1,0,0" c="3" L="60" o="A4D0E7" grav="2.5" X="800" H="60" Y="350" T="12" /><S nosync="" P="1,0,0,0,45,1,0,0" c="3" L="60" o="A4D0E7" grav="2.5" X="0" H="60" Y="350" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="50" H="105" Y="45" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" L="100" o="6a7495" X="845" H="3000" Y="-1000" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" L="100" o="6a7495" X="-50" H="3000" Y="-1000" T="12" /><S P="0,0,0,0.2,0,0,0,0" c="3" L="800" X="400" H="10" N="" Y="0" T="1" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="800" m="" X="400" H="10" N="" Y="95" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" m="" X="105" H="100" Y="48" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" m="" X="700" H="100" N="" Y="48" T="0" /><S P="0,0,0,0,0,0,0,0" c="3" L="10" m="" X="400" H="150" Y="175" T="0" /><S P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" m="" X="400" H="10" Y="791" T="0" /><S P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="316" H="200" Y="-129" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="407" H="200" Y="-133" T="12" /><S P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="363" H="100" Y="-92" T="12" /><S P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="360" H="100" Y="-206" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="3000" o="6a7495" X="400" H="120" N="" Y="460" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="750" H="105" Y="45" T="12" /><S P="0,0,0,0.2,0,0,0,0" L="800" X="400" H="10" N="" Y="-800" T="1" /><S P="0,0,0.3,1,0,0,0,0" c="2" L="10" o="6D4E94" m="" X="-15" H="20" Y="595" T="12" /><S P="0,0,0.3,1,0,0,0,0" c="2" L="10" o="6D4E94" m="" X="-15" H="20" Y="695" T="12" /><S P="0,0,0.3,1,0,0,0,0" c="2" L="10" o="6D4E94" m="" X="815" H="20" Y="595" T="12" /><S P="0,0,0.3,1,0,0,0,0" c="2" L="10" o="6D4E94" m="" X="815" H="20" Y="695" T="12" /><S P="0,0,0,0,0,0,0,0" c="2" L="820" o="89A7F5" m="" X="400" H="10" Y="599" T="12" /><S P="0,0,0,0,0,0,0,0" c="2" L="820" o="89A7F5" m="" X="400" H="10" Y="699" T="12" /><S nosync="" P="1,999999,0.3,0.2,0,1,0,0" c="2" L="20" o="324650" grav="2.5" m="" X="0" H="20" Y="585" T="12" /><S nosync="" P="1,999999,0.3,0.2,0,1,0,0" c="2" L="20" o="324650" grav="2.5" m="" X="800" H="20" Y="685" T="12" /><S P="1,999999,0,5,45,1,0,0" c="2" L="10" nosync="" grav="2.5" m="" X="-11" H="10" Y="565" T="2" /><S P="1,999999,0,5,45,1,0,0" c="2" L="10" nosync="" grav="2.5" m="" X="811" H="10" Y="665" T="2" /></S><D><P X="699" P="1,0" Y="365" T="10" /><P X="99" P="1,0" Y="365" T="10" /><DS Y="-151" X="360" /></D><O><O P="0" X="0" C="22" Y="350" /><O P="0" X="800" C="22" Y="350" /></O><L><JR M2="31" M1="4" /><JR M2="30" M1="5" /><JR M2="31" M1="6" /><JR M2="30" M1="7" /></L></Z></C>',
    [6] = '1955403cceb.png'
  },
  [15] = {
    [1] = '<C><P L="1600" F="3" G="0,4" MEDATA="29,1;;;;-0;0:::1-"/><Z><S><S T="7" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="9" X="400" Y="194" L="30" H="60" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/><S T="9" X="800" Y="194" L="30" H="60" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/><S T="9" X="1200" Y="194" L="30" H="60" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA="25,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="9" X="800" Y="194" L="30" H="60" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/><S T="9" X="400" Y="194" L="30" H="60" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Black water (small)',
    [4] = 'Asdfghjkkk#8564',
    [5] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="9" X="400" Y="194" L="30" H="60" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '19554008a40.png'
  },
  [16] = {
    [1] = '<C><P L="1600" F="3" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="7" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="808" Y="310" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA="14,1;;;;-0;0:::1-"/><Z><S><S T="7" X="596" Y="399" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="594" Y="309" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'No jump',
    [4] = 'Raf02#4942',
    [5] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="399" Y="311" L="814" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '19539e5756b.png'
  },
  [17] = {
    [1] = '<C><P L="1600" F="2" G="0,4" MEDATA="13,1;;;;-0;0:::1-"/><Z><S><S T="20" X="805" Y="400" L="1610" H="100" P="0,0,100,0.2,0,0,0,0" c="3" N="" friction="100,20"/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0.01,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="792" Y="136" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="197" L="10" H="115" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0.01,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="195" L="10" H="118" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0.01,0.2,0,0,0,0"/><S T="0" X="1200" Y="195" L="10" H="118" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="-1" Y="224" L="97" H="245" P="0,0,0.01,0.2,20,0,0,0"/><S T="1" X="1610" Y="234" L="97" H="245" P="0,0,0.01,0.2,-20,0,0,0"/><S T="1" X="44" Y="212" L="73" H="32" P="0,0,0.01,0.2,-40,0,0,0"/><S T="1" X="1564" Y="220" L="73" H="32" P="0,0,0.01,0.2,40,0,0,0"/><S T="1" X="71" Y="161" L="75" H="32" P="0,0,0.01,0.2,-80,0,0,0"/><S T="1" X="1533" Y="171" L="75" H="32" P="0,0,0.01,0.2,80,0,0,0"/><S T="1" X="11" Y="101" L="73" H="32" P="0,0,0,0.2,-130,0,0,0"/><S T="1" X="1595" Y="109" L="73" H="32" P="0,0,0,0.2,130,0,0,0"/><S T="1" X="289" Y="296" L="10" H="135" P="0,0,0.01,0.2,-20,0,0,0"/><S T="1" X="690" Y="296" L="10" H="135" P="0,0,0.01,0.2,-20,0,0,0"/><S T="1" X="1089" Y="296" L="10" H="135" P="0,0,0.01,0.2,-20,0,0,0"/><S T="1" X="512" Y="296" L="10" H="135" P="0,0,0.01,0.2,20,0,0,0"/><S T="1" X="913" Y="296" L="10" H="135" P="0,0,0.01,0.2,20,0,0,0"/><S T="1" X="1312" Y="296" L="10" H="135" P="0,0,0.01,0.2,20,0,0,0"/><S T="12" X="1678" Y="-1" L="143" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-56" Y="0" L="112" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><P X="1292" Y="3" T="288" P="1,0"/><P X="918" Y="91" T="287" P="0,0"/><P X="189" Y="-23" T="220" P="0,0"/><P X="1434" Y="47" T="221" P="0,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="2" G="0,4" MEDATA="13,1;;;;-0;0:::1-"/><Z><S><S T="20" X="600" Y="400" L="1200" H="100" P="0,0,100,0.2,0,0,0,0" c="3" N="" friction="100,20"/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0.01,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="136" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="196" L="10" H="116" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0.01,0.2,0,0,0,0"/><S T="0" X="800" Y="196" L="10" H="116" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="513" Y="296" L="10" H="135" P="0,0,0.01,0.2,20,0,0,0"/><S T="1" X="913" Y="296" L="10" H="135" P="0,0,0.01,0.2,20,0,0,0"/><S T="1" X="290" Y="296" L="10" H="135" P="0,0,0.01,0.2,-20,0,0,0"/><S T="1" X="10" Y="102" L="73" H="32" P="0,0,0,0.2,50,0,0,0"/><S T="1" X="1188" Y="104" L="73" H="32" P="0,0,0,0.2,-50,0,0,0"/><S T="1" X="690" Y="296" L="10" H="135" P="0,0,0.01,0.2,-20,0,0,0"/><S T="1" X="-2" Y="228" L="97" H="245" P="0,0,0.01,0.2,20,0,0,0"/><S T="1" X="1200" Y="230" L="97" H="245" P="0,0,0.01,0.2,-20,0,0,0"/><S T="12" X="-74" Y="0" L="148" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="72" Y="165" L="75" H="32" P="0,0,0.01,0.2,-80,0,0,0"/><S T="1" X="1126" Y="167" L="75" H="32" P="0,0,0.01,0.2,80,0,0,0"/><S T="1" X="46" Y="216" L="73" H="32" P="0,0,0.01,0.2,-40,0,0,0"/><S T="1" X="1152" Y="218" L="73" H="32" P="0,0,0.01,0.2,40,0,0,0"/><S T="12" X="1253" Y="0" L="116" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><P X="147" Y="55" T="219" P="0,0"/><P X="885" Y="117" T="221" P="0,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Honeymoon',
    [4] = 'Boczek#7535',
    [5] = '<C><P F="2" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="20" X="400" Y="400" L="800" H="100" P="0,0,100,0.2,0,0,0,0" c="3" N="" friction="100,20"/><S T="1" X="13" Y="114" L="73" H="32" P="0,0,0,0.2,50,0,0,0"/><S T="1" X="783" Y="112" L="73" H="32" P="0,0,0,0.2,-50,0,0,0"/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0.01,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="144" L="801" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="200" L="10" H="109" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="1" X="-5" Y="237" L="97" H="245" P="0,0,0.01,0.2,20,0,0,0"/><S T="1" X="801" Y="235" L="97" H="245" P="0,0,0.01,0.2,-20,0,0,0"/><S T="1" X="71" Y="175" L="75" H="32" P="0,0,0.01,0.2,-80,0,0,0"/><S T="1" X="725" Y="173" L="75" H="32" P="0,0,0.01,0.2,80,0,0,0"/><S T="1" X="45" Y="223" L="73" H="32" P="0,0,0.01,0.2,-40,0,0,0"/><S T="1" X="751" Y="221" L="73" H="32" P="0,0,0.01,0.2,40,0,0,0"/><S T="12" X="-55" Y="0" L="110" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="871" Y="0" L="142" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="1" X="289" Y="295" L="10" H="135" P="0,0,0.01,0.2,-20,0,0,0"/><S T="1" X="512" Y="295" L="10" H="135" P="0,0,0.01,0.2,20,0,0,0"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><P X="639" Y="91" T="287" P="0,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '19554018c22.png'
  },
  [18] = {
    [1] = '<C><P L="1600" F="3" G="0,4" C="" MEDATA="14,1;;;;-0;0:::1-"/><Z><S><S T="7" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="175" L="10" H="158" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="175" L="10" H="158" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="176" L="10" H="156" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="802" Y="71"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" C="" MEDATA="14,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="175" L="10" H="158" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="176" L="10" H="156" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><DS X="506" Y="67"/></D><O/><L/></Z></C>',
    [3] = 'Collision',
    [4] = 'Raf02#4942',
    [5] = '<C><P F="0" G="0,4" C="" MEDATA="14,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="400" Y="175" L="10" H="158" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '19539e5756b.png'
  },
  [19] = {
    [1] = '<C><P L="1600" F="5" G="0,4" MEDATA=";;;;-0;0:::1-"/><Z><S><S T="11" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="11" X="-6" Y="311" L="184" H="76" P="0,0,0.05,0.1,50,0,0,0" c="3"/><S T="11" X="1604" Y="308" L="184" H="76" P="0,0,0.05,0.1,-50,0,0,0" c="3"/><S T="11" X="187" Y="367" L="184" H="97" P="0,0,0.05,0.1,-40,0,0,0" c="3"/><S T="11" X="988" Y="362" L="184" H="97" P="0,0,0.05,0.1,-40,0,0,0" c="3"/><S T="11" X="585" Y="364" L="184" H="97" P="0,0,0.05,0.1,-40,0,0,0" c="3"/><S T="11" X="612" Y="365" L="184" H="97" P="0,0,0.05,0.1,40,0,0,0" c="3"/><S T="11" X="1010" Y="362" L="184" H="97" P="0,0,0.05,0.1,40,0,0,0" c="3"/><S T="12" X="1647" Y="0" L="104" H="3000" P="0,0,0,0.2,0,0,0,0" o="6a7495"/><S T="11" X="1411" Y="364" L="184" H="97" P="0,0,0.05,0.1,40,0,0,0" c="3"/><S T="11" X="284" Y="359" L="184" H="97" P="0,0,0.05,0.1,30,0,0,0" c="3"/><S T="11" X="1085" Y="354" L="184" H="97" P="0,0,0.05,0.1,30,0,0,0" c="3"/><S T="11" X="682" Y="356" L="184" H="97" P="0,0,0.05,0.1,30,0,0,0" c="3"/><S T="11" X="515" Y="357" L="184" H="97" P="0,0,0.05,0.1,-30,0,0,0" c="3"/><S T="11" X="913" Y="354" L="184" H="97" P="0,0,0.05,0.1,-30,0,0,0" c="3"/><S T="11" X="1314" Y="356" L="184" H="97" P="0,0,0.05,0.1,-30,0,0,0" c="3"/><S T="11" X="346" Y="365" L="185" H="107" P="0,0,0.05,0.1,-30,0,0,0" c="3"/><S T="11" X="1147" Y="360" L="185" H="107" P="0,0,0.05,0.1,-30,0,0,0" c="3"/><S T="11" X="744" Y="362" L="185" H="107" P="0,0,0.05,0.1,-30,0,0,0" c="3"/><S T="11" X="453" Y="363" L="185" H="107" P="0,0,0.05,0.1,30,0,0,0" c="3"/><S T="11" X="851" Y="360" L="185" H="107" P="0,0,0.05,0.1,30,0,0,0" c="3"/><S T="11" X="1252" Y="362" L="185" H="107" P="0,0,0.05,0.1,30,0,0,0" c="3"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="-57" Y="0" L="116" H="3000" P="0,0,0,0.2,0,0,0,0" o="6a7495"/><S T="0" X="790" Y="115" L="1620" H="49" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="194" L="10" H="120" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="10" H="880" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="10" H="880" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="791" L="10" H="880" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="195" L="10" H="119" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="194" L="10" H="120" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="8" X="39" Y="136" L="10" H="10" P="0,0,0.3,0.2,10,0,0,0" tint="76D7F7"/><S T="8" X="1559" Y="136" L="10" H="10" P="0,0,0.3,0.2,-10,0,0,0" tint="76D7F7"/><S T="8" X="168" Y="185" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76D7F7"/><S T="8" X="1430" Y="185" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76D7F7"/><S T="8" X="255" Y="100" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76D7F7"/><S T="8" X="1055" Y="100" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76D7F7"/><S T="8" X="655" Y="100" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76D7F7"/><S T="8" X="546" Y="100" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76D7F7"/><S T="8" X="946" Y="100" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76D7F7"/><S T="8" X="1343" Y="100" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76D7F7"/><S T="8" X="329" Y="193" L="10" H="10" P="0,0,0.3,0.2,40,0,0,0" tint="76D7F7"/><S T="8" X="1129" Y="193" L="10" H="10" P="0,0,0.3,0.2,40,0,0,0" tint="76D7F7"/><S T="8" X="729" Y="193" L="10" H="10" P="0,0,0.3,0.2,40,0,0,0" tint="76D7F7"/><S T="8" X="472" Y="193" L="10" H="10" P="0,0,0.3,0.2,-40,0,0,0" tint="76D7F7"/><S T="8" X="872" Y="193" L="10" H="10" P="0,0,0.3,0.2,-40,0,0,0" tint="76D7F7"/><S T="8" X="1269" Y="193" L="10" H="10" P="0,0,0.3,0.2,-40,0,0,0" tint="76D7F7"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="5" G="0,4" MEDATA="30,1;;;;-0;0:::1-"/><Z><S><S T="11" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="11" X="3" Y="308" L="167" H="72" P="0,0,0.05,0.1,50,0,0,0" c="3"/><S T="11" X="1198" Y="308" L="167" H="72" P="0,0,0.05,0.1,-50,0,0,0" c="3"/><S T="12" X="1253" Y="0" L="115" H="3000" P="0,0,0,0.2,0,0,0,0" o="6a7495"/><S T="11" X="186" Y="366" L="169" H="87" P="0,0,0.05,0.1,-40,0,0,0" c="3"/><S T="11" X="586" Y="366" L="169" H="87" P="0,0,0.05,0.1,-40,0,0,0" c="3"/><S T="11" X="616" Y="366" L="169" H="87" P="0,0,0.05,0.1,40,0,0,0" c="3"/><S T="11" X="1015" Y="366" L="169" H="87" P="0,0,0.05,0.1,40,0,0,0" c="3"/><S T="11" X="289" Y="347" L="169" H="87" P="0,0,0.05,0.1,20,0,0,0" c="3"/><S T="11" X="689" Y="347" L="169" H="87" P="0,0,0.05,0.1,20,0,0,0" c="3"/><S T="11" X="513" Y="347" L="169" H="87" P="0,0,0.05,0.1,-20,0,0,0" c="3"/><S T="11" X="912" Y="347" L="169" H="87" P="0,0,0.05,0.1,-20,0,0,0" c="3"/><S T="11" X="349" Y="357" L="169" H="87" P="0,0,0.05,0.1,-30,0,0,0" c="3"/><S T="11" X="749" Y="357" L="169" H="87" P="0,0,0.05,0.1,-30,0,0,0" c="3"/><S T="11" X="453" Y="357" L="169" H="87" P="0,0,0.05,0.1,30,0,0,0" c="3"/><S T="11" X="852" Y="357" L="169" H="87" P="0,0,0.05,0.1,30,0,0,0" c="3"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="12" X="-49" Y="0" L="99" H="3000" P="0,0,0,0.2,0,0,0,0" o="6a7495"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="135" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="195" L="10" H="118" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="194" L="10" H="120" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="8" X="54" Y="136" L="10" H="10" P="0,0,0.3,0.2,10,0,0,0" tint="76D7F7"/><S T="8" X="1147" Y="136" L="10" H="10" P="0,0,0.3,0.2,-10,0,0,0" tint="76D7F7"/><S T="8" X="156" Y="180" L="10" H="10" P="0,0,0.3,0.2,-10,0,0,0" tint="76D7F7"/><S T="8" X="1045" Y="180" L="10" H="10" P="0,0,0.3,0.2,10,0,0,0" tint="76D7F7"/><S T="8" X="320" Y="200" L="10" H="10" P="0,0,0.3,0.2,50,0,0,0" tint="76D7F7"/><S T="8" X="720" Y="200" L="10" H="10" P="0,0,0.3,0.2,50,0,0,0" tint="76D7F7"/><S T="8" X="478" Y="200" L="10" H="10" P="0,0,0.3,0.2,-50,0,0,0" tint="76D7F7"/><S T="8" X="881" Y="200" L="10" H="10" P="0,0,0.3,0.2,-50,0,0,0" tint="76D7F7"/><S T="8" X="266" Y="100" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76D7F7"/><S T="8" X="666" Y="100" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76D7F7"/><S T="8" X="532" Y="100" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76D7F7"/><S T="8" X="935" Y="100" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76D7F7"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Snowy Mountains',
    [4] = 'Hxejss#7104',
    [5] = '<C><P F="5" G="0,4" MEDATA="22,1;;;;-0;0:::1-"/><Z><S><S T="11" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="11" X="13" Y="333" L="182" H="89" P="0,0,0.05,0.1,50,0,0,0" c="3"/><S T="11" X="787" Y="334" L="182" H="89" P="0,0,0.05,0.1,-50,0,0,0" c="3"/><S T="11" X="184" Y="364" L="182" H="89" P="0,0,0.05,0.1,-40,0,0,0" c="3"/><S T="11" X="616" Y="365" L="182" H="89" P="0,0,0.05,0.1,40,0,0,0" c="3"/><S T="11" X="296" Y="346" L="182" H="89" P="0,0,0.05,0.1,20,0,0,0" c="3"/><S T="11" X="504" Y="347" L="182" H="89" P="0,0,0.05,0.1,-20,0,0,0" c="3"/><S T="11" X="343" Y="362" L="182" H="89" P="0,0,0.05,0.1,-30,0,0,0" c="3"/><S T="11" X="457" Y="363" L="182" H="89" P="0,0,0.05,0.1,30,0,0,0" c="3"/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="12" X="-52" Y="0" L="104" H="3000" P="0,0,0,0.2,0,0,0,0" o="6a7495"/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="135" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="195" L="10" H="118" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="8" X="56" Y="136" L="10" H="10" P="0,0,0.3,0.2,10,0,0,0" tint="76D7F7"/><S T="8" X="744" Y="137" L="10" H="10" P="0,0,0.3,0.2,-10,0,0,0" tint="76D7F7"/><S T="8" X="146" Y="192" L="10" H="10" P="0,0,0.3,0.2,-10,0,0,0" tint="76D7F7"/><S T="8" X="654" Y="193" L="10" H="10" P="0,0,0.3,0.2,10,0,0,0" tint="76D7F7"/><S T="8" X="322" Y="200" L="10" H="10" P="0,0,0.3,0.2,50,0,0,0" tint="76D7F7"/><S T="8" X="478" Y="201" L="10" H="10" P="0,0,0.3,0.2,-50,0,0,0" tint="76D7F7"/><S T="8" X="220" Y="100" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76D7F7"/><S T="8" X="580" Y="101" L="10" H="10" P="0,0,0.3,0.2,0,0,0,0" tint="76D7F7"/><S T="12" X="856" Y="0" L="111" H="3000" P="0,0,0,0.2,0,0,0,0" o="6a7495"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '1955402cb0a.png'
  },
  [20] = {
    [1] = '<C><P L="1600" F="4" G="0,4" MEDATA="29,1;;;;-0;0:::1-"/><Z><S><S T="10" X="787" Y="400" L="1726" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="10" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" friction="-100,-20"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="10" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" friction="-100,-20"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="10" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" friction="-100,-20"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="2" X="28" Y="324" L="10" H="153" P="0,0,0,1.2,-70,0,0,0"/><S T="9" X="26" Y="112" L="50" H="234" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-10"/><S T="2" X="1573" Y="324" L="10" H="153" P="0,0,0,1.2,70,0,0,0"/><S T="9" X="1571" Y="112" L="50" H="234" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-10"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><P X="100" Y="357" T="106" P="1,0"/><P X="598" Y="357" T="106" P="1,0"/><P X="998" Y="357" T="106" P="1,1"/><P X="1499" Y="357" T="106" P="1,1"/><P X="201" Y="4" T="107" P="0,0"/><P X="197" Y="2" T="107" P="1,0"/><P X="1086" Y="91" T="111" P="0,0"/><P X="1548" Y="351" T="115" P="0,0"/><P X="456" Y="352" T="174" P="0,0"/><P X="71" Y="167" T="176" P="0,1"/><P X="861" Y="99" T="177" P="0,1"/><P X="400" Y="251" T="159" P="0,0"/><P X="398" Y="251" T="159" P="1,0"/><P X="398" Y="300" T="159" P="1,0"/><P X="800" Y="252" T="159" P="0,0"/><P X="798" Y="251" T="159" P="1,0"/><P X="798" Y="300" T="159" P="1,0"/><P X="1200" Y="252" T="159" P="0,0"/><P X="1198" Y="251" T="159" P="1,0"/><P X="1198" Y="300" T="159" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="4" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="10" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="10" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" friction="-100,-20"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="10" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" friction="-100,-20"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="9" X="26" Y="112" L="50" H="234" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/><S T="9" X="1170" Y="112" L="50" H="234" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-5"/><S T="2" X="27" Y="324" L="10" H="153" P="0,0,0,1.2,-70,0,0,0"/><S T="2" X="1166" Y="324" L="10" H="153" P="0,0,0,1.2,70,0,0,0"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><P X="99" Y="357" T="106" P="1,0"/><P X="599" Y="357" T="106" P="1,0"/><P X="1098" Y="357" T="106" P="1,1"/><P X="599" Y="357" T="106" P="1,0"/><P X="398" Y="251" T="159" P="1,0"/><P X="398" Y="301" T="159" P="1,0"/><P X="798" Y="251" T="159" P="1,0"/><P X="798" Y="301" T="159" P="1,0"/><P X="445" Y="352" T="174" P="0,0"/><P X="479" Y="163" T="175" P="0,0"/><P X="789" Y="103" T="177" P="0,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Halloween',
    [4] = 'Ppoppohaejuseyo#2315',
    [5] = '<C><P F="4" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="10" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="10" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" friction="-100,-20"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="9" X="24" Y="112" L="48" H="234" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-10"/><S T="2" X="27" Y="324" L="10" H="153" P="0,0,0,1.2,-70,0,0,0"/><S T="9" X="776" Y="112" L="48" H="234" P="0,0,0,0,0,0,0,0" tint="000000" archAcc="-10"/><S T="2" X="768" Y="324" L="10" H="153" P="0,0,0,1.2,70,0,0,0"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><P X="98" Y="357" T="106" P="1,0"/><P X="699" Y="357" T="106" P="1,1"/><P X="398" Y="251" T="159" P="1,0"/><P X="398" Y="301" T="159" P="1,0"/><P X="-1" Y="4" T="107" P="1,0"/><P X="699" Y="1" T="109" P="1,0"/><P X="405" Y="172" T="176" P="0,0"/><P X="267" Y="351" T="118" P="0,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '195540174b1.png'
  },
  [21] = {
    [1] = '<C><P L="1600" F="4" G="0,4" MEDATA="29,1;;;;-0;0:::1-"/><Z><S><S T="17" X="799" Y="362" L="1615" H="180" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><P X="400" Y="350" T="46" P="1,0"/><P X="800" Y="350" T="46" P="1,0"/><P X="1200" Y="350" T="46" P="1,0"/><P X="678" Y="274" T="137" P="0,0"/><P X="1083" Y="275" T="136" P="0,0"/><P X="1294" Y="275" T="135" P="0,0"/><P X="45" Y="274" T="169" P="0,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="4" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="17" X="600" Y="362" L="1200" H="180" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><P X="400" Y="350" T="46" P="0,0"/><P X="800" Y="350" T="46" P="0,0"/><P X="136" Y="272" T="48" P="0,0"/><P X="643" Y="273" T="135" P="0,0"/><P X="996" Y="273" T="164" P="0,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Halloween No Jump',
    [4] = 'Ppoppohaejuseyo#2315',
    [5] = '<C><P F="4" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="17" X="400" Y="362" L="800" H="180" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><P X="400" Y="350" T="46" P="0,0"/><P X="176" Y="272" T="135" P="0,0"/><P X="723" Y="272" T="169" P="0,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '19554015d3f.png'
  },
  [22] = {
    [1] = '<C><P L="1600" F="3" G="0,4" MEDATA="31,1;;;;-0;0::0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,0,0,0,0:1-"/><Z><S><S T="12" X="805" Y="400" L="1613" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" N="" tint="FF0000"/><S T="12" X="806" Y="401" L="1613" H="101" P="0,0,0.3,0.2,0,0,0,0" o="838383" c="3" N="" tint="000000"/><S T="12" X="832" Y="457" L="1612" H="100" P="0,0,0.3,0.2,0,0,0,0" o="DBDBDB" c="3" N="" tint="807878"/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="401" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" m=""/><S T="12" X="400" Y="300" L="12" H="102" P="0,0,0,0.2,0,0,0,0" o="9A0505" c="4" N=""/><S T="12" X="800" Y="300" L="12" H="102" P="0,0,0,0.2,0,0,0,0" o="9A0505" c="4" N=""/><S T="12" X="1200" Y="300" L="12" H="102" P="0,0,0,0.2,0,0,0,0" o="9A0505" c="4" N=""/><S T="12" X="400" Y="300" L="10" H="101" P="0,0,0,0.2,0,0,0,0" o="000000" c="4" N=""/><S T="12" X="800" Y="300" L="10" H="101" P="0,0,0,0.2,0,0,0,0" o="000000" c="4" N=""/><S T="12" X="1200" Y="300" L="10" H="101" P="0,0,0,0.2,0,0,0,0" o="000000" c="4" N=""/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-6" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="4"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="4"/><S T="12" X="998" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="4"/><S T="12" X="1347" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="4"/><S T="12" X="251" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="12" X="601" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="12" X="999" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="12" X="1348" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="1" X="835" Y="-1" L="1690" H="10" P="0,0,0,0.2,0,0,0,0" c="3" tint="FF0000"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="789" Y="221" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="297" Y="49" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1301" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="1" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" m=""/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="1" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" m=""/><S T="1" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="796" Y="220" L="1594" H="265" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="13" X="599" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="99" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="998" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="1498" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="51" Y="137" L="37" P="1,0,0.3,0.2,0,0,0,0" o="9B0505"/><S T="13" X="1546" Y="137" L="37" P="1,0,0.3,0.2,180,0,0,0" o="9B0505"/><S T="13" X="53" Y="137" L="35" P="0,0,0.3,0.2,0,0,0,0" o="000000"/><S T="13" X="1544" Y="137" L="35" P="0,0,0.3,0.2,0,0,0,0" o="000000"/><S T="9" X="805" Y="375" L="1615" H="50" P="0,0,0,0,0,0,0,0" tint="810000" archAcc="-4" archMax="0"/></S><D><P X="999" Y="363" T="10" P="0,0"/><DS X="365" Y="-141"/></D><O/><L><JD c="000000,92,1," P1="36.71,57.28" P2="1551.9,54.75"/><JD c="000000,92,1," P1="41.9,45.25" P2="1556.46,47.15"/><JD c="000000,8,1," P1="1573.69,94.37" P2="1595.88,94.69"/><JD c="000000,8,1," P1="21,94.37" P2="-1.19,94.69"/><JD c="000000,8,1," P1="1575.81,94.37" P2="1598,94.69"/><JD c="000000,8,1," P1="1596.2,92.63" P2="1596.67,3.09"/><JD c="000000,8,1," P1="-1.51,92.63" P2="-1.98,3.09"/><JD c="000000,8,1," P1="1559.59,4.04" P2="1594.14,3.88"/><JD c="000000,8,1," P1="35.1,4.04" P2="0.55,3.88"/><JD c="000000,8,1," P1="1583.36,88.19" P2="1593.34,89.78"/><JD c="000000,8,1," P1="11.33,88.19" P2="1.35,89.78"/><JD c="000000,8,1," P1="1590.65,87.4" P2="1591.28,75.83"/><JD c="000000,8,1," P1="4.04,87.4" P2="3.41,75.83"/><JD c="000000,8,1," P1="1586.69,84.87" P2="1586.85,85.39"/><JD c="000000,8,1," P1="8,84.87" P2="7.84,85.39"/><JD c="000000,8,1," P1="1582.25,9.43" P2="1592.08,17.83"/><JD c="000000,8,1," P1="12.44,9.43" P2="2.61,17.83"/><JD c="000000,8,1," P1="1589.54,8" P2="1593.34,13.55"/><JD c="000000,8,1," P1="5.15,8" P2="1.35,13.55"/><JD c="000000,8,1," P1="12.81,96.86" P2="3.77,96.11"/><JD c="000000,8,1," P1="1584,96.86" P2="1593.04,96.11"/><JD c="000000,8,1," P1="1582.87,96.86" P2="1591.91,96.11"/><JD c="000000,8,1," P1="11.82,96.86" P2="2.78,96.11"/><JD c="000000,8,1," P1="1584.99,96.86" P2="1594.03,96.11"/><JD c="000000,8,1," P1="1583.85,96.86" P2="1592.89,96.11"/><JD c="000000,8,1," P1="10.84,96.86" P2="1.8,96.11"/><JD c="000000,8,1," P1="1585.97,96.86" P2="1595.01,96.11"/><JD c="000000,8,1," P1="1584.29,96.86" P2="1593.33,96.11"/><JD c="000000,8,1," P1="10.4,96.86" P2="1.36,96.11"/><JD c="000000,8,1," P1="1586.41,96.86" P2="1595.45,96.11"/><JD c="000000,8,1," P1="3.77,96.11" P2="3.27,82.54"/><JD c="000000,8,1," P1="1591.91,96.11" P2="1592.41,82.54"/><JD c="000000,8,1," P1="2.78,96.11" P2="2.28,82.54"/><JD c="000000,8,1," P1="1592.89,96.11" P2="1593.39,82.54"/><JD c="000000,8,1," P1="1.8,96.11" P2="1.3,82.54"/><JD c="000000,8,1," P1="1593.33,96.11" P2="1593.83,82.54"/><JD c="000000,8,1," P1="1.36,96.11" P2="0.86,82.54"/><JD c="000000,8,1," P1="4.27,24.25" P2="3.52,4.65"/><JD c="000000,8,1," P1="1591.41,24.25" P2="1592.16,4.65"/><JD c="000000,8,1," P1="3.28,24.25" P2="2.53,4.65"/><JD c="000000,8,1," P1="1592.39,24.25" P2="1593.14,4.65"/><JD c="000000,8,1," P1="2.3,24.25" P2="1.55,4.65"/><JD c="000000,8,1," P1="1592.83,24.25" P2="1593.58,4.65"/><JD c="000000,8,1," P1="1.86,24.25" P2="1.11,4.65"/><JD c="000000,8,1," P1="2.01,4.9" P2="41.46,4.15"/><JD c="000000,8,1," P1="1593.67,4.9" P2="1554.22,4.15"/><JD c="000000,8,1," P1="1.02,4.9" P2="40.47,4.15"/><JD c="000000,8,1," P1="1594.65,4.9" P2="1555.2,4.15"/><JD c="000000,8,1," P1="0.04,4.9" P2="39.49,4.15"/><JD c="000000,8,1," P1="1595.09,4.9" P2="1555.64,4.15"/><JD c="000000,8,1," P1="-0.4,4.9" P2="39.05,4.15"/><JD c="000000,8,1," P1="8.79,12.44" P2="19.6,8.92"/><JD c="000000,8,1," P1="1586.89,12.44" P2="1576.08,8.92"/><JD c="000000,8,1," P1="7.8,12.44" P2="18.61,8.92"/><JD c="000000,8,1," P1="1587.87,12.44" P2="1577.06,8.92"/><JD c="000000,8,1," P1="6.82,12.44" P2="17.63,8.92"/><JD c="000000,8,1," P1="1588.31,12.44" P2="1577.5,8.92"/><JD c="000000,8,1," P1="6.38,12.44" P2="17.19,8.92"/><JP M1="51" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="51" AXIS="0,1"/><JP M1="52" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="52" AXIS="0,1"/></L></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA="15,1;;;;-0;0::0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,0,0,0,0,0,0,0,0:1-"/><Z><S><S T="12" X="602" Y="400" L="1203" H="101" P="0,0,0.1,0.2,0,0,0,0" o="FF0000" c="3" N="" tint="FF0000"/><S T="12" X="602" Y="401" L="1202" H="100" P="0,0,0.1,0.2,0,0,0,0" o="000000" c="3" N="" tint="000000"/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3" tint="FF0000"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="903" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="401" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" m=""/><S T="12" X="400" Y="300" L="12" H="102" P="0,0,0,0.2,0,0,0,0" o="9A0505" c="4" N=""/><S T="12" X="800" Y="300" L="12" H="102" P="0,0,0,0.2,0,0,0,0" o="9A0505" c="4" N=""/><S T="12" X="400" Y="300" L="10" H="101" P="0,0,0,0.2,0,0,0,0" o="000000" c="4" N=""/><S T="12" X="800" Y="300" L="10" H="101" P="0,0,0,0.2,0,0,0,0" o="000000" c="4" N=""/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="4"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="4"/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="4"/><S T="12" X="251" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="12" X="601" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="12" X="951" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="0" X="297" Y="49" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="1" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" m=""/><S T="1" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="599" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="99" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="1099" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="599" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="98" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="51" Y="137" L="37" P="1,0,0.3,0.2,0,0,0,0" o="9B0505"/><S T="13" X="1147" Y="137" L="37" P="1,0,0.3,0.2,180,0,0,0" o="9B0505"/><S T="13" X="53" Y="137" L="35" P="1,0,0.3,0.2,0,0,0,0" o="000000"/><S T="13" X="1145" Y="137" L="35" P="1,0,0.3,0.2,180,0,0,0" o="000000"/><S T="9" X="602" Y="374" L="1203" H="51" P="0,0,0,0,0,0,0,0" tint="9A0505" archAcc="-5" archMax="0"/></S><D><DS X="365" Y="-141"/></D><O/><L><JD c="000000,8,1," P1="21,94.37" P2="-1.19,94.69"/><JD c="000000,8,1," P1="1169.48,94.37" P2="1191.67,94.69"/><JD c="000000,8,1," P1="1176.81,94.37" P2="1199,94.69"/><JD c="000000,8,1," P1="-1.51,92.63" P2="-1.98,3.09"/><JD c="000000,8,1," P1="1191.99,92.63" P2="1192.46,3.09"/><JD c="000000,8,1," P1="35.1,4.04" P2="0.55,3.88"/><JD c="000000,8,1," P1="1155.38,4.04" P2="1189.93,3.88"/><JD c="000000,8,1," P1="11.33,88.19" P2="1.35,89.78"/><JD c="000000,8,1," P1="1179.15,88.19" P2="1189.13,89.78"/><JD c="000000,8,1," P1="1186.48,88.19" P2="1196.46,89.78"/><JD c="000000,8,1," P1="4.04,87.4" P2="3.41,75.83"/><JD c="000000,8,1," P1="1186.44,87.4" P2="1187.07,75.83"/><JD c="000000,8,1," P1="8,84.87" P2="7.84,85.39"/><JD c="000000,8,1," P1="1182.48,84.87" P2="1182.64,85.39"/><JD c="000000,8,1," P1="12.44,9.43" P2="2.61,17.83"/><JD c="000000,8,1," P1="1178.04,9.43" P2="1187.87,17.83"/><JD c="000000,8,1," P1="5.15,8" P2="1.35,13.55"/><JD c="000000,8,1," P1="1185.33,8" P2="1189.13,13.55"/><JD c="000000,8,1," P1="12.81,96.86" P2="3.77,96.11"/><JD c="000000,8,1," P1="1177.67,96.86" P2="1186.71,96.11"/><JD c="000000,8,1," P1="1185,96.86" P2="1194.04,96.11"/><JD c="000000,8,1," P1="11.82,96.86" P2="2.78,96.11"/><JD c="000000,8,1," P1="1178.66,96.86" P2="1187.7,96.11"/><JD c="000000,8,1," P1="1185.99,96.86" P2="1195.03,96.11"/><JD c="000000,8,1," P1="10.84,96.86" P2="1.8,96.11"/><JD c="000000,8,1," P1="1179.64,96.86" P2="1188.68,96.11"/><JD c="000000,8,1," P1="1186.97,96.86" P2="1196.01,96.11"/><JD c="000000,8,1," P1="10.4,96.86" P2="1.36,96.11"/><JD c="000000,8,1," P1="1180.08,96.86" P2="1189.12,96.11"/><JD c="000000,8,1," P1="1187.41,96.86" P2="1196.45,96.11"/><JD c="000000,8,1," P1="3.77,96.11" P2="3.27,82.54"/><JD c="000000,8,1," P1="1186.71,96.11" P2="1187.21,82.54"/><JD c="000000,8,1," P1="2.78,96.11" P2="2.28,82.54"/><JD c="000000,8,1," P1="1187.7,96.11" P2="1188.2,82.54"/><JD c="000000,8,1," P1="1.8,96.11" P2="1.3,82.54"/><JD c="000000,8,1," P1="1188.68,96.11" P2="1189.18,82.54"/><JD c="000000,8,1," P1="1.36,96.11" P2="0.86,82.54"/><JD c="000000,8,1," P1="1189.12,96.11" P2="1189.62,82.54"/><JD c="000000,8,1," P1="4.27,24.25" P2="3.52,4.65"/><JD c="000000,8,1," P1="1186.21,24.25" P2="1186.96,4.65"/><JD c="000000,8,1," P1="3.28,24.25" P2="2.53,4.65"/><JD c="000000,8,1," P1="1187.2,24.25" P2="1187.95,4.65"/><JD c="000000,8,1," P1="2.3,24.25" P2="1.55,4.65"/><JD c="000000,8,1," P1="1188.18,24.25" P2="1188.93,4.65"/><JD c="000000,8,1," P1="1.86,24.25" P2="1.11,4.65"/><JD c="000000,8,1," P1="1188.62,24.25" P2="1189.37,4.65"/><JD c="000000,8,1," P1="2.01,4.9" P2="41.46,4.15"/><JD c="000000,8,1," P1="1188.47,4.9" P2="1149.02,4.15"/><JD c="000000,8,1," P1="1.02,4.9" P2="40.47,4.15"/><JD c="000000,8,1," P1="1189.46,4.9" P2="1150.01,4.15"/><JD c="000000,8,1," P1="0.04,4.9" P2="39.49,4.15"/><JD c="000000,8,1," P1="1190.44,4.9" P2="1150.99,4.15"/><JD c="000000,8,1," P1="-0.4,4.9" P2="39.05,4.15"/><JD c="000000,8,1," P1="1190.88,4.9" P2="1151.43,4.15"/><JD c="000000,8,1," P1="8.79,12.44" P2="19.6,8.92"/><JD c="000000,8,1," P1="1181.69,12.44" P2="1170.88,8.92"/><JD c="000000,8,1," P1="7.8,12.44" P2="18.61,8.92"/><JD c="000000,8,1," P1="1182.68,12.44" P2="1171.87,8.92"/><JD c="000000,8,1," P1="6.82,12.44" P2="17.63,8.92"/><JD c="000000,8,1," P1="1183.66,12.44" P2="1172.85,8.92"/><JD c="000000,8,1," P1="6.38,12.44" P2="17.19,8.92"/><JD c="000000,8,1," P1="1184.1,12.44" P2="1173.29,8.92"/><JD c="000000,250,1," P1="1078.48,187.97" P2="116.46,191.77"/><JD c="000000,250,1," P1="124.05,274.05" P2="1074.68,319.62"/><JD c="000000,250,1," P1="127.85,116.85" P2="1078.48,119.39"/><JD c="000000,30,1," P1="15.19,344.94" P2="12.66,12.03"/><JD c="000000,30,1," P1="27.85,36.08" P2="67.09,15.82"/><JD c="000000,30,1," P1="13.92,10.76" P2="163.29,9.49"/><JD c="000000,30,1," P1="36.33,14.07" P2="9.98,9.28"/><JD c="000000,30,1," P1="1182,350.25" P2="1184,14.75"/><JD c="000000,30,1," P1="1161.5,15.25" P2="1076,12.25"/><JD c="000000,30,1," P1="1168.5,32.25" P2="1047.5,25.75"/><JP M1="52" AXIS="-1,0" MV="Infinity,8.333333333333334"/><JP M1="52" AXIS="0,1"/><JP M1="53" AXIS="-1,0" MV="Infinity,8.333333333333334"/><JP M1="53" AXIS="0,1"/><JP M1="54" AXIS="-1,0" MV="Infinity,8.333333333333334"/><JP M1="54" AXIS="0,1"/><JP M1="55" AXIS="-1,0" MV="Infinity,8.333333333333334"/><JP M1="55" AXIS="0,1"/></L></Z></C>',
    [3] = 'Eclipse',
    [4] = 'Lacoste#8972',
    [5] = '<C><P F="0" G="0,4" MEDATA="16,1;;;;-0;0::0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,0,0:1-"/><Z><S><S T="12" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" o="FF0000" c="3" N="" tint="FF0000"/><S T="12" X="400" Y="401" L="796" H="100" P="0,0,0.1,0.2,0,0,0,0" o="000000" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="400" Y="-12" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N="" tint="FF0000"/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="51" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="51" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="4"/><S T="12" X="51" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="4"/><S T="12" X="751" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="000000" c="4"/><S T="9" X="400" Y="374" L="801" H="49" P="0,0,0,0,0,0,0,0" tint="E60101" archAcc="-5"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="1" X="401" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" m=""/><S T="12" X="400" Y="300" L="12" H="102" P="0,0,0,0.2,0,0,0,0" o="9A0505" c="4" N=""/><S T="12" X="400" Y="300" L="10" H="101" P="0,0,0,0.2,0,0,0,0" o="000000" c="4" N=""/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="99" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="699" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="98" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="698" Y="354" L="10" P="0,0,0.3,0.2,0,0,0,0" o="9B0505" c="4"/><S T="13" X="401" Y="70" L="62" P="1,0,0.3,0.2,-90,0,0,0" o="324650" c="2" N="" m=""/></S><D><DS X="360" Y="-151"/></D><O/><L><JD c="000000,250,1," P1="125.32,189.24" P2="674.68,176.58"/><JD c="000000,250,1," P1="127.85,132.28" P2="681.01,123.42"/><JD c="000000,250,1," P1="673.42,281.17" P2="122.78,283.7"/><JD c="000000,23,1," P1="8.86,350" P2="6.33,5.7"/><JD c="000000,23,1," P1="6.33,5.7" P2="788.61,4.43"/><JD c="000000,23,1," P1="789.87,5.7" P2="788.61,348.73"/><JD c="A80000,114,1,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="660000,119,0.8,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="660000,124,0.5,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="660000,119,0.2,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="B02525,109,1,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="D43737,104,1,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="AD2828,99,1,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="812626,94,0.9,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="5C1414,89,0.9,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="501313,84,0.9,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="2A0D0D,79,0.9,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="330000,114,0.4,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JD c="000000,74,0.8,1" M1="4" M2="4" P1="401,69" P2="401,70"/><JP M1="46" AXIS="-1,0" MV="Infinity,5"/><JP M1="46" AXIS="0,1"/></L></Z></C>',
    [6] = '195540145dc.png'
  },
  [23] = {
    [1] = '<C><P L="1600" F="3" G="0,4" MEDATA="14,1;;;;-0;0:::1-"/><Z><S><S T="8" X="776" Y="400" L="1675" H="108" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="101" Y="353" L="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" m=""/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="791" Y="-800" L="1768" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="451" Y="-60" L="10" H="393" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="9" X="400" Y="-63" L="91" H="392" P="0,0,0,0,0,0,0,0" tint="FFFFFF" archAcc="0.5" archMax="0.7"/><S T="1" X="750" Y="-60" L="10" H="393" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="1" X="851" Y="-60" L="10" H="393" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="9" X="800" Y="-63" L="91" H="392" P="0,0,0,0,0,0,0,0" tint="FFFFFF" archAcc="0.5" archMax="0.7"/><S T="1" X="1250" Y="-60" L="10" H="393" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="9" X="1200" Y="-63" L="91" H="392" P="0,0,0,0,0,0,0,0" tint="FFFFFF" archAcc="0.5" archMax="0.7"/><S T="1" X="1150" Y="-60" L="10" H="393" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="13" X="400" Y="-870" L="140" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" m=""/><S T="13" X="800" Y="-870" L="140" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" m=""/><S T="13" X="1200" Y="-870" L="140" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" m=""/><S T="13" X="600" Y="353" L="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" m=""/><S T="13" X="1000" Y="353" L="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" m=""/><S T="13" X="1501" Y="353" L="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" m=""/><S T="1" X="350" Y="-60" L="10" H="393" P="0,0,0,0.2,0,0,0,0" c="2"/></S><D><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="8" X="583" Y="400" L="1235" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="357" L="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" m=""/><S T="13" X="600" Y="357" L="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" m=""/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="357" L="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="1" X="350" Y="-60" L="10" H="393" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="9" X="400" Y="-63" L="91" H="392" P="0,0,0,0,0,0,0,0" tint="FFFFFF" archAcc="0.5" archMax="0.7"/><S T="1" X="451" Y="-60" L="10" H="393" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="12" X="716" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="807" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="763" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="760" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="807" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="1" X="750" Y="-60" L="10" H="393" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="9" X="800" Y="-63" L="91" H="392" P="0,0,0,0,0,0,0,0" tint="FFFFFF" archAcc="0.5" archMax="0.7"/><S T="1" X="851" Y="-60" L="10" H="393" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="13" X="400" Y="-870" L="140" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" m=""/><S T="13" X="800" Y="-870" L="140" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" m=""/></S><D><DS X="374" Y="-127"/></D><O/><L/></Z></C>',
    [3] = 'Tube cannon',
    [4] = 'Ppoppohaejuseyo#2315',
    [5] = '<C><P F="3" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="8" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="357" L="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" m=""/><S T="13" X="700" Y="357" L="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" m=""/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="1" X="451" Y="-60" L="10" H="393" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="9" X="400" Y="-63" L="91" H="392" P="0,0,0,0,0,0,0,0" tint="FFFFFF" archAcc="0.5" archMax="0.7"/><S T="1" X="350" Y="-60" L="10" H="393" P="0,0,0,0.2,0,0,0,0" c="2"/><S T="13" X="400" Y="-870" L="140" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" m=""/></S><D><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '1955403b578.png'
  },
  [24] = {
    [1] = '<C><P L="1600" F="3" G="0,4" C="" MEDATA="17,1;;;;-0;0:::1-"/><Z><S><S T="1" X="400" Y="440" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="440" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="1200" Y="440" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="7" X="800" Y="400" L="1600" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1605" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="800" Y="-5" L="1600" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="800" Y="93" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="800" Y="500" L="3000" H="200" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" C="" MEDATA="20,1;;;;-0;0:::1-"/><Z><S><S T="1" X="400" Y="440" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="440" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1205" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-5" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="93" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="600" Y="500" L="3000" H="200" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Very small ice barrier and mice collision',
    [4] = 'Kralizmox#0000',
    [5] = '<C><P F="0" G="0,4" C="" MEDATA="13,1;;;;-0;0:::1-"/><Z><S><S T="1" X="400" Y="440" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-5" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="93" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="500" L="3000" H="200" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '1955403fbce.png'
  },
  [25] = {
    [1] = '<C><P L="1600" F="3" G="0,4" MEDATA="18,1;;;;-0;0::0,0,0,0,0,0,0,0,0,0:1-"/><Z><S><S T="7" X="800" Y="400" L="1600" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="400" Y="350" L="20" H="200" P="1,0,9999,0.2,90,0,0,0" o="89A7F5"/><S T="12" X="10" Y="275" L="20" H="350" P="1,0,9999,0.2,90,0,0,0" o="89A7F5"/><S T="12" X="1590" Y="275" L="20" H="350" P="1,0,9999,0.2,90,0,0,0" o="89A7F5"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1605" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="800" Y="0" L="1600" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="800" Y="95" L="1600" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="175" L="20" H="150" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="1" X="800" Y="-800" L="1600" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="800" Y="350" L="20" H="200" P="1,0,9999,0.2,90,0,0,0" o="89A7F5"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="175" L="20" H="150" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="1200" Y="350" L="20" H="200" P="1,0,9999,0.2,90,0,0,0" o="89A7F5"/><S T="0" X="1200" Y="175" L="20" H="150" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="400" Y="300" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="10" Y="230" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="800" Y="300" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="1200" Y="300" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="1590" Y="230" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="400" Y="305" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5" c="4"/><S T="12" X="10" Y="235" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5" c="4"/><S T="12" X="800" Y="305" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5" c="4"/><S T="12" X="1200" Y="305" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5" c="4"/><S T="12" X="1590" Y="235" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5" c="4"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="365" Y="-140"/></D><O/><L><JP M1="1" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="1" AXIS="0,1"/><JP M1="2" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="2" AXIS="0,1"/><JP M1="3" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="3" AXIS="0,1"/><JP M1="25" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="25" AXIS="0,1"/><JP M1="29" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="29" AXIS="0,1"/></L></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA="17,1;;;;-0;0::0,0,0,0,0,0,0,0:1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="400" Y="350" L="20" H="200" P="1,0,9999,0.2,90,0,0,0" o="89A7F5"/><S T="12" X="10" Y="275" L="20" H="350" P="1,0,9999,0.2,90,0,0,0" o="89A7F5"/><S T="12" X="1190" Y="275" L="20" H="350" P="1,0,9999,0.2,90,0,0,0" o="89A7F5"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1205" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="601" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="175" L="20" H="150" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="800" Y="350" L="20" H="200" P="1,0,9999,0.2,90,0,0,0" o="89A7F5"/><S T="0" X="800" Y="175" L="20" H="150" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="400" Y="300" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="10" Y="230" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="800" Y="300" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="1190" Y="230" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="400" Y="305" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5" c="4"/><S T="12" X="10" Y="235" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5" c="4"/><S T="12" X="800" Y="305" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5" c="4"/><S T="12" X="1190" Y="235" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5" c="4"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><DS X="365" Y="-140"/></D><O/><L><JP M1="1" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="1" AXIS="0,1"/><JP M1="2" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="2" AXIS="0,1"/><JP M1="3" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="3" AXIS="0,1"/><JP M1="24" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="24" AXIS="0,1"/></L></Z></C>',
    [3] = 'Ice barrier booster',
    [4] = 'Kralizmox#0000',
    [5] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0::0,0,0,0,0,0:1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="400" Y="350" L="20" H="200" P="1,0,9999,0.2,270,0,0,0" o="89A7F5"/><S T="12" X="10" Y="270" L="20" H="340" P="1,0,9999,0.2,270,0,0,0" o="89A7F5"/><S T="12" X="790" Y="270" L="20" H="340" P="1,0,9999,0.2,270,0,0,0" o="89A7F5"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="400" Y="175" L="20" H="150" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="12" X="400" Y="300" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="10" Y="230" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="790" Y="230" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="FFFFFF" c="4"/><S T="12" X="400" Y="305" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5" c="4"/><S T="12" X="10" Y="235" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5" c="4"/><S T="12" X="790" Y="235" L="15" H="15" P="0,0,0.3,0.2,45,0,0,0" o="89A7F5" c="4"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-150"/></D><O/><L><JP M1="1" A="-3.141592653589793" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="1" A="-3.141592653589793" AXIS="0,1"/><JP M1="2" A="-3.141592653589793" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="2" A="-3.141592653589793" AXIS="0,1"/><JP M1="3" A="-3.141592653589793" AXIS="-1,0" MV="Infinity,6.666666666666667"/><JP M1="3" A="-3.141592653589793" AXIS="0,1"/></L></Z></C>',
    [6] = '1955401bb06.png'
  },
  [26] = {
    [1] = '<C><P L="1600" G="0,4" MEDATA="11,1;;;0,2:1,2:2,2:3,2:4,2:5,2:6,2:7,2:8,2:9,2:10,2:11,2:12,2:13,2:14,2:15,2;-0;0::0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15:1-"/><Z><S><S T="4" X="800" Y="550" L="10" H="10" P="1,-1,20,0.2,0,1,0,0" c="4" m=""/><S T="7" X="800" Y="400" L="1600" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="800" Y="200" L="1600" H="400" P="0,0,0.3,0.2,0,0,0,0" o="808080" c="4"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="0" X="800" Y="95" L="1600" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="225" L="1600" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="800" Y="-800" L="1600" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="800" Y="0" L="1600" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="12" X="200" Y="355" L="40" H="20" P="1,999999,0.3,0,0,1,9999,0" o="FFFFFF" c="3"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="600" Y="355" L="40" H="20" P="1,999999,0.3,0,0,1,9999,0" o="FFFFFF" c="3"/><S T="12" X="1000" Y="355" L="40" H="20" P="1,999999,0.3,0,0,1,9999,0" o="FFFFFF" c="3"/><S T="12" X="1400" Y="355" L="40" H="20" P="1,999999,0.3,0,0,1,9999,0" o="FFFFFF" c="3"/><S T="12" X="1605" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="200" Y="225" L="400" H="250" P="1,1,0.3,0.2,0,1,0,0" o="000000" c="4" N=""/><S T="12" X="600" Y="225" L="400" H="250" P="1,1,0.3,0.2,0,1,0,0" o="000000" c="4" N=""/><S T="12" X="1000" Y="225" L="400" H="250" P="1,1,0.3,0.2,0,1,0,0" o="000000" c="4" N=""/><S T="12" X="1400" Y="225" L="400" H="250" P="1,1,0.3,0.2,0,1,0,0" o="000000" c="4" N=""/><S T="12" X="-50" Y="185" L="10" H="10" P="1,999999,0.3,0,0,1,0,0" o="324650" c="2" m=""/><S T="12" X="-170" Y="185" L="10" H="10" P="1,999999,0.3,0,0,1,0,0" o="324650" c="2" m=""/><S T="12" X="-110" Y="185" L="10" H="10" P="1,999999,0.3,0,0,1,0,0" o="324650" c="2" m=""/><S T="12" X="-230" Y="185" L="10" H="10" P="1,999999,0.3,0,0,1,0,0" o="324650" c="2" m=""/><S T="12" X="-50" Y="-500" L="50" H="10" P="0,0,0.3,0,0,0,0,0" o="324650" c="2" m=""/><S T="12" X="-170" Y="-500" L="50" H="10" P="0,0,0.3,0,0,0,0,0" o="324650" c="2" m=""/><S T="12" X="-110" Y="-500" L="50" H="10" P="0,0,0.3,0,0,0,0,0" o="324650" c="2" m=""/><S T="12" X="-230" Y="-500" L="50" H="10" P="0,0,0.3,0,0,0,0,0" o="324650" c="2" m=""/><S T="13" X="200" Y="160" L="20" P="0,0,0.3,0.2,0,0,0,0" o="FFF1A7" c="4"/><S T="13" X="1000" Y="160" L="20" P="0,0,0.3,0.2,0,0,0,0" o="FFF1A7" c="4"/><S T="13" X="600" Y="160" L="20" P="0,0,0.3,0.2,0,0,0,0" o="FFF1A7" c="4"/><S T="13" X="1400" Y="160" L="20" P="0,0,0.3,0.2,0,0,0,0" o="FFF1A7" c="4"/><S T="12" X="200" Y="185" L="40" H="10" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="1000" Y="185" L="40" H="10" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="600" Y="185" L="40" H="10" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="1400" Y="185" L="40" H="10" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="200" Y="205" L="30" H="10" P="0,0,0.3,0.2,90,0,0,0" o="654321" c="4"/><S T="12" X="1000" Y="205" L="30" H="10" P="0,0,0.3,0.2,90,0,0,0" o="654321" c="4"/><S T="12" X="600" Y="205" L="30" H="10" P="0,0,0.3,0.2,90,0,0,0" o="654321" c="4"/><S T="12" X="1400" Y="205" L="30" H="10" P="0,0,0.3,0.2,90,0,0,0" o="654321" c="4"/></S><D><DS X="365" Y="-140"/></D><O/><L><JR M1="28"/><JR M1="28" M2="34"/><JR M1="34" M2="38"/><JP M1="38" AXIS="0,1" MV="Infinity,12"/><JR M1="30"/><JR M1="30" M2="35"/><JR M1="35" M2="40"/><JP M1="40" AXIS="0,1" MV="Infinity,12"/><JR M1="31"/><JR M1="31" M2="36"/><JR M1="36" M2="39"/><JP M1="39" AXIS="0,1" MV="Infinity,12"/><JR M1="32"/><JR M1="32" M2="37"/><JR M1="37" M2="41"/><JP M1="41" AXIS="0,1" MV="Infinity,12"/></L></Z></C>',
    [2] = '<C><P L="1200" G="0,4" MEDATA="11,1;;;0,2:1,2:2,2:3,2:4,2:5,2:6,2:7,2:8,2:9,2:10,2:11,2;-0;0::0,1,2,3,4,5,6,7,8,9,10,11:1-"/><Z><S><S T="4" X="600" Y="550" L="10" H="10" P="1,-1,20,0.2,0,0,0,0" c="4"/><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="12" X="600" Y="200" L="1200" H="400" P="0,0,0.3,0.2,0,0,0,0" o="808080" c="4"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="600" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="12" X="200" Y="355" L="40" H="20" P="1,999999,0.3,0,0,1,9999,0" o="FFFFFF" c="3"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="600" Y="355" L="40" H="20" P="1,999999,0.3,0,0,1,9999,0" o="FFFFFF" c="3"/><S T="12" X="1000" Y="355" L="40" H="20" P="1,999999,0.3,0,0,1,9999,0" o="FFFFFF" c="3"/><S T="12" X="1205" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="200" Y="225" L="400" H="255" P="1,1,0.3,0.2,0,1,0,0" o="000000" c="4" N=""/><S T="12" X="600" Y="225" L="400" H="255" P="1,1,0.3,0.2,0,1,0,0" o="000000" c="4" N=""/><S T="12" X="1000" Y="225" L="400" H="255" P="1,1,0.3,0.2,0,1,0,0" o="000000" c="4" N=""/><S T="12" X="-50" Y="185" L="10" H="10" P="1,999999,0.3,0,0,1,0,0" o="324650" c="2" m=""/><S T="12" X="-110" Y="185" L="10" H="10" P="1,999999,0.3,0,0,1,0,0" o="324650" c="2" m=""/><S T="12" X="-170" Y="185" L="10" H="10" P="1,999999,0.3,0,0,1,0,0" o="324650" c="2" m=""/><S T="12" X="-50" Y="-500" L="50" H="10" P="0,0,0.3,0,0,0,0,0" o="324650" c="2" m=""/><S T="12" X="-110" Y="-500" L="50" H="10" P="0,0,0.3,0,0,0,0,0" o="324650" c="2" m=""/><S T="12" X="-170" Y="-500" L="50" H="10" P="0,0,0.3,0,0,0,0,0" o="324650" c="2" m=""/><S T="13" X="200" Y="160" L="20" P="0,0,0.3,0.2,0,0,0,0" o="FFF1A7" c="4"/><S T="13" X="1000" Y="160" L="20" P="0,0,0.3,0.2,0,0,0,0" o="FFF1A7" c="4"/><S T="13" X="600" Y="160" L="20" P="0,0,0.3,0.2,0,0,0,0" o="FFF1A7" c="4"/><S T="12" X="200" Y="185" L="40" H="10" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="1000" Y="185" L="40" H="10" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="600" Y="185" L="40" H="10" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="200" Y="205" L="10" H="30" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="1000" Y="205" L="10" H="30" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="600" Y="205" L="10" H="30" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/></S><D><DS X="365" Y="-140"/></D><O/><L><JR M1="24"/><JR M1="24" M2="29"/><JR M1="29" M2="32"/><JP M1="32" AXIS="0,1" MV="Infinity,10"/><JR M1="26"/><JR M1="26" M2="30"/><JR M1="30" M2="33"/><JP M1="33" AXIS="0,1" MV="Infinity,10"/><JR M1="27"/><JR M1="27" M2="31"/><JR M1="31" M2="34"/><JP M1="34" AXIS="0,1" MV="Infinity,10"/></L></Z></C>',
    [3] = 'Lightness and darkness',
    [4] = 'Kralizmox#0000',
    [5] = '<C><P G="0,4" MEDATA="13,1;;;;-0;0::0,1,2,3,4,5,6,7:1-"/><Z><S><S T="4" X="400" Y="550" L="10" H="10" P="1,-1,20,0.2,0,0,0,0" m=""/><S T="12" X="400" Y="200" L="800" H="400" P="0,0,0.3,0.2,0,0,0,0" o="808080" c="4"/><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="12" X="200" Y="355" L="40" H="20" P="1,999999,0.3,0,0,1,9999,0" o="ffffff" c="3"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="600" Y="355" L="40" H="20" P="1,999999,0.3,0,0,1,9999,0" o="FFFFFF" c="3"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="200" Y="225" L="400" H="255" P="1,1,0.3,0.2,0,1,0,0" o="000000" c="4" N=""/><S T="12" X="600" Y="225" L="400" H="255" P="1,1,0.3,0.2,0,1,0,0" o="000000" c="4" N=""/><S T="12" X="-140" Y="185" L="10" H="10" P="1,999999,0.3,0,0,1,0,0" o="324650" m=""/><S T="12" X="930" Y="185" L="10" H="10" P="1,999999,0.3,0,0,1,0,0" o="324650" m=""/><S T="12" X="930" Y="-500" L="50" H="10" P="0,0,0.3,0,0,0,0,0" o="324650" m=""/><S T="12" X="-140" Y="-500" L="50" H="10" P="0,0,0.3,0,0,0,0,0" o="324650" m=""/><S T="13" X="200" Y="160" L="20" P="0,0,0.3,0.2,0,0,0,0" o="fff1a7" c="4"/><S T="12" X="200" Y="185" L="40" H="10" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="200" Y="205" L="10" H="30" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="600" Y="185" L="40" H="10" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="12" X="600" Y="205" L="10" H="30" P="0,0,0.3,0.2,0,0,0,0" o="654321" c="4"/><S T="13" X="600" Y="160" L="20" P="0,0,0.3,0.2,0,0,0,0" o="fff1a7" c="4"/></S><D><DS X="350" Y="-150"/></D><O/><L><JR M1="21"/><JR M1="21" M2="25"/><JR M1="25" M2="27"/><JP M1="27" AXIS="0,1" MV="Infinity,10"/><JR M1="23"/><JR M1="23" M2="26"/><JR M1="26" M2="28"/><JP M1="28" AXIS="0,1" MV="Infinity,10"/></L></Z></C>',
    [6] = '19554026d42.png'
  },
  [27] = {
    [1] = '<C><P L="1600" F="3" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="200" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="600" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="1000" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="1400" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><P X="185" Y="110" T="131" C="555D77" P="0,0"/><P X="215" Y="110" T="131" C="555D77" P="1,0"/><P X="400" Y="50" T="131" C="555D77" P="0,0"/><P X="585" Y="110" T="131" C="555D77" P="0,0"/><P X="615" Y="110" T="131" C="555D77" P="0,0"/><P X="800" Y="50" T="131" C="555D77" P="0,0"/><P X="985" Y="110" T="131" C="555D77" P="0,0"/><P X="1015" Y="110" T="131" C="555D77" P="0,0"/><P X="1200" Y="50" T="131" C="555D77" P="0,0"/><P X="1385" Y="110" T="131" C="555D77" P="0,0"/><P X="1415" Y="110" T="131" C="555D77" P="0,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="200" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="600" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="1000" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><P X="185" Y="110" T="131" C="555D77" P="0,0"/><P X="215" Y="110" T="131" C="555D77" P="0,0"/><P X="585" Y="110" T="131" C="555D77" P="0,0"/><P X="615" Y="110" T="131" C="555D77" P="0,0"/><P X="985" Y="110" T="131" C="555D77" P="0,0"/><P X="1015" Y="110" T="131" C="555D77" P="0,0"/><P X="800" Y="50" T="131" C="555D77" P="0,0"/><P X="400" Y="50" T="131" C="555D77" P="0,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Volley 2.0',
    [4] = 'Refletz#6472',
    [5] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="13" X="200" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/><S T="13" X="600" Y="180" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650"/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><P X="185" Y="110" T="131" C="555D77" P="0,0"/><P X="215" Y="110" T="131" C="555D77" P="0,0"/><P X="400" Y="50" T="131" C="555D77" P="0,0"/><P X="585" Y="110" T="131" C="555D77" P="0,0"/><P X="615" Y="110" T="131" C="555D77" P="0,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '1955404133e.png'
  },
  [28] = {
    [1] = '<C><P L="1600" G="0,4" MEDATA=";36,1;;;-0;0:::1-" F="3" /><Z><S><S Y="400" T="18" P="0,0,0.1,0.2,0,0,0,0" c="3" L="1610" X="805" H="100" N="" /><S Y="430" T="9" P="0,0,0,0,0,0,0,0" L="1200" X="600" H="10" /><S Y="350" T="1" P="0,0,0,0.2,0,0,0,0" L="10" X="400" H="200" /><S Y="455" T="12" P="0,0,0.3,0.2,0,0,0,0" L="800" o="6a7495" X="400" H="10" /><S Y="0" T="12" P="0,0,0.2,0.2,0,0,0,0" L="10" o="6a7495" X="-5" H="3000" /><S Y="0" T="12" P="0,0,0.2,0.2,0,0,0,0" L="10" o="6a7495" X="1600" H="3000" /><S Y="359" T="13" P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="100" c="3" /><S Y="359" T="13" P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="600" c="3" /><S Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="250" H="105" /><S Y="0" T="1" P="0,0,0,0.2,0,0,0,0" c="3" L="1620" X="790" H="10" /><S Y="95" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" c="3" L="1620" X="790" H="10" /><S Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" X="305" H="100" /><S Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" X="1300" H="100" /><S Y="225" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" c="3" L="1620" X="790" H="10" /><S Y="239" T="0" m="" P="0,0,0,0,0,0,0,0" c="3" L="10" X="400" H="30" /><S Y="791" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" X="400" H="10" /><S Y="-129" T="12" P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="316" H="200" /><S Y="-133" T="12" P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="407" H="200" /><S Y="-92" T="12" P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="363" H="100" /><S Y="-206" T="12" P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="360" H="100" /><S Y="460" T="12" P="0,0,0.3,0.2,0,0,0,0" c="4" L="3000" o="6a7495" X="400" H="120" N="" /><S Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="1350" H="105" /><S Y="-800" T="1" P="0,0,0,0.2,0,0,0,0" L="1200" X="600" H="10" /><S Y="350" T="1" P="0,0,0,0.2,0,0,0,0" L="10" X="800" H="200" /><S Y="790" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" X="800" H="10" /><S Y="239" T="0" m="" P="0,0,0,0,0,0,0,0" c="3" L="10" X="800" H="30" /><S Y="359" T="13" P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="1000" c="3" /><S Y="350" T="1" P="0,0,0,0.2,0,0,0,0" L="10" X="1200" H="200" /><S Y="239" T="0" m="" P="0,0,0,0,0,0,0,0" c="3" L="10" X="1200" H="30" /><S Y="790" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" X="1200" H="10" /><S Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="600" H="105" /><S Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="1000" H="105" /><S Y="359" T="13" P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="1500" c="3" /><S Y="134" T="2" P="0,0,0,1.2,-110,0,0,0" L="10" X="383" H="41" /><S Y="133" T="2" P="0,0,0,1.2,-70,0,0,0" L="10" X="420" H="41" /><S Y="146" T="2" P="0,0,0,1.2,-50,0,0,0" L="10" X="447" H="22" /><S Y="146" T="2" P="0,0,0,1.2,50,0,0,0" L="10" X="359" H="22" /><S Y="133" T="2" P="0,0,0,1.2,-110,0,0,0" L="10" X="784" H="41" /><S Y="133" T="2" P="0,0,0,1.2,-70,0,0,0" L="10" X="821" H="41" /><S Y="146" T="2" P="0,0,0,1.2,-50,0,0,0" L="10" X="848" H="22" /><S Y="145" T="2" P="0,0,0,1.2,50,0,0,0" L="10" X="760" H="22" /><S Y="133" T="2" P="0,0,0,1.2,-110,0,0,0" L="10" X="1183" H="41" /><S Y="133" T="2" P="0,0,0,1.2,-70,0,0,0" L="10" X="1220" H="41" /><S Y="146" T="2" P="0,0,0,1.2,-50,0,0,0" L="10" X="1247" H="22" /><S Y="145" T="2" P="0,0,0,1.2,50,0,0,0" L="10" X="1159" H="22" /></S><D><P Y="363" T="10" X="599" P="1,0" /><P Y="363" T="10" X="99" P="1,0" /><P Y="363" T="10" X="999" P="1,0" /><P Y="363" T="10" X="1499" P="1,0" /><P Y="502" T="148" X="58" P="0,0" /><P Y="499" T="148" X="142" P="0,0" /><P Y="496" T="148" X="221" P="0,0" /><P Y="495" T="148" X="293" P="0,0" /><P Y="496" T="148" X="355" P="0,0" /><P Y="496" T="148" X="443" P="0,0" /><P Y="496" T="148" X="548" P="0,0" /><P Y="500" T="148" X="656" P="0,0" /><P Y="494" T="148" X="761" P="0,0" /><P Y="493" T="148" X="873" P="0,0" /><P Y="489" T="148" X="971" P="0,0" /><P Y="487" T="148" X="1074" P="0,0" /><P Y="484" T="148" X="1162" P="0,0" /><P Y="482" T="148" X="1269" P="0,0" /><P Y="490" T="148" X="1364" P="0,0" /><P Y="486" T="148" X="1453" P="0,0" /><P Y="462" T="148" X="1512" P="0,0" /><P Y="484" T="148" X="1571" P="0,0" /><P Y="485" T="148" X="717" P="0,0" /><P Y="477" T="148" X="629" P="0,0" /><P Y="471" T="148" X="502" P="0,0" /><P Y="476" T="148" X="333" P="0,0" /><P Y="481" T="148" X="219" P="0,0" /><P Y="459" T="148" X="90" P="0,0" /><P Y="478" T="148" X="15" P="0,0" /><P Y="459" T="148" X="575" P="0,0" /><P Y="462" T="148" X="815" P="0,0" /><P Y="466" T="148" X="1037" P="0,0" /><P Y="468" T="148" X="1183" P="0,0" /><P Y="476" T="148" X="1352" P="0,0" /><P Y="247" T="66" X="400" P="1,0" /><P Y="247" T="66" X="800" P="1,0" /><P Y="247" T="66" X="1200" P="1,0" /><P Y="251" T="65" P="1,0" X="400" C="FFFFFF,F48DCA" /><P Y="251" T="65" P="1,0" X="800" C="FFFFFF,F48DCA" /><P Y="251" T="65" P="1,0" X="1200" C="FFFFFF,F48DCA" /><DS Y="-141" X="365" /></D><O /><L /></Z></C>',
    [2] = '<C><P L="1200" G="0,4" MEDATA=";33,1;;;-0;0:::1-" F="3" /><Z><S><S Y="400" T="18" P="0,0,0.1,0.2,0,0,0,0" c="3" L="1200" X="600" H="100" N="" /><S Y="430" T="9" P="0,0,0,0,0,0,0,0" L="1200" X="600" H="10" /><S Y="350" T="1" P="0,0,0,0.2,0,0,0,0" L="10" X="400" H="200" /><S Y="455" T="12" P="0,0,0.3,0.2,0,0,0,0" L="800" o="6a7495" X="400" H="10" /><S Y="0" T="12" P="0,0,0.2,0.2,0,0,0,0" L="10" o="6a7495" X="-5" H="3000" /><S Y="0" T="12" P="0,0,0.2,0.2,0,0,0,0" L="10" o="6a7495" X="1200" H="3000" /><S Y="359" T="13" P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="100" c="3" /><S Y="359" T="13" P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="600" c="3" /><S Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="250" H="105" /><S Y="0" T="1" P="0,0,0,0.2,0,0,0,0" c="3" L="1200" X="600" H="10" /><S Y="95" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" c="3" L="1200" X="600" H="10" /><S Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" X="305" H="100" /><S Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" X="900" H="100" /><S Y="225" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" c="3" L="1200" X="601" H="10" /><S Y="239" T="0" m="" P="0,0,0,0,0,0,0,0" c="3" L="10" X="400" H="30" /><S Y="791" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" X="400" H="10" /><S Y="-129" T="12" P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="316" H="200" /><S Y="-133" T="12" P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="407" H="200" /><S Y="-92" T="12" P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="363" H="100" /><S Y="-206" T="12" P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="360" H="100" /><S Y="460" T="12" P="0,0,0.3,0.2,0,0,0,0" c="4" L="3000" o="6a7495" X="400" H="120" N="" /><S Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="950" H="105" /><S Y="-800" T="1" P="0,0,0,0.2,0,0,0,0" L="1200" X="600" H="10" /><S Y="350" T="1" P="0,0,0,0.2,0,0,0,0" L="10" X="800" H="200" /><S Y="239" T="0" m="" P="0,0,0,0,0,0,0,0" c="3" L="10" X="800" H="30" /><S Y="791" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" X="800" H="10" /><S Y="359" T="13" P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="1100" c="3" /><S Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="600" H="105" /><S Y="239" T="0" m="" P="0,0,0,0,0,0,0,0" c="3" L="10" X="400" H="30" /><S Y="239" T="0" m="" P="0,0,0,0,0,0,0,0" c="3" L="10" X="800" H="30" /><S Y="134" T="2" P="0,0,0,1.2,-110,0,0,0" L="10" X="383" H="41" /><S Y="133" T="2" P="0,0,0,1.2,-70,0,0,0" L="10" X="420" H="41" /><S Y="146" T="2" P="0,0,0,1.2,-50,0,0,0" L="10" X="447" H="22" /><S Y="146" T="2" P="0,0,0,1.2,50,0,0,0" L="10" X="359" H="22" /><S Y="133" T="2" P="0,0,0,1.2,-110,0,0,0" L="10" X="784" H="41" /><S Y="133" T="2" P="0,0,0,1.2,-70,0,0,0" L="10" X="821" H="41" /><S Y="146" T="2" P="0,0,0,1.2,-50,0,0,0" L="10" X="848" H="22" /><S Y="145" T="2" P="0,0,0,1.2,50,0,0,0" L="10" X="760" H="22" /></S><D><P Y="363" T="10" X="599" P="1,0" /><P Y="363" T="10" X="99" P="1,0" /><P Y="363" T="10" X="1099" P="1,0" /><P Y="247" T="66" X="400" P="1,0" /><P Y="247" T="66" X="800" P="1,0" /><P Y="251" T="65" P="1,0" X="400" C="FFFFFF,F48DCA" /><P Y="251" T="65" P="1,0" X="800" C="FFFFFF,F48DCA" /><P Y="490" T="148" X="30" P="0,0" /><P Y="485" T="148" X="119" P="0,0" /><P Y="485" T="148" X="226" P="0,0" /><P Y="474" T="148" X="322" P="0,0" /><P Y="482" T="148" X="403" P="0,0" /><P Y="480" T="148" X="486" P="0,0" /><P Y="474" T="148" X="572" P="0,0" /><P Y="478" T="148" X="656" P="0,0" /><P Y="465" T="148" X="766" P="0,0" /><P Y="471" T="148" X="866" P="0,0" /><P Y="473" T="148" X="954" P="0,0" /><P Y="474" T="148" X="1040" P="0,0" /><P Y="475" T="148" X="1127" P="0,0" /><P Y="444" T="148" X="1166" P="0,0" /><P Y="463" T="148" X="1070" P="0,0" /><P Y="464" T="148" X="939" P="0,0" /><P Y="444" T="148" X="816" P="0,0" /><P Y="454" T="148" X="666" P="0,0" /><P Y="448" T="148" X="519" P="0,0" /><P Y="474" T="148" X="428" P="0,0" /><P Y="436" T="148" X="358" P="0,0" /><P Y="450" T="148" X="257" P="0,0" /><P Y="450" T="148" X="172" P="0,0" /><P Y="428" T="148" X="80" P="0,0" /><P Y="467" T="148" X="6" P="0,0" /><P Y="438" T="148" X="603" P="0,0" /><P Y="432" T="148" X="1010" P="0,0" /><DS Y="-141" X="365" /></D><O /><L /></Z></C>',
    [3] = 'Pink date',
    [4] = 'Ppoppohaejuseyo#2315',
    [5] = '<C><P G="0,4" MEDATA=";33,1;;;-0;0:::1-" F="3" /><Z><S><S Y="400" T="18" P="0,0,0.1,0.2,0,0,0,0" c="3" L="800" X="400" H="100" N="" /><S Y="430" T="9" P="0,0,0,0,0,0,0,0" L="800" X="400" H="10" /><S Y="350" T="1" P="0,0,0,0.2,0,0,0,0" L="10" X="400" H="200" /><S Y="455" T="12" P="0,0,0.3,0.2,0,0,0,0" L="800" o="6a7495" X="400" H="10" /><S Y="0" T="12" P="0,0,0.2,0.2,0,0,0,0" L="10" o="6a7495" X="-5" H="3000" /><S Y="0" T="12" P="0,0,0.2,0.2,0,0,0,0" L="10" o="6a7495" X="805" H="3000" /><S Y="359" T="13" P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="100" c="3" /><S Y="359" T="13" P="0,0,0.3,0.2,0,0,0,0" H="10" L="10" o="324650" X="700" c="3" /><S Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="50" H="105" /><S Y="0" T="1" P="0,0,0,0.2,0,0,0,0" c="3" L="800" X="400" H="10" N="" /><S Y="95" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" c="3" L="800" X="400" H="10" N="" /><S Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" X="105" H="100" /><S Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" X="700" H="100" N="" /><S Y="225" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" c="3" L="800" X="401" H="10" /><S Y="239" T="0" m="" P="0,0,0,0,0,0,0,0" c="3" L="10" X="400" H="30" /><S Y="791" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" X="400" H="10" /><S Y="-129" T="12" P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="316" H="200" /><S Y="-133" T="12" P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="407" H="200" /><S Y="-92" T="12" P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="363" H="100" /><S Y="-206" T="12" P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="360" H="100" /><S Y="460" T="12" P="0,0,0.3,0.2,0,0,0,0" c="4" L="3000" o="6a7495" X="400" H="120" N="" /><S Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="750" H="105" /><S Y="-800" T="1" P="0,0,0,0.2,0,0,0,0" L="800" X="400" H="10" N="" /><S Y="239" T="0" m="" P="0,0,0,0,0,0,0,0" c="3" L="10" X="400" H="30" /><S Y="239" T="0" m="" P="0,0,0,0,0,0,0,0" c="3" L="10" X="400" H="30" /><S Y="134" T="2" P="0,0,0,1.2,-110,0,0,0" L="10" X="383" H="41" /><S Y="133" T="2" P="0,0,0,1.2,-70,0,0,0" L="10" X="420" H="41" /><S Y="146" T="2" P="0,0,0,1.2,-50,0,0,0" L="10" X="447" H="22" /><S Y="146" T="2" P="0,0,0,1.2,50,0,0,0" L="10" X="359" H="22" /></S><D><P Y="365" T="10" X="699" P="1,0" /><P Y="365" T="10" X="99" P="1,0" /><P Y="247" T="66" X="400" P="1,0" /><P Y="251" T="65" P="1,0" X="400" C="FFFFFF,F48DCA" /><P Y="473" T="148" X="39" P="0,0" /><P Y="476" T="148" X="103" P="0,0" /><P Y="474" T="148" X="183" P="0,0" /><P Y="474" T="148" X="242" P="0,0" /><P Y="476" T="148" X="310" P="0,0" /><P Y="478" T="148" X="385" P="0,0" /><P Y="476" T="148" X="456" P="0,0" /><P Y="480" T="148" X="527" P="0,0" /><P Y="481" T="148" X="600" P="0,0" /><P Y="478" T="148" X="678" P="0,0" /><P Y="478" T="148" X="746" P="0,0" /><P Y="440" T="148" X="766" P="0,0" /><P Y="452" T="148" X="673" P="0,0" /><P Y="454" T="148" X="572" P="0,0" /><P Y="434" T="148" X="482" P="0,0" /><P Y="456" T="148" X="400" P="0,0" /><P Y="432" T="148" X="304" P="0,0" /><P Y="448" T="148" X="205" P="0,0" /><P Y="424" T="148" X="130" P="0,0" /><P Y="447" T="148" X="76" P="0,0" /><P Y="431" T="148" X="19" P="0,0" /><P Y="438" T="148" X="402" P="0,0" /><P Y="431" T="148" X="620" P="0,0" /><P Y="438" T="148" X="716" P="0,0" /><P Y="496" T="148" X="293" P="0,0" /><P Y="504" T="148" X="129" P="0,0" /><P Y="501" T="148" X="54" P="0,0" /><P Y="513" T="148" X="476" P="0,0" /><P Y="512" T="148" X="597" P="0,0" /><P Y="500" T="148" X="727" P="0,0" /><DS Y="-151" X="360" /></D><O /><L /></Z></C>',
    [6] = '195540284b2.png'
  },
  [29] = {
    [1] = '<C><P MEDATA=";;;;-0;0:::1-" F="10" L="1600" G="0,4" /><Z><S><S c="3" L="1610" H="100" X="805" N="" Y="400" T="3" P="0,0,0.2,500,0,0,0,0" /><S L="1200" H="10" X="600" Y="430" T="9" P="0,0,0,0,0,0,0,0" /><S L="10" o="A55131" H="200" X="400" Y="350" T="12" P="0,0,0,0.2,0,0,0,0" /><S L="800" o="6a7495" H="10" X="400" Y="455" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S c="2" L="10" o="6a7495" H="3000" X="-5" Y="0" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S c="3" L="10" o="6a7495" H="3000" X="-5" Y="4" T="12" P="0,0,0,0.2,0,0,0,0" /><S c="2" L="10" o="6a7495" H="3000" X="1605" Y="5" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S c="3" L="10" o="6a7495" H="3000" X="1606" Y="1" T="12" P="0,0,0,0.2,0,0,0,0" /><S c="4" L="100" o="324650" H="105" X="250" Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="1620" H="10" X="790" Y="0" T="1" P="0,0,0,0.2,0,0,0,0" /><S c="3" L="1620" H="10" X="790" Y="95" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="10" H="100" X="305" Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="10" H="100" X="1300" Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="1620" H="10" X="790" Y="101" T="3" P="0,0,0.2,500,0,0,0,0" /><S c="3" L="10" H="160" X="400" Y="174" T="0" m="" P="0,0,0,0,0,0,0,0" /><S c="3" L="800" H="10" X="400" Y="791" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" /><S c="3" L="20" o="6a7495" H="200" X="316" Y="-129" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S c="3" L="20" o="6a7495" H="200" X="407" Y="-133" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S c="3" L="20" o="6a7495" H="100" X="363" Y="-92" T="12" P="0,0,0.2,0.2,90,0,0,0" /><S c="3" L="20" o="6a7495" H="100" X="360" Y="-206" T="12" P="0,0,0.2,0.2,90,0,0,0" /><S c="4" L="3000" o="6a7495" H="120" X="400" N="" Y="460" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S c="4" L="100" o="324650" H="105" X="1350" Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S L="1200" H="10" X="603" Y="-800" T="1" P="0,0,0,0.2,0,0,0,0" /><S L="10" o="A55131" H="200" X="800" Y="350" T="12" P="0,0,0,0.2,0,0,0,0" /><S c="3" L="800" H="10" X="800" Y="790" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" /><S c="3" L="10" H="158" X="800" Y="175" T="0" m="" P="0,0,0,0,0,0,0,0" /><S L="10" o="A55131" H="200" X="1200" Y="350" T="12" P="0,0,0,0.2,0,0,0,0" /><S c="3" L="10" H="159" X="1200" Y="175" T="0" m="" P="0,0,0,0,0,0,0,0" /><S c="3" L="800" H="10" X="1200" Y="790" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" /><S c="4" L="100" o="324650" H="105" X="600" Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S c="4" L="100" o="324650" H="105" X="1000" Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" /></S><D><DS Y="-141" X="365" /></D><O /><L /></Z></C>',
    [2] = '<C><P MEDATA=";;;;-0;0:::1-" F="10" L="1200" G="0,4" /><Z><S><S c="3" L="1200" H="100" X="600" N="" Y="400" T="3" P="0,0,0.2,500,0,0,0,0" /><S L="1200" H="10" X="600" Y="430" T="9" P="0,0,0,0,0,0,0,0" /><S L="10" o="8E471D" H="200" X="400" Y="350" T="12" P="0,0,0,0.2,0,0,0,0" /><S L="800" o="6a7495" H="10" X="400" Y="455" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S c="2" L="10" o="6a7495" H="3000" X="-6" Y="0" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S c="3" L="10" o="6a7495" H="3000" X="-6" Y="2" T="12" P="0,0,0,0.2,0,0,0,0" /><S c="2" L="10" o="6a7495" H="3000" X="1200" Y="0" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S c="3" L="10" o="6a7495" H="3000" X="1201" Y="-3" T="12" P="0,0,0,0.2,0,0,0,0" /><S c="4" L="100" o="324650" H="105" X="250" Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="1200" H="10" X="600" Y="0" T="1" P="0,0,0,0.2,0,0,0,0" /><S c="3" L="1200" H="10" X="600" Y="95" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="10" H="100" X="305" Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="10" H="100" X="900" Y="48" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S c="3" L="1200" H="10" X="601" Y="101" T="3" P="0,0,0.2,500,0,0,0,0" /><S c="3" L="10" H="159" X="400" Y="175" T="0" m="" P="0,0,0,0,0,0,0,0" /><S c="3" L="800" H="10" X="400" Y="791" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" /><S c="3" L="20" o="6a7495" H="200" X="316" Y="-129" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S c="3" L="20" o="6a7495" H="200" X="407" Y="-133" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S c="3" L="20" o="6a7495" H="100" X="363" Y="-92" T="12" P="0,0,0.2,0.2,90,0,0,0" /><S c="3" L="20" o="6a7495" H="100" X="360" Y="-206" T="12" P="0,0,0.2,0.2,90,0,0,0" /><S c="4" L="3000" o="6a7495" H="120" X="400" N="" Y="460" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S c="4" L="100" o="324650" H="105" X="950" Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S L="1200" H="10" X="600" Y="-800" T="1" P="0,0,0,0.2,0,0,0,0" /><S L="10" o="8E471D" H="200" X="800" Y="350" T="12" P="0,0,0,0.2,0,0,0,0" /><S c="3" L="10" H="159" X="800" Y="175" T="0" m="" P="0,0,0,0,0,0,0,0" /><S c="3" L="800" H="10" X="800" Y="791" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" /><S c="4" L="100" o="324650" H="105" X="600" Y="45" T="12" P="0,0,0.3,0.2,0,0,0,0" /></S><D><DS Y="-141" X="365" /></D><O /><L /></Z></C>',
    [3] = 'The floor is kralizmox',
    [4] = 'Sfjoud#8638',
    [5] = '<C><P MEDATA=";;;;-0;0:::1-" F="10" G="0,4" /><Z><S><S P="0,0,0.2,500,0,0,0,0" L="800" X="400" c="3" N="" Y="400" T="3" H="100" /><S L="800" X="400" H="10" Y="430" T="9" P="0,0,0,0,0,0,0,0" /><S P="0,0,0,0.2,0,0,0,0" L="10" o="A3401F" X="400" Y="350" T="12" H="200" /><S P="0,0,0.3,0.2,0,0,0,0" L="800" o="6a7495" X="400" Y="455" T="12" H="10" /><S P="0,0,0,0.2,0,0,0,0" L="10" o="6a7495" X="-5" c="3" Y="0" T="12" H="3000" /><S P="0,0,0,0.2,0,0,0,0" L="10" o="6a7495" X="805" c="3" Y="0" T="12" H="3000" /><S P="0,0,0.3,0.2,0,0,0,0" L="100" o="324650" X="50" c="4" Y="45" T="12" H="105" /><S P="0,0,0,0.2,0,0,0,0" L="800" X="400" c="3" N="" Y="0" T="1" H="10" /><S P="0,0,0.3,0.2,0,0,0,0" L="800" X="400" c="3" N="" Y="95" T="0" m="" H="10" /><S P="0,0,0.3,0.2,0,0,0,0" L="10" X="105" c="3" Y="48" T="0" m="" H="100" /><S P="0,0,0.3,0.2,0,0,0,0" L="10" X="700" c="3" N="" Y="48" T="0" m="" H="100" /><S P="0,0,0.2,500,0,0,0,0" L="810" X="404" c="3" Y="102" T="3" H="10" /><S P="0,0,0,0,0,0,0,0" L="10" X="400" c="3" Y="172" T="0" m="" H="158" /><S P="0,0,0.3,0.2,90,0,0,0" L="800" X="400" c="3" Y="791" T="0" m="" H="10" /><S P="0,0,0.2,0.2,0,0,0,0" L="20" o="6a7495" X="316" c="3" Y="-129" T="12" H="200" /><S P="0,0,0.2,0.2,0,0,0,0" L="20" o="6a7495" X="407" c="3" Y="-133" T="12" H="200" /><S P="0,0,0.2,0.2,90,0,0,0" L="20" o="6a7495" X="363" c="3" Y="-92" T="12" H="100" /><S P="0,0,0.2,0.2,90,0,0,0" L="20" o="6a7495" X="360" c="3" Y="-206" T="12" H="100" /><S P="0,0,0.3,0.2,0,0,0,0" L="3000" o="6a7495" X="400" c="4" N="" Y="460" T="12" H="120" /><S P="0,0,0.3,0.2,0,0,0,0" L="100" o="324650" X="750" c="4" Y="45" T="12" H="105" /><S P="0,0,0,0.2,0,0,0,0" L="800" X="400" N="" Y="-800" T="1" H="10" /><S H="3000" L="10" o="6a7495" X="-5" c="2" Y="1" T="12" P="0,0,0.2,0.2,0,0,0,0" /><S P="0,0,0.2,0.2,0,0,0,0" L="10" o="6a7495" X="806" c="2" Y="34" T="12" H="3000" /></S><D><P X="321" Y="350" T="294" P="0,1" /><P X="319" Y="284" T="132" P="0,1" /><P X="324" Y="433" T="44" P="0,0" /><P X="302" Y="433" T="44" P="0,0" /><P X="307" Y="435" T="44" P="0,0" /><P X="326" Y="436" T="44" P="0,0" /><P X="341" Y="436" T="44" P="0,0" /><P X="348" Y="436" T="44" P="0,0" /><P X="304" Y="434" T="44" P="0,0" /><DS Y="-151" X="360" /></D><O /><L /></Z></C>',
    [6] = '1955403115e.png'
  },
  [30] = {
    [1] = '<C><P G="0,4" MEDATA=";;;;-0;0::0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21:1-" L="1600" /><Z><S><S P="0,0,0,0.2,0,0,0,0" L="10" X="400" H="200" Y="350" T="1" /><S P="0,0,0.3,0.2,0,0,0,0" L="800" o="6a7495" X="400" H="10" N="" Y="475" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" L="800" o="6a7495" X="1200" H="10" N="" Y="475" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="250" H="105" Y="45" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="1600" m="" X="800" H="10" Y="95" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" m="" X="305" H="100" Y="48" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" m="" X="1300" H="100" Y="48" T="0" /><S P="0,0,0,0,0,0,0,0" c="3" L="10" m="" X="400" H="150" Y="175" T="0" /><S P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="316" H="200" Y="-129" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="407" H="200" Y="-133" T="12" /><S P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="363" H="100" Y="-92" T="12" /><S P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="360" H="100" Y="-206" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="1350" H="105" Y="45" T="12" /><S P="0,0,0,0.2,0,0,0,0" L="1600" X="800" H="10" Y="-800" T="1" /><S P="0,0,0,0.2,0,0,0,0" L="10" X="800" H="200" Y="350" T="1" /><S P="0,0,0,0,0,0,0,0" c="3" L="10" m="" X="800" H="150" Y="175" T="0" /><S P="0,0,0,0,0,0,0,0" c="3" L="10" m="" X="1200" H="150" Y="175" T="0" /><S P="0,0,0,0.2,0,0,0,0" L="10" X="1200" H="200" Y="350" T="1" /><S P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" m="" X="1200" H="10" Y="790" T="0" /><S P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" m="" X="800" H="10" Y="790" T="0" /><S P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" m="" X="400" H="10" Y="790" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="600" H="105" Y="45" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="1000" H="105" Y="45" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="ee0f0f" X="200" c="3" N="" Y="500" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="ee0f0f" X="1000" c="3" N="" Y="500" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="ee0f0f" X="600" c="3" N="" Y="500" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="ee0f0f" X="1400" c="3" N="" Y="500" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="eea10f" X="200" c="3" N="" Y="510" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="eea10f" X="1000" c="3" N="" Y="510" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="eea10f" X="600" c="3" N="" Y="510" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="eea10f" X="1400" c="3" N="" Y="510" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="f7ff00" X="200" c="3" N="" Y="520" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="f7ff00" X="1000" c="3" N="" Y="520" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="f7ff00" X="600" c="3" N="" Y="520" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="f7ff00" X="1400" c="3" N="" Y="520" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00ff21" X="200" c="3" N="" Y="530" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00ff21" X="1000" c="3" N="" Y="530" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00ff21" X="600" c="3" N="" Y="530" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00ff21" X="1400" c="3" N="" Y="530" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00e8ff" X="200" c="3" N="" Y="540" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00e8ff" X="1000" c="3" N="" Y="540" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00e8ff" X="600" c="3" N="" Y="540" T="13" /><S P="0,0,0,0.2,0,0,0,0" c="3" L="1600" X="800" H="10" Y="-5" T="1" /><S P="0,0,0.2,0.2,0,0,0,0" L="200" o="6a7495" X="-95" H="3000" Y="0" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" L="200" o="6a7495" X="1695" H="3000" Y="0" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00e8ff" X="1400" c="3" N="" Y="540" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="0028ff" X="200" c="3" N="" Y="550" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="0028ff" X="1000" c="3" N="" Y="550" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="0028ff" X="600" c="3" N="" Y="550" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="0028ff" X="1400" c="3" N="" Y="550" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="6d00ff" X="200" c="3" N="" Y="560" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="6d00ff" X="1000" c="3" N="" Y="560" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="6d00ff" X="600" c="3" N="" Y="560" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="6d00ff" X="1400" c="3" N="" Y="560" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="69cdff" X="1000" c="3" N="" Y="570" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="69cdff" X="600" c="3" N="" Y="570" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="69cdff" X="200" c="3" N="" Y="570" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="69cdff" X="1400" c="3" N="" Y="570" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="3000" o="6a7495" X="800" H="400" N="" Y="600" T="12" /></S><D><DS Y="-141" X="365" /></D><O /><L><JD c="69cdff,200,1," P2="1600,300" P1="0,300" /><JD c="69cdff,200,1," P2="1600,100" P1="0,100" /><JD c="ffffff,50,1," P2="200.31,181" P1="200.31,180" /><JD c="ffffff,50,1," P2="1000.31,181" P1="1000.31,180" /><JD c="ffffff,50,1," P2="600.31,181" P1="600.31,180" /><JD c="ffffff,50,1," P2="1400.31,181" P1="1400.31,180" /><JD c="ffffff,50,1," P2="160,181" P1="160,180" /><JD c="ffffff,50,1," P2="960,181" P1="960,180" /><JD c="ffffff,50,1," P2="560,181" P1="560,180" /><JD c="ffffff,50,1," P2="1360,181" P1="1360,180" /><JD c="ffffff,50,1," P2="240,181" P1="240,180" /><JD c="ffffff,50,1," P2="1040,181" P1="1040,180" /><JD c="ffffff,50,1," P2="640,181" P1="640,180" /><JD c="ffffff,50,1," P2="1440,181" P1="1440,180" /><JD c="ffffff,50,1," P2="220,159.9" P1="220,160" /><JD c="ffffff,50,1," P2="1020,159.9" P1="1020,160" /><JD c="ffffff,50,1," P2="620,159.9" P1="620,160" /><JD c="ffffff,50,1," P2="1420,159.9" P1="1420,160" /><JD c="ffffff,50,1," P2="180,159.9" P1="180,160" /><JD c="ffffff,50,1," P2="980,159.9" P1="980,160" /><JD c="ffffff,50,1," P2="580,159.9" P1="580,160" /><JD c="ffffff,50,1," P2="1380,159.9" P1="1380,160" /></L></Z></C>',
    [2] = '<C><P G="0,4" MEDATA=";;;;-0;0::0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16:1-" L="1200" /><Z><S><S P="0,0,0,0.2,0,0,0,0" L="10" X="400" H="200" Y="350" T="1" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="250" H="105" Y="45" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="1200" m="" X="600" H="10" Y="95" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" m="" X="305" H="100" Y="48" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" m="" X="900" H="100" Y="48" T="0" /><S P="0,0,0,0,0,0,0,0" c="3" L="10" m="" X="400" H="150" Y="175" T="0" /><S P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" m="" X="400" H="10" Y="791" T="0" /><S P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="316" H="200" Y="-129" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="407" H="200" Y="-133" T="12" /><S P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="363" H="100" Y="-92" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="ee0f0f" X="200" c="3" N="" Y="500" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="ee0f0f" X="1000" c="3" N="" Y="500" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="ee0f0f" X="600" c="3" N="" Y="500" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="eea10f" X="200" c="3" N="" Y="510" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="eea10f" X="1000" c="3" N="" Y="510" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="eea10f" X="600" c="3" N="" Y="510" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="f7ff00" X="200" c="3" N="" Y="520" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="f7ff00" X="1000" c="3" N="" Y="520" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="f7ff00" X="600" c="3" N="" Y="520" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00ff21" X="200" c="3" N="" Y="530" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00ff21" X="1000" c="3" N="" Y="530" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00ff21" X="600" c="3" N="" Y="530" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00e8ff" X="200" c="3" N="" Y="540" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00e8ff" X="1000" c="3" N="" Y="540" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00e8ff" X="600" c="3" N="" Y="540" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="0028ff" X="200" c="3" N="" Y="550" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="0028ff" X="1000" c="3" N="" Y="550" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="0028ff" X="600" c="3" N="" Y="550" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="6d00ff" X="199" c="3" N="" Y="560" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="6d00ff" X="999" c="3" N="" Y="560" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="6d00ff" X="599" c="3" N="" Y="560" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="69cdff" X="200" c="3" N="" Y="570" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="69cdff" X="1000" c="3" N="" Y="570" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="69cdff" X="600" c="3" N="" Y="570" T="13" /><S P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="360" H="100" Y="-206" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="3000" o="6a7495" X="400" H="400" N="" Y="600" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="950" H="105" Y="45" T="12" /><S P="0,0,0,0.2,0,0,0,0" L="1200" X="600" H="10" Y="-800" T="1" /><S P="0,0,0,0.2,0,0,0,0" L="10" X="800" H="200" Y="350" T="1" /><S P="0,0,0,0,0,0,0,0" c="3" L="10" m="" X="800" H="150" Y="175" T="0" /><S P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" m="" X="800" H="10" Y="791" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="600" H="105" Y="45" T="12" /><S P="0,0,0,0.2,0,0,0,0" c="3" L="1200" X="601" H="10" Y="-5" T="1" /><S P="0,0,0.2,0.2,0,0,0,0" L="200" o="6a7495" X="-95" H="3000" Y="0" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" L="200" o="6a7495" X="1295" H="3000" Y="0" T="12" /></S><D><DS Y="-141" X="365" /></D><O /><L><JD c="69cdff,200,1," P2="1200,300" P1="0,300" /><JD c="69cdff,200,1," P2="1200,100" P1="0,100" /><JD c="ffffff,50,1," P2="200,181" P1="200,180" /><JD c="ffffff,50,1," P2="1000,181" P1="1000,180" /><JD c="ffffff,50,1," P2="600,181" P1="600,180" /><JD c="ffffff,50,1," P2="220,161" P1="220,160" /><JD c="ffffff,50,1," P2="1020,161" P1="1020,160" /><JD c="ffffff,50,1," P2="620,161" P1="620,160" /><JD c="ffffff,50,1," P2="180,161" P1="180,160" /><JD c="ffffff,50,1," P2="980,161" P1="980,160" /><JD c="ffffff,50,1," P2="580,161" P1="580,160" /><JD c="ffffff,50,1," P2="240,181" P1="240,180" /><JD c="ffffff,50,1," P2="1040,181" P1="1040,180" /><JD c="ffffff,50,1," P2="640,181" P1="640,180" /><JD c="ffffff,50,1," P2="160,181" P1="160,180" /><JD c="ffffff,50,1," P2="960,181" P1="960,180" /><JD c="ffffff,50,1," P2="560,181" P1="560,180" /></L></Z></C>',
    [3] = 'The Rainbow',
    [4] = 'Kralizmox#0000',
    [5] = '<C><P G="0,4" MEDATA=";;;;-0;0::0,1,2,3,4,5,6,7,8,9,10,11:1-" /><Z><S><S P="0,0,0,0.2,0,0,0,0" L="10" X="400" H="200" Y="350" T="1" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="50" H="105" Y="45" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="800" m="" X="400" H="10" N="" Y="95" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" m="" X="105" H="100" Y="48" T="0" /><S P="0,0,0.3,0.2,0,0,0,0" c="3" L="10" m="" X="700" H="100" N="" Y="48" T="0" /><S P="0,0,0,0,0,0,0,0" c="3" L="10" m="" X="400" H="150" Y="175" T="0" /><S P="0,0,0.3,0.2,90,0,0,0" c="3" L="800" m="" X="400" H="10" Y="791" T="0" /><S P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="316" H="200" Y="-129" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" c="3" L="20" o="6a7495" X="407" H="200" Y="-133" T="12" /><S P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="363" H="100" Y="-92" T="12" /><S P="0,0,0.2,0.2,90,0,0,0" c="3" L="20" o="6a7495" X="360" H="100" Y="-206" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="ee0f0f" X="200" c="3" N="" Y="500" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="ee0f0f" X="600" c="3" N="" Y="500" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="eea10f" X="200" c="3" N="" Y="510" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="eea10f" X="600" c="3" N="" Y="510" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="f7ff00" X="200" c="3" N="" Y="520" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="f7ff00" X="600" c="3" N="" Y="520" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00ff21" X="200" c="3" N="" Y="530" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00ff21" X="600" c="3" N="" Y="530" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00e8ff" X="200" c="3" N="" Y="540" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="00e8ff" X="600" c="3" N="" Y="540" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="0028ff" X="200" c="3" N="" Y="550" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="0028ff" X="600" c="3" N="" Y="550" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="6d00ff" X="200" c="3" N="" Y="560" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="6d00ff" X="600" c="3" N="" Y="560" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="69cdff" X="200" c="3" N="" Y="570" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" H="10" L="200" o="69cdff" X="600" c="3" N="" Y="570" T="13" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="3000" o="6a7495" X="400" H="400" N="" Y="600" T="12" /><S P="0,0,0.3,0.2,0,0,0,0" c="4" L="100" o="324650" X="750" H="105" Y="45" T="12" /><S P="0,0,0,0.2,0,0,0,0" c="3" L="800" X="400" H="10" Y="-5" T="1" /><S P="0,0,0,0.2,0,0,0,0" L="800" X="400" H="10" N="" Y="-800" T="1" /><S P="0,0,0.2,0.2,0,0,0,0" L="200" o="6a7495" X="-95" H="3000" Y="0" T="12" /><S P="0,0,0.2,0.2,0,0,0,0" L="200" o="6a7495" X="895" H="3000" Y="0" T="12" /></S><D><DS Y="-151" X="360" /></D><O /><L><JD c="69cdff,200,1," P1="0,299" P2="800,299" /><JD c="69cdff,200,1," P1="0,100" P2="800,100" /><JD c="ffffff,50,1," P1="200,180" P2="200,181" /><JD c="ffffff,50,1," P1="600,180" P2="600,181" /><JD c="ffffff,50,1," P1="160,180" P2="160,181" /><JD c="ffffff,50,1," P1="560,180" P2="560,181" /><JD c="ffffff,50,1," P1="180,160" P2="180,161" /><JD c="ffffff,50,1," P1="580,160" P2="580,161" /><JD c="ffffff,50,1," P1="220,160" P2="220,161" /><JD c="ffffff,50,1," P1="620,160" P2="620,161" /><JD c="ffffff,50,1," P1="240,180" P2="240,181" /><JD c="ffffff,50,1," P1="640,180" P2="640,181" /></L></Z></C>',
    [6] = '19554034040.png'
  },
  [31] = {
    [1] = '<C><P L="1600" F="7" G="0,4" MEDATA=";10,1;;;-0;0:::1-"/><Z><S><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="178" L="10" H="155" P="0,0,0.2,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="177" L="10" H="155" P="0,0,0.2,0,0,0,0,0" c="3" m=""/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="178" L="10" H="155" P="0,0,0.2,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="10" X="342" Y="264" L="108" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="742" Y="264" L="108" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1142" Y="264" L="108" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1258" Y="264" L="108" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="458" Y="264" L="108" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="858" Y="264" L="108" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="326" Y="214" L="68" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="474" Y="214" L="68" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="874" Y="214" L="68" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="726" Y="214" L="68" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1126" Y="214" L="68" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1274" Y="214" L="68" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="293" Y="238" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="507" Y="238" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="907" Y="238" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="693" Y="238" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1093" Y="238" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1307" Y="238" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="355" Y="184" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="445" Y="184" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="845" Y="184" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="755" Y="184" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1155" Y="184" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1245" Y="184" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="377" Y="156" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="423" Y="156" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="823" Y="156" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="777" Y="156" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1177" Y="156" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1223" Y="156" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="190" Y="328" L="139" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="611" Y="328" L="139" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1011" Y="328" L="139" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1410" Y="328" L="139" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1410" Y="378" L="139" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="190" Y="378" L="139" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="611" Y="378" L="139" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1011" Y="378" L="139" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="126" Y="352" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="546" Y="352" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="946" Y="352" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1475" Y="352" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="255" Y="352" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="676" Y="352" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1076" Y="352" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1345" Y="352" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="50" Y="300" L="100" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1550" Y="300" L="100" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="96" Y="270" L="10" H="68" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1504" Y="270" L="10" H="68" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="73" Y="240" L="55" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1527" Y="240" L="55" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="51" Y="207" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1549" Y="207" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="25" Y="179" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1575" Y="179" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/></S><D><T X="335" Y="251" spawn="2"/><T X="465" Y="251" spawn="2"/><T X="865" Y="251" spawn="2"/><T X="735" Y="251" spawn="2"/><T X="1135" Y="251" spawn="2"/><T X="1265" Y="251" spawn="2"/><T X="190" Y="366" spawn="1"/><T X="610" Y="366" spawn="1"/><T X="1010" Y="366" spawn="1"/><T X="1410" Y="366" spawn="1"/><T X="41" Y="281" spawn="3"/><T X="1559" Y="281" spawn="3"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="7" G="0,4" MEDATA=";7,1;;;-0;0:::1-"/><Z><S><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="176" L="10" H="156" P="0,0,0.2,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="175" L="10" H="158" P="0,0,0.2,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="10" X="342" Y="264" L="108" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3"/><S T="10" X="458" Y="264" L="108" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3"/><S T="10" X="858" Y="264" L="108" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3"/><S T="10" X="742" Y="264" L="108" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3"/><S T="10" X="293" Y="238" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="507" Y="238" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="907" Y="238" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="693" Y="238" L="10" H="59" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="190" Y="378" L="139" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="326" Y="214" L="68" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="474" Y="214" L="68" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="874" Y="214" L="68" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="726" Y="214" L="68" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="355" Y="184" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="445" Y="184" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="845" Y="184" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="755" Y="184" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="377" Y="156" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="423" Y="156" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="823" Y="156" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="777" Y="156" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="190" Y="328" L="139" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="611" Y="328" L="139" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1011" Y="328" L="139" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="611" Y="378" L="139" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1011" Y="378" L="139" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="126" Y="354" L="10" H="57" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="547" Y="354" L="10" H="57" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="947" Y="354" L="10" H="57" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="255" Y="354" L="10" H="57" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="676" Y="354" L="10" H="57" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1076" Y="354" L="10" H="57" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="50" Y="300" L="100" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1150" Y="300" L="100" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="96" Y="270" L="10" H="68" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1104" Y="270" L="10" H="68" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="73" Y="240" L="55" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1127" Y="240" L="55" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="51" Y="207" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1149" Y="207" L="10" H="66" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="25" Y="179" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/><S T="10" X="1175" Y="179" L="48" H="10" P="0,0,0.3,0,0,0,0,0" c="3"/></S><D><T X="335" Y="251" spawn="2"/><T X="465" Y="251" spawn="2"/><T X="865" Y="251" spawn="2"/><T X="735" Y="251" spawn="2"/><T X="190" Y="366" spawn="1"/><T X="610" Y="366" spawn="1"/><T X="1010" Y="366" spawn="1"/><T X="41" Y="281" spawn="3"/><T X="1159" Y="281" spawn="3"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Platforms',
    [4] = 'Refletz#6472',
    [5] = '<C><P F="7" G="0,4" MEDATA=";4,1;;;-0;0:::1-"/><Z><S><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="400" Y="175" L="10" H="158" P="0,0,0.2,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/><S T="10" X="342" Y="264" L="108" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="458" Y="264" L="108" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="326" Y="214" L="68" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="474" Y="214" L="68" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="355" Y="184" L="10" H="66" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="445" Y="184" L="10" H="66" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="51" Y="207" L="10" H="66" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="751" Y="207" L="10" H="66" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="377" Y="156" L="48" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="423" Y="156" L="48" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="25" Y="179" L="48" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="775" Y="179" L="48" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="293" Y="238" L="10" H="59" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="507" Y="238" L="10" H="59" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="190" Y="378" L="139" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="610" Y="378" L="139" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="190" Y="328" L="139" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="611" Y="328" L="139" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="126" Y="352" L="10" H="59" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="546" Y="352" L="10" H="59" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="255" Y="354" L="10" H="57" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="676" Y="354" L="10" H="57" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="50" Y="300" L="100" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="750" Y="300" L="100" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="73" Y="240" L="55" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="727" Y="240" L="55" H="10" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="96" Y="270" L="10" H="68" P="0,0,0.1,0.2,0,0,0,0" c="3"/><S T="10" X="704" Y="270" L="10" H="68" P="0,0,0.1,0.2,0,0,0,0" c="3"/></S><D><T X="335" Y="251" spawn="2"/><T X="465" Y="251" spawn="2"/><T X="190" Y="366" spawn="1"/><T X="610" Y="366" spawn="1"/><T X="41" Y="281" spawn="3"/><T X="761" Y="281" spawn="3"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [6] = '196599446e1.png'
  },
  [32] =
  {
    [1] = '<C><P L="1600" G="0,4" MEDATA=";;;;-0;0:::1-"/><Z><S><S T="12" X="400" Y="50" L="10" H="100" P="0,0,0,0,0,0,0,0" o="272727" c="4" friction="-100,-20"/><S T="12" X="800" Y="500" L="2400" H="300" P="0,0,0.1,0.2,0,0,0,0" o="6A7495" c="4" N=""/><S T="12" X="800" Y="175" L="1600" H="350" P="0,0,0,0,0,0,0,0" o="121212" c="4"/><S T="12" X="800" Y="95" L="1600" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" m=""/><S T="12" X="800" Y="-500" L="1620" H="20" P="0,0,0,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="400" Y="175" L="10" H="150" P="0,0,0,0,0,0,0,0" o="272727" c="3" friction="-100,-20"/><S T="12" X="800" Y="175" L="10" H="150" P="0,0,0,0,0,0,0,0" o="272727" c="3" friction="-100,-20"/><S T="12" X="1200" Y="175" L="10" H="150" P="0,0,0,0,0,0,0,0" o="272727" c="3" friction="-100,-20"/><S T="12" X="800" Y="50" L="10" H="100" P="0,0,0,0,0,0,0,0" o="272727" c="4" friction="-100,-20"/><S T="12" X="800" Y="-50" L="1600" H="100" P="0,0,0,0.2,0,0,0,0" o="0d0906" c="3"/><S T="12" X="400" Y="345" L="10" H="200" P="0,0,0,0.2,0,0,0,0" o="FFFFFF" N=""/><S T="12" X="800" Y="345" L="10" H="200" P="0,0,0,0.2,0,0,0,0" o="FFFFFF" N=""/><S T="12" X="1200" Y="345" L="10" H="200" P="0,0,0,0.2,0,0,0,0" o="FFFFFF" N=""/><S T="12" X="800" Y="400" L="1600" H="100" P="0,0,0.1,0.2,0,0,0,0" o="0D0906" c="3" N=""/><S T="9" X="800" Y="430" L="1600" H="10" P="0,0,0,0,0,0,0,0" m=""/><S T="12" X="400" Y="795" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="800" Y="795" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="1200" Y="795" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="-10" Y="490" L="20" H="2000" P="0,0,0.2,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="1610" Y="490" L="20" H="2000" P="0,0,0.2,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="800" Y="455" L="1600" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="318" Y="-204" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-210" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-169" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-283" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="13" X="208" Y="314" L="37" P="0,0,0,0,0,0,0,0" o="181818" c="4"/><S T="13" X="1404" Y="314" L="37" P="0,0,0,0,0,0,0,0" o="181818" c="4"/><S T="13" X="583" Y="52" L="37" P="0,0,0,0,180,0,0,0" o="181818" c="4"/><S T="12" X="1200" Y="50" L="10" H="100" P="0,0,0,0,0,0,0,0" o="272727" c="4" friction="-100,-20"/><S T="13" X="588" Y="140" L="37" P="0,0,0,0,180,0,0,0" o="181818" c="4"/><S T="13" X="1045" Y="140" L="37" P="0,0,0,0,180,0,0,0" o="181818" c="4"/><S T="12" X="237" Y="159" L="15" H="320" P="0,0,0,0,0,0,0,0" o="181818" c="4"/><S T="12" X="1433" Y="159" L="15" H="320" P="0,0,0,0,0,0,0,0" o="181818" c="4"/><S T="12" X="1500" Y="90" L="15" H="220" P="0,0,0,0,-40,0,0,0" o="181818" c="4"/><S T="12" X="554" Y="207" L="15" H="320" P="0,0,0,0,180,0,0,0" o="181818" c="4"/><S T="12" X="1016" Y="269" L="15" H="320" P="0,0,0,0,180,0,0,0" o="181818" c="4"/><S T="12" X="800" Y="270" L="1600" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3"/><S T="12" X="800" Y="185" L="1600" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3"/><S T="12" X="800" Y="95" L="1600" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3"/><S T="12" X="300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" N="" m=""/><S T="12" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" N="" m=""/></S><D><T X="200" Y="161" spawn="2"/><T X="600" Y="161" spawn="2"/><T X="1000" Y="161" spawn="2"/><T X="1400" Y="161" spawn="2"/><T X="200" Y="246" spawn="1"/><T X="600" Y="246" spawn="1"/><T X="1000" Y="246" spawn="1"/><T X="1400" Y="246" spawn="1"/><T X="200" Y="346" spawn="3"/><T X="600" Y="346" spawn="3"/><T X="1000" Y="346" spawn="3"/><T X="1400" Y="346" spawn="3"/><DS X="365" Y="-200"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="3" G="0,4" /><Z><S><S T="12" X="600" Y="500" L="2000" H="300" P="0,0,0.1,0.2,0,0,0,0" o="6A7495" c="4" N=""/><S T="12" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" m=""/><S T="12" X="600" Y="175" L="1200" H="350" P="0,0,0.1,0.2,0,0,0,0" o="121212" c="4"/><S T="13" X="698" Y="52" L="37" P="0,0,0,0.2,180,0,0,0" o="181818" c="4"/><S T="13" X="703" Y="140" L="37" P="0,0,0,0.2,180,0,0,0" o="181818" c="4"/><S T="13" X="958" Y="314" L="37" P="0,0,0,0.2,0,0,0,0" o="181818" c="4"/><S T="12" X="600" Y="-500" L="1240" H="20" P="0,0,0,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="400" Y="161" L="10" H="120" P="0,0,0,0.2,0,0,0,0" o="272727" c="3" friction="-100,-20"/><S T="12" X="986" Y="159" L="15" H="320" P="0,0,0,0.2,0,0,0,0" o="181818" c="4"/><S T="12" X="1043" Y="52" L="150" H="15" P="0,0,0,0.2,-140,0,0,0" o="181818" c="4"/><S T="12" X="600" Y="-50" L="1200" H="100" P="0,0,0,0,0,0,0,0" o="0d0906" c="3"/><S T="12" X="400" Y="330" L="10" H="220" P="0,0,0,0.2,0,0,0,0" o="FFFFFF" N=""/><S T="12" X="800" Y="330" L="10" H="220" P="0,0,0,0.2,0,0,0,0" o="FFFFFF" N=""/><S T="12" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" o="0D0906" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0" m=""/><S T="12" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="-10" Y="490" L="20" H="2000" P="0,0,0.2,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="1210" Y="490" L="20" H="2000" P="0,0,0.2,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="80" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3" m=""/><S T="12" X="1120" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3" m=""/><S T="12" X="400" Y="50" L="10" H="100" P="0,0,0,0.2,0,0,0,0" o="272727" c="4" friction="-100,-20"/><S T="12" X="600" Y="455" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="318" Y="-204" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="800" Y="50" L="10" H="100" P="0,0,0,0.2,0,0,0,0" o="272727" c="4" friction="-100,-20"/><S T="12" X="407" Y="-210" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-169" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-283" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="13" X="208" Y="314" L="37" P="0,0,0,0.2,0,0,0,0" o="181818" c="4"/><S T="13" X="464" Y="316" L="37" P="0,0,0,0.2,0,0,0,0" o="181818" c="4"/><S T="12" X="237" Y="159" L="15" H="320" P="0,0,0,0.2,0,0,0,0" o="181818" c="4"/><S T="12" X="493" Y="161" L="15" H="320" P="0,0,0,0.2,0,0,0,0" o="181818" c="4"/><S T="12" X="669" Y="207" L="15" H="320" P="0,0,0,0.2,180,0,0,0" o="181818" c="4"/><S T="12" X="600" Y="270" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3"/><S T="12" X="600" Y="185" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3"/><S T="12" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3"/><S T="12" X="800" Y="161" L="10" H="120" P="0,0,0,0.2,0,0,0,0" o="272727" c="3" friction="-100,-20"/></S><D><T X="200" Y="160" spawn="2"/><T X="600" Y="160" spawn="2"/><T X="1000" Y="160" spawn="2"/><T X="200" Y="247" spawn="1"/><T X="600" Y="247" spawn="1"/><T X="1000" Y="247" spawn="1"/><T X="200" Y="345" spawn="3"/><T X="600" Y="345" spawn="3"/><T X="1000" Y="345" spawn="3"/><DS X="365" Y="-200"/></D><O/><L/></Z></C>',
    [3] = 'Some chords',
    [4] = 'Tanarchosl#4785 and Tanatosl#0000',
    [5] = '<C><P G="0,4" L="800"/><Z><S><S T="12" X="400" Y="500" L="1600" H="300" P="0,0,0.1,0.2,0,0,0,0" o="6A7495" c="4" N=""/><S T="12" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3" m=""/><S T="12" X="400" Y="175" L="800" H="350" P="0,0,0,0,0,0,0,0" o="121212" c="4"/><S T="12" X="400" Y="-400" L="830" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="400" Y="180" L="10" H="160" P="0,0,0,0,0,0,0,0" o="272727" c="3" friction="-100,-20"/><S T="12" X="400" Y="-50" L="800" H="100" P="0,0,0,0.2,0,0,0,0" o="0d0906" c="3"/><S T="12" X="400" Y="345" L="10" H="200" P="0,0,0,0.2,0,0,0,0" o="FFFFFF" N=""/><S T="12" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" o="0D0906" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0" m=""/><S T="12" X="400" Y="795" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="-5" Y="400" L="10" H="1600" P="0,0,0.2,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="805" Y="400" L="10" H="1600" P="0,0,0.2,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="80" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="720" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="318" Y="-204" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-210" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-169" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="50" L="10" H="100" P="0,0,0,0,0,0,0,0" o="272727" c="4" friction="-100,-20"/><S T="12" X="360" Y="-283" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="13" X="208" Y="314" L="37" P="0,0,0,0,0,0,0,0" o="181818" c="4"/><S T="13" X="583" Y="52" L="37" P="0,0,0,0,180,0,0,0" o="181818" c="4"/><S T="13" X="588" Y="140" L="37" P="0,0,0,0,180,0,0,0" o="181818" c="4"/><S T="12" X="237" Y="159" L="15" H="320" P="0,0,0,0,0,0,0,0" o="181818" c="4"/><S T="12" X="554" Y="207" L="15" H="320" P="0,0,0,0,180,0,0,0" o="181818" c="4"/><S T="12" X="400" Y="270" L="700" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3"/><S T="12" X="400" Y="185" L="700" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3"/><S T="12" X="400" Y="95" L="700" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="3"/></S><D><T X="321" Y="161" spawn="2"/><T X="441" Y="161" spawn="2"/><T X="321" Y="246" spawn="1"/><T X="441" Y="246" spawn="1"/><T X="321" Y="346" spawn="3"/><T X="442" Y="346" spawn="3"/><DS X="365" Y="-200"/></D><O/><L/></Z></C>',
    [6] = '19539e5756b.png'
  },
  [33] =
  {
    [1] = '<C><P L="1600" F="8" G="0,4" playerForce="1.1"/><Z><S><S T="12" X="-60" Y="133" L="120" H="560" P="0,0,0,0,0,0,0,0" o="000000" c="4"/><S T="12" X="1660" Y="133" L="120" H="560" P="0,0,0,0,0,0,0,0" o="000000" c="4"/><S T="9" X="-85" Y="140" L="50" H="430" P="0,0,0,0,0,0,0,0" tint="260042" archAcc="0.5" archCheeseMax="1" archMax="2"/><S T="9" X="1685" Y="140" L="50" H="430" P="0,0,0,0,0,0,0,0" tint="260042" archAcc="0.5" archCheeseMax="1" archMax="2"/><S T="9" X="-40" Y="320" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="FF0000" archAcc="0.75" archCheeseMax="1" archMax="1"/><S T="9" X="1640" Y="320" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="FF0000" archAcc="0.75" archCheeseMax="1" archMax="1"/><S T="10" X="800" Y="-590" L="1000" H="20" P="0,0,0,0.2,0,0,0,0" tint="1d0034" friction="20,4"/><S T="12" X="800" Y="-5" L="1600" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="802" Y="-80" L="1600" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="10" X="800" Y="115" L="1600" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" tint="1d0034"/><S T="1" X="400" Y="120" L="10" H="260" P="0,0,0,0.2,0,0,0,0" c="3" m="" friction="-100,-20"/><S T="1" X="800" Y="120" L="10" H="260" P="0,0,0,0.2,0,0,0,0" c="3" m="" friction="-100,-20"/><S T="1" X="1200" Y="120" L="10" H="260" P="0,0,0,0.2,0,0,0,0" c="3" m="" friction="-100,-20"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0,0,0,0,0" tint="1d0034"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0,0,0,0,0" tint="1d0034"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0,0,0,0,0" tint="1d0034"/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0" m=""/><S T="12" X="-5" Y="-50" L="10" H="200" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="1605" Y="-50" L="10" H="200" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="-60" Y="45" L="120" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="1660" Y="45" L="120" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="10" X="-30" Y="20" L="60" H="60" P="0,0,0.3,0.2,-3,0,0,0" tint="1d0034"/><S T="10" X="1630" Y="20" L="60" H="60" P="0,0,0.3,0.2,3,0,0,0" tint="1d0034"/><S T="10" X="-30" Y="260" L="60" H="60" P="0,0,0.3,0.2,-3,0,0,0" tint="1d0034"/><S T="10" X="1630" Y="260" L="60" H="60" P="0,0,0.3,0.2,3,0,0,0" tint="1d0034"/><S T="10" X="-30" Y="140" L="60" H="60" P="0,0,0.3,0.2,-3,0,0,0" tint="1d0034"/><S T="10" X="1630" Y="140" L="60" H="60" P="0,0,0.3,0.2,3,0,0,0" tint="1d0034"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="316" Y="-179" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-183" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="10" X="-33" Y="355" L="65" H="10" P="0,0,0,0.2,0,0,0,0" N="" tint="5C1B56"/><S T="10" X="1633" Y="355" L="65" H="10" P="0,0,0,0.2,0,0,0,0" N="" tint="5C1B56"/><S T="9" X="-40" Y="200" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="00FF40" archAcc="0.5" archCheeseMax="1" archMax="1"/><S T="9" X="1640" Y="200" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="00FF40" archAcc="0.5" archCheeseMax="1" archMax="1"/><S T="9" X="-40" Y="80" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="0008FF" archAcc="0.25" archCheeseMax="1" archMax="1"/><S T="9" X="1640" Y="80" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="0008FF" archAcc="0.25" archCheeseMax="1" archMax="1"/><S T="9" X="-40" Y="-80" L="80" H="140" P="0,0,0,0,0,0,0,0" tint="260042" archAcc="0.5" archCheeseMax="1" archMax="2"/><S T="9" X="1640" Y="-80" L="80" H="140" P="0,0,0,0,0,0,0,0" tint="260042" archAcc="0.5" archCheeseMax="1" archMax="2"/><S T="10" X="-115" Y="500" L="10" H="1200" P="0,0,0,0,0,0,0,0" tint="1d0034"/><S T="10" X="1715" Y="500" L="10" H="1200" P="0,0,0,0,0,0,0,0" tint="1d0034"/><S T="10" X="310" Y="-450" L="20" H="300" P="0,0,0,0.5,0,0,0,0" c="2" tint="1d0034"/><S T="10" X="1290" Y="-450" L="20" H="300" P="0,0,0,0.5,0,0,0,0" c="2" tint="1d0034"/><S T="12" X="800" Y="551" L="2400" H="400" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3" N=""/><S T="10" X="800" Y="400" L="2000" H="100" P="0,0,0.2,0,0,0,0,0" c="3" N="" tint="1d0034"/><S T="10" X="100" Y="-200" L="500" H="100" P="0,0,0,0,-20,0,0,0" tint="1d0034"/><S T="10" X="1500" Y="-200" L="500" H="100" P="0,0,0,0,20,0,0,0" tint="1d0034"/><S T="12" X="400" Y="700" L="10" H="700" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" N="" m=""/><S T="12" X="800" Y="700" L="10" H="700" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" N="" m=""/><S T="12" X="1200" Y="700" L="10" H="700" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" N="" m=""/></S><D><P X="1635" Y="345" T="307" P="0,1"/><P X="1635" Y="110" T="306" P="0,0"/><T X="800" Y="-15" lobby="0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="7" G="0,4" playerForce="1.1"/><Z><S><S T="12" X="-60" Y="133" L="120" H="560" P="0,0,0,0.2,0,0,0,0" o="000000" c="4"/><S T="12" X="407" Y="-183" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="1260" Y="133" L="120" H="560" P="0,0,0,0.2,0,0,0,0" o="000000" c="4"/><S T="9" X="-85" Y="138" L="50" H="425" P="0,0,0,0,0,0,0,0" tint="260042" archAcc="0.5" archCheeseMax="1" archMax="2"/><S T="9" X="1285" Y="138" L="50" H="425" P="0,0,0,0,0,0,0,0" tint="260042" archAcc="0.5" archCheeseMax="1" archMax="2"/><S T="9" X="-40" Y="320" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="FF0000" archAcc="0.75" archCheeseMax="1" archMax="1"/><S T="9" X="1240" Y="320" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="FF0000" archAcc="0.75" archCheeseMax="1" archMax="1"/><S T="10" X="600" Y="-285" L="600" H="100" P="0,0,0,0.2,0,0,0,0" tint="1d0034" friction="20,4"/><S T="12" X="600" Y="-5" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="600" Y="-80" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="10" X="600" Y="115" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" tint="1d0034"/><S T="1" X="400" Y="120" L="10" H="260" P="0,0,0,0.2,0,0,0,0" c="3" m="" friction="-100,-20"/><S T="1" X="800" Y="120" L="10" H="260" P="0,0,0,0.2,0,0,0,0" c="3" m="" friction="-100,-20"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" tint="1d0034"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" tint="1d0034"/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0" m=""/><S T="12" X="-5" Y="-50" L="10" H="200" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="1205" Y="-50" L="10" H="200" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="-60" Y="45" L="120" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="12" X="1260" Y="45" L="120" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" c="3" m=""/><S T="10" X="-30" Y="20" L="60" H="60" P="0,0,0.3,0.2,-3,0,0,0" tint="1d0034"/><S T="10" X="1230" Y="20" L="60" H="60" P="0,0,0.3,0.2,3,0,0,0" tint="1d0034"/><S T="10" X="-30" Y="260" L="60" H="60" P="0,0,0.3,0.2,-3,0,0,0" tint="1d0034"/><S T="10" X="1230" Y="260" L="60" H="60" P="0,0,0.3,0.2,3,0,0,0" tint="1d0034"/><S T="10" X="-30" Y="140" L="60" H="60" P="0,0,0.3,0.2,-3,0,0,0" tint="1d0034"/><S T="10" X="1230" Y="140" L="60" H="60" P="0,0,0.3,0.2,3,0,0,0" tint="1d0034"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="316" Y="-179" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6A7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="10" X="-33" Y="355" L="65" H="10" P="0,0,0,0.2,0,0,0,0" N="" tint="5C1B56"/><S T="10" X="1233" Y="355" L="65" H="10" P="0,0,0,0.2,0,0,0,0" N="" tint="5C1B56"/><S T="9" X="-40" Y="200" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="00FF40" archAcc="0.5" archCheeseMax="1" archMax="1"/><S T="9" X="1240" Y="200" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="00FF40" archAcc="0.5" archCheeseMax="1" archMax="1"/><S T="9" X="-40" Y="80" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="0008FF" archAcc="0.25" archCheeseMax="1" archMax="1"/><S T="9" X="1240" Y="80" L="80" H="60" P="0,0,0,0,0,0,0,0" tint="0008FF" archAcc="0.25" archCheeseMax="1" archMax="1"/><S T="9" X="-40" Y="-80" L="80" H="140" P="0,0,0,0,0,0,0,0" tint="260042" archAcc="0.5" archCheeseMax="1" archMax="2"/><S T="9" X="1240" Y="-80" L="80" H="140" P="0,0,0,0,0,0,0,0" tint="260042" archAcc="0.5" archCheeseMax="1" archMax="2"/><S T="10" X="-115" Y="500" L="10" H="1200" P="0,0,0,0,0,0,0,0" tint="1d0034"/><S T="10" X="1315" Y="500" L="10" H="1200" P="0,0,0,0,0,0,0,0" tint="1d0034"/><S T="12" X="400" Y="551" L="2400" H="400" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3" N=""/><S T="10" X="600" Y="400" L="1600" H="100" P="0,0,0.2,0,0,0,0,0" c="3" N="" tint="1d0034"/><S T="10" X="100" Y="-200" L="500" H="100" P="0,0,0.3,0.2,-20,0,0,0" tint="1d0034"/><S T="10" X="1100" Y="-200" L="500" H="100" P="0,0,0.3,0.2,20,0,0,0" tint="1d0034"/><S T="12" X="400" Y="700" L="10" H="700" P="0,0,0,0,0,0,0,0" o="FF0000" c="3" N="" m=""/><S T="12" X="800" Y="700" L="10" H="700" P="0,0,0,0,0,0,0,0" o="FF0000" c="3" N="" m=""/></S><D><P X="1235" Y="345" T="307" P="0,1"/><P X="1235" Y="110" T="306" P="0,0"/><T X="600" Y="-20"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = 'Quad water cannon',
    [4] = 'Tanarchosl#4785 and K1ng#7286',
    [5] = '<C><P F="0" G="0,4"/><Z><S><S H="560" L="120" Y="133" P="0,0,0,0,0,0,0,0" X="-60" c="4" o="000000" T="12" /><S H="560" L="120" Y="133" P="0,0,0,0,0,0,0,0" X="860" c="4" o="000000" T="12" /><S H="560" L="120" Y="133" tint="23003E" X="860" P="0,0,0,0,0,0,0,0" c="4" T="12" /><S archCheeseMax="1" H="450" L="50" Y="138" archAcc="0.5" tint="260042" X="-85" P="0,0,0,0,0,0,0,0" T="9" archMax="2" /><S archCheeseMax="1" H="450" L="50" Y="140" archAcc="0.5" tint="260042" X="885" P="0,0,0,0,0,0,0,0" T="9" archMax="2" /><S archCheeseMax="1" H="60" L="80" Y="320" archAcc="0.75" tint="FF0000" X="-40" P="0,0,0,0,0,0,0,0" T="9" archMax="1" /><S archCheeseMax="1" H="60" L="80" Y="320" archAcc="0.75" tint="FF0000" X="840" P="0,0,0,0,0,0,0,0" T="9" archMax="1" /><S H="20" L="1100" Y="-590" tint="1D0034" X="400" P="0,0,0,0.2,0,0,0,0" friction="20,4" T="10" /><S H="10" c="3" Y="-5" P="0,0,0,0.2,0,0,0,0" m="" X="400" L="800" o="FF0000" T="12" /><S H="10" c="3" Y="-80" P="0,0,0,0.2,0,0,0,0" m="" X="400" L="800" o="FF0000" T="12" /><S H="10" L="800" Y="115" m="" tint="1D0034" X="400" P="0,0,0.3,0.2,0,0,0,0" c="3" T="10" /><S H="10" L="800" Y="235" tint="1D0034" X="400" P="0,0,0.3,0.2,0,0,0,0" c="3" T="10" /><S H="140" L="10" Y="180" m="" X="400" P="0,0,0,0.2,0,0,0,0" friction="-100,-20" c="3" T="1" /><S H="200" L="10" Y="340" tint="1D0034" X="400" P="0,0,0,0,0,0,0,0" T="1" /><S H="10" L="1200" Y="430" m="" X="600" P="0,0,0,0,0,0,0,0" T="9" /><S H="200" c="3" Y="20" P="0,0,0.3,0.2,0,0,0,0" m="" X="-5" L="10" o="324650" T="12" /><S H="200" c="3" Y="20" P="0,0,0.3,0.2,0,0,0,0" m="" X="805" L="10" o="324650" T="12" /><S H="10" c="3" Y="165" P="0,0,0.3,0.2,0,0,0,0" m="" X="-60" L="120" o="FF0000" T="12" /><S H="10" c="3" Y="165" P="0,0,0.3,0.2,0,0,0,0" m="" X="860" L="120" o="FF0000" T="12" /><S H="60" L="60" Y="20" tint="1D0034" X="-30" P="0,0,0.3,0.2,3,0,0,0" T="10" /><S H="60" L="60" Y="20" tint="1D0034" X="830" P="0,0,0.3,0.2,-3,0,0,0" T="10" /><S H="60" L="60" Y="260" tint="1D0034" X="-30" P="0,0,0.3,0.2,3,0,0,0" T="10" /><S H="60" L="60" Y="260" tint="1D0034" X="830" P="0,0,0.3,0.2,-3,0,0,0" T="10" /><S H="60" L="60" Y="140" tint="1D0034" X="-30" P="0,0,0.3,0.2,3,0,0,0" T="10" /><S H="60" L="60" Y="140" tint="1D0034" X="830" P="0,0,0.3,0.2,-3,0,0,0" T="10" /><S H="10" L="800" Y="455" P="0,0,0.3,0.2,0,0,0,0" X="400" o="6a7495" T="12" /><S H="200" L="20" Y="-129" P="0,0,0.2,0.2,0,0,0,0" X="316" c="3" o="6a7495" T="12" /><S H="200" L="20" Y="-133" P="0,0,0.2,0.2,0,0,0,0" X="407" c="3" o="6a7495" T="12" /><S H="100" L="20" Y="-92" P="0,0,0.2,0.2,90,0,0,0" X="363" c="3" o="6a7495" T="12" /><S H="100" L="20" Y="-206" P="0,0,0.2,0.2,90,0,0,0" X="360" c="3" o="6a7495" T="12" /><S H="10" L="65" Y="355" tint="5C1B56" X="-33" P="0,0,0,0.2,0,0,0,0" N="" T="10" /><S H="10" L="65" Y="355" tint="5C1B56" X="833" P="0,0,0,0.2,0,0,0,0" N="" T="10" /><S archCheeseMax="1" H="60" L="80" Y="200" archAcc="0.5" tint="00FF40" X="-40" P="0,0,0,0,0,0,0,0" T="9" archMax="1" /><S archCheeseMax="1" H="60" L="80" Y="200" archAcc="0.5" tint="00FF40" X="840" P="0,0,0,0,0,0,0,0" T="9" archMax="1" /><S archCheeseMax="1" H="60" L="80" Y="80" archAcc="0.25" tint="0008FF" X="-40" P="0,0,0,0,0,0,0,0" T="9" archMax="1" /><S archCheeseMax="1" H="60" L="80" Y="80" archAcc="0.25" tint="0008FF" X="840" P="0,0,0,0,0,0,0,0" T="9" archMax="1" /><S archCheeseMax="1" H="140" L="80" Y="-80" archAcc="0.5" tint="260042" X="-40" P="0,0,0,0,0,0,0,0" T="9" archMax="1" /><S archCheeseMax="1" H="140" L="80" Y="-80" archAcc="0.5" tint="260042" X="840" P="0,0,0,0,0,0,0,0" T="9" archMax="1" /><S H="1200" L="10" Y="500" tint="1D0034" X="-115" P="0,0,0,0,0,0,0,0" T="10" /><S H="1200" L="10" Y="500" tint="1D0034" X="915" P="0,0,0,0,0,0,0,0" T="10" /><S H="460" L="20" Y="-370" tint="1D0034" X="70" P="0,0,0,0.5,0,0,0,0" c="2" T="10" /><S H="460" L="20" Y="-370" tint="1D0034" X="730" P="0,0,0,0.5,0,0,0,0" c="2" T="10" /><S H="400" L="1600" Y="550" P="0,0,0.2,0.2,0,0,0,0" X="400" c="3" N="" o="6a7495" T="12" /><S H="100" L="1200" Y="400" tint="1D0034" X="400" P="0,0,0.2,0,0,0,0,0" N="" c="3" T="10" /><S H="216" L="100" Y="-130" tint="1D0034" X="-20" P="0,0,0,0,80,0,0,0" T="10" /><S H="216" L="100" Y="-130" tint="1D0034" X="820" P="0,0,0.3,0.2,-80,0,0,0" T="10" /><S H="700" c="3" Y="700" P="0,0,0,0,0,0,0,0" m="" X="400" L="10" N="" o="FF0000" T="12" /></S><D><P X="835" P="0,1" Y="345" T="307" /><P X="835" P="0,0" Y="110" T="306" /><DS X="365" Y="-141" /></D><O /><L /></Z></C>',
    [6] = '19539e5756b.png'
  },
-- [99] =
-- {
--   [1] = 'map1',
--   [2] = 'map2',
--   [3] = 'name',
--   [4] = 'author',
--   [5] = 'small map',
--   [6] = '19539e5756b.png'
-- }
}

local balls = {
  [1] = {
    id = 604,
    isImage = false,
    image = '',
    name = 'Soccer ball'
  },
  [2] = {
    id = 608,
    isImage = false,
    image = '',
    name = 'Futuristic ball'
  },
  [3] = {
    id = 611,
    isImage = false,
    image = '',
    name = 'Dino egg ball'
  },
  [4] = {
    id = 612,
    isImage = false,
    image = '',
    name = 'Basketball'
  },
  [5] = {
    id = 616,
    isImage = false,
    image = '',
    name = 'Earth ball'
  },
  [6] = {
    id = 619,
    isImage = false,
    image = '',
    name = 'Poisoned apple ball'
  },
  [7] = {
    id = 621,
    isImage = false,
    image = '',
    name = 'Snow globe ball'
  },
  [8] = {
    id = 626,
    isImage = false,
    image = '',
    name = 'Bubble ball'
  },
  [9] = {
    id = 630,
    isImage = false,
    image = '',
    name = 'Moon ball'
  },
  [10] = {
    id = 635,
    isImage = false,
    image = '',
    name = 'Crystal ball'
  },
  [11] = {
    id = 6,
    isImage = true,
    image = '18fd18e2334.png',
    name = 'White Volley ball'
  },
  [12] = {
    id = 6,
    isImage = true,
    image = '18fd18e5dc6.png',
    name = 'Original Volley ball'
  }
}

local x = {100, 280, 280, 640, 460, 460, 100, 100, 280, 640, 460, 640}
local y = {100, 100, 160, 100, 100, 160, 160, 220, 220, 160, 220, 220}
local score_red = 0
local score_blue = 0
local ball_id = 0
local ballOnGame = false
local ballOnGame2 = false
local playerConsumable = {}
local playerConsumableItem = {}
local playerConsumables = {}
local playerLeftRight = {}
local playerConsumableKey = {}
local ballOnGameTwoBalls = {}
local ballsId = {}
local gameStats = {gameMode = ''}
local pagesList = {}
local mapsVotes = {}
local canVote = {}
local afkTimeValue = -60
local enableAfkSystem = false
local playerOutOfCourt = {}
local showOutOfCourtText = {}
local globalSettings = { mode = 'Normal mode', twoBalls = false }
local settings = {}
local settingsMode = {}
local playersNormalMode = {}
local rankNormalMode = {}
local playersOnGameHistoric = {}
local pageNormalMode = {}
local playerRankingMode = {}
local playersFourTeamsMode = {}
local rankFourTeamsMode = {}
local pageFourTeamsMode = {}
local rankTwoTeamsMode = {}
local playersTwoTeamsMode = {}
local pageTwoTeamsMode = {}
local rankRealMode = {}
local playersRealMode = {}
local pageRealMode = {}
local openRank = {}
local countMatches = 0
local playerLastMatchCount = {}
local playerLeft = {}
local showCrownImages = {}
local redCrown = {'15296835cdd.png', '1529683757b.png', '15296838f74.png', '1529683a830.png', '1529683c1e0.png', '1529655c3e4.png', '1529655df16.png', '1529655fb1b.png', '152965616ff.png', '15296563a9e.png'}
local blueCrown = {'1529682cc1e.png', '1529682e815.png', '15296830d1a.png', '1529683291f.png', '15296834389.png', '1529653b65f.png', '1529653d855.png', '1529653fa44.png', '15296541aed.png', '15296543994.png'}
local yellowCrown = {'192e02e0140.png', '192e02e18b0.png', '192e02e3022.png', '192e02e4795.png', '192e02e5f06.png', '192e02e767b.png', '192e02e8deb.png', '192e02ea7b1.png', '192e02ebf90.png', '192e02ed701.png'}
local greenCrown = {'192e02d16d0.png', '192e02d2e3f.png', '192e02d45b2.png', '192e02d5d22.png', '192e02d7494.png', '192e02d8c06.png', '192e02da37a.png', '192e02dbaea.png', '192e02dd25c.png', '192e02de9ce.png'}
local rankCrown = {}
local playerAchievements = {}
local playerAchievementsImages = {}
local playerTrophyImage = {}
local isOpenProfile = {}
local selectMapOpen = {}
local selectMapPage = {}
local selectMapImages = {}
local customMapCommand = {}
local lobbySpawn = {}
local playersSpawn400 = {}
local playersSpawn800 = {}
local playersSpawn1200 = {}
local playersSpawn1600 = {}

local gameTimeEnd = os.time() + 5000

playerAchievements["Jenji#1475"] = { [1] = { image = "img@193d675bca7", quantity = 1 }, [2] = { image = '19636907e9e.png', quantity = 0}}
playerAchievements["Ramasevosaff#0000"] = { [1] = { image = "img@193d675bca7", quantity = 1 }, [2] = { image = '19636907e9e.png', quantity = 0}}
playerAchievements["Rex#2654"] = { [1] = { image = "img@193d675bca7", quantity = 1 }, [2] = { image = '19636907e9e.png', quantity = 0}}
playerAchievements["Raidensnd#0000"] = { [1] = { image = "img@193d675bca7", quantity = 1 }, [2] = { image = '19636907e9e.png', quantity = 0}}
playerAchievements["Mulan#5042"] = { [1] = { image = "img@193d675bca7", quantity = 1 }, [2] = { image = '19636905a3c.png', quantity = 1 }}
playerAchievements["Basker#2338"] = { [1] = { image = "img@193d675bca7", quantity = 1 }, [2] = { image = '19636907e9e.png', quantity = 0}}
playerAchievements["Ppoppohaejuseyo#2315"] = { [1] = { image = "img@193d6763c82", quantity = 0 }, [2] = { image = '19636905a3c.png', quantity = 1 }}
playerAchievements["Djadja#5590"] = { [1] = { image = "img@193d6763c82", quantity = 1 }, [2] = { image = '19636905a3c.png', quantity = 1 }}

for name, data in pairs(tfm.get.room.playerList) do
  customMapCommand[name] = true
  selectMapOpen[name] = false
  selectMapPage[name] = 1
  selectMapImages[name] = {}
  isOpenProfile[name] = false
  playerTrophyImage[name] = 0
  if playerAchievements[name] == nil then
    playerAchievements[name] = {[1] = { image = "img@193d6763c82", quantity = 0 }, [2] = { image = '19636907e9e.png', quantity = 0}}
  end
  playerAchievementsImages[name] = {}
  showCrownImages[name] = true
  playersNormalMode[name] = {name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0}
  pageNormalMode[name] = 1
  playersFourTeamsMode[name] = {name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0, winsYellow = 0, winsGreen = 0}
  pageFourTeamsMode[name] = 1
  playersTwoTeamsMode[name] = {name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0}
  pageTwoTeamsMode[name] = 1
  playersRealMode[name] = {name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0}
  pageRealMode[name] = 1
  playerRankingMode[name] = "Normal mode"
  playerLeft[name] = false
  openRank[name] = false
  settings[name] = false
  settingsMode[name] = false
  playerLanguage[name] = {tr = trad, name = name}
  playerOutOfCourt[name] = false
  playerCanTransform[name] = true
  playerInGame[name] = false
  playerPhysicId[name] = 0
  playerBan[name] = false
  playerBanHistory[name] = ""
  showOutOfCourtText[name] = false
  tfm.exec.chatMessage(playerLanguage[name].tr.welcomeMessage, name)
  tfm.exec.chatMessage("<j>#Volley Version: "..gameVersion.."<n>", name)
  tfm.exec.chatMessage("<ce>Join our #Volley Discord server: https://discord.com/invite/pWNTesmNhu<n>", name)
  if tfm.get.room.isTribeHouse then
    if tfm.get.room.name:sub(3) == tfm.get.room.playerList[name].tribeName then
      admins[name] = true
    end
  end
  system.bindKeyboard(name, 32, true, true)
  system.bindKeyboard(name, 0, true, true)
  system.bindKeyboard(name, 1, true, true)
  system.bindKeyboard(name, 2, true, true)
  system.bindKeyboard(name, 3, true, true)
  system.bindKeyboard(name, 49, true, true)
  system.bindKeyboard(name, 50, true, true)
  system.bindKeyboard(name, 51, true, true)
  system.bindKeyboard(name, 52, true, true)
  system.bindKeyboard(name, 55, true, true)
  system.bindKeyboard(name, 56, true, true)
  system.bindKeyboard(name, 57, true, true)
  system.bindKeyboard(name, 48, true, true)
  system.bindKeyboard(name, 77, true, true)
  system.bindKeyboard(name, 76, true, true)
  system.bindKeyboard(name, 80, true, true)
end

function ui.addWindow(id, text, player, x, y, width, height, alpha, corners, closeButton, buttonText, showCornerImage)
  id = tostring(id)
  ui.addTextArea(id.."0", "", player, x+1, y+1, width-2, height-2, 0x8a583c, 0x8a583c, alpha, true)
  ui.addTextArea(id.."00", "", player, x+3, y+3, width-6, height-6, 0x2b1f19, 0x2b1f19, alpha, true)
  ui.addTextArea(id.."000", "", player, x+4, y+4, width-8, height-8, 0xc191c, 0xc191c, alpha, true)
  ui.addTextArea(id.."0000", "", player, x+5, y+5, width-10, height-10, 0x2d5a61, 0x2d5a61, alpha, true)
  ui.addTextArea(id.."00000", text, player, x+5, y+6, width-10, height-12, 0x142b2e, 0x142b2e, alpha, true)
  local imageId = {}
  if corners then
    if showCornerImage[1] == true then
      table.insert(imageId, tfm.exec.addImage("155cbe97a3f.png", "&1", x-7, (y+height)-22, player))
    end

    if showCornerImage[2] == true then
      table.insert(imageId, tfm.exec.addImage("155cbe99c72.png", "&1", x-7, y-7, player))
    end

    if showCornerImage[3] == true then
      table.insert(imageId, tfm.exec.addImage("155cbe9bc9b.png", "&1", (x+width)-20, (y+height)-22, player))
    end

    if showCornerImage[4] == true then
      table.insert(imageId, tfm.exec.addImage("155cbea943a.png", "&1", (x+width)-20, y-7, player))
    end
  end
  if closeButton then
    ui.addTextArea(id.."000000", "", player, x+8, y+height-22, width-16, 13, 0x7a8d93, 0x7a8d93, alpha, true)
    ui.addTextArea(id.."0000000", "", player, x+9, y+height-21, width-16, 13, 0xe1619, 0xe1619, alpha, true)
    ui.addTextArea(id.."00000000", "", player, x+9, y+height-21, width-17, 12, 0x314e57, 0x314e57, alpha, true)
    ui.addTextArea(id.."", buttonText, player, x+9, y+height-24, width-17, nil, 0x314e57, 0x314e57, 0, true)
  end
  return imageId
end


function ui.addTrophie(id, event, player, playerTarget, x, y, width, height, alpha)
  local indexImage = tonumber(string.sub(event, 8))
  id = tostring(id)
  ui.addTextArea(id.."0", "", player, x+1, y+1, width-2, height-2, 0x8a583c, 0x8a583c, alpha, true)
  ui.addTextArea(id.."00", "", player, x+3, y+3, width-6, height-6, 0x2b1f19, 0x2b1f19, alpha, true)
  ui.addTextArea(id.."000", "", player, x+4, y+4, width-8, height-8, 0xc191c, 0xc191c, alpha, true)
  ui.addTextArea(id.."0000", "", player, x+5, y+5, width-10, height-10, 0x2d5a61, 0x2d5a61, alpha, true)
  ui.addTextArea(id.."0000000", "", player, x+5, y+6, width-10, height-12, 0x142b2e, 0x142b2e, alpha, true)
  table.insert(playerAchievementsImages[player], tfm.exec.addImage(playerAchievements[playerTarget][indexImage].image, "~"..id.."0000000", x + 5, y + 7, player))
  ui.addTextArea(id.."00000", "<p align='right'><font size='10px'><font color='#000000'>x"..playerAchievements[playerTarget][indexImage].quantity.."", player, x+33, y+height-16, 20, 15, 0x161616, 0x161616, 0, true)
  ui.addTextArea(id.."000000", "<p align='right'><font size='10px'>x"..playerAchievements[playerTarget][indexImage].quantity.."", player, x+32, y+height-17, 20, 15, 0x161616, 0x161616, 0, true)
  ui.addTextArea(id.."00000000", "<a href='event:"..event.."'><font size='20px'><br> <br> </a>", player, x+5, y+6, width, height, 0x142b2e, 0x142b2e, 0, true)
end


function windowForHelp(name, pageOfPlayer, textNext, textPrev)
  removeUITrophies(name)
  local pageList = #trad.helpText
  ui.addWindow(24, ""..playerLanguage[name].tr.helpTitle..""..playerLanguage[name].tr.helpText[pageOfPlayer].text.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
  if pageOfPlayer >= 1 and pageOfPlayer < pageList then
    local page = pageOfPlayer + 1
    buttonNextOrPrev(25, name, 540, 300, 200, 30, 1, "<a href='event:nextHelp"..tostring(page).."'>"..textNext.."</a>")
  else
    buttonNextOrPrev(25, name, 540, 300, 200, 30, 1, "<n2>"..textNext.."")
  end
  if pageOfPlayer > 1 then
    local page = pageOfPlayer - 1
    buttonNextOrPrev(26, name, 160, 300, 200, 30, 1, "<a href='event:prevHelp"..tostring(page).."'>"..textPrev.."</a>")
  else
    buttonNextOrPrev(26, name, 160, 300, 200, 30, 1, "<n2>"..textPrev.."")
  end
end

function buttonNextOrPrev(id, name, x, y, width, height, alpha, text)
  id = tostring(id)
  ui.addTextArea(id.."0000000000", "", name, x+8, y+height-22, width-16, 13, 0x7a8d93, 0x7a8d93, alpha, true)
  ui.addTextArea(id.."00000000000", "", name, x+9, y+height-21, width-16, 13, 0xe1619, 0xe1619, alpha, true)
  ui.addTextArea(id.."000000000000", "", name, x+9, y+height-21, width-17, 12, 0x314e57, 0x314e57, alpha, true)
  ui.addTextArea(id.."0000000000000", text, name, x+9, y+height-24, width-17, nil, 0x314e57, 0x314e57, 0, true)
end

function closeWindow(id, name)
  local id = tostring(id)
  local str = "0"
  ui.removeTextArea(id, name)
  for i = 1, 9 do
    ui.removeTextArea(id..""..str.."", name)
    str = ""..str.."0"
  end
end

function removeButtons(id, name)
  local id = tostring(id)
  local str = "000000000"
  ui.removeTextArea(id, name)
  for i = 10, 14 do
    ui.removeTextArea(id..""..str.."", name)
    str = ""..str.."0"
  end
end

function init()
  spawnBallArea400 = {}
  spawnBallArea800 = {}
  spawnBallArea1200 = {}
  spawnBallArea1600 = {}
  lobbySpawn = {}
  playersSpawn400 = {}
  playersSpawn800 = {}
  playersSpawn1200 = {}
  playersSpawn1600 = {}

  playersOnGameHistoric = {}
  mode = "startGame"
  removeTimer('verifyBallCoordinates')
  playerConsumables = {}
  ballOnGame = false
  ballOnGame2 = false
  ballOnGameTwoBalls = {ballOnGame, ballOnGame2}
  ballsId = {nil, nil}
  tfm.exec.disableAllShamanSkills(true)
  playerCanTransform = {}
  playerInGame = {}
  twoTeamsPlayerRedPosition = {
    [1] = "",
    [2] = "",
    [3] = "",
    [4] = "",
    [5] = "",
    [6] = ""
  }
  twoTeamsPlayerBluePosition = {
    [1] = "",
    [2] = "",
    [3] = "",
    [4] = "",
    [5] = "",
    [6] = ""
  }
  playersRed = {
    [1] = {name = ''},
    [2] = {name = ''},
    [3] = {name = ''},
    [4] = {name = ''},
    [5] = {name = ''},
    [6] = {name = ''}
  }
  playersBlue = {
    [1] = {name = ''},
    [2] = {name = ''},
    [3] = {name = ''},
    [4] = {name = ''},
    [5] = {name = ''},
    [6] = {name = ''}

  }
  playersYellow = {
    [1] = {name = ''},
    [2] = {name = ''},
    [3] = {name = ''}
  }

  playersGreen = {
    [1] = {name = ''},
    [2] = {name = ''},
    [3] = {name = ''}
  }

  teamsLifes = {
    [1] = {yellow = 3},
    [2] = {red = 3},
    [3] = {blue = 3},
    [4] = {green = 3}
  }

  mapsToTest = {
    [1] = "",
    [2] = "",
    [3] = ""
  }

  getTeamsLifes = {}

  getTeamsColors = {}
  teamsPlayersOnGame = {}
  messageTeamsLifes = {}
  messageTeamsLostOneLife = {}
  messageTeamsLifesTextChat = {}
  messageWinners = {}
  getTeamsColorsName = {0xF59E0B, 0xEF4444, 0x3B82F6, 0x109267}

  for i = 1, #customMaps do
    mapsVotes[i] = 0
  end

  gameStats = {gameMode = '', redX = 0, blueX = 0, yellowX = 0, greenX = 0, redX2 = 0, blueX2 = 0, setMapName = '', winscore = 7, isCustomMap = false, customMapIndex = 0, initTimer = 0, totalVotes = 0, mapIndexSelected = 0, canTransform = false, teamsMode = false, canJoin = true, typeMap = '', customBall = false, customBallId = 0, banCommandIsEnabled = true, killSpec = false, isGamePaused = false, psyhicObjectForce = 1, twoTeamsMode = false, enableAfkMode = false, realMode = false, redServeIndex = 1, blueServeIndex = 1, redPlayerServe = "", bluePlayerServe = "", redServe = false, blueServe = false, redQuantitySpawn = 0, redLimitSpawn = 3, blueQuantitySpawn = 0, blueLimitSpawn = 3, lastPlayerRed = "", lastPlayerBlue = "", teamWithOutAce = "", reduceForce = false, aceRed = false, aceBlue = false, twoBalls = false, consumables = false, actualMode = ""}
  playerCoordinates = {}
  countId = 1
  playerPhysicId = {}
  score_red = 0
  score_blue = 0
  ball_id = 0
  tfm.exec.newGame('<C><P MEDATA="4,1;;;;-0;0:::1-"/><Z><S><S T="6" X="400" Y="385" L="800" H="50" P="0,0,0.3,0.2,0,0,0,0"/><S T="1" X="2" Y="202" L="10" H="404" P="0,0,0,0.2,0,0,0,0" m=""/><S T="1" X="795" Y="203" L="10" H="404" P="0,0,0,0.2,0,0,0,0" m=""/><S T="1" X="396" Y="7" L="10" H="800" P="0,0,0,0.2,90,0,0,0" m=""/><S T="0" X="450" Y="95" L="700" H="10" P="0,0,0.3,0.2,0,0,0,0" m=""/><S T="9" X="52" Y="222" L="89" H="270" P="0,0,0,0,0,0,0,0" m=""/></S><D><P X="217" Y="359" T="6" P="0,0"/><P X="580" Y="363" T="4" P="0,0"/><P X="319" Y="360" T="5" P="0,0"/><P X="0" Y="0" T="257" P="0,0"/><DS X="400" Y="349"/></D><O/><L/></Z></C>')

  if globalSettings.mode == "4 teams mode" then
    gameStats.teamsMode = true
    updateLobbyTextAreas(gameStats.teamsMode)
    tfm.exec.chatMessage("<bv>Room Setup: The room has been configured for 4 teams mode<n>", nil)
    if globalSettings.twoBalls then
      gameStats.twoBalls = true
      tfm.exec.chatMessage("<bv>Room Setup: The two-ball mode has been activated<n>", nil)
    end
  elseif globalSettings.mode == "2 teams mode" then
    gameStats.twoTeamsMode = true
    tfm.exec.chatMessage("<bv>Room Setup: The room has been configured for "..globalSettings.mode.."<n>", nil)
    if globalSettings.twoBalls then
      gameStats.twoBalls = true
      tfm.exec.chatMessage("<bv>Room Setup: The two-ball mode has been activated<n>", nil)
    end
  elseif globalSettings.mode == "Real mode" then
    gameStats.realMode = true
    tfm.exec.chatMessage("<bv>Room Setup: The room has been configured for "..globalSettings.mode.."<n>", nil)
  elseif globalSettings.mode == "Normal mode" then
    if globalSettings.twoBalls then
      gameStats.twoBalls = true
      tfm.exec.chatMessage("<bv>Room Setup: The two-ball mode has been activated<n>", nil)
    end
  end

  for name, data in pairs(tfm.get.room.playerList) do
    playerLeftRight[name] = 0
    playerConsumableKey[name] = 56
    playerConsumable[name] = true
    playerConsumableItem[name] = 80
    playerForce[name] = 0
    playerCanTransform[name] = true
    playerInGame[name] = false
    playerCoordinates[name] = {x = 0, y = 0}
    playerPhysicId[name] = 0
    playersOnGameHistoric[name] = { teams = {} }
    playersAfk[name] = os.time()
    system.bindKeyboard(name, 32, true, true)
    system.bindKeyboard(name, 0, true, true)
    system.bindKeyboard(name, 1, true, true)
    system.bindKeyboard(name, 2, true, true)
    system.bindKeyboard(name, 3, true, true)
    system.bindKeyboard(name, 49, true, true)
    system.bindKeyboard(name, 50, true, true)
    system.bindKeyboard(name, 51, true, true)
    system.bindKeyboard(name, 52, true, true)
    system.bindKeyboard(name, 55, true, true)
    system.bindKeyboard(name, 56, true, true)
    system.bindKeyboard(name, 57, true, true)
    system.bindKeyboard(name, 48, true, true)
    system.bindKeyboard(name, 77, true, true)
    tfm.exec.setNameColor(name, 0xD1D5DB)
    tfm.exec.setPlayerScore(name, 0, false)
    pagesList[name] = {helpPage = 1}
    canVote[name] = true

    if selectMapOpen[name] then
      selectMapPage[name] = 1
      selectMapUI(name)
    end

    if admins[name] then
      ui.addWindow(31, "<p align='center'><font size='13px'><a href='event:settings'>Room settings", name, 180, 370, 150, 30, 1, false, false, _)
    end
  end

  ui.addWindow(23, "<p align='center'><font size='13px'><a href='event:menuOpen'>Menu", nil, 5, 15, 100, 30, 0.2, false, false, _)
  ui.addWindow(30, "<p align='center'><font size='13px'><a href='event:selectMap'>Select a map", nil, 10, 370, 150, 30, 1, false, false, _)
  ui.removeTextArea(0)
  ui.addTextArea(7, "<p align='center'>", nil, 375, 50, 30, 20, 0x161616, 0x161616, 1, false)
  if not gameStats.teamsMode then
    for i = 1, 3 do
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..i.."'>Join", nil, x[i], y[i], 150, 40, 0xE14747, 0xE14747, 1, false)
    end

    for i = 4, 6 do
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..i.."'>Join", nil, x[i], y[i], 150, 40, 0x184F81, 0x184F81, 1, false)
    end

    for i = 8, 10 do
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..(i - 4).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0xE14747, 0xE14747, 1, false)
    end

    for i = 11, 13 do
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..(i - 4).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0x184F81, 0x184F81, 1, false)
    end
  end

  initGame = os.time() + 25000
end

function eventTextAreaCallback(id, name, c)
  if gameStats.initTimer > 2 and gameStats.canJoin then
    if string.sub(c, 1, 11) == "joinTeamRed" and playerInGame[name] == false and playersRed[tonumber(string.sub(c, 12))].name == '' then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 12))
      playerInGame[name] = true
      playersRed[index].name = name
      if index > 3 then
        ui.addTextArea(index + 4, "<p align='center'><font size='14px'><a href='event:leaveTeamRed"..index.."'>"..name.."", nil, x[index + 3], y[index + 3], 150, 40, 0x871F1F, 0x871F1F, 1, false)
      else
        ui.addTextArea(index, "<p align='center'><font size='14px'><a href='event:leaveTeamRed"..index.."'>"..name.."", nil, x[index], y[index], 150, 40, 0x871F1F, 0x871F1F, 1, false)
      end
    elseif string.sub(c, 1, 12) == "leaveTeamRed" and playersRed[tonumber(string.sub(c, 13))].name == name then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 13))
      playerInGame[name] = false
      playersRed[index].name = ''
      if index > 3 then
        ui.addTextArea(index + 4, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..index.."'>Join", nil, x[index + 3], y[index + 3], 150, 40, 0xE14747, 0xE14747, 1, false)
      else
        ui.addTextArea(index, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..index.."'>Join", nil, x[index], y[index], 150, 40, 0xE14747, 0xE14747, 1, false)
      end
    elseif string.sub(c, 1, 12) == "joinTeamBlue" and playerInGame[name] == false and playersBlue[tonumber(string.sub(c, 13)-3)].name == '' then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 13) - 3)
      playerInGame[name] = true
      playersBlue[index].name = name
      if index > 3 then
        ui.addTextArea(index + 7, "<p align='center'><font size='14px'><a href='event:leaveTeamBlue"..(index + 3).."'>"..name.."", nil, x[index + 6], y[index + 6], 150, 40, 0x0B3356, 0x0B3356, 1, false)
      else
        ui.addTextArea(index + 3, "<p align='center'><font size='14px'><a href='event:leaveTeamBlue"..(index + 3).."'>"..name.."", nil, x[index + 3], y[index + 3], 150, 40, 0x0B3356, 0x0B3356, 1, false)
      end
    elseif string.sub(c, 1, 13) == "leaveTeamBlue" and playersBlue[tonumber(string.sub(c, 14)) - 3].name == name then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 14) - 3)
      playerInGame[name] = false
      playersBlue[index].name = ''
      if index > 3 then
        ui.addTextArea(index + 7, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..(index + 3).."'>Join", nil, x[index + 6], y[index + 6], 150, 40, 0x184F81, 0x184F81, 1, false)
      else
        ui.addTextArea(index + 3, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..(index + 3).."'>Join", nil, x[index + 3], y[index + 3], 150, 40, 0x184F81, 0x184F81, 1, false)
      end
    elseif string.sub(c, 1, 14) == "joinTeamYellow" and playerInGame[name] == false and playersYellow[tonumber(string.sub(c, 15))].name == '' then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 15))
      playerInGame[name] = true
      playersYellow[index].name = name

      ui.addTextArea(index + 7, "<p align='center'><font size='14px'><a href='event:leaveTeamYellow"..index.."'>"..name.."", nil, x[index + 6], y[index + 6], 150, 40, 0xB57200, 0xB57200, 1, false)
    elseif string.sub(c, 1, 15) == "leaveTeamYellow" and playersYellow[tonumber(string.sub(c, 16))].name == name then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 16))
      playerInGame[name] = false
      playersYellow[index].name = ''

      ui.addTextArea(index + 7, "<p align='center'><font size='14px'><a href='event:joinTeamYellow"..index.."'>Join", nil, x[index + 6], y[index + 6], 150, 40, 0xF59E0B, 0xF59E0B, 1, false)
    elseif string.sub(c, 1, 13) == "joinTeamGreen" and playerInGame[name] == false and playersGreen[tonumber(string.sub(c, 14))].name == '' then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 14))
      playerInGame[name] = true
      playersGreen[index].name = name

      ui.addTextArea(index + 10, "<p align='center'><font size='14px'><a href='event:leaveTeamGreen"..index.."'>"..name.."", nil, x[index + 9], y[index + 9], 150, 40, 0x0C6346, 0x0C6346, 1, false)
    elseif string.sub(c, 1, 14) == "leaveTeamGreen" and playersGreen[tonumber(string.sub(c, 15))].name == name then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 15))
      playerInGame[name] = false
      playersGreen[index].name = ''

      ui.addTextArea(index + 10, "<p align='center'><font size='14px'><a href='event:joinTeamGreen"..index.."'>Join", nil, x[index + 9], y[index + 9], 150, 40, 0x109267, 0x109267, 1, false)
    end
  end
  if c == "menuOpen" then
    ui.addWindow(23, "<p align='center'><font size='13px'><a href='event:menuClose'>Menu</a>"..playerLanguage[name].tr.menuOpenText, name, 5, 15, 200, 120, 0.2, false, false, _)
  elseif c == "menuClose" then
    ui.addWindow(23, "<p align='center'><font size='13px'><a href='event:menuOpen'>Menu", name, 5, 15, 100, 30, 0.2, false, false, _)
  elseif c == "howToPlay" then
    removeUITrophies(name)
    openRank[name] = false
    closeRankingUI(name)
    pagesList[name].helpPage = 1
    windowForHelp(name, pagesList[name].helpPage, playerLanguage[name].tr.nextMessage, playerLanguage[name].tr.previousMessage)
  elseif string.sub(c, 1, 8) == "nextHelp" then
    pagesList[name].helpPage = tonumber(string.sub(c, 9))
    windowForHelp(name, pagesList[name].helpPage, playerLanguage[name].tr.nextMessage, playerLanguage[name].tr.previousMessage)
  elseif string.sub(c, 1, 8) == "prevHelp" then
    pagesList[name].helpPage = tonumber(string.sub(c, 9))
    windowForHelp(name, pagesList[name].helpPage, playerLanguage[name].tr.nextMessage, playerLanguage[name].tr.previousMessage)
  elseif c == "credits" then
    removeUITrophies(name)
    openRank[name] = false
    closeRankingUI(name)
    ui.addWindow(24, ""..playerLanguage[name].tr.creditsTitle..""..playerLanguage[name].tr.creditsText.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
  elseif c == "realmode" then
    removeUITrophies(name)
    openRank[name] = false
    closeRankingUI(name)
    ui.addWindow(266, ""..playerLanguage[name].tr.realModeRules.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
  elseif c == "closeWindow" then
    closeAllWindows(name)
  elseif c == "roomadmin" then
    tfm.exec.chatMessage("<rose>/room *#volley0"..name.."<n>", name)
  elseif string.sub(c, 1, 4) == "sync" then
    local playerSync = string.sub(c, 5)

    print(playerLeft[name])

    if playerLeft[playerSync] then
      tfm.exec.chatMessage("<bv>Player not found, choose another player<n>", name)
      windowUISync(name)
    else
      closeWindow(24, name)
      tfm.exec.setPlayerSync(playerSync)
      tfm.exec.chatMessage("<bv>Set new player sync: "..playerSync.."<n>", nil)
    end
  elseif c == "openMode" and admins[name] then
    settingsMode[name] = true
    local modes = getActionsModes()
    local str = ''
    for i = 1, #modes do
      str = ""..str..""..modes[i].."<br>"
    end
    ui.addWindow(25, "<p align='center'><font size='11px'><a href='event:closeMode'>Select a mode</a><br><br>"..str.."", name, 665, 110, 100, 100, 1, false, false)
  elseif c:sub(1, 7) == "setMode" then
    local modes = getModesText()
    local index = tonumber(c:sub(8))

    globalSettings.mode = modes[index]
    messageLog("<bv>The room has been set to "..modes[index]..", selected by the admin "..name.."<n>")
    updateSettingsUI()
  elseif c == "twoballs" and admins[name] then
    if globalSettings.twoBalls then
      globalSettings.twoBalls = false
      messageLog("<bv>The two balls command was disabled globally in the room in 4-team mode, selected by the admin "..name.."<n>")
    else
      globalSettings.twoBalls = true
      messageLog("<bv>The two balls command was enabled globally in the room in 4-team mode, selected by the admin "..name.."<n>")
    end

    updateSettingsUI()
  elseif c == "closeMode" then
    settingsMode[name] = false
    ui.addWindow(25, "<p align='center'><font size='11px'><a href='event:openMode'>Select a mode</a>", name, 665, 110, 100, 30, 1, false, false)
  elseif c == "ranking" then
    removeUITrophies(name)
    openRank[name] = true
    ui.addWindow(24, "<p align='center'><font size='15px'>", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
    ui.addTextArea(9999543, "<p align='center'>Room Ranking", name, 17, 168, 100, 20, 0x142b2e, 0x8a583c, 1, true)
    ui.addTextArea(9999544, "<p align='center'><n2>Global Ranking<n>", name, 17, 268, 100, 18, 0x142b2e, 0x8a583c, 1, true)
    showMode(playerRankingMode[name], name)
  elseif c == "Normal mode" then
    playerRankingMode[name] = "Normal mode"

    showMode(playerRankingMode[name], name)
  elseif c == "4 teams mode" then
    playerRankingMode[name] = "4 teams mode"

    showMode(playerRankingMode[name], name)
  elseif c == "2 teams mode" then
    playerRankingMode[name] = "2 teams mode"

    showMode(playerRankingMode[name], name)
  elseif c == "Real mode" then
    playerRankingMode[name] = "Real mode"

    showMode(playerRankingMode[name], name)
  elseif string.sub(c, 1, 8) == "prevRank" then
    local index = tonumber(string.sub(c, 9))

    if playerRankingMode[name] == "Normal mode" then
      pageNormalMode[name] = index
      showMode(playerRankingMode[name], name)
    elseif playerRankingMode[name] == "4 teams mode" then
      pageFourTeamsMode[name] = index
      showMode(playerRankingMode[name], name)
    elseif playerRankingMode[name] == "2 teams mode" then
      pageTwoTeamsMode[name] = index
      showMode(playerRankingMode[name], name)
    elseif playerRankingMode[name] == "Real mode" then
      pageRealMode[name] = index
      showMode(playerRankingMode[name], name)
    end
  elseif string.sub(c, 1, 8) == "nextRank" then
    local index = tonumber(string.sub(c, 9))

    if playerRankingMode[name] == "Normal mode" then
      pageNormalMode[name] = index
      showMode(playerRankingMode[name], name)
    elseif playerRankingMode[name] == "4 teams mode" then
      pageFourTeamsMode[name] = index
      showMode(playerRankingMode[name], name)
    elseif playerRankingMode[name] == "2 teams mode" then
      pageTwoTeamsMode[name] = index
      showMode(playerRankingMode[name], name)
    elseif playerRankingMode[name] == "Real mode" then
      pageRealMode[name] = index
      showMode(playerRankingMode[name], name)
    end
  elseif string.sub(c, 1, 7) == "trophie" then
    local index = tonumber(string.sub(c, 8))

    tfm.exec.chatMessage("<ce>"..playerLanguage[name].tr.msgsTrophies[index].."<n>", name)
    print("<ce>"..playerLanguage[name].tr.msgsTrophies[index].."<n>")

    if playerAchievements[name][index].quantity >= 1 then
      removePlayerTrophy(name)
      closeAllWindows(name)
      playerTrophyImage[name] = tfm.exec.addImage(playerAchievements[name][index].image, "$"..name, -20, -105, nil)
      tfm.exec.playEmote(name, 0)
      removePlayerTrophyImage(name)
    end
  elseif c == "selectMap" then
    closeAllWindows(name)
    ui.addWindow(24, "<p align='center'><font size='15px'>"..playerLanguage[name].tr.mapSelect.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
    selectMapOpen[name] = true
    selectMapPage[name] = 1
    selectMapUI(name)
  elseif string.sub(c, 1, 13) == "nextSelectMap" or string.sub(c, 1, 13) == "prevSelectMap" then
    local index = tonumber(string.sub(c, 14))
    selectMapPage[name] = index
    selectMapUI(name)
  elseif string.sub(c, 1, 3) == "map" then
    tfm.exec.chatMessage('<bv>'..string.sub(c, 4)..'<n>', name)
  elseif string.sub(c, 1, 7) == "votemap" and canVote[name] and not gameStats.realMode and mode == "startGame" then
    local index = tonumber(string.sub(c, 8))
    local maps = configSelectMap()

    if mapsVotes[index] == nil then
      mapsVotes[index] = 0
    end

    mapsVotes[index] = mapsVotes[index] + 1
    canVote[name] = false
    gameStats.totalVotes = gameStats.totalVotes + 1
    verifyMostMapVoted()

    for name1, data in pairs(tfm.get.room.playerList) do
      if selectMapPage[name] == selectMapPage[name1] and selectMapOpen[name1] then
        selectMapUI(name1)
      end
    end

    tfm.exec.chatMessage("<bv>"..name.." voted for the "..maps[index][3].." map ("..tostring(mapsVotes[index]).." votes), type !maps to see the maps list and to vote !votemap (number)<n>", nil)
  elseif string.sub(c, 1, 6)  == "setmap" and customMapCommand[name] and not gameStats.realMode and mode == "startGame" and admins[name] then
    local index = tonumber(string.sub(c, 7))
    local maps = configSelectMap()

    customMapCommand[name] = false

    customMapCommandDelay = addTimer(function(i)
      if i == 1 then
        customMapCommand[name] = true
      end
    end, 2000, 1, "customMapCommandDelay")

    gameStats.isCustomMap = true
    gameStats.customMapIndex = index

    tfm.exec.chatMessage('<bv>'..maps[gameStats.customMapIndex][3]..' map (created by '..maps[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>', nil)
    print('<bv>'..maps[gameStats.customMapIndex][3]..' map (created by '..maps[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>')

    for name1, data in pairs(tfm.get.room.playerList) do
      if selectMapOpen[name1] then
        selectMapUI(name1)
      end
    end
  elseif c == "settings" and admins[name] then
    closeRankingUI(name)
    removeUITrophies(name)
    settings[name] = true
    ui.addWindow(24, ""..playerLanguage[name].tr.titleSettings.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
    ui.addTextArea(99992, ""..playerLanguage[name].tr.textSettings, name, 150, 110, 500, 200, 0x161616, 0x161616, 0, true)
    ui.addWindow(25, "<p align='center'><font size='11px'><a href='event:openMode'>Select a mode</a>", name, 665, 110, 100, 30, 1, false, false)
    if globalSettings.twoBalls then
      ui.addWindow(21, "<p align='center'><font size='11px'><a href='event:twoballs'>Enabled</a>", name, 665, 250, 100, 30, 1, false, false)

      return
    end
    ui.addWindow(21, "<p align='center'><font size='11px'><a href='event:twoballs'>Disabled</a>", name, 665, 250, 100, 30, 1, false, false)
  end
end

function eventLoop(elapsedTime, remainingTime)
  if mode == "startGame" then
    local x = math.ceil((initGame - os.time())/1000)
    local c = string.format("%d", x)
    gameStats.initTimer = x
    ui.addTextArea(7, "<p align='center'>"..c.."", nil, 375, 50, 30, 20, 0x161616, 0x161616, 1, false)
    if x == 0 then
      local playersOnGame = quantityPlayers()

      if gameStats.realMode then
        if playersOnGame.red >= 2 and playersOnGame.blue >= 2 then
          rankCrown = rankRealMode
          rulesTimer = os.time() + 10000
          mode = "showRules"
          for name, data in pairs(tfm.get.room.playerList) do
            ui.addWindow(266, ""..playerLanguage[name].tr.realModeRules.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
          end
          removeWindowsOnBottom()

          return
        else
          initGame = os.time() + 25000
          return
        end
      end

      if gameStats.teamsMode then
        if playersOnGame.red >= 1 and playersOnGame.blue >= 1 and playersOnGame.yellow >= 1 and playersOnGame.green >= 1 then
          gameStats.actualMode = "4 teams mode"
          rankCrown = rankFourTeamsMode
          removeTextAreasOfLobby()
          removeWindowsOnBottom()
          gameStats.yellowX = 399
          gameStats.redX = 799
          gameStats.blueX = 1199
          gameStats.greenX = 1201

          mode = "gameStart"
          gameStats.typeMap = "large4v4"
          startGame()

          return
        else
          initGame = os.time() + 25000
          return
        end
      end

      if gameStats.twoTeamsMode then
        if playersOnGame.red >= 2 and playersOnGame.blue >= 2 then
          rankCrown = rankTwoTeamsMode
          removeTextAreasOfLobby()
          removeWindowsOnBottom()
          gameStats.blueX = 399
          gameStats.redX = 799
          gameStats.blueX2 = 1199
          gameStats.redX2 = 1201

          mode = "gameStart"
          gameStats.typeMap = "large4v4"
          startGame()

          return
        else
          initGame = os.time() + 25000

          return
        end
      end

      if playersOnGame.red >= 1 and playersOnGame.blue >= 1 then
        removeTextAreasOfLobby()
        removeWindowsOnBottom()
        rankCrown = rankNormalMode
        if playersOnGame.red <= 3 or playersOnGame.blue <= 3 then
          gameStats.gameMode = "3v3"
          gameStats.redX = 399
          gameStats.blueX = 401
        end

        if playersOnGame.red >= 4 or playersOnGame.blue >= 4 then
          gameStats.gameMode = "4v4"
          gameStats.redX = 599
          gameStats.blueX = 601
        end
        mode = "gameStart"
        startGame()
      else
        initGame = os.time() + 25000
      end
    end
  elseif mode == "showRules" then
    local x = math.ceil((rulesTimer - os.time())/1000)
    local c = string.format("%d", x)

    if x == 0 then
      gameStats.redX = 601
      gameStats.blueX = 1999
      closeWindow(266, nil)
      mode = "gameStart"
      startGame()
    end
  elseif mode == "endGame" then
    local x = math.ceil((gameTimeEnd - os.time())/1000)
    local c = string.format("%d", x)
    if x == 0 then
      countMatches = countMatches + 1
      ui.removeTextArea(899899)
      ui.removeTextArea(8998991)
      removeTimer('verifyBallCoordinates')
      init()
    end
  end
  timersLoop()
end

function quantityPlayers()
  local quantity = {red = 0, blue = 0}
  if gameStats.teamsMode then
    quantity = {red = 0, blue = 0, yellow = 0, green = 0}
  end


  for i = 1, #playersRed do
    if playersRed[i].name ~= '' then
      quantity.red = quantity.red + 1
    end
  end
  for i = 1, #playersBlue do
    if playersBlue[i].name ~= '' then
      quantity.blue = quantity.blue + 1
    end
  end

  if gameStats.teamsMode then
    for i = 1, #playersYellow do
      if playersYellow[i].name ~= '' then
        quantity.yellow = quantity.yellow + 1
      end
    end
    for i = 1, #playersGreen do
      if playersGreen[i].name ~= '' then
        quantity.green = quantity.green + 1
      end
    end
  end

  return quantity
end

function startGame()
  gameStats.canTransform = false
  disablePlayersCanTransform(1500)

  addMatchesToAllPlayers()
  selectMap()

  tfm.exec.addPhysicObject (99999, 800, 460, {
    type = 15,
    width = 3000,
    height = 100,
    miceCollision = false,
    groundCollision = false
  })
  enableAfkMode()
  removeTextAreasOfLobby()
  showTheScore()
  delaySpawnBall = addTimer(function(i)
    if i == 1 then
      teleportPlayers()
      spawnInitialBall()
    end
  end, 1500)
  verifyIsPoint()
  showCrownToAllPlayers()
  mode = "gameStart"
  tfm.exec.chatMessage("<ch>If you don't want to see the ranking crowns, type the command !crown false<n>", nil)
end

function enableAfkMode()
  local enableAfkSystem1 = addTimer(function(i)
    if i == 1 then
      gameStats.enableAfkMode = true
    end
  end, 5000, 1, "enableAfkSystem1")
end

function selectMap()
  local maps = {
    [1] = '<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>',
    [2] = '<C><P L="1200" F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="600" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="600" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/></S><D><P X="899" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>',
    [3] = '<C><P L="1800" F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="900" Y="400" L="1800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="901" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0,0,0,0,0" o="6a7495"/><S T="12" X="1800" Y="0" L="10" H="3000" P="0,0,0.2,0,0,0,0,0" o="6a7495"/><S T="13" X="300" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="900" Y="0" L="1800" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="900" Y="95" L="1800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1500" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="901" Y="225" L="1800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="900" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1550" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="900" Y="-800" L="1800" H="10" P="0,0,0,0.2,0,0,0,0"/></S><D><P X="1499" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>'
  }

  if gameStats.realMode then
    tfm.exec.newGame('<C><P L="2600" F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="1300" Y="400" L="2600" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="1300" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0,0,0,0,0" o="6a7495"/><S T="12" X="2600" Y="0" L="10" H="3000" P="0,0,0.2,0,0,0,0,0" o="6a7495"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="1900" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="1200" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="1300" Y="0" L="2600" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="1300" Y="95" L="2600" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="2300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="225" L="2600" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="788" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="1300" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1400" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="1300" Y="-800" L="2600" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="4" X="600" Y="850" L="10" H="1000" P="0,0,20,0.2,0,0,0,0" c="2"/><S T="4" X="2000" Y="850" L="10" H="1000" P="0,0,20,0.2,0,0,0,0" c="2"/><S T="4" X="600" Y="355" L="10" H="10" P="0,0,20,0.2,30,0,0,0" c="2"/><S T="4" X="2000" Y="355" L="10" H="10" P="0,0,20,0.2,30,0,0,0" c="2"/><S T="12" X="600" Y="850" L="10" H="1000" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="4" N=""/><S T="12" X="2000" Y="850" L="10" H="1000" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" c="4" N=""/></S><D><P X="1899" Y="365" T="10" P="1,0"/><P X="700" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>')
    return
  end

  if gameStats.teamsMode then
    if mapsToTest[1] ~= "" then
      tfm.exec.newGame(mapsToTest[1])
      local foundMap = addTimer(function(i)
        if i == 1 then
          foundBallSpawnsOnMap(mapsToTest[1], false)
          foundMiceSpawnsOnMap(mapsToTest[1], false)
        end
      end, 1000)

      return
    end
    if gameStats.isCustomMap then
      tfm.exec.newGame(customMapsFourTeamsMode[gameStats.customMapIndex][1])
      foundBallSpawnsOnMap(customMapsFourTeamsMode[gameStats.customMapIndex][1], false)
      foundMiceSpawnsOnMap(customMapsFourTeamsMode[gameStats.customMapIndex][1], false)

      return
    end
    if gameStats.totalVotes == 1 then
      tfm.exec.chatMessage('<bv>It is necessary that at least 2 players have used the !votemap command for a map to be selected<n>', nil)
    end
    if gameStats.totalVotes >= 2 then
      tfm.exec.newGame(customMapsFourTeamsMode[gameStats.mapIndexSelected][1])
      foundBallSpawnsOnMap(customMapsFourTeamsMode[gameStats.mapIndexSelected][1], false)
      foundMiceSpawnsOnMap(customMapsFourTeamsMode[gameStats.mapIndexSelected][1], false)
      tfm.exec.chatMessage("<bv>The "..customMapsFourTeamsMode[gameStats.mapIndexSelected][3].." map (created by "..customMapsFourTeamsMode[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>", nil)
      print("<bv>The "..customMapsFourTeamsMode[gameStats.mapIndexSelected][3].." map (created by "..customMapsFourTeamsMode[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>")

      return
    end
    local defaultMap = '<C><P L="1600" F="3" G="0,4" MEDATA="29,1;;;;-0;0:::1-"/><Z><S><S T="7" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>'
    tfm.exec.newGame(defaultMap)
    return
  end

  if gameStats.twoTeamsMode then
    if mapsToTest[1] ~= "" then
      tfm.exec.newGame(mapsToTest[1])
      local foundMap = addTimer(function(i)
        if i == 1 then
          foundBallSpawnsOnMap(mapsToTest[1], false)
          foundMiceSpawnsOnMap(mapsToTest[1], false)
        end
      end, 1000)

      return
    end
    if gameStats.isCustomMap then
      tfm.exec.newGame(customMapsFourTeamsMode[gameStats.customMapIndex][1])
      foundBallSpawnsOnMap(customMapsFourTeamsMode[gameStats.customMapIndex][1], false)
      foundMiceSpawnsOnMap(customMapsFourTeamsMode[gameStats.customMapIndex][1], false)

      return
    end
    if gameStats.totalVotes == 1 then
      tfm.exec.chatMessage('<bv>It is necessary that at least 2 players have used the !votemap command for a map to be selected<n>', nil)
    end
    if gameStats.totalVotes >= 2 then
      tfm.exec.newGame(customMapsFourTeamsMode[gameStats.mapIndexSelected][1])
      foundBallSpawnsOnMap(customMapsFourTeamsMode[gameStats.mapIndexSelected][1], false)
      foundMiceSpawnsOnMap(customMapsFourTeamsMode[gameStats.mapIndexSelected][1], false)
      tfm.exec.chatMessage("<bv>The "..customMapsFourTeamsMode[gameStats.mapIndexSelected][3].." map (created by "..customMapsFourTeamsMode[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>", nil)
      print("<bv>The "..customMapsFourTeamsMode[gameStats.mapIndexSelected][3].." map (created by "..customMapsFourTeamsMode[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>")

      return
    end
    tfm.exec.newGame('<C><P L="1600" F="3" G="0,4" MEDATA="29,1;;;;-0;0:::1-"/><Z><S><S T="7" X="805" Y="400" L="1610" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1600" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="790" Y="0" L="1620" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="790" Y="95" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="1300" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="790" Y="225" L="1620" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1350" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="13" X="1000" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="1" X="1200" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="1200" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="1200" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1000" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="999" Y="363" T="10" P="1,0"/><P X="1499" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>')
    return
  end

  if gameStats.setMapName == "" then
    if gameStats.gameMode == "3v3" then
      if mapsToTest[1] ~= "" then
        tfm.exec.newGame(mapsToTest[1])
        local foundMap = addTimer(function(i)
          if i == 1 then
            foundBallSpawnsOnMap(mapsToTest[1], false)
            foundMiceSpawnsOnMap(mapsToTest[1], false)
          end
        end, 1000)

        return
      end
      if gameStats.isCustomMap then
        tfm.exec.newGame(customMaps[gameStats.customMapIndex][1])
        foundBallSpawnsOnMap(customMaps[gameStats.customMapIndex][1], false)
        foundMiceSpawnsOnMap(customMaps[gameStats.customMapIndex][1], false)
      else
        if gameStats.totalVotes == 1 then
          tfm.exec.chatMessage('<bv>It is necessary that at least 2 players have used the !votemap command for a map to be selected<n>', nil)
        end
        if gameStats.totalVotes >= 2 then
          tfm.exec.newGame(customMaps[gameStats.mapIndexSelected][1])
          foundBallSpawnsOnMap(customMaps[gameStats.mapIndexSelected][1], false)
          foundMiceSpawnsOnMap(customMaps[gameStats.mapIndexSelected][1], false)
          tfm.exec.chatMessage("<bv>The "..customMaps[gameStats.mapIndexSelected][3].." map (created by "..customMaps[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>", nil)
          print("<bv>The "..customMaps[gameStats.mapIndexSelected][3].." map (created by "..customMaps[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>")
        else
          tfm.exec.newGame(maps[1])
        end

      end

    else
      if mapsToTest[1] ~= "" then
        tfm.exec.newGame(mapsToTest[1])
        local foundMap = addTimer(function(i)
          if i == 1 then
            foundBallSpawnsOnMap(mapsToTest[1], true)
            foundMiceSpawnsOnMap(mapsToTest[1], true)
          end
        end, 1000)

        return
      end
      if gameStats.isCustomMap then
        tfm.exec.newGame(customMaps[gameStats.customMapIndex][2])
        foundBallSpawnsOnMap(customMaps[gameStats.customMapIndex][2], true)
        foundMiceSpawnsOnMap(customMaps[gameStats.customMapIndex][2], true)
      else
        if gameStats.totalVotes == 1 then
          tfm.exec.chatMessage('<bv>It is necessary that at least 2 players have used the !votemap command for a map to be selected<n>', nil)
        end
        if gameStats.totalVotes >= 2 then
          tfm.exec.newGame(customMaps[gameStats.mapIndexSelected][2])
          foundBallSpawnsOnMap(customMaps[gameStats.mapIndexSelected][2], true)
          foundMiceSpawnsOnMap(customMaps[gameStats.mapIndexSelected][2], true)
          tfm.exec.chatMessage("<bv>The "..customMaps[gameStats.mapIndexSelected][3].." map (created by "..customMaps[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>", nil)
        else
          tfm.exec.newGame(maps[2])
        end
      end
    end
  else
    if gameStats.setMapName == "small" then
      gameStats.gameMode = "3v3"
      gameStats.redX = 399
      gameStats.blueX = 401
      if mapsToTest[1] ~= "" then
        tfm.exec.newGame(mapsToTest[1])
        local foundMap = addTimer(function(i)
          if i == 1 then
            foundBallSpawnsOnMap(mapsToTest[1], false)
            foundMiceSpawnsOnMap(mapsToTest[1], false)
          end
        end, 1000)

        return
      end
      if gameStats.isCustomMap then
        tfm.exec.newGame(customMaps[gameStats.customMapIndex][1])
        foundBallSpawnsOnMap(customMaps[gameStats.customMapIndex][1], false)
        foundMiceSpawnsOnMap(customMaps[gameStats.customMapIndex][1], false)
      else
        if gameStats.totalVotes == 1 then
          tfm.exec.chatMessage('<bv>It is necessary that at least 2 players have used the !votemap command for a map to be selected<n>', nil)
        end
        if gameStats.totalVotes >= 2 then
          tfm.exec.newGame(customMaps[gameStats.mapIndexSelected][1])
          foundBallSpawnsOnMap(customMaps[gameStats.mapIndexSelected][1], false)
          foundMiceSpawnsOnMap(customMaps[gameStats.mapIndexSelected][1], false)
          tfm.exec.chatMessage("<bv>The "..customMaps[gameStats.mapIndexSelected][3].." map (created by "..customMaps[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>", nil)
        else
          tfm.exec.newGame(maps[1])
        end
      end
    elseif gameStats.setMapName == "large" then
      gameStats.gameMode = "4v4"
      gameStats.redX = 599
      gameStats.blueX = 601
      if mapsToTest[1] ~= "" then
        tfm.exec.newGame(mapsToTest[1])
        local foundMap = addTimer(function(i)
          if i == 1 then
            foundBallSpawnsOnMap(mapsToTest[1], true)
            foundMiceSpawnsOnMap(mapsToTest[1], true)
          end
        end, 1000)
        return
      end
      if gameStats.isCustomMap then
        tfm.exec.newGame(customMaps[gameStats.customMapIndex][2])
        foundBallSpawnsOnMap(customMaps[gameStats.customMapIndex][2], true)
        foundMiceSpawnsOnMap(customMaps[gameStats.customMapIndex][2], true)
      else
        if gameStats.totalVotes == 1 then
          tfm.exec.chatMessage('<bv>It is necessary that at least 2 players have used the !votemap command for a map to be selected<n>', nil)
        end
        if gameStats.totalVotes >= 2 then
          tfm.exec.newGame(customMaps[gameStats.mapIndexSelected][2])
          foundBallSpawnsOnMap(customMaps[gameStats.mapIndexSelected][2], true)
          foundMiceSpawnsOnMap(customMaps[gameStats.mapIndexSelected][2], true)
          tfm.exec.chatMessage("<bv>The "..customMaps[gameStats.mapIndexSelected][3].." map (created by "..customMaps[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>", nil)
        else
          tfm.exec.newGame(maps[2])
        end
      end
    elseif gameStats.setMapName == "extra-large" then
      gameStats.gameMode = "6v6"
      gameStats.redX = 899
      gameStats.blueX = 901

      tfm.exec.newGame(maps[3])
    end
  end
end

function spawnInitialBall()
  local x = {}

  if gameStats.teamsMode and gameStats.typeMap == "large4v4" or gameStats.twoTeamsMode then
    local spawnBalls = { spawnBallArea400, spawnBallArea800, spawnBallArea1200, spawnBallArea1600 }

    x = {200, 600, 1000, 1400}

    spawnBallConfig(spawnBalls, x)

    return
  elseif gameStats.teamsMode and gameStats.typeMap == "large3v3" then
    x = {200, 600, 1000}
    local spawnBalls = { spawnBallArea400, spawnBallArea800, spawnBallArea1200 }

    spawnBallConfig(spawnBalls, x)

    return
  elseif gameStats.teamsMode and gameStats.typeMap == "small" then
    x = {200, 600}
    local spawnBalls = { spawnBallArea400, spawnBallArea800 }

    spawnBallConfig(spawnBalls, x)

    return
  end

  if gameStats.realMode then
    ballOnGame = false
    local team = chooseInitialPlayer()

    print(team)
    gameStats.reduceForce = true
    if team == "red" then
      gameStats.aceRed = true
      gameStats.redLimitSpawn = 1
      local delaySpawnBall = addTimer(function(i)
        if i == 1 then
          if gameStats.customBall then
            ball_id = tfm.exec.addShamanObject(balls[gameStats.customBallId].id, 700, 50, 0, 0, -5, true)
            if balls[gameStats.customBallId].isImage then
              tfm.exec.addImage(balls[gameStats.customBallId].image, "#"..ball_id, -15, -15, nil, 1, 1, _, 1)
            end
          else
            ball_id = tfm.exec.addShamanObject(6, 700, 50, 0, 0, -5, true)
          end
        end
      end, 4000, 1, "delaySpawnBall")
    elseif team == "blue" then
      gameStats.aceBlue = true
      gameStats.blueLimitSpawn = 1
      local delaySpawnBall = addTimer(function(i)
        if i == 1 then
          if gameStats.customBall then
            ball_id = tfm.exec.addShamanObject(balls[gameStats.customBallId].id, 1900, 50, 0, 0, -5, true)
            if balls[gameStats.customBallId].isImage then
              tfm.exec.addImage(balls[gameStats.customBallId].image, "#"..ball_id, -15, -15, nil, 1, 1, _, 1)
            end
          else
            ball_id = tfm.exec.addShamanObject(6, 1900, 50, 0, 0, -5, true)
          end
        end
      end, 4000, 1, "delaySpawnBall")
    end

    showTheScore()

    delayToVerifyBall = addTimer(function(i)
      if i == 1 then
        ballOnGame = true
      end
    end, 2000, 1, "delayToVerifyBall")
    return
  end

  local spawnBalls = {}
  if gameStats.gameMode == "3v3" then
    x = {200, 600}
    spawnBalls = {spawnBallArea400, spawnBallArea800}
  elseif gameStats.gameMode == "4v4" then
    x = {400, 800}
    spawnBalls = {spawnBallArea800, spawnBallArea1600}
  else
    gameStats.psyhicObjectForce = 1.2
    x = {400, 1400}
  end

  print(x)

  spawnBallConfig(spawnBalls, x)
  ballOnGame = true
  updateTwoBallOnGame()
end

function choosePlayerServe(team)
  print(team)
  gameStats.redServe = false
  gameStats.blueServe = false
  gameStats.lastPlayerRed = ""
  gameStats.lastPlayerBlue = ""

  if gameStats.aceRed then
    tfm.exec.movePlayer(gameStats.redPlayerServe, 700, 334)
    tfm.exec.chatMessage("<bv>"..gameStats.redPlayerServe.." will serve the ball<n>", nil)
    print("red condition ace")
    print("<bv>"..gameStats.redPlayerServe.." will serve the ball<n>")
    return chooseTeam
  end

  if gameStats.aceBlue then
    tfm.exec.movePlayer(gameStats.bluePlayerServe, 1900, 334)
    tfm.exec.chatMessage("<bv>"..gameStats.bluePlayerServe.." will serve the ball<n>", nil)
    print("blue condition ace")
    print("<bv>"..gameStats.bluePlayerServe.." will serve the ball<n>")
    return chooseTeam
  end


  if team == "red" then
    if gameStats.redServeIndex == 6 then
      for i = 1, 6 do
        if playersRed[i].name ~= "" then
          gameStats.redServeIndex = i
          gameStats.redPlayerServe = playersRed[i].name
          gameStats.redServe = true
          gameStats.aceRed = true
          tfm.exec.movePlayer(playersRed[i].name, 700, 334)
          tfm.exec.chatMessage("<bv>"..playersRed[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersRed[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end
    else
      for i = gameStats.redServeIndex, 6 do
        if playersRed[i].name ~= "" and gameStats.redServeIndex ~= i then
          gameStats.redServeIndex = i
          gameStats.redPlayerServe = playersRed[i].name
          gameStats.redServe = true
          gameStats.aceRed = true
          tfm.exec.movePlayer(playersRed[i].name, 700, 334)
          tfm.exec.chatMessage("<bv>"..playersRed[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersRed[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end

      for i = 1, gameStats.redServeIndex do
        if playersRed[i].name ~= "" then
          gameStats.redServeIndex = i
          gameStats.redPlayerServe = playersRed[i].name
          gameStats.redServe = true
          gameStats.aceRed = true
          tfm.exec.movePlayer(playersRed[i].name, 700, 334)
          tfm.exec.chatMessage("<bv>"..playersRed[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersRed[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end
    end
    gameStats.redServe = true
    gameStats.aceRed = true
  elseif team == "blue" then
    if gameStats.blueServeIndex == 6 then
      for i = 1, 6 do
        if playersBlue[i].name ~= "" then
          gameStats.blueServeIndex = i
          gameStats.bluePlayerServe = playersBlue[i].name
          gameStats.blueServe = true
          gameStats.aceBlue = true
          tfm.exec.movePlayer(playersBlue[i].name, 1900, 334)
          tfm.exec.chatMessage("<bv>"..playersBlue[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersBlue[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end
    else
      for i = gameStats.blueServeIndex, 6 do
        if playersBlue[i].name ~= "" and gameStats.blueServeIndex ~= i then
          gameStats.blueServeIndex = i
          gameStats.bluePlayerServe = playersBlue[i].name
          gameStats.blueServe = true
          gameStats.aceBlue = true
          tfm.exec.movePlayer(playersBlue[i].name, 1900, 334)
          tfm.exec.chatMessage("<bv>"..playersBlue[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersBlue[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end

      for i = 1, gameStats.blueServeIndex do
        if playersBlue[i].name ~= "" then
          gameStats.blueServeIndex = i
          gameStats.bluePlayerServe = playersBlue[i].name
          gameStats.blueServe = true
          gameStats.aceBlue = true
          tfm.exec.movePlayer(playersBlue[i].name, 1900, 334)
          tfm.exec.chatMessage("<bv>"..playersBlue[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersBlue[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end
    end

    gameStats.blueServe = true
    gameStats.aceBlue = true
  end
end

function chooseInitialPlayer()
  local teams = {"red", "blue"}

  local chooseTeam = teams[math.random(1, #teams)]

  if chooseTeam == "red" then
    gameStats.redServeIndex = math.random(1, 6)
    if gameStats.redServeIndex == 6 then
      for i = 1, 6 do
        if playersRed[i].name ~= "" then
          gameStats.redServeIndex = i
          gameStats.redPlayerServe = playersRed[i].name
          gameStats.redServe = true
          tfm.exec.movePlayer(playersRed[i].name, 700, 334)
          tfm.exec.chatMessage("<bv>"..playersRed[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersRed[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end
    else
      for i = gameStats.redServeIndex, 6 do
        if playersRed[i].name ~= "" and gameStats.redServeIndex ~= i then
          gameStats.redServeIndex = i
          gameStats.redPlayerServe = playersRed[i].name
          gameStats.redServe = true
          tfm.exec.movePlayer(playersRed[i].name, 700, 334)
          tfm.exec.chatMessage("<bv>"..playersRed[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersRed[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end

      for i = 1, gameStats.redServeIndex do
        if playersRed[i].name ~= "" then
          gameStats.redServeIndex = i
          gameStats.redPlayerServe = playersRed[i].name
          gameStats.redServe = true
          tfm.exec.movePlayer(playersRed[i].name, 700, 334)
          tfm.exec.chatMessage("<bv>"..playersRed[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersRed[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end
    end
    gameStats.redServe = true
  elseif chooseTeam == "blue" then
    gameStats.blueServeIndex = math.random(1, 6)
    if gameStats.blueServeIndex == 6 then
      for i = 1, 6 do
        if playersBlue[i].name ~= "" then
          gameStats.blueServeIndex = i
          gameStats.bluePlayerServe = playersBlue[i].name
          gameStats.blueServe = true
          tfm.exec.movePlayer(playersBlue[i], name, 1900, 334)
          tfm.exec.chatMessage("<bv>"..playersBlue[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersBlue[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end
    else
      for i = gameStats.blueServeIndex, 6 do
        if playersBlue[i].name ~= "" and gameStats.blueServeIndex ~= i then
          gameStats.blueServeIndex = i
          gameStats.bluePlayerServe = playersBlue[i].name
          gameStats.blueServe = true
          tfm.exec.movePlayer(playersBlue[i].name, 1900, 334)
          tfm.exec.chatMessage("<bv>"..playersBlue[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersBlue[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end

      for i = 1, gameStats.redServeIndex do
        if playersBlue[i].name ~= "" and gameStats.blueServeIndex ~= i then
          gameStats.blueServeIndex = i
          gameStats.bluePlayerServe = playersBlue[i].name
          gameStats.blueServe = true
          tfm.exec.movePlayer(playersBlue[i].name, 1900, 334)
          tfm.exec.chatMessage("<bv>"..playersBlue[i].name.." will serve the ball<n>", nil)
          print("<bv>"..playersBlue[i].name.." will serve the ball<n>")
          return chooseTeam
        end
      end
    end
    gameStats.blueServe = true
  end

  return chooseTeam

end

function showMessageWinner()
  if gameStats.teamsMode then
    ui.addTextArea(6, "<p align='center'><font size='30px'><textformat leading='150'><br>"..messageWinners[1].."", nil, 0, 0, 800, 400, 0x161616, 0x161616, 0.8, true)
    return
  end
  if score_red >= gameStats.winscore then
    for name, data in pairs(tfm.get.room.playerList) do
      ui.addTextArea(6, "<p align='center'><font size='30px'><textformat leading='150'><br><r>"..playerLanguage[name].tr.msgRedWinner.."<n>", nil, 0, 0, 800, 400, 0x161616, 0x161616, 0.8, true)
    end
  elseif score_blue >= gameStats.winscore then
    for name, data in pairs(tfm.get.room.playerList) do
      ui.addTextArea(6, "<p align='center'><font size='30px'><textformat leading='150'><br><bv>"..playerLanguage[name].tr.msgBlueWinner.."<n>", nil, 0, 0, 800, 400, 0x161616, 0x161616, 0.8, true)
    end
  end
end

function spawnBallRealMode(team)
  gameStats.reduceForce = true
  if team == "red" then
    gameStats.teamWithOutAce = "blue"

    ballOnGame = false
    tfm.exec.removeObject (ball_id)
    gameStats.redServe = true

    if gameStats.customBall then
      ball_id = tfm.exec.addShamanObject(balls[gameStats.customBallId].id, 700, 50, 0, 0, -5, true)
      if balls[gameStats.customBallId].isImage then
        tfm.exec.addImage(balls[gameStats.customBallId].image, "#"..ball_id, -15, -15, nil, 1, 1, _, 1)
      end
    else
      ball_id = tfm.exec.addShamanObject(6, 700, 50, 0, 0, -5, true)
    end

    ballOnGame = true
    showTheScore()
    gameStats.canTransform = true

    return
  elseif team == "blue" then
    gameStats.teamWithOutAce = "red"
    ballOnGame = false
    tfm.exec.removeObject (ball_id)
    gameStats.blueServe = true
    if gameStats.customBall then
      ball_id = tfm.exec.addShamanObject(balls[gameStats.customBallId].id, 1900, 50, 0, 0, -5, true)
      if balls[gameStats.customBallId].isImage then
        tfm.exec.addImage(balls[gameStats.customBallId].image, "#"..ball_id, -15, -15, nil, 1, 1, _, 1)
      end
    else
      ball_id = tfm.exec.addShamanObject(6, 1900, 50, 0, 0, -5, true)
    end

    gameStats.canTransform = true
    ballOnGame = true
    showTheScore()

  end
end

function spawnBall(x, index, y)

  local ballSpawnX = x
  local ballSpawnY = 50
  if y ~= nil then
    ballSpawnY = y
  end

  if index == 1 then
    tfm.exec.removeObject(ball_id)
    ball_id = nil
    ballOnGame = false
    updateTwoBallOnGame()
    showTheScore()

    if gameStats.customBall then
      ball_id = tfm.exec.addShamanObject(balls[gameStats.customBallId].id, ballSpawnX, ballSpawnY, 0, 0, -5, true)
      if balls[gameStats.customBallId].isImage then
        tfm.exec.addImage(balls[gameStats.customBallId].image, "#"..ball_id, -15, -15, nil, 1, 1, _, 1)
      end
      ballOnGame = true
      updateTwoBallOnGame()

      return
    else
      ball_id = tfm.exec.addShamanObject(6, ballSpawnX, ballSpawnY, 0, 0, -5, true)
      ballOnGame = true
      updateTwoBallOnGame()

      return
    end
  elseif index == 2 then
    tfm.exec.removeObject(ball_id2)
    ball_id2 = nil
    ballOnGame2 = false
    updateTwoBallOnGame()
    showTheScore()

    if gameStats.customBall then
      ball_id2 = tfm.exec.addShamanObject(balls[gameStats.customBallId].id, ballSpawnX, ballSpawnY, 0, 0, -5, true)
      if balls[gameStats.customBallId].isImage then
        tfm.exec.addImage(balls[gameStats.customBallId].image, "#"..ball_id2, -15, -15, nil, 1, 1, _, 1)
      end
      ballOnGame2 = true
      updateTwoBallOnGame()

      return
    else
      ball_id2 = tfm.exec.addShamanObject(6, ballSpawnX, ballSpawnY, 0, 0, -5, true)
      ballOnGame2 = true
      updateTwoBallOnGame()

      return
    end
  end
end

function verifyIsPoint()
  verifyBallCoordinates = addTimer(function(i)
    if gameStats.teamsMode and ballOnGame then
      setLostLife()

      return
    end

    if gameStats.twoTeamsMode and ballOnGame then
      verifyIsPointTwoTeamsMode()

      return
    end
    if gameStats.realMode and ballOnGame then
      verifyIsPointRealMode()

      return
    end

    local quantityBalls = 1

    if gameStats.twoBalls then
      quantityBalls = 2
    end

    for j = 1, quantityBalls do
      if ballOnGameTwoBalls[j] and ballsId[j] ~= nil then
        if tfm.get.room.objectList[ballsId[j]].x <= gameStats.redX and tfm.get.room.objectList[ballsId[j]].y >= 368 then
          score_blue = score_blue + 1
          tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
          tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
          if score_blue >= gameStats.winscore then
            ballOnGame = false
            ballOnGame2 = false
            updateTwoBallOnGame()
            tfm.exec.removeObject(ballsId[j])
            showTheScore()
            showMessageWinner()
            normalModeTeamWinner("blue")
            updateRankingNormalMode()
            mode = "endGame"
            gameTimeEnd = os.time() + 5000
          else
            if gameStats.gameMode == "3v3" then
              if #spawnBallArea800 ~= 0 then
                randomIndex = math.random(1, #spawnBallArea800)
                ballSpawnX = spawnBallArea800[randomIndex].x
                ballSpawnY = spawnBallArea800[randomIndex].y
                spawnBall(ballSpawnX, j, ballSpawnY)
              else
                spawnBall(600, j)
              end
            elseif gameStats.gameMode == "4v4" then
              if #spawnBallArea1600 ~= 0 then
                randomIndex = math.random(1, #spawnBallArea1600)
                ballSpawnX = spawnBallArea1600[randomIndex].x
                ballSpawnY = spawnBallArea1600[randomIndex].y
                spawnBall(ballSpawnX, j, ballSpawnY)
              else
                spawnBall(800, j)
              end
            else
              spawnBall(1400, j)
            end
          end
        elseif tfm.get.room.objectList[ballsId[j]].x >= gameStats.blueX and tfm.get.room.objectList[ballsId[j]].y >= 368 then
          score_red = score_red + 1
          tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
          tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
          if score_red >= gameStats.winscore then
            showTheScore()
            showMessageWinner()
            ballOnGame = false
            ballOnGame2 = false
            updateTwoBallOnGame()
            tfm.exec.removeObject(ballsId[j])
            normalModeTeamWinner("red")
            updateRankingNormalMode()
            mode = "endGame"
            gameTimeEnd = os.time() + 5000
          else
            if gameStats.gameMode == "3v3" then
              if #spawnBallArea400 ~= 0 then
                randomIndex = math.random(1, #spawnBallArea400)
                ballSpawnX = spawnBallArea400[randomIndex].x
                ballSpawnY = spawnBallArea400[randomIndex].y
                spawnBall(ballSpawnX, j, ballSpawnY)
              else
                spawnBall(200, j)
              end
            elseif gameStats.gameMode == "4v4" then
              if #spawnBallArea800 ~= 0 then
                randomIndex = math.random(1, #spawnBallArea800)
                ballSpawnX = spawnBallArea800[randomIndex].x
                ballSpawnY = spawnBallArea800[randomIndex].y
                spawnBall(ballSpawnX, j, ballSpawnY)
              else
                spawnBall(400, j)
              end
            else
              spawnBall(400, j)
            end
          end
        end
      end
    end
  end, 5000, 0, "verifyBallCoordinates")
end

function verifyIsPointRealMode()
  local ballX = tfm.get.room.objectList[ball_id].x
  local ballY = tfm.get.room.objectList[ball_id].y

  resetQuantityTeams()

  if ballX <= 599 and ballY >= 368 then
    if gameStats.redQuantitySpawn > 0 or gameStats.redServe then
      gameStats.aceRed = false
      score_blue = score_blue + 1
      tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
    else
      gameStats.aceBlue = false
      score_red = score_red + 1
      tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
    end
    tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
    if score_red >= gameStats.winscore or score_blue >= gameStats.winscore then
      showTheScore()
      showMessageWinner()
      ballOnGame = false
      tfm.exec.removeObject (ball_id)
      if gameStats.redQuantitySpawn > 0 or gameStats.redServe then
        realModeWinner("blue")
      else
        realModeWinner("red")
      end
      updateRankingRealMode()
      mode = "endGame"
      gameTimeEnd = os.time() + 5000
    else
      ballOnGame = false
      if gameStats.redQuantitySpawn > 0 or gameStats.redServe then
        gameStats.canTransform = false
        local delayTeleport = addTimer(function(i)
          if i == 1 then
            choosePlayerServe("blue")
            teamServe("blue")
          end
        end, 4000, 1, "delayTeleport")

        local delaySpawnBall = addTimer(function(i)
          if i == 1 then
            spawnBallRealMode("blue")
          end
        end, 6000, 1, "delaySpawnBall")
      else
        gameStats.canTransform = false
        local delayTeleport = addTimer(function(i)
          if i == 1 then
            choosePlayerServe("red")
            teamServe("red")
          end
        end, 4000, 1, "delayTeleport")

        local delaySpawnBall = addTimer(function(i)
          if i == 1 then
            spawnBallRealMode("red")
          end
        end, 6000, 1, "delaySpawnBall")
      end
    end
    showTheScore()
    return
  elseif ballX >= gameStats.redX and ballX <= 1299 and ballY >= 368 then
    score_blue = score_blue + 1
    gameStats.aceRed = false
    tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
    tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
    if score_blue >= gameStats.winscore then
      ballOnGame = false
      tfm.exec.removeObject (ball_id)
      showTheScore()
      showMessageWinner()
      realModeWinner("blue")
      updateRankingRealMode()
      mode = "endGame"
      gameTimeEnd = os.time() + 5000
    else
      ballOnGame = false
      gameStats.canTransform = false
      local delayTeleport = addTimer(function(i)
        if i == 1 then
          choosePlayerServe("blue")
          teamServe("blue")
        end
      end, 4000, 1, "delayTeleport")

      local delaySpawnBall = addTimer(function(i)
        if i == 1 then
          spawnBallRealMode("blue")
        end
      end, 6000, 1, "delaySpawnBall")
    end
    showTheScore()
    return
  elseif ballX >= 1301 and ballX <= gameStats.blueX and ballY >= 368 then
    score_red = score_red + 1
    gameStats.aceBlue = false
    tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
    tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
    if score_red >= gameStats.winscore then
      showTheScore()
      showMessageWinner()
      realModeWinner("red")
      updateRankingRealMode()
      ballOnGame = false
      tfm.exec.removeObject (ball_id)
      mode = "endGame"
      gameTimeEnd = os.time() + 5000
    else
      ballOnGame = false
      gameStats.canTransform = false
      local delayTeleport = addTimer(function(i)
        if i == 1 then
          choosePlayerServe("red")
          teamServe("red")
        end
      end, 4000, 1, "delayTeleport")

      local delaySpawnBall = addTimer(function(i)
        if i == 1 then
          spawnBallRealMode("red")
        end
      end, 6000, 1, "delaySpawnBall")
    end
    showTheScore()
    return
  elseif ballX >= 2001 and ballY >= 368 then
    if gameStats.blueQuantitySpawn > 0 or gameStats.blueServe then
      gameStats.aceBlue = false
      score_red = score_red + 1
      tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
    else
      gameStats.aceRed = false
      score_blue = score_blue + 1
      tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
    end

    tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
    if score_blue >= gameStats.winscore or score_red >= gameStats.winscore then
      ballOnGame = false
      tfm.exec.removeObject (ball_id)
      showTheScore()
      showMessageWinner()
      if gameStats.blueQuantitySpawn > 0 or gameStats.blueServe then
        realModeWinner("red")
      else
        realModeWinner("blue")
      end
      updateRankingRealMode()
      mode = "endGame"
      gameTimeEnd = os.time() + 5000
    else
      ballOnGame = false
      if gameStats.blueQuantitySpawn > 0 or gameStats.blueServe then
        gameStats.canTransform = false
        local delayTeleport = addTimer(function(i)
          if i == 1 then
            choosePlayerServe("red")
            teamServe("red")
          end
        end, 4000, 1, "delayTeleport")

        local delaySpawnBall = addTimer(function(i)
          if i == 1 then
            spawnBallRealMode("red")
          end
        end, 6000, 1, "delaySpawnBall")
      else
        gameStats.canTransform = false
        local delayTeleport = addTimer(function(i)
          if i == 1 then
            choosePlayerServe("blue")
            teamServe("blue")
          end
        end, 4000, 1, "delayTeleport")

        local delaySpawnBall = addTimer(function(i)
          if i == 1 then
            spawnBallRealMode("blue")
          end
        end, 6000, 1, "delaySpawnBall")
      end
    end
    showTheScore()
    return
  end
end

function verifyIsPointTwoTeamsMode()

  local quantityBalls = 1

  if gameStats.twoBalls then
    quantityBalls = 2
  end

  for j = 1, quantityBalls do
    if ballOnGameTwoBalls[j] and ballsId[j] ~= nil then
      if tfm.get.room.objectList[ballsId[j]].x <= gameStats.blueX and tfm.get.room.objectList[ballsId[j]].y >= 368 then
        score_red = score_red + 1
        tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
        tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
        if score_red >= gameStats.winscore then
          showTheScore()
          showMessageWinner()
          ballOnGame = false
          ballOnGame2 = false
          updateTwoBallOnGame()
          twoTeamsModeWinner("red")
          updateRankingTwoTeamsMode()
          tfm.exec.removeObject (ballsId[j])
          mode = "endGame"
          gameTimeEnd = os.time() + 5000
        else
          if #spawnBallArea800 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea800)
            ballSpawnX = spawnBallArea800[randomIndex].x
            ballSpawnY = spawnBallArea800[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(600, j)
          end
        end
        showTheScore()
      elseif tfm.get.room.objectList[ballsId[j]].x <= gameStats.redX and tfm.get.room.objectList[ballsId[j]].y >= 368 then
        score_blue = score_blue + 1
        tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
        tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
        if score_blue >= gameStats.winscore then
          ballOnGame = false
          ballOnGame2 = false
          updateTwoBallOnGame()
          twoTeamsModeWinner("blue")
          updateRankingTwoTeamsMode()
          tfm.exec.removeObject (ballsId[j])
          showTheScore()
          showMessageWinner()
          mode = "endGame"
          gameTimeEnd = os.time() + 5000
        else
          if #spawnBallArea400 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea400)
            ballSpawnX = spawnBallArea400[randomIndex].x
            ballSpawnY = spawnBallArea400[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(200, j)
          end
        end
        showTheScore()
      elseif tfm.get.room.objectList[ballsId[j]].x <= gameStats.blueX2 and tfm.get.room.objectList[ballsId[j]].y >= 368 then
        score_red = score_red + 1
        tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
        tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
        if score_red >= gameStats.winscore then
          showTheScore()
          showMessageWinner()
          ballOnGame = false
          ballOnGame2 = false
          updateTwoBallOnGame()
          twoTeamsModeWinner("red")
          updateRankingTwoTeamsMode()
          tfm.exec.removeObject (ballsId[j])
          mode = "endGame"
          gameTimeEnd = os.time() + 5000
        else
          if #spawnBallArea1600 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea1600)
            ballSpawnX = spawnBallArea1600[randomIndex].x
            ballSpawnY = spawnBallArea1600[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(1400, j)
          end
        end
        showTheScore()
      elseif tfm.get.room.objectList[ballsId[j]].x >= gameStats.redX2 and tfm.get.room.objectList[ballsId[j]].y >= 368 then
        score_blue = score_blue + 1
        tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
        tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
        if score_blue >= gameStats.winscore then
          ballOnGame = false
          ballOnGame2 = false
          updateTwoBallOnGame()
          twoTeamsModeWinner("blue")
          updateRankingTwoTeamsMode()
          tfm.exec.removeObject (ballsId[j])
          showTheScore()
          showMessageWinner()
          mode = "endGame"
          gameTimeEnd = os.time() + 5000
        else
          if #spawnBallArea1200 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea1200)
            ballSpawnX = spawnBallArea1200[randomIndex].x
            ballSpawnY = spawnBallArea1200[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(1000, j)
          end
        end
        showTheScore()
      end
    end
  end
end

function setLostLife()
  local quantityBalls = 1

  if gameStats.twoBalls then
    quantityBalls = 2
  end

  for j = 1, quantityBalls do
    local onCondition = false
    local lostLife = false

    print(ballsId[j])
    print(ballOnGameTwoBalls[j])
    print('===')
    if gameStats.typeMap == "large4v4" and ballOnGameTwoBalls[j] and ballsId[j] ~= nil then
      if tfm.get.room.objectList[ballsId[j]].x <= gameStats.yellowX and tfm.get.room.objectList[ballsId[j]].y >= 368 and teamsLifes[1].yellow >= 1 and not lostLife then
        lostLife = true
        onCondition = true
        teamsLifes[1].yellow = teamsLifes[1].yellow - 1
        if teamsLifes[1].yellow == 0 then
          ballOnGame = false
          ballOnGame2 = false
          updateTwoBallOnGame()

          for i = 1, #playersYellow do
            tfm.exec.setNameColor(playersYellow[i].name, 0xD1D5DB)
            tfm.exec.movePlayer(playersYellow[i].name, 391, 74)
            playerInGame[playersYellow[i].name] = false
            playersYellow[i].name = ''
          end
          tfm.exec.chatMessage("<j>Yellow team lost all their lives<n>", nil)
          toggleMapType()
          updateTeamsColors(1)
          gameStats.canTransform = false
          disablePlayersCanTransform(4000)
          delayToToggleMap = addTimer(function(i)
            if i == 1 then
              toggleMap()
            end
          end, 3000, 1, "delayToToggleMap")

          return
        end
        tfm.exec.chatMessage("<j>Yellow team lost a life<n>", nil)
        tfm.exec.chatMessage("<j>Team Yellow<n> "..teamsLifes[1].yellow.." | <r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."", nil)
        print("<j>Team Yellow<n> "..teamsLifes[1].yellow.." | <r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."")
        local ballSpawnX = 0
        local ballSpawnY = 0

        if #spawnBallArea400 ~= 0 then
          randomIndex = math.random(1, #spawnBallArea400)
          ballSpawnX = spawnBallArea400[randomIndex].x
          ballSpawnY = spawnBallArea400[randomIndex].y
          spawnBall(ballSpawnX, j, ballSpawnY)
        else
          spawnBall(200, j)
        end

        showTheScore()
      elseif tfm.get.room.objectList[ballsId[j]].x <= gameStats.redX and tfm.get.room.objectList[ballsId[j]].y >= 368 and teamsLifes[2].red >= 1 and not onCondition and not lostLife then
        lostLife = true
        onCondition = true
        teamsLifes[2].red = teamsLifes[2].red - 1
        if teamsLifes[2].red == 0 then
          ballOnGame = false
          ballOnGame2 = false
          updateTwoBallOnGame()
          for i = 1, #playersRed do
            tfm.exec.setNameColor(playersRed[i].name, 0xD1D5DB)
            tfm.exec.movePlayer(playersRed[i].name, 391, 74)
            playerInGame[playersRed[i].name] = false
            playersRed[i].name = ''
          end
          tfm.exec.chatMessage("<r>Red team lost all their lives<n>", nil)
          toggleMapType()
          updateTeamsColors(2)
          gameStats.canTransform = false
          disablePlayersCanTransform(4000)
          delayToToggleMap = addTimer(function(i)
            if i == 1 then
              toggleMap()
            end
          end, 3000, 1, "delayToToggleMap")
          return
        end
        local ballSpawnX = 0
        local ballSpawnY = 0

        tfm.exec.chatMessage("<r>Red team lost a life<n>", nil)
        tfm.exec.chatMessage("<j>Team Yellow<n> "..teamsLifes[1].yellow.." | <r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."", nil)
        print("<j>Team Yellow<n> "..teamsLifes[1].yellow.." | <r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."")
        if #spawnBallArea800 ~= 0 then
          randomIndex = math.random(1, #spawnBallArea800)
          ballSpawnX = spawnBallArea800[randomIndex].x
          ballSpawnY = spawnBallArea800[randomIndex].y
          spawnBall(ballSpawnX, j, ballSpawnY)
        else
          spawnBall(600, j)
        end
        showTheScore()
      elseif tfm.get.room.objectList[ballsId[j]].x <= gameStats.blueX and tfm.get.room.objectList[ballsId[j]].y >= 368 and teamsLifes[3].blue >= 1 and not onCondition and not lostLife then
        lostLife = true
        onCondition = true
        teamsLifes[3].blue = teamsLifes[3].blue - 1
        if teamsLifes[3].blue == 0 then
          ballOnGame = false
          ballOnGame2 = false
          updateTwoBallOnGame()
          for i = 1, #playersBlue do
            tfm.exec.setNameColor(playersBlue[i].name, 0xD1D5DB)
            tfm.exec.movePlayer(playersBlue[i].name, 391, 74)
            playerInGame[playersBlue[i].name] = false
            playersBlue[i].name = ''
          end
          tfm.exec.chatMessage("<bv>Blue team lost all their lives<n>", nil)
          toggleMapType()
          updateTeamsColors(3)
          gameStats.canTransform = false
          disablePlayersCanTransform(4000)
          delayToToggleMap = addTimer(function(i)
            if i == 1 then
              toggleMap()
            end
          end, 3000, 1, "delayToToggleMap")
          return
        end
        tfm.exec.chatMessage("<bv>Blue team lost a life<n>", nil)
        tfm.exec.chatMessage("<j>Team Yellow<n> "..teamsLifes[1].yellow.." | <r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."", nil)
        print("<j>Team Yellow<n> "..teamsLifes[1].yellow.." | <r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."")
        local ballSpawnX = 0
        local ballSpawnY = 0
        if #spawnBallArea1200 ~= 0 then
          randomIndex = math.random(1, #spawnBallArea1200)
          ballSpawnX = spawnBallArea1200[randomIndex].x
          ballSpawnY = spawnBallArea1200[randomIndex].y
          spawnBall(ballSpawnX, j, ballSpawnY)
        else
          spawnBall(1000, j)
        end

        showTheScore()
      elseif tfm.get.room.objectList[ballsId[j]].x >= gameStats.greenX and tfm.get.room.objectList[ballsId[j]].y >= 368 and teamsLifes[4].green >= 1 and not onCondition and not lostLife then
        lostLife = true
        onCondition = true
        teamsLifes[4].green = teamsLifes[4].green - 1
        if teamsLifes[4].green == 0 then
          ballOnGame = false
          ballOnGame2 = false
          updateTwoBallOnGame()
          for i = 1, #playersGreen do
            tfm.exec.setNameColor(playersGreen[i].name, 0xD1D5DB)
            tfm.exec.movePlayer(playersGreen[i].name, 391, 74)
            playerInGame[playersGreen[i].name] = false
            playersGreen[i].name = ''
          end
          tfm.exec.chatMessage("<vp>Green team lost all their lives<n>", nil)
          toggleMapType()
          updateTeamsColors(4)
          gameStats.canTransform = false
          disablePlayersCanTransform(4000)
          delayToToggleMap = addTimer(function(i)
            if i == 1 then
              toggleMap()
            end
          end, 3000, 1, "delayToToggleMap")
          return
        end
        local ballSpawnX = 0
        local ballSpawnY = 0

        tfm.exec.chatMessage("<vp>Green team lost a life<n>", nil)
        tfm.exec.chatMessage("<j>Team Yellow<n> "..teamsLifes[1].yellow.." | <r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."", nil)
        print("<j>Team Yellow<n> "..teamsLifes[1].yellow.." | <r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."")
        if #spawnBallArea1600 ~= 0 then
          randomIndex = math.random(1, #spawnBallArea1600)
          ballSpawnX = spawnBallArea1600[randomIndex].x
          ballSpawnY = spawnBallArea1600[randomIndex].y
          spawnBall(ballSpawnX, j, ballSpawnY)
        else
          spawnBall(1400, j)
        end
        showTheScore()
      end
    elseif gameStats.typeMap == "large3v3" and ballOnGameTwoBalls[j] and ballsId[j] ~= nil then
      for i = 1, #getTeamsLifes do
        if tfm.get.room.objectList[ballsId[j]].x <= 399 and tfm.get.room.objectList[ballsId[j]].y >= 368 and getTeamsLifes[1] >= 1 and i == 1 and not lostLife then
          lostLife = true
          getTeamsLifes[1] = getTeamsLifes[1] - 1
          if getTeamsLifes[1] == 0 then
            ballOnGame = false
            ballOnGame2 = false
            updateTwoBallOnGame()
            for j = 1, #teamsPlayersOnGame[i] do
              tfm.exec.setNameColor(teamsPlayersOnGame[i][j].name, 0xD1D5DB)
              tfm.exec.movePlayer(teamsPlayersOnGame[i][j].name, 391, 74)
              playerInGame[teamsPlayersOnGame[i][j].name] = false
              teamsPlayersOnGame[i][j].name = ''
            end
            tfm.exec.chatMessage(messageTeamsLifes[1], nil)
            print(messageTeamsLifes[1])
            updateTeamsColors(1)
            toggleMapType()
            gameStats.canTransform = false
            disablePlayersCanTransform(4000)
            delayToToggleMap = addTimer(function(i)
              if i == 1 then
                toggleMap()
              end
            end, 3000, 1, "delayToToggleMap")
            return
          end
          tfm.exec.chatMessage(messageTeamsLostOneLife[1], nil)
          print(messageTeamsLostOneLife[1])
          tfm.exec.chatMessage(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].." | "..messageTeamsLifesTextChat[3].." "..getTeamsLifes[3].."", nil)
          print(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].." | "..messageTeamsLifesTextChat[3].." "..getTeamsLifes[3].."")

          local ballSpawnX = 0
          local ballSpawnY = 0

          if #spawnBallArea400 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea400)
            ballSpawnX = spawnBallArea400[randomIndex].x
            ballSpawnY = spawnBallArea400[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(200, j)
          end
          showTheScore()
        elseif tfm.get.room.objectList[ballsId[j]].x <= 799 and tfm.get.room.objectList[ballsId[j]].y >= 368 and getTeamsLifes[2] >= 1 and i == 2 and not lostLife then
          lostLife = true
          getTeamsLifes[2] = getTeamsLifes[2] - 1
          if getTeamsLifes[2] == 0 then
            ballOnGame = false
            ballOnGame2 = false
            updateTwoBallOnGame()
            for j = 1, #teamsPlayersOnGame[i] do
              tfm.exec.setNameColor(teamsPlayersOnGame[i][j].name, 0xD1D5DB)
              tfm.exec.movePlayer(teamsPlayersOnGame[i][j].name, 391, 74)
              playerInGame[teamsPlayersOnGame[i][j].name] = false
              teamsPlayersOnGame[i][j].name = ''
            end
            tfm.exec.chatMessage(messageTeamsLifes[2], nil)
            print(messageTeamsLifes[2])
            toggleMapType()
            updateTeamsColors(2)
            gameStats.canTransform = false
            disablePlayersCanTransform(4000)
            delayToToggleMap = addTimer(function(i)
              if i == 1 then
                toggleMap()
              end
            end, 3000, 1, "delayToToggleMap")
            return
          end
          tfm.exec.chatMessage(messageTeamsLostOneLife[2], nil)
          print(messageTeamsLostOneLife[2])
          tfm.exec.chatMessage(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].." | "..messageTeamsLifesTextChat[3].." "..getTeamsLifes[3].."", nil)
          print(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].." | "..messageTeamsLifesTextChat[3].." "..getTeamsLifes[3].."")

          local ballSpawnX = 0
          local ballSpawnY = 0

          if #spawnBallArea800 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea800)
            ballSpawnX = spawnBallArea800[randomIndex].x
            ballSpawnY = spawnBallArea800[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(600, j)
          end
          showTheScore()
        elseif tfm.get.room.objectList[ballsId[j]].x >= 801 and tfm.get.room.objectList[ballsId[j]].y >= 368 and getTeamsLifes[3] >= 1 and i == 3 and not lostLife then
          lostLife = true
          getTeamsLifes[3] = getTeamsLifes[3] - 1
          if getTeamsLifes[3] == 0 then
            ballOnGame = false
            ballOnGame2 = false
            updateTwoBallOnGame()
            for j = 1, #teamsPlayersOnGame[i] do
              tfm.exec.setNameColor(teamsPlayersOnGame[i][j].name, 0xD1D5DB)
              tfm.exec.movePlayer(teamsPlayersOnGame[i][j].name, 391, 74)
              playerInGame[teamsPlayersOnGame[i][j].name] = false
              teamsPlayersOnGame[i][j].name = ''
            end
            tfm.exec.chatMessage(messageTeamsLifes[3], nil)
            print(messageTeamsLifes[3])
            toggleMapType()
            updateTeamsColors(3)
            gameStats.canTransform = false
            disablePlayersCanTransform(4000)
            delayToToggleMap = addTimer(function(i)
              if i == 1 then
                toggleMap()
              end
            end, 3000, 1, "delayToToggleMap")
            return
          end

          tfm.exec.chatMessage(messageTeamsLostOneLife[3], nil)
          print(messageTeamsLostOneLife[3])
          tfm.exec.chatMessage(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].." | "..messageTeamsLifesTextChat[3].." "..getTeamsLifes[3].."", nil)
          print(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].." | "..messageTeamsLifesTextChat[3].." "..getTeamsLifes[3].."")
          local ballSpawnX = 0
          local ballSpawnY = 0

          if #spawnBallArea1200 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea1200)
            ballSpawnX = spawnBallArea1200[randomIndex].x
            ballSpawnY = spawnBallArea1200[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(1000, j)
          end
          showTheScore()
        end
      end
    elseif gameStats.typeMap == "small" and ballOnGameTwoBalls[j] and ballsId[j] ~= nil then
      for i = 1, #getTeamsLifes do
        if tfm.get.room.objectList[ballsId[j]].x <= 399 and tfm.get.room.objectList[ballsId[j]].y >= 368 and getTeamsLifes[1] >= 1 and i == 1 and not lostLife then
          lostLife = true
          getTeamsLifes[1] = getTeamsLifes[1] - 1
          if getTeamsLifes[1] == 0 then
            for j = 1, #teamsPlayersOnGame[i] do
              tfm.exec.setNameColor(teamsPlayersOnGame[i][j].name, 0xD1D5DB)
              tfm.exec.movePlayer(teamsPlayersOnGame[i][j].name, 391, 74)
              playerInGame[teamsPlayersOnGame[i][j].name] = false
              teamsPlayersOnGame[i][j].name = ''
            end
            print(teamsPlayersOnGame)
            print(messageTeamsLifes[1])
            tfm.exec.chatMessage(messageTeamsLifes[1], nil)
            showTheScore()
            updateTeamsColors(1)
            showMessageWinner()
            ballOnGame = false
            ballOnGame2 = false
            fourTeamsModeWinner(messageTeamsLifes[1], teamsPlayersOnGame[1])
            updateRankingFourTeamsMode()
            updateTwoBallOnGame()

            tfm.exec.removeObject (ballsId[j])
            mode = "endGame"
            gameTimeEnd = os.time() + 5000
            return
          end
          tfm.exec.chatMessage(messageTeamsLostOneLife[1], nil)
          print(messageTeamsLostOneLife[1])
          tfm.exec.chatMessage(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].."", nil)
          print(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].."")
          local ballSpawnX = 0
          local ballSpawnY = 0

          if #spawnBallArea400 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea400)
            ballSpawnX = spawnBallArea400[randomIndex].x
            ballSpawnY = spawnBallArea400[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(200, j)
          end
          showTheScore()
        elseif tfm.get.room.objectList[ballsId[j]].x >= 401 and tfm.get.room.objectList[ballsId[j]].y >= 368 and getTeamsLifes[2] >= 1 and i == 2 and not lostLife then
          lostLife = true
          getTeamsLifes[2] = getTeamsLifes[2] - 1
          if getTeamsLifes[2] == 0 then
            for j = 1, #teamsPlayersOnGame[i] do
              tfm.exec.setNameColor(teamsPlayersOnGame[i][j].name, 0xD1D5DB)
              tfm.exec.movePlayer(teamsPlayersOnGame[i][j].name, 391, 74)
              playerInGame[teamsPlayersOnGame[i][j].name] = false
              teamsPlayersOnGame[i][j].name = ''
            end
            tfm.exec.chatMessage(messageTeamsLifes[2], nil)
            print(messageTeamsLifes[2])
            showTheScore()
            updateTeamsColors(2)
            showMessageWinner()
            ballOnGame = false
            ballOnGame2 = false
            fourTeamsModeWinner(messageTeamsLifes[1], teamsPlayersOnGame[1])
            updateRankingFourTeamsMode()
            updateTwoBallOnGame()
            tfm.exec.removeObject (ballsId[j])
            mode = "endGame"
            gameTimeEnd = os.time() + 5000
            return
          end
          tfm.exec.chatMessage(messageTeamsLostOneLife[2], nil)
          print(messageTeamsLostOneLife[2])
          tfm.exec.chatMessage(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].."", nil)
          print(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].."")
          local ballSpawnX = 0
          local ballSpawnY = 0

          if #spawnBallArea800 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea800)
            ballSpawnX = spawnBallArea800[randomIndex].x
            ballSpawnY = spawnBallArea800[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(600, j)
          end
          showTheScore()
        end
      end
    end
  end
end

function updateTeamsColors(index)
  table.remove(messageTeamsLostOneLife, index)
  table.remove(messageTeamsLifes, index)
  table.remove(getTeamsColors, index)
  table.remove(getTeamsColorsName, index)
  table.remove(messageTeamsLifesTextChat, index)
  table.remove(messageWinners, index)
  table.remove(teamsPlayersOnGame, index)
  table.remove(getTeamsLifes, index)
end

function toggleMapType()
  if gameStats.typeMap == "large4v4" then
    gameStats.typeMap = "large3v3"
  elseif gameStats.typeMap == "large3v3" then
    gameStats.typeMap = "small"
  end
end

function toggleMap()
  gameStats.canTransform = false
  disablePlayersCanTransform(1500)
  ballOnGame = false
  if gameStats.typeMap == "large3v3" then
    ui.removeTextArea(8998991)
    if mapsToTest[2] ~= "" then
      tfm.exec.newGame(mapsToTest[2])
      local foundMap = addTimer(function(i)
        if i == 1 then
          foundBallSpawnsOnMap(mapsToTest[2], false)
          foundMiceSpawnsOnMap(mapsToTest[2], false)
        end
      end, 1000)
    else
      if gameStats.isCustomMap then
        tfm.exec.newGame(customMapsFourTeamsMode[gameStats.customMapIndex][2])
        foundBallSpawnsOnMap(customMapsFourTeamsMode[gameStats.customMapIndex][2], false)
        foundMiceSpawnsOnMap(customMapsFourTeamsMode[gameStats.customMapIndex][2], false)
      elseif gameStats.totalVotes >= 2 then
        tfm.exec.newGame(customMapsFourTeamsMode[gameStats.mapIndexSelected][2])
        foundBallSpawnsOnMap(customMapsFourTeamsMode[gameStats.mapIndexSelected][2], false)
        foundMiceSpawnsOnMap(customMapsFourTeamsMode[gameStats.mapIndexSelected][2], false)
      else
        tfm.exec.newGame('<C><P L="1200" F="3" G="0,4" MEDATA="25,1;;;;-0;0:::1-"/><Z><S><S T="7" X="600" Y="400" L="1200" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="1200" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="600" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="0" L="1200" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="0" X="600" Y="95" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="900" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="601" Y="225" L="1200" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="950" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="600" Y="-800" L="1200" H="10" P="0,0,0,0.2,0,0,0,0"/><S T="1" X="800" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="0" X="800" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="800" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="13" X="1100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="600" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/></S><D><P X="599" Y="363" T="10" P="1,0"/><P X="99" Y="363" T="10" P="1,0"/><P X="1099" Y="363" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>')
      end
    end

    teleportPlayersWithTypeMap(true)
    showTheScore()
    delaySpawnBall = addTimer(function(i)
      if i == 1 then
        spawnInitialBall()
      end
    end, 1500)

    tfm.exec.addPhysicObject (99999, 800, 460, {
      type = 15,
      width = 3000,
      height = 100,
      miceCollision = false,
      groundCollision = false
    })

    showCrownToAllPlayers()

    return
  elseif gameStats.typeMap == "small" then
    ui.removeTextArea(8998991)
    ui.removeTextArea(899899)
    if mapsToTest[3] ~= '' then
      tfm.exec.newGame(mapsToTest[3])
      local foundMap = addTimer(function(i)
        if i == 1 then
          foundBallSpawnsOnMap(mapsToTest[3], false)
          foundMiceSpawnsOnMap(mapsToTest[3], false)
        end
      end, 1000)
    else
      if gameStats.isCustomMap then
        tfm.exec.newGame(customMapsFourTeamsMode[gameStats.customMapIndex][5])
        foundBallSpawnsOnMap(customMapsFourTeamsMode[gameStats.customMapIndex][5], false)
        foundMiceSpawnsOnMap(customMapsFourTeamsMode[gameStats.customMapIndex][5], false)
      elseif gameStats.totalVotes >= 2 then
        tfm.exec.newGame(customMapsFourTeamsMode[gameStats.mapIndexSelected][5])
        foundBallSpawnsOnMap(customMapsFourTeamsMode[gameStats.mapIndexSelected][5], false)
        foundMiceSpawnsOnMap(customMapsFourTeamsMode[gameStats.mapIndexSelected][5], false)
      else
        tfm.exec.newGame('<C><P F="0" G="0,4" MEDATA="15,1;;;;-0;0:::1-"/><Z><S><S T="7" X="400" Y="400" L="800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="400" Y="430" L="800" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="400" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-5" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="12" X="805" Y="0" L="10" H="3000" P="0,0,0.2,0.2,0,0,0,0" o="6a7495"/><S T="13" X="100" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="13" X="700" Y="359" L="10" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="3"/><S T="12" X="50" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="0" L="800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" N=""/><S T="0" X="400" Y="95" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="105" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="700" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" c="3" N="" m=""/><S T="0" X="401" Y="225" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="239" L="10" H="30" P="0,0,0,0,0,0,0,0" c="3" m=""/><S T="0" X="400" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="400" Y="460" L="3000" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="750" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="400" Y="-800" L="800" H="10" P="0,0,0,0.2,0,0,0,0" N=""/></S><D><P X="699" Y="365" T="10" P="1,0"/><P X="99" Y="365" T="10" P="1,0"/><DS X="360" Y="-151"/></D><O/><L/></Z></C>')
      end
    end

    teleportPlayersWithTypeMap(false)
    showTheScore()
    spawnInitialBall()
    tfm.exec.addPhysicObject (99999, 800, 460, {
      type = 15,
      width = 3000,
      height = 100,
      miceCollision = false,
      groundCollision = false
    })

    showCrownToAllPlayers()
  end
end

function teamServe(team)
  gameStats.redQuantitySpawn = 0
  gameStats.blueQuantitySpawn = 0
  if team == "red" then
    gameStats.redLimitSpawn = 1
    gameStats.blueLimitSpawn = 3
    showTheScore()
    return
  end

  gameStats.redLimitSpawn = 3
  gameStats.blueLimitSpawn = 1
  showTheScore()
end

function teleportPlayersWithTypeMap(islargeMode)
  teleportPlayersToSpec()

  local sideToTeleport = {}
  local teleportX = {}
  local teamsToTeleport = {teamsLifes[1].yellow, teamsLifes[2].red, teamsLifes[3].blue, teamsLifes[4].green}
  local teamsPlayers = {playersYellow, playersRed, playersBlue, playersGreen}
  local teamsColors = {0xF59E0B, 0xEF4444, 0x3B82F6, 0x109267}
  local spawnTeleport = { playersSpawn400, playersSpawn800, playersSpawn1200 }

  if islargeMode then
    sideToTeleport = { true, true, true }
    teleportX = { 200, 600, 1000 }
    messageTeamsLifes = {}
    messageTeamsLostOneLife = {}
    messageTeamsLifesTextChat = {}
    messageWinners = {}
  else
    teamsPlayers = {}
    sideToTeleport = { true, true }
    teleportX = { 200, 600 }
    teamsToTeleport = {getTeamsLifes[1], getTeamsLifes[2]}
    for i = 1, #teamsPlayersOnGame do
      teamsPlayers[#teamsPlayers + 1] = teamsPlayersOnGame[i]
    end
  end

  local teamsColorsText = {"<j>", "<r>", "<bv>", "<vp>"}
  local mapCoords = {gameStats.yellowX, gameStats.redX, gameStats.blueX, gameStats.greenX}
  local mapCoordsX = {399, 799, 801}
  local messageLostAllLifes = {"<j>Yellow team lost all their lives<n>", "<r>Red team lost all their lives<n>", "<bv>Blue team lost all their lives<n>", "<vp>Green team lost all their lives<n>"}
  local messageLostOneLife = {"<j>Yellow team lost a life<n>", "<r>Red team lost a life<n>", "<bv>Blue team lost a life<n>", "<vp>Green team lost a life<n>"}
  local messageTeamsLifesText = {"<j>Team Yellow<n>", "<r>Team Red<n>", "<bv>Team Blue<n>", "<vp>Team Green<n>"}
  local messageWinnersText = {"<j>Team Yellow won!<n>", "<r>Team Red won!<n>", "<bv>Team Blue won!<n>", "<vp>Team Green won!<n>"}
  mapCoordsTeams = {}
  getTeamsLifes = {}

  if gameStats.typeMap == "large3v3" or gameStats.typeMap == "small" then
    for i = 1, #teamsToTeleport do
      if teamsToTeleport[i] >= 1 then
        if gameStats.typeMap == "large3v3" then
          teamsPlayersOnGame[#teamsPlayersOnGame + 1] = teamsPlayers[i]
          getTeamsColors[#getTeamsColors + 1] = teamsColorsText[i]
          messageTeamsLifes[#messageTeamsLifes + 1] = messageLostAllLifes[i]
          messageTeamsLostOneLife[#messageTeamsLostOneLife + 1] = messageLostOneLife[i]
          messageTeamsLifesTextChat[#messageTeamsLifesTextChat + 1] = messageTeamsLifesText[i]
          messageWinners[#messageWinners + 1] = messageWinnersText[i]
        end
        getTeamsLifes[#getTeamsLifes + 1] = teamsToTeleport[i]
        for j = 1, #sideToTeleport do
          mapCoords[i] = mapCoordsX[j]
          mapCoordsTeams[#mapCoordsTeams + 1] = mapCoords[i]
          if sideToTeleport[j] then
            sideToTeleport[j] = false
            for h = 1, #teamsPlayers[i] do
              if teamsPlayers[i][h].name ~= '' then
                if #spawnTeleport[j] > 0 then
                  teleportPlayerWithSpecificSpawn(spawnTeleport[j], teamsPlayers[i][h].name)
                else
                  tfm.exec.movePlayer(teamsPlayers[i][h].name, teleportX[j], 334)
                end

                if gameStats.typeMap == "large3v3" then
                  tfm.exec.setNameColor(teamsPlayers[i][h].name, teamsColors[i])
                else
                  tfm.exec.setNameColor(teamsPlayers[i][h].name, getTeamsColorsName[i])
                end

              end
            end
            break
          end
        end
      end
    end
  end
end

function eventNewPlayer(name)
  customMapCommand[name] = true
  selectMapOpen[name] = false
  selectMapPage[name] = 1
  selectMapImages[name] = {}
  isOpenProfile[name] = false
  playerTrophyImage[name] = 0
  if playerAchievements[name] == nil then
    playerAchievements[name] = {[1] = { image = "img@193d6763c82", quantity = 0 }, [2] = { image = '19636907e9e.png', quantity = 0}}
  end
  playerAchievementsImages[name] = {}
  settings[name] = false
  settingsMode[name] = false
  playerLeft[name] = false
  playerLeftRight[name] = 0
  playerConsumable[name] = true
  playerConsumableKey[name] = 56
  playerConsumableItem[name] = 80
  playerForce[name] = 0
  showOutOfCourtText[name] = false
  playerOutOfCourt[name] = false
  openRank[name] = false
  playerLanguage[name] = {tr = trad, name = name}
  pagesList[name] = {helpPage = 1}
  playersAfk[name] = os.time()

  showCrownToAllPlayers()
  if canVote[name] == nil then
    canVote[name] = true
  end

  if showCrownImages[name] == nil then
    showCrownImages[name] = true
  end

  if playersOnGameHistoric[name] == nil then
    playersOnGameHistoric[name] = { teams = {} }
  end

  if playerLastMatchCount[name] == nil then
    playerLastMatchCount[name] = countMatches
  else
    if playerLastMatchCount[name] ~= countMatches then
      playersOnGameHistoric[name] = { teams = {} }
    end
  end

  if playerBan[name] == nil then
    playerBan[name] = false
    playerBanHistory[name] = ""
  end

  if gameStats.killSpec or killSpecPermanent then
    tfm.exec.killPlayer(name)
  else
    tfm.exec.respawnPlayer(name)
  end

  if playersNormalMode[name] == nil then
    playersNormalMode[name] = {name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0}
    pageNormalMode[name] = 1
    playersFourTeamsMode[name] = {name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0, winsYellow = 0, winsGreen = 0}
    pageFourTeamsMode[name] = 1
    playersTwoTeamsMode[name] = {name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0}
    pageTwoTeamsMode[name] = 1
    playersRealMode[name] = {name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0}
    pageRealMode[name] = 1
    playerRankingMode[name] = "Normal mode"
  end

  playerCanTransform[name] = true
  playerInGame[name] = false
  playerPhysicId[name] = 0
  system.bindKeyboard(name, 32, true, true)
  system.bindKeyboard(name, 0, true, true)
  system.bindKeyboard(name, 1, true, true)
  system.bindKeyboard(name, 2, true, true)
  system.bindKeyboard(name, 3, true, true)
  system.bindKeyboard(name, 49, true, true)
  system.bindKeyboard(name, 50, true, true)
  system.bindKeyboard(name, 51, true, true)
  system.bindKeyboard(name, 52, true, true)
  system.bindKeyboard(name, 55, true, true)
  system.bindKeyboard(name, 56, true, true)
  system.bindKeyboard(name, 57, true, true)
  system.bindKeyboard(name, 48, true, true)
  system.bindKeyboard(name, 77, true, true)
  system.bindKeyboard(name, 76, true, true)
  system.bindKeyboard(name, 80, true, true)
  tfm.exec.setNameColor(name, 0xD1D5DB)
  if playerBan[name] then
    tfm.exec.chatMessage("<bv>You have been banned from the room by the admin "..playerBanHistory[name].."<n>", name)
    tfm.exec.kickPlayer(name)
  end

  ui.addWindow(23, "<p align='center'><font size='13px'><a href='event:menuOpen'>Menu", name, 5, 15, 100, 30, 0.2, false, false, _)
  tfm.exec.chatMessage(playerLanguage[name].tr.welcomeMessage, name)
  if mode == "startGame" then
    eventNewGameShowLobbyTexts(gameStats.teamsMode)

    ui.addWindow(30, "<p align='center'><font size='13px'><a href='event:selectMap'>Select a map", name, 10, 370, 150, 30, 1, false, false, _)

    if admins[name] then
      ui.addWindow(31, "<p align='center'><font size='13px'><a href='event:settings'>Room settings", name, 180, 370, 150, 30, 1, false, false, _)
    end
  elseif mode ~= "startGame" then
    tfm.exec.chatMessage("<ch>If you don't want to see the ranking crowns, type the command !crown false<n>", name)
    showTheScore()
    teleportPlayersToSpecWithSpecificSpawn(name)

    tfm.exec.chatMessage(playerLanguage[name].tr.welcomeMessage2, name)
    canVote[name] = true
  end
  tfm.exec.chatMessage("<j>#Volley Version: "..gameVersion.."<n>", name)
  tfm.exec.chatMessage("<ce>Join our #Volley Discord server: https://discord.com/invite/pWNTesmNhu<n>", name)
end

function setConsumablesForce(key, playerMove)
  local speedX = 0
  local speedY = 0
  local yCoord = 0

  if key == 55 or key == 48 then
    yCoord = -65
    if playerMove == 0 then
      speedX = -10
    elseif playerMove == 2 then
      speedX = 10
    end
  elseif key == 57 then
    yCoord = -65
    speedY = -5

    if playerMove == 0 then
      speedX = -5
    elseif playerMove == 2 then
      speedX = 5
    end
  end

  return { speedX, speedY, yCoord }
end

function eventKeyboard(name, key, down, x, y, xv, yv)
  local OffsetX = 0
  local OffsetY = 0

  if xv < 0 then
    OffsetX = -15
  elseif xv > 0 then
    OffsetX = 15
  end
  if yv < 0 then
    OffsetY = -5
  elseif yv > 0 then
    OffsetY = 5
  end
  local coordinatesX = (x + xv) + OffsetX
  local coordinatesY = (y + yv) + OffsetY
  tfm.get.room.playerList[name].x = coordinatesX
  tfm.get.room.playerList[name].y = coordinatesY

  if key == 0 or key == 1 or key == 2 or key == 3 then
    removePlayerTrophy(name)
  end

  if key == 80 then
    if isOpenProfile[name] then
      closeAllWindows(name)
      closeRankingUI(name)
      removeButtons(25, name)
      removeButtons(26, name)
      closeWindow(24, name)
      closeWindow(25, name)
      removeUITrophies(name)

      return
    end
    closeAllWindows(name)
    closeRankingUI(name)
    removeButtons(25, name)
    removeButtons(26, name)
    removeUITrophies(name)
    profileUI(name, name)
  end

  if key == 76 then
    if openRank[name] then
      openRank[name] = false
      closeAllWindows(name)
      closeWindow(21, name)
      closeWindow(24, name)
      closeWindow(25, name)
      ui.removeTextArea(99992, name)
      closeWindow(266, name)
      removeButtons(25, name)
      removeButtons(26, name)
      closeRankingUI(name)
    else
      openRank[name] = true
      ui.addWindow(24, "<p align='center'><font size='15px'>", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
      ui.addTextArea(9999543, "<p align='center'>Room Ranking", name, 17, 168, 100, 20, 0x142b2e, 0x8a583c, 1, true)
      ui.addTextArea(9999544, "<p align='center'><n2>Global Ranking<n>", name, 17, 268, 100, 18, 0x142b2e, 0x8a583c, 1, true)
      showMode(playerRankingMode[name], name)
    end
  end

  if playerInGame[name] and mode == "gameStart" then

    if key == 0 or key == 2 then
      playerLeftRight[name] = key
    end

    if gameStats.consumables then
      if not gameStats.teamsMode and not gameStats.twoTeamsMode and not gameStats.realMode then
        local keysEmote = {55, 56, 57, 48}
        local consumablesId = {65, 80, 6, 34}
        local consumablesNames = {"pufferfish", "paper plane", "ball", "snow ball"}

        for i = 1, #keysEmote do
          if keysEmote[i] == key then
            playerConsumableKey[name] = keysEmote[i]
            playerConsumableItem[name] = consumablesId[i]
            tfm.exec.chatMessage("<bv>You chose the consumable "..consumablesNames[i].."<n>", name)
            print("<bv>You chose the consumable "..consumablesNames[i].."<n>")
          end
        end

        if key == 77 then
          if not playerConsumable[name] then
            tfm.exec.chatMessage("<bv>You need wait 5 seconds to spawn a new consumable<n>", name)
            print("<bv>You need wait 5 seconds to spawn a new item<n>")

            return
          end
          local speed = setConsumablesForce(playerConsumableKey[name], playerLeftRight[name])
          playerConsumable[name] = false

          local enablePlayerConsumable = addTimer(function(i)
            if i == 1 then
              playerConsumable[name] = true
              tfm.exec.chatMessage("<bv>You can spawn a new consumable<n>", name)
              print("<bv>You can spawn a new consumable <n>")
            end
          end, 5000, 1, "enablePlayerConsumable")

          local id = tfm.exec.addShamanObject(playerConsumableItem[name], x + OffsetX + (OffsetX / 2), y + speed[3], 0, speed[1], speed[2], false)
          playerConsumables[#playerConsumables + 1] = id

          local removeShamanObject = addTimer(function(i)
            if i == 1 then
              tfm.exec.removeObject(playerConsumables[1])
              table.remove(playerConsumables, 1)
            end
          end, 15000, 1, "removeShamanObject")
        end
      end
    end

    if key == 0 or key == 1 or key == 2 or key == 3 or key == 32 then
      playersAfk[name] = os.time()
    end

    if gameStats.realMode then
      if key == 49 then
        playerForce[name] = 0
        tfm.exec.chatMessage("<bv>Your strength changed to normal<n>", name)
      elseif key == 50 then
        playerForce[name] = -0.2
        tfm.exec.chatMessage("<bv>Your strength has been reduced by 20%<n>", name)
      elseif key == 51 then
        playerForce[name] = -0.45
        tfm.exec.chatMessage("<bv>Your strength has been reduced by 45%<n>", name)
      elseif key == 52 then
        playerForce[name] = -1
        tfm.exec.chatMessage("<bv>Your strength has been reduced by 100%<n>", name)
      end

      if x <= 599 or x >= 2001 then
        if not playerOutOfCourt[name] and not showOutOfCourtText[name] then
          showOutOfCourtText[name] = true
          tfm.exec.chatMessage("<bv>you are outside the court you have 7 seconds to make an action, otherwise you will not be able to use the space key outside the court<n>", name)
          print("<bv>you are outside the court you have 7 seconds to make an action, otherwise you will not be able to use the space key outside the court<n>")
        end
        delayToDoAnAction = addTimer(function(i)
          if i == 1 then
            playerOutOfCourt[name] = true
          end
        end, 7000, 1, "delay"..name.."")
      end

      if x > 599 and x < 2001 then
        removeTimer("delay"..name.."")
        showOutOfCourtText[name] = false
        playerOutOfCourt[name] = false
      end
      if gameStats.redServe and name ~= gameStats.redPlayerServe then
        return
      end

      if gameStats.blueServe and name ~= gameStats.bluePlayerServe then
        return
      end
    end
    if key == 32 and gameStats.canTransform and playerCanTransform[name] and not playerOutOfCourt[name] then
      local aditionalForce = 0

      if gameStats.realMode then
        local playerCanSpawn = verifyPlayerTeam(name)
        local searchPlayerTeam = searchPlayerTeam(name)

        if searchPlayerTeam == "red" and gameStats.redQuantitySpawn >= 0 then
          aditionalForce = 0 + playerForce[name]
        end

        if searchPlayerTeam == "blue" and gameStats.blueQuantitySpawn >= 0 then
          aditionalForce = 0 + playerForce[name]
        end

        if gameStats.redServe then
          gameStats.redServe = false
          aditionalForce = 0.34
        end

        if gameStats.blueServe then
          gameStats.blueServe = false
          aditionalForce = 0.34
        end

        if not playerCanSpawn then
          return
        end

        if gameStats.redQuantitySpawn == 3 then
          aditionalForce = 0.2 + playerForce[name]
        end

        if gameStats.blueQuantitySpawn == 3 then
          aditionalForce = 0.2 + playerForce[name]
        end

        if gameStats.reduceForce and searchPlayerTeam == gameStats.teamWithOutAce then
          gameStats.reduceForce = false
          aditionalForce = -0.45 + playerForce[name]
        end

        playerNearOfTheBall(name, x, y)
      end

      playerCanTransform[name] = false
      playerPhysicId[name] = countId
      tfm.exec.killPlayer (name)
      tfm.exec.addPhysicObject (playerPhysicId[name], coordinatesX, coordinatesY, {
        type = 13,
        width = 20,
        height = 20,
        restitution = gameStats.psyhicObjectForce + aditionalForce,
        friction = 0,
        color = 0x81348A,
        miceCollision = false,
        groundCollision = true
      })

      local groundId = playerPhysicId[name]

      removeGround = addTimer(function(i)
        if i == 1 then
          tfm.exec.removePhysicObject(groundId)
          tfm.exec.respawnPlayer(name)
          setCrownToPlayer(name)
          if playerInGame[name] then
            tfm.exec.movePlayer (name, x, y)
          end
          delayOnTransform = addTimer(function(i)
            if i == 1 then
              playerCanTransform[name] = true
            end
          end, 500, 1, "delayOnTransform")
        end
      end, 3000, 1, "removeGround"..name.."")
      countId = countId + 1
      for i = 1, #playersRed do
        if playersRed[i].name == name then
          tfm.exec.setNameColor(name, 0xEF4444)
          break
        end
      end
      for i = 1, #playersBlue do
        if playersBlue[i].name == name then
          tfm.exec.setNameColor(name, 0x3B82F6)
          break
        end
      end
    end
  end
end

function playerNearOfTheBall(name, x, y)
  if ballOnGame then
    resetQuantityTeams()
    local ballX = tfm.get.room.objectList[ball_id].x + tfm.get.room.objectList[ball_id].vx
    local ballY = tfm.get.room.objectList[ball_id].y + tfm.get.room.objectList[ball_id].vy

    if (ballX + 15) >= 1250 and (ballX - 15) <= 1350 and x >= 1250 and x <= 1350 and ballY <= 297 then
      local team = searchPlayerTeam(name)

      if team == "red" then
        gameStats.lastPlayerRed = name
        gameStats.blueQuantitySpawn = 0
        if gameStats.blueServe then
          gameStats.blueLimitSpawn = 1
        else
          gameStats.blueLimitSpawn = 3
        end
      elseif team == "blue" then
        gameStats.lastPlayerBlue = name
        gameStats.redQuantitySpawn = 0
        if gameStats.redServe then
          gameStats.redLimitSpawn = 1
        else
          gameStats.redLimitSpawn = 3
        end
      end
    end

    showTheScore()
  end
end

function searchPlayerTeam(name)
  local team = ""

  for i = 1, #playersRed do
    if playersRed[i].name == name then
      team = "red"

      return team
    end
  end

  for i = 1, #playersBlue do
    if playersBlue[i].name == name then
      team = "blue"

      return team
    end
  end
end

function verifyPlayerTeam(name)
  if playerOutOfCourt[name] then
    return
  end

  for i = 1, #playersRed do
    if playersRed[i].name == name then
      if gameStats.redQuantitySpawn == gameStats.redLimitSpawn then
        return false
      end
      if gameStats.redQuantitySpawn < gameStats.redLimitSpawn then
        if gameStats.redLimitSpawn == 1 and name ~= gameStats.redPlayerServe and gameStats.lastPlayerRed == name then
          return false
        end
        gameStats.redQuantitySpawn = gameStats.redQuantitySpawn + 1
        gameStats.lastPlayerRed = name
        showTheScore()

        return true
      end
    end
  end

  for i = 1, #playersBlue do
    if playersBlue[i].name == name then
      if gameStats.blueQuantitySpawn == gameStats.blueLimitSpawn then
        return false
      end

      if gameStats.blueQuantitySpawn < gameStats.blueLimitSpawn then
        if gameStats.blueLimitSpawn == 1 and name ~= gameStats.bluePlayerServe and gameStats.lastPlayerBlue == name then
          return false
        end

        gameStats.blueQuantitySpawn = gameStats.blueQuantitySpawn + 1
        gameStats.lastPlayerBlue = name
        showTheScore()

        return true
      end
    end
  end
end

function teleportPlayer(name, mode)
  local xRed = {[1] = 101}
  local xBlue = {[1] = 700}

  if gameStats.teamsMode then
    print("b")
    teleportPlayerOnTeamsMode(name)
    return
  end

  if mode == "4v4" then
    xRed = {[1] = 301}
    xBlue = {[1] = 900}
  elseif mode == "6v6" then
    xRed = {[1] = 401}
    xBlue = {[1] = 1500}
  end
  for i = 1, #playersRed do
    if playersRed[i].name == name then
      if gameStats.twoTeamsMode then
        if twoTeamsPlayerRedPosition[i] == "middle" then
          tfm.exec.movePlayer(name, 600, 334)
          return
        end
        tfm.exec.movePlayer(name, 1400, 334)
        return
      end
      if gameStats.realMode then
        tfm.exec.movePlayer(name, 900, 334)
        return
      end
      tfm.exec.movePlayer(name, xRed[1], 334)
    end
  end
  for i = 1, #playersBlue do
    if playersBlue[i].name == name then
      if gameStats.twoTeamsMode then
        if twoTeamsPlayerBluePosition[i] == "middle" then
          tfm.exec.movePlayer(name, 1000, 334)
          return
        end
        tfm.exec.movePlayer(name, 200, 334)
        return
      end
      if gameStats.realMode then
        tfm.exec.movePlayer(name, 1700, 334)
        return
      end
      tfm.exec.movePlayer(name, xBlue[1], 334)
    end
  end
end

function teleportPlayerOnTeamsMode(name)
  local x = {[1] = 200, [2] = 600, [3] = 1000}

  if gameStats.typeMap == "large4v4" then
    for i= 1, #playersYellow do
      if playersYellow[i].name == name then
        tfm.exec.movePlayer(name, 200, 334)

        return
      end
    end
    for i= 1, #playersRed do
      if playersRed[i].name == name then
        tfm.exec.movePlayer(name, 600, 334)

        return
      end
    end
    for i= 1, #playersBlue do
      if playersBlue[i].name == name then
        tfm.exec.movePlayer(name, 1000, 334)

        return
      end
    end

    for i= 1, #playersGreen do
      if playersGreen[i].name == name then
        tfm.exec.movePlayer(name, 1400, 334)

        return
      end
    end
  else
    for i = 1, #teamsPlayersOnGame do
      for j = 1, #teamsPlayersOnGame[i] do
        if teamsPlayersOnGame[i][j].name == name then
          print(x[i])
          tfm.exec.movePlayer(name, x[i], 334)
          return
        end
      end
    end
  end
end

function eventPlayerLeft(name)
  playerLeft[name] = true
  playerLastMatchCount[name] = countMatches
  playerCanTransform[name] = true
  playerInGame[name] = false
  if mode == "startGame" then
    updateLobbyTexts(name)

    return
  elseif mode ~= "startGame" then
    canVote[name] = true

    if gameStats.teamsMode then
      leaveTeamTeamsModeConfig(name)
    end

    for i = 1, #playersRed do
      if playersRed[i].name == name then
        playersRed[i].name = ''
        twoTeamsPlayerRedPosition[i] = ''
        removePlayerOnSpawnConfig(name)
        leaveConfigRealMode(name)
      end
      if playersBlue[i].name == name then
        playersBlue[i].name = ''
        twoTeamsPlayerBluePosition[i] = ''
        removePlayerOnSpawnConfig(name)
        leaveConfigRealMode(name)
      end
    end
  end
end

function eventChatCommand(name, c)
  local command = string.lower(c)
  if command == "join" and playerInGame[name] == false and mode == "gameStart" then
    local isPlayerBanned = messagePlayerIsBanned(name)
    playersAfk[name] = os.time()
    if isPlayerBanned then
      return
    end

    if gameStats.teamsMode and gameStats.canTransform then
      if tfm.get.room.playerList[name].isDead then
        tfm.exec.respawnPlayer(name)
      end
      chooseTeamTeamsMode(name)
      showCrownToAllPlayers()
      return
    else
      if not gameStats.teamsMode then
        if tfm.get.room.playerList[name].isDead then
          tfm.exec.respawnPlayer(name)
        end
        chooseTeam(name)
        showCrownToAllPlayers()
        return
      end
      tfm.exec.chatMessage("<bv>The join command is disabled now, please try the same command in few seconds<n>", name)
      return
    end
  elseif command == "leave" and playerInGame[name] and mode == "gameStart" then
    local isPlayerBanned = messagePlayerIsBanned(name)
    if isPlayerBanned then
      return
    end

    if gameStats.teamsMode and gameStats.canTransform then
      leaveTeamTeamsMode(name)
      return
    else
      if not gameStats.teamsMode then
        leaveTeam(name)
        return
      end
      tfm.exec.chatMessage("<bv>The leave command is disabled now, please try the same command in few seconds<n>", name)
      return
    end
  elseif command:sub(1,4)=="lang" then
    local language = string.lower(command:sub(6,7))
    if language == "en" then
      playerLanguage[name].tr = lang.en
    elseif language == "br" then
      playerLanguage[name].tr = lang.br
    elseif language == "ar" then
      playerLanguage[name].tr = lang.ar
    elseif language == "fr" then
      playerLanguage[name].tr = lang.fr
    elseif language == "pl" then
      playerLanguage[name].tr = lang.pl
    end
  elseif command == "admins" then
    local str = ""
    for name, data in pairs(admins) do
      if name ~= "Refletz#6472" and name ~= "Soristl1#0000" then
        if admins[name] then
          str = ""..str.." "..name..""
        end
      end
    end
    tfm.exec.chatMessage("<bv>Admins: "..str.."<n>", name)
    print(str)
  elseif command == "maps" then
    local str = "<bv>Volley maps"
    if gameStats.twoTeamsMode then
      for i = 1, #customMapsTwoTeamsMode do
        str = ""..str.."\n"..i.."- "..customMapsTwoTeamsMode[i][3]..""
      end
    elseif gameStats.teamsMode then
      for i = 1, #customMapsFourTeamsMode do
        str = ""..str.."\n"..i.."- "..customMapsFourTeamsMode[i][3]..""
      end
    else
      for i = 1, #customMaps do
        str = ""..str.."\n"..i.."- "..customMaps[i][3]..""
      end
    end
    if not gameStats.twoTeamsMode and not gameStats.teamsMode then
      str = ""..str.."\n\nto vote type !votemap number, example: !votemap 1<n>"
    end

    tfm.exec.chatMessage(str, name)
    print(str)
  elseif command == "balls" then
    local str = "<bv>Volley custom balls"
    for i = 1, #balls do
      str = ""..str.."\n"..i.."- "..balls[i].name..""
    end
    str = ""..str.."<n>"
    tfm.exec.chatMessage(str, name)
  elseif command:sub(1, 7) == "votemap" and mode == "startGame" and canVote[name] then
    local isPlayerBanned = messagePlayerIsBanned(name)
    if isPlayerBanned then
      return
    end

    if gameStats.realMode then
      commandNotAvailable(command:sub(1, 7), name)
      return
    end
    local args = split(command)

    if #args < 2 then
      return
    end

    if type(tonumber(args[2])) ~= "number" then
      tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
      return
    end

    local maps = configSelectMap()
    local indexMap = math.abs(math.floor(tonumber(args[2])))

    if type(indexMap) ~= "number" then
      tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
      return
    elseif indexMap < 1 or indexMap > #maps then
      tfm.exec.chatMessage('<bv>Second parameter invalid, the map index must be higher than 1 and less than '..tostring(#maps)..'<n>', name)
      return
    end

    canVote[name] = false
    if mapsVotes[indexMap] == nil then
      mapsVotes[indexMap] = 0
    end
    mapsVotes[indexMap] = mapsVotes[indexMap] + 1
    gameStats.totalVotes = gameStats.totalVotes + 1

    for name1, data in pairs(tfm.get.room.playerList) do
      if selectMapPage[name] == selectMapPage[name1] and selectMapOpen[name1] then
        selectMapUI(name1)
      end
    end

    verifyMostMapVoted()
    tfm.exec.chatMessage("<bv>"..name.." voted for the "..maps[indexMap][3].." map ("..tostring(mapsVotes[indexMap]).." votes), type !maps to see the maps list and to vote !votemap (number)<n>", nil)
  elseif command:sub(1, 5) == "crown" then
    local args = split(command)

    if args[2] ~= "true" and args[2] ~= "false" then
      tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)

      return
    end

    if args[2] == "true" then
      showCrownImages[name] = true

      return
    end

    showCrownImages[name] = false
  elseif command:sub(1, 7) == "profile" then
    closeRankingUI(name)
    removeButtons(25, name)
    removeButtons(26, name)
    removeUITrophies(name)
    local args = split(command)

    if #args == 1 then
      profileUI(name, name)
    else
      for name1, value in pairs(playerAchievements) do
        if string.lower(name1) == args[2] then
          profileUI(name, name1)
        end
      end
    end
  end
  if admins[name] then
    local isPlayerBanned = messagePlayerIsBanned(name)
    if isPlayerBanned then
      return
    end
    if command == "resettimer" and mode == "startGame" then
      initGame = os.time() + 15000
    elseif command == "skiptimer" and mode == "startGame" then
      initGame = os.time() + 5000
    elseif command:sub(1, 13) == "setmaxplayers" then
      if #command <= 14 then
        return
      end
      local maxNumberPlayers = math.abs(math.floor(tonumber(command:sub(15))))
      if type(maxNumberPlayers) ~= "number" then
        return
      end

      if maxNumberPlayers >= 6 and maxNumberPlayers <= 20 then
        tfm.exec.setRoomMaxPlayers(maxNumberPlayers)
        tfm.exec.chatMessage("<bv>"..playerLanguage[name].tr.messageSetMaxPlayers.." "..command:sub(15).." by admin "..name.."<n>", nil)
      else
        tfm.exec.chatMessage(playerLanguage[name].tr.messageMaxPlayersAlert, name)
      end
    elseif command:sub(1, 6) == "setmap" and mode == "startGame" then
      if gameStats.teamsMode then
        commandNotAvailable(command:sub(1, 6), name)
        return
      end
      if command:sub(8) == "small" or command:sub(8) == "large" or command:sub(8) == "extra-large" then
        if command:sub(8) == "small" or command:sub(8) == "large" then
          resetMapsToTest()
        end
        gameStats.setMapName = command:sub(8)
        tfm.exec.chatMessage("<bv>"..gameStats.setMapName.." map selected by admin "..name.."<n>", nil)
      else
        tfm.exec.chatMessage("<bv>Invalid map to select, valid options: small or large<n>", name)
      end
    elseif command:sub(1, 8) == "winscore" and mode == "gameStart" then
      if gameStats.teamsMode then
        commandNotAvailable(command:sub(1, 8), name)
        return
      end
      if #command <= 9 then
        return
      end

      if type(tonumber(command:sub(10))) ~= "number" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
        return
      end

      local winscoreNumber = math.abs(math.floor(tonumber(command:sub(10))))
      if type(winscoreNumber) ~= "number" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
        return
      end

      if winscoreNumber > score_red and winscoreNumber > score_blue and winscoreNumber > 0 then
        gameStats.winscore = math.abs(winscoreNumber)
        tfm.exec.chatMessage("<bv>Winscore changed to "..command:sub(10).."<n>", nil)
      end
    elseif command:sub(1,2) == "pw" then
      tfm.exec.setRoomPassword(command:sub(4))
      if command:sub(4) ~= "" then
        tfm.exec.chatMessage("<bv>"..playerLanguage[name].tr.newPassword.." "..command:sub(4).." by admin "..name.."<n>", nil)
      else
        tfm.exec.chatMessage(playerLanguage[name].tr.passwordRemoved, name)
      end
    elseif command:sub(1, 9) == "custommap" and mode == "startGame" and customMapCommand[name] then
      if gameStats.realMode then
        tfm.exec.chatMessage("<bv>The command !customMap is not available on Volley Real Mode<n>", name)
        return
      end
      local args = split(command)
      local indexMap = ""
      if #args >= 3 then
        if type(tonumber(args[3])) ~= "number" then
          tfm.exec.chatMessage('<bv>Third parameter invalid, must be a number<n>', name)
          return
        end
        indexMap = math.abs(math.floor(tonumber(args[3])))
      end

      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end

      if args[2] == "false" then
        customMapCommand[name] = false

        customMapCommandDelay = addTimer(function(i)
          if i == 1 then
            customMapCommand[name] = true
          end
        end, 2000, 1, "customMapCommandDelay")

        gameStats.isCustomMap = false
        gameStats.customMapIndex = 0
        for name1, data in pairs(tfm.get.room.playerList) do
          if selectMapOpen[name1] then
            selectMapUI(name1)
          end
        end

        return
      end

      if type(indexMap) ~= "number" then
        tfm.exec.chatMessage('<bv>Third parameter invalid, must be a number<n>', name)
        return
      end

      if gameStats.twoTeamsMode then
        if indexMap < 1 or indexMap > #customMapsFourTeamsMode then
          tfm.exec.chatMessage('<bv>Third parameter invalid, the map index must be higher than 1 and less than '..tostring(#customMapsFourTeamsMode)..'<n>', name)
          return
        end
      end

      if gameStats.teamsMode then
        if indexMap < 1 or indexMap > #customMapsFourTeamsMode then
          tfm.exec.chatMessage('<bv>Third parameter invalid, the map index must be higher than 1 and less than '..tostring(#customMapsFourTeamsMode)..'<n>', name)
          return
        end
      end

      if not gameStats.twoTeamsMode and not gameStats.teamsMode then
        if indexMap < 1 or indexMap > #customMaps then
          tfm.exec.chatMessage('<bv>Third parameter invalid, the map index must be higher than 1 and less than '..tostring(#customMaps)..'<n>', name)
          return
        end
      end

      customMapCommand[name] = false

      customMapCommandDelay = addTimer(function(i)
        if i == 1 then
          customMapCommand[name] = true
        end
      end, 2000, 1, "customMapCommandDelay")

      if args[2] == "true" then
        gameStats.isCustomMap = true
        gameStats.customMapIndex = indexMap
        for name1, data in pairs(tfm.get.room.playerList) do
          if selectMapOpen[name1] then
            selectMapUI(name1)
          end
        end
        if gameStats.twoTeamsMode then
          tfm.exec.chatMessage('<bv>'..customMapsFourTeamsMode[gameStats.customMapIndex][3]..' map (created by '..customMapsFourTeamsMode[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>', nil)
          print('<bv>'..customMapsFourTeamsMode[gameStats.customMapIndex][3]..' map (created by '..customMapsFourTeamsMode[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>')
          return
        end

        if gameStats.teamsMode then
          tfm.exec.chatMessage('<bv>'..customMapsFourTeamsMode[gameStats.customMapIndex][3]..' map (created by '..customMapsFourTeamsMode[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>', nil)
          print('<bv>'..customMapsFourTeamsMode[gameStats.customMapIndex][3]..' map (created by '..customMapsFourTeamsMode[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>')
          return
        end

        tfm.exec.chatMessage('<bv>'..customMaps[gameStats.customMapIndex][3]..' map (created by '..customMaps[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>', nil)
        return
      end

      gameStats.isCustomMap = false
      gameStats.customMapIndex = 0
      for name1, data in pairs(tfm.get.room.playerList) do
        if selectMapOpen[name1] then
          selectMapUI(name1)
        end
      end
    elseif command == "ballcoords" and name == "Refletz#6472" then
      print('X: '..tfm.get.room.objectList[ball_id].x..'')
      print('Y: '..tfm.get.room.objectList[ball_id].y..'')
    elseif command:sub(1, 8) == "setscore" and mode ~= "startGame" then
      local args = split(command)
      local isPlayerInTheRoom = false
      local scoreNumber = nil

      if #args >= 3 then
        if type(tonumber(args[3])) ~= "number" then
          tfm.exec.chatMessage("<bv>Third parameter invalid, must be a number<n>", name)

          return
        end

        scoreNumber = math.abs(math.floor(tonumber(args[3])))
      end

      if type(args[2]) ~= "string" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be a name player in the room or the value can be: red or blue<n>', name)
        return
      end

      if args[2] == "red" or args[2] == "blue" then
        if gameStats.teamsMode then
          commandNotAvailable(command:sub(1, 8), name)
          return
        end

        if type(scoreNumber) ~= "number" then
          tfm.exec.chatMessage("<bv>Third parameter invalid, must be a number and the number must be less than the actual winscore "..gameStats.winscore.."<n>", name)
          return
        end

        if scoreNumber >= gameStats.winscore then
          tfm.exec.chatMessage("<bv>Third parameter invalid, must be a number and the number must be less than the actual winscore "..gameStats.winscore.."<n>", name)
          return
        end

        if args[2] == "red" then
          score_red = scoreNumber
          tfm.exec.chatMessage("<r>Red score changed to "..score_red.." by admin "..name.."<n>", nil)
        end

        if args[2] == "blue" then
          score_blue = scoreNumber
          tfm.exec.chatMessage("<bv>Blue score changed to "..score_blue.." by admin "..name.."<n>", nil)
        end

        showTheScore()

        return
      end

      for name, data in pairs(tfm.get.room.playerList) do
        if string.lower(name) == args[2] then
          isPlayerInTheRoom = true
        end
      end

      if not isPlayerInTheRoom then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be a name player in the room<n>', name)
        return
      end

      if type(scoreNumber) == "number" then
        tfm.exec.setPlayerScore(args[2], scoreNumber, false)
        tfm.exec.chatMessage("<bv>the "..args[2].."'s score was changed to "..args[3].."<n>", name)
      else
        tfm.exec.setPlayerScore(args[2], 1, true)
        tfm.exec.chatMessage("<bv>added +1 to "..args[2].."'s score<n>", name)
      end
    elseif command:sub(1, 10) == "4teamsmode" and mode == "startGame" then
      if gameStats.twoTeamsMode then
        tfm.exec.chatMessage("<bv>You should disable the 2 teams mode first to enable the 4 teams mode<n>", nil)
        return
      end
      if gameStats.realMode then
        tfm.exec.chatMessage("<bv>You should disable the real mode first to enable the 4 teams mode<n>", nil)
        return
      end
      local args = split(command)
      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end

      gameStats.canJoin = false
      gameStats.isCustomMap = false
      gameStats.customMapIndex = 0

      if args[2] == "true" then
        if gameStats.teamsMode then
          return
        end
        resetMapsToTest()
        gameStats.teamsMode = true
        resetMapsList()
        tfm.exec.chatMessage("<bv>4-team volley mode activated by admin "..name.."<n>", nil)
        updateLobbyTextAreas(gameStats.teamsMode)
        return
      end

      if not gameStats.teamsMode then
        return
      end
      resetMapsToTest()

      gameStats.teamsMode = false
      resetMapsList()
      tfm.exec.chatMessage("<bv>4-team volley mode disabled by admin "..name.."<n>", nil)
      updateLobbyTextAreas(gameStats.teamsMode)
    elseif command:sub(1, 8) == "realmode" and mode == "startGame" then
      if gameStats.twoTeamsMode then
        tfm.exec.chatMessage("<bv>You should disable the real mode first to enable the 4 teams mode<n>", nil)
        return
      end

      if gameStats.teamsMode then
        tfm.exec.chatMessage("<bv>You should disable the realmode mode first to enable the 2 teams mode<n>", nil)
        return
      end

      local args = split(command)
      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end

      gameStats.isCustomMap = false
      gameStats.customMapIndex = 0

      if args[2] == "true" then
        gameStats.realMode = true
        resetMapsToTest()
        resetMapsList()
        tfm.exec.chatMessage("<bv>real volley mode activated by admin "..name.."<n>", nil)
        return
      end

      gameStats.realMode = false
      resetMapsList()
      resetMapsToTest()
      tfm.exec.chatMessage("<bv>real volley mode disabled by admin "..name.."<n>", nil)
    elseif command:sub(1, 5) == "admin" then
      local args = split(command)

      for name1, data in pairs(tfm.get.room.playerList) do
        if string.lower(name1) == args[2] then
          admins[name1] = true
          tfm.exec.chatMessage("<bv>Admin selected for "..name1.." command used by "..name.."<n>", nil)

          if mode == "startGame" then
            ui.addWindow(31, "<p align='center'><font size='13px'><a href='event:settings'>Room settings", name1, 180, 370, 150, 30, 1, false, false, _)

            if selectMapOpen[name1] then
              selectMapUI(name1)
            end
          end
        end
      end
    elseif command:sub(1, 7) == "unadmin" then
      local args = split(command)
      local permanentAdmin = isPermanentAdmin(name)

      for i = 1, #permanentAdmins do
        local admin = string.lower(permanentAdmins[i])
        if args[2] == admin then
          return
        end
      end

      for name1, data in pairs(playerLanguage) do
        if string.lower(name1) == args[2] then
          if name1 == getRoomAdmin and permanentAdmin then
            admins[name1] = false
            tfm.exec.chatMessage("<bv>Admin removed for "..name1.." command used by "..name.."<n>", nil)
          end
          admins[name1] = false
          tfm.exec.chatMessage("<bv>Admin removed for "..name1.." command used by "..name.."<n>", nil)

          if mode == "startGame" then
            closeWindow(31, name1)

            if selectMapOpen[name1] then
              selectMapUI(name1)
            end
          end
        end
      end
    elseif command:sub(1, 4) == "kick" then
      local args = split(command)
      local permanentAdmin = isPermanentAdmin(name)

      if not permanentAdmin then
        return
      end

      for i = 1, #permanentAdmins do
        local admin = string.lower(permanentAdmins[i])
        if args[2] == admin then
          return
        end
      end

      for name1, data in pairs(tfm.get.room.playerList) do
        if string.lower(name1) == args[2] then
          tfm.exec.kickPlayer(name1)
          tfm.exec.chatMessage("<bv>You have been kicked from the room by the admin "..name.."<n>", name1)
          tfm.exec.chatMessage("<bv>"..name.." kicked the player "..name1.." from the room<n>", nil)
          print("<bv>"..name.." kicked the player "..name1.." from the room<n>")
        end
      end
    elseif command:sub(1, 6) == "fleave" and mode == "gameStart" then
      local args = split(command)
      local permanentAdmin = isPermanentAdmin(name)

      if not permanentAdmin then
        return
      end

      for i = 1, #permanentAdmins do
        local admin = string.lower(permanentAdmins[i])
        if args[2] == admin then
          return
        end
      end

      for name1, data in pairs(tfm.get.room.playerList) do
        if string.lower(name1) == args[2] then
          if gameStats.teamsMode and gameStats.canTransform then
            leaveTeamTeamsMode(name1)
            tfm.exec.chatMessage("<bv>Force leave used on "..name1.." command used by "..name.."<n>", nil)
            return
          else
            if not gameStats.teamsMode then
              leaveTeam(name1)
              tfm.exec.chatMessage("<bv>Force leave used on "..name1.." command used by "..name.."<n>", nil)
              return
            end
            tfm.exec.chatMessage("<bv>The force leave command is disabled now, please try the same command in few seconds<n>", name)
            return
          end
        end
      end
    elseif command:sub(1, 3) == "ban" and gameStats.banCommandIsEnabled then
      local args = split(command)
      local permanentAdmin = isPermanentAdmin(name)

      if not permanentAdmin then
        return
      end

      for i = 1, #permanentAdmins do
        local admin = string.lower(permanentAdmins[i])
        if args[2] == admin then
          return
        end
      end

      for name1, data in pairs(tfm.get.room.playerList) do
        if args[2] == string.lower(name1) then
          if args[2] == string.lower(getRoomAdmin) and not permanentAdmin then
            return
          end
          playerBan[name1] = true
          tfm.exec.chatMessage("<bv>You have been banned from the room by the admin "..name.."<n>", name1)
          tfm.exec.chatMessage("<bv>"..name.." banned the player "..name1.." from the room<n>", nil)
          print("<bv>"..name.." banned the player "..name1.." from the room<n>")
          tfm.exec.kickPlayer(name1)
          playerBanHistory[name1] = name
          if mode == "startGame" then
            updateLobbyTexts(name1)
          elseif mode == "gameStart" then
            if gameStats.teamsMode and gameStats.canTransform then
              leaveTeamTeamsMode(name1)
              return
            else
              if not gameStats.teamsMode then
                leaveTeam(name1)
                return
              end
              tfm.exec.chatMessage("<bv>The force leave command is disabled now, please try the same command in few seconds<n>", name)
              return
            end
          end
        end
      end
    elseif command:sub(1, 5) == "unban" and gameStats.banCommandIsEnabled then
      local args = split(command)
      local permanentAdmin = isPermanentAdmin(name)

      for i = 1, #permanentAdmins do
        local admin = string.lower(permanentAdmins[i])
        if args[2] == admin then
          return
        end
      end

      for name1, data in pairs(playerLanguage) do
        if args[2] == string.lower(name1) then
          if args[2] == string.lower(getRoomAdmin) and not permanentAdmin then
            return
          end
          playerBan[name1] = false
          tfm.exec.chatMessage("<bv>You are not banned from the room anymore, you can play in this room again<n>", name1)
          tfm.exec.chatMessage("<bv>"..name.." unbanned the player "..name1.." from the room<n>", nil)
          print("<bv>"..name.." unbanned the player "..name1.." from the room<n>")
        end
      end
    elseif command:sub(1, 10) == "customball" and mode == "startGame" then
      local args = split(command)

      if type(tonumber(args[2])) ~= "number" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
        return
      end
      local indexMap = math.abs(math.floor(tonumber(args[2])))

      if type(indexMap) ~= "number" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
        return
      elseif indexMap < 1 or indexMap > #balls then
        tfm.exec.chatMessage('<bv>Second parameter invalid, the map index must be higher than 1 and less than '..tostring(#balls)..'<n>', name)
        return
      end

      gameStats.customBall = true
      gameStats.customBallId = indexMap

      tfm.exec.chatMessage("<bv>"..balls[gameStats.customBallId].name.." selected by admin "..name.."<n>", nil)
    elseif command:sub(1, 6) == "lobby" and mode == "gameStart" then
      ballOnGame = false
      ballOnGame2 = false
      ballOnGameTwoBalls = {ballOnGame, ballOnGame2}
      tfm.exec.removeObject(ball_id)
      mode = "endGame"
      gameTimeEnd = os.time() + 5000

      if gameStats.teamsMode then
        updateRankingFourTeamsMode()
      elseif gameStats.twoTeamsMode then
        updateRankingTwoTeamsMode()
      elseif gameStats.realMode then
        updateRankingRealMode()
      else
        updateRankingNormalMode()
      end

      tfm.exec.chatMessage("<bv>The command to reset lobby was actived by admin "..name..", the match will restart in 5 seconds<n>", nil)
    elseif command:sub(1, 8) == "killspec" then

      local findAdminPermanent = false

      for i = 1, #permanentAdmins do
        local admin = permanentAdmins[i]
        if name == admin then
          findAdminPermanent = true
        end
      end

      if findAdminPermanent then
        if mode == "startGame" then
          local boolean = command:sub(10)
          if boolean ~= "true" and boolean ~= "false" then
            tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
            return
          end

          if boolean == "true" then
            killSpecPermanent = true
            return
          end

          killSpecPermanent = false

          return

        elseif mode == "gameStart" then
          local boolean = command:sub(10)
          if boolean ~= "true" and boolean ~= "false" then
            tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
            return
          end

          if boolean == "true" then
            killSpecPermanent = true
            gameStats.killSpec = true
            for name1, data in pairs(tfm.get.room.playerList) do
              if playerInGame[name1] == false then
                tfm.exec.killPlayer(name1)
              end
            end
            return
          end

          killSpecPermanent = false
          gameStats.killSpec = false
        end
      end
    elseif command == "pause" and mode == "gameStart" then

      if gameStats.realMode then
        tfm.exec.chatMessage("<bv>The command !pause isn't available on Volley Real Mode<n>", name)

        return
      end

      local findAdminPermanent = false

      for i = 1, #permanentAdmins do
        local admin = permanentAdmins[i]
        if name == admin then
          findAdminPermanent = true
        end
      end

      if findAdminPermanent then
        if not gameStats.isGamePaused then
          gameStats.isGamePaused = true
          ballOnGame = false
          ballOnGame2 = false
          ballOnGameTwoBalls = {ballOnGame, ballOnGame2}

          tfm.exec.removeObject(ball_id)
          tfm.exec.removeObject(ball_id2)
          tfm.exec.chatMessage("<bv>Command !pause used by admin "..name.."<n>", nil)

          return
        else
          gameStats.isGamePaused = false
          spawnInitialBall()
        end
      end
    elseif command:sub(1, 4) == "sync" then
      if #command == 4 then
        local lowestSync = 10000
        local newPlayerSync = ""
        for name, data in pairs(tfm.get.room.playerList) do
          local playerSync = tfm.get.room.playerList[name].averageLatency
          if playerSync < lowestSync then
            newPlayerSync = name
            lowestSync = playerSync
          end
        end

        tfm.exec.setPlayerSync(newPlayerSync)
        tfm.exec.chatMessage("<bv>Set new player sync: "..newPlayerSync.."<n>", nil)
      else
        local permanentAdmin = isPermanentAdmin(name)

        if not permanentAdmin then
          return
        end

        local playerName = command:sub(6)
        local playerOnRoom = false
        local playerSync = 0
        for name1, data in pairs(tfm.get.room.playerList) do
          if string.lower(name1) == playerName then
            playerOnRoom = true
            playerName = name1
            playerSync = tfm.get.room.playerList[name1].averageLatency
          end
        end

        if playerOnRoom then
          tfm.exec.setPlayerSync(playerName)

          tfm.exec.chatMessage("<bv>Set new player sync: "..playerName.."<n>", nil)
        end

      end
    elseif command == "setsync" then
      windowUISync(name)
    elseif command == "synctfm" then
      tfm.exec.setPlayerSync(nil)

      local playerSync = tfm.exec.getPlayerSync()
      local syncLatency = tfm.get.room.playerList[playerSync].averageLatency

      tfm.exec.chatMessage("<bv>Set new player sync: "..playerSync.."<n>", nil)
    elseif command == "listsync" then
      local permanentAdmin = isPermanentAdmin(name)
      local playersSync = {}

      if not permanentAdmin then
        return
      end

      local str = "Sync list: <br><br>"

      for name1, data in pairs(tfm.get.room.playerList) do
        local syncCondition = textSyncCondition(tfm.get.room.playerList[name1].averageLatency)
        playersSync[#playersSync + 1] = { name = name1, sync = tfm.get.room.playerList[name1].averageLatency, syncCondition = syncCondition }
      end

      table.sort(playersSync, function(a, b) return a.sync < b.sync end)

      for i = 1, #playersSync do
        str = ""..str..""..playersSync[i].name.." - "..playersSync[i].syncCondition.."<br>"
      end

      ui.addPopup(0, 0, str, name, 300, 50, 300, true)
    elseif command:sub(1, 14) == "setplayerforce" and mode == "startGame" then
      local numberForce = tonumber(command:sub(16))
      if type(numberForce) ~= "number" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
        return
      elseif numberForce < 0 or numberForce > 1.05 then
        tfm.exec.chatMessage('<bv>The number to set the force is low or high than allowed, the value must be between (0 the minimum and 1.05 the maximum)<n>', name)
        return
      end

      gameStats.psyhicObjectForce = numberForce

      tfm.exec.chatMessage("<bv>The strength of the player's object has been changed to "..tostring(gameStats.psyhicObjectForce).."<n>", name)
      print("<bv>The strength of the player's object has been changed to "..tostring(gameStats.psyhicObjectForce).."<n>")
    elseif command == "test" and tfm.get.room.isTribeHouse and mode == "startGame" then
      playersRed[1].name = "a"
      playersRed[2].name = "a"
      playersBlue[1].name = "a"
      playersBlue[2].name = "a"
      playersGreen[1].name = "a"
      playersYellow[1].name = "a"
      eventNewGameShowLobbyTexts(gameStats.teamsMode)
    elseif command:sub(1, 10) == "2teamsmode" and mode == "startGame" then
      if gameStats.teamsMode then
        tfm.exec.chatMessage("<bv>You should disable the 4 teams mode first to enable the 2 teams mode<n>", nil)
        return
      end
      if gameStats.realMode then
        tfm.exec.chatMessage("<bv>You should disable the real mode first to enable the 2 teams mode<n>", nil)
        return
      end
      local args = split(command)
      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end

      gameStats.isCustomMap = false
      gameStats.customMapIndex = 0

      if args[2] == "true" then
        if gameStats.twoTeamsMode then
          return
        end
        resetMapsToTest()
        gameStats.twoTeamsMode = true
        resetMapsList()
        tfm.exec.chatMessage("<bv>2-team volley mode activated by admin "..name.."<n>", nil)
        return
      end

      if not gameStats.twoTeamsMode then
        return
      end

      resetMapsToTest()
      resetMapsList()
      gameStats.twoTeamsMode = false
      resetMapsList()
      tfm.exec.chatMessage("<bv>2-team volley mode disabled by admin "..name.."<n>", nil)
    elseif command:sub(1, 9) == "afksystem" and false and mode == "startGame" then
      local args = split(command)
      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end
      if args[2] == "true" then
        enableAfkSystem = true
        tfm.exec.chatMessage("<bv>The afk system has enabled by the admin "..name.."<n>", nil)
        return
      end

      enableAfkSystem = false
      tfm.exec.chatMessage("<bv>The afk system has disabled by the admin "..name.."<n>", nil)

      return
    elseif command:sub(1, 10) == "setafktime" and false then
      local args = split(command)
      if type(tonumber(args[2])) ~= "number" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
        return
      end

      local afkTime = math.abs(math.floor(tonumber(args[2])))

      if type(afkTime) ~= "number" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
        return
      end

      if afkTime < 60 then
        tfm.exec.chatMessage("<bv>Second invalid parameter, the time in seconds must be greater than or equal to 60<n>", name)
        return
      end

      afkTimeValue = math.abs(afkTime - (afkTime * 2))

      tfm.exec.chatMessage("<bv>Afk timeout changed to "..afkTime.." seconds by admin "..name.."<n>", nil)
    elseif command:sub(1, 8) == "twoballs" and mode == "startGame" then
      local args = split(command)
      print(args[2])
      if gameStats.realMode then
        tfm.exec.chatMessage("<bv>The command two balls isn't available for Volley Real Mode<n>", name)

        return
      end
      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end
      if args[2] == "true" then
        gameStats.twoBalls = true
        tfm.exec.chatMessage("<bv>Two balls on game has enabled by the admin "..name.."<n>", nil)
        return
      end

      gameStats.twoBalls = false
      tfm.exec.chatMessage("<bv>Two balls on 4 teams has disabled by the admin "..name.."<n>", nil)
    elseif command:sub(1, 11) == "consumables" and mode == "startGame" then
      local args = split(command)

      if not gameStats.teamsMode and not gameStats.twoTeamsMode and not gameStats.realMode then
        tfm.exec.chatMessage("<bv>The command consumables only works on normal mode<n>", name)
      end

      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end

      if args[2] == "true" then
        gameStats.consumables = true
        tfm.exec.chatMessage("<bv>Consumables on normal mode has enabled by the admin "..name.."<n>", nil)
        return
      end

      gameStats.consumables = false
      tfm.exec.chatMessage("<bv>Consumables on normal mode has disabled by the admin "..name.."<n>", nil)
    elseif command == "settings" then
      closeRankingUI(name)
      removeUITrophies(name)
      settings[name] = true
      ui.addWindow(24, ""..playerLanguage[name].tr.titleSettings.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
      ui.addTextArea(99992, ""..playerLanguage[name].tr.textSettings, name, 150, 110, 500, 200, 0x161616, 0x161616, 0, true)
      ui.addWindow(25, "<p align='center'><font size='11px'><a href='event:openMode'>Select a mode</a>", name, 665, 110, 100, 30, 1, false, false)
      if globalSettings.twoBalls then
        ui.addWindow(21, "<p align='center'><font size='11px'><a href='event:twoballs'>Enabled</a>", name, 665, 250, 100, 30, 1, false, false)

        return
      end
      ui.addWindow(21, "<p align='center'><font size='11px'><a href='event:twoballs'>Disabled</a>", name, 665, 250, 100, 30, 1, false, false)
    elseif command:sub(1, 2) == "np" and tfm.get.room.isTribeHouse and mode == "startGame" then
      local args = split(command)
      local regexMap = "^@%d%d%d%d%d%d%d$"

      if gameStats.realMode then
        tfm.exec.chatMessage("<bv>There aren't availables maps to test on volley real mode", name)

        return
      end

      if gameStats.setMapName == "extra-large" then
        tfm.exec.chatMessage("<bv>There aren't availables maps to test on extra-large map", name)

        return
      end

      if gameStats.teamsMode then
        if type(args[2]) == "nil" then
          tfm.exec.chatMessage("<bv>Second parameter invalid, must be a tfm map like @3493212<n>", name)

          return
        end
        if string.match(args[2], regexMap) == nil then
          tfm.exec.chatMessage("<bv>Second parameter invalid, must be a tfm map like @3493212<n>", name)

          return
        end

        mapsToTest[1] = args[2]

        if type(args[3]) == "nil" then
          mapsToTest[2] = '<C><P F="3" L="1200" G="0,4" /><Z><S><S H="100" L="1200" X="600" c="3" N="" Y="400" T="7" P="0,0,.1,.2,,0,0,0" /><S L="1200" X="600" H="10" Y="430" T="9" P="0,0,,,,0,0,0" /><S L="10" H="200" X="400" Y="350" T="1" P="0,0,.0,,,0,0,0" /><S P="0,0,.3,.2,,0,0,0" L="800" o="6a7495" X="400" Y="455" T="12" H="10" /><S H="3000" L="10" o="6a7495" X="-5" c="1" Y="0" T="12" P="0,0,.2,,,0,0,0" /><S H="3000" L="10" o="6a7495" X="1200" c="1" Y="0" T="12" P="0,0,.2,,,0,0,0" /><S H="10" L="10" o="324650" X="100" c="3" Y="359" T="13" P="0,0,.3,.2,,0,0,0" /><S X="600" L="10" o="324650" H="10" c="3" Y="359" T="13" P="0,0,.3,.2,,0,0,0" /><S P="0,0,.3,.2,,0,0,0" L="100" o="324650" X="250" c="4" Y="45" T="12" H="105" /><S P="0,0,0,0.2,0,0,0,0" L="1200" X="600" c="3" Y="0" T="1" H="10" /><S P="0,0,0.3,0.2,0,0,0,0" L="1200" X="600" c="3" Y="95" T="0" m="" H="10" /><S P="0,0,0.3,0.2,0,0,0,0" L="10" X="305" c="3" Y="48" T="0" m="" H="100" /><S P="0,0,0.3,0.2,0,0,0,0" L="10" H="100" c="3" Y="48" T="0" m="" X="900" /><S H="10" L="1200" X="601" c="3" Y="225" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S H="30" L="10" X="400" c="3" Y="239" T="0" m="" P="0,0,0,0,0,0,0,0" /><S H="10" L="800" X="400" c="3" Y="791" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" /><S P="0,0,.2,,,0,0,0" L="20" o="6a7495" X="316" c="3" Y="-129" T="12" H="200" /><S H="200" L="20" o="6a7495" X="407" c="3" Y="-133" T="12" P="0,0,.2,,,0,0,0" /><S P="0,0,.2,,90,0,0,0" L="20" o="6a7495" X="363" c="3" Y="-92" T="12" H="100" /><S H="100" L="20" o="6a7495" X="360" c="3" Y="-206" T="12" P="0,0,.2,,90,0,0,0" /><S P="0,0,0.3,0.2,0,0,0,0" L="3000" o="6a7495" X="400" c="4" N="" Y="460" T="12" H="120" /><S H="105" L="100" o="324650" X="950" c="4" Y="45" T="12" P="0,0,.3,.2,,0,0,0" /><S H="10" L="1200" X="600" c="1" Y="-800" T="1" P="0,0,0,0.2,0,0,0,0" /><S L="10" X="800" H="200" Y="350" T="1" P="0,0,.0,,,0,0,0" /><S P="0,0,0,0,0,0,0,0" L="10" H="30" c="3" Y="239" T="0" m="" X="800" /><S P="0,0,0.3,0.2,90,0,0,0" L="800" H="10" c="3" Y="791" T="0" m="" X="800" /><S P="0,0,.3,.2,,0,0,0" L="10" o="324650" H="10" c="3" Y="359" T="13" X="1100" /><S P="0,0,.3,.2,,0,0,0" L="100" o="324650" X="600" c="4" Y="45" T="12" H="105" /></S><D><P P="1" Y="363" T="10" X="599" /><P X="99" Y="363" T="10" P="1" /><DS Y="-141" X="365" /><P X="1099" Y="363" T="10" P="1" /></D><O /></Z></C>'
          tfm.exec.chatMessage("<bv>Warning: in 4-team mode, the !np command should be !np @map @map @map, but if you only have one map ready and want to test it, the game will set the default map for the other maps<n>", name)
          print("<bv>Warning: in 4-team mode, the !np command should be !np @map @map @map, but if you only have one map ready and want to test it, the game will set the default map for the other maps<n>")
        else
          if string.match(args[3], regexMap) == nil then
            tfm.exec.chatMessage("<bv>Third parameter invalid, must be a tfm map like @3493212<n>", name)

            return
          else
            mapsToTest[2] = args[3]
          end
        end

        if type(args[4]) == "nil" then
          mapsToTest[3] = '<C><P G="0,4" F="0" /><Z><S><S X="400" L="800" H="100" c="3" N="" Y="400" T="7" P="0,0,.1,.2,,0,0,0" /><S L="800" X="400" H="10" Y="430" T="9" P="0,0,,,,0,0,0" /><S L="10" H="200" X="400" Y="350" T="1" P="0,0,.0,,,0,0,0" /><S L="800" o="6a7495" X="400" H="10" Y="455" T="12" P="0,0,.3,.2,,0,0,0" /><S H="3000" L="10" o="6a7495" X="-5" c="1" Y="0" T="12" P="0,0,.2,,,0,0,0" /><S H="3000" L="10" o="6a7495" X="805" c="1" Y="0" T="12" P="0,0,.2,,,0,0,0" /><S H="10" L="10" o="324650" X="100" c="3" Y="359" T="13" P="0,0,.3,.2,,0,0,0" /><S X="700" L="10" o="324650" H="10" c="3" Y="359" T="13" P="0,0,.3,.2,,0,0,0" /><S P="0,0,.3,.2,,0,0,0" L="100" o="324650" X="50" c="4" Y="45" T="12" H="105" /><S P="0,0,0,0.2,0,0,0,0" L="800" H="10" c="3" N="" Y="0" T="1" X="400" /><S P="0,0,0.3,0.2,0,0,0,0" L="800" H="10" c="3" N="" Y="95" T="0" m="" X="400" /><S P="0,0,0.3,0.2,0,0,0,0" L="10" H="100" c="3" Y="48" T="0" m="" X="105" /><S P="0,0,0.3,0.2,0,0,0,0" L="10" X="700" c="3" N="" Y="48" T="0" m="" H="100" /><S X="401" L="800" H="10" c="3" Y="225" T="0" m="" P="0,0,0.3,0.2,0,0,0,0" /><S X="400" L="10" H="30" c="3" Y="239" T="0" m="" P="0,0,0,0,0,0,0,0" /><S X="400" L="800" H="10" c="3" Y="791" T="0" m="" P="0,0,0.3,0.2,90,0,0,0" /><S P="0,0,.2,,,0,0,0" L="20" o="6a7495" X="316" c="3" Y="-129" T="12" H="200" /><S H="200" L="20" o="6a7495" X="407" c="3" Y="-133" T="12" P="0,0,.2,,,0,0,0" /><S P="0,0,.2,,90,0,0,0" L="20" o="6a7495" X="363" c="3" Y="-92" T="12" H="100" /><S H="100" L="20" o="6a7495" X="360" c="3" Y="-206" T="12" P="0,0,.2,,90,0,0,0" /><S P="0,0,0.3,0.2,0,0,0,0" L="3000" o="6a7495" X="400" c="4" N="" Y="460" T="12" H="120" /><S H="105" L="100" o="324650" X="750" c="4" Y="45" T="12" P="0,0,.3,.2,,0,0,0" /><S X="400" L="800" H="10" c="1" N="" Y="-800" T="1" P="0,0,0,0.2,0,0,0,0" /></S><D><P X="699" Y="365" T="10" P="1" /><P P="1" Y="365" T="10" X="99" /><DS Y="-151" X="360" /></D><O /></Z></C>'
          tfm.exec.chatMessage("<bv>Warning: in 4-team mode, the !np command should be !np @map @map @map, but if you only have one map ready and want to test it, the game will set the default map for the other maps<n>", name)
          print("<bv>Warning: in 4-team mode, the !np command should be !np @map @map @map, but if you only have one map ready and want to test it, the game will set the default map for the other maps<n>")
        else
          if string.match(args[4], regexMap) == nil then
            tfm.exec.chatMessage("<bv>Fourth parameter invalid, must be a tfm map like @3493212<n>", name)

            return
          else
            mapsToTest[3] = args[4]
          end
        end

        tfm.exec.chatMessage("<bv>Test map successfully selected<n>", nil)

        return
      end

      if type(args[2]) == "nil" then
        tfm.exec.chatMessage("<bv>Second parameter invalid, must be a tfm map like @3493212<n>", name)

        return
      end
      if string.match(args[2], regexMap) == nil then
        tfm.exec.chatMessage("<bv>Second parameter invalid, must be a tfm map like @3493212<n>", name)

        return
      end

      mapsToTest[1] = args[2]
      tfm.exec.chatMessage("<bv>Test map successfully selected<n>", nil)
    end
  end
end

function maxPlayers()
  local maxPlayers = 0
  if gameStats.gameMode == "3v3" then
    maxPlayers = 3
  elseif gameStats.gameMode == "4v4" or gameStats.gameMode == "6v6" then
    maxPlayers = 6
  end

  return maxPlayers
end

function getQuantityPlayers()
  local quantity = {yellow = 0, red = 0, blue = 0, green = 0}
  if gameStats.typeMap == "large4v4" then
    for i = 1, #playersYellow do
      if playersYellow[i].name ~= "" then
        quantity.yellow = quantity.yellow + 1
      end
    end
    for i = 1, #playersRed do
      if playersRed[i].name ~= "" then
        quantity.red = quantity.red + 1
      end
    end
    for i = 1, #playersBlue do
      if playersBlue[i].name ~= "" then
        quantity.blue = quantity.blue + 1
      end
    end
    for i = 1, #playersGreen do
      if playersGreen[i].name ~= "" then
        quantity.green = quantity.green + 1
      end
    end

    return quantity
  elseif gameStats.typeMap ~= "large4v4" then
    local quantity = {}
    local count = 0
    for i = 1, #teamsPlayersOnGame do
      for j = 1, #teamsPlayersOnGame[i] do
        if teamsPlayersOnGame[i][j].name ~= '' then
          count = count + 1
        end
      end
      if count > 0 then
        quantity[#quantity + 1] = count
      end

      count = 0
    end
    return quantity
  end
end

function getSmallQuantity(quantity)
  local quantityNumbers = {quantity.yellow, quantity.red, quantity.blue, quantity.green}
  local smallNumber = 9999
  local index = 0
  for i = 1, #quantityNumbers do
    if quantityNumbers[i] < smallNumber and quantityNumbers[i] > 0 then
      smallNumber = quantityNumbers[i]
      index = i
    end
  end

  local smallQuantity = {[1] = smallNumber, [2] = index}
  return smallQuantity
end

function getSmallQuantity1(quantity)
  local smallNumber = 9999
  local index = 0

  for i = 1, #quantity do
    if quantity[i] < smallNumber and quantity[i] > 0 then
      smallNumber = quantity[i]
      index = i
    end
  end

  local smallQuantity = {[1] = smallNumber, [2] = index}
  return smallQuantity
end

function chooseTeamTeamsMode(name)
  local quantity = getQuantityPlayers()
  local smallQuantity = ""
  if gameStats.typeMap == "large4v4" then
    smallQuantity = getSmallQuantity(quantity)
  else
    smallQuantity = getSmallQuantity1(quantity)
  end
  if gameStats.typeMap == "large4v4" then
    if smallQuantity[2] == 1 and quantity.yellow < 3 then
      for i= 1, #playersYellow do
        if playersYellow[i].name == '' then
          local isNewTeam = playerHistoryOnMatch("yellow", name)

          if isNewTeam then
            local playerTeams = playersOnGameHistoric[name].teams
            playersOnGameHistoric[name].teams[#playerTeams + 1] = "yellow"

            addMatchToPlayerFourTeamsMode(name)
          end
          playersYellow[i].name = name
          playerInGame[name] = true
          tfm.exec.setNameColor(playersYellow[i].name, 0xF59E0B)
          if #playersSpawn400 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn400, name)
          else
            tfm.exec.movePlayer(name, 200, 334)
          end

          disablePlayerCanTransform(name)

          return
        end
      end
    elseif smallQuantity[2] == 2 and quantity.red < 3 then
      for i= 1, #playersRed do
        if playersRed[i].name == '' then
          local isNewTeam = playerHistoryOnMatch("red", name)

          if isNewTeam then
            local playerTeams = playersOnGameHistoric[name].teams
            playersOnGameHistoric[name].teams[#playerTeams + 1] = "red"

            addMatchToPlayerFourTeamsMode(name)
          end
          playersRed[i].name = name
          playerInGame[name] = true
          tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, name)
          else
            tfm.exec.movePlayer(name, 600, 334)
          end

          disablePlayerCanTransform(name)

          return
        end
      end
    elseif smallQuantity[2] == 3 and quantity.blue < 3 then
      for i= 1, #playersBlue do
        if playersBlue[i].name == '' then
          local isNewTeam = playerHistoryOnMatch("blue", name)

          if isNewTeam then
            local playerTeams = playersOnGameHistoric[name].teams
            playersOnGameHistoric[name].teams[#playerTeams + 1] = "blue"

            addMatchToPlayerFourTeamsMode(name)
          end
          playersBlue[i].name = name
          playerInGame[name] = true
          tfm.exec.setNameColor(playersBlue[i].name, 0x3B82F6)
          if #playersSpawn1200 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn1200, name)
          else
            tfm.exec.movePlayer(name, 1000, 334)
          end

          disablePlayerCanTransform(name)

          return
        end
      end

    elseif smallQuantity[2] == 4 and quantity.green < 3 then
      for i= 1, #playersGreen do
        if playersGreen[i].name == '' then
          local isNewTeam = playerHistoryOnMatch("green", name)

          if isNewTeam then
            local playerTeams = playersOnGameHistoric[name].teams
            playersOnGameHistoric[name].teams[#playerTeams + 1] = "green"

            addMatchToPlayerFourTeamsMode(name)
          end
          playersGreen[i].name = name
          playerInGame[name] = true
          tfm.exec.setNameColor(playersGreen[i].name, 0x109267)
          if #playersSpawn1600 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn1600, name)
          else
            tfm.exec.movePlayer(name, 1400, 334)
          end

          disablePlayerCanTransform(name)

          return
        end
      end
    else
      tfm.exec.chatMessage("<bv>The teams are full<n>", name)
    end
  elseif gameStats.typeMap == "large3v3" or gameStats.typeMap == "small" then
    local x = {200, 600, 1000}
    local playersSpawn = { playersSpawn400, playersSpawn800, playersSpawn1200 }
    print("a")
    print(smallQuantity[2])
    for i = 1, #teamsPlayersOnGame do
      if i == smallQuantity[2] then
        for j = 1, #teamsPlayersOnGame[smallQuantity[2]] do
          if teamsPlayersOnGame[smallQuantity[2]][j].name == '' then
            local team = getTeamName(messageTeamsLifes[smallQuantity[2]])

            if team == "Yellow" then
              local isNewTeam = playerHistoryOnMatch("yellow", name)

              if isNewTeam then
                local playerTeams = playersOnGameHistoric[name].teams
                playersOnGameHistoric[name].teams[#playerTeams + 1] = "yellow"

                addMatchToPlayerFourTeamsMode(name)
              end
            elseif team == "Red" then
              local isNewTeam = playerHistoryOnMatch("red", name)

              if isNewTeam then
                local playerTeams = playersOnGameHistoric[name].teams
                playersOnGameHistoric[name].teams[#playerTeams + 1] = "red"

                addMatchToPlayerFourTeamsMode(name)
              end
            elseif team == "Blue" then
              local isNewTeam = playerHistoryOnMatch("blue", name)

              if isNewTeam then
                local playerTeams = playersOnGameHistoric[name].teams
                playersOnGameHistoric[name].teams[#playerTeams + 1] = "blue"

                addMatchToPlayerFourTeamsMode(name)
              end
            elseif team == "Green" then
              local isNewTeam = playerHistoryOnMatch("green", name)

              if isNewTeam then
                local playerTeams = playersOnGameHistoric[name].teams
                playersOnGameHistoric[name].teams[#playerTeams + 1] = "green"

                addMatchToPlayerFourTeamsMode(name)
              end
            end
            teamsPlayersOnGame[smallQuantity[2]][j].name = name
            playerInGame[name] = true
            tfm.exec.setNameColor(name, getTeamsColorsName[smallQuantity[2]])
            if #playersSpawn[smallQuantity[2]] > 0 then
              teleportPlayerWithSpecificSpawn(playersSpawn[smallQuantity[2]], name)
            else
              tfm.exec.movePlayer(name, x[smallQuantity[2]], 334)
            end

            disablePlayerCanTransform(name)

            return
          end
        end
      end
    end
  end
end

function leaveTeamTeamsMode(name)
  playerInGame[name] = false
  tfm.exec.setNameColor(name, 0xD1D5DB)

  leaveTeamTeamsModeConfig(name)

end

function leaveTeamTeamsModeConfig(name)
  local count = 0
  local index = 1

  if gameStats.typeMap == "large4v4" then
    for i= 1, #playersYellow do
      if playersYellow[i].name == name then
        playersYellow[i].name = ''
        tfm.exec.killPlayer(name)
        removePlayerOnSpawnConfig(name)

        local movePlayer = addTimer(function(i)
          tfm.exec.respawnPlayer(name)

          teleportPlayersToSpecWithSpecificSpawn(name)
        end, 1000, 1, "movePlayer")
      end

      if playersYellow[i].name ~= '' then
        count = count + 1
      end
    end
    if count == 0 then
      ballOnGame = false
      ballOnGame2 = false
      ball_id = nil
      ball_id2 = nil
      updateTwoBallOnGame()
      tfm.exec.chatMessage("<j>Yellow team lost all their lives<n>", nil)
      teamsLifes[1].yellow = 0
      toggleMapType()
      updateTeamsColors(1)
      gameStats.canTransform = false
      disablePlayersCanTransform(4000)
      delayToToggleMap = addTimer(function(i)
        if i == 1 then
          toggleMap()
        end
      end, 3000, 1, "delayToToggleMap")

      return
    end

    count = 0

    for i= 1, #playersRed do
      if playersRed[i].name == name then
        playersRed[i].name = ''
        tfm.exec.killPlayer(name)
        removePlayerOnSpawnConfig(name)

        local movePlayer = addTimer(function(i)
          tfm.exec.respawnPlayer(name)
          teleportPlayersToSpecWithSpecificSpawn(name)
        end, 1000, 1, "movePlayer")
      end

      if playersRed[i].name ~= '' then
        count = count + 1
      end
    end

    if count == 0 then
      ballOnGame = false
      ballOnGame2 = false
      ball_id = nil
      ball_id2 = nil
      updateTwoBallOnGame()
      tfm.exec.chatMessage("<r>Red team lost all their lives<n>", nil)
      teamsLifes[2].red = 0
      toggleMapType()
      updateTeamsColors(2)
      gameStats.canTransform = false
      disablePlayersCanTransform(4000)
      delayToToggleMap = addTimer(function(i)
        if i == 1 then
          toggleMap()
        end
      end, 3000, 1, "delayToToggleMap")
      return
    end

    count = 0

    for i= 1, #playersBlue do
      if playersBlue[i].name == name then
        playersBlue[i].name = ''
        tfm.exec.killPlayer(name)
        removePlayerOnSpawnConfig(name)

        local movePlayer = addTimer(function(i)
          tfm.exec.respawnPlayer(name)
          teleportPlayersToSpecWithSpecificSpawn(name)
        end, 1000, 1, "movePlayer")
      end

      if playersBlue[i].name ~= '' then
        count = count + 1
      end
    end

    if count == 0 then
      ballOnGame = false
      ballOnGame2 = false
      ball_id = nil
      ball_id2 = nil
      updateTwoBallOnGame()
      tfm.exec.chatMessage("<bv>Blue team lost all their lives<n>", nil)
      teamsLifes[3].blue = 0
      toggleMapType()
      updateTeamsColors(3)
      gameStats.canTransform = false
      disablePlayersCanTransform(4000)
      delayToToggleMap = addTimer(function(i)
        if i == 1 then
          toggleMap()
        end
      end, 3000, 1, "delayToToggleMap")
      return
    end

    count = 0

    for i= 1, #playersGreen do
      if playersGreen[i].name == name then
        playersGreen[i].name = ''
        tfm.exec.killPlayer(name)
        removePlayerOnSpawnConfig(name)

        local movePlayer = addTimer(function(i)
          tfm.exec.respawnPlayer(name)
          teleportPlayersToSpecWithSpecificSpawn(name)
        end, 1000, 1, "movePlayer")
      end

      if playersGreen[i].name ~= '' then
        count = count + 1
      end
    end

    if count == 0 then
      ballOnGame = false
      ballOnGame2 = false
      ball_id = nil
      ball_id2 = nil
      updateTwoBallOnGame()
      tfm.exec.chatMessage("<vp>Green team lost all their lives<n>", nil)
      teamsLifes[4].green = 0
      toggleMapType()
      updateTeamsColors(3)
      gameStats.canTransform = false
      disablePlayersCanTransform(4000)
      delayToToggleMap = addTimer(function(i)
        if i == 1 then
          toggleMap()
        end
      end, 3000, 1, "delayToToggleMap")
      return
    end
  elseif gameStats.typeMap == "large3v3" then
    for i = 1, #getTeamsLifes do
      for j = 1, #teamsPlayersOnGame[i] do
        if teamsPlayersOnGame[i][j].name == name then
          teamsPlayersOnGame[i][j].name = ''
          tfm.exec.killPlayer(name)
          removePlayerOnSpawnConfig(name)

          local movePlayer = addTimer(function(i)
            tfm.exec.respawnPlayer(name)
            teleportPlayersToSpecWithSpecificSpawn(name)
          end, 1000, 1, "movePlayer")
        end

        if teamsPlayersOnGame[i][j].name ~= '' then
          count = count + 1
        end
      end

      if count == 0 then
        ballOnGame = false
        ballOnGame2 = false
        ball_id = nil
        ball_id2 = nil
        updateTwoBallOnGame()
        tfm.exec.chatMessage(messageTeamsLifes[index], nil)
        print(messageTeamsLifes[index])
        updateTeamsColors(index)
        toggleMapType()
        gameStats.canTransform = false
        disablePlayersCanTransform(4000)
        delayToToggleMap = addTimer(function(i)
          if i == 1 then
            toggleMap()
          end
        end, 3000, 1, "delayToToggleMap")
        return
      end

      count = 0
      index = index + 1
    end
  elseif gameStats.typeMap == "small" then
    for i = 1, #getTeamsLifes do
      for j = 1, #teamsPlayersOnGame[i] do
        if teamsPlayersOnGame[i][j].name == name then
          teamsPlayersOnGame[i][j].name = ''
          tfm.exec.killPlayer(name)
          removePlayerOnSpawnConfig(name)

          local movePlayer = addTimer(function(i)
            tfm.exec.respawnPlayer(name)
            teleportPlayersToSpecWithSpecificSpawn(name)
          end, 1000, 1, "movePlayer")
        end

        if teamsPlayersOnGame[i][j].name ~= '' then
          count = count + 1
        end
      end

      if count == 0 then
        tfm.exec.chatMessage(messageTeamsLifes[index], nil)
        print(messageTeamsLifes[index])
        showTheScore()
        updateTeamsColors(index)
        showMessageWinner()
        ballOnGame = false
        ballOnGame2 = false
        ball_id = nil
        ball_id2 = nil
        updateTwoBallOnGame()
        fourTeamsModeWinner(messageTeamsLifes[1], teamsPlayersOnGame[1])
        updateRankingFourTeamsMode()
        tfm.exec.removeObject (ball_id)
        mode = "endGame"
        gameTimeEnd = os.time() + 5000
        return
      end

      count = 0
      index = index + 1
    end
  end
end

function getQuantityPlayersOnPosition(team)
  local quantity = {middle = 0, back = 0}

  if team == "red" then
    for i = 1, #playersRed do
      if playersRed[i].name ~= '' then
        if twoTeamsPlayerRedPosition[i] == "middle" then
          quantity.middle = quantity.middle + 1
        elseif twoTeamsPlayerRedPosition[i] == "back" then
          quantity.back = quantity.back + 1
        end
      end
    end

    return quantity
  end

  for i = 1, #playersBlue do
    if playersBlue[i].name ~= '' then
      if twoTeamsPlayerBluePosition[i] == "middle" then
        quantity.middle = quantity.middle + 1
      elseif twoTeamsPlayerBluePosition[i] == "back" then
        quantity.back = quantity.back + 1
      end
    end
  end

  return quantity

end

function chooseTeam(name)
  local maxPlayersOnGame = maxPlayers()
  if gameStats.twoTeamsMode or gameStats.realMode then
    maxPlayersOnGame = 6
  end
  local quantity = quantityPlayers()
  if quantity.red < quantity.blue and quantity.red < maxPlayersOnGame then
    for i = 1, 6 do
      if playersRed[i].name == '' then
        local isNewTeam = playerHistoryOnMatch("red", name)

        if isNewTeam then
          local playerTeams = playersOnGameHistoric[name].teams
          playersOnGameHistoric[name].teams[#playerTeams + 1] = "red"

          if gameStats.twoTeamsMode then
            addMatchToPlayerTwoTeamsMode(name)
          elseif gameStats.realMode then
            addMatchToPlayerRealMode(name)
          else
            addMatchToPlayer(name)
          end
        end
        playersRed[i].name = name
        playerInGame[name] = true
        tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
        disablePlayerCanTransform(name)

        if gameStats.realMode then
          tfm.exec.movePlayer(name, 900, 334)

          return
        end

        if gameStats.twoTeamsMode then
          local quantity = getQuantityPlayersOnPosition("red")

          if quantity.middle < quantity.back then
            if #playersSpawn800 > 0 then
              teleportPlayerWithSpecificSpawn(playersSpawn800, name)
            else
              tfm.exec.movePlayer(name, 600, 334)
            end

            twoTeamsPlayerRedPosition[i] = "middle"
          elseif quantity.back < quantity.middle then
            if #playersSpawn1600 > 0 then
              teleportPlayerWithSpecificSpawn(playersSpawn1600, name)
            else
              tfm.exec.movePlayer(name, 1400, 334)
            end

            twoTeamsPlayerRedPosition[i] = "back"
          else
            if #playersSpawn800 > 0 then
              teleportPlayerWithSpecificSpawn(playersSpawn800, name)
            else
              tfm.exec.movePlayer(name, 600, 334)
            end

            twoTeamsPlayerRedPosition[i] = "middle"
          end

          break
        end
        if gameStats.gameMode == "3v3" then
          if #playersSpawn400 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn400, name)
          else
            tfm.exec.movePlayer(name, 101, 334)
          end
        elseif gameStats.gameMode == "4v4" then
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, name)
          else
            tfm.exec.movePlayer(name, 301, 334)
          end
        else
          tfm.exec.movePlayer(name, 401, 334)
        end

        break
      end
    end
    return
  elseif quantity.blue < quantity.red and quantity.blue < maxPlayersOnGame then
    for i = 1, 6 do
      if playersBlue[i].name == '' then
        local isNewTeam = playerHistoryOnMatch("blue", name)

        if isNewTeam then
          local playerTeams = playersOnGameHistoric[name].teams
          playersOnGameHistoric[name].teams[#playerTeams + 1] = "blue"

          if gameStats.twoTeamsMode then
            addMatchToPlayerTwoTeamsMode(name)
          elseif gameStats.realMode then
            addMatchToPlayerRealMode(name)
          else
            addMatchToPlayer(name)
          end
        end
        playersBlue[i].name = name
        playerInGame[name] = true
        tfm.exec.setNameColor(playersBlue[i].name, 0x3B82F6)
        disablePlayerCanTransform(name)

        if gameStats.realMode then
          tfm.exec.movePlayer(name, 1700, 334)

          return
        end

        if gameStats.twoTeamsMode then
          local quantity = getQuantityPlayersOnPosition("blue")

          if quantity.middle < quantity.back then
            if #playersSpawn1200 > 0 then
              teleportPlayerWithSpecificSpawn(playersSpawn1200, name)
            else
              tfm.exec.movePlayer(name, 1000, 334)
            end

            twoTeamsPlayerBluePosition[i] = "middle"
          elseif quantity.back < quantity.middle then
            if #playersSpawn400 > 0 then
              teleportPlayerWithSpecificSpawn(playersSpawn400, name)
            else
              tfm.exec.movePlayer(name, 200, 334)
            end

            twoTeamsPlayerBluePosition[i] = "back"
          else
            if #playersSpawn1200 > 0 then
              teleportPlayerWithSpecificSpawn(playersSpawn1200, name)
            else
              tfm.exec.movePlayer(name, 1000, 334)
            end

            twoTeamsPlayerBluePosition[i] = "middle"
          end

          break
        end
        if gameStats.gameMode == "3v3" then
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, name)
          else
            tfm.exec.movePlayer(name, 700, 334)
          end
        elseif gameStats.gameMode == "4v4" then
          if #playersSpawn1600 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn1600, name)
          else
            tfm.exec.movePlayer(name, 900, 334)
          end
        else
          tfm.exec.movePlayer(name, 1500, 334)
        end

        break
      end
    end
    return
  elseif quantity.red == quantity.blue and quantity.red < maxPlayersOnGame then
    for i = 1, 6 do
      if playersRed[i].name == '' then
        local isNewTeam = playerHistoryOnMatch("red", name)

        if isNewTeam then
          local playerTeams = playersOnGameHistoric[name].teams
          playersOnGameHistoric[name].teams[#playerTeams + 1] = "red"

          if gameStats.twoTeamsMode then
            addMatchToPlayerTwoTeamsMode(name)
          elseif gameStats.realMode then
            addMatchToPlayerRealMode(name)
          else
            addMatchToPlayer(name)
          end
        end
        playersRed[i].name = name
        playerInGame[name] = true
        tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
        disablePlayerCanTransform(name)

        if gameStats.realMode then
          tfm.exec.movePlayer(name, 900, 334)

          return
        end

        if gameStats.twoTeamsMode then
          local quantity = getQuantityPlayersOnPosition("red")
          print(quantity.middle)
          print(quantity.back)

          if quantity.middle < quantity.back then
            tfm.exec.movePlayer(name, 600, 334)
            twoTeamsPlayerRedPosition[i] = "middle"
          elseif quantity.back < quantity.middle then
            tfm.exec.movePlayer(name, 1400, 334)
            twoTeamsPlayerRedPosition[i] = "back"
          else
            tfm.exec.movePlayer(name, 600, 334)
            twoTeamsPlayerRedPosition[i] = "middle"
          end

          break
        end
        if gameStats.gameMode == "3v3" then
          if #playersSpawn400 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn400, name)
          else
            tfm.exec.movePlayer(name, 101, 334)
          end
        elseif gameStats.gameMode == "4v4" then
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, name)
          else
            tfm.exec.movePlayer(name, 301, 334)
          end
        else
          tfm.exec.movePlayer(name, 401, 334)
        end

        break
      end
    end
    return
  else
    tfm.exec.chatMessage("<bv>The teams are full<n>", name)
  end
end

function leaveTeam(name)
  playerInGame[name] = false
  tfm.exec.setNameColor(name, 0xD1D5DB)
  for i = 1, #playersRed do
    if playersRed[i].name == name then
      playersRed[i].name = ''
      twoTeamsPlayerRedPosition[i] = ""
      removePlayerOnSpawnConfig(name)
      leaveConfigRealMode(name)
      if killSpecPermanent then
        tfm.exec.killPlayer(name)
      else
        tfm.exec.killPlayer(name)

        local movePlayer = addTimer(function(i)
          tfm.exec.respawnPlayer(name)

          teleportPlayersToSpecWithSpecificSpawn(name)
        end, 1000, 1, "movePlayer")
      end
    end
    if playersBlue[i].name == name then
      playersBlue[i].name = ''
      twoTeamsPlayerBluePosition[i] = ""
      removePlayerOnSpawnConfig(name)
      leaveConfigRealMode(name)
      if killSpecPermanent then
        tfm.exec.killPlayer(name)
      else
        tfm.exec.killPlayer(name)

        local movePlayer = addTimer(function(i)
          tfm.exec.respawnPlayer(name)

          teleportPlayersToSpecWithSpecificSpawn(name)
        end, 1000, 1, "movePlayer")
      end
    end
  end
end

function removePlayerOnSpawnConfig(name)
  for i = 1, #playersSpawn400 do
    for j = 1, #playersSpawn400[i].players do
      if playersSpawn400[i].players[j] == name then
        table.remove(playersSpawn400[i].players, j)

        return
      end
    end
  end

  for i = 1, #playersSpawn800 do
    for j = 1, #playersSpawn800[i].players do
      if playersSpawn800[i].players[j] == name then
        table.remove(playersSpawn800[i].players, j)

        return
      end
    end
  end

  for i = 1, #playersSpawn1200 do
    for j = 1, #playersSpawn1200[i].players do
      if playersSpawn1200[i].players[j] == name then
        table.remove(playersSpawn1200[i].players, j)

        return
      end
    end
  end

  for i = 1, #playersSpawn1600 do
    for j = 1, #playersSpawn1600[i].players do
      if playersSpawn1600[i].players[j] == name then
        table.remove(playersSpawn1600[i].players, j)

        return
      end
    end
  end
end

function leaveConfigRealMode(name)
  local quantity = quantityPlayers()

  local team = searchPlayerTeam(name)

  if team == "red" and gameStats.redServe then
    gameStats.aceRed = false
    if quantity.red >= 1 then
      tfm.exec.chatMessage("<ce>[System]: player who was going to serve has left, the system will choose another player to serve<n>", nil)
      ballOnGame = false
      gameStats.canTransform = false
      local delayTeleport = addTimer(function(i)
        if i == 1 then
          choosePlayerServe("red")
          teamServe("red")
        end
      end, 4000, 1, "delayTeleport")

      local delaySpawnBall = addTimer(function(i)
        if i == 1 then
          spawnBallRealMode("red")
        end
      end, 6000, 1, "delaySpawnBall")
    end

    return
  end

  if quantity.blue >= 1 and gameStats.blueServe then
    gameStats.aceBlue = false
    tfm.exec.chatMessage("<ce>[System]: player who was going to serve has left, the system will choose another player to serve<n>", nil)
    ballOnGame = false
    gameStats.canTransform = false
    local delayTeleport = addTimer(function(i)
      if i == 1 then
        choosePlayerServe("blue")
        teamServe("blue")
      end
    end, 4000, 1, "delayTeleport")

    local delaySpawnBall = addTimer(function(i)
      if i == 1 then
        spawnBallRealMode("blue")
      end
    end, 6000, 1, "delaySpawnBall")
  end
end

function teleportPlayersToSpec()
  for name, data in pairs(tfm.get.room.playerList) do
    if playerInGame[name] == false then
      print(killSpecPermanent)
      if killSpecPermanent then
        tfm.exec.killPlayer(name)
      else
        teleportPlayersToSpecWithSpecificSpawn(name)
      end
    end
  end
end

function teleportPlayersToSpecWithSpecificSpawn(name)
  if #lobbySpawn > 0 then
    local index = math.random(1, #lobbySpawn)

    tfm.exec.movePlayer(name, lobbySpawn[index].x, lobbySpawn[index].y)
  else
    tfm.exec.movePlayer(name, 391, 74)
  end
end

function teleportPlayers()
  teleportPlayersToSpec()

  if gameStats.twoTeamsMode then
    local spawnOnMiddle = true
    for i = 1, #playersRed do
      if playersRed[i].name ~= '' then
        playersOnGameHistoric[playersRed[i].name] = { teams = {"red"} }
        if spawnOnMiddle then
          playersAfk[playersRed[i].name] = os.time()
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, playersRed[i].name)
          else
            tfm.exec.movePlayer(playersRed[i].name, 600, 334)
          end

          tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
          twoTeamsPlayerRedPosition[i] = "middle"

          spawnOnMiddle = false
        else
          playersAfk[playersRed[i].name] = os.time()
          if #playersSpawn1600 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn1600, playersRed[i].name)
          else
            tfm.exec.movePlayer(playersRed[i].name, 1400, 334)
          end

          tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)

          twoTeamsPlayerRedPosition[i] = "back"

          spawnOnMiddle = true
        end

      end

    end

    local spawnOnMiddle = true
    for i = 1, #playersBlue do
      if playersBlue[i].name ~= '' then
        playersOnGameHistoric[playersBlue[i].name] = { teams = {"blue"} }
        if spawnOnMiddle then
          playersAfk[playersBlue[i].name] = os.time()
          if #playersSpawn1200 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn1200, playersBlue[i].name)
          else
            tfm.exec.movePlayer(playersBlue[i].name, 1000, 334)
          end
          tfm.exec.setNameColor(playersBlue[i].name, 0x3B82F6)
          twoTeamsPlayerBluePosition[i] = "middle"

          spawnOnMiddle = false
        else
          playersAfk[playersBlue[i].name] = os.time()
          if #playersSpawn400 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn400, playersBlue[i].name)
          else
            tfm.exec.movePlayer(playersBlue[i].name, 200, 334)
          end

          tfm.exec.setNameColor(playersBlue[i].name, 0x3B82F6)
          twoTeamsPlayerBluePosition[i] = "back"

          spawnOnMiddle = true
        end
      end

    end

    return
  end

  if gameStats.teamsMode then
    for i = 1, #playersYellow do
      if playersYellow[i].name ~= '' then
        playersOnGameHistoric[playersYellow[i].name] = { teams = {"yellow"} }
        playersAfk[playersYellow[i].name] = os.time()
        if #playersSpawn400 > 0 then
          teleportPlayerWithSpecificSpawn(playersSpawn400, playersYellow[i].name)
        else
          tfm.exec.movePlayer(playersYellow[i].name, 200, 334)
        end

        tfm.exec.setNameColor(playersYellow[i].name, 0xF59E0B)
      end
    end
    for i = 1, #playersRed do
      if playersRed[i].name ~= '' then
        playersOnGameHistoric[playersRed[i].name] = { teams = {"red"} }
        playersAfk[playersRed[i].name] = os.time()
        if #playersSpawn800 > 0 then
          teleportPlayerWithSpecificSpawn(playersSpawn800, playersRed[i].name)
        else
          tfm.exec.movePlayer(playersRed[i].name, 600, 334)
        end

        tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
      end
    end
    for i = 1, #playersBlue do
      if playersBlue[i].name ~= '' then
        playersOnGameHistoric[playersBlue[i].name] = { teams = {"blue"} }
        playersAfk[playersBlue[i].name] = os.time()
        if #playersSpawn1200 > 0 then
          teleportPlayerWithSpecificSpawn(playersSpawn1200, playersBlue[i].name)
        else
          tfm.exec.movePlayer(playersBlue[i].name, 1000, 334)
        end

        tfm.exec.setNameColor(playersBlue[i].name, 0x3B82F6)
      end
    end
    for i = 1, #playersGreen do
      if playersGreen[i].name ~= '' then
        playersOnGameHistoric[playersGreen[i].name] = { teams = {"green"} }
        playersAfk[playersGreen[i].name] = os.time()
        if #playersSpawn1600 > 0 then
          teleportPlayerWithSpecificSpawn(playersSpawn1600, playersGreen[i].name)
        else
          tfm.exec.movePlayer(playersGreen[i].name, 1400, 334)
        end

        tfm.exec.setNameColor(playersGreen[i].name, 0x109267)
      end
    end

    return
  end

  for i = 1, #playersRed do
    if playersRed[i].name ~= '' then
      playersOnGameHistoric[playersRed[i].name] = { teams = {"red"} }

      playersAfk[playersRed[i].name] = os.time()
      if gameStats.realMode then
        tfm.exec.movePlayer(playersRed[i].name, 900, 334)
      else
        if gameStats.gameMode == "3v3" then
          if #playersSpawn400 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn400, playersRed[i].name)
          else
            tfm.exec.movePlayer(playersRed[i].name, 101, 334)
          end
        elseif gameStats.gameMode == "4v4" then
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, playersRed[i].name)
          else
            tfm.exec.movePlayer(playersRed[i].name, 301, 334)
          end
        else
          tfm.exec.movePlayer(playersRed[i].name, 401, 334)
        end
      end


      tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
    end
  end
  for i = 1, #playersBlue do
    if playersBlue[i].name ~= '' then
      playersOnGameHistoric[playersBlue[i].name] = { teams = {"blue"} }
      playersAfk[playersBlue[i].name] = os.time()
      if gameStats.realMode then
        tfm.exec.movePlayer(playersBlue[i].name, 1700, 334)
      else
        if gameStats.gameMode == "3v3" then
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, playersBlue[i].name)
          else
            tfm.exec.movePlayer(playersBlue[i].name, 700, 334)
          end
        elseif gameStats.gameMode == "4v4" then
          if #playersSpawn1600 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn1600, playersBlue[i].name)
          else
            tfm.exec.movePlayer(playersBlue[i].name, 900, 334)
          end
        else
          tfm.exec.movePlayer(playersBlue[i].name, 1500, 334)
        end
        tfm.exec.setNameColor(playersBlue[i].name, 0x3B82F6)
      end
    end
  end
end

function teleportPlayerWithSpecificSpawn(playersSpawn, name)
  local lowestPlayersQuantity
  local availableIndexesToSpawn = {}
  for i = 1, #playersSpawn do
    if lowestPlayersQuantity == nil then
      lowestPlayersQuantity = #playersSpawn[i].players
      availableIndexesToSpawn[#availableIndexesToSpawn + 1] = i
    else
      if #playersSpawn[i].players == lowestPlayersQuantity then
        availableIndexesToSpawn[#availableIndexesToSpawn + 1] = i
      elseif #playersSpawn[i].players < lowestPlayersQuantity then
        lowestPlayersQuantity = #playersSpawn[i].players
        availableIndexesToSpawn = {[1] = i}
      end
    end
  end

  if #availableIndexesToSpawn == 1 then
    local index = availableIndexesToSpawn[1]
    playersSpawn[index].players[#playersSpawn[index].players + 1] = name
    tfm.exec.movePlayer(name, playersSpawn[index].x, playersSpawn[index].y)

    return
  end

  local lowestSpawnPriority
  local indexSelected
  local foundDifference = false
  for i = 1, #availableIndexesToSpawn do
    local index = availableIndexesToSpawn[i]

    if lowestSpawnPriority == nil then
      lowestSpawnPriority = playersSpawn[index].spawnPriority
      indexSelected = index
    else
      if lowestSpawnPriority ~= playersSpawn[index].spawnPriority then
        foundDifference = true
      end

      if playersSpawn[index].spawnPriority < lowestSpawnPriority then
        lowestSpawnPriority = playersSpawn[index].spawnPriority
        indexSelected = index
      end
    end
  end

  if foundDifference then
    playersSpawn[indexSelected].players[#playersSpawn[indexSelected].players + 1] = name
    tfm.exec.movePlayer(name, playersSpawn[indexSelected].x, playersSpawn[indexSelected].y)

    return
  end

  local index = availableIndexesToSpawn[math.random(1, #availableIndexesToSpawn)]
  playersSpawn[index].players[#playersSpawn[index].players + 1] = name
  tfm.exec.movePlayer(name, playersSpawn[index].x, playersSpawn[index].y)
end

function resetQuantityTeams()
  if ballOnGame then
    local ballX = tfm.get.room.objectList[ball_id].x + tfm.get.room.objectList[ball_id].vx
    print("<br>normal:"..ballX.."<br><r>red:"..(ballX + 300).."<n><br><bv>blue:"..(ballX - 300).."<n>")

    if (ballX + 100) >= 1299 then
      print("caiu no red")
      gameStats.redQuantitySpawn = 0
      gameStats.lastPlayerRed = ""
      if gameStats.redServe then
        gameStats.redLimitSpawn = 1
      else
        gameStats.redLimitSpawn = 3
      end
    end
    if (ballX - 100) <= 1301 then
      print("caiu no blue")
      gameStats.lastPlayerBlue = ""
      gameStats.blueQuantitySpawn = 0
      if gameStats.blueServe then
        gameStats.blueLimitSpawn = 1
      else
        gameStats.blueLimitSpawn = 3
      end
    end

    showTheScore()
  end
end

function removeTextAreasOfLobby()
  for i = 1, 13 do
    ui.removeTextArea(i)
  end
end

function showTheScore()
  if gameStats.realMode then
    ui.addTextArea(0, "<p align='center'><font size='40px'><r>"..score_red.."<n>", nil, 1150, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'><bv>"..score_blue.."<n>", nil, 1350, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(899899, "<p align='center'><font size='20px'><b><r>"..gameStats.redQuantitySpawn.."/"..gameStats.redLimitSpawn.."<n></b>", nil, 200, 20, 100, 100, 0x161616, 0x161616, 0, true)
    ui.addTextArea(8998991, "<p align='center'><font size='20px'><b><bv>"..gameStats.blueQuantitySpawn.."/"..gameStats.blueLimitSpawn.."<n></b>", nil, 600, 20, 100, 100, 0x161616, 0x161616, 0, true)
    return
  end
  if gameStats.twoTeamsMode then
    ui.addTextArea(899899, "<p align='center'><font size='40px'><bv>"..score_blue.."<n>", nil, 200, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(0, "<p align='center'><font size='40px'><r>"..score_red.."<n>", nil, 550, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'><bv>"..score_blue.."<n>", nil, 950, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(8998991, "<p align='center'><font size='40px'><r>"..score_red.."<n>", nil, 1300, 20, 100, 100, 0x161616, 0x161616, 0, false)

    return
  end
  if gameStats.teamsMode and gameStats.typeMap == "large4v4" then
    ui.addTextArea(899899, "<p align='center'><font size='40px'><j>"..teamsLifes[1].yellow.."<n>", nil, 200, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(0, "<p align='center'><font size='40px'><r>"..teamsLifes[2].red.."<n>", nil, 550, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'><bv>"..teamsLifes[3].blue.."<n>", nil, 950, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(8998991, "<p align='center'><font size='40px'><vp>"..teamsLifes[4].green.."<n>", nil, 1300, 20, 100, 100, 0x161616, 0x161616, 0, false)
    return
  end

  if gameStats.teamsMode and gameStats.typeMap == "large3v3" then
    if getTeamsLifes[1] == nil or getTeamsLifes[2] == nil or getTeamsLifes[3] == nil then
      return
    end
    if getTeamsColors[1] == nil or getTeamsColors[2] == nil or getTeamsColors[3] == nil then
      return
    end
    ui.addTextArea(899899, "<p align='center'><font size='40px'>"..getTeamsColors[1]..""..getTeamsLifes[1].."<n>", nil, 200, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(0, "<p align='center'><font size='40px'>"..getTeamsColors[2]..""..getTeamsLifes[2].."<n>", nil, 550, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'>"..getTeamsColors[3]..""..getTeamsLifes[3].."<n>", nil, 900, 20, 100, 100, 0x161616, 0x161616, 0, false)
    return
  end

  if gameStats.teamsMode and gameStats.typeMap == "small" then
    if getTeamsLifes[1] == nil or getTeamsLifes[2] == nil then
      return
    end
    if getTeamsColors[1] == nil or getTeamsColors[2] == nil then
      return
    end
    ui.addTextArea(0, "<p align='center'><font size='40px'>"..getTeamsColors[1]..""..getTeamsLifes[1].."<n>", nil, 0, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'>"..getTeamsColors[2]..""..getTeamsLifes[2].."<n>", nil, 700, 20, 100, 100, 0x161616, 0x161616, 0, false)
    return
  end

  if gameStats.gameMode == "3v3" then
    ui.addTextArea(0, "<p align='center'><font size='40px'><r>"..score_red.."<n>", nil, 0, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'><bv>"..score_blue.."<n>", nil, 700, 20, 100, 100, 0x161616, 0x161616, 0, false)
  elseif gameStats.gameMode == "4v4" then
    ui.addTextArea(0, "<p align='center'><font size='40px'><r>"..score_red.."<n>", nil, 200, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'><bv>"..score_blue.."<n>", nil, 900, 20, 100, 100, 0x161616, 0x161616, 0, false)
  else
    ui.addTextArea(0, "<p align='center'><font size='40px'><r>"..score_red.."<n>", nil, 200, 20, 100, 100, 0x161616, 0x161616, 0, false)
    ui.addTextArea(1, "<p align='center'><font size='40px'><bv>"..score_blue.."<n>", nil, 1500, 20, 100, 100, 0x161616, 0x161616, 0, false)
  end
end

function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

function verifyMostMapVoted()
  local mostMapVotedIndex = 1
  local mapsTie = {}

  local maps = configSelectMap()

  for i = 2, #maps do
    if mapsVotes[i] ~= nil then
      if mapsVotes[mostMapVotedIndex] ~= nil then
        if mapsVotes[i] > mapsVotes[mostMapVotedIndex] then
          mostMapVotedIndex = i
        end
      else
        mostMapVotedIndex = i
      end
    end
  end

  mapsTie[#mapsTie + 1] = mostMapVotedIndex

  for i = 1, #maps do
    if mapsVotes[i] ~= nil then
      if mapsVotes[i] == mapsVotes[mostMapVotedIndex] and i ~= mostMapVotedIndex then
        mapsTie[#mapsTie + 1] = i
      end
    end
  end

  if #mapsTie > 1 then
    mostMapVotedIndex = mapsTie[math.random(1, #mapsTie)]
  end

  gameStats.mapIndexSelected = mostMapVotedIndex
end

function updateLobbyTextAreas(isTeamsModeActived)
  resetPlayerConfigs()
  initGame = os.time() + 25000

  if isTeamsModeActived then
    resetTeams = addTimer(function(i)
      if i == 1 then
        playersRed = {
          [1] = {name = ''},
          [2] = {name = ''},
          [3] = {name = ''},
        }
        playersBlue = {
          [1] = {name = ''},
          [2] = {name = ''},
          [3] = {name = ''},
        }
        playersYellow = {
          [1] = {name = ''},
          [2] = {name = ''},
          [3] = {name = ''}
        }

        playersGreen = {
          [1] = {name = ''},
          [2] = {name = ''},
          [3] = {name = ''}
        }
      end
    end, 1000, 1, "resetTeams")
    toggleTeams = addTimer(function(i)
      if i == 1 then
        for i = 1, 3 do
          ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..i.."'>Join", nil, x[i], y[i], 150, 40, 0xE14747, 0xE14747, 1, false)
        end

        for i = 4, 6 do
          ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..i.."'>Join", nil, x[i], y[i], 150, 40, 0x184F81, 0x184F81, 1, false)
        end

        for i = 8, 10 do
          ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamYellow"..(i - 7).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0xF59E0B, 0xF59E0B, 1, false)
        end

        for i = 11, 13 do
          ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamGreen"..(i - 10).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0x109267, 0x109267, 1, false)
        end
      end
    end, 1500, 1, "toggleTeams")
    canJoin = addTimer(function(i)
      if i == 1 then
        gameStats.canJoin = true
      end
    end, 2500, 1, "canJoin")

    return
  end

  resetTeams = addTimer(function(i)
    if i == 1 then
      playersRed = {
        [1] = {name = ''},
        [2] = {name = ''},
        [3] = {name = ''},
        [4] = {name = ''},
        [5] = {name = ''},
        [6] = {name = ''}
      }
      playersBlue = {
        [1] = {name = ''},
        [2] = {name = ''},
        [3] = {name = ''},
        [4] = {name = ''},
        [5] = {name = ''},
        [6] = {name = ''}
      }
    end
  end, 1000, 1, "resetTeams")

  toggleTeams = addTimer(function(i)
    if i == 1 then
      for i = 1, 3 do
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..i.."'>Join", nil, x[i], y[i], 150, 40, 0xE14747, 0xE14747, 1, false)
      end

      for i = 4, 6 do
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..i.."'>Join", nil, x[i], y[i], 150, 40, 0x184F81, 0x184F81, 1, false)
      end

      for i = 8, 10 do
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..(i - 4).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0xE14747, 0xE14747, 1, false)
      end

      for i = 11, 13 do
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..(i - 4).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0x184F81, 0x184F81, 1, false)
      end
    end
  end, 1500, 1, "toggleTeams")

  canJoin = addTimer(function(i)
    if i == 1 then
      gameStats.canJoin = true
    end
  end, 2500, 1, "canJoin")

end

function resetPlayerConfigs()
  for name, data in pairs(tfm.get.room.playerList) do
    playerCanTransform[name] = true
    playerInGame[name] = false
    playerCoordinates[name] = {x = 0, y = 0}
    playerPhysicId[name] = 0
    system.bindKeyboard(name, 32, true, true)
    system.bindKeyboard(name, 0, true, true)
    system.bindKeyboard(name, 1, true, true)
    system.bindKeyboard(name, 2, true, true)
    system.bindKeyboard(name, 3, true, true)
    system.bindKeyboard(name, 55, true, true)
    system.bindKeyboard(name, 56, true, true)
    system.bindKeyboard(name, 57, true, true)
    system.bindKeyboard(name, 48, true, true)
    system.bindKeyboard(name, 77, true, true)
    tfm.exec.setNameColor(name, 0xD1D5DB)
    tfm.exec.setPlayerScore(name, 0, false)
    canVote[name] = true
  end
end

function eventNewGameShowLobbyTexts(is4teamsmode)
  for i = 1, 3 do
    if playersRed[i].name == "" then
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..i.."'>Join", nil, x[i], y[i], 150, 40, 0xE14747, 0xE14747, 1, false)
    else
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:leaveTeamRed"..i.."'>"..playersRed[i].name.."", nil, x[i], y[i], 150, 40, 0x871F1F, 0x871F1F, 1, false)
    end
  end
  for i= 4, 6 do
    if playersBlue[i - 3].name == "" then
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..i.."'>Join", nil, x[i], y[i], 150, 40, 0x184F81, 0x184F81, 1, false)
    else
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:leaveTeamBlue"..i.."'>"..playersBlue[i - 3].name.."", nil, x[i], y[i], 150, 40, 0x0B3356, 0x0B3356, 1, false)
    end
  end
  if not is4teamsmode then
    for i = 8, 10 do
      if playersRed[i - 4].name == "" then
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..(i - 4).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0xE14747, 0xE14747, 1, false)
      else
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:leaveTeamRed"..(i - 4).."'>"..playersRed[i - 4].name.."", nil, x[i - 1], y[i - 1], 150, 40, 0x871F1F, 0x871F1F, 1, false)
      end
    end
    for i = 11, 13 do
      if playersBlue[i - 7].name == "" then
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..(i - 4).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0x184F81, 0x184F81, 1, false)
      else
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:leaveTeamBlue"..(i - 4).."'>"..playersBlue[i - 7].name.."", nil, x[i - 1], y[i- 1], 150, 40, 0x0B3356, 0x0B3356, 1, false)
      end
    end

    return
  end
  for i = 8, 10 do
    if playersYellow[i - 7].name == "" then
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamYellow"..(i - 7).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0xF59E0B, 0xF59E0B, 1, false)
    else
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:leaveTeamYellow"..(i - 7).."'>"..playersYellow[i - 7].name.."", nil, x[i - 1], y[i - 1], 150, 40, 0xB57200, 0xB57200, 1, false)
    end
  end

  for i = 11, 13 do
    if playersGreen[i - 10].name == "" then
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamGreen"..(i - 10).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0x109267, 0x109267, 1, false)
    else
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:leaveTeamGreen"..(i - 10).."'>"..playersGreen[i - 10].name.."", nil, x[i - 1], y[i - 1], 150, 40, 0x0C6346, 0x0C6346, 1, false)
    end
  end
end

function disablePlayersCanTransform(time)
  playersCanTransform = addTimer(function(i)
    if i == 1 then
      gameStats.canTransform = true
    end
  end, time, 1, "playersCanTransform")
end

function disablePlayerCanTransform(name)
  playerCanTransform[name] = false
  playersCanTransform = addTimer(function(i)
    if i == 1 then
      playerCanTransform[name] = true
    end
  end, 2000, 1, "playersCanTransform")
end

function commandNotAvailable(command, name)
  tfm.exec.chatMessage("<bv>The "..command.." is not available when the mode 4 teams is enabled<n>", name)
end

function updateLobbyTexts(name)
  for i = 1, 3 do
    if playersRed[i].name == name then
      playersRed[i].name = ''
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..i.."'>Join", nil, x[i], y[i], 150, 40, 0xE14747, 0xE14747, 1, false)
    end
    if playersBlue[i].name == name then
      playersBlue[i].name = ''
      ui.addTextArea(i + 3, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..(i + 3).."'>Join", nil, x[i + 3], y[i + 3], 150, 40, 0x184F81, 0x184F81, 1, false)
    end
  end
  if not gameStats.teamsMode then
    for i = 8, 10 do
      if playersRed[i - 4].name == name then
        playersRed[i - 4].name = ''
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..(i - 4).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0xE14747, 0xE14747, 1, false)
      end
    end
    for i = 11, 13 do
      if playersBlue[i - 7].name == name then
        playersBlue[i - 7].name = ''
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..(i - 4).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0x184F81, 0x184F81, 1, false)
      end
    end
    return
  end
  for i = 8, 10 do
    if playersYellow[i - 7].name == name then
      playersYellow[i - 7].name = ''
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamYellow"..(i - 7).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0xF59E0B, 0xF59E0B, 1, false)
    end
  end

  for i = 11, 13 do
    if playersGreen[i - 10].name == name then
      playersGreen[i - 10].name = ''
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamGreen"..(i - 10).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0x109267, 0x109267, 1, false)
    end
  end
end

function messagePlayerIsBanned(name)
  if playerBan[name] then
    tfm.exec.chatMessage("<bv>You do not have access to this action because you are banned from the room<n>", name)
    return true
  end

  return false
end

function isPermanentAdmin(name)
  for i = 1, #permanentAdmins do
    local admin = permanentAdmins[i]
    if name == admin then
      return true
    end
  end

  return false
end

function updateTwoBallOnGame()
  ballOnGameTwoBalls = {ballOnGame, ballOnGame2}
  ballsId = {ball_id, ball_id2}
end

local afkSystem = addTimer(function(i)
  if mode == "gameStart" and enableAfkSystem and gameStats.enableAfkMode then
    for name, data in pairs(tfm.get.room.playerList) do
      if playerInGame[name] then
        local time = math.ceil((playersAfk[name] - os.time())/1000)
        if time <= afkTimeValue then
          if gameStats.teamsMode and gameStats.canTransform then
            leaveTeamTeamsMode(name)
            tfm.exec.chatMessage("<bv>"..name.." left the game because "..name.." was AFK<n>", nil)
          else
            if not gameStats.teamsMode then
              leaveTeam(name)
              tfm.exec.chatMessage("<bv>"..name.." left the game because "..name.." was AFK<n>", nil)
            end
          end
        end
      end
    end
  end
end, 1000, 0, "afkSystem")

function resetMapsToTest()
  if not tfm.get.room.isTribeHouse then
    return
  end

  if mapsToTest[1] ~= "" then
    tfm.exec.chatMessage("<bv>The test maps were removed due to the game mode change, you need to add the map again with the command !np @map<n>", nil)
    print("<bv>The test maps were removed due to the game mode change, you need to add the map again with the command !np @map<n>")
  end

  mapsToTest = {
    [1] = "",
    [2] = "",
    [3] = ""
  }
end

function textSyncCondition(sync)
  local syncConditionValues = {50, 100, 150, 200}
  local syncText = {"Perfect", "Good", "Fair", "Bad", "Terrible"}

  for i = 1, #syncConditionValues do
    if sync <= syncConditionValues[i] then
      return syncText[i]
    end
  end

  return syncText[5]
end

function getActionsModes()
  local modes = getModesText()

  for i = 1, #modes do
    if globalSettings.mode == modes[i] then
      modes[i] = "<j>"..modes[i].."<n>"
    else
      modes[i] = "<a href='event:setMode"..i.."'>"..modes[i].."</a>"
    end
  end

  return modes
end

function getModesText()
  local modes = {"Normal mode", "4 teams mode", "2 teams mode", "Real mode"}

  return modes
end

function updateSettingsUI()
  for name, data in pairs(tfm.get.room.playerList) do
    if settings[name] then
      ui.addWindow(24, ""..playerLanguage[name].tr.titleSettings.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
      ui.addTextArea(99992, ""..playerLanguage[name].tr.textSettings.."", name, 150, 110, 500, 200, 0x161616, 0x161616, 0, true)
      if settingsMode[name] then
        local modes = getActionsModes()
        local str = ''

        for i = 1, #modes do
          str = ""..str..""..modes[i].."<br>"
        end
        ui.addWindow(25, "<p align='center'><font size='11px'><a href='event:closeMode'>Select a mode</a><br><br>"..str.."", name, 665, 110, 100, 100, 1, false, false)
      else
        ui.addWindow(25, "<p align='center'><font size='11px'><a href='event:openMode'>Select a mode</a>", name, 665, 110, 100, 30, 1, false, false)
      end

      if globalSettings.twoBalls then
        ui.addWindow(21, "<p align='center'><font size='11px'><a href='event:twoballs'>Enabled</a>", name, 665, 250, 100, 30, 1, false, false)
      else
        ui.addWindow(21, "<p align='center'><font size='11px'><a href='event:twoballs'>Disabled</a>", name, 665, 250, 100, 30, 1, false, false)
      end
    end
  end
end

function messageLog(message)
  for name, data in pairs(tfm.get.room.playerList) do
    if admins[name] then
      tfm.exec.chatMessage(message, name)
    end
  end
end

function winRatioPercentage(wins, matches)
  if matches == 0 then
    return 0
  end

  return (wins / matches) * 100
end

function addMatchesToAllPlayers()

  local mode = verifyMode()

  if mode == "Normal mode" then
    for name, value in pairs(playerInGame) do
      if value then
        playersNormalMode[name].matches = playersNormalMode[name].matches + 1
        playersNormalMode[name].winRatio = winRatioPercentage(playersNormalMode[name].wins, playersNormalMode[name].matches)
      end
    end
  elseif mode == "4 teams mode" then
    for name, value in pairs(playerInGame) do
      if value then
        playersFourTeamsMode[name].matches = playersFourTeamsMode[name].matches + 1
        playersFourTeamsMode[name].winRatio = winRatioPercentage(playersFourTeamsMode[name].wins, playersFourTeamsMode[name].matches)
      end
    end
  elseif mode == "2 teams mode" then
    for name, value in pairs(playerInGame) do
      if value then
        playersTwoTeamsMode[name].matches = playersTwoTeamsMode[name].matches + 1
        playersTwoTeamsMode[name].winRatio = winRatioPercentage(playersTwoTeamsMode[name].wins, playersTwoTeamsMode[name].matches)
      end
    end
  elseif mode == "Real mode" then
    for name, value in pairs(playerInGame) do
      if value then
        playersRealMode[name].matches = playersRealMode[name].matches + 1
        playersRealMode[name].winRatio = winRatioPercentage(playersRealMode[name].wins, playersRealMode[name].matches)
      end
    end
  end
end

function verifyMode()
  if gameStats.teamsMode then
    return "4 teams mode"
  elseif gameStats.twoTeamsMode then
    return "2 teams mode"
  elseif gameStats.realMode then
    return "Real mode"
  else
    return "Normal mode"
  end
end

function addMatchToPlayer(name)
  playersNormalMode[name].matches = playersNormalMode[name].matches + 1
  playersNormalMode[name].winRatio = winRatioPercentage(playersNormalMode[name].wins, playersNormalMode[name].matches)
end

function addMatchToPlayerFourTeamsMode(name)
  playersFourTeamsMode[name].matches = playersFourTeamsMode[name].matches + 1
  playersFourTeamsMode[name].winRatio = winRatioPercentage(playersFourTeamsMode[name].wins, playersFourTeamsMode[name].matches)
end

function addMatchToPlayerTwoTeamsMode(name)
  playersTwoTeamsMode[name].matches = playersTwoTeamsMode[name].matches + 1
  playersTwoTeamsMode[name].winRatio = winRatioPercentage(playersTwoTeamsMode[name].wins, playersTwoTeamsMode[name].matches)
end

function addMatchToPlayerRealMode(name)
  playersRealMode[name].matches = playersRealMode[name].matches + 1
  playersRealMode[name].winRatio = winRatioPercentage(playersRealMode[name].wins, playersRealMode[name].matches)
end

function normalModeTeamWinner(team)
  if team == "red" then
    for i = 1, #playersRed do
      local player = playersRed[i].name
      if player ~= "a" and player ~= '' then
        playersNormalMode[player].wins = playersNormalMode[player].wins + 1
        playersNormalMode[player].winRatio = winRatioPercentage(playersNormalMode[player].wins, playersNormalMode[player].matches)
        playersNormalMode[player].winsRed = playersNormalMode[player].winsRed + 1
      end
    end

    return
  end

  for i = 1, #playersBlue do
    local player = playersBlue[i].name

    if player ~= "a" and player ~= '' then
      playersNormalMode[player].wins = playersNormalMode[player].wins + 1
      playersNormalMode[player].winRatio = winRatioPercentage(playersNormalMode[player].wins, playersNormalMode[player].matches)
      playersNormalMode[player].winsBlue = playersNormalMode[player].winsBlue + 1
    end
  end
end

function updateRankingNormalMode()
  local rank_list = {}

  for name, stats in pairs(playersNormalMode) do
    if stats.matches > 0 then
      rank_list[#rank_list + 1] = {name = name, matches = stats.matches, wins = stats.wins, winRatio = stats.winRatio, winsRed = stats.winsRed, winsBlue = stats.winsBlue}
    end
  end

  table.sort(rank_list, function(a, b)
    if a.wins == b.wins then
      return a.matches < b.matches
    else
      return a.wins > b.wins
    end
  end)

  rankNormalMode = rank_list
end

function fourTeamsModeWinner(teamText, playersOnTeam)
  local team = getTeamName(teamText)

  if team == "Yellow" then
    for i = 1, #playersOnTeam do
      local player = playersOnTeam[i].name

      if player ~= 'a' and player ~= '' then
        playersFourTeamsMode[player].wins = playersFourTeamsMode[player].wins + 1
        playersFourTeamsMode[player].winRatio = winRatioPercentage(playersFourTeamsMode[player].wins, playersFourTeamsMode[player].matches)
        playersFourTeamsMode[player].winsYellow = playersFourTeamsMode[player].winsYellow + 1
      end
    end

    return
  elseif team == "Red" then
    for i = 1, #playersOnTeam do
      local player = playersOnTeam[i].name

      if player ~= 'a' and player ~= '' then
        playersFourTeamsMode[player].wins = playersFourTeamsMode[player].wins + 1
        playersFourTeamsMode[player].winRatio = winRatioPercentage(playersFourTeamsMode[player].wins, playersFourTeamsMode[player].matches)
        playersFourTeamsMode[player].winsRed = playersFourTeamsMode[player].winsRed + 1
      end
    end

    return
  elseif team == "Blue" then
    for i = 1, #playersOnTeam do
      local player = playersOnTeam[i].name

      if player ~= 'a' and player ~= '' then
        playersFourTeamsMode[player].wins = playersFourTeamsMode[player].wins + 1
        playersFourTeamsMode[player].winRatio = winRatioPercentage(playersFourTeamsMode[player].wins, playersFourTeamsMode[player].matches)
        playersFourTeamsMode[player].winsBlue = playersFourTeamsMode[player].winsBlue + 1
      end
    end

    return
  elseif team == "Green" then
    for i = 1, #playersOnTeam do
      local player = playersOnTeam[i].name

      if player ~= 'a' and player ~= '' then
        playersFourTeamsMode[player].wins = playersFourTeamsMode[player].wins + 1
        playersFourTeamsMode[player].winRatio = winRatioPercentage(playersFourTeamsMode[player].wins, playersFourTeamsMode[player].matches)
        playersFourTeamsMode[player].winsGreen = playersFourTeamsMode[player].winsGreen + 1
      end
    end

    return
  end
end

function getTeamName(text)
  if string.sub(text, 1, 9) == "<j>Yellow" then
    return "Yellow"
  elseif string.sub(text, 1, 6) == "<r>Red" then
    return "Red"
  elseif string.sub(text, 1, 8) == "<bv>Blue" then
    return "Blue"
  elseif string.sub(text, 1, 9) == "<vp>Green" then
    return "Green"
  end
end


function updateRankingFourTeamsMode()
  local rank_list = {}

  for name, stats in pairs(playersFourTeamsMode) do
    if stats.matches > 0 then
      rank_list[#rank_list + 1] = {name = name, matches = stats.matches, wins = stats.wins, winRatio = stats.winRatio, winsRed = stats.winsRed, winsBlue = stats.winsBlue, winsYellow = stats.winsYellow, winsGreen = stats.winsGreen}
    end
  end

  table.sort(rank_list, function(a, b)
    if a.wins == b.wins then
      return a.matches < b.matches
    else
      return a.wins > b.wins
    end
  end)

  rankFourTeamsMode = rank_list
end

function twoTeamsModeWinner(team)
  if team == "red" then
    for i = 1, #playersRed do
      local player = playersRed[i].name
      if player ~= "a" and player ~= '' then
        playersTwoTeamsMode[player].wins = playersTwoTeamsMode[player].wins + 1
        playersTwoTeamsMode[player].winRatio = winRatioPercentage(playersTwoTeamsMode[player].wins, playersTwoTeamsMode[player].matches)
        playersTwoTeamsMode[player].winsRed = playersTwoTeamsMode[player].winsRed + 1
      end
    end

    return
  end

  for i = 1, #playersBlue do
    local player = playersBlue[i].name

    if player ~= "a" and player ~= '' then
      playersTwoTeamsMode[player].wins = playersTwoTeamsMode[player].wins + 1
      playersTwoTeamsMode[player].winRatio = winRatioPercentage(playersTwoTeamsMode[player].wins, playersTwoTeamsMode[player].matches)
      playersTwoTeamsMode[player].winsBlue = playersTwoTeamsMode[player].winsBlue + 1
    end
  end
end

function updateRankingTwoTeamsMode()
  local rank_list = {}

  for name, stats in pairs(playersTwoTeamsMode) do
    if stats.matches > 0 then
      rank_list[#rank_list + 1] = {name = name, matches = stats.matches, wins = stats.wins, winRatio = stats.winRatio, winsRed = stats.winsRed, winsBlue = stats.winsBlue}
    end
  end

  table.sort(rank_list, function(a, b)
    if a.wins == b.wins then
      return a.matches < b.matches
    else
      return a.wins > b.wins
    end
  end)

  rankTwoTeamsMode = rank_list
end

function realModeWinner(team)
  if team == "red" then
    for i = 1, #playersRed do
      local player = playersRed[i].name
      if player ~= "a" and player ~= '' then
        playersRealMode[player].wins = playersRealMode[player].wins + 1
        playersRealMode[player].winRatio = winRatioPercentage(playersRealMode[player].wins, playersRealMode[player].matches)
        playersRealMode[player].winsRed = playersRealMode[player].winsRed + 1
      end
    end

    return
  end

  for i = 1, #playersBlue do
    local player = playersBlue[i].name

    if player ~= "a" and player ~= '' then
      playersRealMode[player].wins = playersRealMode[player].wins + 1
      playersRealMode[player].winRatio = winRatioPercentage(playersRealMode[player].wins, playersRealMode[player].matches)
      playersRealMode[player].winsBlue = playersRealMode[player].winsBlue + 1
    end
  end
end

function updateRankingRealMode()
  local rank_list = {}

  for name, stats in pairs(playersRealMode) do
    if stats.matches > 0 then
      rank_list[#rank_list + 1] = {name = name, matches = stats.matches, wins = stats.wins, winRatio = stats.winRatio, winsRed = stats.winsRed, winsBlue = stats.winsBlue}
    end
  end

  table.sort(rank_list, function(a, b)
    if a.wins == b.wins then
      return a.matches < b.matches
    else
      return a.wins > b.wins
    end
  end)

  rankRealMode = rank_list
end

function formatMapName(map)
  if #map > 14 then
    return ""..string.sub(map, 1, 10).."..."
  end

  return map
end

function removeSelectUI(name)
  local ids = {99999, 999999, 9999999, 99999999, 999999999}

  for i = 1, 5 do
    for j = 1, 5 do
      ui.removeTextArea(""..tostring(ids[i])..""..j.."", name)
    end
  end

  ui.removeTextArea(9999999999, name)

  for i = 1, #selectMapImages[name] do
    tfm.exec.removeImage(selectMapImages[name][i])
  end
end

function showMapVotes(maps, index)
  if mapsVotes[index] == nil then
    return 0
  end

  return mapsVotes[index]
end

function selectMapPointersNavigation(name, page, maxPage)
  local str = ""
  for i = 1, maxPage do
    if page == i then
      str = ""..str.." <j>•<n>"
    else
      str = ""..str.." <a href='event:nextSelectMap"..i.."'>•</a>"
    end
  end

  ui.addTextArea(9999999999, "<p align='center'><font size='18px'>"..str.."", name, 347, 300, 200, 20, 0x161616, 0x161616, 0, true)
end

function selectMapUI(name)
  removeSelectUI(name)
  local maps = configSelectMap()
  local maxPage = getMaxPageMap(maps)
  local page = selectMapPage[name]

  for i = 1, 5 do
    local index = i + ((page - 1) * 5)

    if maps[index] ~= nil then
      local textSelect = "<a href='event:setmap"..index.."'>Select map</a>"
      local voteText = "<a href='event:votemap"..index.."'>Vote map ("..showMapVotes(maps, index)..")</a>"

      if index == gameStats.customMapIndex then
        textSelect = "<j>Selected map<n>"
      elseif not admins[name] then
        textSelect = "<n2>Select map<n>"
      end

      if not canVote[name] then
        voteText = "<n2>Vote map<n> ("..showMapVotes(maps, index)..")"
      end

      ui.addTextArea(""..tostring(99999)..""..tostring(i).."", "", name, (142 + ((i - 1) * 125)), 115, 110, 140, 0x142b2e, 0x8a583c, 1, true)
      ui.addTextArea(""..tostring(999999)..""..tostring(i).."", "", name, (147  + ((i - 1) * 125)), 120, 100, 43, 0x142b2e, 0x2d5a61, 1, true)
      ui.addTextArea(""..tostring(9999999)..""..tostring(i).."", "<p align='center'><font size='12px'><a href='event:map"..maps[index][3].."'>"..formatMapName(maps[index][3]).."</a>", name, (147  + ((i - 1) * 125)), 165, 100, 20, 0x142b2e, 0x2d5a61, 0, true)

      ui.addTextArea(""..tostring(99999999)..""..tostring(i).."", "<p align='center'><font size='12px'>"..textSelect.."", name, (147  + ((i - 1) * 125)), 190, 100, 20, 0x142b2e, 0x2d5a61, 1, true)
      ui.addTextArea(""..tostring(999999999)..""..tostring(i).."", "<p align='center'><font size='12px'>"..voteText.."", name, (147  + ((i - 1) * 125)), 225, 100, 20, 0x142b2e, 0x2d5a61, 1, true)

      table.insert(selectMapImages[name], tfm.exec.addImage(maps[index][6], "~999999"..i.."", (147 + ((i - 1) * 125 )), 118, name))
    end
  end

  selectMapPointersNavigation(name, page, maxPage)

  if page == 1 then
    buttonNextOrPrev(26, name, 135, 300, 200, 30, 1, "<n2>"..playerLanguage[name].tr.previousMessage.."</n>")
  else
    buttonNextOrPrev(26, name, 135, 300, 200, 30, 1, "<a href='event:prevSelectMap"..tostring(page - 1).."'>"..playerLanguage[name].tr.previousMessage.."</a>")
  end

  if page >= maxPage then
    buttonNextOrPrev(25, name, 560, 300, 200, 30, 1, "<n2>"..playerLanguage[name].tr.nextMessage.."</n>")
  else
    buttonNextOrPrev(25, name, 560, 300, 200, 30, 1, "<a href='event:nextSelectMap"..tostring(page + 1).."'>"..playerLanguage[name].tr.nextMessage.."</a>")
  end
end

function configSelectMap()
  local maps

  if gameStats.realMode then
    return {}
  end

  if gameStats.teamsMode or gameStats.twoTeamsMode then
    maps = customMapsFourTeamsMode

    return maps
  end

  maps = customMaps

  return maps
end

function getMaxPageMap(mapsList)
  local count = math.floor(#mapsList / 5)

  if #mapsList % 5 ~= 0 then
    count = count + 1
  end

  return count
end

function resetMapsList()
  mapsVotes = {}
  gameStats.totalVotes = 0
  for name, data in pairs(tfm.get.room.playerList) do
    canVote[name] = true
    if selectMapOpen[name] then
      selectMapPage[name] = 1
      selectMapUI(name)
    end
  end
end

function showMode(mode, name)
  removeUITrophies(name)
  if mode ~= "4 teams mode" then
    ui.removeTextArea(9999564, name)
    ui.removeTextArea(9999565, name)
  end

  local rank = rankMode(mode)
  local page = rankPageMode(mode, name)

  local y = 137
  local colorBackground = 0x2d5a61
  local indexPositions = positionsString(page)
  local namesRank = ""
  local matchesRank = ""
  local winsRank = ""
  local winRatioRank = ""
  local winsRed = ""
  local winsBlue = ""
  local winsYellow = ""
  local winsGreen = ""

  for i = 9999554, 9999563 do
    local index = (i - 9999553) + (10 * (page - 1))

    if rank[index] ~= nil then
      local winRatioString = tostring(rank[index].winRatio)

      ui.addTextArea(i, "", name, 135, y, 630, 6, colorBackground, colorBackground, 1, true)

      if page == 1 and index == 1 then
        namesRank = ""..namesRank.."<br>"..indexPositions[(i - 9999553)].." <cs>"..string.sub(rank[index].name, 1, #rank[index].name - 5).."<n><bl>"..string.sub(rank[index].name, #rank[index].name - 4).."<n>"
      else
        namesRank = ""..namesRank.."<br>"..indexPositions[(i - 9999553)].." "..string.sub(rank[index].name, 1, #rank[index].name - 5).."<bl>"..string.sub(rank[index].name, #rank[index].name - 4).."<n>"
      end
      matchesRank = ""..matchesRank.."<br>"..rank[index].matches..""
      winsRank = ""..winsRank.."<br>"..rank[index].wins..""
      winRatioRank = ""..winRatioRank.."<br>"..string.sub(winRatioString, 1, 4).."%"
      winsRed = ""..winsRed.."<br>"..rank[index].winsRed..""
      winsBlue = ""..winsBlue.."<br>"..rank[index].winsBlue..""

      if mode == "4 teams mode" then
        winsYellow = ""..winsYellow.."<br>"..rank[index].winsYellow..""
        winsGreen = ""..winsGreen.."<br>"..rank[index].winsGreen..""
      end

      if colorBackground == 0x2d5a61 then
        colorBackground = 0x142b2e
      else
        colorBackground = 0x2d5a61
      end
    else
      ui.addTextArea(i, "", name, 135, y, 630, 6, colorBackground, colorBackground, 0, true)
    end

    y = y + 16
  end

  local findNextIndexValue = 1 + (10 * (page))

  ui.addTextArea(9999545, "<p align='center'><font size='11px'>"..playerRankingMode[name].."", name, 390, 85, 120, 20, 0x161616, 0x161616, 0, true)
  if mode == "Normal mode" then
    ui.addTextArea(9999546, "<p align='center'><font size='13px'><n2>«<n>", name, 350, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
    ui.addTextArea(9999547, "<p align='center'><font size='13px'><a href='event:4 teams mode'>»</a>", name, 520, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
  elseif mode == "4 teams mode" then
    ui.addTextArea(9999546, "<p align='center'><font size='13px'><a href='event:Normal mode'>«</a>", name, 350, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
    ui.addTextArea(9999547, "<p align='center'><font size='13px'><a href='event:2 teams mode'>»</a>", name, 520, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
  elseif mode == "2 teams mode" then
    ui.addTextArea(9999546, "<p align='center'><font size='13px'><a href='event:4 teams mode'>«</a>", name, 350, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
    ui.addTextArea(9999547, "<p align='center'><font size='13px'><a href='event:Real mode'>»</a>", name, 520, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
  elseif mode == "Real mode" then
    ui.addTextArea(9999546, "<p align='center'><font size='13px'><a href='event:2 teams mode'>«</a>", name, 350, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
    ui.addTextArea(9999547, "<p align='center'><font size='13px'><n2>»</n>", name, 520, 86, 30, 18, 0x142b2e, 0x8a583c, 1, true)
  end
  ui.addTextArea(9999548, "<textformat leading='3px'><j>Name<n>"..namesRank.."", name, 135, 115, 185, 185, 0x161616, 0x161616, 0, true)
  ui.addTextArea(9999549, "<textformat leading='3px'><j>Matches<n>"..matchesRank.."", name, 335, 115, 50, 185, 0x161616, 0x161616, 0, true)
  ui.addTextArea(9999550, "<textformat leading='3px'><j>Wins<n>"..winsRank.."", name, 400, 115, 50, 185, 0x161616, 0x161616, 0, true)
  ui.addTextArea(9999551, "<textformat leading='3px'><j>Win rate<n>"..winRatioRank.."", name, 465, 115, 55, 185, 0x161616, 0x161616, 0, true)
  if mode == "4 teams mode" then
    ui.addTextArea(9999552, "<textformat leading='3px'><r>WR<n>"..winsRed.."", name, 535, 115, 50, 185, 0x161616, 0x161616, 0, true)
    ui.addTextArea(9999553, "<textformat leading='3px'><bv>WB<n>"..winsBlue.."", name, 597, 115, 50, 185, 0x161616, 0x161616, 0, true)
    ui.addTextArea(9999564, "<textformat leading='3px'><j>WY<n>"..winsYellow.."", name, 659, 115, 50, 185, 0x161616, 0x161616, 0, true)
    ui.addTextArea(9999565, "<textformat leading='3px'><vp>WG<n>"..winsGreen.."", name, 721, 115, 50, 185, 0x161616, 0x161616, 0, true)
  else
    ui.addTextArea(9999552, "<textformat leading='3px'><r>WR<n>"..winsRed.."", name, 650, 115, 50, 185, 0x161616, 0x161616, 0, true)
    ui.addTextArea(9999553, "<textformat leading='3px'><bv>WB<n>"..winsBlue.."", name, 715, 115, 50, 185, 0x161616, 0x161616, 0, true)
  end

  if page == 1 then
    buttonNextOrPrev(26, name, 135, 300, 200, 30, 1, "<n2>"..playerLanguage[name].tr.previousMessage.."</n>")
  else
    buttonNextOrPrev(26, name, 135, 300, 200, 30, 1, "<a href='event:prevRank"..tostring(page - 1).."'>"..playerLanguage[name].tr.previousMessage.."</a>")
  end

  if rank[findNextIndexValue] == nil or findNextIndexValue > 30 then
    buttonNextOrPrev(25, name, 560, 300, 200, 30, 1, "<n2>"..playerLanguage[name].tr.nextMessage.."</n>")
  else
    buttonNextOrPrev(25, name, 560, 300, 200, 30, 1, "<a href='event:nextRank"..tostring(page + 1).."'>"..playerLanguage[name].tr.nextMessage.."</a>")
  end
end

function rankMode(mode)
  if mode == "Normal mode" then
    return rankNormalMode
  elseif mode == "4 teams mode" then
    return rankFourTeamsMode
  elseif mode == "2 teams mode" then
    return rankTwoTeamsMode
  elseif mode == "Real mode" then
    return rankRealMode
  end
end

function rankPageMode(mode, name)
  if mode == "Normal mode" then
    return pageNormalMode[name]
  elseif mode == "4 teams mode" then
    return pageFourTeamsMode[name]
  elseif mode == "2 teams mode" then
    return pageTwoTeamsMode[name]
  elseif mode == "Real mode" then
    return pageRealMode[name]
  end
end

function positionsString(page)
  local positions = {}

  for i = 1, 10 do
    if i == 1 and page == 1 then
      positions[#positions + 1] = "<j>"..tostring( i + (10 * (page - 1)))..".<n>"
    elseif i == 2 and page == 1 then
      positions[#positions + 1] = "<n2>"..tostring( i + (10 * (page - 1)))..".<n>"
    elseif i == 3 and page == 1 then
      positions[#positions + 1] = "<ce>"..tostring( i + (10 * (page - 1)))..".<n>"
    else
      positions[#positions + 1] = "<n>"..tostring( i + (10 * (page - 1)))..".<n>"
    end
  end

  return positions
end

function positions(page)
  local positions = {}

  for i = 1, 10 do
    positions[#positions + 1] = i
  end

  return positions
end

function playerHistoryOnMatch(team, name)
  local playerTeams = playersOnGameHistoric[name].teams
  local notFindSameTeam = true

  for i = 1, #playerTeams do
    if playerTeams[i] == team then
      notFindSameTeam = false
    end
  end

  if notFindSameTeam then
    return true
  end

  return false
end

function closeRankingUI(name)
  for i = 9999543, 9999565 do
    ui.removeTextArea(i, name)
  end
end

function windowUISync(name)
  local playersSync = {}
  closeRankingUI(name)
  openRank[name] = false
  for name1, data in pairs(tfm.get.room.playerList) do
    local playerSync = tfm.get.room.playerList[name1].averageLatency
    local syncCondition = textSyncCondition(tfm.get.room.playerList[name1].averageLatency)

    if not playerLeft[name1] then
      playersSync[#playersSync + 1] = { name = name1, sync = tfm.get.room.playerList[name1].averageLatency, syncCondition = syncCondition }
    end
  end

  table.sort(playersSync, function(a, b) return a.sync < b.sync end)

  local str = ""
  for i = 1, 3 do
    if playersSync[i] ~= nil then
      str = ""..str.."<p align='left'><font size='12px'><a href='event:sync"..playersSync[i].name.."'>"..playersSync[i].name.."</a></p><p align='right'><font size='12px'>"..playersSync[i].syncCondition.."</p><br><br>"
    end
  end

  ui.addWindow(24, "<p align='center'><font size='14px'>Select player sync (click on player name to select the sync)</p><br><br><p align='left'><font size='12px'>Player</p><p align='right'><font size='12px'>Sync condition</p><br>"..str.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
end

function showCrownToAllPlayers()
  local crowns = {redCrown, blueCrown, greenCrown, yellowCrown}
  local teams = {playersRed, playersBlue, playersGreen, playersYellow}

  for j = 1, #teams do
    for i = 1, #teams[j] do
      local player = teams[j][i].name

      if player ~= '' and playerInGame[player] then
        for i = 1, 10 do
          if rankCrown[i] ~= nil then
            if rankCrown[i].name == player then
              for name1, data in pairs(tfm.get.room.playerList) do
                if showCrownImages[name1] then
                  tfm.exec.addImage(crowns[j][i], "$"..player, -20, -135, name1)
                end
              end
              break
            end
          end
        end
      end
    end
  end
end

function setCrownToPlayer(playerName)
  local crowns = {redCrown, blueCrown, greenCrown, yellowCrown}
  local teams = {playersRed, playersBlue, playersGreen, playersYellow}

  for j = 1, #teams do
    for i = 1, #teams[j] do
      local player = teams[j][i].name

      if player == playerName and playerInGame[player] then
        for i = 1, 10 do
          if rankCrown[i] ~= nil then
            if rankCrown[i].name == player then
              for name1, data in pairs(tfm.get.room.playerList) do
                if showCrownImages[name1] then
                  tfm.exec.addImage(crowns[j][i], "$"..player, -20, -135, name1)
                end
              end
              break
            end
          end
        end

        return
      end
    end
  end
end

function removeUITrophies(name)
  isOpenProfile[name] = false
  closeWindow(28, name)
  closeWindow(27, name)
  closeWindow(26, name)

  for i = 1, #playerAchievementsImages[name] do
    tfm.exec.removeImage(playerAchievementsImages[name][i])
  end

  playerAchievementsImages[name] = {}
end

function appendAchievementsImages(name, tableImages)
  for i = 1, #tableImages do
    playerAchievementsImages[name][#playerAchievementsImages[name] + 1] = tableImages[i]
  end
end

function profileUI(name, playerTarget)
  isOpenProfile[name] = true
  local images3 = ui.addWindow(26, "<textformat leading='55'><br>"..playerLanguage[name].tr.msgAchievements.."", name, 217, 120, 470, 240, 1, true, true, playerLanguage[name].tr.closeUIText, {true, false, true, false})
  local images1 = ui.addWindow(24, "<p align='center'><font size='16px'><textformat leading='-10'><br><v>"..string.sub(playerTarget, 1, #playerTarget - 5).."<n><bl>"..string.sub(playerTarget, #playerTarget -4).."<n>", name, 300, 105, 400, 50, 1, true, false, "", {false, false, true, true})
  local images2 = ui.addWindow(25, "<p align='center'><font size='30px'><textformat leading='-10'><br><j>#1<n>", name, 200, 80, 100, 100, 1, true, false, "", {true, true, true, true})
  ui.addTrophie(27, "trophie1", name, playerTarget, 230, 230, 50, 50, 1)
  ui.addTrophie(28, "trophie2", name, playerTarget, 295, 230, 50, 50, 1)

  appendAchievementsImages(name, images1)
  appendAchievementsImages(name, images2)
  appendAchievementsImages(name, images3)
end

function closeAllWindows(name)
  openRank[name] = false
  selectMapOpen[name] = false
  selectMapPage[name] = 1
  closeWindow(21, name)
  closeWindow(24, name)
  closeWindow(25, name)
  removeUITrophies(name)
  removeSelectUI(name)
  ui.removeTextArea(99992, name)
  closeWindow(266, name)
  removeButtons(25, name)
  removeButtons(26, name)
  settings[name] = false
  settingsMode[name] = false

  closeRankingUI(name)
end

function removePlayerTrophyImage(name)
  local removeImage = addTimer(function(i)
    if i == 1 then
      if playerTrophyImage[name] ~= 0 then
        tfm.exec.removeImage(playerTrophyImage[name])
        playerTrophyImage[name] = 0
      end
    end
  end, 10000, 1, "trophy"..name.."")
end

function removePlayerTrophy(name)
  if playerTrophyImage[name] ~= 0 then
    tfm.exec.removeImage(playerTrophyImage[name])
    playerTrophyImage[name] = 0
    removeTimer("trophy"..name.."")
  end
end

function foundMicePlayersConfig(map)
  local mapXML = ""

  if #map > 10 then
    mapXML = map
  else
    mapXML = tfm.get.room.xmlMapInfo.xml
  end

  local pTag = string.match(mapXML, '<C><P%s+([^>]+)')

  if pTag then
    local playerForce = string.match(pTag, 'playerForce="([^"]+)"')

    if type(tonumber(playerForce)) == 'number' then
      gameStats.psyhicObjectForce = tonumber(playerForce)
    end
  end
end

function foundMiceSpawnsOnMap(map, isLargeMap)
  lobbySpawn = {}
  playersSpawn400 = {}
  playersSpawn800 = {}
  playersSpawn1200 = {}
  playersSpawn1600 = {}

  local mapXML = ""

  if #map > 10 then
    mapXML = map
  else
    mapXML = tfm.get.room.xmlMapInfo.xml
  end

  for tag in string.gmatch(mapXML, '<T%s+.-/>') do
    local x = string.match(tag, 'X="([^"]+)"')
    local y = string.match(tag, 'Y="([^"]+)"')
    local spawn = string.match(tag, 'spawn="([^"]+)"')
    local lobby = string.match(tag, 'lobby="([^"]+)"')

    local xNumber = tonumber(x)
    local yNumber = tonumber(y)

    if spawn == nil then
      spawn = 99999
    end

    if lobby ~= nil then
      setConfigLobbySpawn(xNumber, yNumber)
    else
      setConfigPlayersSpawn(isLargeMap, xNumber, yNumber, tonumber(spawn))
    end
  end

  foundMicePlayersConfig(map)

  print('400: '..#playersSpawn400..'')
  print('800: '..#playersSpawn800..'')
  print('1200: '..#playersSpawn1200..'')
  print('1600: '..#playersSpawn1600..'')
end

function setConfigLobbySpawn(xNumber, yNumber)
  lobbySpawn[#lobbySpawn + 1] = { x = xNumber, y = yNumber }
end

function setConfigPlayersSpawn(isLargeMap, xNumber, yNumber, spawnPriority)
  if isLargeMap then
    if xNumber >= 0 and xNumber <= 600 then
      playersSpawn800[#playersSpawn800 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {}}
    end

    if xNumber >= 600 and xNumber <= 1200 then
      playersSpawn1600[#playersSpawn1600 + 1] = { x = xNumber , y = yNumber, spawnPriority = spawnPriority, players = {} }
    end
  else
    if xNumber >= 0 and xNumber <= 400 then
      playersSpawn400[#playersSpawn400 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
    end

    if xNumber >= 400 and xNumber <= 800 then
      playersSpawn800[#playersSpawn800 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
    end

    if xNumber >= 800 and xNumber <= 1200 then
      playersSpawn1200[#playersSpawn1200 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
    end

    if xNumber >= 1200 and xNumber <= 1600 then
      playersSpawn1600[#playersSpawn1600 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
    end
  end
end

function foundBallSpawnsOnMap(map, isLargeMap)
  local tags_T131 = {}
  spawnBallArea400 = {}
  spawnBallArea800 = {}
  spawnBallArea1200 = {}
  spawnBallArea1600 = {}

  local mapXML = ""

  if #map > 10 then
    mapXML = map
  else
    mapXML = tfm.get.room.xmlMapInfo.xml
  end

  for tag in string.gmatch(mapXML, '<P[^>]*T="131"[^>]*/?>') do
    table.insert(tags_T131, tag)
  end

  for _, tag in ipairs(tags_T131) do
    local xString = tag:match('X="(%d+)"')
    local yString = tag:match('Y="(%d+)"')

    local x = tonumber(xString)
    local y = tonumber(yString)

    if isLargeMap then
      if x >= 0 and x <= 600 then
        spawnBallArea800[#spawnBallArea800 + 1] = {x = x, y = y}
      end
      if x >= 600 and x <= 1200 then
        spawnBallArea1600[#spawnBallArea1600 + 1] = {x = x, y = y}
      end
    else
      if x >= 0 and x <= 400 then
        spawnBallArea400[#spawnBallArea400 + 1] = { x = x, y = y}
      end
      if x >= 400 and x <= 800 then
        spawnBallArea800[#spawnBallArea800 + 1] = { x  = x, y = y}
      end
      if x >= 800 and x <= 1200 then
        spawnBallArea1200[#spawnBallArea1200 + 1] = { x = x, y = y}
      end
      if x >= 1200 and x <= 1600 then
        spawnBallArea1600[#spawnBallArea1600 + 1] = { x = x, y = y}
      end
    end
  end
end

function spawnBallConfig(spawnBalls, x)
  local customBallId = 6
  local ballPlaces = spawnBallsOnSpecificPlaces(spawnBalls, x)

  print(ballPlaces)

  if gameStats.customBall then
    customBallId = balls[gameStats.customBallId].id
  end

  ball_id = tfm.exec.addShamanObject(customBallId, ballPlaces[1].x, ballPlaces[1].y, 0, 0, -5, true)

  if gameStats.customBall then
    if balls[gameStats.customBallId].isImage then
      tfm.exec.addImage(balls[gameStats.customBallId].image, "#"..ball_id, -15, -15, nil, 1, 1, _, 1)
    end
  end

  if gameStats.twoBalls then
    ball_id2 = tfm.exec.addShamanObject(customBallId, ballPlaces[2].x, ballPlaces[2].y, 0, 0, -5, true)

    if gameStats.customBall then
      if balls[gameStats.customBallId].isImage then
        tfm.exec.addImage(balls[gameStats.customBallId].image, "#"..ball_id2, -15, -15, nil, 1, 1, _, 1)
      end
    end
    ballOnGame2 = true
  end

  ballOnGame = true
  updateTwoBallOnGame()
end

function spawnBallsOnSpecificPlaces(spawnBallsTable, defaultSpawnBallTable)
  local spawnBalls = spawnBallsTable
  local defaultSpawnBall = defaultSpawnBallTable

  local randomIndex = 0
  local spawnPlaces = {[1] = {x = 0, y = 50}, [2] = {x = 0, y = 50}}

  for i = 1, 2 do
    local randomTeamSpawn = math.random(1, #spawnBalls)
    if #spawnBalls > 0 and #spawnBalls[randomTeamSpawn] ~= 0 then
      randomIndex = math.random(1, #spawnBalls[randomTeamSpawn])
      spawnPlaces[i].x = spawnBalls[randomTeamSpawn][randomIndex].x
      spawnPlaces[i].y = spawnBalls[randomTeamSpawn][randomIndex].y
      table.remove(spawnBalls, randomTeamSpawn)
    else
      randomIndex = math.random(1, #defaultSpawnBall)
      spawnPlaces[i].x = defaultSpawnBall[randomIndex]
      table.remove(defaultSpawnBall, randomIndex)
    end
  end

  return spawnPlaces
end

function removeWindowsOnBottom()
  closeWindow(30, nil)
  closeWindow(31, nil)
end

init()
