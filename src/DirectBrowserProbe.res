exception DirectBrowserSourceMapError(string)

let makeMessage = () => {
  "Direct browser sourcemap sample from DirectBrowserProbe.res"
}

let throwFromDirectBrowser = () => {
  let message = makeMessage()
  throw(DirectBrowserSourceMapError(message))
}
