import strutils, sequtils

type
  Format = enum
    RESET_ALL
    BOLD
    DIM
    UNDERLINE = 4
    BLINK
    INVERTED = 7
    HIDDEN


    RED = 31

  CauVong = object
    text: string
    flags: seq[FormatCode]

proc newCauVong(s: string, f: FormatCode): CauVong =
  result.text = s
  result.flags = @[]
  result.flags.add(f)

proc `$`*(cv: CauVong): string =
  if len(cv.flags) > 0:
    var flags = ""

    flags.add($(cv.flags[0].ord))
    for i in 1..cv.flags.len-1:
      flags.add(";")
      flags.add($(cv.flags[i].ord))

    result = "\e[$#m$#\e[0m" % [flags, cv.text]
  else:
    result = cv.text


proc bold*[T: string|CauVong](s: T): CauVong =
  when s is CauVong:
    result.add(BOLD)
  else:
    result = newCauVong(s, BOLD)

var a = "Hello World".bold
echo a
