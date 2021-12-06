module Message
  ( parseLine )
  where

import Data.List (isPrefixOf)

data MessageType = User 
                   | Ping 
                   | Nan 
                    deriving (Show, Eq)

data Message = Message { username :: String
                       , channel :: String
                       , message :: String
                       , msgType :: MessageType
                       } deriving (Show, Eq)

parseLine :: String -> Message
parseLine str = do
  if hasPrefix "PING" str then
    Message { username= ""
            , channel= ""
            , message= ""
            , msgType = Ping
            }
  else if hasPrefix "tmi.twitch" str then
    Message { username= ""
            , channel= ""
            , message= ""
            , msgType = Nan
            }
  else do
    let sender = getSender str
    let channel = findHashtag str
    let msg = getMessage str 0
    Message { username= sender
            , channel= channel
            , message= msg
            , msgType = User
            }

hasPrefix :: String -> String -> Bool
hasPrefix prefix x = prefix `isPrefixOf` x

--":sender!sender@sender.tmi.twitch.tv PRIVMSG #channel :!hello"

getSender :: String -> String
getSender "" = ""
getSender (x:xs) = do
  if x == ':' then
    getSender xs
  else if x == '!' then
    ""
  else
    x : getSender xs

findHashtag :: String -> String
findHashtag "" = ""
findHashtag (x:xs) = do
  if x == '#' then
    getChannel xs
  else
    findHashtag xs

getChannel :: String -> String
getChannel "" = ""
getChannel (x:xs) = do
  if x == ' ' then
    ""
  else
    x : getChannel xs

getMessage :: String -> Int -> String
getMessage (x:xs) n = do
  if n == 2 then
    xs
  else if x == ':' && n == 1 then
    xs
  else if x == ':' then
    getMessage xs (n + 1)
  else
    getMessage xs n
