  doctype 5
  html lang: "en", ->
    head ->
      meta charset: 'utf-8'

      if @title?
        title "Astro 林 #{@title}"
      else
        title "Astro 林" # route?

      meta(name: 'description', content: @description) if @description?
      link(rel: 'canonical', href: @canonical) if @canonical?

      link rel: 'icon', href: '/favicon.ico'

      style '''
        .wf-loading { visibility: hidden }
      '''
      script src: "http://use.typekit.com/loe7yzm.js"
      script "try{Typekit.load();}catch(e){}"

      link rel: 'stylesheet', href: '/css/style.css'

    body id: "whole", ->
      div id: "header", ->
        h1 -> center "ASTRO 林 LIN"
      div id: "torso", ->
        @body
