# 🏠 redz-library-v5 · Brookhaven Edition

---

## Loader

Cole no seu script executor:

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/BrushHub/BrushHub/refs/heads/main/Librarys%20Modded/RedzModded/RedzBrookHaven.luau"))()
```

---

## Using

```lua
local Library = -- (carregue a library aqui)

local Window = Library:MakeWindow({
    "Meu Script",       -- Título
    "by você",          -- Subtítulo
    "MeuScript"         -- Pasta para salvar flags/configs (opcional)
})

local Tab = Window:MakeTab({
    "Principal",        -- Nome da aba
    "rbxassetid://..."  -- Ícone (opcional)
})
```

---

## Temas

| Tema | Descrição |
|------|-----------|
| `Brookhaven` ⭐ | Roxo escuro, lilás e tons pastéis. **Padrão.** |
| `Darker` | Cinza escuro clássico com azul índigo |

### Trocar de tema em runtime

```lua
Library:SetTheme("Darker")      -- muda para o tema escuro
Library:SetTheme("Brookhaven")  -- volta pro tema padrão
```

### Verificar tema atual

```lua
local tema = Library:GetCurrentTheme()
print(tema.Name) -- "Brookhaven"
```

### Listar todos os temas

```lua
local temas = Library:GetThemes()
-- { "Brookhaven", "Darker" }
```

---

## 🪟 Window — Métodos

```lua
local Window = Library:MakeWindow({ Title, SubTitle, ScriptFolder? })
```

| Método | Descrição |
|--------|-----------|
| `Window:MakeTab(config)` | Cria uma nova aba |
| `Window:SelectTab(index ou Tab)` | Seleciona uma aba |
| `Window:Minimize()` | Minimiza/restaura a janela |
| `Window:MinimizeButton()` | Alterna minimize com animação |
| `Window:Dialog(config)` | Abre um diálogo modal |
| `Window:Notify(config)` | Exibe uma notificação |
| `Window:NewMinimizer(KeyCode)` | Cria atalho de teclado para minimizar |
| `Window:SetTitle(texto)` | Altera o título da janela |
| `Window:SetSubTitle(texto)` | Altera o subtítulo |
| `Window:GetTitle()` | Retorna o título atual |
| `Window:GetSubTitle()` | Retorna o subtítulo atual |
| `Window:SetFlag(chave, valor)` | Define uma flag salva |
| `Window:GetFlag(chave)` | Lê uma flag |
| `Window:DeleteFlags()` | Apaga todas as flags salvas |
| `Window:GetTabByTitle(nome)` | Busca aba pelo nome |

---

## 📑 Tabs — Elementos

### Toggle

```lua
local toggle = Tab:AddToggle({
    "Nome do Toggle",   -- [1] Título
    false,              -- [2] Valor padrão
    function(value)     -- [3] Callback
        print("Toggle:", value)
    end,
    "minhaFlag"         -- [4] Flag (opcional)
})

toggle:SetValue(true)  -- muda o valor programaticamente
```

### Button

```lua
local btn = Tab:AddButton({
    "Clique aqui",      -- [1] Título
    function()          -- [2] Callback
        print("Clicado!")
    end,
    Desc = "Descrição opcional",
    Debounce = 1        -- cooldown em segundos (opcional)
})
```

### Slider

```lua
local slider = Tab:AddSlider({
    "Velocidade",       -- [1] Título
    0,                  -- [2] Mínimo
    100,                -- [3] Máximo
    1,                  -- [4] Incremento
    50,                 -- [5] Padrão
    function(value)     -- [6] Callback
        print("Valor:", value)
    end,
    "velocidadeFlag"    -- [7] Flag (opcional)
})

slider:SetValue(75)
```

### Dropdown

```lua
local dropdown = Tab:AddDropdown({
    "Escolha um item",              -- [1] Título
    {"Opção 1", "Opção 2", "Opção 3"}, -- [2] Opções
    "Opção 1",                      -- [3] Padrão
    function(selected)              -- [4] Callback
        print("Selecionado:", selected)
    end,
    "dropFlag",                     -- [5] Flag (opcional)
    MultiSelect = false             -- Seleção múltipla
})

dropdown:Add("Nova Opção")
dropdown:Remove("Opção 2")
dropdown:Clear()
dropdown:NewOptions({"A", "B", "C"})
```

### TextBox

```lua
local textbox = Tab:AddTextBox({
    "Digite algo",      -- [1] Título
    "",                 -- [2] Valor padrão
    function(text)      -- [3] Callback (ao perder foco)
        print("Texto:", text)
    end,
    "textoFlag",        -- [4] Flag (opcional)
    Placeholder = "Escreva aqui...",
    ClearOnFocus = false
})

