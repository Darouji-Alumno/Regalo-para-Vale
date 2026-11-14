param([Parameter(Mandatory=$true)][string]$PowerPointPath)
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$data=Get-Content (Join-Path $root 'story-data.js') -Raw
$json=$data.Substring($data.IndexOf('{'),$data.LastIndexOf('}')-$data.IndexOf('{')+1)
$story=$json | ConvertFrom-Json
$out=Join-Path $root 'media/slides'
New-Item -ItemType Directory -Force $out | Out-Null
$app=New-Object -ComObject PowerPoint.Application
$deck=$app.Presentations.Open((Resolve-Path $PowerPointPath).Path,$true,$false,$false)
try {
  function Get-TextShapes($shapes) {
    foreach($shape in $shapes) {
      if($shape.HasTextFrame -eq -1 -and $shape.TextFrame.HasText -eq -1) { $shape }
      if($shape.Type -eq 6) { Get-TextShapes $shape.GroupItems }
    }
  }
  foreach($chapter in $story.chapters) {
    $i=[array]::IndexOf($story.chapters,$chapter)+1
    foreach($scene in $chapter.slides) {
      $slide=$deck.Slides.Item([int]$scene.page)
      $used=$false
      foreach($shape in @(Get-TextShapes $slide.Shapes)) {
        $raw=$shape.TextFrame.TextRange.Text
        $t=$raw.Trim()
        if(-not $t) {continue}
        if($scene.page -eq 8 -and $shape.Name -eq 'TextBox 5') {
          $shape.TextFrame.TextRange.Text='Incluso en ese entonces...'
          $shape.Left=0;$shape.Width=$deck.PageSetup.SlideWidth
          $shape.TextFrame.TextRange.ParagraphFormat.Alignment=2
          continue
        }
        if($scene.page -eq 8 -and $shape.Name -eq 'TextBox 16') {$shape.TextFrame.TextRange.Text='';continue}
        if($scene.page -eq 22 -and $shape.Name -eq 'TextBox 3') {
          $shape.TextFrame.TextRange.Text='El mundo era nuestro'
          $shape.TextFrame.TextRange.Font.Name='Georgia'
          $shape.TextFrame.TextRange.Font.Size=23
          $shape.TextFrame.TextRange.Font.Bold=0
          continue
        }
        if($scene.page -eq 22 -and $shape.Name -eq 'TextBox 20') {$shape.TextFrame.TextRange.Text='';continue}
        if($scene.page -eq 23 -and $shape.Name -eq 'TextBox 4') {
          $shape.TextFrame.TextRange.Text='El mundo es nuestro'
          $shape.TextFrame.TextRange.Font.Name='Georgia'
          $shape.TextFrame.TextRange.Font.Size=23
          $shape.TextFrame.TextRange.Font.Bold=0
          continue
        }
        if($scene.page -eq 23 -and $shape.Name -eq 'TextBox 5') {
          $shape.TextFrame.TextRange.Text='Algunos no tanto...'
          $shape.TextFrame.TextRange.Font.Name='Georgia'
          $shape.TextFrame.TextRange.Font.Size=21
          $shape.TextFrame.TextRange.Font.Italic=-1
          $shape.Left=0;$shape.Width=$deck.PageSetup.SlideWidth
          $shape.TextFrame.TextRange.ParagraphFormat.Alignment=2
          continue
        }
        if($t -match '^0[1-4]\s*/') {$shape.TextFrame.TextRange.Text=('0{0} / {1}' -f $i,$chapter.era);continue}
        if($t -match '^(Pequeñas aventuras|Ya no tan pequeñas|El mundo era nuestro|Treinta, y las de siempre)$') {$shape.TextFrame.TextRange.Text=$chapter.title;continue}
        if($t -match '^(PLAY|CHARLOTT &|SP\s|RECUERDOS PARA GUARDAR)') {continue}
        if(-not $used) {$shape.TextFrame.TextRange.Text=$scene.caption -replace '\n',"`r";$used=$true}
        else {$shape.TextFrame.TextRange.Text=''}
      }
      $png=Join-Path $out ('page-{0:D2}.png' -f $scene.page)
      $slide.Export($png,'PNG',1600,900)
      & ffmpeg -v error -y -i $png -q:v 3 ($png -replace '\.png$','.jpg')
      Remove-Item -LiteralPath $png
      Write-Output ('Exported page {0}' -f $scene.page)
    }
  }
} finally { $deck.Close();$app.Quit() }
