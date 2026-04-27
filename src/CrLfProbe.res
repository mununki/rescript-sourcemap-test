let crlfLabel = "CRLF source file"

let throwFromCrLf = () => {
  let message = crlfLabel ++ " should map to CrLfProbe.res"
  JsError.throwWithMessage(message)
}
