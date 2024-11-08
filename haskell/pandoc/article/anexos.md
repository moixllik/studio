## Anexos

**Anexo 1.** Archivo de referencias

```bib
@misc{doc2024,
    title={Pandoc User’s Guide},
    author={Pandoc},
    year={2024},
    url={https://pandoc.org/MANUAL.html}
}
```

**Anexo 2.** Filtro con Lua

Filtro que reemplaza {{ message }} por "{{message}}", ver @lua2024.

```lua
-- replace.lua
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
--
```
