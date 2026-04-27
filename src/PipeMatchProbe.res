type probeResult =
  | PipeOk(string)
  | PipeMissing
  | PipeFailed(string)

@scope("globalThis") @val
external raiseProbeError: string => 'a = "throwPipeMatchProbeError"

@scope("globalThis") @val
external raiseProbeErrorWithPrefix: (string, string) => 'a = "throwPipeMatchProbeErrorWithPrefix"

let normalize = value => value ++ " / normalized"

let validate = value => value ++ " / validated"

let runPipe = () =>
  "pipe-input"
  ->normalize
  ->validate
  ->raiseProbeErrorWithPrefix("PipeMatchProbe.res pipe crash: ")

let describe = result =>
  switch result {
  | PipeOk(value) =>
    let decorated = "ok branch / " ++ value
    ("PipeMatchProbe.res match crash: " ++ decorated)->raiseProbeError
  | PipeMissing =>
    let decorated = "missing branch"
    ("PipeMatchProbe.res match crash: " ++ decorated)->raiseProbeError
  | PipeFailed(reason) =>
    let decorated = "failed branch / " ++ reason
    ("PipeMatchProbe.res match crash: " ++ decorated)->raiseProbeError
  }

let runMatchOk = () => describe(PipeOk("ok-value"))

let runMatchMissing = () => describe(PipeMissing)

let runMatchFailed = () => describe(PipeFailed("bad-value"))
