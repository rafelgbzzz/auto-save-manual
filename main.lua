-- Pastikan sudah load library WindUI yang kamu lampirkan

-- Misal: loadstring(game:HttpGet('https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua'))()
local WindUI = loadfile('main.lua')() -- gunakan file lokal jika di executor mendukung

local ui = WindUI.CreateWindow({
    Title = "STREE HUB",
    Author = "KinoseC - flux li",
    Icon = "rbxassetid://7733765398", -- gunakan ikon sesuai kebutuhanmu
    Size = UDim2.new(0, 640, 0, 420),
    Theme = WindUI.Themes.Dark,
    Folder = "StreeHub",
    MinSize = Vector2.new(480,325),
    Acrylic = false,
    -- Untuk draggable, resizable, dsb., bisa diatur juga di sini
})

-- Badge/label versi & status freemium (seperti pada atas window)
ui.Tag({Title = "v0.0.2.8", Color = Color3.fromRGB(34, 197, 94)})
ui.Tag({Title = "Freemium", Color = Color3.fromRGB(255, 193, 7)})

-- Sisi sidebar kiri: Daftar menu utama
local tabNames = {
    {"Info", "info"}, 
    {"Players", "users"},
    {"Main", "key"},
    {"Shop", "shopping-bag"},
    {"Teleport", "map"},
    {"Settings", "settings"},
}
local sidebarTabs = {}
for _, data in ipairs(tabNames) do
    local tab = ui.Tab({Title = data[1], Icon = data[2]})
    table.insert(sidebarTabs, tab)
    -- Contoh: Setiap tab punya section untuk isian masing-masing
    tab.Section({Title=data[1].." Section"})
end

-- Section anonim user profile (bagian paling bawah sidebar)
ui.User.SetAnonymous(true)
ui.User.Enable()
-- Kalau ingin menambahkan klik untuk info lebih lanjut:
ui.User.Callback = function()
    WindUI.Notify({Title="Anonymous", Content="Profil klik!", Duration=2})
end

-- Contoh: Mengisi elemen di Tab Info
local infoSection = sidebarTabs[1].Section({Title="Deskripsi", Icon="info"})
infoSection.Paragraph({Title="Ini adalah Stree Hub v0.0.2.8 Freemium.
Script hub universal untuk berbagai game Roblox. Menu di sidebar kiri untuk fitur lengkap."})

-- Friend system, boost, coin dsb bisa ditaruh di Section berikutnya
infoSection.Paragraph({Title="🟡 Friendlist: +0%
🪙 1.6kk
Lokasi: Pulau Yakushima"})

-- Custom button contoh di tab "Main"
local mainSection = sidebarTabs[3].Section({Title="Script Utama"})
mainSection.Button({Title = "Memunculkan Kapal", Callback = function()
    WindUI.Notify({Title = "Kapal berhasil dimunculkan.", Duration=2})
end})

-- Untuk tab/tab menu lainnya, tambahkan sesuai kebutuhan, gunakan Section/Input/Toggle/Button WindUI

-- Agar jendela muncul di tengah layar (opsional)
ui.SetToTheCenter()

-- Buka window otomatis
ui.Open()
