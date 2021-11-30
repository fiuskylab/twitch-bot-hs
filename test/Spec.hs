import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)
import Message

userMessage = ":sender!sender@sender.tmi.twitch.tv PRIVMSG #channel :!hello" :: String

main :: IO ()
main = hspec $ do
  describe "Message.parseLine" $ do
    it "parse a user message line" $ do
      parseLine userMessage `shouldBe` MessageData{
                            sender="sender"
                            ,channel="channel"
                            ,message="!hello"}
