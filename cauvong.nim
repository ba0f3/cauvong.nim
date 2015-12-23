import macros, strutils

type
  Format = enum
    BOLD = 1
    DIM
    UNDERLINE = 4
    BLINK
    INVERTED = 7
    HIDDEN


    BLACK = 30
    RED
    GREEN
    YELLOW
    BLUE
    MAGENTA
    CYAN
    LIGHT_GRAY
    DARK_GRAY = 90
    LIGHT_RED
    LIGHT_GREEN
    LIGHT_YELLOW
    LIGHT_BLUE
    LIGHT_MAGENTA
    LIGHT_CYAN
    WHITE


  CauVong = ref object
    text: string
    flags: seq[string]

proc add(c: CauVong, f: Format) =
  c.flags.add($(f.ord))


proc newCauVong(s: string, f: Format): CauVong =
  new(result)
  result.text = s
  result.flags = @[]
  result.add(f)


proc `$`*(cv: CauVong): string {.inline.} =
  if len(cv.flags) > 0:
    var flags = ""
    flags.add(cv.flags[0])
    for i in 1..cv.flags.len-1:
      flags.add(";")
      flags.add(cv.flags[i])
      result = "\e["
      result.add(flags)
      result.add("m")
      result.add(cv.text)
      result.add("\e[0m")
  else:
    result = cv.text


macro genProc(e: expr): stmt {.immediate.} =
  result = newStmtList()

  var procName = ($e).toLower
  var ret = !"result"
  result.add(
    newProc(
      name = ident(procName).postfix("*"),
      params = [
        ident("CauVong"),
        newIdentDefs(
          ident("s"),
          ident("string")
        )
      ],
      body = newStmtList(newAssignment(
        ident("result"),
        newCall("newCauVong", ident("s"), ident($e))
      ))
    )
  )
  echo result.treeRepr
  result.add(
    newProc(
      name = ident(procName).postfix("*"),
      params = [
        ident("CauVong"),
        newIdentDefs(
          ident("cv"),
          ident("CauVong")
        )
      ],
      body = quote do:
        cv.add(`e`)
        cv
    )
  )

genProc(BOLD)
genProc(DIM)
genProc(UNDERLINE)
genProc(BLINK)
genProc(INVERTED)
genProc(HIDDEN)

genProc(BLACK)
genProc(RED)
genProc(GREEN)
genProc(YELLOW)
genProc(BLUE)
genProc(MAGENTA)
genProc(CYAN)
genProc(LIGHT_GRAY)
genProc(DARK_GRAY)
genProc(LIGHT_RED)
genProc(LIGHT_GREEN)
genProc(LIGHT_YELLOW)
genProc(LIGHT_BLUE)
genProc(LIGHT_MAGENTA)
genProc(LIGHT_CYAN)
genProc(WHITE)

dumpTree:
  proc red*(s: string): CauVong =
    result = newCauVong(s, RED)
#  proc red*(cv: CauVong): CauVong =
#    cv.add(RED)
#    cv



when isMainModule:
  echo "Hello World".red.bold.underline
  echo "Welcome".red, " to".green, " the".yellow, " world".blue, " of".magenta, " colors".cyan
