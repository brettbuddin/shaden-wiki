## Install

Copy `lumen.vim` plugin to your `plugin` directory:

    $ mkdir -p $HOME/.vim/plugin
    $ cp extra/lumen.vim $HOME/.vim/plugin/lumen.vim

Add key-bindings to your `vimrc`:

```vimscript
" Send a visual block of code to Lumen for evaluation
vnoremap <C-S-P> :<C-U>LumenPatchSelection<CR>

" Send a line of code to Lumen for evaluation
nnoremap <C-S-P> :<C-U>LumenPatchLine<CR>
```
