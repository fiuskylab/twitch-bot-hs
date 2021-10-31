module Main where

import System.IO
import qualified Network.Socket as N
import Lib

twitchURL = "irc.chat.twitch.tv" :: String
twitchPort = 6667 :: N.PortNumber

main :: IO ()
main = do
  h <- connectTo twitchURL twitchPort
  t <- hGetContents h
  hSetBuffering stdout NoBuffering
  print t

connectTo :: N.HostName -> N.PortNumber -> IO Handle
connectTo host port = do
  addr : _ <- N.getAddrInfo Nothing (Just host) (Just (show port))
  sock <- N.socket (N.addrFamily addr) (N.addrSocketType addr) (N.addrProtocol addr)
  N.connect sock (N.addrAddress addr)
  N.socketToHandle sock ReadWriteMode
