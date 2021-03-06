module Main where

import Dovin.V2
import Dovin.Prelude
import Dovin.Monad

import qualified MTGTC

import System.Environment (getArgs)
import System.Exit (exitFailure, exitSuccess)

main = do
  (tape:_) <- getArgs

  let (e, initialBoard, _) = runMonad emptyBoard (MTGTC.setup tape)
  putStrLn . myFormatter $ initialBoard
  _ <- foldM runCycle initialBoard [1..]
  putStrLn "Done"

fixupFinalBoard = do
  forCards (matchAttribute MTGTC.assassin) $
    modifyCard cardStrengthModifier (mkStrength (-2, -2) <>)

runCycle :: Board -> Int -> IO Board
runCycle board n = do
  let (e, newBoard, log) = runMonad board (MTGTC.stepCompute n)

  case e of
    Left "won game" -> do
      let (e, finalBoard, log) = runMonad newBoard fixupFinalBoard
      putStrLn ""
      putStrLn . MTGTC.tapeFormatter2 $ finalBoard
      exitSuccess
    Left x -> putStrLn x >> exitFailure
    Right _ -> do
      putStrLn . myFormatter $ newBoard
    --  putStrLn . myFormatter $ newBoard
    --  forM_ log $ \step -> do
    --    putStr $ show (view stepNumber step) <> ". "
    --    putStr $ view stepLabel step
    --    putStrLn . myFormatter . view stepState $ step
      return newBoard

myFormatter =
     MTGTC.stateFormatter
  <> MTGTC.tapeFormatter2
    -- <> cardFormatter "tape" (MTGTC.matchAny (map matchAttribute MTGTC.tapeTypes))
