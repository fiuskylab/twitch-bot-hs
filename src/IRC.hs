-- Defining the IRC module
-- to handle every action related
-- to the IRC
module IRC 
  ( connectTo,
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


