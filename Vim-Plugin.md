## Install

Copy `shaden.vim` plugin to your `plugin` directory:

    $ mkdir -p $HOME/.vim/plugin
    $ cp extra/shaden.vim $HOME/.vim/plugin/shaden.vim

Add key-bindings to your `vimrc`:

```vimscript
" Send a visual block of code to Shaden for evaluation
vnoremap <C-S-P> :<C-U>ShadenPatchSelection<CR>

" Send a line of code to Shaden for evaluation
nnoremap <C-S-P> :<C-U>ShadenPatchLine<CR>
```
