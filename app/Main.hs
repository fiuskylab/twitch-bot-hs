module Main where

import Lib
import qualified Network.Socket as N -- network
import GHC.IO.Handle.Text (hGetContents)
import System.IO (hGetContents, hSetBuffering, stdout, BufferMode (NoBuffering))
import qualified IRC

-- IRC URL
twitchIRC     = "irc.chat.twitch.tv" :: String
-- IRC Port
twitchIRCPort = 6667 :: N.PortNumber
-- Bot's Twitch username
botUsername   = "rafiuskybot" :: String
-- Bot's OAuth token
botOAuthToken = "" :: String
-- Twitch channel to listen the chat
twitchChannel = "rafiusky" :: String

main :: IO ()
main = do
  h <- IRC.connectTo twitchIRC twitchIRCPort
  IRC.write h "PASS" botOAuthToken
  IRC.write h "NICK" botUsername
  IRC.write h "JOIN" ("#" ++ twitchChannel)
  IRC.listen h

