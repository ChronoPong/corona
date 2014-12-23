local scoreLib = {}  --create the local module table (this will hold our functions and data)
scoreLib.score = 0  --set the initial score to 0
function scoreLib.init( options )
   local customOptions = options or {}
   local opt = {}
   opt.fontSize = customOptions.fontSize or 24
   opt.font = customOptions.font or native.systemFontBold
   opt.x = customOptions.x or display.contentCenterX
   opt.y = customOptions.y or opt.fontSize*0.5
   opt.maxDigits = customOptions.maxDigits or 6
   opt.leadingZeros = customOptions.leadingZeros or false
   scoreLib.filename = customOptions.filename or "scorefile.txt"
   local prefix = ""
   if ( opt.leadingZeros ) then 
      prefix = "0"
   end
   scoreLib.format = "%" .. prefix .. opt.maxDigits .. "d"
   scoreLib.scoreText = display.newText( string.format(scoreLib.format, 0), opt.x, opt.y, opt.font, opt.fontSize )
   return scoreLib.scoreText
end


function scoreLib.set( value )
   scoreLib.score = value
   scoreLib.scoreText.text = string.format( scoreLib.format, scoreLib.score )
end
function scoreLib.get()
   return scoreLib.score
end
function scoreLib.add( amount )
   scoreLib.score = scoreLib.score + amount
   scoreLib.scoreText.text = string.format( scoreLib.format, scoreLib.score )
end

function scoreLib.save()
   local path = system.pathForFile( scoreLib.filename, system.DocumentsDirectory )
   local file = io.open(path, "w")
   if ( file ) then
      local contents = tostring( scoreLib.score )
      file:write( contents )
      io.close( file )
      return true
   else
      print( "Error: could not read ", scoreLib.filename, "." )
      return false
   end
end
function scoreLib.load()
   local path = system.pathForFile( scoreLib.filename, system.DocumentsDirectory )
   local contents = ""
   local file = io.open( path, "r" )
   if ( file ) then
      -- read all contents of file into a string
      local contents = file:read( "*a" )
      local score = tonumber(contents);
      io.close( file )
      return score
   else
      print( "Error: could not read scores from ", scoreLib.filename, "." )
   end
   return nil
end
return scoreLib

