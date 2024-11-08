return {
    {
        Str = function(elem)
            if elem.text == "{{message}}" then
                return pandoc.Emph { pandoc.Str "Oi, Lua!" }
            else
                return elem
            end
        end,
    }
}
