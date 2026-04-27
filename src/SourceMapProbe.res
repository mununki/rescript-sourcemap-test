exception BrowserSourceMapError(string)

@new external makeError: string => JsError.t = "Error"

type sample = {
  title: string,
  count: int,
}

let renderLabel = sample => {
  let prefix = "브라우저 sourcemap 🌏"
  prefix ++ " / " ++ sample.title ++ " / count=" ++ Belt.Int.toString(sample.count)
}

let buildCrashMessage = sample => {
  let label = renderLabel(sample)
  "Thrown from SourceMapProbe.res: " ++ label
}

let explode = sample => {
  let message = buildCrashMessage(sample)
  throw(BrowserSourceMapError(message))
}

let explodeJsError = sample => {
  let message = buildCrashMessage(sample)
  makeError(message)->JsError.throw
}
