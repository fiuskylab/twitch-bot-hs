-- Defining the IRC module
-- to handle every action related
-- to the IRC
module IRC 
  ( connectTo,
    write,
    listen,
  ) where

import System.IO
import qualified Network.Socket as N -- network

-- Setting IRC connection
connectTo :: N.HostName -> N.PortNumber -> IO Handle
connectTo host port = do
  addr  : _ <- N.getAddrInfo Nothing (Just host) (Just (show port))
  sock <- N.socket (N.addrFamily addr) (N.addrSocketType addr) (N.addrProtocol addr)
  N.connect sock (N.addrAddress addr)
  N.socketToHandle sock ReadWriteMode


--    :: Our Socket -> The Command -> The Message
write :: Handle -> String -> String -> IO ()
write h cmd arg = do
  let msg = cmd ++ " " ++ arg ++ "\r\n"
  hPutStr h msg           -- Send message
  putStr ("> " ++ msg)    -- Show sent message

--     :: Our Socket
listen :: Handle -> IO ()
listen h = forever $ do
    line <- hGetLine h
    putStrLn line
  where
    forever :: IO () -> IO ()
    forever a = do a; forever a
