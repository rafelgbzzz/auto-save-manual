-- Buat Window utama
local ui = WindUI.CreateWindow({
    Title = "STREE HUB",
    Author = "KinoseC - flux li",
    Icon = "rbxassetid://7733765398", -- bebas ganti icon
    Size = UDim2.new(0, 640, 0, 420),
    Theme = WindUI.Themes.Dark, -- pakai tema gelap
    Folder = "StreeHub",
    MinSize = Vector2.new(480,325),
    Acrylic = false,
})

-- Label badge di header window
ui.Tag({Title = "v0.0.2.8", Color = Color3.fromRGB(34, 197, 94)})
ui.Tag({Title = "Freemium", Color = Color3.fromRGB(255, 193, 7)})

-- Buat Tab sidebar (sidebar di kiri)
local tabs = {
    {"Info", "info"},
    {"Players", "users"},
    {"Main", "key"},
    {"Shop", "shopping-bag"},
    {"Teleport", "map"},
    {"Settings", "settings"},
}
local tabSections = {}
for i, v in ipairs(tabs) do
    local tab = ui.Tab({Title = v[1], Icon = v[2]})
    tabSections[v[1]] = tab.Section({Title = v[1]})
end

-- Section USER Anonymous (paling bawah sidebar)
ui.User.SetAnonymous(true)
ui.User.Enable()
ui.User.Callback = function()
    WindUI.Notify({Title="Anonymous", Content="Info user klik!", Duration=2})
end

-- Tab Info - Tambahkan penjelasan sederhana
local sectionInfo = tabSections["Info"]
sectionInfo.Paragraph({Title = "Ini adalah tampilan Stree Hub v0.0.2.8 Freemium versi polos.
Menu di sidebar kiri untuk akses fitur berbeda."})

-- Tab Players - Polosan saja
local sectionPlayers = tabSections["Players"]
sectionPlayers.Paragraph({Title = "Daftar player akan tampil di sini (polosan)."})

-- Tab Main - Tombol contoh
local sectionMain = tabSections["Main"]
sectionMain.Paragraph({Title = "Menu utama script, contoh tombol di bawah."})
sectionMain.Button({Title = "Memunculkan Kapal", Callback = function()
    WindUI.Notify({Title = "Kapal berhasil dimunculkan.", Duration=2})
end})

-- Tab Shop
local sectionShop = tabSections["Shop"]
sectionShop.Paragraph({Title = "Toko, info, atau menu pembelian bisa kamu taruh di sini."})

-- Tab Teleport
local sectionTeleport = tabSections["Teleport"]
sectionTeleport.Paragraph({Title = "Fitur teleportasi, pilih tujuan atau interaksi lainnya."})

-- Tab Settings
local sectionSettings = tabSections["Settings"]
sectionSettings.Paragraph({Title = "Pengaturan dan preferensi bisa diatur di sini."})

-- Window muncul di tengah
ui.SetToTheCenter()
ui.Open()
