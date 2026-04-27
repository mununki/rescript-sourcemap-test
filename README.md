# ReScript Source Map Test

Vite + React app for checking `.res -> .js.map` output from a local ReScript
compiler branch.

## Setup

Check out and build the sourcemap branch in a local ReScript compiler clone. The
examples below assume the compiler repository is cloned as `rescript` next to
this test project:

```sh
cd /path/to/rescript
git fetch origin
git checkout sourcemap
yarn install
opam exec -- make
```

The compiler repository uses Yarn, and `make` builds both the compiler and
rewatch binaries used by the linked `rescript` package.

The app uses npm packages for `@rescript/react` and `@rescript/runtime`. The
only local package link is the `rescript` compiler package. If your compiler
checkout is not next to this project, update that path in `package.json` before
installing:

```json
{
  "devDependencies": {
    "rescript": "link:/path/to/rescript"
  }
}
```

`@rescript/runtime` is pinned to the npm-published 13 alpha runtime because this
test app is meant to run against a 13 alpha compiler branch.

Install this test app's dependencies with pnpm after the `rescript` link points
at your local checkout:

```sh
cd /path/to/rescript-sourcemap-test
pnpm install
```

Build ReScript and the Vite production bundle:

```sh
pnpm build
```

After changing compiler code, rerun `opam exec -- make` in the compiler checkout
before rebuilding this test app.

## Browser Test

Run the Vite dev server:

```sh
pnpm dev
```

React app test:

1. Open `http://127.0.0.1:5173/`.
2. Open DevTools Sources and search for `SourceMapProbe.res`.
3. Set a breakpoint on `throw(BrowserSourceMapError(message))`.
4. Click `Throw ReScript exception`.
5. The breakpoint should pause in `SourceMapProbe.res`.

React console-link test:

1. Open `http://127.0.0.1:5173/`.
2. Click `Throw JS Error`.
3. The console stack should include `SourceMapProbe.res`.

The `Throw ReScript exception` button throws a ReScript exception object.
React reports errors thrown from synthetic event handlers through React's own
dispatch path, so Chrome may show a top-level `react-dom_client.js` console
link even though the nested stack and breakpoints still map to `.res`.

Direct generated-JS test:

1. Open `http://127.0.0.1:5173/direct-browser.html`.
2. Open DevTools Sources and search for `DirectBrowserProbe.res`.
3. Set a breakpoint on `throw(DirectBrowserSourceMapError(message))`.
4. Click `Throw from direct ReScript module`.
5. The breakpoint should pause in `DirectBrowserProbe.res`.

Line and column accuracy test:

1. Open `http://127.0.0.1:5173/accuracy.html`.
2. Open DevTools Sources and search for `AccuracyProbe.res`.
3. Set breakpoints on these call sites:
   - `JsError.throwWithMessage` inside `asciiBaseline`
   - `JsError.throwWithMessage` inside `unicodeColumn`
   - `JsError.throwWithMessage` inside `emojiColumn`
   - `JsError.throwWithMessage` inside `multipleExpressions`
4. Click the matching buttons. Each pause should land on the matching `.res`
   line, and the highlighted expression should be near the `JsError` call.
5. Search for `CrLfProbe.res`, set a breakpoint on its `JsError.throwWithMessage`
   call, then click `CRLF source file`.

For the Unicode and emoji cases, the important check is the column location:
the `unicodeColumn` and `emojiColumn` functions put Korean text or an emoji
before the throwing expression on the same source line. If UTF-8 byte offsets
are accidentally used as source-map columns, these breakpoints tend to bind too
far to the right.

Pipe and pattern match test:

1. Open `http://127.0.0.1:5173/pipe-match.html`.
2. Open DevTools Sources and search for `PipeMatchProbe.res`.
3. For pipe mapping, set breakpoints around the `runPipe` pipe expression,
   especially the `"pipe-input"` line, then click `Throw from pipe chain`.
4. When the exception pauses in `throwPipeMatchProbeErrorWithPrefix`, select
   the `runPipe` frame in the call stack. It should point back to the pipe
   expression in `PipeMatchProbe.res`.
5. For pattern matching, set breakpoints on each branch body inside `describe`,
   then click the matching `PipeOk`, `PipeMissing`, and `PipeFailed` buttons.
6. Each breakpoint should bind in `PipeMatchProbe.res`, and the console stack
   should include `.res` locations for the throwing branch.

Production build smoke test:

```sh
pnpm build
```

For browser behavior, prefer the manual DevTools checks above. The compiler PR
has its own repository test for `.js.map` file generation.

## Node Test

Run the automated Node stack trace check:

```sh
pnpm run test:node-sourcemap
```

It builds ReScript, runs `src/NodeProbe.js` with `node --enable-source-maps`,
expects the program to throw, and verifies that the stack trace mentions
`NodeProbe.res`.

For manual inspection:

```sh
pnpm run res:build
node --enable-source-maps src/NodeProbe.js
```

That command is expected to exit with an error. With source maps enabled, the
stack trace should point at `src/NodeProbe.res`. Without `--enable-source-maps`,
Node should report `src/NodeProbe.js` instead.
