"
" An example configuration using the vim-speechdispath
" functions.
"

" Use <Leader>s as a motion operator to say arbitrary text objects
" e.g. \saw says the current word
nmap <Leader>s :call SetupSayMotion()<CR>g@
" it also works with  the visual selection
vmap <Leader>s :call SaySelection()<CR>

" <Leader> capital S silences the last command
nmap <Leader>S :call SPDStop()<CR>

