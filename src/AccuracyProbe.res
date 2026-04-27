let asciiBaseline = () => {
  let label = "ascii baseline"
  JsError.throwWithMessage("AccuracyProbe.res ascii line check: " ++ label)
}

let unicodeColumn = () => { let koreanValue = "가나다"; JsError.throwWithMessage("AccuracyProbe.res unicode column check: " ++ koreanValue) }

let emojiColumn = () => { let planet = "🌏"; let marker = "after emoji"; JsError.throwWithMessage("AccuracyProbe.res emoji column check: " ++ planet ++ " " ++ marker) }

let multipleExpressions = () => {
  let left = "first"
  let right = "second"
  let combined = left ++ " / " ++ right
  JsError.throwWithMessage("AccuracyProbe.res multi-line check: " ++ combined)
}
