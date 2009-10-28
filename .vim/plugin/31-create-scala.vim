" Vim plugin to generate new Scala source file.
" Copied from 30-create-java.vim
" Author:   Stepan Koltsov <yozh@mx1.ru>
" Version:  0.0.1

function! MakeScalaFile()
    if exists("b:template_used") && b:template_used
        return
    endif
    
    let b:template_used = 1
    
    let filename = expand("<afile>:p")
    let x = substitute(filename, "\.scala$", "", "")
    
    let p = substitute(x, "/[^/]*$", "", "")
    let p = substitute(p, "/", ".", "g")
    let p = substitute(p, ".*\.src$", "@", "") " unnamed package
    let p = substitute(p, ".*\.src\.", "!", "")
    let p = substitute(p, "^!main\.scala\.", "!", "") "
    let p = substitute(p, "^!.*\.ru\.", "!ru.", "")
    let p = substitute(p, "^!.*\.org\.", "!org.", "")
    let p = substitute(p, "^!.*\.com\.", "!com.", "")
    
    " ! marks that we found package name.
    if match(p, "^!") == 0
        let p = substitute(p, "^!", "", "")
    else
        " Don't know package name.
        let p = "@"
    endif
    
    let class = substitute(x, ".*/", "", "")
    
    if p != "@"
        call append("0", "package " . p)
    endif
    
    "norm G
    call append(".", "class " . class . " {")
    
    "norm G
    call append(".", "} /// end of " . class)
    
    call append(".", "// vim: set ts=4 sw=4 et:")
    call append(".", "")
    
endfunction

au BufNewFile *.scala call MakeScalaFile()

" vim: set ts=4 sw=4 et:
