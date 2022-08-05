{-# LANGUAGE FlexibleContexts #-}

module Lib
  ( run,
    transform,
    Preferences (..),
  )
where

import Control.Monad.Reader (MonadReader (..), asks, runReader)
import Text.HTML.TagSoup

newtype Preferences = Preferences
  { prefix :: String
  }

getPrefix :: MonadReader Preferences m => m String
getPrefix = asks prefix

filteredTags, filteredAttrs :: [String]
filteredTags = ["a", "meta", "link", "form"]
filteredAttrs = ["href", "src", "action"]

transformAttr :: MonadReader Preferences m => Attribute String -> m (Attribute String)
transformAttr (attr, val@('/' : _))
  | attr `elem` filteredAttrs =
    do
      prefix <- getPrefix
      pure (attr, prefix ++ val)
transformAttr a = pure a

transformTag :: MonadReader Preferences m => Tag String -> m (Tag String)
transformTag (TagOpen tag attrs)
  | tag `elem` filteredTags = TagOpen tag <$> mapM transformAttr attrs
  | otherwise = pure $ TagOpen tag attrs
transformTag a = pure a

transform :: MonadReader Preferences m => [Tag String] -> m [Tag String]
transform = mapM transformTag

run :: Preferences -> String -> String
run prefs = renderTags . flip runReader prefs . transform . parseTags
