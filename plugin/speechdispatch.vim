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

" Get text between two marks, according to the motion type (line, block, char)
function s:get_text(start, end, motion)
	let [lnum1, col1] = getpos(a:start)[1:2]
	let [lnum2, col2] = getpos(a:end)[1:2]
	let lines = getline(lnum1, lnum2)

	" TODO: How does this behave with inclusive/excusive
	if a:motion == 'line'
		" Motion is linewise
	elseif a:motion == 'block'
		let blockdata = []
		for line in lines
			let blockline = line[col1-1:col2-1]
			let blockdata = blockdata + [blockline]
		endfor
		let lines = blockdata
	else
		let lines[-1] = lines[-1][: col2 - 1]
		let lines[0] = lines[0][col1 - 1:]
	endif

	return join(lines, "\n")
endfunction

function SayMotion(motion)
	let text = s:get_text("'[", "']", a:motion)
	call SPDSay(text)
	if exists('g:SayMotionView')
		call winrestview(g:SayMotionView)
	endif
endfunction
" Set opfunc=SayMotion, setting the restore context
function SetupSayMotion()
	let g:SayMotionView=winsaveview()
	set opfunc=SayMotion
endfunction

function! SaySelection()
	let m = visualmode()
	if m == "v"
		call SPDSay(s:get_text("'<", "'>", 'char'))
	elseif m == "V"
		call SPDSay(s:get_text("'<", "'>", 'line'))
	else
		call SPDSay(s:get_text("'<", "'>", 'block'))
	endif
endfunction

