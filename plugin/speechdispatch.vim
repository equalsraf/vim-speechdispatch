if exists("g:loaded_speechdispatch")
  finish
endif
let g:loaded_speechdispatch = 1

function s:spd_command(...)
	if exists('g:spd_cmd')
		let cmd = g:spd_cmd
	else
		let cmd = ['spd-say', '-N', 'neovim']
	endif

	if exists('g:spd_cmd_options')
		let cmd = cmd + g:spd_cmd_options
	endif

	if exists('b:spd_cmd_options')
		let cmd = cmd + b:spd_cmd_options
	endif

	return cmd + a:000
endfunction

function s:run_command(argv)
	if has('nvim')
		call jobstart(a:argv)
	else
		call job_start(a:argv)
	endif
endfunction

function SPDSay(text)
	call s:run_command(s:spd_command(a:text))
endfunction

function SPDSayPunctAll(text)
	call s:run_command(s:spd_command('-m', 'all', a:text))
endfunction

" Stop speaking
function SPDStop()
	call s:run_command(s:spd_command('-S'))
endfunction

function SPDSpell(text)
	call s:run_command(s:spd_command('-s', a:text))
endfunction

" Escape special chars when using SSML, this was written for
" espeak and is untested in spd
function SSMLEscape(text)
	let text = substitute(a:text, '&', '\&amp;', 'g')
	let text = substitute(text, '<', '\&lt;', 'g')
	let text = substitute(text, '>', '\&gt;', 'g')
	return text
endfunction

" Say the current line number
function SayLineNumber()
	call SPDSay(line('.'))
endfunction

" Say the current line content
function SayLine()
	call SPDSay(getline('.'))
endfunction

" Say the word under the cursor
function SayWord()
	call SPDSay(expand('<cword>'))
endfunction

" Say char under the cursor
function SayChar()
	call SPDSayPunctAll(getline('.')[col('.')-1])
endfunction
