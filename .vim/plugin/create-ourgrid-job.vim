" Vim plugin to generate new OurGrid's Job Description File.
" Author:   Jonhnny Weslley <jonhnnyweslley@gmail.com>
" Version:  0.1

function! MakeJobDescriptionFile()
    if exists("b:template_used") && b:template_used
        return
    endif
    
    let b:template_used = 1
    
    let filename = expand("<afile>:p")
    let x = substitute(filename, "\.jdf$", "", "")
    let label = substitute(x, ".*/", "", "")

    call append(0, "job :")
    call append(1, "label  : " . label)
    call append(2, "")
    call append(3, "task :")
    call append(4, "remote  : ")
    
endfunction

au BufNewFile *.jdf call MakeJobDescriptionFile()

" vim: set ts=4 sw=4 et:
