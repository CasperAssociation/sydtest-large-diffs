{-# LANGUAGE OverloadedStrings #-}

module Spec.LargeDiffsSpec (spec) where

import Data.Text (pack)
import Test.Syd (Spec, describe, it, shouldBe)

spec :: Spec
spec =
  describe "large diffs" $ do
    it "shows a large diff in a test failure (A)" $
      pack (replicate 20000 'a') `shouldBe` "B"

    it "shows a large diff in a test failure (B)" $
      "A" `shouldBe` pack (replicate 20000 'b')