textbox:SetText("Olá!")
textbox:SetPlaceholder("Novo placeholder")
textbox:Clear()
textbox:CaptureFocus()
```

### Section

```lua
Tab:AddSection("⚙️ Configurações")
```

### Paragraph

```lua
Tab:AddParagraph(
    "Título do parágrafo",
    "Texto de descrição mais longo aqui."
)
```

### Discord Invite

```lua
Tab:AddDiscordInvite({
    "Nome do Servidor",             -- [1] Título
    "Descrição do servidor",        -- [2] Desc
    Icon = "rbxassetid://...",
    Banner = Color3.fromRGB(155,89,182), -- ou URL da imagem
    Online = 1234,
    Members = 9999,
    Invite = "https://discord.gg/xxxxx"
})
```

---

## 🔔 Notificações

```lua
Window:Notify({
    "Título",           -- [1]
    "Mensagem aqui",    -- [2]
    "rbxassetid://...", -- [3] Ícone (opcional)
    5                   -- [4] Duração em segundos
})
```

### Grupo de notificações

```lua
local grupo = Window:NewNotifyGroup({
    "Título padrão",
    "Conteúdo padrão",
    nil,    -- ícone
    5       -- duração
})

grupo:Notify({ Title = "Diferente!", Content = "Mensagem específica" })
```

---

## 💬 Dialog (Modal)

```lua
Window:Dialog({
    Title = "Confirmação",
    Content = "Tem certeza que deseja continuar?",
    Options = {
        {
            Title = "Sim",
            Callback = function()
                print("Confirmado!")
            end
        },
        { Title = "Não" }
    }
})
```

---

## ⌨️ Minimizer (Atalho de teclado)

```lua
local minimizer = Window:NewMinimizer(Enum.KeyCode.RightShift)

-- Ou com opções:
local minimizer = Window:NewMinimizer({
    KeyCode = Enum.KeyCode.Insert
})

-- Trocar o KeyCode depois:
minimizer:SetKeyCode(Enum.KeyCode.Home)
```

---

## 🧩 Métodos comuns dos elementos

Todos os elementos (Toggle, Slider, Dropdown, TextBox, Button, etc.) compartilham:

```lua
elemento:SetTitle("Novo título")
elemento:SetDescription("Nova descrição")
elemento:SetVisible(false)        -- esconde
elemento:Destroy()                -- remove da UI
elemento:AddCallback(function()   -- adiciona callback extra
    print("callback adicional")
end)
```

---

## 💾 Flags (persistência)

Flags são salvas automaticamente em `ScriptFolder/ScriptFlags.json` quando você define `ScriptFolder` no `MakeWindow`.

```lua
-- Escrita automática ao interagir com o elemento (via parâmetro Flag)
Tab:AddToggle({ "Aimbot", false, callback, "AimbotAtivo" })

-- Leitura/escrita manual
Window:SetFlag("MinhaChave", true)
local val = Window:GetFlag("MinhaChave")

-- Apagar tudo
Window:DeleteFlags()
```

---

## 📐 Escala da UI

```lua
Library:SetUIScale(1.2)   -- entre 0.6 e 1.6
Library:GetMinScale()     -- → 0.6
Library:GetMaxScale()     -- → 1.6
```

---

## 🎨 Paleta do tema Brookhaven

| Chave | Cor | Uso |
|-------|-----|-----|
| `Primary` | `#9B59B6` 🟣 | Accent, toggles ativos, slider |
| `OnPrimary` | `#5A3278` 🔵 | Sombra do primary |
| `Buttons.Default` | `#34204F` | Fundo dos botões |
| `Buttons.Holding` | `#442D64` | Hover dos botões |
| `Stroke` | `#4B3269` | Bordas e inputs |
| `ScrollBar` | `#8250A0` | Barra de scroll |
| `Text.Default` | `#F5EBFF` | Texto principal |
| `Text.Dark` | `#C3A5E1` | Texto secundário |
| `Text.Darker` | `#9B7DB9` | Texto terciário |
| `JoinButton` | `#27AE60` | Botão "Go to Server" |
| `Link` | `#64B4FF` | Links e URLs |
| `Background` | `#26183A → #30234A` | Gradiente do fundo |

---

## 🔧 Destruir a UI

```lua
Library:Destroy()
```

Remove todos os elementos e desconecta todas as conexões.

---

## 📝 Informações

| Campo | Valor |
|-------|-------|
| Versão | `v2.0.1` |
| Tema padrão | `Brookhaven` |
| Autor original | `tlredz` |
| Tema Brookhaven | Adicionado Para Brush Haven (⚪), RedzModded By IA (Claude) |
