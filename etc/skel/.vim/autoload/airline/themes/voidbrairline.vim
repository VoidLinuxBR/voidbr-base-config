" voidbrairline Airline Theme
" Author: Vilmar Catafesta
" Repository: https://github.com/voidlinuxbr/voidbr-base-config
" Version: 0.10
" License: MIT

let s:theme = 'voidbrairline'
let s:want_showmod = get(g:, 'airline_voidbrairline_showmod', 0)

function! airline#themes#voidbrairline#refresh()
  if &background == "dark"

    let N1 = [ '#E4E4E4', '#3A3A3A', 189, 0 ]
    let N2 = [ '#E4E4E4', '#4E4E4E', 254, 239 ]
    let N3 = [ '#EEEEEE', '#262626', 255, 235 ]

    let I1 = [ '#E4E4E4', '#3A3A3A', 7, 197 ]
    let I2 = [ '#E4E4E4', '#4E4E4E', 0, 0 ]
    let I3 = [ '#EEEEEE', '#262626', 0, 0 ]

    let V1 = [ '#E4E4E4', '#3A3A3A', 7, 90 ]
    let V2 = [ '#E4E4E4', '#4E4E4E', 0, 0 ]
    let V3 = [ '#EEEEEE', '#262626', 0, 0 ]

    let IA = [ '#666666', N3[1], 242, N3[3] ]

    let ER = [ '#1C1C1C', '#f24c63', 234, 167 ]
    let WI = [ ER[0], '#f24c63', ER[2], 215 ]

  else

    let N1 = [ 'gray30', 'gray70', 235, 249 ]
    let N2 = [ 'gray20', 'gray60', 233, 246 ]
    let N3 = [ 'gray20', 'gray80', 233, 251 ]

    let I1 = [ 'gray30', 'gray70', 235, 249 ]
    let I2 = [ 'gray20', 'gray60', 233, 246 ]
    let I3 = [ 'gray20', 'gray80', 233, 251 ]

    let V1 = [ 'gray30', 'gray70', 235, 249 ]
    let V2 = [ 'gray20', 'gray60', 233, 246 ]
    let V3 = [ 'gray20', 'gray80', 233, 251 ]

    let IA = [ 'gray15', N3[1], 244, N3[3] ]

    let ER = [ '#1C1C1C', '#D75F5F', 234, 167 ]
    let WI = [ ER[0], '#f24c63', ER[2], 215 ]

  endif

  let TE = [ ER[0], N1[1], N1[2], N1[3] ]
  let NR = [ N2[1], N2[0], N2[3], N2[2], 'bold' ]

  let palette = {}

  let palette.normal = airline#themes#generate_color_map(N1, N2, N3)
  let palette.insert = airline#themes#generate_color_map(I1, I2, I3)
  let palette.visual = airline#themes#generate_color_map(V1, V2, V3)

  let palette.normal.airline_error   = ER
  let palette.normal.airline_warning = WI
  let palette.normal.airline_term    = TE

  let palette.replace  = palette.normal
  let palette.inactive = airline#themes#generate_color_map(IA, IA, IA)

  if s:want_showmod
    let palette.normal_modified = { 'airline_a': NR, 'airline_z': NR }
  endif

  let palette.accents = {
        \ 'red': [ ER[1], '', ER[3], '' ]
        \ }

  if get(g:, 'loaded_ctrlp', 0)
    let palette.ctrlp = airline#extensions#ctrlp#generate_color_map(N3, N2, NR)
  endif

  let g:airline#themes#voidbrairline#palette = palette

endfunction

