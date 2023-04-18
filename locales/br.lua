local Translations = {
    info = {
        used_vape = "Você começou a usar o vape, use U para parar ou o comando /stopvape",
       
    },
    
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
