# Las mismas de siempre

Un regalo de Charlott para Valesca. La historia y las fotografías proceden de las 41 páginas de Canva; las páginas 38–41 forman los créditos ascendentes.

Abrir `index.html` para entrar. La web es estática y no necesita instalación ni servicios externos. También funciona con GitHub Pages.

- **Ver historia completa:** reproducción automática con música.
- **Anterior / Siguiente:** cambiar de recuerdo, incluso durante la pausa.
- **Barra de tiempo:** saltar a cualquier momento, con audio sincronizado.
- **Espacio:** pausar; flechas: navegar; Escape: volver a los capítulos.
- **Descargar película:** MP4 H.264/AAC, 1280 × 720, 5:48, unos 14 MB. El MP4 conserva fotos, textos, videos, música y créditos; usa fundidos suaves entre escenas. La web añade las transiciones de ventanas y cursor del proyecto original.

## Edición

`story-data.js` contiene los textos corregidos, el orden y los tiempos. `player.js` controla la reproducción. Las escenas narrativas se renderizan desde el PowerPoint en `media/slides/`: conservan exactamente los recortes, los marcos y la posición de cada foto. Las imágenes originales se guardan también en `media/album/`, sin enlaces temporales de Canva. Los rótulos de capítulo se fijaron según el capítulo narrativo, y las páginas de menú repetidas se conservaron como transiciones intencionales.

Las bromas de las páginas 8, 22 y 23 revelan el remate 1,8 segundos después de la frase inicial, tanto en la web como en el MP4. La portada del capítulo 1 usa un recorte específico de Supergirl que muestra la cara; la foto narrativa original permanece intacta.

El audio mezcla **May Be** y **River Flows in You**, de Yiruma, a partir de los archivos aportados. Tiene 8 segundos de fundido entre canciones, entrada de 3 segundos y salida de 10 segundos. El sonido original de 2014 está integrado en la mezcla, con el piano atenuado durante ese recuerdo. Por eso los elementos de video de la web se reproducen silenciados.

Para regenerar las escenas desde el PPTX en Windows con PowerPoint: `./scripts/export-ppt-frames.ps1 "ruta/al/archivo.pptx"`. El script abre una copia en memoria, corrige rótulos y ortografía y exporta las páginas sin modificar el original. Para regenerar el audio y el MP4: instalar Node.js, FFmpeg (incluye ffprobe) y las dependencias con `npm install`; luego ejecutar `npm run audio`, `npm run video` y `npm run check`. La suma de las dos canciones con el fundido es de aproximadamente 350 segundos; si se amplía la película, hay que ajustar también el montaje musical. Los archivos temporales se guardan en `.build/` y no se publican.

Verificación realizada: reproducción y navegación en navegador, pausa y retroceso, lectura de Parabatai en móvil de 390 × 844, créditos, carga de imágenes y duración/códecs del MP4.
