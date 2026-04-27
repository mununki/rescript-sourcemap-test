@react.component
let make = () => {
  let (count, setCount) = React.useState(() => 0)
  let sample: SourceMapProbe.sample = {
    title: "Vite + React",
    count,
  }
  let label = SourceMapProbe.renderLabel(sample)

  <main className="app-shell">
    <section className="panel">
      <p className="eyebrow"> {"ReScript source map probe"->React.string} </p>
      <h1> {"Breakpoints should land in .res files"->React.string} </h1>
      <p className="summary">
        {("Open DevTools, set breakpoints in App.res or SourceMapProbe.res, then click the buttons."
        )->React.string}
      </p>
      <div className="readout">
        <span> {label->React.string} </span>
      </div>
      <div className="actions">
        <button onClick={_event => setCount(current => current + 1)}>
          {"Increment count"->React.string}
        </button>
        <button className="danger" onClick={_event => SourceMapProbe.explode(sample)}>
          {"Throw ReScript exception"->React.string}
        </button>
        <button className="danger" onClick={_event => SourceMapProbe.explodeJsError(sample)}>
          {"Throw JS Error"->React.string}
        </button>
      </div>
    </section>
  </main>
}
