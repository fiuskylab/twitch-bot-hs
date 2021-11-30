module Message where

data MessageType = USER | PING

-- Message data
data MessageData = MessageData { 
  sender :: String , 
  channel :: String ,
  message :: String
} deriving (Eq, Show) 

parseLine :: String -> MessageData
parseLine str = do
  let sender = getSender str
  let channel = findHashtag str
  let msg = getMessage str 0
  MessageData{
  sender= sender,
  channel= channel,
  message= msg}

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
  
--countTwo :: Int -> Int
--count 0 = 1
--count x = x + 1















