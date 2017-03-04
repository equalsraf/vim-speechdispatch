
Call speech-dispatcher from Vim. This works by calling spd-say with the
proper arguments. Probably not the most efficient backend, but it works
well enough for now(TM) -- an alternative would be to implement a SSIP
client in vimscript or an intermediate process to handle this.

This provides various vim script functions

- SPDSay(text), SPDStop(text) SPD... call spd-say with various arguments
- SayLine(), SayChar(), Say... are convinience functions
- spd-say commands are build from argument lists as 
  'g:spd_cmd + g:spd_cmd_options +  b:spd_cmd_options' which you can use
  to override them, using global or buffer options.

This is very much a WIP project. But it would be cool to be able to build screen
readers on top of Vim.

Made available under the ISC license.
