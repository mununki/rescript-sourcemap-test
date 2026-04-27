exception NodeSourceMapError(string)

let formatMessage = label => {
  let prefix = "노드 sourcemap 🌏"
  prefix ++ " / " ++ label
}

let crashFromNode = () => {
  let message = formatMessage("stack trace should point at the original source")
  throw(NodeSourceMapError(message))
}

let _ = crashFromNode()
