local commands = {
    ["save"] = function()
        save_ar(1)
    end,
    ["open"] = function()
        --TODO
    end,
    ["exit"] = function()
        initar("saves/def_save.txt")
        mode = "run"
    end
}
return(commands)
