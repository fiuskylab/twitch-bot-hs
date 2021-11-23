module Main where

import System.IO
import qualified Network.Socket as N
import Lib
import Control.Monad (forever)
import Debug.Trace (putTraceMsg)
import Configuration.Dotenv (loadFile, defaultConfig)
import qualified System.Environment as System

twitchURL = "irc.chat.twitch.tv" :: String
twitchPort = 6667 :: N.PortNumber
twitchChannelIO = System.getEnv "TWITCH_CHANNEL" :: IO String
userNickIO = System.getEnv "BOT_USERNAME" :: IO String
userOAuthIO = System.getEnv "BOT_OAUTH_TOKEN" :: IO String

main :: IO ()
main = do
  loadFile defaultConfig
  h <- connectTo twitchURL twitchPort
  userOAuth <- userOAuthIO
  userNick <- userNickIO
  write h "PASS" userOAuth
  write h "NICK" userNick
  write h "JOIN" "#rafiusky"
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

-- Message data
data Message = Message { 
  sender :: String , 
  channel :: String ,
  message :: String
}

-- Process each line of the IRC
listen :: Handle -> IO ()
listen h = forever $ do
    line <- hGetLine h 
    putStrLn line
  where
    forever :: IO () -> IO ()
    forever a = do a; forever a
