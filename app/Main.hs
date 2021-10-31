module Main where

import System.IO
import qualified Network.Socket as N
import Lib
import Control.Monad (forever)
import Debug.Trace (putTraceMsg)

twitchURL = "irc.chat.twitch.tv" :: String
twitchPort = 6667 :: N.PortNumber
twitchChannel = "rafiusky" :: String
userNick = "rafiuskybot" :: String
userOAuth = "oauth:" :: String

main :: IO ()
main = do
  h <- connectTo twitchURL twitchPort
  write h "PASS" userOAuth
  write h "NICK" userNick
  write h "JOIN" "#lajurubeba"
  listen h

connectTo :: N.HostName -> N.PortNumber -> IO Handle
connectTo host port = do
    addr : _ <- N.getAddrInfo Nothing (Just host) (Just (show port))
    sock <- N.socket (N.addrFamily addr) (N.addrSocketType addr) (N.addrProtocol addr)
    N.connect sock (N.addrAddress addr)
    N.socketToHandle sock ReadWriteMode

-- Write message into IRC server
write :: Handle -> String -> String -> IO ()
write h cmd args = do
  let msg = cmd ++ " " ++ args ++ "\r\n"
  hPutStr h msg
  putStr ("> " ++ msg)

-- Process each line of the IRC
listen :: Handle -> IO ()
listen h = forever $ do
    line <- hGetLine h 
    putStrLn line
  where
    forever :: IO () -> IO ()
    forever a = do a; forever a
