module GHCiParser (
        ensureNoNewLine,
        parseErrors
    ) where

import Data.Text (Text)
import qualified Data.Text as T

ensureNoNewLine :: Text -> Text
ensureNoNewLine xs | T.last xs == '\n' = T.init xs
                   | otherwise         = xs

-- Take the interactive output and make it a little more JavaScript friendly.
-- Return a tuple of (position, position, details)
parseErrors :: String -> [String]
parseErrors str' = go str' "" "" 0
  where
    -- <interactive>:1:1:
    go :: String -> String -> String -> Int -> [String]
    go rest first second 3 = [first, second, rest]

    go (s:str) first second seen =
      if s == ':'
        then go str first second (seen + 1)
        else
          case seen of
            1 -> go str (first ++ [s]) second seen
            2 -> go str first (second ++ [s]) seen
            _ -> go str first second seen

    go [] first second _ = [first, second]

